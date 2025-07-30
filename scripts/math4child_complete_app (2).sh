#!/bin/bash

#===============================================================================
# MATH4CHILD - GÉNÉRATION APPLICATION COMPLÈTE
# Crée l'application complète avec toutes les fonctionnalités
#===============================================================================

set -euo pipefail

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] ℹ️  INFO: ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  WARN: ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ERROR: ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ SUCCESS: ${message}${NC}" ;;
        "DEBUG") echo -e "${BLUE}[${timestamp}] 🔍 DEBUG: ${message}${NC}" ;;
    esac
}

show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║               🎓 MATH4CHILD - APPLICATION ÉDUCATIVE COMPLÈTE                ║
║                   Génération de l'application complète                      ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Créer la structure complète de l'application
create_complete_structure() {
    log_message "INFO" "🏗️ Création de la structure complète..."
    
    cd apps/math4child
    
    # Créer toutes les pages et composants
    mkdir -p src/{app,components,hooks,utils,stores,types,styles}
    mkdir -p src/app/{auth,dashboard,exercises,subscription,profile,settings}
    mkdir -p src/components/{layout,ui,exercises,auth,subscription}
    
    # 1. LAYOUT PRINCIPAL avec Header et Footer
    cat > src/app/layout.tsx << 'EOF'
import { ReactNode } from 'react'
import Header from '@/components/layout/Header'
import Footer from '@/components/layout/Footer'
import '@/styles/globals.css'

export const metadata = {
  title: 'Math4Child - Application Éducative de Mathématiques',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques pour enfants de 4 à 18 ans',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="fr">
      <body className="min-h-screen bg-gradient-to-br from-blue-50 to-purple-50">
        <Header />
        <main className="flex-1">
          {children}
        </main>
        <Footer />
      </body>
    </html>
  )
}
EOF
    
    # 2. HEADER avec Navigation
    cat > src/components/layout/Header.tsx << 'EOF'
'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function Header() {
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [currentPlan, setCurrentPlan] = useState('free') // free, premium, family

  const menuItems = [
    { href: '/exercises', label: 'Exercices', icon: '🧮' },
    { href: '/dashboard', label: 'Tableau de bord', icon: '📊' },
    { href: '/subscription', label: 'Abonnement', icon: '💎' },
    { href: '/profile', label: 'Profil', icon: '👤' },
  ]

  const plans = {
    free: { name: 'Gratuit', color: 'bg-gray-100 text-gray-800' },
    premium: { name: 'Premium', color: 'bg-yellow-100 text-yellow-800' },
    family: { name: 'Famille', color: 'bg-purple-100 text-purple-800' }
  }

  return (
    <header className="bg-white shadow-lg border-b-4 border-blue-500">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
              <span className="text-white font-bold text-xl">M4C</span>
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">Math4Child</h1>
              <p className="text-xs text-gray-500">Apprendre en s'amusant</p>
            </div>
          </Link>

          {/* Navigation Desktop */}
          <nav className="hidden md:flex space-x-8">
            {menuItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className="flex items-center space-x-1 text-gray-700 hover:text-blue-600 px-3 py-2 rounded-md text-sm font-medium transition-colors"
              >
                <span>{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            ))}
          </nav>

          {/* Plan et Actions */}
          <div className="flex items-center space-x-4">
            {/* Badge du plan actuel */}
            <span className={`px-3 py-1 rounded-full text-xs font-medium ${plans[currentPlan].color}`}>
              {plans[currentPlan].name}
            </span>
            
            {/* Sélecteur de langue */}
            <select className="text-sm border rounded-md px-2 py-1">
              <option value="fr">🇫🇷 FR</option>
              <option value="en">🇺🇸 EN</option>
              <option value="es">🇪🇸 ES</option>
              <option value="ar">🇲🇦 AR</option>
            </select>

            {/* Menu mobile */}
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="md:hidden p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100"
            >
              <svg className="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
          </div>
        </div>

        {/* Menu Mobile */}
        {isMenuOpen && (
          <div className="md:hidden">
            <div className="px-2 pt-2 pb-3 space-y-1 sm:px-3 bg-gray-50 rounded-lg mt-2">
              {menuItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  className="flex items-center space-x-2 text-gray-700 hover:text-blue-600 block px-3 py-2 rounded-md text-base font-medium"
                  onClick={() => setIsMenuOpen(false)}
                >
                  <span>{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </div>
          </div>
        )}
      </div>
    </header>
  )
}
EOF
    
    # 3. FOOTER
    cat > src/components/layout/Footer.tsx << 'EOF'
export default function Footer() {
  return (
    <footer className="bg-gray-800 text-white mt-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Logo et description */}
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center space-x-2 mb-4">
              <div className="w-8 h-8 bg-gradient-to-br from-blue-500 to-purple-600 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold">M4C</span>
              </div>
              <h3 className="text-xl font-bold">Math4Child</h3>
            </div>
            <p className="text-gray-300 max-w-md">
              L'application éducative révolutionnaire qui rend l'apprentissage des mathématiques 
              amusant et interactif pour les enfants de 4 à 18 ans.
            </p>
            <div className="flex space-x-4 mt-4">
              <span className="text-2xl">🏆 +50k familles</span>
              <span className="text-2xl">🌍 14 langues</span>
              <span className="text-2xl">🎯 Adaptatif</span>
            </div>
          </div>

          {/* Liens rapides */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Fonctionnalités</h4>
            <ul className="space-y-2 text-gray-300">
              <li>🧮 Exercices interactifs</li>
              <li>📊 Suivi des progrès</li>
              <li>🎮 Gamification</li>
              <li>👨‍👩‍👧‍👦 Profils multiples</li>
              <li>📱 Mode hors ligne</li>
            </ul>
          </div>

          {/* Support */}
          <div>
            <h4 className="text-lg font-semibold mb-4">Support</h4>
            <ul className="space-y-2 text-gray-300">
              <li>📧 support@math4child.com</li>
              <li>📞 +33 1 23 45 67 89</li>
              <li>💬 Chat en direct</li>
              <li>📚 Centre d'aide</li>
              <li>👥 Communauté</li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-700 mt-8 pt-8 flex flex-col md:flex-row justify-between items-center">
          <p className="text-gray-400">
            © 2024 Math4Child. Tous droits réservés.
          </p>
          <div className="flex space-x-6 mt-4 md:mt-0">
            <a href="/privacy" className="text-gray-400 hover:text-white">Confidentialité</a>
            <a href="/terms" className="text-gray-400 hover:text-white">Conditions</a>
            <a href="/contact" className="text-gray-400 hover:text-white">Contact</a>
          </div>
        </div>
      </div>
    </footer>
  )
}
EOF
    
    # 4. PAGE D'ACCUEIL AMÉLIORÉE
    cat > src/app/page.tsx << 'EOF'
'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function HomePage() {
  const [selectedAge, setSelectedAge] = useState('')

  const features = [
    {
      icon: '🧮',
      title: 'Exercices Adaptés',
      description: 'Plus de 10 000 exercices personnalisés selon l\'âge et le niveau'
    },
    {
      icon: '🎯',
      title: 'Suivi Personnalisé',
      description: 'Algorithme intelligent qui s\'adapte au rythme de chaque enfant'
    },
    {
      icon: '🏆',
      title: 'Gamification',
      description: 'Points, badges et défis pour maintenir la motivation'
    },
    {
      icon: '🌍',
      title: 'Multilingue',
      description: 'Interface disponible en 14 langues avec support RTL'
    }
  ]

  const plans = [
    {
      name: 'Découverte',
      price: 'Gratuit',
      features: ['5 exercices/jour', 'Suivi basique', 'Support email'],
      color: 'border-gray-200',
      buttonColor: 'bg-gray-600 hover:bg-gray-700'
    },
    {
      name: 'Premium',
      price: '9,99€/mois',
      features: ['Exercices illimités', 'Analyses détaillées', 'Support prioritaire', 'Mode hors ligne'],
      color: 'border-blue-500 ring-2 ring-blue-500',
      buttonColor: 'bg-blue-600 hover:bg-blue-700',
      popular: true
    },
    {
      name: 'Famille',
      price: '19,99€/mois',
      features: ['Jusqu\'à 6 profils', 'Contrôle parental', 'Rapports détaillés', 'Support téléphonique'],
      color: 'border-purple-200',
      buttonColor: 'bg-purple-600 hover:bg-purple-700'
    }
  ]

  return (
    <div className="space-y-16">
      {/* Hero Section */}
      <section className="relative py-20 px-4 text-center">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6">
            Révolutionnez l'apprentissage des
            <span className="bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent"> mathématiques</span>
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Une application éducative intelligente qui s'adapte à chaque enfant 
            pour rendre les mathématiques amusantes et accessibles.
          </p>
          
          {/* Sélecteur d'âge */}
          <div className="mb-8">
            <label className="block text-lg font-medium text-gray-700 mb-4">
              Sélectionnez l'âge de votre enfant :
            </label>
            <select
              value={selectedAge}
              onChange={(e) => setSelectedAge(e.target.value)}
              className="px-6 py-3 text-lg border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
            >
              <option value="">Choisir un âge...</option>
              <option value="4-6">4-6 ans (Maternelle)</option>
              <option value="7-10">7-10 ans (Primaire)</option>
              <option value="11-14">11-14 ans (Collège)</option>
              <option value="15-18">15-18 ans (Lycée)</option>
            </select>
          </div>

          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link
              href="/exercises"
              className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200"
            >
              🚀 Commencer gratuitement
            </Link>
            <Link
              href="/subscription"
              className="bg-white text-gray-700 border-2 border-gray-300 px-8 py-4 rounded-lg text-lg font-semibold hover:border-blue-500 hover:text-blue-600 transition-all duration-200"
            >
              💎 Voir les abonnements
            </Link>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-16 px-4">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-12">
            Pourquoi choisir Math4Child ?
          </h2>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {features.map((feature, index) => (
              <div key={index} className="text-center p-6 bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow">
                <div className="text-4xl mb-4">{feature.icon}</div>
                <h3 className="text-xl font-semibold text-gray-900 mb-2">{feature.title}</h3>
                <p className="text-gray-600">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing */}
      <section className="py-16 px-4 bg-gray-50">
        <div className="max-w-6xl mx-auto">
          <h2 className="text-3xl font-bold text-center text-gray-900 mb-4">
            Choisissez votre formule
          </h2>
          <p className="text-center text-gray-600 mb-12">
            Commencez gratuitement, passez au premium quand vous êtes prêt
          </p>
          
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {plans.map((plan, index) => (
              <div key={index} className={`bg-white rounded-xl p-8 ${plan.color} relative`}>
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                      🔥 Populaire
                    </span>
                  </div>
                )}
                
                <div className="text-center mb-8">
                  <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
                  <div className="text-3xl font-bold text-gray-900 mb-4">{plan.price}</div>
                </div>
                
                <ul className="space-y-3 mb-8">
                  {plan.features.map((feature, featureIndex) => (
                    <li key={featureIndex} className="flex items-center text-gray-600">
                      <span className="text-green-500 mr-3">✓</span>
                      {feature}
                    </li>
                  ))}
                </ul>
                
                <Link
                  href="/subscription"
                  className={`w-full block text-center text-white px-6 py-3 rounded-lg font-semibold transition-colors ${plan.buttonColor}`}
                >
                  Choisir ce plan
                </Link>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Final */}
      <section className="py-16 px-4 bg-gradient-to-r from-blue-600 to-purple-600 text-white text-center">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Prêt à transformer l'apprentissage de votre enfant ?
          </h2>
          <p className="text-xl mb-8 opacity-90">
            Rejoignez plus de 50 000 familles qui font confiance à Math4Child
          </p>
          <Link
            href="/exercises"
            className="bg-white text-blue-600 px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200 inline-block"
          >
            🎯 Commencer l'aventure maintenant
          </Link>
        </div>
      </section>
    </div>
  )
}
EOF
    
    log_message "SUCCESS" "Pages principales créées"
}

# Créer les pages spécialisées
create_specialized_pages() {
    log_message "INFO" "📝 Création des pages spécialisées..."
    
    # PAGE EXERCICES
    cat > src/app/exercises/page.tsx << 'EOF'
'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function ExercisesPage() {
  const [selectedLevel, setSelectedLevel] = useState('')
  const [selectedOperation, setSelectedOperation] = useState('')

  const levels = [
    { id: 'beginner', name: 'Débutant', age: '4-6 ans', icon: '🌱' },
    { id: 'elementary', name: 'Élémentaire', age: '7-10 ans', icon: '🌿' },
    { id: 'intermediate', name: 'Intermédiaire', age: '11-14 ans', icon: '🌳' },
    { id: 'advanced', name: 'Avancé', age: '15-18 ans', icon: '🏔️' }
  ]

  const operations = [
    { id: 'addition', name: 'Addition', symbol: '+', color: 'bg-green-500', exercises: 1250 },
    { id: 'subtraction', name: 'Soustraction', symbol: '-', color: 'bg-blue-500', exercises: 980 },
    { id: 'multiplication', name: 'Multiplication', symbol: '×', color: 'bg-purple-500', exercises: 870 },
    { id: 'division', name: 'Division', symbol: '÷', color: 'bg-red-500', exercises: 640 }
  ]

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          🧮 Exercices Mathématiques
        </h1>
        <p className="text-xl text-gray-600">
          Choisissez votre niveau et commencez à apprendre !
        </p>
      </div>

      {/* Sélection du niveau */}
      <section className="mb-12">
        <h2 className="text-2xl font-semibold text-gray-900 mb-6">Choisissez votre niveau</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {levels.map((level) => (
            <button
              key={level.id}
              onClick={() => setSelectedLevel(level.id)}
              className={`p-6 rounded-xl border-2 text-center transition-all ${
                selectedLevel === level.id
                  ? 'border-blue-500 bg-blue-50 shadow-lg'
                  : 'border-gray-200 hover:border-blue-300 hover:shadow-md'
              }`}
            >
              <div className="text-4xl mb-3">{level.icon}</div>
              <h3 className="text-lg font-semibold text-gray-900">{level.name}</h3>
              <p className="text-gray-600">{level.age}</p>
            </button>
          ))}
        </div>
      </section>

      {/* Sélection de l'opération */}
      <section className="mb-12">
        <h2 className="text-2xl font-semibold text-gray-900 mb-6">Choisissez une opération</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {operations.map((operation) => (
            <button
              key={operation.id}
              onClick={() => setSelectedOperation(operation.id)}
              className={`p-6 rounded-xl border-2 text-center transition-all ${
                selectedOperation === operation.id
                  ? 'border-blue-500 bg-blue-50 shadow-lg'
                  : 'border-gray-200 hover:border-blue-300 hover:shadow-md'
              }`}
            >
              <div className={`w-16 h-16 ${operation.color} rounded-full flex items-center justify-center text-white text-2xl font-bold mx-auto mb-4`}>
                {operation.symbol}
              </div>
              <h3 className="text-lg font-semibold text-gray-900">{operation.name}</h3>
              <p className="text-gray-600">{operation.exercises} exercices</p>
            </button>
          ))}
        </div>
      </section>

      {/* Bouton de démarrage */}
      {selectedLevel && selectedOperation && (
        <div className="text-center">
          <Link
            href={`/exercises/${selectedLevel}/${selectedOperation}`}
            className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200 inline-block"
          >
            🚀 Commencer les exercices
          </Link>
        </div>
      )}
    </div>
  )
}
EOF
    
    # PAGE ABONNEMENT
    cat > src/app/subscription/page.tsx << 'EOF'
'use client'

import { useState } from 'react'

export default function SubscriptionPage() {
  const [billingPeriod, setBillingPeriod] = useState('monthly')

  const plans = [
    {
      id: 'free',
      name: 'Découverte',
      description: 'Parfait pour tester Math4Child',
      price: { monthly: 0, yearly: 0 },
      features: [
        '5 exercices par jour',
        'Suivi basique des progrès',
        'Accès aux additions simples',
        'Support par email',
        '1 profil enfant'
      ],
      limitations: [
        'Exercices limités',
        'Pas de statistiques avancées',
        'Pas de mode hors ligne'
      ],
      color: 'border-gray-300',
      buttonColor: 'bg-gray-600 hover:bg-gray-700'
    },
    {
      id: 'premium',
      name: 'Premium',
      description: 'L\'expérience complète pour un enfant',
      price: { monthly: 9.99, yearly: 7.99 },
      features: [
        'Exercices illimités',
        'Toutes les opérations mathématiques',
        'Analyses détaillées des progrès',
        'Mode hors ligne',
        'Contenu adaptatif IA',
        'Support prioritaire',
        'Jusqu\'à 3 profils enfants',
        'Contrôle parental avancé',
        'Badges et récompenses'
      ],
      color: 'border-blue-500 ring-4 ring-blue-100',
      buttonColor: 'bg-blue-600 hover:bg-blue-700',
      popular: true,
      savings: billingPeriod === 'yearly' ? '20%' : null
    },
    {
      id: 'family',
      name: 'Famille',
      description: 'Idéal pour les familles nombreuses',
      price: { monthly: 19.99, yearly: 15.99 },
      features: [
        'Tout le contenu Premium',
        'Jusqu\'à 6 profils enfants',
        'Rapports détaillés par enfant',
        'Contrôle parental complet',
        'Support téléphonique',
        'Accès anticipé aux nouveautés',
        'Sessions de groupe',
        'Tableau de bord familial',
        'Synchronisation multi-appareils'
      ],
      color: 'border-purple-300',
      buttonColor: 'bg-purple-600 hover:bg-purple-700',
      savings: billingPeriod === 'yearly' ? '20%' : null
    }
  ]

  const faqs = [
    {
      question: 'Puis-je changer de plan à tout moment ?',
      answer: 'Oui, vous pouvez upgrader ou downgrader votre plan à tout moment. Les changements prennent effet immédiatement.'
    },
    {
      question: 'Y a-t-il une période d\'essai gratuite ?',
      answer: 'Oui, tous les plans payants incluent une période d\'essai gratuite de 7 jours, sans engagement.'
    },
    {
      question: 'Que se passe-t-il si je résilie mon abonnement ?',
      answer: 'Vous gardez l\'accès aux fonctionnalités premium jusqu\'à la fin de votre période de facturation, puis revenez au plan gratuit.'
    },
    {
      question: 'Les prix sont-ils les mêmes dans tous les pays ?',
      answer: 'Non, nos prix s\'adaptent à la parité de pouvoir d\'achat de votre région pour rester accessibles.'
    }
  ]

  return (
    <div className="max-w-6xl mx-auto px-4 py-8">
      {/* Header */}
      <div className="text-center mb-12">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">
          💎 Choisissez votre abonnement
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          Débloquez tout le potentiel de Math4Child pour votre enfant
        </p>

        {/* Période de facturation */}
        <div className="flex items-center justify-center space-x-4 mb-8">
          <span className={billingPeriod === 'monthly' ? 'font-semibold' : 'text-gray-500'}>
            Mensuel
          </span>
          <button
            onClick={() => setBillingPeriod(billingPeriod === 'monthly' ? 'yearly' : 'monthly')}
            className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${
              billingPeriod === 'yearly' ? 'bg-blue-600' : 'bg-gray-200'
            }`}
          >
            <span
              className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${
                billingPeriod === 'yearly' ? 'translate-x-6' : 'translate-x-1'
              }`}
            />
          </button>
          <span className={billingPeriod === 'yearly' ? 'font-semibold' : 'text-gray-500'}>
            Annuel
          </span>
          {billingPeriod === 'yearly' && (
            <span className="bg-green-100 text-green-800 px-2 py-1 rounded-full text-sm font-medium">
              💰 Économisez 20%
            </span>
          )}
        </div>
      </div>

      {/* Plans */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-16">
        {plans.map((plan) => (
          <div key={plan.id} className={`bg-white rounded-2xl p-8 ${plan.color} relative shadow-lg`}>
            {plan.popular && (
              <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-medium">
                  🔥 Plus populaire
                </span>
              </div>
            )}

            {plan.savings && (
              <div className="absolute -top-2 -right-2">
                <span className="bg-green-500 text-white px-3 py-1 rounded-full text-xs font-medium">
                  -{plan.savings}
                </span>
              </div>
            )}

            <div className="text-center mb-8">
              <h3 className="text-2xl font-bold text-gray-900 mb-2">{plan.name}</h3>
              <p className="text-gray-600 mb-4">{plan.description}</p>
              
              <div className="mb-4">
                {plan.price[billingPeriod] === 0 ? (
                  <span className="text-4xl font-bold text-gray-900">Gratuit</span>
                ) : (
                  <div>
                    <span className="text-4xl font-bold text-gray-900">
                      {plan.price[billingPeriod]}€
                    </span>
                    <span className="text-gray-600">
                      /{billingPeriod === 'monthly' ? 'mois' : 'mois'}
                    </span>
                    {billingPeriod === 'yearly' && (
                      <div className="text-sm text-gray-500">
                        Facturé {(plan.price.yearly * 12).toFixed(2)}€/an
                      </div>
                    )}
                  </div>
                )}
              </div>
            </div>

            <ul className="space-y-3 mb-8">
              {plan.features.map((feature, index) => (
                <li key={index} className="flex items-start text-gray-700">
                  <span className="text-green-500 mr-3 mt-0.5">✓</span>
                  <span>{feature}</span>
                </li>
              ))}
            </ul>

            {plan.limitations && (
              <ul className="space-y-2 mb-8 border-t pt-4">
                {plan.limitations.map((limitation, index) => (
                  <li key={index} className="flex items-start text-gray-500 text-sm">
                    <span className="text-gray-400 mr-3 mt-0.5">✗</span>
                    <span>{limitation}</span>
                  </li>
                ))}
              </ul>
            )}

            <button className={`w-full text-white px-6 py-3 rounded-lg font-semibold transition-all duration-200 ${plan.buttonColor}`}>
              {plan.price[billingPeriod] === 0 ? 'Commencer gratuitement' : 'Choisir ce plan'}
            </button>

            {plan.price[billingPeriod] > 0 && (
              <p className="text-center text-sm text-gray-500 mt-3">
                Essai gratuit de 7 jours • Annulable à tout moment
              </p>
            )}
          </div>
        ))}
      </div>

      {/* FAQ */}
      <section className="mb-16">
        <h2 className="text-2xl font-bold text-center text-gray-900 mb-8">
          Questions fréquentes
        </h2>
        <div className="space-y-6">
          {faqs.map((faq, index) => (
            <div key={index} className="bg-white rounded-lg p-6 shadow-md">
              <h3 className="text-lg font-semibold text-gray-900 mb-3">
                {faq.question}
              </h3>
              <p className="text-gray-600">{faq.answer}</p>
            </div>
          ))}
        </div>
      </section>
    </div>
  )
}
EOF
    
    log_message "SUCCESS" "Pages spécialisées créées"
}

# Créer les styles globaux
create_global_styles() {
    log_message "INFO" "🎨 Création des styles globaux..."
    
    cat > src/styles/globals.css << 'EOF'
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

/* Styles personnalisés pour Math4Child */
@layer base {
  html {
    scroll-behavior: smooth;
  }
  
  body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  }
}

@layer components {
  .btn-primary {
    @apply bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200;
  }
  
  .btn-secondary {
    @apply bg-white text-gray-700 border-2 border-gray-300 px-6 py-3 rounded-lg font-semibold hover:border-blue-500 hover:text-blue-600 transition-all duration-200;
  }
  
  .card {
    @apply bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300;
  }
  
  .input-field {
    @apply w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-blue-500 focus:ring-2 focus:ring-blue-200 outline-none transition-all;
  }
}

/* Animations personnalisées */
@keyframes bounce-gentle {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

@keyframes pulse-color {
  0%, 100% {
    background-color: rgb(59 130 246);
  }
  50% {
    background-color: rgb(139 92 246);
  }
}

.animate-bounce-gentle {
  animation: bounce-gentle 2s infinite;
}

.animate-pulse-color {
  animation: pulse-color 3s ease-in-out infinite;
}

/* Styles pour les mathématiques */
.math-problem {
  @apply text-4xl font-bold text-center p-8 bg-gradient-to-r from-blue-100 to-purple-100 rounded-xl border-2 border-blue-300;
}

.math-input {
  @apply text-2xl text-center font-bold border-4 border-blue-500 rounded-lg p-4 w-32 mx-2;
}

/* Responsive */
@media (max-width: 640px) {
  .math-problem {
    @apply text-2xl p-4;
  }
  
  .math-input {
    @apply text-xl w-24 p-2;
  }
}

/* Mode sombre (pour plus tard) */
@media (prefers-color-scheme: dark) {
  .dark-mode {
    @apply bg-gray-900 text-white;
  }
}
EOF
    
    log_message "SUCCESS" "Styles globaux créés"
}

# Installer les dépendances nécessaires
install_complete_dependencies() {
    log_message "INFO" "📦 Installation des dépendances complètes..."
    
    # Mettre à jour package.json avec toutes les dépendances
    cat > package.json << 'EOF'
{
  "name": "math4child-app",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "clean": "rm -rf .next node_modules"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "typescript": "5.3.3",
    "@types/node": "20.10.6",
    "@types/react": "18.2.45",
    "@types/react-dom": "18.2.18",
    "tailwindcss": "3.4.0",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.32",
    "clsx": "2.0.0",
    "lucide-react": "0.300.0",
    "framer-motion": "10.16.16",
    "zustand": "4.4.7",
    "@heroicons/react": "2.0.18"
  },
  "devDependencies": {
    "eslint": "8.56.0",
    "eslint-config-next": "14.0.4",
    "@typescript-eslint/eslint-plugin": "6.18.1",
    "@typescript-eslint/parser": "6.18.1",
    "prettier": "3.1.1",
    "@tailwindcss/forms": "0.5.7",
    "@tailwindcss/typography": "0.5.10"
  }
}
EOF
    
    npm install
    
    log_message "SUCCESS" "Dépendances installées"
}

# Configuration Tailwind
setup_tailwind() {
    log_message "INFO" "🎨 Configuration de Tailwind CSS..."
    
    cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        },
        secondary: {
          50: '#faf5ff',
          100: '#f3e8ff',
          200: '#e9d5ff',
          300: '#d8b4fe',
          400: '#c084fc',
          500: '#a855f7',
          600: '#9333ea',
          700: '#7c3aed',
          800: '#6b21a8',
          900: '#581c87',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Poppins', 'system-ui', 'sans-serif'],
      },
      animation: {
        'bounce-gentle': 'bounce-gentle 2s infinite',
        'pulse-color': 'pulse-color 3s ease-in-out infinite',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
EOF
    
    cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    
    log_message "SUCCESS" "Tailwind CSS configuré"
}

# Fonction principale
main() {
    show_banner
    
    log_message "INFO" "🚀 Création de l'application Math4Child complète..."
    
    if [ ! -d "apps/math4child" ]; then
        log_message "ERROR" "Répertoire apps/math4child non trouvé. Exécutez d'abord le script de base."
        exit 1
    fi
    
    # Créer l'application complète
    create_complete_structure
    create_specialized_pages
    create_global_styles
    install_complete_dependencies
    setup_tailwind
    
    log_message "SUCCESS" "🎉 Application Math4Child complète créée !"
    
    echo ""
    echo -e "${CYAN}🎯 VOTRE APPLICATION MATH4CHILD EST PRÊTE !${NC}"
    echo ""
    echo "📱 Fonctionnalités disponibles :"
    echo "   • 🏠 Page d'accueil avec présentation complète"
    echo "   • 🧮 Page d'exercices avec sélection niveau/opération"
    echo "   • 💎 Page d'abonnement avec 3 formules"
    echo "   • 📊 Header avec navigation complète"
    echo "   • 🔗 Footer avec informations détaillées"
    echo "   • 🎨 Design moderne avec Tailwind CSS"
    echo "   • 📱 Interface responsive"
    echo "   • 🌍 Sélecteur de langues"
    echo ""
    echo "🚀 Pour démarrer :"
    echo "   cd apps/math4child && npm run dev"
    echo ""
    echo "🌐 Accès :"
    echo "   • Application : http://localhost:3000"
    echo "   • Exercices : http://localhost:3000/exercises"
    echo "   • Abonnements : http://localhost:3000/subscription"
}

main "$@"