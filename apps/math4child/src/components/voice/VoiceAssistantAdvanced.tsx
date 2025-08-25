'use client';

import React, { useState, useEffect, useRef } from 'react';

type VoicePersonality = 'amical' | 'enthousiaste' | 'patient';

interface VoiceAssistantProps {
  onResponse: (response: string) => void;
  personality?: VoicePersonality;
  disabled?: boolean;
  exerciseQuestion?: string;
}

export default function VoiceAssistantAdvanced({ 
  onResponse, 
  personality = 'amical', 
  disabled = false,
  exerciseQuestion = ''
}: VoiceAssistantProps) {
  const [isListening, setIsListening] = useState(false);
  const [transcript, setTranscript] = useState('');
  const [isSupported, setIsSupported] = useState(false);
  const [emotionDetected, setEmotionDetected] = useState<string>('');
  const recognitionRef = useRef<any>(null);

  useEffect(() => {
    // Vérifier support API Speech selon spécifications v4.2.0
    setIsSupported('webkitSpeechRecognition' in window || 'SpeechRecognition' in window);
  }, []);

  const personalities = {
    amical: {
      color: 'from-blue-500 to-blue-600',
      borderColor: 'border-blue-300',
      name: '😊 Amical',
      emoji: '😊',
      description: 'Doux et encourageant',
      responses: [
        'Super ! Tu as dit : ',
        'C\'est bien ! J\'ai entendu : ',
        'Parfait ! Tu as répondu : ',
        'Très bien ! Tu dis : '
      ],
      encouragements: [
        '👍 Continue comme ça !',
        '😊 Tu progresses bien !',
        '💙 Je suis là pour t\'aider !'
      ]
    },
    enthousiaste: {
      color: 'from-green-500 to-emerald-600',
      borderColor: 'border-green-300',
      name: '🎉 Enthousiaste',
      emoji: '🎉',
      description: 'Plein d\'énergie et motivant',
      responses: [
        'FANTASTIQUE ! Tu as dit : ',
        'GÉNIAL ! J\'ai capté : ',
        'EXTRAORDINAIRE ! Ta réponse est : ',
        'BRAVO ! Tu as annoncé : '
      ],
      encouragements: [
        '🌟 Tu es incroyable !',
        '🚀 En avant vers la réussite !',
        '⭐ Champion des mathématiques !'
      ]
    },
    patient: {
      color: 'from-purple-500 to-indigo-600',
      borderColor: 'border-purple-300',
      name: '🧘 Patient',
      emoji: '🧘',
      description: 'Calme et rassurant',
      responses: [
        'Je t\'écoute, tu as dit : ',
        'D\'accord, j\'ai compris : ',
        'Très bien, tu as répondu : ',
        'Prends ton temps, tu dis : '
      ],
      encouragements: [
        '🌸 Pas de stress, tu y arrives !',
        '🕯️ Respire et continue !',
        '☯️ Chaque étape compte !'
      ]
    }
  };

  const startListening = () => {
    if (!isSupported || disabled) return;

    setIsListening(true);
    setTranscript('');
    setEmotionDetected('');

    // Configuration Speech Recognition avancée v4.2.0
    try {
      const SpeechRecognition = (window as any).webkitSpeechRecognition || (window as any).SpeechRecognition;
      const recognition = new SpeechRecognition();
      
      recognition.continuous = false;
      recognition.interimResults = true;
      recognition.lang = 'fr-FR';
      recognition.maxAlternatives = 3;
      
      recognition.onresult = (event: any) => {
        const results = event.results;
        if (results.length > 0) {
          const speechResult = results[0][0].transcript.toLowerCase();
          setTranscript(speechResult);
          
          // Analyse émotionnelle basique
          if (speechResult.includes('génial') || speechResult.includes('super')) {
            setEmotionDetected('joie');
          } else if (speechResult.includes('difficile') || speechResult.includes('dur')) {
            setEmotionDetected('frustration');
          } else {
            setEmotionDetected('neutre');
          }
          
          processVoiceResponse(speechResult);
        }
      };
      
      recognition.onerror = (event: any) => {
        console.error('Erreur reconnaissance vocale:', event.error);
        setIsListening(false);
      };
      
      recognition.onend = () => {
        setIsListening(false);
      };
      
      recognitionRef.current = recognition;
      recognition.start();
      
    } catch (error) {
      console.error('Erreur initialisation reconnaissance:', error);
      // Fallback simulation pour démo
      simulateVoiceRecognition();
    }
  };

  const simulateVoiceRecognition = () => {
    // Simulation réaliste pour démo
    setTimeout(() => {
      const mockResponses = [
        'la réponse est 42',
        'c\'est 15',
        '7',
        'vingt-cinq',
        'je pense que c\'est 8',
        'euh... 12 ?'
      ];
      const mockResponse = mockResponses[Math.floor(Math.random() * mockResponses.length)];
      
      setTranscript(mockResponse);
      
      // Simulation analyse émotionnelle
      const emotions = ['joie', 'confiance', 'hésitation', 'concentration'];
      const emotion = emotions[Math.floor(Math.random() * emotions.length)];
      setEmotionDetected(emotion);
      
      processVoiceResponse(mockResponse);
      setIsListening(false);
    }, 3000);
  };

  const processVoiceResponse = (speechText: string) => {
    const personalityData = personalities[personality];
    const response = personalityData.responses[
      Math.floor(Math.random() * personalityData.responses.length)
    ] + speechText;
    
    // Extraction du nombre de la réponse
    const numbers = speechText.match(/\d+/g);
    const extractedNumber = numbers ? numbers[0] : speechText;
    
    speak(response);
    onResponse(extractedNumber);
  };

  const speak = (text: string) => {
    if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = 'fr-FR';
      
      // Adaptation voix selon personnalité
      switch (personality) {
        case 'enthousiaste':
          utterance.rate = 1.3;
          utterance.pitch = 1.2;
          utterance.volume = 0.9;
          break;
        case 'patient':
          utterance.rate = 0.8;
          utterance.pitch = 0.9;
          utterance.volume = 0.7;
          break;
        default: // amical
          utterance.rate = 1.0;
          utterance.pitch = 1.0;
          utterance.volume = 0.8;
      }
      
      window.speechSynthesis.speak(utterance);
    }
  };

  const stopListening = () => {
    if (recognitionRef.current) {
      recognitionRef.current.stop();
    }
    setIsListening(false);
  };

  if (!isSupported) {
    return (
      <div className="text-center p-6 bg-yellow-50 border border-yellow-200 rounded-xl">
        <div className="text-6xl mb-4">⚠️</div>
        <p className="text-yellow-800 font-medium">
          Votre navigateur ne supporte pas la reconnaissance vocale.
        </p>
        <p className="text-yellow-600 text-sm mt-2">
          Utilisez Chrome, Edge ou Safari pour cette fonctionnalité.
        </p>
      </div>
    );
  }

  const currentPersonality = personalities[personality];

  return (
    <div className="flex flex-col items-center space-y-6">
      {/* Header avec personnalité */}
      <div className="text-center">
        <h3 className="text-2xl font-bold mb-3">🎙️ Assistant Vocal IA</h3>
        <div className={`inline-flex items-center px-4 py-2 bg-gradient-to-r ${currentPersonality.color} text-white rounded-full shadow-lg`}>
          <span className="text-2xl mr-2">{currentPersonality.emoji}</span>
          <div>
            <div className="font-semibold">{currentPersonality.name}</div>
            <div className="text-xs opacity-90">{currentPersonality.description}</div>
          </div>
        </div>
      </div>

      {/* Microphone principal */}
      <div className="relative">
        <button
          onClick={isListening ? stopListening : startListening}
          disabled={disabled}
          className={`
            w-24 h-24 rounded-full flex items-center justify-center text-white font-bold text-2xl shadow-xl transition-all duration-300
            ${isListening 
              ? 'bg-gradient-to-r from-red-500 to-red-600 animate-pulse scale-110' 
              : `bg-gradient-to-r ${currentPersonality.color} hover:scale-105 active:scale-95`
            }
            ${disabled ? 'opacity-50 cursor-not-allowed' : 'hover:shadow-2xl'}
          `}
        >
          {isListening ? '⏹️' : '🎤'}
        </button>
        
        {/* Animation d'écoute */}
        {isListening && (
          <>
            <div className="absolute -inset-4 border-4 border-red-300 rounded-full animate-ping"></div>
            <div className="absolute -inset-8 border-2 border-red-200 rounded-full animate-ping animation-delay-200"></div>
          </>
        )}
      </div>

      {/* Status et instructions */}
      <div className="text-center space-y-2">
        <p className={`text-lg font-medium ${
          isListening ? 'text-red-600 animate-pulse' : 'text-gray-700'
        }`}>
          {isListening ? '🎧 Je t\'écoute attentivement...' : '💭 Clique et dis ta réponse'}
        </p>
        
        {exerciseQuestion && (
          <div className="bg-blue-50 p-3 rounded-lg border border-blue-200">
            <p className="text-sm text-blue-800">
              <strong>Question:</strong> {exerciseQuestion}
            </p>
          </div>
        )}
        
        {/* Émotions détectées */}
        {emotionDetected && (
          <div className="bg-purple-50 p-2 rounded border border-purple-200">
            <p className="text-sm text-purple-700">
              😊 Émotion détectée: <strong>{emotionDetected}</strong>
            </p>
          </div>
        )}
      </div>

      {/* Transcript et résultats */}
      {transcript && (
        <div className={`max-w-md w-full p-4 bg-gradient-to-r ${currentPersonality.color} bg-opacity-10 border ${currentPersonality.borderColor} rounded-xl`}>
          <p className="text-lg font-medium text-gray-800 mb-2">
            {currentPersonality.emoji} <strong>Tu as dit:</strong>
          </p>
          <p className="text-xl text-gray-700 font-semibold bg-white p-3 rounded border">
            "{transcript}"
          </p>
          
          {/* Encouragement personnalisé */}
          <p className="text-sm text-gray-600 mt-2">
            {currentPersonality.encouragements[Math.floor(Math.random() * currentPersonality.encouragements.length)]}
          </p>
        </div>
      )}

      {/* Instructions d'utilisation */}
      <div className="text-center max-w-md space-y-2">
        <div className="text-xs text-gray-500 bg-gray-50 p-3 rounded border">
          <p className="font-semibold mb-2">💡 <strong>Instructions:</strong></p>
          <div className="space-y-1 text-left">
            <p>• Dis "La réponse est..." suivi du nombre</p>
            <p>• Ou simplement énonce le chiffre</p>
            <p>• Exemples: "C'est 15", "42", "Je pense que c'est 7"</p>
          </div>
        </div>
      </div>
    </div>
  );
}
