"use client"

import React, { useState, useRef, useEffect, useCallback } from 'react'
import { Mic, MicOff, Volume2, VolumeX, Settings, Zap } from 'lucide-react'

interface VoiceMessage {
  id: string
  text: string
  type: 'user' | 'assistant'
  timestamp: number
  emotion?: string
  confidence?: number
}

interface VoiceAssistantProps {
  onVoiceCommand?: (command: string, confidence: number) => void
  currentQuestion?: string
  expectedAnswer?: number
  language?: string
  className?: string
}

export default function VoiceAssistantAdvanced({
  onVoiceCommand,
  currentQuestion = "",
  expectedAnswer,
  language = 'fr',
  className = ""
}: VoiceAssistantProps) {
  const [isListening, setIsListening] = useState(false)
  const [isSpeaking, setIsSpeaking] = useState(false)
  const [voiceEnabled, setVoiceEnabled] = useState(false)
  const [currentPhrase, setCurrentPhrase] = useState('')
  const [messages, setMessages] = useState<VoiceMessage[]>([])
  const [recognitionConfidence, setRecognitionConfidence] = useState(0)
  const [volumeLevel, setVolumeLevel] = useState(0)
  const [personality, setPersonality] = useState<'friendly' | 'enthusiastic' | 'patient'>('friendly')

  const recognitionRef = useRef<any>(null)
  const synthesisRef = useRef<SpeechSynthesis | null>(null)
  const volumeIntervalRef = useRef<NodeJS.Timeout | null>(null)

  // Personnalités de l'assistant IA
  const personalities = {
    friendly: {
      name: '😊 Amical',
      responses: {
        greeting: "Salut ! Je suis ton assistant vocal Math4Child. Comment puis-je t'aider aujourd'hui ?",
        help: "Pas de problème ! Je vais t'expliquer étape par étape.",
        correct: "Excellent ! Tu as trouvé la bonne réponse !",
        incorrect: "Ce n'est pas tout à fait ça, mais tu y es presque ! Essaie encore.",
        encouragement: "Tu fais des progrès fantastiques ! Continue comme ça !"
      }
    },
    enthusiastic: {
      name: '🚀 Enthousiaste', 
      responses: {
        greeting: "Wow ! C'est parti pour une aventure mathématique incroyable !",
        help: "Oh ! J'ai une super astuce pour toi ! Écoute bien...",
        correct: "FANTASTIQUE ! Tu es un vrai génie des maths !",
        incorrect: "Ooh, pas tout à fait ! Mais j'adore ton enthousiasme ! On recommence ?",
        encouragement: "Tu es en feu ! Tes progrès sont absolument incroyables !"
      }
    },
    patient: {
      name: '🧘‍♀️ Patient',
      responses: {
        greeting: "Bonjour. Je suis là pour t'accompagner tranquillement dans ton apprentissage.",
        help: "Prenons le temps qu'il faut. Voici une explication détaillée...",
        correct: "Très bien. Tu as pris ton temps et tu as réussi.",
        incorrect: "Ce n'est pas grave. Chaque erreur nous aide à mieux comprendre.",
        encouragement: "Chaque petit pas compte. Tu progresses à ton rythme."
      }
    }
  }

  // Commandes vocales reconnues
  const voiceCommands = {
    help: ['aide', 'help', 'au secours', 'je ne comprends pas', 'explique'],
    repeat: ['répète', 'repeat', 'encore', 'redis', 'peux-tu répéter'],
    answer: ['la réponse est', 'c\'est', 'je pense que', 'réponse'],
    next: ['suivant', 'next', 'question suivante', 'continue'],
    encouragement: ['encourage-moi', 'motivation', 'vas-y']
  }

  // Initialisation
  useEffect(() => {
    if (typeof window !== 'undefined') {
      // Vérifier support Web Speech API
      const speechSupported = 'speechSynthesis' in window && 'webkitSpeechRecognition' in window
      
      if (speechSupported) {
        synthesisRef.current = window.speechSynthesis
        initializeSpeechRecognition()
      }
    }
  }, [language])

  const initializeSpeechRecognition = () => {
    if (typeof window === 'undefined') return

    try {
      const SpeechRecognition = (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition
      recognitionRef.current = new SpeechRecognition()
      
      recognitionRef.current.continuous = true
      recognitionRef.current.interimResults = true
      recognitionRef.current.lang = language === 'fr' ? 'fr-FR' : 'en-US'
      
      recognitionRef.current.onstart = () => {
        setIsListening(true)
        startVolumeAnimation()
      }
      
      recognitionRef.current.onresult = handleSpeechResult
      recognitionRef.current.onerror = handleSpeechError
      recognitionRef.current.onend = () => {
        setIsListening(false)
        stopVolumeAnimation()
      }
    } catch (error) {
      console.error('Erreur initialisation reconnaissance vocale:', error)
    }
  }

  const handleSpeechResult = useCallback((event: any) => {
    const transcript = event.results[event.results.length - 1][0].transcript.toLowerCase()
    const confidence = event.results[event.results.length - 1][0].confidence
    
    setCurrentPhrase(transcript)
    setRecognitionConfidence(confidence * 100)

    if (event.results[event.results.length - 1].isFinal) {
      processVoiceCommand(transcript, confidence)
    }
  }, [])

  const handleSpeechError = useCallback((event: any) => {
    console.error('Erreur reconnaissance vocale:', event.error)
    setIsListening(false)
    
    const errorMessage = "Désolé, je n'ai pas bien entendu. Peux-tu répéter ?"
    addMessage(errorMessage, 'assistant', 'concerned')
    speak(errorMessage)
  }, [])

  const processVoiceCommand = (transcript: string, confidence: number) => {
    addMessage(transcript, 'user')
    
    // Analyser l'intention
    const intent = analyzeIntent(transcript)
    const emotion = analyzeEmotion(transcript)
    
    let response = ''
    
    switch (intent) {
      case 'help':
        response = personalities[personality].responses.help
        if (currentQuestion) {
          response += ` Pour ${currentQuestion}, pense aux étapes : d'abord identifie l'opération, puis calcule étape par étape.`
        }
        break
        
      case 'answer':
        const numberMatch = transcript.match(/\b(\d+)\b/)
        if (numberMatch && expectedAnswer !== undefined) {
          const userAnswer = parseInt(numberMatch[0])
          if (userAnswer === expectedAnswer) {
            response = personalities[personality].responses.correct
          } else {
            response = personalities[personality].responses.incorrect + ` La bonne réponse était ${expectedAnswer}.`
          }
        } else {
          response = "Je n'ai pas compris ton nombre. Peux-tu le répéter clairement ?"
        }
        break
        
      case 'repeat':
        response = `Je répète : ${currentQuestion || "Quelle est ta question ?"}`
        break
        
      case 'encouragement':
        response = personalities[personality].responses.encouragement
        break
        
      default:
        response = "Comment puis-je t'aider avec les mathématiques ?"
    }
    
    addMessage(response, 'assistant', emotion)
    speak(response)
    
    if (onVoiceCommand) {
      onVoiceCommand(transcript, confidence)
    }
  }

  const analyzeIntent = (transcript: string): string => {
    const lowerTranscript = transcript.toLowerCase()
    
    for (const [intent, keywords] of Object.entries(voiceCommands)) {
      if (keywords.some(keyword => lowerTranscript.includes(keyword))) {
        return intent
      }
    }
    
    // Vérifier si c'est une réponse numérique
    if (/\b\d+\b/.test(transcript)) {
      return 'answer'
    }
    
    return 'general'
  }

  const analyzeEmotion = (transcript: string): string => {
    const lowerTranscript = transcript.toLowerCase()
    
    if (['difficile', 'compliqué', 'ne comprends pas'].some(word => lowerTranscript.includes(word))) {
      return 'frustrated'
    }
    if (['super', 'génial', 'cool', 'j\'adore'].some(word => lowerTranscript.includes(word))) {
      return 'excited'
    }
    if (['quoi', 'comment', 'pourquoi', 'hein'].some(word => lowerTranscript.includes(word))) {
      return 'confused'
    }
    
    return 'neutral'
  }

  const addMessage = (text: string, type: 'user' | 'assistant', emotion?: string) => {
    const message: VoiceMessage = {
      id: `msg_${Date.now()}_${Math.random()}`,
      text,
      type,
      timestamp: Date.now(),
      emotion,
      confidence: type === 'user' ? recognitionConfidence : undefined
    }
    
    setMessages(prev => [...prev.slice(-10), message]) // Garder 10 derniers messages
  }

  const speak = (text: string) => {
    if (!voiceEnabled || !synthesisRef.current) return
    
    // Arrêter toute synthèse en cours
    synthesisRef.current.cancel()
    
    const utterance = new SpeechSynthesisUtterance(text)
    utterance.lang = language === 'fr' ? 'fr-FR' : 'en-US'
    utterance.rate = personality === 'enthusiastic' ? 1.1 : personality === 'patient' ? 0.9 : 1.0
    utterance.pitch = personality === 'enthusiastic' ? 1.2 : 1.0
    utterance.volume = 0.8
    
    utterance.onstart = () => setIsSpeaking(true)
    utterance.onend = () => setIsSpeaking(false)
    utterance.onerror = () => setIsSpeaking(false)
    
    synthesisRef.current.speak(utterance)
  }

  const toggleListening = () => {
    if (!recognitionRef.current) {
      alert('Reconnaissance vocale non supportée dans ce navigateur')
      return
    }
    
    if (isListening) {
      recognitionRef.current.stop()
    } else {
      recognitionRef.current.start()
    }
  }

  const toggleVoice = () => {
    const newVoiceEnabled = !voiceEnabled
    setVoiceEnabled(newVoiceEnabled)
    
    if (newVoiceEnabled) {
      addMessage(personalities[personality].responses.greeting, 'assistant')
      speak(personalities[personality].responses.greeting)
    } else {
      if (synthesisRef.current) {
        synthesisRef.current.cancel()
      }
    }
  }

  const startVolumeAnimation = () => {
    volumeIntervalRef.current = setInterval(() => {
      setVolumeLevel(Math.random() * 100)
    }, 100)
  }

  const stopVolumeAnimation = () => {
    if (volumeIntervalRef.current) {
      clearInterval(volumeIntervalRef.current)
      volumeIntervalRef.current = null
    }
    setVolumeLevel(0)
  }

  return (
    <div className={`bg-gradient-to-br from-purple-50 to-blue-50 rounded-2xl shadow-lg p-6 ${className}`}>
      {/* Header */}
      <div className="flex justify-between items-center mb-4">
        <div>
          <h3 className="text-xl font-bold text-gray-800">
            🎙️ Assistant Vocal IA - Math4Child
          </h3>
          <p className="text-sm text-gray-600">
            {personalities[personality].name} • {language === 'fr' ? 'Français' : 'English'}
          </p>
        </div>
        
        <div className="flex space-x-2">
          <select
            value={personality}
            onChange={(e) => setPersonality(e.target.value as any)}
            className="text-xs px-2 py-1 border rounded bg-white"
          >
            <option value="friendly">😊 Amical</option>
            <option value="enthusiastic">🚀 Enthousiaste</option>
            <option value="patient">🧘‍♀️ Patient</option>
          </select>
        </div>
      </div>

      {/* Contrôles principaux */}
      <div className="flex justify-center space-x-4 mb-6">
        <button
          onClick={toggleVoice}
          className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all ${
            voiceEnabled 
              ? 'bg-green-500 text-white hover:bg-green-600' 
              : 'bg-gray-300 text-gray-700 hover:bg-gray-400'
          }`}
        >
          {voiceEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
          <span>{voiceEnabled ? 'Vocal ON' : 'Vocal OFF'}</span>
        </button>

        <button
          onClick={toggleListening}
          disabled={!voiceEnabled}
          className={`flex items-center space-x-2 px-4 py-2 rounded-lg transition-all relative ${
            isListening 
              ? 'bg-red-500 text-white hover:bg-red-600 animate-pulse' 
              : voiceEnabled 
              ? 'bg-blue-500 text-white hover:bg-blue-600' 
              : 'bg-gray-300 text-gray-500 cursor-not-allowed'
          }`}
        >
          {isListening ? <MicOff className="w-5 h-5" /> : <Mic className="w-5 h-5" />}
          <span>{isListening ? 'Arrêter' : 'Écouter'}</span>
          
          {/* Animation du niveau sonore */}
          {isListening && (
            <div className="absolute -top-1 -right-1 w-3 h-3 bg-red-400 rounded-full animate-ping" />
          )}
        </button>
      </div>

      {/* Visualisation en temps réel */}
      {isListening && (
        <div className="mb-4 p-3 bg-blue-50 rounded-lg border-l-4 border-blue-500">
          <div className="flex items-center space-x-2 mb-2">
            <Zap className="w-4 h-4 text-blue-600" />
            <span className="text-sm font-medium text-blue-800">J'écoute...</span>
          </div>
          
          {/* Barre de niveau sonore */}
          <div className="w-full bg-gray-200 rounded-full h-2 mb-2">
            <div 
              className="bg-blue-600 h-2 rounded-full transition-all duration-100"
              style={{ width: `${volumeLevel}%` }}
            />
          </div>
          
          {currentPhrase && (
            <p className="text-sm text-gray-700 italic">"{currentPhrase}"</p>
          )}
        </div>
      )}

      {/* Messages de conversation */}
      <div className="space-y-2 max-h-48 overflow-y-auto mb-4">
        {messages.slice(-5).map((message) => (
          <div
            key={message.id}
            className={`p-3 rounded-lg ${
              message.type === 'user'
                ? 'bg-blue-100 text-blue-800 ml-4'
                : 'bg-purple-100 text-purple-800 mr-4'
            }`}
          >
            <div className="flex justify-between items-start">
              <p className="text-sm">{message.text}</p>
              {message.confidence && (
                <span className="text-xs opacity-70">
                  {Math.round(message.confidence)}%
                </span>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* État et statistiques */}
      <div className="bg-gray-100 rounded-lg p-3 text-xs text-gray-600">
        <div className="flex justify-between items-center">
          <span>
            {isSpeaking ? '🗣️ En train de parler...' : 
             isListening ? '👂 À l\'écoute...' : 
             '⏸️ En attente'}
          </span>
          <span>
            📊 Messages: {messages.length} | 
            🎯 Confiance: {Math.round(recognitionConfidence)}%
          </span>
        </div>
      </div>
    </div>
  )
}
