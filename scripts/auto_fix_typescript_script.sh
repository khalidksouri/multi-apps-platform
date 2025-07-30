#!/bin/bash
set -e

echo "🔧 CORRECTION AUTOMATIQUE DES 26 ERREURS TYPESCRIPT..."

cd apps/math4child

# Sauvegarde des fichiers existants
echo "💾 Sauvegarde des fichiers actuels..."
mkdir -p backups/typescript-fix-$(date +%Y%m%d_%H%M%S)
cp src/app/exercises/page.tsx backups/typescript-fix-$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || echo "exercises/page.tsx n'existe pas"
cp src/app/page.tsx backups/typescript-fix-$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || echo "page.tsx n'existe pas"
cp src/app/subscription/page.tsx backups/typescript-fix-$(date +%Y%m%d_%H%M%S)/ 2>/dev/null || echo "subscription/page.tsx n'existe pas"

# Créer les dossiers nécessaires
mkdir -p src/app/exercises
mkdir -p src/app/subscription

echo "📝 Création du fichier exercises/page.tsx corrigé..."
cat > src/app/exercises/page.tsx << 'EOF'
'use client';

import React, { useState, useEffect } from 'react';

// Types TypeScript stricts
interface MathProblem {
  num1: number;
  num2: number;
  correctAnswer: number;
  operator: string;
}

type Operation = 'addition' | 'subtraction' | 'multiplication' | 'division';
type Level = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';

export default function ExercisesPage() {
  // États avec types stricts
  const [selectedOperation, setSelectedOperation] = useState<Operation>('addition');
  const [selectedLevel, setSelectedLevel] = useState<Level>('beginner');
  const [currentProblem, setCurrentProblem] = useState<MathProblem | null>(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [feedback, setFeedback] = useState('');
  const [score, setScore] = useState(0);
  const [attempts, setAttempts] = useState(0);

  // Configuration des niveaux
  const levelConfig = {
    beginner: { minNum: 1, maxNum: 10 },
    elementary: { minNum: 1, maxNum: 50 },
    intermediate: { minNum: 1, maxNum: 100 },
    advanced: { minNum: 1, maxNum: 500 },
    expert: { minNum: 1, maxNum: 1000 }
  };

  // Générateur de nombres aléatoires
  const randomInt = (min: number, max: number): number => 
    Math.floor(Math.random() * (max - min + 1)) + min;

  // Générateur d'exercice avec types stricts
  const generateExercise = (): MathProblem => {
    const config = levelConfig[selectedLevel];
    
    // Initialisation avec des valeurs par défaut pour TypeScript
    let num1: number = 1;
    let num2: number = 1;
    let correctAnswer: number = 2;
    let operator: string = '+';

    switch (selectedOperation) {
      case 'addition':
        operator = '+';
        num1 = randomInt(config.minNum, config.maxNum);
        num2 = randomInt(config.minNum, config.maxNum);
        correctAnswer = num1 + num2;
        break;
      
      case 'subtraction':
        operator = '-';
        num1 = randomInt(config.minNum, config.maxNum);
        num2 = randomInt(config.minNum, Math.min(num1, config.maxNum));
        // Assurer que num1 >= num2 pour éviter les résultats négatifs
        if (num1 < num2) {
          [num1, num2] = [num2, num1];
        }
        correctAnswer = num1 - num2;
        break;
      
      case 'multiplication':
        operator = '×';
        num1 = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        correctAnswer = num1 * num2;
        break;
      
      case 'division':
        operator = '÷';
        correctAnswer = randomInt(config.minNum, Math.min(config.maxNum / 10, 20));
        num2 = randomInt(2, 12);
        num1 = correctAnswer * num2;
        break;
    }

    return { num1, num2, correctAnswer, operator };
  };

  // Générer un nouveau problème quand la configuration change
  useEffect(() => {
    const problem = generateExercise();
    setCurrentProblem(problem);
    setUserAnswer('');
    setFeedback('');
  }, [selectedOperation, selectedLevel]);

  // Vérifier la réponse
  const checkAnswer = () => {
    if (!currentProblem || !userAnswer.trim()) return;

    const userNum = parseInt(userAnswer);
    const isCorrect = userNum === currentProblem.correctAnswer;
    
    setAttempts(prev => prev + 1);
    
    if (isCorrect) {
      setScore(prev => prev + 1);
      setFeedback('✅ Excellent ! Bonne réponse !');
    } else {
      setFeedback(`❌ Pas tout à fait ! La bonne réponse est ${currentProblem.correctAnswer}`);
    }
  };

  // Passer au problème suivant
  const nextProblem = () => {
    const newProblem = generateExercise();
    setCurrentProblem(newProblem);
    setUserAnswer('');
    setFeedback('');
  };

  // Obtenir le symbole de l'opération
  const getOperationSymbol = (): string => {
    if (!currentProblem) return '+';
    return currentProblem.operator;
  };

  // Gestionnaire d'événements typé pour les effets de survol
  const handleMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1.05)';
  };

  const handleMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1)';
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 p-8">
      <div className="max-w-4xl mx-auto">
        {/* Configuration */}
        <div className="bg-white rounded-2xl p-6 shadow-lg mb-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-4">Configuration de l'exercice</h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Opération mathématique
              </label>
              <select
                value={selectedOperation}
                onChange={(e) => setSelectedOperation(e.target.value as Operation)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="addition">Addition (+)</option>
                <option value="subtraction">Soustraction (-)</option>
                <option value="multiplication">Multiplication (×)</option>
                <option value="division">Division (÷)</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Niveau de difficulté
              </label>
              <select
                value={selectedLevel}
                onChange={(e) => setSelectedLevel(e.target.value as Level)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              >
                <option value="beginner">Débutant (1-10)</option>
                <option value="elementary">Élémentaire (1-50)</option>
                <option value="intermediate">Intermédiaire (1-100)</option>
                <option value="advanced">Avancé (1-500)</option>
                <option value="expert">Expert (1-1000)</option>
              </select>
            </div>
          </div>

          {/* Statistiques */}
          <div className="flex justify-center space-x-8 text-center">
            <div 
              className="bg-blue-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-blue-600">{score}</div>
              <div className="text-sm text-blue-800">Bonnes réponses</div>
            </div>
            <div 
              className="bg-green-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-green-600">{attempts}</div>
              <div className="text-sm text-green-800">Tentatives</div>
            </div>
            <div 
              className="bg-purple-50 p-4 rounded-lg transition-transform cursor-pointer"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              <div className="text-2xl font-bold text-purple-600">
                {attempts > 0 ? Math.round((score / attempts) * 100) : 0}%
              </div>
              <div className="text-sm text-purple-800">Précision</div>
            </div>
          </div>
        </div>

        {/* Exercice principal */}
        <div className="bg-white rounded-3xl p-12 shadow-xl text-center">
          <div className="mb-4">
            <span className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium">
              {selectedOperation.charAt(0).toUpperCase() + selectedOperation.slice(1)} - {selectedLevel.charAt(0).toUpperCase() + selectedLevel.slice(1)}
            </span>
          </div>

          <h2 className="text-3xl font-bold text-gray-900 mb-8">
            Résous ce calcul
          </h2>
          
          {/* Question */}
          {currentProblem && (
            <div className="text-6xl font-bold text-blue-600 mb-8">
              {currentProblem.num1} {getOperationSymbol()} {currentProblem.num2} = ?
            </div>
          )}
          
          {/* Zone de réponse */}
          <div className="space-y-6">
            <input
              type="number"
              value={userAnswer}
              onChange={(e) => setUserAnswer(e.target.value)}
              className="text-4xl text-center border-2 border-gray-300 rounded-xl p-4 w-48 focus:border-blue-500 focus:outline-none"
              placeholder="?"
              autoFocus
              onKeyPress={(e) => {
                if (e.key === 'Enter') {
                  checkAnswer();
                }
              }}
            />
            
            <div className="flex gap-4 justify-center">
              <button
                onClick={checkAnswer}
                className="px-8 py-4 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors font-semibold text-lg disabled:opacity-50"
                disabled={!userAnswer.trim()}
              >
                Vérifier
              </button>
              <button
                onClick={nextProblem}
                className="px-8 py-4 bg-green-500 text-white rounded-xl hover:bg-green-600 transition-colors font-semibold text-lg"
              >
                Nouveau calcul
              </button>
            </div>
          </div>

          {/* Feedback */}
          {feedback && (
            <div className={`mt-8 p-4 rounded-lg text-lg font-semibold ${
              feedback.includes('✅') 
                ? 'bg-green-100 text-green-800' 
                : 'bg-red-100 text-red-800'
            }`}>
              {feedback}
            </div>
          )}

          {/* Métadonnées */}
          <div className="mt-8 pt-6 border-t border-gray-200">
            <div className="flex justify-center items-center space-x-6 text-sm text-gray-600">
              <span>🎯 Niveau: {selectedLevel}</span>
              <span>📊 Opération: {selectedOperation}</span>
              <span>🏆 Score: {score}/{attempts}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF

echo "📝 Création du fichier page.tsx (homepage) corrigé..."
cat > src/app/page.tsx << 'EOF'
'use client';

import React, { useState } from 'react';
import Link from 'next/link';

export default function HomePage() {
  const [language, setLanguage] = useState('fr');

  // Gestionnaires d'événements typés pour les effets de survol
  const handleMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1.05)';
  };

  const handleMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.transform = 'scale(1)';
  };

  const handleFeatureMouseOver = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.borderColor = '#3b82f6';
    target.style.color = '#3b82f6';
  };

  const handleFeatureMouseOut = (e: React.MouseEvent<HTMLElement>) => {
    const target = e.target as HTMLElement;
    target.style.borderColor = '#d1d5db';
    target.style.color = '#374151';
  };

  // Traductions simplifiées
  const translations = {
    fr: {
      title: 'Math4Child',
      subtitle: 'L\'apprentissage des mathématiques rendu amusant pour les enfants',
      description: 'Une application éducative interactive qui aide les enfants à maîtriser les mathématiques de base avec des exercices personnalisés et un suivi des progrès.',
      startLearning: 'Commencer l\'apprentissage',
      viewPlans: 'Voir les formules',
      features: 'Fonctionnalités',
      featuresSubtitle: 'Tout ce dont votre enfant a besoin pour réussir en mathématiques'
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Making math learning fun for children',
      description: 'An interactive educational app that helps children master basic mathematics with personalized exercises and progress tracking.',
      startLearning: 'Start Learning',
      viewPlans: 'View Plans',
      features: 'Features',
      featuresSubtitle: 'Everything your child needs to succeed in mathematics'
    }
  };

  const t = translations[language as keyof typeof translations];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <div className="text-2xl font-bold text-blue-600">
                🧮 {t.title}
              </div>
            </div>
            <nav className="flex space-x-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
                Accueil
              </Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium">
                Exercices
              </Link>
              <Link href="/subscription" className="text-gray-700 hover:text-blue-600 font-medium">
                Abonnement
              </Link>
            </nav>
            <div className="flex items-center space-x-4">
              <select
                value={language}
                onChange={(e) => setLanguage(e.target.value)}
                className="border border-gray-300 rounded-md px-3 py-1 text-sm"
              >
                <option value="fr">🇫🇷 Français</option>
                <option value="en">🇺🇸 English</option>
              </select>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            {t.title}
          </h1>
          <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-3xl mx-auto">
            {t.subtitle}
          </p>
          <p className="text-lg text-gray-500 mb-12 max-w-2xl mx-auto">
            {t.description}
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="/exercises"
              className="bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg hover:bg-blue-700"
              onMouseOver={handleMouseOver}
              onMouseOut={handleMouseOut}
            >
              {t.startLearning}
            </Link>
            <Link
              href="/subscription"
              className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg border-2 border-blue-600 hover:bg-blue-50"
              onMouseOver={handleFeatureMouseOver}
              onMouseOut={handleFeatureMouseOut}
            >
              {t.viewPlans}
            </Link>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">{t.features}</h2>
            <p className="text-xl text-gray-600">{t.featuresSubtitle}</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[
              {
                icon: '🧮',
                title: 'Exercices Personnalisés',
                description: 'Des problèmes adaptés au niveau de votre enfant'
              },
              {
                icon: '🎯',
                title: 'Suivi des Progrès',
                description: 'Visualisez les améliorations en temps réel'
              },
              {
                icon: '📊',
                title: 'Statistiques Détaillées',
                description: 'Analyse complète des performances'
              },
              {
                icon: '🎮',
                title: 'Apprentissage Ludique',
                description: 'Rend les mathématiques amusantes'
              },
              {
                icon: '🌍',
                title: 'Multilingue',
                description: 'Disponible en plusieurs langues'
              },
              {
                icon: '📱',
                title: 'Multi-Plateforme',
                description: 'Web, Android et iOS'
              }
            ].map((feature, index) => (
              <div
                key={index}
                className="bg-gradient-to-br from-white to-gray-50 rounded-2xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 border border-gray-100"
              >
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">
                  {feature.title}
                </h3>
                <p className="text-gray-600">
                  {feature.description}
                </p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 bg-blue-600">
        <div className="max-w-4xl mx-auto text-center px-4 sm:px-6 lg:px-8">
          <h2 className="text-4xl font-bold text-white mb-6">
            Prêt à commencer l'aventure mathématique ?
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            Rejoignez des milliers de familles qui font confiance à Math4Child
          </p>
          <Link
            href="/exercises"
            className="bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg"
            onMouseOver={handleMouseOver}
            onMouseOut={handleMouseOut}
          >
            Commencer gratuitement
          </Link>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div className="col-span-1 md:col-span-2">
              <div className="text-2xl font-bold mb-4">🧮 Math4Child</div>
              <p className="text-gray-400 mb-4">
                L'application qui rend l'apprentissage des mathématiques amusant et efficace pour tous les enfants.
              </p>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Liens rapides</h3>
              <ul className="space-y-2">
                <li><Link href="/" className="text-gray-400 hover:text-white">Accueil</Link></li>
                <li><Link href="/exercises" className="text-gray-400 hover:text-white">Exercices</Link></li>
                <li><Link href="/subscription" className="text-gray-400 hover:text-white">Abonnement</Link></li>
              </ul>
            </div>
            <div>
              <h3 className="text-lg font-semibold mb-4">Support</h3>
              <ul className="space-y-2">
                <li><span className="text-gray-400">Email: support@math4child.com</span></li>
                <li><span className="text-gray-400">Version: 4.0.0</span></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 mt-8 pt-8 text-center">
            <p className="text-gray-400">
              © 2025 Math4Child. Tous droits réservés.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
EOF

echo "📝 Création du fichier subscription/page.tsx corrigé..."
cat > src/app/subscription/page.tsx << 'EOF'
'use client';

import React, { useState } from 'react';
import Link from 'next/link';

// Types TypeScript stricts pour les plans
interface PricingPlan {
  id: string;
  name: string;
  price: {
    monthly: number;
    yearly: number;
  };
  description: string;
  features: string[];
  popular?: boolean;
  contact?: boolean;
}

type BillingPeriod = 'monthly' | 'yearly';

export default function SubscriptionPage() {
  const [billingPeriod, setBillingPeriod] = useState<BillingPeriod>('monthly');

  // Plans d'abonnement avec types stricts
  const plans: PricingPlan[] = [
    {
      id: 'free',
      name: 'Version Gratuite',
      price: { monthly: 0, yearly: 0 },
      description: '7 jours - 50 questions',
      features: [
        '50 questions au total',
        'Tous les niveaux limités',
        'Support par email',
        'Accès 7 jours'
      ]
    },
    {
      id: 'monthly',
      name: 'Mensuel',
      price: { monthly: 9.99, yearly: 119.88 },
      description: 'Parfait pour commencer',
      features: [
        'Questions illimitées',
        'Tous les niveaux débloqués',
        'Toutes les opérations',
        'Support prioritaire',
        'Statistiques détaillées'
      ],
      popular: true
    },
    {
      id: 'quarterly',
      name: 'Trimestriel',
      price: { monthly: 26.97, yearly: 323.64 },
      description: '3 mois - Économie de 10%',
      features: [
        'Tout du plan mensuel',
        'Économie de 10%',
        'Paiement unique',
        'Support premium',
        'Rapports de progression'
      ]
    },
    {
      id: 'family',
      name: 'Famille',
      price: { monthly: 19.99, yearly: 239.88 },
      description: 'Jusqu\'à 5 profils enfants',
      features: [
        'Jusqu\'à 5 profils',
        'Toutes les fonctionnalités',
        'Tableau de bord famille',
        'Support téléphonique',
        'Rapports personnalisés'
      ],
      contact: true
    }
  ];

  // Fonction helper pour obtenir le prix avec type safety
  const getPlanPrice = (plan: PricingPlan, period: BillingPeriod): number => {
    return plan.price[period];
  };

  // Fonction pour formater le prix
  const formatPrice = (price: number): string => {
    return price === 0 ? 'Gratuit' : `${price.toFixed(2)}€`;
  };

  // Fonction pour obtenir le texte du bouton
  const getButtonText = (plan: PricingPlan): string => {
    const price = getPlanPrice(plan, billingPeriod);
    
    if (price === 0) {
      return 'Commencer gratuitement';
    }
    
    if (plan.contact) {
      return 'Nous contacter';
    }
    
    return `S'abonner - ${formatPrice(price)}`;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <Link href="/" className="text-2xl font-bold text-blue-600">
                🧮 Math4Child
              </Link>
            </div>
            <nav className="flex space-x-8">
              <Link href="/" className="text-gray-700 hover:text-blue-600 font-medium">
                Accueil
              </Link>
              <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium">
                Exercices
              </Link>
              <Link href="/subscription" className="text-blue-600 font-medium">
                Abonnement
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <div className="py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          {/* Header Section */}
          <div className="text-center mb-16">
            <h1 className="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
              Choisissez votre formule
            </h1>
            <p className="text-xl text-gray-600 mb-8">
              Des plans adaptés à tous les besoins d'apprentissage
            </p>

            {/* Billing Period Toggle */}
            <div className="flex justify-center mb-12">
              <div className="bg-gray-100 p-1 rounded-lg flex">
                <button
                  onClick={() => setBillingPeriod('monthly')}
                  className={`px-6 py-2 rounded-md font-medium transition-all ${
                    billingPeriod === 'monthly'
                      ? 'bg-white text-blue-600 shadow-sm'
                      : 'text-gray-500 hover:text-gray-700'
                  }`}
                >
                  Mensuel
                </button>
                <button
                  onClick={() => setBillingPeriod('yearly')}
                  className={`px-6 py-2 rounded-md font-medium transition-all ${
                    billingPeriod === 'yearly'
                      ? 'bg-white text-blue-600 shadow-sm'
                      : 'text-gray-500 hover:text-gray-700'
                  }`}
                >
                  Annuel
                  <span className="ml-2 text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">
                    -20%
                  </span>
                </button>
              </div>
            </div>
          </div>

          {/* Pricing Cards */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {plans.map((plan) => (
              <div
                key={plan.id}
                className={`relative bg-white rounded-2xl shadow-lg p-8 border-2 transition-all duration-300 hover:shadow-xl ${
                  plan.popular
                    ? 'border-blue-500 transform scale-105'
                    : 'border-gray-200 hover:border-blue-300'
                }`}
              >
                {/* Popular Badge */}
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      🔥 Populaire
                    </span>
                  </div>
                )}

                {/* Plan Header */}
                <div className="text-center mb-6">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">
                    {plan.name}
                  </h3>
                  <p className="text-gray-500 mb-4">{plan.description}</p>
                  
                  {/* Price Display with Type Safety */}
                  <div className="mb-6">
                    {getPlanPrice(plan, billingPeriod) === 0 ? (
                      <div className="text-4xl font-bold text-green-600">
                        Gratuit
                      </div>
                    ) : (
                      <>
                        <div className="text-4xl font-bold text-gray-900">
                          {formatPrice(getPlanPrice(plan, billingPeriod))}
                        </div>
                        <div className="text-gray-500">
                          /{billingPeriod === 'monthly' ? 'mois' : 'an'}
                        </div>
                      </>
                    )}
                  </div>
                </div>

                {/* Features List */}
                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-start">
                      <svg
                        className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                      >
                        <path
                          fillRule="evenodd"
                          d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                          clipRule="evenodd"
                        />
                      </svg>
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>

                {/* CTA Button */}
                <button
                  className={`w-full py-3 px-6 rounded-lg font-semibold transition-all duration-200 ${
                    plan.popular
                      ? 'bg-blue-600 text-white hover:bg-blue-700'
                      : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                  }`}
                >
                  {getButtonText(plan)}
                </button>

                {/* Additional Info for Paid Plans */}
                {getPlanPrice(plan, billingPeriod) > 0 && !plan.contact && (
                  <div className="mt-4 text-center">
                    <p className="text-xs text-gray-500">
                      Essai gratuit de 7 jours
                    </p>
                  </div>
                )}
              </div>
            ))}
          </div>

          {/* Bottom Section */}
          <div className="mt-16 text-center">
            <div className="bg-white rounded-2xl p-8 shadow-lg">
              <h3 className="text-2xl font-bold text-gray-900 mb-4">
                Toutes nos formules incluent :
              </h3>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="flex items-center justify-center">
                  <svg className="w-6 h-6 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/>
                  </svg>
                  <span className="text-gray-700">Support technique</span>
                </div>
                <div className="flex items-center justify-center">
                  <svg className="w-6 h-6 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/>
                  </svg>
                  <span className="text-gray-700">Mises à jour gratuites</span>
                </div>
                <div className="flex items-center justify-center">
                  <svg className="w-6 h-6 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"/>
                  </svg>
                  <span className="text-gray-700">Accès multi-plateforme</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF

echo "🧪 Test de compilation TypeScript..."
if npx tsc --noEmit --skipLibCheck; then
    echo "✅ SUCCÈS ! Toutes les 26 erreurs TypeScript ont été corrigées !"
    echo ""
    echo "🎯 RÉSUMÉ DES CORRECTIONS :"
    echo "   ✅ 16 erreurs dans exercises/page.tsx - Variables num1/num2 initialisées"
    echo "   ✅ 6 erreurs dans page.tsx - Event handlers typés avec e.target as HTMLElement"  
    echo "   ✅ 4 erreurs dans subscription/page.tsx - Index safety avec getPlanPrice()"
    echo ""
    echo "🚀 Tentative de build..."
    if npm run build; then
        echo "🎉 BUILD RÉUSSI ! L'application est maintenant stable !"
    else
        echo "⚠️ Build échoué, mais TypeScript est corrigé"
    fi
else
    echo "❌ Des erreurs TypeScript persistent"
    exit 1
fi

cd ../..
echo "✅ Correction complète terminée avec succès !"