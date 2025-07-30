#!/bin/bash

echo "🎯 Correction des niveaux pour âges 4-12 ans (Niv1-Niv5)"
echo "========================================================"

# Mettre à jour la page d'exercices avec les bons niveaux
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

  // Niveaux pour âges 4-12 ans (Maternelle → CM2)
  const levels = [
    { id: 'niv1', name: 'Niveau 1', age: '4-5 ans', icon: '🌱', color: '#10b981', description: 'Premiers nombres' },
    { id: 'niv2', name: 'Niveau 2', age: '6-7 ans', icon: '🌿', color: '#3b82f6', description: 'Nombres jusqu\'à 20' },
    { id: 'niv3', name: 'Niveau 3', age: '8-9 ans', icon: '🌳', color: '#8b5cf6', description: 'Nombres jusqu\'à 100' },
    { id: 'niv4', name: 'Niveau 4', age: '10-11 ans', icon: '🏔️', color: '#ef4444', description: 'Nombres jusqu\'à 1000' },
    { id: 'niv5', name: 'Niveau 5', age: '12+ ans', icon: '🚀', color: '#f59e0b', description: 'Nombres avancés' }
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
    
    // Générer des nombres selon le niveau (4-12 ans)
    switch (selectedLevel) {
      case 'niv1': // 4-5 ans - Nombres 1-10
        num1 = Math.floor(Math.random() * 5) + 1
        num2 = Math.floor(Math.random() * 5) + 1
        break
      case 'niv2': // 6-7 ans - Nombres 1-20
        num1 = Math.floor(Math.random() * 10) + 1
        num2 = Math.floor(Math.random() * 10) + 1
        break
      case 'niv3': // 8-9 ans - Nombres 1-50
        num1 = Math.floor(Math.random() * 25) + 1
        num2 = Math.floor(Math.random() * 25) + 1
        break
      case 'niv4': // 10-11 ans - Nombres 1-100
        num1 = Math.floor(Math.random() * 50) + 1
        num2 = Math.floor(Math.random() * 50) + 1
        break
      case 'niv5': // 12+ ans - Nombres 1-1000
        num1 = Math.floor(Math.random() * 100) + 1
        num2 = Math.floor(Math.random() * 100) + 1
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
        // Simplifier pour les petits niveaux
        if (selectedLevel === 'niv1' || selectedLevel === 'niv2') {
          num1 = Math.floor(Math.random() * 5) + 1
          num2 = Math.floor(Math.random() * 5) + 1
        }
        correctAnswer = num1 * num2
        break
      case 'division':
        // Division exacte adaptée au niveau
        correctAnswer = Math.floor(Math.random() * (selectedLevel === 'niv1' ? 5 : 10)) + 1
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
            Pour les enfants de 4 à 12 ans • Choisissez votre niveau !
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
            gridTemplateColumns: 'repeat(auto-fit, minmax(220px, 1fr))', 
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
                <p style={{ color: '#6b7280', fontSize: '0.875rem', marginBottom: '0.25rem' }}>{level.age}</p>
                <p style={{ color: '#6b7280', fontSize: '0.75rem' }}>{level.description}</p>
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

echo "✅ Niveaux corrigés pour âges 4-12 ans :"
echo "   🌱 Niveau 1 (4-5 ans) - Premiers nombres"
echo "   🌿 Niveau 2 (6-7 ans) - Nombres jusqu'à 20"
echo "   🌳 Niveau 3 (8-9 ans) - Nombres jusqu'à 100"
echo "   🏔️ Niveau 4 (10-11 ans) - Nombres jusqu'à 1000"
echo "   🚀 Niveau 5 (12+ ans) - Nombres avancés"