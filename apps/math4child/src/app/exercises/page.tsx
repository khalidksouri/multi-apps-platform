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
