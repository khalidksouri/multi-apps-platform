'use client';

import { useState } from 'react';
import { Star } from 'lucide-react';
import { FEATURES } from '@/lib/constants';
import { FeatureCard } from '@/components/ui/FeatureCard';
import { UNIVERSAL_LANGUAGES } from '@/lib/i18n/languages';

// Interface pour le sélecteur de langue simplifié
interface SimplifiedLanguage {
  code: string;
  name: string;
  flag: string;
}

interface SimplifiedLanguageSelectorProps {
  selectedLanguage: SimplifiedLanguage;
  onLanguageChange: (language: SimplifiedLanguage) => void;
}

function SimplifiedLanguageSelector({ selectedLanguage, onLanguageChange }: SimplifiedLanguageSelectorProps) {
  const [isOpen, setIsOpen] = useState(false);
  
  return (
    <div className="relative">
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center space-x-2 px-4 py-2 bg-white border border-gray-300 rounded-lg shadow-sm hover:bg-gray-50"
      >
        <span className="text-xl">{selectedLanguage.flag}</span>
        <span className="font-medium">{selectedLanguage.name}</span>
      </button>
      
      {isOpen && (
        <div className="absolute right-0 mt-2 w-64 bg-white border border-gray-200 rounded-lg shadow-lg max-h-64 overflow-y-auto z-50">
          {UNIVERSAL_LANGUAGES.map((language) => (
            <button
              key={language.code}
              onClick={() => {
                onLanguageChange({
                  code: language.code,
                  name: language.name,
                  flag: language.flag
                });
                setIsOpen(false);
              }}
              className={`w-full px-4 py-3 text-left hover:bg-gray-50 flex items-center space-x-3 ${
                selectedLanguage.code === language.code ? 'bg-indigo-50 text-indigo-600' : 'text-gray-700'
              }`}
            >
              <span className="text-2xl">{language.flag}</span>
              <span className="font-medium">{language.name}</span>
            </button>
          ))}
        </div>
      )}
    </div>
  );
}

// Interface pour les plans de pricing
interface PricingPlan {
  id: string;
  name: string;
  price: string;
  features: string[];
}

// Plans de pricing avec typage strict - FIX erreur ligne 87
const PRICING_PLANS: Record<string, PricingPlan[]> = {
  'monthly': [
    { id: 'free', name: 'Gratuit', price: '0€', features: ['1 profil', 'Exercices de base'] },
    { id: 'premium', name: 'Premium', price: '4.99€', features: ['3 profils', 'Tous les exercices'] },
    { id: 'family', name: 'Famille', price: '6.99€', features: ['5 profils', 'Rapports parents'] }
  ],
  'yearly': [
    { id: 'free', name: 'Gratuit', price: '0€', features: ['1 profil', 'Exercices de base'] },
    { id: 'premium', name: 'Premium', price: '41.94€', features: ['3 profils', 'Tous les exercices'] },
    { id: 'family', name: 'Famille', price: '58.32€', features: ['5 profils', 'Rapports parents'] }
  ]
};

// Fonction avec assertion stricte pour garantir le retour - FIX erreur ligne 87
const getPricingPlans = (period: string): PricingPlan[] => {
  const plans = PRICING_PLANS[period];
  if (!plans) {
    // Retour avec assertion de type explicite
    return PRICING_PLANS['monthly'] as PricingPlan[];
  }
  return plans as PricingPlan[];
};

export default function ImprovedHomePage() {
  // Initialisation stricte avec assertion
  const [selectedLanguage, setSelectedLanguage] = useState<SimplifiedLanguage>(() => {
    const firstLanguage = UNIVERSAL_LANGUAGES[0];
    if (!firstLanguage) {
      throw new Error('UNIVERSAL_LANGUAGES ne peut pas être vide');
    }
    return {
      code: firstLanguage.code,
      name: firstLanguage.name,
      flag: firstLanguage.flag
    };
  });
  
  const [selectedPeriod, setSelectedPeriod] = useState<'monthly' | 'yearly'>('monthly');

  const trackLanguageChange = (oldLang: string, newLang: string) => {
    console.log(`Langue changée: ${oldLang} → ${newLang}`);
  };

  const trackPlanSelection = (planId: string, period: string) => {
    console.log(`Plan sélectionné: ${planId} (${period})`);
  };

  const handleLanguageChange = (language: SimplifiedLanguage) => {
    trackLanguageChange(selectedLanguage.code, language.code);
    setSelectedLanguage(language);
  };

  const handlePlanSelect = (planId: string) => {
    trackPlanSelection(planId, selectedPeriod);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="flex justify-between items-center mb-12">
          <div className="flex items-center space-x-4">
            <div className="w-12 h-12 bg-indigo-600 rounded-xl flex items-center justify-center">
              <span className="text-white text-xl font-bold">M4C</span>
            </div>
            <h1 className="text-3xl font-bold text-indigo-900">Math4Child</h1>
          </div>
          
          <SimplifiedLanguageSelector 
            selectedLanguage={selectedLanguage}
            onLanguageChange={handleLanguageChange}
          />
        </header>

        {/* Hero Section */}
        <section className="text-center mb-16">
          <h2 className="text-6xl font-bold text-gray-900 mb-6">
            Apprends les maths en t'amusant
          </h2>
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            L'application éducative n°1 qui transforme l'apprentissage des mathématiques 
            en aventure passionnante pour toute la famille.
          </p>
          <button className="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
            Commencer gratuitement
          </button>
        </section>

        {/* Features Section */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Pourquoi choisir Math4Child ?
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {FEATURES.map((feature) => (
              <FeatureCard 
                key={feature.id} 
                feature={{
                  ...feature,
                  gradient: 'from-indigo-500 to-purple-600'
                }} 
              />
            ))}
          </div>
        </section>

        {/* Stats Section */}
        <section className="mb-16">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="text-center p-6 bg-white rounded-lg shadow-sm">
              <div className="text-4xl font-bold text-indigo-600 mb-2">100k+</div>
              <div className="text-gray-600">familles satisfaites</div>
            </div>
            <div className="text-center p-6 bg-white rounded-lg shadow-sm">
              <div className="text-4xl font-bold text-indigo-600 mb-2">98%</div>
              <div className="text-gray-600">de satisfaction</div>
            </div>
            <div className="text-center p-6 bg-white rounded-lg shadow-sm">
              <div className="text-4xl font-bold text-indigo-600 mb-2">47</div>
              <div className="text-gray-600">langues disponibles</div>
            </div>
          </div>
        </section>

        {/* Pricing Section */}
        <section className="mb-16">
          <h3 className="text-3xl font-bold text-center text-gray-900 mb-8">
            Choisissez votre plan
          </h3>
          
          {/* Period Selector */}
          <div className="flex justify-center mb-8">
            <div className="bg-white rounded-lg p-1 shadow-sm">
              <button
                onClick={() => setSelectedPeriod('monthly')}
                className={`px-6 py-2 rounded-md transition-colors ${
                  selectedPeriod === 'monthly' 
                    ? 'bg-indigo-600 text-white' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                Mensuel
              </button>
              <button
                onClick={() => setSelectedPeriod('yearly')}
                className={`px-6 py-2 rounded-md transition-colors ${
                  selectedPeriod === 'yearly' 
                    ? 'bg-indigo-600 text-white' 
                    : 'text-gray-600 hover:text-gray-800'
                }`}
              >
                Annuel (-30%)
              </button>
            </div>
          </div>
          
          {/* Pricing Cards - Utilisation de la fonction corrigée */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {getPricingPlans(selectedPeriod).map((plan: PricingPlan) => (
              <div key={plan.id} className="bg-white rounded-lg shadow-sm p-6">
                <h4 className="text-xl font-bold text-gray-900 mb-4">{plan.name}</h4>
                <div className="text-3xl font-bold text-indigo-600 mb-6">{plan.price}</div>
                <ul className="space-y-2 mb-6">
                  {plan.features.map((feature, index) => (
                    <li key={index} className="flex items-center space-x-2">
                      <Star className="w-4 h-4 text-indigo-600" />
                      <span className="text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
                <button 
                  onClick={() => handlePlanSelect(plan.id)}
                  className="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2 px-4 rounded-lg transition-colors"
                >
                  Choisir ce plan
                </button>
              </div>
            ))}
          </div>
        </section>
      </div>
    </div>
  );
}
