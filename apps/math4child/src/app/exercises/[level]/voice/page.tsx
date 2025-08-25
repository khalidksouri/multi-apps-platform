'use client';

import { useState, useEffect } from 'react';
import { useParams } from 'next/navigation';
import VoiceAssistantAdvanced from '../../../../components/voice/VoiceAssistantAdvanced';
import { generateExercise } from '../../../../data/exercises';
import { BranchInfoProvider } from '../../../../components/BranchInfo';

type VoicePersonality = 'amical' | 'enthousiaste' | 'patient';

export default function VoicePage() {
  const params = useParams();
  const level = parseInt(params.level as string) || 1;
  
  const [exercise, setExercise] = useState(generateExercise('multiplication', level, 'medium'));
  const [voiceResponse, setVoiceResponse] = useState<string>('');
  const [personality, setPersonality] = useState<VoicePersonality>('amical');
  const [isCorrect, setIsCorrect] = useState<boolean | null>(null);
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);
  const [conversationHistory, setConversationHistory] = useState<string[]>([]);

  const generateNewExercise = () => {
    const operations = ['addition', 'subtraction', 'multiplication', 'division'] as const;
    const randomOp = operations[Math.floor(Math.random() * operations.length)];
    const difficulties = ['easy', 'medium', 'hard'] as const;
    const randomDiff = difficulties[Math.floor(Math.random() * difficulties.length)];
    
    setExercise(generateExercise(randomOp, level, randomDiff));
    setVoiceResponse('');
    setIsCorrect(null);
  };

  const handleVoiceResponse = (response: string) => {
    setVoiceResponse(response);
    setAttempts(prev => prev + 1);
    
    // Ajouter à l'historique
    setConversationHistory(prev => [...prev, `Vous: "${response}"`]);
    
    // Extraction du nombre de la réponse vocale
    const numberMatch = response.match(/\d+/);
    const spokenNumber = numberMatch ? parseInt(numberMatch[0]) : null;
    
    // Vérification de la réponse
    let correct = false;
    if (spokenNumber !== null && spokenNumber === exercise.answer) {
      correct = true;
      setScore(prev => prev + exercise.points);
    }
    
    setIsCorrect(correct);
    
    // Réponse de l'IA selon personnalité
    const personalities = {
      amical: correct 
        ? "😊 Parfait ! Tu as trouvé la bonne réponse !"
        : "🤔 Pas tout à fait... Réessaie !",
      enthousiaste: correct
        ? "🎉 FANTASTIQUE ! Tu es un champion !"
        : "💪 Allez ! Je sais que tu peux y arriver !",
      patient: correct
        ? "✨ Très bien, tu as pris ton temps et c'est réussi"
        : "🌸 Ce n'est pas grave, respire et réessaie calmement"
    };
    
    const aiResponse = personalities[personality];
    setConversationHistory(prev => [...prev, `IA: "${aiResponse}"`]);
    
    if (correct) {
      setTimeout(() => {
        generateNewExercise();
      }, 3000);
    }
  };

  return (
    <BranchInfoProvider>
      <div className="min-h-screen bg-gradient-to-br from-purple-900 via-pink-900 to-indigo-900 text-white pt-20">
        <div className="max-w-6xl mx-auto px-4 py-20">
          {/* Header avec statistiques */}
          <div className="text-center mb-12">
            <h1 className="text-5xl font-bold mb-4 bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
              🎙️ Mode Assistant Vocal IA
            </h1>
            <div className="flex justify-center items-center space-x-6 mb-6">
              <div className="bg-purple-500/20 px-4 py-2 rounded-full border border-purple-500/30">
                <span className="text-purple-400 font-bold">Niveau {level}</span>
              </div>
              <div className="bg-pink-500/20 px-4 py-2 rounded-full border border-pink-500/30">
                <span className="text-pink-400 font-bold">Score: {score}</span>
              </div>
              <div className="bg-indigo-500/20 px-4 py-2 rounded-full border border-indigo-500/30">
                <span className="text-indigo-400 font-bold">Conversations: {attempts}</span>
              </div>
            </div>
            <p className="text-xl text-gray-300">
              Parle à ton assistant IA pour résoudre les exercices mathématiques
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Zone d'exercice et IA */}
            <div className="bg-black/30 backdrop-blur-sm border border-purple-500/20 rounded-2xl p-8">
              <div className="text-center mb-8">
                <div className="bg-gradient-to-r from-purple-400 to-pink-400 text-transparent bg-clip-text text-7xl font-bold mb-4">
                  {exercise.question}
                </div>
                <p className="text-gray-300 text-lg mb-4">
                  Dis ta réponse à voix haute à l'assistant IA
                </p>
                
                {/* Sélection personnalité */}
                <div className="mb-6">
                  <h3 className="text-lg font-semibold mb-4">Choisis la personnalité de ton assistant:</h3>
                  <div className="grid grid-cols-3 gap-3">
                    <button
                      onClick={() => setPersonality('amical')}
                      className={`px-4 py-3 rounded-xl transition-all duration-300 ${
                        personality === 'amical' 
                          ? 'bg-blue-600 scale-105 shadow-lg' 
                          : 'bg-gray-600 hover:bg-blue-500'
                      }`}
                    >
                      <div className="text-2xl mb-1">😊</div>
                      <div className="text-sm font-semibold">Amical</div>
                      <div className="text-xs opacity-80">Doux et encourageant</div>
                    </button>
                    <button
                      onClick={() => setPersonality('enthousiaste')}
                      className={`px-4 py-3 rounded-xl transition-all duration-300 ${
                        personality === 'enthousiaste' 
                          ? 'bg-green-600 scale-105 shadow-lg' 
                          : 'bg-gray-600 hover:bg-green-500'
                      }`}
                    >
                      <div className="text-2xl mb-1">🎉</div>
                      <div className="text-sm font-semibold">Enthousiaste</div>
                      <div className="text-xs opacity-80">Plein d'énergie</div>
                    </button>
                    <button
                      onClick={() => setPersonality('patient')}
                      className={`px-4 py-3 rounded-xl transition-all duration-300 ${
                        personality === 'patient' 
                          ? 'bg-purple-600 scale-105 shadow-lg' 
                          : 'bg-gray-600 hover:bg-purple-500'
                      }`}
                    >
                      <div className="text-2xl mb-1">🧘</div>
                      <div className="text-sm font-semibold">Patient</div>
                      <div className="text-xs opacity-80">Calme et rassurant</div>
                    </button>
                  </div>
                </div>
              </div>

              <div className="flex justify-center">
                <VoiceAssistantAdvanced
                  personality={personality}
                  onResponse={handleVoiceResponse}
                  exerciseQuestion={exercise.question}
                />
              </div>
            </div>

            {/* Zone de résultats et conversation */}
            <div className="space-y-6">
              {/* Résultat vocal */}
              {voiceResponse && (
                <div className={`p-6 rounded-2xl border ${
                  isCorrect 
                    ? 'bg-green-500/20 border-green-500/30 text-green-400'
                    : 'bg-orange-500/20 border-orange-500/30 text-orange-400'
                }`}>
                  <div className="text-center">
                    <div className="text-4xl mb-4">
                      {isCorrect ? '🎯' : '🤔'}
                    </div>
                    
                    {isCorrect ? (
                      <div className="text-green-400 text-2xl font-bold mb-4">
                        ✅ Parfait ! Tu as trouvé la bonne réponse !
                        <div className="text-lg mt-2">
                          +{exercise.points} points gagnés !
                        </div>
                      </div>
                    ) : (
                      <div className="text-orange-400 text-xl mb-4">
                        🔄 Continue ! La réponse correcte est {exercise.answer}
                        <div className="text-sm mt-2 text-gray-400">
                          Tu peux réessayer ou passer au suivant !
                        </div>
                      </div>
                    )}
                    
                    <div className="bg-black/30 p-4 rounded-lg">
                      <p className="text-lg font-medium text-white">
                        Tu as dit: "<span className="text-yellow-400">{voiceResponse}</span>"
                      </p>
                    </div>
                  </div>
                </div>
              )}

              {/* Historique conversation */}
              <div className="bg-gradient-to-br from-indigo-500/20 to-purple-500/20 p-6 rounded-2xl border border-indigo-500/30 max-h-80 overflow-y-auto">
                <h3 className="text-xl font-bold text-indigo-400 mb-4 flex items-center">
                  💬 Historique Conversation
                  {conversationHistory.length > 0 && (
                    <span className="ml-2 text-sm bg-indigo-500/30 px-2 py-1 rounded-full">
                      {conversationHistory.length}
                    </span>
                  )}
                </h3>
                <div className="space-y-2">
                  {conversationHistory.length === 0 ? (
                    <p className="text-gray-400 italic text-center py-4">
                      Commence à parler avec l'IA ! 🗣️
                    </p>
                  ) : (
                    conversationHistory.slice(-6).map((message, index) => (
                      <div 
                        key={index} 
                        className={`p-3 rounded-lg ${
                          message.startsWith('Vous:') 
                            ? 'bg-blue-500/20 text-blue-300 ml-4' 
                            : 'bg-purple-500/20 text-purple-300 mr-4'
                        }`}
                      >
                        <p className="text-sm">{message}</p>
                      </div>
                    ))
                  )}
                </div>
              </div>

              {/* Innovation showcase */}
              <div className="bg-gradient-to-br from-pink-500/20 to-red-500/20 p-6 rounded-2xl border border-pink-500/30">
                <div className="text-center mb-4">
                  <div className="text-3xl mb-2">🚀</div>
                  <h3 className="text-xl font-bold text-pink-400">Première Éducative Mondiale</h3>
                </div>
                <div className="space-y-3 text-sm text-gray-300">
                  <div className="flex items-center">
                    <span className="text-green-400 mr-2">🎭</span>
                    3 personnalités IA distinctes avec émotions
                  </div>
                  <div className="flex items-center">
                    <span className="text-blue-400 mr-2">🎙️</span>
                    Reconnaissance vocale Web Speech API
                  </div>
                  <div className="flex items-center">
                    <span className="text-purple-400 mr-2">❤️</span>
                    Analyse émotionnelle temps réel
                  </div>
                  <div className="flex items-center">
                    <span className="text-orange-400 mr-2">🗣️</span>
                    Synthèse vocale adaptative par personnalité
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className="space-y-3">
                <button
                  onClick={generateNewExercise}
                  className="w-full py-3 bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700 text-white rounded-lg font-semibold transition-all duration-300 shadow-lg"
                >
                  ➡️ Exercice Suivant
                </button>
                
                <div className="grid grid-cols-2 gap-3">
                  <button 
                    onClick={() => setConversationHistory([])}
                    className="py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg font-medium transition-colors"
                  >
                    🗑️ Effacer Historique
                  </button>
                  <button className="py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium transition-colors">
                    🎨 Paramètres Voix
                  </button>
                </div>
              </div>
            </div>
          </div>

          {/* Instructions et conseils */}
          <div className="mt-12 grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🎤</div>
              <h4 className="font-semibold mb-2 text-center">Comment parler</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Parle clairement au microphone</li>
                <li>• Dis "La réponse est..." + nombre</li>
                <li>• Ou énonce simplement le chiffre</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🎭</div>
              <h4 className="font-semibold mb-2 text-center">Personnalités IA</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• 😊 Amical: doux et encourageant</li>
                <li>• 🎉 Enthousiaste: plein d'énergie</li>
                <li>• 🧘 Patient: calme et rassurant</li>
              </ul>
            </div>
            
            <div className="bg-black/20 p-6 rounded-xl border border-gray-500/20">
              <div className="text-3xl mb-3 text-center">🧠</div>
              <h4 className="font-semibold mb-2 text-center">IA Avancée</h4>
              <ul className="text-sm text-gray-300 space-y-1">
                <li>• Analyse émotions dans la voix</li>
                <li>• Synthèse vocale adaptée</li>
                <li>• Conversation naturelle</li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </BranchInfoProvider>
  );
}
