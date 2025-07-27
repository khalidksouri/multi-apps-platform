import React, { useState } from 'react';
import { ChevronDown, Star, Globe, Users, BookOpen, Trophy, Zap } from 'lucide-react';
import { Modal, LanguageSelector, FeatureCard } from './ui';
import { PricingCard } from './pricing';
import { useModal } from '@/hooks';
import { LANGUAGES, FEATURES, PRICING_PLANS } from '@/lib/constants';
import { trackPlanSelection, trackLanguageChange, trackModalOpen } from '@/utils/analytics';

export default function ImprovedHomePage() {
  const [selectedLanguage, setSelectedLanguage] = useState(LANGUAGES[0]);
  const [selectedPeriod, setSelectedPeriod] = useState<keyof typeof PRICING_PLANS>('monthly');
  const pricingModal = useModal();

  const handleLanguageChange = (language: any) => {
    trackLanguageChange(selectedLanguage.code, language.code);
    setSelectedLanguage(language);
  };

  const handlePlanSelect = (planId: string) => {
    trackPlanSelection(planId, selectedPeriod);
    pricingModal.closeModal();
    // Ici vous pourriez rediriger vers la page de paiement
    console.log('Plan sélectionné:', planId, 'Période:', selectedPeriod);
  };

  const handlePricingModalOpen = () => {
    trackModalOpen('pricing');
    pricingModal.openModal();
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-indigo-50">
      {/* Header amélioré */}
      <header className="sticky top-0 z-40 bg-white/90 backdrop-blur-lg border-b border-gray-200/50 shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            
            {/* Logo avec animation */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-110 hover:rotate-3 transition-all duration-300 cursor-pointer">
                <span className="text-white font-bold text-xl">M4C</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math pour enfants</h1>
                <p className="text-sm text-gray-600">L'app n°1 des familles</p>
              </div>
            </div>

            {/* Statistiques en temps réel */}
            <div className="hidden md:flex items-center space-x-6">
              <div className="flex items-center space-x-2 text-green-600">
                <Users className="w-4 h-4" />
                <span className="font-semibold">100k+ familles</span>
              </div>
              <div className="flex items-center space-x-2 text-blue-600">
                <Globe className="w-4 h-4" />
                <span className="font-semibold">47+ langues</span>
              </div>
            </div>

            {/* Sélecteur de langue */}
            <LanguageSelector
              languages={LANGUAGES}
              selectedLanguage={selectedLanguage}
              onLanguageChange={handleLanguageChange}
            />
          </div>
        </div>
      </header>

      {/* Section Hero */}
      <main className="relative">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          
          {/* Badge de confiance */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center space-x-2 bg-green-100 text-green-800 px-4 py-2 rounded-full text-sm font-medium">
              <Star className="w-4 h-4 text-green-600" />
              <span>Plus de 100k familles nous font déjà confiance !</span>
            </div>
          </div>

          {/* Titre principal */}
          <div className="text-center mb-12">
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-blue-800 bg-clip-text text-transparent mb-6">
              Apprends les maths en
              <br />
              t'amusant !
            </h1>
            <p className="text-xl md:text-2xl text-gray-600 max-w-3xl mx-auto mb-8 leading-relaxed">
              Rejoins plus de 100 000 enfants qui progressent chaque jour avec des jeux 
              interactifs, des défis passionnants et un suivi personnalisé.
            </p>
          </div>

          {/* Boutons d'action */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-16">
            <button className="group bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl">
              <span className="mr-2">🎁</span>
              Commencer gratuitement
              <div className="text-sm opacity-90 group-hover:opacity-100">Essai gratuit 14 jours</div>
            </button>
            <button
              onClick={handlePricingModalOpen}
              className="group bg-white text-blue-600 px-8 py-4 rounded-xl font-semibold text-lg border-2 border-blue-600 hover:bg-blue-50 transition-all duration-300 hover:scale-105 shadow-lg hover:shadow-xl"
            >
              <span className="mr-2">💰</span>
              Voir les prix
              <div className="text-sm opacity-75 group-hover:opacity-100">À partir de 6,99€/mois</div>
            </button>
          </div>

          {/* Section des fonctionnalités */}
          <div className="grid md:grid-cols-3 gap-8 mb-16">
            {FEATURES.map((feature) => (
              <FeatureCard key={feature.id} feature={feature} />
            ))}
          </div>

          {/* Section statistiques */}
          <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-3xl p-8 md:p-12 text-white text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-8">
              Disponible sur toutes vos plateformes
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
              {[
                { icon: '💻', title: 'Web', subtitle: 'Navigateur' },
                { icon: '📱', title: 'iOS', subtitle: 'iPhone/iPad' },
                { icon: '🤖', title: 'Android', subtitle: 'Tablette/Mobile' }
              ].map((platform, index) => (
                <div key={index} className="text-center">
                  <div className="text-6xl mb-4">{platform.icon}</div>
                  <h3 className="text-xl font-bold mb-2">{platform.title}</h3>
                  <p className="text-blue-100">{platform.subtitle}</p>
                </div>
              ))}
            </div>
            
            <div className="grid grid-cols-3 gap-8 mt-12 pt-8 border-t border-blue-500/30">
              {[
                { value: '100k+', label: 'Familles actives', desc: 'Utilisent Math4Child quotidiennement' },
                { value: '98%', label: 'Satisfaction parents', desc: 'Recommandent notre application' },
                { value: '47', label: 'Pays disponibles', desc: 'Et plus chaque mois' }
              ].map((stat, index) => (
                <div key={index} className="text-center">
                  <div className="text-3xl md:text-4xl font-bold mb-2">{stat.value}</div>
                  <div className="text-lg font-semibold mb-1">{stat.label}</div>
                  <div className="text-sm text-blue-100">{stat.desc}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>

      {/* Modal de pricing */}
      <Modal
        isOpen={pricingModal.isOpen}
        onClose={pricingModal.closeModal}
        title="Choisissez votre plan"
        subtitle="Commencez votre essai gratuit de 14 jours, annulable à tout moment"
        maxWidth="5xl"
      >
        {/* Sélecteur de période */}
        <div className="flex justify-center mb-8">
          <div className="bg-gray-100 rounded-xl p-1 flex">
            {[
              { key: 'monthly' as const, label: 'Mensuel' },
              { key: 'quarterly' as const, label: 'Trimestriel', badge: '10% de réduction' },
              { key: 'annual' as const, label: 'Annuel', badge: '30% de réduction' }
            ].map((period) => (
              <button
                key={period.key}
                onClick={() => setSelectedPeriod(period.key)}
                className={`px-6 py-3 rounded-lg font-medium transition-all relative ${
                  selectedPeriod === period.key
                    ? 'bg-white text-blue-600 shadow-md'
                    : 'text-gray-600 hover:text-gray-900'
                }`}
              >
                {period.label}
                {period.badge && (
                  <div className="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full whitespace-nowrap">
                    {period.badge}
                  </div>
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Grille des plans */}
        <div className="grid md:grid-cols-3 gap-6">
          {PRICING_PLANS[selectedPeriod].map((plan) => (
            <PricingCard
              key={plan.id}
              plan={plan}
              onSelect={handlePlanSelect}
            />
          ))}
        </div>

        {/* Footer du modal */}
        <div className="text-center mt-8 pt-6 border-t border-gray-200">
          <p className="text-sm text-gray-600 mb-2">
            ✅ Essai gratuit de 14 jours • ✅ Annulation à tout moment • ✅ Garantie satisfait ou remboursé
          </p>
          <p className="text-xs text-gray-500">
            Les prix sont en euros, TVA incluse. Facturation récurrente, résiliable à tout moment.
          </p>
        </div>
      </Modal>
    </div>
  );
}
