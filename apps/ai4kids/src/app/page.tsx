'use client';

import { useState } from 'react';

export default function HomePage() {
  const [selectedTopic, setSelectedTopic] = useState<string | null>(null);

  const topics = [
    {
      id: 'chatbot',
      title: 'Mon Premier Chatbot',
      description: 'Crée ton propre assistant virtuel',
      color: 'bg-blue-500',
      emoji: '🤖'
    },
    {
      id: 'image-recognition',
      title: 'Reconnaissance d\'Images', 
      description: 'Apprends à l\'IA à voir les images',
      color: 'bg-green-500',
      emoji: '👁️'
    },
    {
      id: 'voice-commands',
      title: 'Commandes Vocales',
      description: 'Contrôle ton ordinateur avec ta voix',
      color: 'bg-purple-500',
      emoji: '🎤'
    }
  ];

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          Bienvenue dans AI4Kids! 🌟
        </h1>
        <p className="text-xl text-gray-600">
          Découvre le monde magique de l'Intelligence Artificielle
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {topics.map((topic) => (
          <div
            key={topic.id}
            className="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-shadow cursor-pointer border-2 border-transparent hover:border-purple-300"
            onClick={() => setSelectedTopic(topic.id)}
          >
            <div className="text-center">
              <div className="text-6xl mb-4">{topic.emoji}</div>
              <h3 className="text-xl font-bold mb-2">{topic.title}</h3>
              <p className="text-gray-600 mb-4">{topic.description}</p>
              <button className="bg-purple-600 text-white px-4 py-2 rounded-md hover:bg-purple-700">
                Commencer
              </button>
            </div>
          </div>
        ))}
      </div>

      {selectedTopic && (
        <div className="bg-white p-6 rounded-lg shadow-lg">
          <h3 className="text-2xl font-bold mb-4">
            Tu as choisi: {topics.find(t => t.id === selectedTopic)?.title}
          </h3>
          <p className="text-gray-600 mb-4">
            Félicitations! Tu vas apprendre quelque chose d'incroyable aujourd'hui.
          </p>
          <div className="flex space-x-4">
            <button className="bg-green-600 text-white px-4 py-2 rounded-md hover:bg-green-700">
              Suivant 🚀
            </button>
            <button 
              className="bg-gray-200 text-gray-800 px-4 py-2 rounded-md hover:bg-gray-300"
              onClick={() => setSelectedTopic(null)}
            >
              Retour
            </button>
          </div>
        </div>
      )}
    </div>
  );
}