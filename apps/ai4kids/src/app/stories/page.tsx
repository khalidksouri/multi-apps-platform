'use client';

import React, { useState } from 'react';
import { AI4KidsLogo } from '../../components/AI4KidsLogo';
import { Button } from '../../components/ui/Button';
import { Card } from '../../components/ui/Card';
import { useLanguage } from '../../contexts/LanguageContext';
import Link from 'next/link';

export default function StoriesPage() {
  const { translations } = useLanguage();
  const [currentStory, setCurrentStory] = useState<any>(null);
  const [storyStep, setStoryStep] = useState(0);

  const stories = [
    {
      id: 'robot',
      title: 'Le Robot Curieux',
      description: 'L\'histoire d\'un petit robot qui veut apprendre',
      icon: '🤖',
      color: 'bg-blue-500',
      steps: [
        {
          text: "Il était une fois un petit robot nommé Beep qui vivait dans une grande ville technologique.",
          image: "🤖",
          choice: "Que fait Beep ?"
        },
        {
          text: "Beep décide d'explorer la ville pour apprendre de nouvelles choses. Il rencontre d'autres robots.",
          image: "🏙️",
          choice: "Beep veut-il jouer ou apprendre ?"
        },
        {
          text: "Beep choisit d'apprendre ! Il découvre qu'aider les autres robots le rend heureux.",
          image: "✨",
          choice: "Quelle leçon Beep a-t-il apprise ?"
        }
      ],
      moral: "La curiosité et l'apprentissage nous rendent heureux !"
    },
    {
      id: 'princess',
      title: 'La Princesse Codeuse',
      description: 'Une princesse qui résout des problèmes avec la programmation',
      icon: '👸',
      color: 'bg-pink-500',
      steps: [
        {
          text: "La Princesse Luna vit dans un château magique où tout fonctionne grâce à des algorithmes.",
          image: "👸",
          choice: "Que se passe-t-il dans le château ?"
        },
        {
          text: "Un jour, les robots du château se trompent dans leurs tâches. Luna doit les reprogrammer.",
          image: "🏰",
          choice: "Comment Luna va-t-elle les aider ?"
        },
        {
          text: "Luna utilise sa baguette magique pour écrire du code et réparer tous les robots !",
          image: "✨",
          choice: "Quel pouvoir a la programmation ?"
        }
      ],
      moral: "La programmation peut résoudre de nombreux problèmes !"
    },
    {
      id: 'dragon',
      title: 'Le Dragon Intelligent',
      description: 'Un dragon qui utilise l\'IA pour protéger son trésor',
      icon: '🐉',
      color: 'bg-green-500',
      steps: [
        {
          text: "Dans une montagne lointaine vit Spark, un dragon qui protège un trésor très spécial.",
          image: "🐉",
          choice: "Quel est ce trésor ?"
        },
        {
          text: "Le trésor de Spark, ce sont des livres de connaissance ! Il utilise l'IA pour les organiser.",
          image: "📚",
          choice: "Comment Spark utilise-t-il l'IA ?"
        },
        {
          text: "Spark partage ses connaissances avec tous les enfants qui viennent le voir, grâce à l'IA !",
          image: "🌟",
          choice: "Pourquoi partager est-il important ?"
        }
      ],
      moral: "Partager ses connaissances enrichit tout le monde !"
    }
  ];

  const startStory = (story: any) => {
    setCurrentStory(story);
    setStoryStep(0);
  };

  const nextStep = () => {
    if (storyStep < currentStory.steps.length - 1) {
      setStoryStep(storyStep + 1);
    }
  };

  const resetStory = () => {
    setCurrentStory(null);
    setStoryStep(0);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-400 via-pink-300 to-orange-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <Link href="/" className="flex items-center space-x-3">
            <AI4KidsLogo size={60} />
            <span className="text-white font-bold text-2xl">AI4KIDS</span>
          </Link>
          <Button variant="secondary" className="bg-white text-purple-600">
            <Link href="/">🏠 Accueil</Link>
          </Button>
        </div>

        {!currentStory ? (
          <>
            <div className="text-center mb-12">
              <h1 className="text-4xl font-bold text-white mb-4">
                📚 {translations.storiesTitle}
              </h1>
              <p className="text-xl text-white/90">
                Choisis une histoire magique !
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
              {stories.map((story) => (
                <Card key={story.id} className="text-center hover:scale-105 transition-transform">
                  <div className={`w-16 h-16 ${story.color} rounded-full flex items-center justify-center mx-auto mb-4`}>
                    <span className="text-2xl">{story.icon}</span>
                  </div>
                  <h3 className="text-2xl font-bold text-gray-800 mb-2">{story.title}</h3>
                  <p className="text-gray-600 mb-6">{story.description}</p>
                  <Button 
                    variant="primary" 
                    onClick={() => startStory(story)}
                  >
                    Lire l'histoire
                  </Button>
                </Card>
              ))}
            </div>
          </>
        ) : (
          <div className="max-w-3xl mx-auto">
            <div className="text-center mb-8">
              <Button 
                variant="secondary" 
                onClick={resetStory}
                className="mb-4"
              >
                ← Retour aux histoires
              </Button>
            </div>

            <Card className="text-center">
              <h2 className="text-3xl font-bold text-purple-600 mb-6">
                {currentStory.icon} {currentStory.title}
              </h2>
              
              <div className="text-6xl mb-6">
                {currentStory.steps[storyStep].image}
              </div>
              
              <div className="text-lg text-gray-700 mb-8 leading-relaxed">
                {currentStory.steps[storyStep].text}
              </div>
              
              <div className="text-md text-gray-600 mb-6 italic">
                {currentStory.steps[storyStep].choice}
              </div>
              
              <div className="flex justify-center space-x-4">
                {storyStep < currentStory.steps.length - 1 ? (
                  <Button variant="primary" onClick={nextStep}>
                    Continuer l'histoire →
                  </Button>
                ) : (
                  <div className="text-center">
                    <div className="text-xl font-bold text-green-600 mb-4">
                      🌟 Morale de l'histoire :
                    </div>
                    <div className="text-lg text-gray-700 mb-6">
                      {currentStory.moral}
                    </div>
                    <Button variant="success" onClick={resetStory}>
                      Lire une autre histoire
                    </Button>
                  </div>
                )}
              </div>
              
              <div className="mt-6 text-sm text-gray-500">
                Étape {storyStep + 1} sur {currentStory.steps.length}
              </div>
            </Card>
          </div>
        )}
      </div>
    </div>
  );
}
