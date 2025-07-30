#!/bin/bash

#===============================================================================
# MATH4CHILD - AJOUT DES PAGES MANQUANTES
# Crée les pages Exercices, Abonnement et Tableau de bord
#===============================================================================

set -euo pipefail

# Couleurs
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_message() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')] ✅ $1${NC}"
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                📚 MATH4CHILD - AJOUT PAGES MANQUANTES                       ║
║                   Création des pages Exercices et Abonnement                ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Aller dans le bon répertoire
find_app_directory() {
    if [ -d "/Users/khalidksouri/Desktop/multi-apps-platform/apps/math4child" ]; then
        cd /Users/khalidksouri/Desktop/multi-apps-platform/apps/math4child
    elif [ -d "/Users/khalidksouri/Desktop/multi-apps-platform/temp-math4child" ]; then
        cd /Users/khalidksouri/Desktop/multi-apps-platform/temp-math4child
    else
        log_message "ERROR: Répertoire de l'application non trouvé"
        exit 1
    fi
}

# Créer la page Exercices
create_exercises_page() {
    log_message "INFO: 🧮 Création de la page Exercices..."
    
    mkdir -p src/app/exercises
    cat > src/app/exercises/page.tsx << 'EOF'
'use client'

import { useState } from 'react'

export default function ExercisesPage() {
  const [selectedLevel, setSelectedLevel] = useState('')
  const [selectedOperation, setSelectedOperation] = useState('')
  const [currentProblem, setCurrentProblem] = useState(null)
  const [userAnswer, setUserAnswer] = useState('')
  const [score, setScore] = useState(0)
  const [feedback, setFeedback] = useState('')

  const levels = [
    { id: 'beginner', name: 'Débutant', age: '4-6 ans', icon: '🌱', color: '#10b981' },
    { id: 'elementary', name: 'Élémentaire', age: '7-10 ans', icon: '🌿', color: '#3b82f6' },
    { id: 'intermediate', name: 'Intermédiaire', age: '11-14 ans', icon: '🌳', color: '#8b5cf6' },
    { id: 'advanced', name: 'Avancé', age: '15-18 ans', icon: '🏔️', color: '#ef4444' }
  ]

  const operations = [
    { id: 'addition', name: 'Addition', symbol: '+', color: '#10b981', exercises: 1250 },
    { id: 'subtraction', name: 'Soustraction', symbol: '-', color: '#3b82f6', exercises: 980 },
    { id: 'multiplication', name: 'Multiplication', symbol: '×', color: '#8b5cf6', exercises: 870 },
    { id: 'division', name: 'Division', symbol: '÷', color: '#ef4444', exercises: 640 }
  ]

  const generateProblem = () => {
    if (!selectedLevel || !selectedOperation) return

    let num1, num2, correctAnswer
    
    // Générer des nombres selon le niveau
    switch (selectedLevel) {
      case 'beginner':
        num1 = Math.floor(Math.random() * 10) + 1
        num2 = Math.floor(Math.random() * 10) + 1
        break
      case 'elementary':
        num1 = Math.floor(Math.random() * 50) + 1
        num2 = Math.floor(Math.random() * 50) + 1
        break
      case 'intermediate':
        num1 = Math.floor(Math.random() * 100) + 1
        num2 = Math.floor(Math.random() * 100) + 1
        break
      case 'advanced':
        num1 = Math.floor(Math.random() * 1000) + 1
        num2 = Math.floor(Math.random() * 1000) + 1
        break
    }

    // Calculer selon l'opération
    switch (selectedOperation) {
      case 'addition':
        correctAnswer = num1 + num2
        break
      case 'subtraction':
        if (num1 < num2) [num1, num2] = [num2, num1] // Éviter les négatifs
        correctAnswer = num1 - num2
        break
      case 'multiplication':
        correctAnswer = num1 * num2
        break
      case 'division':
        // Assurer une division exacte
        correctAnswer = Math.floor(Math.random() * 20) + 1
        num1 = correctAnswer * num2
        break
    }

    setCurrentProblem({ num1, num2, correctAnswer })
    setUserAnswer('')
    setFeedback('')
  }

  const checkAnswer = () => {
    if (!currentProblem || !userAnswer) return

    const isCorrect = parseInt(userAnswer) === currentProblem.correctAnswer

    if (isCorrect) {
      setScore(score + 10)
      setFeedback('🎉 Excellent ! Bonne réponse !')
      setTimeout(() => {
        generateProblem()
      }, 2000)
    } else {
      setFeedback(`❌ Pas tout à fait ! La bonne réponse est ${currentProblem.correctAnswer}`)
    }
  }

  const getOperationSymbol = () => {
    const op = operations.find(o => o.id === selectedOperation)
    return op ? op.symbol : ''
  }

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        {/* Header */}
        <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
          <h1 style={{ 
            fontSize: '3rem', 
            fontWeight: 'bold', 
            color: '#1f2937', 
            marginBottom: '1rem' 
          }}>
            🧮 Exercices Mathématiques
          </h1>
          <p style={{ fontSize: '1.25rem', color: '#6b7280' }}>
            Choisissez votre niveau et commencez à apprendre !
          </p>
          {score > 0 && (
            <div style={{
              background: 'linear-gradient(135deg, #10b981, #3b82f6)',
              color: 'white',
              padding: '0.5rem 1.5rem',
              borderRadius: '2rem',
              fontSize: '1.125rem',
              fontWeight: 'bold',
              display: 'inline-block',
              marginTop: '1rem'
            }}>
              🌟 Score: {score} points
            </div>
          )}
        </div>

        {/* Sélection du niveau */}
        <section style={{ marginBottom: '3rem' }}>
          <h2 style={{ fontSize: '1.5rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
            Choisissez votre niveau
          </h2>
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
            gap: '1.5rem' 
          }}>
            {levels.map((level) => (
              <button
                key={level.id}
                onClick={() => setSelectedLevel(level.id)}
                style={{
                  padding: '1.5rem',
                  borderRadius: '1rem',
                  border: selectedLevel === level.id ? `3px solid ${level.color}` : '2px solid #e5e7eb',
                  background: selectedLevel === level.id ? level.color + '10' : 'white',
                  textAlign: 'center',
                  cursor: 'pointer',
                  transition: 'all 0.2s',
                  transform: selectedLevel === level.id ? 'scale(1.05)' : 'scale(1)',
                  boxShadow: selectedLevel === level.id ? '0 8px 25px rgba(0,0,0,0.15)' : '0 2px 10px rgba(0,0,0,0.1)'
                }}
              >
                <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>{level.icon}</div>
                <h3 style={{ fontSize: '1.125rem', fontWeight: '600', color: '#1f2937', marginBottom: '0.25rem' }}>
                  {level.name}
                </h3>
                <p style={{ color: '#6b7280', fontSize: '0.875rem' }}>{level.age}</p>
              </button>
            ))}
          </div>
        </section>

        {/* Sélection de l'opération */}
        <section style={{ marginBottom: '3rem' }}>
          <h2 style={{ fontSize: '1.5rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
            Choisissez une opération
          </h2>
          <div style={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', 
            gap: '1.5rem' 
          }}>
            {operations.map((operation) => (
              <button
                key={operation.id}
                onClick={() => setSelectedOperation(operation.id)}
                style={{
                  padding: '1.5rem',
                  borderRadius: '1rem',
                  border: selectedOperation === operation.id ? `3px solid ${operation.color}` : '2px solid #e5e7eb',
                  background: selectedOperation === operation.id ? operation.color + '10' : 'white',
                  textAlign: 'center',
                  cursor: 'pointer',
                  transition: 'all 0.2s',
                  transform: selectedOperation === operation.id ? 'scale(1.05)' : 'scale(1)',
                  boxShadow: selectedOperation === operation.id ? '0 8px 25px rgba(0,0,0,0.15)' : '0 2px 10px rgba(0,0,0,0.1)'
                }}
              >
                <div style={{
                  width: '4rem',
                  height: '4rem',
                  background: operation.color,
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontSize: '1.5rem',
                  fontWeight: 'bold',
                  margin: '0 auto 1rem auto'
                }}>
                  {operation.symbol}
                </div>
                <h3 style={{ fontSize: '1.125rem', fontWeight: '600', color: '#1f2937', marginBottom: '0.25rem' }}>
                  {operation.name}
                </h3>
                <p style={{ color: '#6b7280', fontSize: '0.875rem' }}>{operation.exercises} exercices</p>
              </button>
            ))}
          </div>
        </section>

        {/* Zone d'exercice */}
        {selectedLevel && selectedOperation && (
          <section style={{
            background: 'white',
            borderRadius: '1.5rem',
            padding: '3rem',
            boxShadow: '0 10px 40px rgba(0,0,0,0.1)',
            textAlign: 'center'
          }}>
            {!currentProblem ? (
              <div>
                <h3 style={{ fontSize: '1.5rem', color: '#1f2937', marginBottom: '1.5rem' }}>
                  Prêt à commencer ?
                </h3>
                <button
                  onClick={generateProblem}
                  style={{
                    background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                    color: 'white',
                    padding: '1rem 2rem',
                    borderRadius: '0.75rem',
                    fontSize: '1.125rem',
                    fontWeight: '600',
                    border: 'none',
                    cursor: 'pointer',
                    transition: 'transform 0.2s'
                  }}
                  onMouseOver={(e) => e.target.style.transform = 'scale(1.05)'}
                  onMouseOut={(e) => e.target.style.transform = 'scale(1)'}
                >
                  🚀 Commencer les exercices
                </button>
              </div>
            ) : (
              <div>
                <div style={{
                  fontSize: '3rem',
                  fontWeight: 'bold',
                  color: '#1f2937',
                  marginBottom: '2rem',
                  padding: '2rem',
                  background: 'linear-gradient(135deg, #eff6ff, #f3e8ff)',
                  borderRadius: '1rem',
                  border: '3px solid #3b82f6'
                }}>
                  {currentProblem.num1} {getOperationSymbol()} {currentProblem.num2} = ?
                </div>

                <div style={{ marginBottom: '2rem' }}>
                  <input
                    type="number"
                    value={userAnswer}
                    onChange={(e) => setUserAnswer(e.target.value)}
                    placeholder="Votre réponse"
                    style={{
                      fontSize: '2rem',
                      padding: '1rem',
                      border: '3px solid #3b82f6',
                      borderRadius: '0.75rem',
                      textAlign: 'center',
                      width: '200px',
                      marginRight: '1rem'
                    }}
                    onKeyPress={(e) => e.key === 'Enter' && checkAnswer()}
                  />
                  <button
                    onClick={checkAnswer}
                    style={{
                      background: '#10b981',
                      color: 'white',
                      border: 'none',
                      padding: '1rem 2rem',
                      fontSize: '1.125rem',
                      fontWeight: '600',
                      borderRadius: '0.75rem',
                      cursor: 'pointer'
                    }}
                  >
                    ✓ Vérifier
                  </button>
                </div>

                {feedback && (
                  <div style={{
                    fontSize: '1.25rem',
                    fontWeight: '600',
                    padding: '1rem 2rem',
                    borderRadius: '0.75rem',
                    background: feedback.includes('🎉') ? '#dcfce7' : '#fef2f2',
                    color: feedback.includes('🎉') ? '#166534' : '#dc2626',
                    display: 'inline-block'
                  }}>
                    {feedback}
                  </div>
                )}

                <div style={{ marginTop: '2rem' }}>
                  <button
                    onClick={generateProblem}
                    style={{
                      background: '#6b7280',
                      color: 'white',
                      border: 'none',
                      padding: '0.75rem 1.5rem',
                      fontSize: '1rem',
                      borderRadius: '0.5rem',
                      cursor: 'pointer'
                    }}
                  >
                    🔄 Nouveau problème
                  </button>
                </div>
              </div>
            )}
          </section>
        )}
      </div>
    </div>
  )
}
EOF
    
    log_message "SUCCESS: Page Exercices créée"
}

# Créer la page Abonnement
create_subscription_page() {
    log_message "INFO: 💎 Création de la page Abonnement..."
    
    mkdir -p src/app/subscription
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
      color: 'border-gray-300',
      buttonColor: 'bg-gray-600 hover:bg-gray-700',
      target: 'Particuliers'
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
        'Jusqu\'à 3 profils enfants'
      ],
      color: 'border-blue-500 ring-4 ring-blue-100',
      buttonColor: 'bg-blue-600 hover:bg-blue-700',
      popular: true,
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Familles'
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
        'Accès anticipé aux nouveautés'
      ],
      color: 'border-purple-300',
      buttonColor: 'bg-purple-600 hover:bg-purple-700',
      savings: billingPeriod === 'yearly' ? '20%' : null,
      target: 'Grandes familles'
    },
    {
      id: 'school',
      name: 'Écoles & Associations',
      description: 'Solution complète pour institutions éducatives',
      price: { monthly: 49.99, yearly: 39.99 },
      features: [
        'Comptes illimités élèves',
        'Tableau de bord enseignant',
        'Gestion de classes multiples',
        'Conformité RGPD éducation',
        'Formation des enseignants incluse',
        'Support technique dédié'
      ],
      color: 'border-emerald-400 ring-4 ring-emerald-100',
      buttonColor: 'bg-emerald-600 hover:bg-emerald-700',
      target: 'Institutions',
      badge: '🏫 Professionnel',
      contact: true
    }
  ]

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1400px', margin: '0 auto' }}>
        {/* Header */}
        <div style={{ textAlign: 'center', marginBottom: '3rem' }}>
          <h1 style={{ 
            fontSize: '3rem', 
            fontWeight: 'bold', 
            color: '#1f2937', 
            marginBottom: '1rem' 
          }}>
            💎 Choisissez votre abonnement
          </h1>
          <p style={{ fontSize: '1.25rem', color: '#6b7280', marginBottom: '2rem' }}>
            Débloquez tout le potentiel de Math4Child pour votre enfant ou votre établissement
          </p>

          {/* Toggle mensuel/annuel */}
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '1rem', marginBottom: '2rem' }}>
            <span style={{ color: billingPeriod === 'monthly' ? '#1f2937' : '#9ca3af', fontWeight: billingPeriod === 'monthly' ? '600' : '400' }}>
              Mensuel
            </span>
            <button
              onClick={() => setBillingPeriod(billingPeriod === 'monthly' ? 'yearly' : 'monthly')}
              style={{
                position: 'relative',
                width: '3rem',
                height: '1.5rem',
                background: billingPeriod === 'yearly' ? '#3b82f6' : '#d1d5db',
                borderRadius: '0.75rem',
                border: 'none',
                cursor: 'pointer',
                transition: 'background-color 0.2s'
              }}
            >
              <span style={{
                position: 'absolute',
                width: '1.25rem',
                height: '1.25rem',
                background: 'white',
                borderRadius: '50%',
                top: '0.125rem',
                left: billingPeriod === 'yearly' ? '1.625rem' : '0.125rem',
                transition: 'left 0.2s'
              }} />
            </button>
            <span style={{ color: billingPeriod === 'yearly' ? '#1f2937' : '#9ca3af', fontWeight: billingPeriod === 'yearly' ? '600' : '400' }}>
              Annuel
            </span>
            {billingPeriod === 'yearly' && (
              <span style={{
                background: '#dcfce7',
                color: '#166534',
                padding: '0.25rem 0.75rem',
                borderRadius: '1rem',
                fontSize: '0.875rem',
                fontWeight: '600'
              }}>
                💰 Économisez 20%
              </span>
            )}
          </div>
        </div>

        {/* Plans */}
        <div style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', 
          gap: '2rem',
          marginBottom: '4rem'
        }}>
          {plans.map((plan) => (
            <div key={plan.id} style={{
              background: 'white',
              borderRadius: '1.5rem',
              padding: '2rem',
              border: plan.color.includes('ring') ? '3px solid #3b82f6' : '2px solid #e5e7eb',
              position: 'relative',
              boxShadow: plan.popular ? '0 20px 40px rgba(59, 130, 246, 0.15)' : '0 10px 30px rgba(0,0,0,0.1)',
              transform: plan.popular ? 'scale(1.05)' : 'scale(1)',
              transition: 'all 0.3s'
            }}>
              {plan.popular && (
                <div style={{
                  position: 'absolute',
                  top: '-0.75rem',
                  left: '50%',
                  transform: 'translateX(-50%)',
                  background: '#3b82f6',
                  color: 'white',
                  padding: '0.5rem 1.5rem',
                  borderRadius: '1.5rem',
                  fontSize: '0.875rem',
                  fontWeight: '600'
                }}>
                  🔥 Plus populaire
                </div>
              )}

              {plan.badge && (
                <div style={{
                  position: 'absolute',
                  top: '-0.75rem',
                  left: '50%',
                  transform: 'translateX(-50%)',
                  background: '#10b981',
                  color: 'white',
                  padding: '0.5rem 1.5rem',
                  borderRadius: '1.5rem',
                  fontSize: '0.875rem',
                  fontWeight: '600'
                }}>
                  {plan.badge}
                </div>
              )}

              <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
                <div style={{ fontSize: '0.75rem', fontWeight: '500', color: '#6b7280', marginBottom: '0.5rem' }}>
                  {plan.target}
                </div>
                <h3 style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#1f2937', marginBottom: '0.5rem' }}>
                  {plan.name}
                </h3>
                <p style={{ color: '#6b7280', marginBottom: '1.5rem', fontSize: '0.875rem' }}>
                  {plan.description}
                </p>
                
                <div style={{ marginBottom: '1.5rem' }}>
                  {plan.price[billingPeriod] === 0 ? (
                    <span style={{ fontSize: '2.5rem', fontWeight: 'bold', color: '#1f2937' }}>Gratuit</span>
                  ) : plan.contact ? (
                    <div>
                      <span style={{ fontSize: '2rem', fontWeight: 'bold', color: '#10b981' }}>Sur devis</span>
                      <div style={{ fontSize: '0.75rem', color: '#6b7280', marginTop: '0.25rem' }}>
                        Tarifs préférentiels disponibles
                      </div>
                    </div>
                  ) : (
                    <div>
                      <span style={{ fontSize: '2.5rem', fontWeight: 'bold', color: '#1f2937' }}>
                        {plan.price[billingPeriod]}€
                      </span>
                      <span style={{ color: '#6b7280', fontSize: '1rem' }}>
                        /{billingPeriod === 'monthly' ? 'mois' : 'mois'}
                      </span>
                      {billingPeriod === 'yearly' && (
                        <div style={{ fontSize: '0.75rem', color: '#6b7280' }}>
                          Facturé {(plan.price.yearly * 12).toFixed(2)}€/an
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>

              <ul style={{ marginBottom: '2rem', padding: 0, listStyle: 'none' }}>
                {plan.features.map((feature, index) => (
                  <li key={index} style={{
                    display: 'flex',
                    alignItems: 'flex-start',
                    marginBottom: '0.75rem',
                    fontSize: '0.875rem',
                    color: '#374151'
                  }}>
                    <span style={{ color: '#10b981', marginRight: '0.75rem', fontSize: '1rem' }}>✓</span>
                    <span>{feature}</span>
                  </li>
                ))}
              </ul>

              <button style={{
                width: '100%',
                color: 'white',
                padding: '1rem',
                fontSize: '1rem',
                fontWeight: '600',
                borderRadius: '0.75rem',
                border: 'none',
                cursor: 'pointer',
                background: plan.id === 'free' ? '#6b7280' : 
                           plan.id === 'premium' ? '#3b82f6' : 
                           plan.id === 'family' ? '#8b5cf6' : '#10b981',
                transition: 'all 0.2s'
              }}>
                {plan.price[billingPeriod] === 0 ? 'Commencer gratuitement' : 
                 plan.contact ? 'Nous contacter' : 'Choisir ce plan'}
              </button>

              {plan.price[billingPeriod] > 0 && !plan.contact && (
                <p style={{ textAlign: 'center', fontSize: '0.75rem', color: '#6b7280', marginTop: '1rem', margin: '1rem 0 0 0' }}>
                  Essai gratuit de 7 jours • Annulable à tout moment
                </p>
              )}
            </div>
          ))}
        </div>

        {/* CTA pour les écoles */}
        <section style={{
          background: 'linear-gradient(135deg, #10b981, #3b82f6)',
          color: 'white',
          borderRadius: '1.5rem',
          padding: '3rem',
          textAlign: 'center'
        }}>
          <h2 style={{ fontSize: '2rem', fontWeight: 'bold', marginBottom: '1rem' }}>
            🎓 Vous êtes un établissement scolaire ?
          </h2>
          <p style={{ fontSize: '1.125rem', marginBottom: '2rem', opacity: 0.9 }}>
            Découvrez notre solution complète pour les écoles et associations
          </p>
          <button style={{
            background: 'white',
            color: '#10b981',
            padding: '1rem 2rem',
            borderRadius: '0.75rem',
            fontSize: '1.125rem',
            fontWeight: '600',
            border: 'none',
            cursor: 'pointer',
            boxShadow: '0 4px 20px rgba(0,0,0,0.2)'
          }}>
            📞 Demander une démonstration
          </button>
        </section>
      </div>
    </div>
  )
}
EOF
    
    log_message "SUCCESS: Page Abonnement créée"
}

# Créer la page Tableau de bord
create_dashboard_page() {
    log_message "INFO: 📊 Création de la page Tableau de bord..."
    
    mkdir -p src/app/dashboard
    cat > src/app/dashboard/page.tsx << 'EOF'
'use client'

import { useState } from 'react'

export default function DashboardPage() {
  const [selectedPeriod, setSelectedPeriod] = useState('week')

  // Données de démonstration
  const stats = {
    totalExercises: 156,
    correctAnswers: 134,
    currentStreak: 7,
    totalTime: 240,
    accuracy: 86,
    level: 'Intermédiaire'
  }

  const recentActivities = [
    { date: '2024-01-15', operation: 'Addition', exercises: 12, accuracy: 92, time: 15 },
    { date: '2024-01-14', operation: 'Soustraction', exercises: 8, accuracy: 88, time: 12 },
    { date: '2024-01-13', operation: 'Multiplication', exercises: 10, accuracy: 85, time: 18 },
    { date: '2024-01-12', operation: 'Division', exercises: 6, accuracy: 83, time: 22 }
  ]

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        {/* Header */}
        <div style={{ marginBottom: '3rem' }}>
          <h1 style={{ 
            fontSize: '2.5rem', 
            fontWeight: 'bold', 
            color: '#1f2937', 
            marginBottom: '0.5rem' 
          }}>
            📊 Tableau de bord
          </h1>
          <p style={{ fontSize: '1.125rem', color: '#6b7280' }}>
            Suivez vos progrès et vos performances
          </p>
        </div>

        {/* Statistiques principales */}
        <section style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: '1.5rem',
          marginBottom: '3rem'
        }}>
          {[
            { title: 'Exercices complétés', value: stats.totalExercises, icon: '📝', color: '#3b82f6' },
            { title: 'Réponses correctes', value: stats.correctAnswers, icon: '✅', color: '#10b981' },
            { title: 'Série actuelle', value: `${stats.currentStreak} jours`, icon: '🔥', color: '#f59e0b' },
            { title: 'Temps total', value: `${stats.totalTime} min`, icon: '⏱️', color: '#8b5cf6' }
          ].map((stat, index) => (
            <div key={index} style={{
              background: 'white',
              borderRadius: '1rem',
              padding: '2rem',
              boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
              textAlign: 'center',
              border: `3px solid ${stat.color}20`
            }}>
              <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>{stat.icon}</div>
              <div style={{ fontSize: '2rem', fontWeight: 'bold', color: stat.color, marginBottom: '0.5rem' }}>
                {stat.value}
              </div>
              <div style={{ color: '#6b7280', fontSize: '0.875rem' }}>{stat.title}</div>
            </div>
          ))}
        </section>

        {/* Précision et niveau */}
        <section style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
          gap: '2rem',
          marginBottom: '3rem'
        }}>
          {/* Précision */}
          <div style={{
            background: 'white',
            borderRadius: '1rem',
            padding: '2rem',
            boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
            textAlign: 'center'
          }}>
            <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
              🎯 Précision globale
            </h3>
            <div style={{
              width: '120px',
              height: '120px',
              borderRadius: '50%',
              background: `conic-gradient(#10b981 0% ${stats.accuracy}%, #e5e7eb ${stats.accuracy}% 100%)`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              margin: '0 auto',
              position: 'relative'
            }}>
              <div style={{
                width: '90px',
                height: '90px',
                borderRadius: '50%',
                background: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1.5rem',
                fontWeight: 'bold',
                color: '#10b981'
              }}>
                {stats.accuracy}%
              </div>
            </div>
          </div>

          {/* Niveau actuel */}
          <div style={{
            background: 'white',
            borderRadius: '1rem',
            padding: '2rem',
            boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
            textAlign: 'center'
          }}>
            <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
              🏆 Niveau actuel
            </h3>
            <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🌳</div>
            <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#8b5cf6', marginBottom: '0.5rem' }}>
              {stats.level}
            </div>
            <div style={{ color: '#6b7280', fontSize: '0.875rem' }}>
              Continuez comme ça !
            </div>
          </div>
        </section>

        {/* Activité récente */}
        <section style={{
          background: 'white',
          borderRadius: '1rem',
          padding: '2rem',
          boxShadow: '0 4px 20px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
            📈 Activité récente
          </h3>
          
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ borderBottom: '2px solid #f3f4f6' }}>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Date</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Opération</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Exercices</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Précision</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Temps</th>
                </tr>
              </thead>
              <tbody>
                {recentActivities.map((activity, index) => (
                  <tr key={index} style={{ borderBottom: '1px solid #f3f4f6' }}>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151' }}>
                      {new Date(activity.date).toLocaleDateString('fr-FR')}
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151' }}>
                      <span style={{
                        background: activity.operation === 'Addition' ? '#dcfce7' :
                                   activity.operation === 'Soustraction' ? '#dbeafe' :
                                   activity.operation === 'Multiplication' ? '#f3e8ff' : '#fef2f2',
                        color: activity.operation === 'Addition' ? '#166534' :
                               activity.operation === 'Soustraction' ? '#1e40af' :
                               activity.operation === 'Multiplication' ? '#7c3aed' : '#dc2626',
                        padding: '0.25rem 0.75rem',
                        borderRadius: '1rem',
                        fontSize: '0.875rem',
                        fontWeight: '500'
                      }}>
                        {activity.operation}
                      </span>
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151', fontWeight: '500' }}>
                      {activity.exercises}
                    </td>
                    <td style={{ padding: '1rem 0.75rem' }}>
                      <span style={{
                        color: activity.accuracy >= 90 ? '#166534' : activity.accuracy >= 80 ? '#f59e0b' : '#dc2626',
                        fontWeight: '600'
                      }}>
                        {activity.accuracy}%
                      </span>
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#6b7280' }}>
                      {activity.time} min
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  )
}
EOF
    
    log_message "SUCCESS: Page Tableau de bord créée"
}

# Fonction principale
main() {
    show_banner
    
    log_message "INFO: Création des pages manquantes..."
    
    find_app_directory
    create_exercises_page
    create_subscription_page
    create_dashboard_page
    
    log_message "SUCCESS: 🎉 Toutes les pages ont été créées !"
    
    echo ""
    echo -e "${BLUE}📱 PAGES CRÉÉES :${NC}"
    echo "   • 🧮 /exercises - Exercices interactifs avec vraies questions"
    echo "   • 💎 /subscription - 4 formules d'abonnement complètes"
    echo "   • 📊 /dashboard - Tableau de bord avec statistiques"
    echo ""
    echo "🌐 Testez maintenant :"
    echo "   • http://localhost:3000/exercises"
    echo "   • http://localhost:3000/subscription"
    echo "   • http://localhost:3000/dashboard"
}

main "$@"