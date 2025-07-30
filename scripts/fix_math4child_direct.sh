#!/bin/bash

# =============================================================================
# 🎯 CORRECTION DIRECTE DE apps/math4child UNIQUEMENT
# Diagnostic + remplacement forcé du contenu
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_step() {
    echo -e "${CYAN}🔍 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

TARGET_DIR="apps/math4child"

print_step "DIAGNOSTIC ET CORRECTION DE $TARGET_DIR"

if [ ! -d "$TARGET_DIR" ]; then
    print_error "Dossier $TARGET_DIR non trouvé"
    exit 1
fi

cd "$TARGET_DIR"

# =============================================================================
# 1. ARRÊTER TOUS LES SERVEURS
# =============================================================================

print_step "1. Arrêt de tous les serveurs Next.js..."

# Tuer tous les processus sur les ports
for port in 3000 3001 3002 3003 3004 3005 3006; do
    if lsof -ti:$port > /dev/null 2>&1; then
        echo "🛑 Arrêt du serveur sur le port $port..."
        lsof -ti:$port | xargs kill -9 2>/dev/null || true
    fi
done

# Tuer tous les processus Next.js
pkill -f "next" 2>/dev/null || true
sleep 2

print_success "Tous les serveurs arrêtés"

# =============================================================================
# 2. DIAGNOSTIC DU FICHIER ACTUEL
# =============================================================================

print_step "2. Diagnostic du fichier page.tsx actuel..."

if [ -f "src/app/page.tsx" ]; then
    echo "📄 Fichier existe. Taille: $(wc -c < src/app/page.tsx) caractères"
    echo ""
    echo "🔍 Premières lignes actuelles:"
    head -10 "src/app/page.tsx"
    echo ""
    echo "🔍 Recherche du bon contenu:"
    if grep -q "Apprends les maths en t'amusant" "src/app/page.tsx"; then
        print_success "✅ BON contenu trouvé"
        echo "❓ Pourtant le navigateur montre l'ancien..."
    else
        print_error "❌ ANCIEN contenu détecté"
        echo "🔍 Contenu détecté:"
        grep -i "math" "src/app/page.tsx" | head -3
    fi
else
    print_error "❌ Fichier page.tsx n'existe pas"
fi

# =============================================================================
# 3. SUPPRESSION FORCÉE ET RECRÉATION
# =============================================================================

print_step "3. Suppression et recréation complète du fichier..."

# Supprimer complètement le fichier
if [ -f "src/app/page.tsx" ]; then
    rm -f "src/app/page.tsx"
    print_success "Ancien fichier supprimé"
fi

# Créer le dossier si nécessaire
mkdir -p "src/app"

# Créer le NOUVEAU page.tsx avec le vrai design Math4Child
cat << 'MATH4CHILD_CONTENT' > "src/app/page.tsx"
'use client'

import React, { useState, useEffect } from 'react'
import { 
  Users, 
  Languages, 
  ChevronDown, 
  Crown, 
  Gift, 
  Globe, 
  TrendingUp,
  CheckCircle,
  ArrowRight,
  Smartphone,
  Monitor,
  Tablet
} from 'lucide-react'

const LANGUAGE_CONFIG = {
  fr: {
    flag: '🇫🇷',
    name: 'Français',
    appName: 'Math pour enfants',
    tagline: 'App éducative n°1 en France',
    heroTitle: 'Apprends les maths en t\'amusant !',
    heroWelcome: 'Bienvenue dans l\'aventure mathématique !',
    features: [
      'Débloquez toutes les fonctionnalités premium',
      '30+ langues disponibles',
      'Web, iOS et Android',
      '5 niveaux de difficulté',
      'Suivi détaillé des progrès'
    ],
    startFree: 'Commencer gratuitement',
    freeTrial: '14j gratuit',
    comparePrices: 'Comparer les prix'
  },
  en: {
    flag: '🇺🇸',
    name: 'English',
    appName: 'Math4Child',
    tagline: '#1 Educational App in France',
    heroTitle: 'Learn math while having fun!',
    heroWelcome: 'Welcome to the mathematical adventure!',
    features: [
      'Unlock all premium features',
      '30+ languages available',
      'Web, iOS and Android',
      '5 difficulty levels',
      'Detailed progress tracking'
    ],
    startFree: 'Start Free',
    freeTrial: '14 days free',
    comparePrices: 'Compare Prices'
  }
}

export default function HomePage() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showPricingModal, setShowPricingModal] = useState(false)
  
  const t = LANGUAGE_CONFIG[currentLang as keyof typeof LANGUAGE_CONFIG]

  const handleStartFree = () => {
    alert(`🎉 Essai gratuit de 14 jours démarré pour ${t.appName}!`)
  }

  useEffect(() => {
    const handleClickOutside = () => setShowLanguageDropdown(false)
    document.addEventListener('click', handleClickOutside)
    return () => document.removeEventListener('click', handleClickOutside)
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header avec le vrai design Math4Child */}
      <header className="sticky top-0 z-50 bg-white/90 backdrop-blur-xl border-b border-gray-200/50 shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            
            {/* Logo Math4Child authentique */}
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-105 transition-transform">
                <span className="text-white text-xl font-bold">🧮</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">{t.appName}</h1>
                <p className="text-xs text-gray-600 flex items-center">
                  <Crown size={12} className="mr-1 text-orange-500" />
                  {t.tagline}
                </p>
              </div>
            </div>
            
            {/* Navigation avec dropdown de langues */}
            <div className="flex items-center space-x-4">
              
              {/* Badge 100k+ familles */}
              <div className="hidden md:flex items-center space-x-2 bg-green-100 text-green-800 rounded-full px-4 py-2 text-sm font-medium shadow-sm">
                <Users size={16} />
                <span>100k+ familles</span>
              </div>
              
              {/* Sélecteur de langue avec le design authentique */}
              <div className="relative">
                <button
                  onClick={(e) => {
                    e.stopPropagation()
                    setShowLanguageDropdown(!showLanguageDropdown)
                  }}
                  className="flex items-center space-x-2 bg-gray-100 hover:bg-gray-200 rounded-lg px-4 py-2 text-gray-700 transition-all duration-200 shadow-sm"
                  data-testid="language-dropdown-button"
                >
                  <Languages size={16} />
                  <span className="text-xl">{t.flag}</span>
                  <span className="text-sm font-medium">{t.name}</span>
                  <ChevronDown size={14} className={`transform transition-transform duration-200 ${showLanguageDropdown ? 'rotate-180' : ''}`} />
                </button>
                
                {/* Dropdown avec scroll visible */}
                {showLanguageDropdown && (
                  <div className="absolute top-full right-0 mt-2 w-72 bg-white rounded-xl shadow-2xl border border-gray-200 overflow-hidden z-50 animate-in slide-in-from-top-2 duration-200">
                    <div className="p-4 border-b border-gray-100 bg-gradient-to-r from-blue-50 to-purple-50">
                      <p className="text-sm font-semibold text-gray-900">Sélectionner une langue</p>
                      <p className="text-xs text-gray-600">30+ langues disponibles • Traduction temps réel</p>
                    </div>
                    <div className="max-h-64 overflow-y-auto">
                      {Object.entries(LANGUAGE_CONFIG).map(([lang, config]) => (
                        <button
                          key={lang}
                          onClick={(e) => {
                            e.stopPropagation()
                            setCurrentLang(lang)
                            setShowLanguageDropdown(false)
                          }}
                          className={`w-full text-left px-4 py-3 hover:bg-gray-50 transition-colors duration-150 flex items-center space-x-3 ${
                            currentLang === lang ? 'bg-blue-50 text-blue-900 font-medium border-l-4 border-blue-500' : 'text-gray-700'
                          }`}
                          data-testid={`language-option-${lang}`}
                        >
                          <span className="text-2xl">{config.flag}</span>
                          <div className="flex-1">
                            <div className="font-medium">{config.name}</div>
                            <div className="text-xs text-gray-500">{config.appName}</div>
                          </div>
                          {currentLang === lang && (
                            <CheckCircle size={16} className="text-blue-500" />
                          )}
                        </button>
                      ))}
                    </div>
                    <div className="p-3 border-t border-gray-100 bg-gray-50">
                      <p className="text-xs text-gray-600 text-center">
                        ✨ Interface traduite automatiquement
                      </p>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section - Design authentique du vrai site */}
      <main className="relative">
        
        {/* Particules animées en arrière-plan */}
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <div className="absolute -top-40 -right-40 w-80 h-80 bg-purple-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
          <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-yellow-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
          <div className="absolute top-40 left-1/4 w-60 h-60 bg-pink-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
          <div className="absolute bottom-40 right-1/4 w-72 h-72 bg-blue-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 animate-pulse"></div>
        </div>

        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          
          {/* Section hero principale */}
          <div className="text-center mb-20">
            
            {/* Badge Leader mondial */}
            <div className="inline-flex items-center space-x-3 bg-gradient-to-r from-orange-100 to-red-100 rounded-full px-6 py-3 mb-8 border border-orange-200 shadow-sm">
              <Globe size={20} className="text-orange-600" />
              <span className="text-orange-800 font-bold text-sm">www.math4child.com • Leader mondial</span>
            </div>

            {/* Titre principal - exactement comme le vrai site */}
            <h2 className="text-5xl sm:text-6xl lg:text-7xl font-bold text-gray-900 mb-8 leading-tight">
              <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent animate-pulse">
                {t.heroTitle}
              </span>
            </h2>
            
            <p className="text-2xl sm:text-3xl text-gray-700 mb-10 max-w-4xl mx-auto font-light leading-relaxed">
              {t.heroWelcome}
            </p>
            
            {/* 5 Fonctionnalités du vrai site */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-6 mb-16 max-w-6xl mx-auto">
              {t.features.map((feature, index) => (
                <div key={index} className="bg-white/80 backdrop-blur-sm rounded-xl p-6 border border-gray-200 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105">
                  <p className="text-sm font-semibold text-gray-800 leading-tight">{feature}</p>
                </div>
              ))}
            </div>
          </div>
          
          {/* Boutons CTA - Design du vrai Math4Child */}
          <div className="flex flex-col sm:flex-row gap-8 justify-center items-center mb-20">
            
            <button 
              onClick={handleStartFree}
              className="group bg-gradient-to-r from-green-500 to-emerald-600 text-white px-10 py-5 rounded-2xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-300 transform hover:scale-105 shadow-2xl flex items-center space-x-4 min-w-[350px] animate-bounce"
            >
              <Gift size={28} />
              <div className="text-left">
                <div>{t.startFree}</div>
                <div className="text-sm opacity-90 font-normal">{t.freeTrial}</div>
              </div>
              <ArrowRight size={24} className="group-hover:translate-x-2 transition-transform duration-300" />
            </button>
            
            <button 
              onClick={() => setShowPricingModal(true)}
              className="bg-gradient-to-r from-blue-500 to-indigo-600 text-white px-10 py-5 rounded-2xl text-xl font-bold hover:from-blue-600 hover:to-indigo-700 transition-all duration-300 transform hover:scale-105 shadow-2xl flex items-center space-x-4 min-w-[350px]"
            >
              <TrendingUp size={28} />
              <span>{t.comparePrices}</span>
            </button>
          </div>

          {/* Statistiques du vrai site */}
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-10 mb-20 max-w-4xl mx-auto">
            <div className="text-center bg-white/60 backdrop-blur-sm rounded-2xl p-8 border border-gray-200 shadow-lg">
              <div className="text-4xl font-bold text-blue-600 mb-3">100k+</div>
              <div className="text-gray-700 font-semibold text-lg">Familles actives</div>
              <div className="text-gray-500 text-sm mt-1">Dans le monde entier</div>
            </div>
            <div className="text-center bg-white/60 backdrop-blur-sm rounded-2xl p-8 border border-gray-200 shadow-lg">
              <div className="text-4xl font-bold text-green-600 mb-3">98%</div>
              <div className="text-gray-700 font-semibold text-lg">Satisfaction parents</div>
              <div className="text-gray-500 text-sm mt-1">Note moyenne</div>
            </div>
            <div className="text-center bg-white/60 backdrop-blur-sm rounded-2xl p-8 border border-gray-200 shadow-lg">
              <div className="text-4xl font-bold text-purple-600 mb-3">47</div>
              <div className="text-gray-700 font-semibold text-lg">Pays disponibles</div>
              <div className="text-gray-500 text-sm mt-1">Et plus chaque mois</div>
            </div>
          </div>

          {/* Section plateformes */}
          <div className="text-center mb-16">
            <h3 className="text-3xl font-bold text-gray-900 mb-10">Disponible sur toutes vos plateformes</h3>
            <div className="flex justify-center items-center space-x-12">
              <div className="text-center group hover:scale-110 transition-transform duration-300">
                <Monitor size={64} className="text-blue-500 mx-auto mb-4 group-hover:animate-bounce" />
                <p className="text-gray-700 font-semibold text-lg">Web</p>
                <p className="text-gray-500 text-sm">Navigateur</p>
              </div>
              <div className="text-center group hover:scale-110 transition-transform duration-300">
                <Smartphone size={64} className="text-green-500 mx-auto mb-4 group-hover:animate-bounce" />
                <p className="text-gray-700 font-semibold text-lg">iOS</p>
                <p className="text-gray-500 text-sm">iPhone/iPad</p>
              </div>
              <div className="text-center group hover:scale-110 transition-transform duration-300">
                <Tablet size={64} className="text-orange-500 mx-auto mb-4 group-hover:animate-bounce" />
                <p className="text-gray-700 font-semibold text-lg">Android</p>
                <p className="text-gray-500 text-sm">Tablettes/Téléphones</p>
              </div>
            </div>
          </div>
        </div>
      </main>

      {/* Modal de pricing - Design du vrai site */}
      {showPricingModal && (
        <div className="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 animate-in fade-in duration-300">
          <div className="bg-white rounded-3xl max-w-5xl w-full max-h-[90vh] overflow-y-auto shadow-2xl animate-in slide-in-from-bottom-4 duration-300">
            <div className="p-8">
              
              <div className="flex justify-between items-center mb-10">
                <div>
                  <h3 className="text-4xl font-bold text-gray-900">Choisissez votre plan</h3>
                  <p className="text-gray-600 mt-2 text-lg">Commencez votre essai gratuit de 14 jours dès maintenant</p>
                </div>
                <button 
                  onClick={() => setShowPricingModal(false)}
                  className="text-gray-500 hover:text-gray-700 text-4xl font-light hover:scale-110 transition-all duration-200"
                >
                  ×
                </button>
              </div>
              
              {/* Plans authentiques du vrai Math4Child */}
              <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                
                {/* Plan Gratuit */}
                <div className="border-2 border-gray-200 rounded-2xl p-6 bg-gray-50 hover:shadow-lg transition-all duration-300">
                  <h4 className="text-xl font-bold text-gray-800 mb-2">Gratuit</h4>
                  <div className="text-3xl font-bold text-gray-800 mb-4">0€<span className="text-base text-gray-500 font-normal">/mois</span></div>
                  <ul className="space-y-3 text-sm text-gray-600 mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Exercices de base</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />1 profil enfant</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Niveau débutant uniquement</li>
                  </ul>
                  <button className="w-full bg-gray-200 text-gray-800 py-3 rounded-xl font-semibold hover:bg-gray-300 transition-colors">
                    Commencer gratuitement
                  </button>
                </div>

                {/* Plan Premium */}
                <div className="border-2 border-blue-200 rounded-2xl p-6 bg-blue-50 hover:shadow-lg transition-all duration-300">
                  <h4 className="text-xl font-bold text-blue-800 mb-2">Premium</h4>
                  <div className="flex items-center space-x-2 mb-4">
                    <span className="text-3xl font-bold text-blue-800">4.99€</span>
                    <span className="text-lg text-gray-500 line-through">6.99€</span>
                    <span className="bg-green-500 text-white text-xs px-2 py-1 rounded-full font-bold">-28%</span>
                  </div>
                  <ul className="space-y-3 text-sm text-gray-600 mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Exercices illimités</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />3 profils enfants</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Tous les niveaux</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Mode hors-ligne</li>
                  </ul>
                  <button className="w-full bg-blue-600 text-white py-3 rounded-xl font-semibold hover:bg-blue-700 transition-colors">
                    Essai gratuit 14j
                  </button>
                </div>

                {/* Plan Famille - Le plus populaire */}
                <div className="border-2 border-purple-500 rounded-2xl p-6 bg-purple-50 relative hover:shadow-xl transition-all duration-300 transform hover:scale-105">
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 bg-purple-500 text-white text-sm px-4 py-2 rounded-full font-bold shadow-lg">
                    🏆 Le plus populaire
                  </div>
                  <h4 className="text-xl font-bold text-purple-800 mb-2 mt-2">Famille</h4>
                  <div className="flex items-center space-x-2 mb-4">
                    <span className="text-3xl font-bold text-purple-800">6.99€</span>
                    <span className="text-lg text-gray-500 line-through">9.99€</span>
                    <span className="bg-green-500 text-white text-xs px-2 py-1 rounded-full font-bold">-30%</span>
                  </div>
                  <ul className="space-y-3 text-sm text-gray-600 mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Tout Premium inclus</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />5 profils enfants</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Rapports parents détaillés</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Support prioritaire</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Statistiques avancées</li>
                  </ul>
                  <button className="w-full bg-purple-600 text-white py-3 rounded-xl font-semibold hover:bg-purple-700 transition-colors shadow-lg">
                    Essai gratuit 14j
                  </button>
                </div>

                {/* Plan École */}
                <div className="border-2 border-orange-200 rounded-2xl p-6 bg-orange-50 hover:shadow-lg transition-all duration-300">
                  <div className="text-xs text-orange-600 mb-2 font-bold">🎓 Recommandé écoles</div>
                  <h4 className="text-xl font-bold text-orange-800 mb-2">École</h4>
                  <div className="flex items-center space-x-2 mb-4">
                    <span className="text-3xl font-bold text-orange-800">24.99€</span>
                    <span className="text-lg text-gray-500 line-through">29.99€</span>
                    <span className="bg-green-500 text-white text-xs px-2 py-1 rounded-full font-bold">-20%</span>
                  </div>
                  <ul className="space-y-3 text-sm text-gray-600 mb-6">
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Tout Famille inclus</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />30 profils élèves</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Dashboard professeur</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />Formation incluse</li>
                    <li className="flex items-center"><CheckCircle size={16} className="text-green-500 mr-2 flex-shrink-0" />API d'intégration</li>
                  </ul>
                  <button className="w-full bg-orange-600 text-white py-3 rounded-xl font-semibold hover:bg-orange-700 transition-colors">
                    Demander un devis
                  </button>
                </div>
              </div>
              
              <div className="mt-10 text-center">
                <p className="text-gray-600 mb-6 text-lg">
                  ✨ Tous les plans incluent : Accès mobile et web • Support client 24/7 • Mises à jour gratuites à vie
                </p>
                <button 
                  onClick={handleStartFree}
                  className="bg-gradient-to-r from-green-500 to-emerald-600 text-white px-12 py-4 rounded-xl text-xl font-bold hover:from-green-600 hover:to-emerald-700 transition-all duration-300 shadow-xl transform hover:scale-105"
                >
                  🚀 Commencer l'essai gratuit maintenant
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="bg-gray-900 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <div className="text-center">
            <div className="flex items-center justify-center space-x-4 mb-8">
              <div className="w-16 h-16 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-2xl font-bold">🧮</span>
              </div>
              <h3 className="text-3xl font-bold">{t.appName}</h3>
            </div>
            <p className="text-gray-400 mb-10 max-w-3xl mx-auto text-lg leading-relaxed">
              L'application éducative de confiance pour apprendre les mathématiques en famille. 
              Rejoignez plus de 100,000 familles dans l'aventure éducative Math4Child.
            </p>
            <div className="flex justify-center space-x-10 text-gray-400 mb-8">
              <a href="#" className="hover:text-white transition-colors">Conditions d'utilisation</a>
              <a href="#" className="hover:text-white transition-colors">Politique de confidentialité</a>
              <a href="#" className="hover:text-white transition-colors">Contact</a>
              <a href="#" className="hover:text-white transition-colors">Support</a>
            </div>
            <div className="pt-8 border-t border-gray-800">
              <p className="text-gray-500">© 2024 Math4Child. Tous droits réservés. Made with ❤️ pour l'éducation.</p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  )
}
MATH4CHILD_CONTENT

print_success "Nouveau fichier page.tsx créé avec le VRAI design Math4Child"

# =============================================================================
# 4. VÉRIFICATION DU NOUVEAU CONTENU
# =============================================================================

print_step "4. Vérification du nouveau contenu..."

if [ -f "src/app/page.tsx" ]; then
    echo "📊 Nouveau fichier créé. Taille: $(wc -c < src/app/page.tsx) caractères"
    echo ""
    echo "🔍 Vérification du bon contenu:"
    if grep -q "Apprends les maths en t'amusant" "src/app/page.tsx"; then
        print_success "✅ BON contenu confirmé dans le fichier"
        echo "📝 Titre trouvé: $(grep "Apprends les maths en t'amusant" src/app/page.tsx)"
    else
        print_error "❌ Problème : contenu non trouvé"
    fi
    
    echo ""
    echo "🔍 Autres éléments vérifiés:"
    grep -q "www.math4child.com • Leader mondial" "src/app/page.tsx" && echo "✅ Badge Leader mondial: OK"
    grep -q "100k+ familles" "src/app/page.tsx" && echo "✅ Badge familles: OK"
    grep -q "30+ langues disponibles" "src/app/page.tsx" && echo "✅ Langues: OK"
    grep -q "Le plus populaire" "src/app/page.tsx" && echo "✅ Plan populaire: OK"
else
    print_error "❌ Erreur : Fichier non créé"
fi

# =============================================================================
# 5. SUPPRESSION TOTALE DU CACHE NEXT.JS
# =============================================================================

print_step "5. Suppression complète du cache Next.js..."

# Supprimer tous les caches
rm -rf .next 2>/dev/null || true
rm -rf out 2>/dev/null || true
rm -rf .next.* 2>/dev/null || true
rm -f *.tsbuildinfo 2>/dev/null || true
rm -f next-env.d.ts 2>/dev/null || true

print_success "Cache Next.js supprimé"

# =============================================================================
# 6. VÉRIFICATION DES DÉPENDANCES
# =============================================================================

print_step "6. Vérification des dépendances..."

if [ -f "package.json" ]; then
    if ! grep -q "lucide-react" package.json; then
        echo "📥 Installation de lucide-react..."
        npm install lucide-react --silent
    fi
    print_success "Dépendances vérifiées"
else
    print_error "❌ package.json manquant"
fi

# =============================================================================
# 7. INSTRUCTIONS FINALES
# =============================================================================

print_step "CORRECTION TERMINÉE"

echo ""
echo -e "${GREEN}🎉 MATH4CHILD CORRIGÉ AVEC LE VRAI DESIGN !${NC}"
echo ""
echo -e "${YELLOW}🚀 MAINTENANT FAITES CECI :${NC}"
echo ""
echo "1️⃣ Dans un nouveau terminal :"
echo "   cd apps/math4child"
echo "   npm run dev"
echo ""
echo "2️⃣ Ouvrez un navigateur PRIVÉ :"
echo "   http://localhost:3000"
echo ""
echo "3️⃣ Vous devriez voir :"
echo "   ✅ 'Apprends les maths en t'amusant !'"
echo "   ✅ Badge 'Leader mondial'"
echo "   ✅ Dropdown de langues fonctionnel"
echo "   ✅ Modal de pricing avec 4 plans"
echo ""
echo -e "${CYAN}🎯 SI ça ne marche TOUJOURS pas :${NC}"
echo "   - Redémarrez complètement votre Mac"
echo "   - Utilisez un autre navigateur (Safari/Firefox)"
echo "   - Videz le cache DNS : sudo dscacheutil -flushcache"
echo ""
echo -e "${GREEN}Le fichier contient maintenant le VRAI design Math4Child !${NC}"

print_success "Correction directe terminée - Testez maintenant !"
