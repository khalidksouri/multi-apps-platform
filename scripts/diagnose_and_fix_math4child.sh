#!/bin/bash

# =============================================================================
# 🔍 DIAGNOSTIC ET CORRECTION MATH4CHILD
# Détection et résolution des problèmes de cache/build
# =============================================================================

set -e

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_ROOT/apps/math4child"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${CYAN}[INFO] $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Diagnostic complet
diagnose_project() {
    log "🔍 Diagnostic du projet Math4Child..."
    
    echo ""
    info "📁 Structure des fichiers:"
    if [[ -d "$APP_DIR" ]]; then
        echo "✅ Dossier apps/math4child existe"
        
        if [[ -f "$APP_DIR/src/app/page.tsx" ]]; then
            echo "✅ Fichier page.tsx existe"
            
            # Vérifier le contenu du fichier
            local content_lines=$(wc -l < "$APP_DIR/src/app/page.tsx")
            echo "📊 Lignes dans page.tsx: $content_lines"
            
            if [[ $content_lines -lt 100 ]]; then
                warn "⚠️  Le fichier page.tsx semble trop court (version basique)"
            else
                success "✅ Le fichier page.tsx semble complet"
            fi
            
            # Vérifier si c'est la version premium
            if grep -q "worldLanguages.length.*langues supportées" "$APP_DIR/src/app/page.tsx"; then
                success "✅ Version premium détectée dans le code"
            else
                warn "⚠️  Version basique détectée dans le code"
            fi
        else
            error "❌ Fichier page.tsx manquant"
        fi
        
        if [[ -f "$APP_DIR/package.json" ]]; then
            echo "✅ Package.json existe"
        else
            error "❌ Package.json manquant"
        fi
    else
        error "❌ Dossier du projet manquant"
        exit 1
    fi
    
    echo ""
    info "🗂️ Cache et builds:"
    
    if [[ -d "$APP_DIR/.next" ]]; then
        echo "⚠️  Cache .next présent"
    else
        echo "✅ Pas de cache .next"
    fi
    
    if [[ -d "$APP_DIR/out" ]]; then
        echo "⚠️  Dossier out présent"
    else
        echo "✅ Pas de dossier out"
    fi
    
    if [[ -d "$APP_DIR/node_modules" ]]; then
        echo "✅ Node modules installés"
    else
        warn "⚠️  Node modules manquants"
    fi
    
    echo ""
    info "🚀 Processus en cours:"
    if pgrep -f "next dev" > /dev/null; then
        echo "⚠️  Serveur Next.js en cours d'exécution"
        echo "PID: $(pgrep -f "next dev")"
    else
        echo "✅ Aucun serveur en cours"
    fi
}

# Nettoyage complet
clean_everything() {
    log "🧹 Nettoyage complet des caches et builds..."
    
    cd "$APP_DIR"
    
    # Arrêter tous les processus Next.js
    if pgrep -f "next dev" > /dev/null; then
        info "🛑 Arrêt du serveur Next.js..."
        pkill -f "next dev" || true
        sleep 2
    fi
    
    # Supprimer tous les caches
    info "🗑️  Suppression des caches..."
    rm -rf .next
    rm -rf out
    rm -rf node_modules/.cache
    rm -rf .cache
    
    # Supprimer node_modules si demandé
    if [[ "${1:-}" == "--full" ]]; then
        info "🗑️  Suppression complète de node_modules..."
        rm -rf node_modules
        rm -f package-lock.json
    fi
    
    success "Nettoyage terminé"
    cd - > /dev/null
}

# Vérification et installation des dépendances
check_dependencies() {
    log "📦 Vérification des dépendances..."
    
    cd "$APP_DIR"
    
    if [[ ! -d "node_modules" ]] || [[ ! -f "package-lock.json" ]]; then
        info "📥 Installation des dépendances..."
        npm install
    else
        info "🔄 Mise à jour des dépendances..."
        npm ci
    fi
    
    success "Dépendances prêtes"
    cd - > /dev/null
}

# Forcer le remplacement du composant
force_replace_component() {
    log "🔄 Remplacement forcé du composant principal..."
    
    # Backup de l'ancien fichier
    if [[ -f "$APP_DIR/src/app/page.tsx" ]]; then
        cp "$APP_DIR/src/app/page.tsx" "$APP_DIR/src/app/page.tsx.backup.$(date +%s)"
        info "💾 Sauvegarde créée"
    fi
    
    # Créer le composant premium complet
    cat > "$APP_DIR/src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react';
import { ChevronDown, Star, Play, Users, Trophy, Zap, Globe, Smartphone, BookOpen, BarChart3, Heart, ArrowRight, ArrowLeft, Calculator, Target, Award, Lock, Check, Crown, Shield } from 'lucide-react';

const Math4ChildProduction = () => {
  // États principaux
  const [currentLanguage, setCurrentLanguage] = useState('fr');
  const [currentCountry, setCurrentCountry] = useState('FR');
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false);
  const [currentView, setCurrentView] = useState('home');
  const [selectedLevel, setSelectedLevel] = useState('');
  const [selectedOperation, setSelectedOperation] = useState('');
  const [currentQuestion, setCurrentQuestion] = useState(null);
  const [userAnswer, setUserAnswer] = useState('');
  const [score, setScore] = useState(0);
  const [streak, setStreak] = useState(0);
  const [questionsAnswered, setQuestionsAnswered] = useState(0);
  const [correctAnswers, setCorrectAnswers] = useState({
    beginner: 0, 
    elementary: 0, 
    intermediate: 0, 
    advanced: 0, 
    expert: 0
  });
  const [unlockedLevels, setUnlockedLevels] = useState(['beginner']);
  const [lives, setLives] = useState(3);
  const [feedback, setFeedback] = useState('');
  const [isCorrect, setIsCorrect] = useState(null);
  const [freeQuestionsLeft, setFreeQuestionsLeft] = useState(50);
  const [userSubscriptions, setUserSubscriptions] = useState([]);

  // Configuration des langues mondiales
  const worldLanguages = [
    { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷', countries: ['FR'] },
    { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸', countries: ['US'] },
    { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸', countries: ['ES'] },
    { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪', countries: ['DE'] },
    { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹', countries: ['IT'] },
    { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹', countries: ['PT'] },
    { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺', countries: ['RU'] },
    { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳', countries: ['CN'] },
    { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵', countries: ['JP'] },
    { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷', countries: ['KR'] },
    { code: 'hi', name: 'हिन्दी', nativeName: 'हिन्दी', flag: '🇮🇳', countries: ['IN'] },
    { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇸🇦', countries: ['SA'] },
    { code: 'th', name: 'ไทย', nativeName: 'ไทย', flag: '🇹🇭', countries: ['TH'] },
    { code: 'vi', name: 'Tiếng Việt', nativeName: 'Tiếng Việt', flag: '🇻🇳', countries: ['VN'] },
    { code: 'id', name: 'Bahasa Indonesia', nativeName: 'Bahasa Indonesia', flag: '🇮🇩', countries: ['ID'] },
    { code: 'ms', name: 'Bahasa Melayu', nativeName: 'Bahasa Melayu', flag: '🇲🇾', countries: ['MY'] },
    { code: 'sw', name: 'Kiswahili', nativeName: 'Kiswahili', flag: '🇹🇿', countries: ['TZ'] },
    { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱', countries: ['NL'] },
    { code: 'pl', name: 'Polski', nativeName: 'Polski', flag: '🇵🇱', countries: ['PL'] },
    { code: 'sv', name: 'Svenska', nativeName: 'Svenska', flag: '🇸🇪', countries: ['SE'] }
  ];

  // Configuration des monnaies
  const countryPricing = {
    FR: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    US: { currency: 'USD', symbol: '$', monthly: 9.99, quarterly: 26.97, yearly: 69.93 },
    DE: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    UK: { currency: 'GBP', symbol: '£', monthly: 7.49, quarterly: 20.22, yearly: 52.44 },
    ES: { currency: 'EUR', symbol: '€', monthly: 8.49, quarterly: 22.92, yearly: 59.43 },
    JP: { currency: 'JPY', symbol: '¥', monthly: 1449, quarterly: 3912, yearly: 10143 },
    CN: { currency: 'CNY', symbol: '¥', monthly: 35.99, quarterly: 97.17, yearly: 251.93 },
    IN: { currency: 'INR', symbol: '₹', monthly: 399, quarterly: 1077, yearly: 2793 },
    BR: { currency: 'BRL', symbol: 'R$', monthly: 25.99, quarterly: 70.17, yearly: 181.93 },
    AU: { currency: 'AUD', symbol: 'A$', monthly: 14.99, quarterly: 40.47, yearly: 104.93 }
  };

  // Système de traductions
  const translations = {
    fr: {
      appName: 'Math4Child',
      heroTitle: 'Math4Child',
      heroSubtitle: 'L\'application éducative n°1 pour apprendre les mathématiques',
      heroDescription: 'Domaine officiel: www.math4child.com - Application hybride disponible sur Web, Android et iOS',
      startFree: 'Commencer gratuitement',
      viewPlans: 'Voir les abonnements',
      freeWeekTrial: 'Essai gratuit d\'une semaine',
      questionsRemaining: 'questions restantes',
      home: 'Accueil',
      game: 'Jeu',
      levels: 'Niveaux',
      subscription: 'Abonnement',
      back: 'Retour',
      chooseLevel: 'Choisissez votre niveau',
      levelProgression: 'Progression des niveaux',
      features: 'Fonctionnalités',
      availableLanguages: 'langues disponibles',
      scrollToExplore: 'Faites défiler pour explorer'
    },
    en: {
      appName: 'Math4Child',
      heroTitle: 'Math4Child',
      heroSubtitle: 'The #1 educational app for learning mathematics',
      heroDescription: 'Official domain: www.math4child.com - Hybrid app available on Web, Android and iOS',
      startFree: 'Start for free',
      viewPlans: 'View plans',
      freeWeekTrial: 'One week free trial',
      questionsRemaining: 'questions remaining',
      home: 'Home',
      game: 'Game',
      levels: 'Levels',
      subscription: 'Subscription',
      back: 'Back',
      chooseLevel: 'Choose your level',
      levelProgression: 'Level progression',
      features: 'Features',
      availableLanguages: 'available languages',
      scrollToExplore: 'Scroll to explore'
    }
  };

  // Fonction de traduction
  const t = (key) => {
    const lang = translations[currentLanguage] || translations.fr;
    return lang[key] || translations.fr[key] || key;
  };

  // Configuration des niveaux
  const levels = [
    { 
      id: 'beginner', 
      name: 'Débutant (4-6 ans)', 
      color: 'bg-green-500', 
      range: [1, 10],
      description: 'Nombres 1-10'
    },
    { 
      id: 'elementary', 
      name: 'Élémentaire (6-8 ans)', 
      color: 'bg-blue-500', 
      range: [1, 50],
      description: 'Nombres 1-50'
    },
    { 
      id: 'intermediate', 
      name: 'Intermédiaire (8-10 ans)', 
      color: 'bg-purple-500', 
      range: [1, 100],
      description: 'Nombres 1-100'
    },
    { 
      id: 'advanced', 
      name: 'Avancé (10-12 ans)', 
      color: 'bg-red-500', 
      range: [1, 500],
      description: 'Nombres 1-500'
    },
    { 
      id: 'expert', 
      name: 'Expert (12+ ans)', 
      color: 'bg-gray-800', 
      range: [1, 1000],
      description: 'Nombres 1-1000'
    }
  ];

  // Gestion du changement de langue
  const handleLanguageChange = (langCode) => {
    setCurrentLanguage(langCode);
    setShowLanguageDropdown(false);
    
    const language = worldLanguages.find(l => l.code === langCode);
    if (language && language.countries.length > 0) {
      setCurrentCountry(language.countries[0]);
    }
  };

  // Rendu conditionnel des vues
  const renderCurrentView = () => {
    switch (currentView) {
      case 'levels':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-6xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-12">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">{t('chooseLevel')}</h1>
                <p className="text-lg text-gray-600">{t('levelProgression')}</p>
                <div className="mt-4 text-sm text-blue-600">
                  {freeQuestionsLeft} {t('questionsRemaining')}
                </div>
              </div>
              
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {levels.map((level, index) => {
                  const isUnlocked = unlockedLevels.includes(level.id);
                  const progress = correctAnswers[level.id] || 0;
                  
                  return (
                    <div 
                      key={level.id}
                      className={`cursor-pointer group bg-white rounded-2xl p-6 shadow-lg transition-all duration-300 border-2 ${
                        isUnlocked 
                          ? 'hover:shadow-2xl transform hover:-translate-y-2 border-gray-100 hover:border-blue-300' 
                          : 'opacity-60 cursor-not-allowed border-gray-200'
                      }`}
                    >
                      <div className={`w-16 h-16 ${isUnlocked ? level.color : 'bg-gray-400'} rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg ${isUnlocked ? 'group-hover:scale-110' : ''} transition-transform`}>
                        {isUnlocked ? (
                          <span className="text-white font-bold text-xl">{index + 1}</span>
                        ) : (
                          <Lock className="w-8 h-8 text-white" />
                        )}
                      </div>
                      
                      <h3 className="text-xl font-bold text-center text-gray-900 mb-2">{level.name}</h3>
                      <p className="text-center text-gray-600 text-sm mb-4">{level.description}</p>
                      
                      <div className="mb-4">
                        <div className="flex justify-between text-xs text-gray-500 mb-1">
                          <span>{progress}/100</span>
                          <span>{isUnlocked ? 'Débloqué' : 'Verrouillé'}</span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-2">
                          <div 
                            className={`${level.color} h-2 rounded-full transition-all duration-500`}
                            style={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                          ></div>
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        );

      case 'subscription':
        return (
          <div className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 py-20">
            <div className="max-w-7xl mx-auto px-4">
              <button 
                onClick={() => setCurrentView('home')}
                className="mb-8 flex items-center text-blue-600 hover:text-blue-800 font-medium"
              >
                <ArrowLeft className="w-5 h-5 mr-2" />
                {t('back')}
              </button>
              
              <div className="text-center mb-16">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">Choisissez votre abonnement</h1>
                <p className="text-xl text-gray-600 mb-4">Débloquez toutes les fonctionnalités</p>
                <p className="text-lg text-blue-600">Réductions multi-plateformes disponibles</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                {[
                  {
                    title: 'Gratuit',
                    price: '0€',
                    features: ['50 questions', 'Tous niveaux'],
                    popular: false
                  },
                  {
                    title: 'Mensuel',
                    price: '8.49€',
                    features: ['Questions illimitées', 'Support prioritaire'],
                    popular: true
                  },
                  {
                    title: 'Annuel',
                    price: '59.43€',
                    features: ['Questions illimitées', '30% de réduction'],
                    popular: false
                  }
                ].map((plan, index) => (
                  <div key={index} className={`bg-white rounded-3xl p-6 shadow-xl ${plan.popular ? 'ring-4 ring-blue-200' : ''}`}>
                    {plan.popular && (
                      <div className="text-center mb-4">
                        <span className="bg-blue-600 text-white px-4 py-2 rounded-full text-sm font-bold">
                          ⭐ Populaire
                        </span>
                      </div>
                    )}
                    <div className="text-center mb-6">
                      <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.title}</h3>
                      <div className="text-3xl font-bold text-blue-600">{plan.price}</div>
                    </div>
                    <ul className="space-y-3 mb-8">
                      {plan.features.map((feature, i) => (
                        <li key={i} className="flex items-center">
                          <Check className="w-5 h-5 text-green-500 mr-3" />
                          <span className="text-gray-700">{feature}</span>
                        </li>
                      ))}
                    </ul>
                    <button className={`w-full py-3 rounded-xl font-bold text-lg ${
                      plan.popular 
                        ? 'bg-blue-600 text-white hover:bg-blue-700' 
                        : 'bg-gray-100 text-gray-900 hover:bg-gray-200'
                    }`}>
                      Choisir ce plan
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        );

      default: // home
        return (
          <div>
            {/* Hero Section */}
            <section className="py-20 px-4 sm:px-6 lg:px-8 relative overflow-hidden">
              <div className="max-w-7xl mx-auto text-center">
                <div className="inline-flex items-center px-4 py-2 rounded-full bg-gradient-to-r from-blue-100 to-purple-100 text-blue-800 text-sm font-semibold mb-8 shadow-sm">
                  <Globe className="w-4 h-4 mr-2" />
                  {worldLanguages.length}+ langues supportées dans le monde entier
                </div>

                <h1 className="text-5xl md:text-7xl font-bold mb-8 leading-tight">
                  <span className="bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent">
                    {t('heroTitle')}
                  </span>
                </h1>
                
                <p className="text-xl md:text-2xl text-gray-600 mb-8 max-w-4xl mx-auto">
                  {t('heroSubtitle')}
                </p>
                
                <p className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto">
                  {t('heroDescription')}
                </p>
                
                {/* Compteur questions gratuites */}
                <div className="bg-gradient-to-r from-green-100 to-blue-100 rounded-2xl p-6 mb-12 max-w-md mx-auto">
                  <h3 className="text-lg font-bold text-gray-900 mb-2">{t('freeWeekTrial')}</h3>
                  <div className="text-3xl font-bold text-green-600 mb-2">{freeQuestionsLeft}/50</div>
                  <p className="text-sm text-gray-600">{t('questionsRemaining')}</p>
                  <div className="w-full bg-gray-200 rounded-full h-2 mt-3">
                    <div 
                      className="bg-gradient-to-r from-green-400 to-blue-500 h-2 rounded-full transition-all duration-500"
                      style={{ width: `${(freeQuestionsLeft / 50) * 100}%` }}
                    ></div>
                  </div>
                </div>
                
                <div className="flex flex-col sm:flex-row gap-6 justify-center items-center mb-16">
                  <button 
                    onClick={() => setCurrentView('levels')}
                    className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Play className="w-6 h-6 mr-3" />
                    {t('startFree')}
                    <ArrowRight className="w-5 h-5 ml-2 group-hover:translate-x-1 transition-transform" />
                  </button>
                  
                  <button 
                    onClick={() => setCurrentView('subscription')}
                    className="group bg-white text-gray-800 px-8 py-4 rounded-xl font-bold text-lg border-2 border-gray-200 hover:border-blue-300 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center"
                  >
                    <Crown className="w-6 h-6 mr-3 text-blue-600" />
                    {t('viewPlans')}
                  </button>
                </div>

                {/* Statistiques */}
                <div className="grid grid-cols-2 md:grid-cols-4 gap-8 max-w-4xl mx-auto mb-16">
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-blue-600 mb-2">{worldLanguages.length}+</div>
                    <div className="text-gray-600 font-medium">Langues</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-green-600 mb-2">5</div>
                    <div className="text-gray-600 font-medium">Niveaux</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-purple-600 mb-2">5</div>
                    <div className="text-gray-600 font-medium">Opérations</div>
                  </div>
                  <div className="text-center">
                    <div className="text-3xl md:text-4xl font-bold text-red-600 mb-2">3</div>
                    <div className="text-gray-600 font-medium">Plateformes</div>
                  </div>
                </div>

                {/* Progression preview */}
                <div className="bg-white rounded-2xl p-8 shadow-xl max-w-4xl mx-auto">
                  <h3 className="text-2xl font-bold text-gray-900 mb-6">{t('levelProgression')}</h3>
                  <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
                    {levels.map((level, index) => {
                      const isUnlocked = unlockedLevels.includes(level.id);
                      const progress = correctAnswers[level.id] || 0;
                      
                      return (
                        <div key={level.id} className="text-center">
                          <div className={`w-12 h-12 ${isUnlocked ? level.color : 'bg-gray-300'} rounded-full flex items-center justify-center mb-2 mx-auto`}>
                            {isUnlocked ? (
                              <span className="text-white font-bold">{index + 1}</span>
                            ) : (
                              <Lock className="w-6 h-6 text-white" />
                            )}
                          </div>
                          <div className="text-sm font-medium text-gray-900 mb-1">{level.name.split(' ')[0]}</div>
                          <div className="text-xs text-gray-500">{progress}/100</div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </section>

            {/* Features Section */}
            <section className="py-20 bg-white">
              <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <h2 className="text-4xl font-bold text-center mb-16 text-gray-900">{t('features')}</h2>
                
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                  {[
                    { 
                      icon: <Target className="w-8 h-8" />, 
                      title: "Système de Progression", 
                      description: "5 niveaux adaptatifs avec déblocage progressif",
                      color: 'from-blue-400 to-blue-600' 
                    },
                    { 
                      icon: <Calculator className="w-8 h-8" />, 
                      title: "Opérations Mathématiques", 
                      description: "Addition, soustraction, multiplication, division",
                      color: 'from-green-400 to-green-600' 
                    },
                    { 
                      icon: <Globe className="w-8 h-8" />, 
                      title: "Support Multilingue", 
                      description: "20+ langues avec support RTL",
                      color: 'from-purple-400 to-purple-600' 
                    },
                    { 
                      icon: <Crown className="w-8 h-8" />, 
                      title: "Multi-plateformes", 
                      description: "Web, Android et iOS avec réductions",
                      color: 'from-orange-400 to-orange-600' 
                    },
                    { 
                      icon: <Shield className="w-8 h-8" />, 
                      title: "Pricing Adaptatif", 
                      description: "Prix selon le pouvoir d'achat local",
                      color: 'from-red-400 to-red-600' 
                    },
                    { 
                      icon: <Smartphone className="w-8 h-8" />, 
                      title: "Application Hybride", 
                      description: "Technologie moderne PWA",
                      color: 'from-indigo-400 to-indigo-600' 
                    }
                  ].map((feature, index) => (
                    <div key={index} className="group bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1 border border-gray-100">
                      <div className={`w-16 h-16 bg-gradient-to-r ${feature.color} rounded-2xl flex items-center justify-center mb-6 shadow-lg group-hover:scale-110 transition-transform text-white`}>
                        {feature.icon}
                      </div>
                      <h3 className="text-2xl font-bold text-gray-900 mb-4">{feature.title}</h3>
                      <p className="text-gray-600 leading-relaxed">{feature.description}</p>
                    </div>
                  ))}
                </div>
              </div>
            </section>

            {/* CTA Final */}
            <section className="py-20 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600">
              <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <h2 className="text-4xl md:text-5xl font-bold text-white mb-6">
                  Prêt pour l'aventure mathématique ?
                </h2>
                <p className="text-xl text-blue-100 mb-12 max-w-2xl mx-auto">
                  Commencez avec 50 questions gratuites et découvrez Math4Child.
                </p>
                
                <div className="flex flex-col sm:flex-row gap-6 justify-center">
                  <button 
                    onClick={() => setCurrentView('levels')}
                    className="bg-white text-blue-600 px-8 py-4 rounded-xl font-bold text-lg shadow-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300"
                  >
                    Commencer gratuitement
                  </button>
                  <button 
                    onClick={() => setCurrentView('subscription')}
                    className="bg-transparent border-2 border-white text-white px-8 py-4 rounded-xl font-bold text-lg hover:bg-white hover:text-blue-600 transition-all duration-300"
                  >
                    Voir les plans
                  </button>
                </div>
              </div>
            </section>
          </div>
        );
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header avec sélecteur de langues */}
      <header className="bg-white/90 backdrop-blur-sm shadow-lg sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-20">
            <div 
              onClick={() => setCurrentView('home')}
              className="flex items-center space-x-4 cursor-pointer"
            >
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 via-red-500 to-pink-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <span className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                  {t('appName')}
                </span>
                <div className="text-xs text-gray-500 font-medium">www.math4child.com</div>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              {/* Navigation */}
              <nav className="hidden md:flex space-x-8">
                <button 
                  onClick={() => setCurrentView('home')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('home')}
                </button>
                <button 
                  onClick={() => setCurrentView('levels')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('game')}
                </button>
                <button 
                  onClick={() => setCurrentView('subscription')}
                  className="text-gray-700 hover:text-blue-600 font-medium transition-colors"
                >
                  {t('subscription')}
                </button>
              </nav>
              
              {/* Sélecteur de langue PREMIUM */}
              <div className="relative">
                <button
                  onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
                  className="flex items-center space-x-2 px-4 py-2 rounded-xl border border-gray-200 bg-white hover:bg-gray-50 transition-all shadow-sm"
                >
                  <span className="text-xl">{worldLanguages.find(l => l.code === currentLanguage)?.flag}</span>
                  <span className="hidden sm:inline font-medium">{worldLanguages.find(l => l.code === currentLanguage)?.name}</span>
                  <ChevronDown className="w-4 h-4 text-gray-500" />
                </button>
                
                {showLanguageDropdown && (
                  <div className="absolute right-0 mt-2 w-80 bg-white rounded-xl shadow-2xl border border-gray-100 z-50">
                    <div className="p-3 border-b border-gray-100 bg-gray-50 rounded-t-xl">
                      <div className="text-xs text-gray-600 text-center font-medium">
                        {worldLanguages.length} {t('availableLanguages')}
                      </div>
                    </div>
                    
                    <div className="max-h-80 overflow-y-auto scrollbar-thin scrollbar-thumb-blue-300 scrollbar-track-gray-100">
                      <div className="p-2">
                        {worldLanguages.map((lang) => (
                          <button
                            key={lang.code}
                            onClick={() => handleLanguageChange(lang.code)}
                            className={`w-full flex items-center space-x-3 px-3 py-2 hover:bg-blue-50 transition-colors rounded-lg ${
                              currentLanguage === lang.code ? 'bg-blue-50 border-r-4 border-blue-500' : ''
                            }`}
                          >
                            <span className="text-lg">{lang.flag}</span>
                            <div className="text-left flex-1">
                              <div className="font-medium text-gray-900 text-sm">{lang.name}</div>
                              <div className="text-xs text-gray-500">{lang.nativeName}</div>
                            </div>
                            {currentLanguage === lang.code && <Check className="w-4 h-4 text-blue-500" />}
                          </button>
                        ))}
                      </div>
                    </div>
                    
                    <div className="p-2 border-t border-gray-100 bg-gray-50 rounded-b-xl">
                      <div className="text-xs text-gray-500 text-center">
                        <span className="inline-flex items-center">
                          <span className="mr-1">↕️</span>
                          {t('scrollToExplore')}
                        </span>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      {renderCurrentView()}
    </div>
  );
};

export default Math4ChildProduction;
EOF

    success "Composant premium créé avec force"
}

# Build et redémarrage
rebuild_and_restart() {
    log "🔨 Build et redémarrage..."
    
    cd "$APP_DIR"
    
    # Build
    info "🏗️  Building application..."
    npm run build
    
    if [[ $? -ne 0 ]]; then
        warn "Build avec erreurs, mais continuons..."
    fi
    
    # Redémarrer le serveur
    info "🚀 Redémarrage du serveur de développement..."
    
    # Arrêter tous les processus existants
    pkill -f "next dev" || true
    sleep 2
    
    # Redémarrer en arrière-plan
    nohup npm run dev > /dev/null 2>&1 &
    
    sleep 3
    
    # Vérifier que le serveur démarre
    if pgrep -f "next dev" > /dev/null; then
        success "✅ Serveur redémarré avec succès"
        info "🌐 Application disponible sur: http://localhost:3000"
    else
        warn "⚠️  Le serveur ne semble pas démarré. Démarrez manuellement avec: npm run dev"
    fi
    
    cd - > /dev/null
}

# Test rapide
quick_test() {
    log "🧪 Test rapide de l'application..."
    
    # Vérifier le contenu du fichier
    if grep -q "worldLanguages.length.*langues supportées" "$APP_DIR/src/app/page.tsx"; then
        success "✅ Version premium confirmée dans le code"
    else
        error "❌ Version basique encore présente"
        return 1
    fi
    
    # Vérifier que le serveur répond
    sleep 2
    if curl -f http://localhost:3000 > /dev/null 2>&1; then
        success "✅ Serveur répond correctement"
    else
        warn "⚠️  Serveur ne répond pas encore (normal si démarrage en cours)"
    fi
}

# Fonction principale
main() {
    echo ""
    echo -e "${BLUE}=================================================================${NC}"
    echo -e "${BLUE}🔍 DIAGNOSTIC ET CORRECTION MATH4CHILD${NC}"
    echo -e "${BLUE}=================================================================${NC}"
    echo ""
    
    # Choix de l'utilisateur
    echo -e "${CYAN}Choisissez une option:${NC}"
    echo "1) Diagnostic seulement"
    echo "2) Nettoyage et correction (recommandé)"
    echo "3) Réinstallation complète"
    echo ""
    read -p "Votre choix (1-3): " choice
    
    case $choice in
        1)
            log "🔍 Diagnostic uniquement..."
            diagnose_project
            ;;
        2)
            log "🔧 Nettoyage et correction..."
            diagnose_project
            clean_everything
            check_dependencies
            force_replace_component
            rebuild_and_restart
            quick_test
            ;;
        3)
            log "🗑️  Réinstallation complète..."
            diagnose_project
            clean_everything --full
            check_dependencies
            force_replace_component
            rebuild_and_restart
            quick_test
            ;;
        *)
            error "Option invalide"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}=================================================================${NC}"
    echo -e "${GREEN}🎉 DIAGNOSTIC ET CORRECTION TERMINÉS !${NC}"
    echo -e "${GREEN}=================================================================${NC}"
    echo ""
    echo -e "${YELLOW}🚀 Prochaines étapes:${NC}"
    echo -e "   1. Vérifiez http://localhost:3000"
    echo -e "   2. Vous devriez voir la version premium avec:"
    echo -e "      • ${worldLanguages.length}+ langues supportées"
    echo -e "      • Design premium avec gradients"
    echo -e "      • Statistiques visuelles"
    echo -e "      • Navigation avancée"
    echo ""
    echo -e "${CYAN}Si l'ancienne version apparaît encore:${NC}"
    echo -e "   • Rafraîchissez la page (Cmd/Ctrl + R)"
    echo -e "   • Videz le cache navigateur (Cmd/Ctrl + Shift + R)"
    echo -e "   • Redémarrez le serveur: cd apps/math4child && npm run dev"
}

# Gestion des signaux
trap 'error "Script interrompu"' SIGINT SIGTERM

# Exécution
main "$@"