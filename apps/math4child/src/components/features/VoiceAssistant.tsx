"use client"

import { useState, useEffect, useCallback, useRef } from 'react'

interface VoiceAssistantProps {
  mathLevel: number
  currentProblem?: any
  userPerformance?: any
  onHint: (hint: string, type: 'visual' | 'audio' | 'interactive') => void
  onEncouragement: (message: string, intensity: 'low' | 'medium' | 'high') => void
  onAnswer?: (answer: string, confidence: number) => void
  language?: string
  enableEmotionalIA?: boolean
}

interface VoiceState {
  isListening: boolean
  isSpeaking: boolean
  isProcessing: boolean
  currentPhrase: string
  recognitionConfidence: number
  emotionalState: EmotionalState
  conversationHistory: ConversationEntry[]
}

interface EmotionalState {
  supportLevel: 'low' | 'medium' | 'high'
  encouragementNeeded: boolean
  frustrationDetected: boolean
  confidenceLevel: number
  engagementLevel: number
}

interface ConversationEntry {
  timestamp: number
  speaker: 'user' | 'assistant'
  message: string
  emotion?: string
  intent?: string
  response?: string
}

interface VoiceAnalytics {
  totalInteractions: number
  averageConfidence: number
  successfulRecognitions: number
  voiceCommandsUsed: string[]
  emotionalAnalysis: {
    positiveInteractions: number
    neutralInteractions: number
    negativeInteractions: number
  }
}

export function VoiceAssistantAdvanced({ 
  mathLevel, 
  currentProblem, 
  userPerformance, 
  onHint, 
  onEncouragement,
  onAnswer,
  language = 'fr',
  enableEmotionalIA = true
}: VoiceAssistantProps) {
  const [voiceState, setVoiceState] = useState<VoiceState>({
    isListening: false,
    isSpeaking: false,
    isProcessing: false,
    currentPhrase: '',
    recognitionConfidence: 0,
    emotionalState: {
      supportLevel: 'medium',
      encouragementNeeded: false,
      frustrationDetected: false,
      confidenceLevel: 75,
      engagementLevel: 80
    },
    conversationHistory: []
  })

  const [voiceEnabled, setVoiceEnabled] = useState(false)
  const [assistantPersonality, setAssistantPersonality] = useState<'encouraging' | 'patient' | 'enthusiastic' | 'adaptive'>('adaptive')
  const [voiceSettings, setVoiceSettings] = useState({
    speechRate: 1.0,
    pitch: 1.0,
    volume: 0.8,
    autoResponse: true,
    emotionalAnalysis: true,
    contextAwareness: true
  })
  const [analytics, setAnalytics] = useState<VoiceAnalytics>({
    totalInteractions: 0,
    averageConfidence: 0,
    successfulRecognitions: 0,
    voiceCommandsUsed: [],
    emotionalAnalysis: {
      positiveInteractions: 0,
      neutralInteractions: 0,
      negativeInteractions: 0
    }
  })

  const recognitionRef = useRef<any>(null)
  const synthesisRef = useRef<any>(null)
  const timeoutRef = useRef<NodeJS.Timeout>()

  // Phrases et réponses intelligentes
  const intelligentResponses = {
    fr: {
      greetings: [
        "Salut ! Je suis ton assistant mathématique IA. Comment puis-je t'aider ?",
        "Bonjour ! Prêt pour une aventure mathématique extraordinaire ?",
        "Coucou ! Je suis là pour rendre les maths super amusantes !"
      ],
      hints: {
        addition: [
          "Pour additionner, imagine que tu comptes tes jouets préférés !",
          "Essaie de compter sur tes doigts ou dessine des petits points.",
          "L'addition, c'est comme rassembler des amis dans un groupe !"
        ],
        subtraction: [
          "Pour soustraire, imagine que tu donnes des bonbons à tes amis.",
          "Compte à rebours comme pour un lancement de fusée !",
          "La soustraction, c'est comme retirer des objets d'une boîte."
        ],
        multiplication: [
          "La multiplication, c'est comme compter par groupes !",
          "Imagine des rangées de cookies dans un plateau.",
          "C'est une addition rapide du même nombre plusieurs fois !"
        ],
        division: [
          "La division, c'est partager équitablement entre amis !",
          "Imagine que tu distribues des cartes à jouer.",
          "C'est comme faire des groupes égaux avec tes jouets."
        ]
      },
      encouragements: {
        low: [
          "Tu progresses bien, continue comme ça !",
          "Chaque erreur nous apprend quelque chose de nouveau.",
          "Tu es sur la bonne voie, ne lâche pas !"
        ],
        medium: [
          "Excellent travail ! Tu deviens vraiment fort !",
          "Bravo ! Tes efforts portent leurs fruits !",
          "Super ! Tu maîtrises de mieux en mieux !"
        ],
        high: [
          "Extraordinaire ! Tu es un vrai génie des maths !",
          "Fantastique ! Tu m'impressionnes vraiment !",
          "Incroyable ! Tu es devenu un expert !"
        ]
      },
      emotions: {
        frustrated: [
          "Je vois que c'est un peu difficile. Prenons une pause ou essayons autrement ?",
          "Pas de stress ! Même les grands mathématiciens ont besoin de temps.",
          "Respirons ensemble. Les maths deviennent plus faciles quand on est détendu."
        ],
        confused: [
          "Je sens que tu as besoin d'une explication différente. Essayons avec des exemples !",
          "Pas de problème ! Décomposons ça en petites étapes plus simples.",
          "C'est normal d'être confus. Reprenons tranquillement ensemble."
        ],
        excited: [
          "J'adore ton enthousiasme ! Continuons sur cette lancée !",
          "Ton énergie est contagieuse ! C'est parti pour la suite !",
          "Super énergie ! Les maths sont encore plus amusantes quand on s'amuse !"
        ]
      }
    }
  }

  // Commandes vocales avancées
  const voiceCommands = {
    help: ['aide', 'help', 'au secours', 'je ne comprends pas'],
    hint: ['indice', 'hint', 'peux-tu m\'aider', 'donne-moi un indice'],
    repeat: ['répète', 'repeat', 'encore', 'redis'],
    next: ['suivant', 'next', 'question suivante', 'continue'],
    explain: ['explique', 'explain', 'comment', 'pourquoi'],
    answer: ['la réponse est', 'c\'est', 'je pense que c\'est', 'réponse'],
    encouragement: ['encourage-moi', 'bravo', 'félicitations', 'motivation']
  }

  // Initialisation de la reconnaissance vocale
  useEffect(() => {
    if (typeof window !== 'undefined' && 'webkitSpeechRecognition' in window) {
      const SpeechRecognition = (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition
      recognitionRef.current = new SpeechRecognition()
      
      recognitionRef.current.continuous = true
      recognitionRef.current.interimResults = true
      recognitionRef.current.lang = language === 'fr' ? 'fr-FR' : 'en-US'
      
      recognitionRef.current.onstart = () => {
        setVoiceState(prev => ({ ...prev, isListening: true, isProcessing: false }))
      }
      
      recognitionRef.current.onresult = handleSpeechResult
      recognitionRef.current.onerror = handleSpeechError
      recognitionRef.current.onend = () => {
        setVoiceState(prev => ({ ...prev, isListening: false }))
      }
    }

    // Initialisation de la synthèse vocale
    if (typeof window !== 'undefined' && 'speechSynthesis' in window) {
      synthesisRef.current = window.speechSynthesis
    }

    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current)
      }
    }
  }, [language])

  const handleSpeechResult = useCallback((event: any) => {
    const transcript = event.results[event.results.length - 1][0].transcript.toLowerCase()
    const confidence = event.results[event.results.length - 1][0].confidence
    
    setVoiceState(prev => ({
      ...prev,
      currentPhrase: transcript,
      recognitionConfidence: confidence * 100
    }))

    if (event.results[event.results.length - 1].isFinal) {
      processVoiceCommand(transcript, confidence)
    }
  }, [])

  const handleSpeechError = useCallback((event: any) => {
    console.error('Erreur reconnaissance vocale:', event.error)
    setVoiceState(prev => ({ ...prev, isListening: false, isProcessing: false }))
  }, [])

  const processVoiceCommand = useCallback((transcript: string, confidence: number) => {
    setVoiceState(prev => ({ ...prev, isProcessing: true }))
    
    // Analyse d'intention avec IA
    const intent = analyzeIntent(transcript)
    const emotion = analyzeEmotion(transcript)
    
    // Enregistrer dans l'historique
    const conversationEntry: ConversationEntry = {
      timestamp: Date.now(),
      speaker: 'user',
      message: transcript,
      emotion,
      intent
    }
    
    setVoiceState(prev => ({
      ...prev,
      conversationHistory: [...prev.conversationHistory, conversationEntry]
    }))
    
    // Traitement intelligent de la commande
    handleIntelligentResponse(transcript, intent, emotion, confidence)
    
    // Mise à jour analytics
    updateAnalytics(transcript, confidence, intent)
    
    setTimeout(() => {
      setVoiceState(prev => ({ ...prev, isProcessing: false }))
    }, 1000)
  }, [])

  const analyzeIntent = (transcript: string): string => {
    const lowerTranscript = transcript.toLowerCase()
    
    for (const [intent, keywords] of Object.entries(voiceCommands)) {
      if (keywords.some(keyword => lowerTranscript.includes(keyword))) {
        return intent
      }
    }
    
    // Analyse des nombres pour les réponses
    const numberMatch = lowerTranscript.match(/\b(\d+)\b/)
    if (numberMatch) {
      return 'answer'
    }
    
    return 'general'
  }

  const analyzeEmotion = (transcript: string): string => {
    const lowerTranscript = transcript.toLowerCase()
    
    const emotionKeywords = {
      frustrated: ['difficile', 'compliqué', 'ne comprends pas', 'énervé', 'marre'],
      excited: ['super', 'génial', 'cool', 'awesome', 'fantastique', 'j\'adore'],
      confused: ['quoi', 'comment', 'pourquoi', 'hein', 'confus'],
      confident: ['facile', 'simple', 'sûr', 'certain', 'évidemment']
    }
    
    for (const [emotion, keywords] of Object.entries(emotionKeywords)) {
      if (keywords.some(keyword => lowerTranscript.includes(keyword))) {
        return emotion
      }
    }
    
    return 'neutral'
  }

  const handleIntelligentResponse = (transcript: string, intent: string, emotion: string, confidence: number) => {
    let response = ''
    let responseType: 'visual' | 'audio' | 'interactive' = 'audio'
    
    // Adaptation basée sur l'émotion détectée
    if (enableEmotionalIA) {
      updateEmotionalState(emotion, confidence)
    }
    
    switch (intent) {
      case 'help':
      case 'hint':
        response = generateContextualHint()
        responseType = confidence > 0.8 ? 'interactive' : 'visual'
        onHint(response, responseType)
        break
        
      case 'encouragement':
        response = generateEncouragement()
        onEncouragement(response, 'high')
        break
        
      case 'answer':
        const numberMatch = transcript.match(/\b(\d+)\b/)
        if (numberMatch && onAnswer) {
          const answer = numberMatch[1]
          onAnswer(answer, confidence * 100)
          response = `J'ai entendu "${answer}". Est-ce ta réponse finale ?`
        }
        break
        
      case 'explain':
        response = generateExplanation()
        responseType = 'interactive'
        break
        
      default:
        response = generateAdaptiveResponse(emotion, transcript)
    }
    
    if (response) {
      speak(response)
    }
  }

  const updateEmotionalState = (emotion: string, confidence: number) => {
    setVoiceState(prev => ({
      ...prev,
      emotionalState: {
        ...prev.emotionalState,
        encouragementNeeded: emotion === 'frustrated' || emotion === 'confused',
        frustrationDetected: emotion === 'frustrated',
        confidenceLevel: emotion === 'confident' ? Math.min(100, prev.emotionalState.confidenceLevel + 10) :
                        emotion === 'frustrated' ? Math.max(0, prev.emotionalState.confidenceLevel - 15) :
                        prev.emotionalState.confidenceLevel,
        engagementLevel: emotion === 'excited' ? Math.min(100, prev.emotionalState.engagementLevel + 15) :
                        emotion === 'frustrated' ? Math.max(0, prev.emotionalState.engagementLevel - 10) :
                        prev.emotionalState.engagementLevel
      }
    }))
  }

  const generateContextualHint = (): string => {
    if (!currentProblem) {
      return "Pose-moi une question sur les mathématiques et je t'aiderai !"
    }
    
    const operation = currentProblem.operation || 'addition'
    const hints = intelligentResponses.fr.hints[operation as keyof typeof intelligentResponses.fr.hints] || []
    
    if (hints.length === 0) {
      return "Essaie de décomposer le problème en étapes plus petites !"
    }
    
    return hints[Math.floor(Math.random() * hints.length)]
  }

  const generateEncouragement = (): string => {
    const level = voiceState.emotionalState.frustrationDetected ? 'low' :
                  voiceState.emotionalState.confidenceLevel > 80 ? 'high' : 'medium'
    
    const encouragements = intelligentResponses.fr.encouragements[level]
    return encouragements[Math.floor(Math.random() * encouragements.length)]
  }

  const generateExplanation = (): string => {
    if (!currentProblem) {
      return "Explique-moi quel concept mathématique tu veux comprendre !"
    }
    
    const { num1, num2, operation } = currentProblem
    
    switch (operation) {
      case '+':
        return `Pour additionner ${num1} et ${num2}, tu peux compter ${num1} objets, puis ajouter ${num2} de plus. Cela fait ${num1 + num2} au total !`
      case '-':
        return `Pour soustraire ${num2} de ${num1}, imagine que tu as ${num1} objets et que tu en enlèves ${num2}. Il te reste ${num1 - num2} !`
      case '×':
        return `Multiplier ${num1} par ${num2}, c'est comme avoir ${num1} groupes de ${num2} objets chacun. Au total : ${num1 * num2} !`
      case '÷':
        return `Diviser ${num1} par ${num2}, c'est partager ${num1} objets en ${num2} groupes égaux. Chaque groupe aura ${Math.floor(num1 / num2)} objets !`
      default:
        return "Je peux t'expliquer l'addition, la soustraction, la multiplication ou la division !"
    }
  }

  const generateAdaptiveResponse = (emotion: string, transcript: string): string => {
    if (emotion === 'frustrated') {
      const responses = intelligentResponses.fr.emotions.frustrated
      return responses[Math.floor(Math.random() * responses.length)]
    }
    
    if (emotion === 'excited') {
      const responses = intelligentResponses.fr.emotions.excited
      return responses[Math.floor(Math.random() * responses.length)]
    }
    
    if (emotion === 'confused') {
      const responses = intelligentResponses.fr.emotions.confused
      return responses[Math.floor(Math.random() * responses.length)]
    }
    
    return "Je t'écoute ! Comment puis-je t'aider avec les mathématiques ?"
  }

  const speak = useCallback((text: string) => {
    if (!voiceEnabled || !synthesisRef.current) return
    
    setVoiceState(prev => ({ ...prev, isSpeaking: true }))
    
    const utterance = new SpeechSynthesisUtterance(text)
    utterance.lang = language === 'fr' ? 'fr-FR' : 'en-US'
    utterance.rate = voiceSettings.speechRate
    utterance.pitch = voiceSettings.pitch
    utterance.volume = voiceSettings.volume
    
    utterance.onend = () => {
      setVoiceState(prev => ({ ...prev, isSpeaking: false }))
    }
    
    utterance.onerror = (error) => {
      console.error('Erreur synthèse vocale:', error)
      setVoiceState(prev => ({ ...prev, isSpeaking: false }))
    }
    
    synthesisRef.current.speak(utterance)
    
    // Enregistrer dans l'historique
    const responseEntry: ConversationEntry = {
      timestamp: Date.now(),
      speaker: 'assistant',
      message: text
    }
    
    setVoiceState(prev => ({
      ...prev,
      conversationHistory: [...prev.conversationHistory, responseEntry]
    }))
  }, [voiceEnabled, language, voiceSettings])

  const toggleListening = () => {
    if (!recognitionRef.current) {
      alert('Reconnaissance vocale non supportée dans ce navigateur')
      return
    }
    
    if (voiceState.isListening) {
      recognitionRef.current.stop()
    } else {
      recognitionRef.current.start()
    }
  }

  const toggleVoice = () => {
    const newVoiceEnabled = !voiceEnabled
    setVoiceEnabled(newVoiceEnabled)
    
    if (newVoiceEnabled) {
      const greeting = intelligentResponses.fr.greetings[Math.floor(Math.random() * intelligentResponses.fr.greetings.length)]
      speak(greeting)
    } else {
      if (synthesisRef.current) {
        synthesisRef.current.cancel()
      }
    }
  }

  const updateAnalytics = (transcript: string, confidence: number, intent: string) => {
    setAnalytics(prev => {
      const newAnalytics = {
        ...prev,
        totalInteractions: prev.totalInteractions + 1,
        averageConfidence: (prev.averageConfidence * prev.totalInteractions + confidence * 100) / (prev.totalInteractions + 1),
        successfulRecognitions: confidence > 0.7 ? prev.successfulRecognitions + 1 : prev.successfulRecognitions,
        voiceCommandsUsed: [...prev.voiceCommandsUsed, intent]
      }
      
      // Analyse émotionnelle
      const emotion = analyzeEmotion(transcript)
      if (emotion === 'excited' || emotion === 'confident') {
        newAnalytics.emotionalAnalysis.positiveInteractions++
      } else if (emotion === 'frustrated') {
        newAnalytics.emotionalAnalysis.negativeInteractions++
      } else {
        newAnalytics.emotionalAnalysis.neutralInteractions++
      }
      
      return newAnalytics
    })
  }

  return (
    <div className="bg-gradient-to-br from-purple-600 via-pink-600 to-red-500 rounded-2xl p-6 text-white shadow-2xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h3 className="text-xl font-bold flex items-center gap-2">
            <span className="text-2xl">🤖</span>
            Assistant Vocal IA Avancé
          </h3>
          <p className="text-purple-100 text-sm">Tuteur personnel avec intelligence émotionnelle</p>
        </div>
        
        <button
          onClick={toggleVoice}
          className={`px-4 py-2 rounded-lg font-medium transition-all duration-300 transform hover:scale-105 ${
            voiceEnabled 
              ? 'bg-white text-purple-600 shadow-lg' 
              : 'bg-purple-500 hover:bg-purple-400 text-white'
          }`}
        >
          {voiceEnabled ? '🔊 Activé' : '🔇 Activer'}
        </button>
      </div>

      {voiceEnabled && (
        <>
          {/* Configuration de personnalité */}
          <div className="mb-4">
            <label className="text-sm font-medium text-purple-100 mb-2 block">
              Personnalité IA :
            </label>
            <div className="grid grid-cols-4 gap-2">
              {[
                { id: 'encouraging', icon: '😊', label: 'Encourageant' },
                { id: 'patient', icon: '🧘', label: 'Patient' },
                { id: 'enthusiastic', icon: '🎉', label: 'Enthousiaste' },
                { id: 'adaptive', icon: '🧠', label: 'Adaptatif' }
              ].map((personality) => (
                <button
                  key={personality.id}
                  onClick={() => setAssistantPersonality(personality.id as any)}
                  className={`px-2 py-2 rounded-lg text-xs font-medium transition-all duration-300 ${
                    assistantPersonality === personality.id
                      ? 'bg-white text-purple-600 transform scale-105'
                      : 'bg-purple-500 hover:bg-purple-400 text-white'
                  }`}
                >
                  <div className="text-lg">{personality.icon}</div>
                  <div className="text-xs">{personality.label}</div>
                </button>
              ))}
            </div>
          </div>

          {/* État émotionnel et engagement */}
          {enableEmotionalIA && (
            <div className="bg-white bg-opacity-20 rounded-lg p-3 mb-4">
              <div className="text-sm font-bold mb-2">🧠 État Émotionnel IA</div>
              <div className="grid grid-cols-2 gap-3 text-xs">
                <div>
                  <div className="flex justify-between">
                    <span>Confiance</span>
                    <span>{voiceState.emotionalState.confidenceLevel}%</span>
                  </div>
                  <div className="w-full bg-purple-300 rounded-full h-1">
                    <div 
                      className="h-1 bg-white rounded-full transition-all duration-500"
                      style={{ width: `${voiceState.emotionalState.confidenceLevel}%` }}
                    />
                  </div>
                </div>
                <div>
                  <div className="flex justify-between">
                    <span>Engagement</span>
                    <span>{voiceState.emotionalState.engagementLevel}%</span>
                  </div>
                  <div className="w-full bg-purple-300 rounded-full h-1">
                    <div 
                      className="h-1 bg-white rounded-full transition-all duration-500"
                      style={{ width: `${voiceState.emotionalState.engagementLevel}%` }}
                    />
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Interface vocale principale */}
          <div className="mb-4">
            <div className="flex items-center gap-2 mb-3">
              <button
                onClick={toggleListening}
                disabled={voiceState.isSpeaking || voiceState.isProcessing}
                className={`flex-1 py-3 rounded-lg font-bold transition-all duration-300 transform hover:scale-105 ${
                  voiceState.isListening
                    ? 'bg-red-500 hover:bg-red-600 animate-pulse shadow-lg shadow-red-500/50'
                    : 'bg-white text-purple-600 hover:bg-purple-50 shadow-lg'
                } ${(voiceState.isSpeaking || voiceState.isProcessing) ? 'opacity-50 cursor-not-allowed' : ''}`}
              >
                {voiceState.isListening ? (
                  <div className="flex items-center justify-center gap-2">
                    <span className="text-xl">🎙️</span>
                    <span>J'écoute...</span>
                    <div className="flex gap-1">
                      {[...Array(3)].map((_, i) => (
                        <div
                          key={i}
                          className="w-1 h-4 bg-white rounded-full animate-pulse"
                          style={{ animationDelay: `${i * 0.2}s` }}
                        />
                      ))}
                    </div>
                  </div>
                ) : (
                  <div className="flex items-center justify-center gap-2">
                    <span className="text-xl">🎤</span>
                    <span>Parler avec l'IA</span>
                  </div>
                )}
              </button>
            </div>
            
            {/* Phrase en cours de reconnaissance */}
            {voiceState.currentPhrase && (
              <div className="bg-white bg-opacity-20 rounded-lg p-2 mb-2">
                <div className="text-xs text-purple-100 mb-1">Reconnaissance en cours :</div>
                <div className="text-sm font-medium">"{voiceState.currentPhrase}"</div>
                {voiceState.recognitionConfidence > 0 && (
                  <div className="text-xs text-purple-200 mt-1">
                    Confiance: {Math.round(voiceState.recognitionConfidence)}%
                  </div>
                )}
              </div>
            )}
          </div>

          {/* État et indicateurs */}
          <div className="bg-white bg-opacity-20 rounded-lg p-3 mb-4">
            <div className="flex items-center gap-2 mb-2">
              <span className={`w-3 h-3 rounded-full ${
                voiceState.isSpeaking ? 'bg-green-400 animate-pulse' : 
                voiceState.isListening ? 'bg-yellow-400 animate-pulse' : 
                voiceState.isProcessing ? 'bg-blue-400 animate-pulse' :
                'bg-gray-400'
              }`}></span>
              <span className="text-sm font-medium">
                {voiceState.isSpeaking ? 'IA en train de parler...' :
                 voiceState.isListening ? 'En écoute active...' :
                 voiceState.isProcessing ? 'Analyse IA en cours...' :
                 'Prêt à converser'}
              </span>
            </div>
            
            {/* Dernière interaction */}
            {voiceState.conversationHistory.length > 0 && (
              <div className="text-xs text-purple-100">
                <div className="font-medium">Dernière interaction :</div>
                <div className="italic">
                  "{voiceState.conversationHistory[voiceState.conversationHistory.length - 1].message.substring(0, 50)}..."
                </div>
              </div>
            )}
          </div>

          {/* Boutons d'actions rapides */}
          <div className="grid grid-cols-2 gap-2 mb-4">
            <button
              onClick={() => speak(generateContextualHint())}
              disabled={voiceState.isSpeaking}
              className="bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 text-white px-3 py-2 rounded-lg text-sm font-medium transition-colors"
            >
              💡 Indice IA
            </button>
            <button
              onClick={() => speak(generateEncouragement())}
              disabled={voiceState.isSpeaking}
              className="bg-green-500 hover:bg-green-600 disabled:bg-green-300 text-white px-3 py-2 rounded-lg text-sm font-medium transition-colors"
            >
              🎉 Motivation
            </button>
            <button
              onClick={() => speak(generateExplanation())}
              disabled={voiceState.isSpeaking}
              className="bg-orange-500 hover:bg-orange-600 disabled:bg-orange-300 text-white px-3 py-2 rounded-lg text-sm font-medium transition-colors"
            >
              📚 Explication
            </button>
            <button
              onClick={() => {
                if (synthesisRef.current) {
                  synthesisRef.current.cancel()
                }
                setVoiceState(prev => ({ ...prev, isSpeaking: false }))
              }}
              disabled={!voiceState.isSpeaking}
              className="bg-red-500 hover:bg-red-600 disabled:bg-red-300 text-white px-3 py-2 rounded-lg text-sm font-medium transition-colors"
            >
              🛑 Stop
            </button>
          </div>

          {/* Analytics avancées */}
          <div className="bg-gray-800 bg-opacity-30 rounded-lg p-3">
            <div className="text-sm font-bold mb-2">📊 Analytics Vocales</div>
            <div className="grid grid-cols-2 gap-3 text-xs">
              <div>
                <div className="text-purple-200">Interactions totales</div>
                <div className="font-bold">{analytics.totalInteractions}</div>
              </div>
              <div>
                <div className="text-purple-200">Confiance moyenne</div>
                <div className="font-bold">{Math.round(analytics.averageConfidence)}%</div>
              </div>
              <div>
                <div className="text-purple-200">Reconnaissances réussies</div>
                <div className="font-bold">{analytics.successfulRecognitions}</div>
              </div>
              <div>
                <div className="text-purple-200">Historique</div>
                <div className="font-bold">{voiceState.conversationHistory.length}</div>
              </div>
            </div>
            
            {/* Analyse émotionnelle */}
            <div className="mt-3 pt-2 border-t border-purple-300">
              <div className="text-xs text-purple-200 mb-1">Analyse Émotionnelle :</div>
              <div className="flex gap-2 text-xs">
                <span className="bg-green-500 px-2 py-1 rounded">
                  😊 {analytics.emotionalAnalysis.positiveInteractions}
                </span>
                <span className="bg-gray-500 px-2 py-1 rounded">
                  😐 {analytics.emotionalAnalysis.neutralInteractions}
                </span>
                <span className="bg-red-500 px-2 py-1 rounded">
                  😤 {analytics.emotionalAnalysis.negativeInteractions}
                </span>
              </div>
            </div>
          </div>
        </>
      )}
    </div>
  )
}
