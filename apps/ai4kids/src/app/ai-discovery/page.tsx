'use client';

import React, { useState } from 'react';
import { AI4KidsLogo } from '../../components/AI4KidsLogo';
import { Button } from '../../components/ui/Button';
import { Card } from '../../components/ui/Card';
import { useLanguage } from '../../contexts/LanguageContext';
import Link from 'next/link';

export default function AIDiscoveryPage() {
  const { translations } = useLanguage();
  const [currentTopic, setCurrentTopic] = useState<string | null>(null);
  const [aiResponse, setAiResponse] = useState('');
  const [userQuestion, setUserQuestion] = useState('');

  const topics = [
    {
      id: 'what-is-ai',
      title: 'Qu\'est-ce que l\'IA ?',
      description: 'Découvre ce qu\'est l\'intelligence artificielle',
      icon: '🤖',
      color: 'bg-blue-500',
      content: `L'Intelligence Artificielle (IA), c'est comme donner un cerveau à un ordinateur ! 

🧠 Imagine que tu enseignes à un robot comment reconnaître un chat :
- Tu lui montres 1000 photos de chats
- Il apprend les formes, les couleurs, les traits
- Maintenant il peut reconnaître un chat tout seul !

L'IA aide les ordinateurs à :
• Reconnaître des images
• Comprendre la parole
• Jouer aux jeux
• Conduire des voitures
• Et bien plus encore !`
    },
    {
      id: 'ai-examples',
      title: 'L\'IA dans la vie',
      description: 'Où trouve-t-on l\'IA tous les jours ?',
      icon: '🌟',
      color: 'bg-green-500',
      content: `L'IA est partout autour de nous ! 

📱 Dans ton téléphone :
• Reconnaissance vocale ("Hey Siri !")
• Appareil photo qui reconnaît les visages
• Traduction automatique

🏠 À la maison :
• Assistants vocaux (Alexa, Google Home)
• Recommandations sur YouTube/Netflix
• Thermostats intelligents

🚗 Dans les transports :
• GPS qui évite les bouchons
• Voitures autonomes
• Avions qui volent automatiquement

🎮 Dans les jeux :
• Personnages qui réagissent
• Adversaires intelligents
• Mondes qui s'adaptent à toi`
    },
    {
      id: 'how-ai-learns',
      title: 'Comment l\'IA apprend',
      description: 'Découvre comment les machines apprennent',
      icon: '📚',
      color: 'bg-purple-500',
      content: `L'IA apprend comme toi, mais différemment !

👶 Toi, tu apprends :
• En regardant
• En écoutant
• En essayant
• En faisant des erreurs

🤖 L'IA apprend :
• Avec des millions d'exemples
• En trouvant des patterns
• En ajustant ses réponses
• En s'améliorant avec le temps

💡 Types d'apprentissage :
• Apprentissage supervisé (avec un prof)
• Apprentissage non supervisé (tout seul)
• Apprentissage par renforcement (avec des récompenses)

C'est comme enseigner à un bébé robot !`
    },
    {
      id: 'ai-future',
      title: 'L\'IA du futur',
      description: 'À quoi ressemblera l\'IA de demain ?',
      icon: '🚀',
      color: 'bg-orange-500',
      content: `L'IA du futur sera incroyable !

🏥 En médecine :
• Diagnostics plus précis
• Robots chirurgiens
• Médicaments personnalisés

🌍 Pour la planète :
• Lutte contre le changement climatique
• Optimisation de l'énergie
• Protection des animaux

🎓 En éducation :
• Professeurs IA personnalisés
• Apprentissage adaptatif
• Réalité virtuelle éducative

✨ Et peut-être :
• Robots compagnons
• Traduction universelle
• Exploration spatiale assistée

L'important : l'IA doit aider les humains, pas les remplacer !`
    }
  ];

  const handleAIChat = () => {
    if (userQuestion.trim()) {
      // Simulation d'une réponse IA simple
      const responses = [
        "C'est une excellente question ! L'IA peut aider de nombreuses façons.",
        "Je pense que tu es très curieux ! L'IA fonctionne en apprenant des exemples.",
        "Bonne question ! L'IA est comme un cerveau électronique qui apprend.",
        "Tu veux en savoir plus ? L'IA peut reconnaître des images et comprendre la parole !",
        "Super question ! L'IA aide les docteurs, les conducteurs et même les artistes !"
      ];
      
      const randomResponse = responses[Math.floor(Math.random() * responses.length)];
      setAiResponse(`🤖 ${randomResponse} 

Pour ta question "${userQuestion}", voici ce que je peux te dire : L'IA est conçue pour aider les humains à résoudre des problèmes complexes en apprenant des données et en reconnaissant des motifs !`);
      setUserQuestion('');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-cyan-400 via-blue-300 to-purple-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <Link href="/" className="flex items-center space-x-3">
            <AI4KidsLogo size={60} />
            <span className="text-white font-bold text-2xl">AI4KIDS</span>
          </Link>
          <Button variant="secondary" className="bg-white text-blue-600">
            <Link href="/">🏠 Accueil</Link>
          </Button>
        </div>

        {!currentTopic ? (
          <>
            <div className="text-center mb-12">
              <h1 className="text-4xl font-bold text-white mb-4">
                🤖 {translations.aiTitle}
              </h1>
              <p className="text-xl text-white/90">
                Découvre les secrets de l'intelligence artificielle !
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 mb-12">
              {topics.map((topic) => (
                <Card key={topic.id} className="text-center hover:scale-105 transition-transform">
                  <div className={`w-16 h-16 ${topic.color} rounded-full flex items-center justify-center mx-auto mb-4`}>
                    <span className="text-2xl">{topic.icon}</span>
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{topic.title}</h3>
                  <p className="text-gray-600 mb-6">{topic.description}</p>
                  <Button 
                    variant="primary" 
                    onClick={() => setCurrentTopic(topic.id)}
                  >
                    Découvrir
                  </Button>
                </Card>
              ))}
            </div>

            {/* Section Chat avec IA */}
            <Card className="max-w-2xl mx-auto">
              <h2 className="text-2xl font-bold text-center text-gray-800 mb-6">
                💬 Pose une question à l'IA !
              </h2>
              
              <div className="space-y-4">
                <div className="flex space-x-2">
                  <input
                    type="text"
                    value={userQuestion}
                    onChange={(e) => setUserQuestion(e.target.value)}
                    placeholder="Demande-moi quelque chose sur l'IA..."
                    className="flex-1 p-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-blue-500"
                    onKeyPress={(e) => e.key === 'Enter' && handleAIChat()}
                  />
                  <Button variant="primary" onClick={handleAIChat}>
                    Demander
                  </Button>
                </div>
                
                {aiResponse && (
                  <div className="p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                    <div className="whitespace-pre-line text-gray-700">
                      {aiResponse}
                    </div>
                  </div>
                )}
              </div>
            </Card>
          </>
        ) : (
          <div className="max-w-3xl mx-auto">
            <div className="text-center mb-8">
              <Button 
                variant="secondary" 
                onClick={() => setCurrentTopic(null)}
                className="mb-4"
              >
                ← Retour aux sujets
              </Button>
            </div>

            <Card>
              {topics.find(t => t.id === currentTopic) && (
                <div className="text-center">
                  <div className="text-6xl mb-6">
                    {topics.find(t => t.id === currentTopic)?.icon}
                  </div>
                  <h2 className="text-3xl font-bold text-gray-800 mb-6">
                    {topics.find(t => t.id === currentTopic)?.title}
                  </h2>
                  <div className="text-left text-gray-700 leading-relaxed whitespace-pre-line">
                    {topics.find(t => t.id === currentTopic)?.content}
                  </div>
                </div>
              )}
            </Card>
          </div>
        )}
      </div>
    </div>
  );
}
