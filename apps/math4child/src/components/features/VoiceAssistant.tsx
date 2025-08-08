"use client"

import { useState, useEffect, useRef, useCallback } from 'react'

type AssistantPersonality = 'encouraging' | 'patient' | 'enthusiastic'

interface VoiceMessage {
  id: string
  text: string
  type: 'assistant' | 'user' | 'system'
  timestamp: number
  personality?: AssistantPersonality
  emotion?: 'happy' | 'concerned' | 'excited' | 'supportive'
}

interface VoiceAssistantProps {
  currentProblem?: string
  userStruggling?: boolean
  onHintRequest?: () => void
  onEncouragement?: () => void
  personality?: AssistantPersonality
}

export function VoiceAssistant({ 
  currentProblem, 
  userStruggling = false,
  onHintRequest,
  onEncouragement,
  personality = 'encouraging'
}: VoiceAssistantProps) {
  const [isListening, setIsListening] = useState(false)
  const [isSpeaking, setIsSpeaking] = useState(false)
  const [messages, setMessages] = useState<VoiceMessage[]>([])
  const [currentPersonality, setCurrentPersonality] = useState<AssistantPersonality>(personality)
  const [speechSupported, setSpeechSupported] = useState(false)
  const [volumeLevel, setVolumeLevel] = useState(0)
  const recognitionRef = useRef<any>(null)
  const synthesisRef = useRef<SpeechSynthesis | null>(null)

  // Personnalités de l'assistant
  const personalities = {
    encouraging: {
      name: '🌟 Encourageant',
      voice: 'friendly',
      responses: {
        greeting: "Salut champion ! Je suis là pour t'aider avec les maths. Tu es prêt ?",
        hint: "Pas de souci ! Voici un petit indice pour t'aider...",
        success: "Bravo ! Tu es vraiment doué en maths !",
        struggle: "Ne t'inquiète pas, on va y arriver ensemble ! Prends ton temps.",
        motivation: "Tu fais des progrès fantastiques ! Continue comme ça !"
      }
    },
    patient: {
      name: '🧘 Patient',
      voice: 'calm',
      responses: {
        greeting: "Bonjour ! Prenons notre temps pour bien comprendre les maths ensemble.",
        hint: "Réfléchissons étape par étape. D'abord, regardons ce nombre...",
        success: "Très bien ! Tu as pris le temps de bien réfléchir.",
        struggle: "C'est normal de trouver ça difficile. Respirons et reprenons calmement.",
        motivation: "Chaque petit pas compte. Tu progresses à ton rythme, c'est parfait."
      }
    },
    enthusiastic: {
      name: '🚀 Enthousiaste',
      voice: 'energetic',
      responses: {
        greeting: "Wow ! C'est parti pour une aventure mathématique incroyable !",
        hint: "Oh oh ! J'ai une astuce géniale pour toi ! Écoute bien...",
        success: "FANTASTIQUE ! Tu es un vrai génie des maths !",
        struggle: "Allez, on va transformer ça en victoire ! Je crois en toi !",
        motivation: "Tu es en feu ! Tes progrès sont absolument incroyables !"
      }
    }
  }

  // Initialisation de l'API Speech
  useEffect(() => {
    if (typeof window !== 'undefined') {
      // Vérifier le support de l'API Speech
      setSpeechSupported('speechSynthesis' in window && 'webkitSpeechRecognition' in window)
      
      if ('speechSynthesis' in window) {
        synthesisRef.current = window.speechSynthesis
      }
      
      // Message d'accueil
      addMessage({
        id: 'greeting',
        text: personalities[currentPersonality].responses.greeting,
        type: 'assistant',
        timestamp: Date.now(),
        personality: currentPersonality,
        emotion: 'happy'
      })
    }
  }, [currentPersonality])

  // Réaction aux difficultés de l'utilisateur
  useEffect(() => {
    if (userStruggling) {
      provideSupport()
    }
  }, [userStruggling])

  const addMessage = useCallback((message: Omit<VoiceMessage, 'id' | 'timestamp'> & { id?: string, timestamp?: number }) => {
    const newMessage: VoiceMessage = {
      id: message.id || `msg_${Date.now()}_${Math.random()}`,
      timestamp: message.timestamp || Date.now(),
      ...message
    }
    
    setMessages(prev => [...prev.slice(-10), newMessage]) // Garder les 10 derniers messages
    
    // Synthèse vocale pour les messages de l'assistant
    if (newMessage.type === 'assistant') {
      speakMessage(newMessage.text)
    }
  }, [])

  const speakMessage = useCallback((text: string) => {
    if (!synthesisRef.current || !speechSupported) {
      console.log('🎙️ Simulation vocale:', text)
      return
    }

    // Arrêter toute synthèse en cours
    synthesisRef.current.cancel()
    
    const utterance = new SpeechSynthesisUtterance(text)
    
    // Configuration de la voix selon la personnalité
    utterance.rate = currentPersonality === 'enthusiastic' ? 1.2 : currentPersonality === 'patient' ? 0.8 : 1.0
    utterance.pitch = currentPersonality === 'enthusiastic' ? 1.2 : 1.0
    utterance.volume = 0.8
    
    utterance.onstart = () => setIsSpeaking(true)
    utterance.onend = () => setIsSpeaking(false)
    utterance.onerror = () => setIsSpeaking(false)
    
    setIsSpeaking(true)
    synthesisRef.current.speak(utterance)
  }, [currentPersonality, speechSupported])

  const startListening = useCallback(() => {
    if (!speechSupported) {
      // Simulation de reconnaissance vocale
      simulateVoiceRecognition()
      return
    }

    // Implémentation réelle de la reconnaissance vocale
    try {
      const SpeechRecognition = (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition
      const recognition = new SpeechRecognition()
      
      recognition.continuous = false
      recognition.interimResults = false
      recognition.lang = 'fr-FR'
      
      recognition.onstart = () => {
        setIsListening(true)
        setVolumeLevel(0)
      }
      
      recognition.onresult = (event: any) => {
        const transcript = event.results[0][0].transcript
        const confidence = event.results[0][0].confidence
        
        addMessage({
          text: transcript,
          type: 'user',
          timestamp: Date.now()
        })
        
        processUserInput(transcript, confidence)
      }
      
      recognition.onerror = () => {
        setIsListening(false)
        addMessage({
          text: "Désolé, je n'ai pas bien entendu. Peux-tu répéter ?",
          type: 'assistant',
          timestamp: Date.now(),
          personality: currentPersonality,
          emotion: 'concerned'
        })
      }
      
      recognition.onend = () => {
        setIsListening(false)
        setVolumeLevel(0)
      }
      
      recognitionRef.current = recognition
      recognition.start()
      
    } catch (error) {
      console.error('Erreur reconnaissance vocale:', error)
      simulateVoiceRecognition()
    }
  }, [speechSupported, currentPersonality])

  const simulateVoiceRecognition = () => {
    setIsListening(true)
    
    // Simulation d'écoute avec animation du volume
    const volumeAnimation = setInterval(() => {
      setVolumeLevel(Math.random() * 100)
    }, 100)
    
    // Simulation de reconnaissance après 3 secondes
    setTimeout(() => {
      clearInterval(volumeAnimation)
      setIsListening(false)
      setVolumeLevel(0)
      
      const simulatedInputs = [
        "Je ne comprends pas",
        "Peux-tu m'aider ?", 
        "C'est difficile",
        "Donne-moi un indice",
        "Je pense que c'est " + Math.floor(Math.random() * 20)
      ]
      
      const randomInput = simulatedInputs[Math.floor(Math.random() * simulatedInputs.length)]
      
      addMessage({
        text: randomInput + " (simulé)",
        type: 'user',
        timestamp: Date.now()
      })
      
      processUserInput(randomInput, 0.8)
    }, 3000)
  }

  const processUserInput = useCallback((input: string, confidence: number) => {
    const lowerInput = input.toLowerCase()
    
    if (lowerInput.includes('aide') || lowerInput.includes('indice')) {
      provideHint()
      onHintRequest?.()
    } else if (lowerInput.includes('difficile') || lowerInput.includes('comprends pas')) {
      provideSupport()
    } else if (lowerInput.includes('merci') || lowerInput.includes('super')) {
      expressJoy()
    } else if (/\d+/.test(lowerInput)) {
      // L'utilisateur donne une réponse numérique
      validateAnswer(lowerInput)
    } else {
      // Réponse générale encourageante
      addMessage({
        text: personalities[currentPersonality].responses.motivation,
        type: 'assistant',
        timestamp: Date.now(),
        personality: currentPersonality,
        emotion: 'supportive'
      })
    }
  }, [currentPersonality, onHintRequest])

  const provideHint = () => {
    const hints = [
      "Essaie de compter sur tes doigts !",
      "Pense à grouper les nombres ensemble.",
      "Commence par le plus petit nombre.",
      "Visualise les objets dans ta tête.",
      "Prends une grande respiration et recommence."
    ]
    
    const randomHint = hints[Math.floor(Math.random() * hints.length)]
    
    addMessage({
      text: personalities[currentPersonality].responses.hint + " " + randomHint,
      type: 'assistant',
      timestamp: Date.now(),
      personality: currentPersonality,
      emotion: 'supportive'
    })
  }

  const provideSupport = () => {
    addMessage({
      text: personalities[currentPersonality].responses.struggle,
      type: 'assistant',
      timestamp: Date.now(),
      personality: currentPersonality,
      emotion: 'supportive'
    })
    
    onEncouragement?.()
  }

  const expressJoy = () => {
    addMessage({
      text: personalities[currentPersonality].responses.success,
      type: 'assistant',
      timestamp: Date.now(),
      personality: currentPersonality,
      emotion: 'excited'
    })
  }

  const validateAnswer = (input: string) => {
    const numbers = input.match(/\d+/g)
    if (numbers && numbers.length > 0) {
      addMessage({
        text: `Je vois que tu penses à ${numbers[0]} ! ${personalities[currentPersonality].responses.success}`,
        type: 'assistant',
        timestamp: Date.now(),
        personality: currentPersonality,
        emotion: 'happy'
      })
    }
  }

  const stopListening = () => {
    if (recognitionRef.current) {
      recognitionRef.current.stop()
    }
    setIsListening(false)
    setVolumeLevel(0)
  }

  const stopSpeaking = () => {
    if (synthesisRef.current) {
      synthesisRef.current.cancel()
    }
    setIsSpeaking(false)
  }

  const changePersonality = (newPersonality: AssistantPersonality) => {
    setCurrentPersonality(newPersonality)
    
    addMessage({
      text: `Salut ! Je change de personnalité. ${personalities[newPersonality].responses.greeting}`,
      type: 'system',
      timestamp: Date.now()
    })
  }

  return (
    <div className="space-y-4">
      <div className="text-center">
        <h3 className="text-lg font-bold text-gray-800 mb-2">
          🎙️ Assistant Vocal IA - INNOVATION MAJEURE
        </h3>
        <p className="text-sm text-gray-600">
          Parlez avec votre tuteur IA personnalisé
        </p>
      </div>

      {/* Sélecteur de personnalité */}
      <div className="bg-gray-50 rounded-lg p-3">
        <div className="text-sm font-medium text-gray-700 mb-2">Choisir la personnalité :</div>
        <div className="grid grid-cols-3 gap-2">
          {Object.entries(personalities).map(([key, persona]) => (
            <button
              key={key}
              onClick={() => changePersonality(key as AssistantPersonality)}
              className={`p-2 rounded-lg text-xs font-medium transition-colors ${
                currentPersonality === key
                  ? 'bg-blue-500 text-white'
                  : 'bg-white text-gray-700 hover:bg-blue-50'
              }`}
            >
              {persona.name}
            </button>
          ))}
        </div>
      </div>

      {/* Interface vocale principale */}
      <div className="bg-gradient-to-br from-blue-50 to-purple-50 border-2 border-blue-200 rounded-lg p-4">
        {/* Visualiseur vocal */}
        <div className="text-center mb-4">
          <div className="relative inline-block">
            {/* Avatar de l'assistant */}
            <div className={`w-20 h-20 rounded-full flex items-center justify-center text-3xl transition-all duration-300 ${
              isSpeaking ? 'bg-green-500 animate-pulse' : 
              isListening ? 'bg-blue-500 animate-bounce' : 'bg-gray-300'
            }`}>
              {isSpeaking ? '🗣️' : isListening ? '👂' : personalities[currentPersonality].name.split(' ')[0]}
            </div>
            
            {/* Indicateur de volume */}
            {isListening && (
              <div className="absolute -bottom-2 left-1/2 transform -translate-x-1/2">
                <div className="flex gap-1">
                  {[1, 2, 3, 4, 5].map(i => (
                    <div
                      key={i}
                      className={`w-1 bg-blue-500 rounded-full transition-all duration-100 ${
                        volumeLevel > i * 20 ? `h-${Math.min(6, i + 1)}` : 'h-1'
                      }`}
                    />
                  ))}
                </div>
              </div>
            )}
          </div>
          
          <div className="mt-2">
            <div className="font-medium text-gray-800">
              {personalities[currentPersonality].name}
            </div>
            <div className="text-sm text-gray-600">
              {isSpeaking ? 'Je parle...' : isListening ? 'J\'écoute...' : 'Prêt à t\'aider !'}
            </div>
          </div>
        </div>

        {/* Contrôles vocaux */}
        <div className="flex justify-center gap-3 mb-4">
          {!isListening ? (
            <button
              onClick={startListening}
              disabled={isSpeaking}
              className="bg-blue-500 hover:bg-blue-600 disabled:bg-gray-300 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center gap-2"
            >
              🎤 Parler
            </button>
          ) : (
            <button
              onClick={stopListening}
              className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center gap-2"
            >
              ⏹️ Arrêter
            </button>
          )}
          
          {isSpeaking && (
            <button
              onClick={stopSpeaking}
              className="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg font-medium transition-colors"
            >
              🔇 Silence
            </button>
          )}
          
          <button
            onClick={provideHint}
            className="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg font-medium transition-colors"
          >
            💡 Indice
          </button>
        </div>

        {/* Historique des messages */}
        <div className="bg-white rounded-lg p-3 max-h-32 overflow-y-auto space-y-2">
          {messages.slice(-3).map(message => (
            <div
              key={message.id}
              className={`flex gap-2 ${message.type === 'user' ? 'justify-end' : 'justify-start'}`}
            >
              <div className={`max-w-xs px-3 py-2 rounded-lg text-sm ${
                message.type === 'user' 
                  ? 'bg-blue-500 text-white' 
                  : message.type === 'system'
                  ? 'bg-gray-500 text-white'
                  : 'bg-gray-100 text-gray-800'
              }`}>
                {message.text}
              </div>
            </div>
          ))}
          
          {messages.length === 0 && (
            <div className="text-center text-gray-500 text-sm italic">
              Aucun message pour le moment...
            </div>
          )}
        </div>
      </div>

      {/* Actions rapides */}
      <div className="grid grid-cols-2 gap-3">
        <button
          onClick={() => addMessage({
            text: "Peux-tu m'expliquer ce problème ?",
            type: 'user',
            timestamp: Date.now()
          })}
          className="bg-yellow-500 hover:bg-yellow-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          ❓ Demander aide
        </button>
        
        <button
          onClick={() => addMessage({
            text: "Je pense avoir compris !",
            type: 'user',
            timestamp: Date.now()
          })}
          className="bg-green-500 hover:bg-green-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          ✅ J'ai compris
        </button>
      </div>

      {/* Informations techniques */}
      <div className="bg-gray-50 rounded-lg p-3 text-xs">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <div className="font-semibold text-gray-700">Support vocal :</div>
            <div className={speechSupported ? 'text-green-600' : 'text-orange-600'}>
              {speechSupported ? '✅ Activé' : '⚠️ Simulé'}
            </div>
          </div>
          <div>
            <div className="font-semibold text-gray-700">Messages :</div>
            <div className="text-blue-600">{messages.length} échanges</div>
          </div>
        </div>
      </div>
    </div>
  )
}
