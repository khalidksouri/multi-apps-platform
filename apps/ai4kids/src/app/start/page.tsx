'use client';

import React, { useState } from 'react';
import { AI4KidsLogo } from '../../components/AI4KidsLogo';
import { Button } from '../../components/ui/Button';
import { Card } from '../../components/ui/Card';
import { useLanguage } from '../../contexts/LanguageContext';
import Link from 'next/link';

export default function StartPage() {
  const { translations } = useLanguage();
  const [userName, setUserName] = useState('');
  const [userAge, setUserAge] = useState('');
  const [step, setStep] = useState(1);

  const handleStart = () => {
    if (userName && userAge) {
      setStep(2);
    }
  };

  const activities = [
    {
      title: 'Jeux Mathématiques',
      description: 'Perfectionne tes compétences en calcul',
      icon: '🧮',
      link: '/games',
      color: 'bg-blue-500'
    },
    {
      title: 'Histoires Magiques',
      description: 'Lis des aventures extraordinaires',
      icon: '📚',
      link: '/stories',
      color: 'bg-purple-500'
    },
    {
      title: 'Découverte IA',
      description: 'Apprends ce qu\'est l\'intelligence artificielle',
      icon: '🤖',
      link: '/ai-discovery',
      color: 'bg-green-500'
    }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-400 via-blue-300 to-purple-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <Link href="/" className="flex items-center space-x-3">
            <AI4KidsLogo size={60} />
            <span className="text-white font-bold text-2xl">AI4KIDS</span>
          </Link>
          <Button variant="secondary" className="bg-white text-green-600">
            <Link href="/">🏠 Accueil</Link>
          </Button>
        </div>

        <div className="max-w-2xl mx-auto">
          {step === 1 ? (
            <Card className="text-center">
              <h1 className="text-4xl font-bold text-green-600 mb-6">
                🚀 Bienvenue dans AI4KIDS !
              </h1>
              
              <div className="text-6xl mb-6">🎉</div>
              
              <p className="text-xl text-gray-700 mb-8">
                Dis-nous en plus sur toi pour personnaliser ton expérience !
              </p>
              
              <div className="space-y-6">
                <div>
                  <label className="block text-left text-gray-700 font-semibold mb-2">
                    Comment tu t'appelles ?
                  </label>
                  <input
                    type="text"
                    value={userName}
                    onChange={(e) => setUserName(e.target.value)}
                    placeholder="Écris ton prénom..."
                    className="w-full p-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-500"
                  />
                </div>
                
                <div>
                  <label className="block text-left text-gray-700 font-semibold mb-2">
                    Quel âge as-tu ?
                  </label>
                  <select
                    value={userAge}
                    onChange={(e) => setUserAge(e.target.value)}
                    className="w-full p-3 border-2 border-gray-300 rounded-lg focus:outline-none focus:border-green-500"
                  >
                    <option value="">Choisis ton âge</option>
                    {Array.from({length: 13}, (_, i) => i + 3).map(age => (
                      <option key={age} value={age}>{age} ans</option>
                    ))}
                  </select>
                </div>
                
                <Button 
                  variant="primary" 
                  onClick={handleStart}
                  disabled={!userName || !userAge}
                  className="w-full"
                >
                  Commencer l'aventure ! 🎯
                </Button>
              </div>
            </Card>
          ) : (
            <Card className="text-center">
              <h1 className="text-4xl font-bold text-green-600 mb-4">
                Salut {userName} ! 👋
              </h1>
              
              <p className="text-xl text-gray-700 mb-8">
                Super ! Tu as {userAge} ans. Voici ce que tu peux faire sur AI4KIDS :
              </p>
              
              <div className="space-y-6">
                {activities.map((activity, index) => (
                  <div key={index} className="flex items-center p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                    <div className={`w-12 h-12 ${activity.color} rounded-full flex items-center justify-center mr-4`}>
                      <span className="text-xl">{activity.icon}</span>
                    </div>
                    <div className="flex-1 text-left">
                      <h3 className="font-bold text-gray-800">{activity.title}</h3>
                      <p className="text-gray-600">{activity.description}</p>
                    </div>
                    <Link href={activity.link}>
                      <Button variant="primary" size="sm">
                        Essayer
                      </Button>
                    </Link>
                  </div>
                ))}
              </div>
              
              <div className="mt-8 p-4 bg-blue-50 rounded-lg border-l-4 border-blue-500">
                <p className="text-blue-800">
                  💡 <strong>Conseil :</strong> Commence par ce qui t'intéresse le plus ! 
                  Tu peux toujours revenir à l'accueil pour essayer autre chose.
                </p>
              </div>
              
              <div className="mt-6">
                <Link href="/">
                  <Button variant="secondary" className="w-full">
                    Retour à l'accueil
                  </Button>
                </Link>
              </div>
            </Card>
          )}
        </div>
      </div>
    </div>
  );
}
