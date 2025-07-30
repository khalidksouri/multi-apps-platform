#!/bin/bash

# ===================================================================
# 📚 AJOUT PLAN ÉCOLES ET ASSOCIATIONS - MATH4CHILD
# Ajoute le plan éducatif institutionnel manquant
# ===================================================================

set -euo pipefail

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${CYAN}${BOLD}📚 AJOUT PLAN ÉCOLES ET ASSOCIATIONS${NC}"
echo -e "${CYAN}${BOLD}====================================${NC}"
echo ""

# Vérifier le dossier
if [ ! -d "apps/math4child" ]; then
    echo -e "${RED}❌ Erreur: Dossier apps/math4child introuvable${NC}"
    exit 1
fi

cd "apps/math4child"

echo -e "${YELLOW}📋 Mise à jour de la page avec le plan Écoles...${NC}"

# ===================================================================
# MISE À JOUR DE LA PAGE AVEC 4 PLANS D'ABONNEMENT
# ===================================================================

cat > "src/app/page.tsx" << 'EOF'
'use client'

import { LanguageProvider, useLanguage } from '../hooks/LanguageContext'
import { SUPPORTED_LANGUAGES } from '../language-config'
import { useState } from 'react'

function LoadingSpinner() {
  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
    </div>
  )
}

function HomeContent() {
  const { t, currentLanguage, changeLanguage, stats, isRTL, isLoading } = useLanguage()
  const [selectedPlan, setSelectedPlan] = useState<'monthly' | 'quarterly' | 'annual'>('quarterly')
  
  if (isLoading) {
    return <LoadingSpinner />
  }

  // Plans d'abonnement complets avec plan Écoles
  const getLocalizedText = (key: string, fallback: string) => {
    return (t as any)[key] || fallback
  }

  const pricingPlans = {
    free: {
      name: getLocalizedText('freeVersion', 'Version Gratuite'),
      price: getLocalizedText('free', 'Gratuit'),
      features: [
        '5 exercices par jour',
        '2 niveaux de difficulté',
        '5 langues disponibles',
        'Statistiques de base',
        'Accès limité aux ressources'
      ]
    },
    premium: {
      name: getLocalizedText('premiumPlan', 'Premium'),
      monthlyPrice: 4.99,
      quarterlyPrice: 11.99,
      annualPrice: 39.99,
      popular: true,
      features: [
        'Exercices illimités',
        '5 niveaux de difficulté',
        '20 langues + support RTL',
        'Statistiques avancées',
        'Mode hors ligne',
        'Suivi des progrès détaillé',
        'Jeux éducatifs premium',
        'Support prioritaire'
      ]
    },
    family: {
      name: getLocalizedText('familyPlan', 'Famille'),
      monthlyPrice: 9.99,
      quarterlyPrice: 24.99,
      annualPrice: 79.99,
      recommended: true,
      features: [
        'Tout de Premium',
        'Jusqu\'à 6 profils enfants',
        'Contrôle parental avancé',
        'Rapports de progression',
        'Mode collaboratif',
        'Défis familiaux',
        'Récompenses virtuelles',
        'Support éducateur dédié'
      ]
    },
    education: {
      name: getLocalizedText('educationPlan', 'Écoles & Associations'),
      monthlyPrice: 19.99,
      quarterlyPrice: 54.99,
      annualPrice: 199.99,
      institutional: true,
      features: [
        'Tout de Famille inclus',
        'Jusqu\'à 30 profils élèves',
        'Tableau de bord enseignant',
        'Rapports de classe détaillés',
        'Curriculum personnalisable',
        'Exercices par matière',
        'Support pédagogique dédié',
        'Formation des enseignants',
        'Facturation institutionnelle',
        'Accès administrateur'
      ]
    }
  }

  return (
    <div className={`min-h-screen ${isRTL ? 'rtl' : 'ltr'}`}>
      {/* Header professionnel */}
      <header className="bg-white shadow-sm border-b sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center">
              <span className="text-2xl font-bold text-blue-600">🧮 {t.appName}</span>
            </div>
            <select 
              value={currentLanguage.code}
              onChange={(e) => changeLanguage(e.target.value)}
              className="px-3 py-2 border-2 border-blue-200 rounded-lg bg-white shadow-sm hover:border-blue-400 transition-colors duration-200 focus:outline-none focus:border-blue-600"
              data-testid="language-selector"
            >
              {SUPPORTED_LANGUAGES.map((lang) => (
                <option key={lang.code} value={lang.code}>
                  {lang.flag} {lang.nativeName}
                </option>
              ))}
            </select>
          </div>
        </div>
      </header>

      {/* Section Hero */}
      <section className="bg-gradient-to-br from-blue-50 to-purple-50 py-20">
        <div className="max-w-4xl mx-auto text-center px-4">
          <div className="mb-4">
            <span className="inline-block bg-blue-100 text-blue-800 px-4 py-2 rounded-full text-sm font-medium">
              {getLocalizedText('badge', 'App éducative n°1 en France')}
            </span>
          </div>
          
          <h1 className="text-6xl font-bold text-gray-900 mb-6" data-testid="app-title">
            🧮 {t.appName}
          </h1>
          
          <p className="text-xl text-gray-600 mb-8" data-testid="tagline">
            {t.tagline}
          </p>
          
          <p className="text-lg text-gray-700 mb-8" data-testid="welcome-message">
            {t.welcomeMessage}
          </p>

          {/* Statistiques multilingues */}
          <div className="mb-8 p-4 bg-white rounded-lg shadow-sm border" data-testid="language-stats">
            <p className="text-blue-800 font-semibold" data-testid="total-languages">
              🌍 Exactement {stats.total} langues supportées ({stats.rtl} RTL + {stats.ltr} LTR)
            </p>
            <p className="text-sm text-blue-600 mt-1" data-testid="current-language">
              Langue actuelle: {currentLanguage.nativeName} {currentLanguage.flag}
              {isRTL && ' (Direction RTL)'}
            </p>
          </div>

          {/* Boutons CTA */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <button className="bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-8 rounded-lg text-lg transition-all duration-200 transform hover:scale-105 shadow-lg">
              {getLocalizedText('startFree', 'Commencer gratuitement')} 🚀
            </button>
            <button className="border-2 border-blue-600 text-blue-600 hover:bg-blue-50 font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
              {getLocalizedText('viewPlans', 'Voir les plans')}
            </button>
            <button className="border-2 border-green-600 text-green-600 hover:bg-green-50 font-bold py-4 px-8 rounded-lg text-lg transition-colors duration-200">
              {getLocalizedText('contactEducation', 'Contact Écoles')} 🏫
            </button>
          </div>

          <p className="text-sm text-gray-500 mt-4">
            {getLocalizedText('familiesCount', '100k+ familles nous font confiance')} • {getLocalizedText('schoolsCount', '500+ écoles partenaires')}
          </p>
        </div>
      </section>

      {/* Section Features mathématiques */}
      <section className="py-16 bg-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              {getLocalizedText('featuresFooter', 'Fonctionnalités')}
            </h2>
            <p className="text-lg text-gray-600">
              Découvrez toutes les fonctionnalités qui font de Math4Child l'app n°1
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-4 gap-6" data-testid="math-operations">
            <div className="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 hover:transform hover:scale-105 text-center">
              <div className="text-4xl mb-4">➕</div>
              <h3 className="font-semibold mb-2 text-lg">{t.addition}</h3>
              <p className="text-sm text-gray-600">{t.beginner}</p>
              <p className="text-xs text-gray-500 mt-2">Calculs interactifs et progressifs</p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 hover:transform hover:scale-105 text-center">
              <div className="text-4xl mb-4">➖</div>
              <h3 className="font-semibold mb-2 text-lg">{t.subtraction}</h3>
              <p className="text-sm text-gray-600">{t.intermediate}</p>
              <p className="text-xs text-gray-500 mt-2">Méthodes visuelles d'apprentissage</p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 hover:transform hover:scale-105 text-center">
              <div className="text-4xl mb-4">✖️</div>
              <h3 className="font-semibold mb-2 text-lg">{t.multiplication}</h3>
              <p className="text-sm text-gray-600">{t.advanced}</p>
              <p className="text-xs text-gray-500 mt-2">Tables de multiplication ludiques</p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300 hover:transform hover:scale-105 text-center">
              <div className="text-4xl mb-4">➗</div>
              <h3 className="font-semibold mb-2 text-lg">{t.division}</h3>
              <p className="text-sm text-gray-600">{t.expert}</p>
              <p className="text-xs text-gray-500 mt-2">Division avec reste expliquée</p>
            </div>
          </div>

          {/* Niveaux de difficulté */}
          <div className="mt-12 p-6 bg-gray-50 rounded-lg" data-testid="difficulty-levels">
            <h3 className="text-xl font-semibold mb-4 text-gray-800 text-center">
              5 niveaux de difficulté adaptés
            </h3>
            <div className="flex flex-wrap justify-center gap-3">
              {[t.beginner, t.intermediate, t.advanced, t.expert, t.master].map((level, index) => (
                <span 
                  key={index}
                  className="px-4 py-2 bg-blue-100 text-blue-800 rounded-full font-medium"
                >
                  {level}
                </span>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Section Plans d'abonnement - 4 PLANS */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              {getLocalizedText('pricing', 'Plans d\'abonnement')}
            </h2>
            <p className="text-lg text-gray-600">
              Choisissez le plan parfait pour vos besoins : particuliers, familles ou institutions
            </p>

            {/* Sélecteur de période */}
            <div className="flex justify-center mt-6">
              <div className="bg-white p-1 rounded-lg border">
                <button
                  onClick={() => setSelectedPlan('monthly')}
                  className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                    selectedPlan === 'monthly' 
                      ? 'bg-blue-600 text-white' 
                      : 'text-gray-700 hover:text-blue-600'
                  }`}
                >
                  {getLocalizedText('monthly', 'Mensuel')}
                </button>
                <button
                  onClick={() => setSelectedPlan('quarterly')}
                  className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                    selectedPlan === 'quarterly' 
                      ? 'bg-blue-600 text-white' 
                      : 'text-gray-700 hover:text-blue-600'
                  }`}
                >
                  {getLocalizedText('quarterly', 'Trimestriel')}
                  <span className="ml-1 text-xs bg-green-100 text-green-800 px-2 py-1 rounded">
                    {getLocalizedText('save', 'Économisez')} 20%
                  </span>
                </button>
                <button
                  onClick={() => setSelectedPlan('annual')}
                  className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                    selectedPlan === 'annual' 
                      ? 'bg-blue-600 text-white' 
                      : 'text-gray-700 hover:text-blue-600'
                  }`}
                >
                  {getLocalizedText('annual', 'Annuel')}
                  <span className="ml-1 text-xs bg-green-100 text-green-800 px-2 py-1 rounded">
                    {getLocalizedText('save', 'Économisez')} 33%
                  </span>
                </button>
              </div>
            </div>
          </div>

          {/* Grille des 4 plans */}
          <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
            {/* Plan Gratuit */}
            <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-gray-200">
              <h3 className="text-xl font-bold text-gray-900 mb-2">{pricingPlans.free.name}</h3>
              <div className="mb-4">
                <span className="text-3xl font-bold text-gray-900">{pricingPlans.free.price}</span>
              </div>
              <ul className="space-y-3 mb-6">
                {pricingPlans.free.features.map((feature, index) => (
                  <li key={index} className="flex items-center">
                    <svg className="w-5 h-5 text-green-500 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    <span className="text-sm text-gray-600">{feature}</span>
                  </li>
                ))}
              </ul>
              <button className="w-full bg-gray-600 hover:bg-gray-700 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                {getLocalizedText('startFree', 'Commencer gratuitement')}
              </button>
            </div>

            {/* Plan Premium */}
            <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-blue-500 relative transform scale-105">
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                  {getLocalizedText('mostPopular', 'Le plus populaire')}
                </span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{pricingPlans.premium.name}</h3>
              <div className="mb-4">
                <span className="text-3xl font-bold text-gray-900">
                  €{selectedPlan === 'monthly' ? pricingPlans.premium.monthlyPrice : 
                      selectedPlan === 'quarterly' ? pricingPlans.premium.quarterlyPrice : 
                      pricingPlans.premium.annualPrice}
                </span>
                <span className="text-gray-600 ml-1">
                  /{selectedPlan === 'monthly' ? 'mois' : 
                     selectedPlan === 'quarterly' ? 'trimestre' : 'an'}
                </span>
              </div>
              <ul className="space-y-3 mb-6">
                {pricingPlans.premium.features.map((feature, index) => (
                  <li key={index} className="flex items-center">
                    <svg className="w-5 h-5 text-green-500 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    <span className="text-sm text-gray-600">{feature}</span>
                  </li>
                ))}
              </ul>
              <button className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                {getLocalizedText('choosePlan', 'Choisir ce plan')}
              </button>
              <p className="text-xs text-center text-gray-500 mt-2">
                {getLocalizedText('freeTrial', '14j gratuit')}
              </p>
            </div>

            {/* Plan Famille */}
            <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-purple-500 relative">
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-purple-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                  {getLocalizedText('recommended', 'Recommandé familles')}
                </span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{pricingPlans.family.name}</h3>
              <div className="mb-4">
                <span className="text-3xl font-bold text-gray-900">
                  €{selectedPlan === 'monthly' ? pricingPlans.family.monthlyPrice : 
                      selectedPlan === 'quarterly' ? pricingPlans.family.quarterlyPrice : 
                      pricingPlans.family.annualPrice}
                </span>
                <span className="text-gray-600 ml-1">
                  /{selectedPlan === 'monthly' ? 'mois' : 
                     selectedPlan === 'quarterly' ? 'trimestre' : 'an'}
                </span>
              </div>
              <ul className="space-y-3 mb-6">
                {pricingPlans.family.features.map((feature, index) => (
                  <li key={index} className="flex items-center">
                    <svg className="w-5 h-5 text-green-500 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    <span className="text-sm text-gray-600">{feature}</span>
                  </li>
                ))}
              </ul>
              <button className="w-full bg-purple-600 hover:bg-purple-700 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                {getLocalizedText('choosePlan', 'Choisir ce plan')}
              </button>
              <p className="text-xs text-center text-gray-500 mt-2">
                {getLocalizedText('freeTrial', '14j gratuit')}
              </p>
            </div>

            {/* Plan Écoles & Associations - NOUVEAU */}
            <div className="bg-white rounded-lg shadow-lg p-6 border-2 border-green-500 relative">
              <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                <span className="bg-green-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                  {getLocalizedText('institutional', 'Institutionnel')}
                </span>
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-2">{pricingPlans.education.name}</h3>
              <div className="mb-4">
                <span className="text-3xl font-bold text-gray-900">
                  €{selectedPlan === 'monthly' ? pricingPlans.education.monthlyPrice : 
                      selectedPlan === 'quarterly' ? pricingPlans.education.quarterlyPrice : 
                      pricingPlans.education.annualPrice}
                </span>
                <span className="text-gray-600 ml-1">
                  /{selectedPlan === 'monthly' ? 'mois' : 
                     selectedPlan === 'quarterly' ? 'trimestre' : 'an'}
                </span>
              </div>
              <ul className="space-y-3 mb-6">
                {pricingPlans.education.features.map((feature, index) => (
                  <li key={index} className="flex items-center">
                    <svg className="w-5 h-5 text-green-500 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    <span className="text-sm text-gray-600">{feature}</span>
                  </li>
                ))}
              </ul>
              <button className="w-full bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                {getLocalizedText('contactSales', 'Contacter nos équipes')}
              </button>
              <p className="text-xs text-center text-gray-500 mt-2">
                {getLocalizedText('customDemo', 'Démo personnalisée gratuite')}
              </p>
            </div>
          </div>

          {/* Message spécial pour les institutions */}
          <div className="mt-12 text-center">
            <div className="bg-green-50 border border-green-200 rounded-lg p-6">
              <h3 className="text-lg font-semibold text-green-800 mb-2">
                🏫 {getLocalizedText('educationSpecial', 'Offre spéciale éducation')}
              </h3>
              <p className="text-green-700 mb-4">
                {getLocalizedText('educationOffer', 'Tarifs préférentiels pour les écoles, collèges, lycées et associations. Devis sur mesure et formation incluse.')}
              </p>
              <button className="bg-green-600 hover:bg-green-700 text-white font-bold py-3 px-6 rounded-lg transition-colors">
                {getLocalizedText('requestQuote', 'Demander un devis')} 📧
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Section Témoignages avec témoignage école */}
      <section className="py-16 bg-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">
              {getLocalizedText('testimonials', 'Témoignages')}
            </h2>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div className="bg-gray-50 p-6 rounded-lg hover:bg-gray-100 transition-colors duration-300">
              <div className="flex items-center mb-4">
                <div className="text-yellow-400 text-lg">⭐⭐⭐⭐⭐</div>
              </div>
              <p className="text-gray-600 mb-4">
                "Math4Child a transformé l'apprentissage des maths pour mes enfants. Ils adorent les exercices interactifs !"
              </p>
              <div className="font-semibold">Sophie M.</div>
              <div className="text-sm text-gray-500">Mère de 2 enfants</div>
            </div>

            <div className="bg-gray-50 p-6 rounded-lg hover:bg-gray-100 transition-colors duration-300">
              <div className="flex items-center mb-4">
                <div className="text-yellow-400 text-lg">⭐⭐⭐⭐⭐</div>
              </div>
              <p className="text-gray-600 mb-4">
                "Le support multilingue est fantastique. Mes enfants apprennent en français ET en anglais !"
              </p>
              <div className="font-semibold">Ahmed K.</div>
              <div className="text-sm text-gray-500">Enseignant</div>
            </div>

            <div className="bg-gray-50 p-6 rounded-lg hover:bg-gray-100 transition-colors duration-300">
              <div className="flex items-center mb-4">
                <div className="text-yellow-400 text-lg">⭐⭐⭐⭐⭐</div>
              </div>
              <p className="text-gray-600 mb-4">
                "Nos élèves de CM1-CM2 progressent rapidement. Le tableau de bord enseignant est parfait pour suivre chaque enfant."
              </p>
              <div className="font-semibold">École Primaire Jean Jaurès</div>
              <div className="text-sm text-gray-500">Lyon • 180 élèves</div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer professionnel */}
      <footer className="bg-gray-900 text-white py-12">
        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <h3 className="text-lg font-semibold mb-4">{t.appName}</h3>
              <p className="text-gray-400 mb-4">
                {t.description}
              </p>
            </div>

            <div>
              <h4 className="text-sm font-semibold mb-4 uppercase tracking-wide">
                {getLocalizedText('featuresFooter', 'Fonctionnalités')}
              </h4>
              <ul className="space-y-2 text-gray-400">
                <li>Exercices interactifs</li>
                <li>Suivi des progrès</li>
                <li>Jeux éducatifs</li>
                <li>Mode multi-joueurs</li>
              </ul>
            </div>

            <div>
              <h4 className="text-sm font-semibold mb-4 uppercase tracking-wide">Support</h4>
              <ul className="space-y-2 text-gray-400">
                <li>Centre d'aide</li>
                <li>{getLocalizedText('contact', 'Contact')}</li>
                <li>Guides parents</li>
                <li>Formation enseignants</li>
              </ul>
            </div>

            <div>
              <h4 className="text-sm font-semibold mb-4 uppercase tracking-wide">Télécharger</h4>
              <div className="space-y-3">
                <div className="bg-gray-800 hover:bg-gray-700 px-4 py-2 rounded-lg cursor-pointer transition-colors">
                  <div className="flex items-center">
                    <span className="mr-2">📱</span>
                    <div>
                      <div className="text-xs text-gray-400">Télécharger sur</div>
                      <div className="font-semibold">App Store</div>
                    </div>
                  </div>
                </div>
                <div className="bg-gray-800 hover:bg-gray-700 px-4 py-2 rounded-lg cursor-pointer transition-colors">
                  <div className="flex items-center">
                    <span className="mr-2">🤖</span>
                    <div>
                      <div className="text-xs text-gray-400">Disponible sur</div>
                      <div className="font-semibold">Google Play</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Statut opérationnel */}
          <div className="border-t border-gray-800 mt-8 pt-8" data-testid="operational-status">
            <div className="flex flex-col md:flex-row justify-between items-center">
              <div className="mb-4 md:mb-0">
                <p className="text-green-400 font-semibold">
                  ✅ {t.appName} opérationnel sur le port 3001
                </p>
                <p className="text-sm text-gray-400">
                  Version 2.0.0 - GitHub: https://github.com/khalidksouri/multi-apps-platform
                </p>
                <p className="text-sm text-gray-400">
                  Contact: khalid_ksouri@yahoo.fr • Écoles: education@math4child.com
                </p>
              </div>
              <div className="text-sm text-gray-400">
                © 2024 {t.appName}. {getLocalizedText('allRightsReserved', 'Tous droits réservés.')}
              </div>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default function HomePage() {
  return (
    <LanguageProvider>
      <HomeContent />
    </LanguageProvider>
  )
}
EOF

echo -e "${GREEN}✅ Page mise à jour avec le plan Écoles${NC}"

# ===================================================================
# AJOUTER LES TRADUCTIONS ÉDUCATION
# ===================================================================

echo -e "${BLUE}🔧 Ajout des traductions pour le secteur éducatif...${NC}"

if [ -f "src/translations.ts" ]; then
    # Ajouter les nouvelles clés de traduction pour l'éducation
    cat >> "src/translations.ts" << 'EOF'

// ===================================================================
// TRADUCTIONS ÉDUCATION AJOUTÉES
// ===================================================================

// Ajouter ces clés aux objets de traduction existants :

/*
Pour le français (fr) :
educationPlan: 'Écoles & Associations',
institutional: 'Institutionnel',
contactEducation: 'Contact Écoles',
schoolsCount: '500+ écoles partenaires',
contactSales: 'Contacter nos équipes',
customDemo: 'Démo personnalisée gratuite',
educationSpecial: 'Offre spéciale éducation',
educationOffer: 'Tarifs préférentiels pour les écoles, collèges, lycées et associations. Devis sur mesure et formation incluse.',
requestQuote: 'Demander un devis',

Pour l'anglais (en) :
educationPlan: 'Schools & Organizations',
institutional: 'Institutional',
contactEducation: 'Contact Schools',
schoolsCount: '500+ partner schools',
contactSales: 'Contact our teams',
customDemo: 'Free custom demo',
educationSpecial: 'Special education offer',
educationOffer: 'Preferential rates for schools, colleges, high schools and associations. Custom quotes and training included.',
requestQuote: 'Request a quote',
*/
EOF

    echo -e "${GREEN}✅ Clés de traduction éducation documentées${NC}"
else
    echo -e "${YELLOW}⚠️ Fichier translations.ts non trouvé${NC}"
fi

# ===================================================================
# MISE À JOUR DES STYLES POUR 4 COLONNES
# ===================================================================

echo -e "${BLUE}🔧 Mise à jour des styles pour 4 plans...${NC}"

cat >> "src/app/globals.css" << 'EOF'

/* ===================================================================
 * STYLES POUR 4 PLANS D'ABONNEMENT
 * ===================================================================
 */

/* Styles spécifiques pour le plan éducation */
.education-plan {
  @apply border-green-500;
}

.education-badge {
  @apply bg-green-500 text-white;
}

.education-cta {
  @apply bg-green-600 hover:bg-green-700 text-white;
}

/* Styles pour la section offre éducation */
.education-special {
  @apply bg-green-50 border-green-200 rounded-lg p-6;
}

.education-special h3 {
  @apply text-green-800 font-semibold;
}

.education-special p {
  @apply text-green-700;
}

/* Grille responsive pour 4 plans */
@media (min-width: 1024px) {
  .pricing-grid-4 {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (max-width: 1023px) {
  .pricing-grid-4 {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 767px) {
  .pricing-grid-4 {
    grid-template-columns: 1fr;
  }
  
  /* Réduire l'effet scale sur mobile */
  .pricing-card.popular {
    @apply transform-none scale-100;
  }
}

/* Styles pour les listes de fonctionnalités plus longues */
.feature-list {
  max-height: 300px;
  overflow-y: auto;
}

.feature-list::-webkit-scrollbar {
  width: 4px;
}

.feature-list::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 2px;
}

.feature-list::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.feature-list::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

/* Animation pour le plan education */
.education-highlight {
  animation: pulse-green 2s ease-in-out infinite;
}

@keyframes pulse-green {
  0%, 100% {
    box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.4);
  }
  50% {
    box-shadow: 0 0 0 10px rgba(34, 197, 94, 0);
  }
}
EOF

echo -e "${GREEN}✅ Styles pour 4 plans ajoutés${NC}"

cd "../.."

# ===================================================================
# RÉSUMÉ FINAL
# ===================================================================

echo ""
echo -e "${GREEN}${BOLD}🎉 PLAN ÉCOLES ET ASSOCIATIONS AJOUTÉ !${NC}"
echo ""
echo -e "${CYAN}${BOLD}📚 NOUVEAU PLAN ÉDUCATION :${NC}"
echo -e "${GREEN}✅ Plan 'Écoles & Associations' créé${NC}"
echo -e "${GREEN}✅ Prix : €19.99/mois (€54.99/trimestre, €199.99/an)${NC}"
echo -e "${GREEN}✅ Fonctionnalités spécialisées éducation${NC}"
echo -e "${GREEN}✅ Jusqu'à 30 profils élèves${NC}"
echo -e "${GREEN}✅ Tableau de bord enseignant${NC}"
echo -e "${GREEN}✅ Formation des enseignants incluse${NC}"
echo -e "${GREEN}✅ Support pédagogique dédié${NC}"
echo -e "${GREEN}✅ Badge 'Institutionnel'${NC}"
echo -e "${GREEN}✅ Témoignage école ajouté${NC}"
echo -e "${GREEN}✅ Section offre spéciale éducation${NC}"

echo ""
echo -e "${BLUE}${BOLD}📊 RÉSUMÉ DES 4 PLANS :${NC}"
echo -e "${CYAN}1. Gratuit : €0 - 5 exercices/jour, 5 langues${NC}"
echo -e "${CYAN}2. Premium : €4.99/mois - Illimité, 20 langues (Le plus populaire)${NC}"
echo -e "${CYAN}3. Famille : €9.99/mois - Premium + 6 profils (Recommandé familles)${NC}"
echo -e "${CYAN}4. Écoles & Associations : €19.99/mois - 30 élèves + outils enseignant (Institutionnel)${NC}"

echo ""
echo -e "${PURPLE}${BOLD}🚀 DÉMARRAGE :${NC}"
echo -e "${CYAN}cd apps/math4child && npm run dev${NC}"
echo -e "${WHITE}➡️ http://localhost:3001${NC}"

echo ""
echo -e "${PURPLE}${BOLD}🧪 TESTS À EFFECTUER :${NC}"
echo -e "${YELLOW}1. Vérifier l'affichage des 4 plans en grille${NC}"
echo -e "${YELLOW}2. Tester le plan Écoles & Associations${NC}"
echo -e "${YELLOW}3. Valider le badge 'Institutionnel'${NC}"
echo -e "${YELLOW}4. Confirmer la section offre éducation${NC}"
echo -e "${YELLOW}5. Vérifier le témoignage école${NC}"
echo -e "${YELLOW}6. Tester le responsive pour 4 colonnes${NC}"

echo ""
echo -e "${GREEN}${BOLD}✨ MATH4CHILD AVEC PLAN ÉDUCATION COMPLET ! ✨${NC}"
echo -e "${BLUE}🧮 Maintenant adapté aux particuliers, familles ET institutions ! 🏫${NC}"