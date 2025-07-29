'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

interface GameStats {
  score: number
  level: number
  timeLeft: number
  isPlaying: boolean
}

export default function GamesPage() {
  const [selectedGame, setSelectedGame] = useState<string>('')
  const [quickMathStats, setQuickMathStats] = useState<GameStats>({
    score: 0, level: 1, timeLeft: 30, isPlaying: false
  })
  const [currentProblem, setCurrentProblem] = useState({ num1: 0, num2: 0, answer: 0 })
  const [userAnswer, setUserAnswer] = useState('')
  const [showResult, setShowResult] = useState(false)
  const [memoryCards, setMemoryCards] = useState<number[]>([])
  const [flippedCards, setFlippedCards] = useState<number[]>([])
  const [matchedCards, setMatchedCards] = useState<number[]>([])
  const [memoryScore, setMemoryScore] = useState(0)

  // Timer pour Quick Math
  useEffect(() => {
    let interval: NodeJS.Timeout | null = null
    if (quickMathStats.isPlaying && quickMathStats.timeLeft > 0) {
      interval = setInterval(() => {
        setQuickMathStats(prev => ({
          ...prev,
          timeLeft: prev.timeLeft - 1
        }))
      }, 1000)
    } else if (quickMathStats.timeLeft === 0) {
      setQuickMathStats(prev => ({ ...prev, isPlaying: false }))
    }
    return () => {
      if (interval) clearInterval(interval)
    }
  }, [quickMathStats.isPlaying, quickMathStats.timeLeft])

  // Générer un problème Quick Math
  const generateQuickMathProblem = () => {
    const level = quickMathStats.level
    const max = Math.min(10 + level * 5, 50)
    const num1 = Math.floor(Math.random() * max) + 1
    const num2 = Math.floor(Math.random() * max) + 1
    const operations = ['+', '-', '×']
    const operation = operations[Math.floor(Math.random() * operations.length)]
    
    let answer: number
    switch (operation) {
      case '+':
        answer = num1 + num2
        break
      case '-':
        answer = Math.abs(num1 - num2)
        break
      case '×':
        answer = num1 * num2
        break
      default:
        answer = num1 + num2
    }

    setCurrentProblem({ num1, num2, answer })
    setUserAnswer('')
    setShowResult(false)
  }

  // Démarrer Quick Math
  const startQuickMath = () => {
    setQuickMathStats({ score: 0, level: 1, timeLeft: 30, isPlaying: true })
    generateQuickMathProblem()
  }

  // Vérifier réponse Quick Math
  const checkQuickMathAnswer = () => {
    const correct = parseInt(userAnswer) === currentProblem.answer
    if (correct) {
      setQuickMathStats(prev => ({
        ...prev,
        score: prev.score + (10 * prev.level),
        level: prev.score > 0 && prev.score % 50 === 0 ? prev.level + 1 : prev.level
      }))
    }
    setShowResult(true)
    setTimeout(() => {
      if (quickMathStats.isPlaying) {
        generateQuickMathProblem()
      }
    }, 1000)
  }

  // Initialiser Memory Game
  const initMemoryGame = () => {
    const pairs = [1, 2, 3, 4, 5, 6, 7, 8]
    const cards = [...pairs, ...pairs].sort(() => Math.random() - 0.5)
    setMemoryCards(cards)
    setFlippedCards([])
    setMatchedCards([])
    setMemoryScore(0)
  }

  // Cliquer sur une carte Memory
  const flipCard = (index: number) => {
    if (flippedCards.length === 2 || flippedCards.includes(index) || matchedCards.includes(index)) {
      return
    }

    const newFlipped = [...flippedCards, index]
    setFlippedCards(newFlipped)

    if (newFlipped.length === 2) {
      const [first, second] = newFlipped
      if (memoryCards[first] === memoryCards[second]) {
        setMatchedCards(prev => [...prev, first, second])
        setMemoryScore(prev => prev + 10)
        setFlippedCards([])
      } else {
        setTimeout(() => setFlippedCards([]), 1000)
      }
    }
  }

  const gameCards = [
    {
      id: 'quickmath',
      title: '⚡ Quick Math',
      description: 'Résous un maximum de calculs en 30 secondes !',
      color: 'bg-blue-500/80'
    },
    {
      id: 'memory',
      title: '🧠 Memory Math',
      description: 'Trouve les paires de nombres identiques !',
      color: 'bg-green-500/80'
    },
    {
      id: 'sequence',
      title: '🔢 Séquence',
      description: 'Continue la séquence numérique !',
      color: 'bg-purple-500/80'
    },
    {
      id: 'puzzle',
      title: '🧩 Puzzle Math',
      description: 'Résous le puzzle mathématique !',
      color: 'bg-orange-500/80'
    }
  ]

  return (
    <div className="min-h-screen bg-gradient-to-br">
      {/* Header */}
      <header className="bg-white/10 backdrop-blur-sm border-white/20">
        <div className="max-w-6xl mx-auto px-4 py-4">
          <Link href="/" className="text-white hover:text-yellow-300 mb-4 block">
            ← Retour à l'accueil
          </Link>
          <h1 className="text-3xl font-bold text-white">🎮 Jeux Math4Child</h1>
          <p className="text-white/80">Apprends en t'amusant avec nos jeux éducatifs</p>
        </div>
      </header>

      <div className="max-w-6xl mx-auto px-4 py-8">
        {!selectedGame ? (
          /* Sélection de jeu */
          <div>
            <h2 className="text-2xl font-bold text-white mb-8 text-center">
              🎯 Choisis ton jeu préféré !
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {gameCards.map((game) => (
                <div
                  key={game.id}
                  onClick={() => setSelectedGame(game.id)}
                  className={`${game.color} rounded-3xl p-8 cursor-pointer transition-all transform hover:scale-105 border-white/30`}
                >
                  <h3 className="text-2xl font-bold text-white mb-4">{game.title}</h3>
                  <p className="text-white/80 mb-6">{game.description}</p>
                  <div className="text-center">
                    <button className="bg-white/20 text-white px-6 py-3 rounded-xl font-semibold hover:bg-white/30 transition-all">
                      🚀 Jouer
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        ) : selectedGame === 'quickmath' ? (
          /* Quick Math Game */
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-white">⚡ Quick Math</h2>
              <button
                onClick={() => setSelectedGame('')}
                className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-xl"
              >
                ← Retour
              </button>
            </div>

            {!quickMathStats.isPlaying ? (
              <div className="text-center">
                <div className="text-6xl mb-4">⚡</div>
                <h3 className="text-2xl font-bold text-white mb-4">Prêt pour le défi ?</h3>
                <p className="text-white/80 mb-8">Tu as 30 secondes pour résoudre un maximum de calculs !</p>
                <button
                  onClick={startQuickMath}
                  className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-bold text-lg"
                >
                  🚀 Démarrer !
                </button>
              </div>
            ) : (
              <div>
                {/* Stats du jeu */}
                <div className="grid grid-cols-3 gap-4 mb-8">
                  <div className="bg-green-500/80 rounded-2xl p-4 text-center">
                    <div className="text-2xl font-bold text-white">{quickMathStats.score}</div>
                    <div className="text-white/80">Score</div>
                  </div>
                  <div className="bg-blue-500/80 rounded-2xl p-4 text-center">
                    <div className="text-2xl font-bold text-white">{quickMathStats.level}</div>
                    <div className="text-white/80">Niveau</div>
                  </div>
                  <div className="bg-red-500/80 rounded-2xl p-4 text-center">
                    <div className="text-2xl font-bold text-white">{quickMathStats.timeLeft}</div>
                    <div className="text-white/80">Secondes</div>
                  </div>
                </div>

                {/* Problème actuel */}
                <div className="text-center">
                  <div className="text-4xl font-bold text-white mb-6">
                    {currentProblem.num1} + {currentProblem.num2} = ?
                  </div>
                  
                  {!showResult ? (
                    <div className="space-y-4">
                      <input
                        type="number"
                        value={userAnswer}
                        onChange={(e) => setUserAnswer(e.target.value)}
                        className="text-3xl text-center p-4 rounded-xl bg-white/20 text-white border-white/30 w-32"
                        autoFocus
                      />
                      <div>
                        <button
                          onClick={checkQuickMathAnswer}
                          disabled={!userAnswer}
                          className="bg-yellow-500 hover:bg-yellow-600 text-white px-6 py-3 rounded-xl font-bold disabled:opacity-50"
                        >
                          ✅ OK
                        </button>
                      </div>
                    </div>
                  ) : (
                    <div className="text-2xl text-green-300 font-bold">
                      {parseInt(userAnswer) === currentProblem.answer ? '🎉 Correct !' : `❌ C'était ${currentProblem.answer}`}
                    </div>
                  )}
                </div>
              </div>
            )}
          </div>
        ) : selectedGame === 'memory' ? (
          /* Memory Game */
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-white">🧠 Memory Math</h2>
              <div className="flex gap-4">
                <div className="text-white">Score: {memoryScore}</div>
                <button
                  onClick={initMemoryGame}
                  className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-xl"
                >
                  🔄 Nouveau
                </button>
                <button
                  onClick={() => setSelectedGame('')}
                  className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-xl"
                >
                  ← Retour
                </button>
              </div>
            </div>

            {memoryCards.length === 0 ? (
              <div className="text-center">
                <div className="text-6xl mb-4">🧠</div>
                <h3 className="text-2xl font-bold text-white mb-4">Memory des Nombres</h3>
                <p className="text-white/80 mb-8">Trouve toutes les paires de nombres identiques !</p>
                <button
                  onClick={initMemoryGame}
                  className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-bold text-lg"
                >
                  🚀 Commencer !
                </button>
              </div>
            ) : (
              <div className="grid grid-cols-4 gap-4 max-w-md mx-auto">
                {memoryCards.map((card, index) => (
                  <div
                    key={index}
                    onClick={() => flipCard(index)}
                    className={`aspect-square rounded-2xl flex items-center justify-center text-2xl font-bold cursor-pointer transition-all ${
                      flippedCards.includes(index) || matchedCards.includes(index)
                        ? 'bg-white text-purple-600'
                        : 'bg-purple-500/80 text-white hover:bg-purple-600/80'
                    }`}
                  >
                    {flippedCards.includes(index) || matchedCards.includes(index) ? card : '?'}
                  </div>
                ))}
              </div>
            )}

            {matchedCards.length === 16 && (
              <div className="text-center mt-8">
                <div className="text-4xl mb-4">🏆</div>
                <h3 className="text-2xl font-bold text-white">Bravo ! Tu as gagné !</h3>
                <p className="text-white/80">Score final : {memoryScore} points</p>
              </div>
            )}
          </div>
        ) : (
          /* Autres jeux - placeholder */
          <div className="bg-white/20 backdrop-blur-sm rounded-3xl p-8 border-white/30 text-center">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-2xl font-bold text-white">🚧 En Construction</h2>
              <button
                onClick={() => setSelectedGame('')}
                className="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-xl"
              >
                ← Retour
              </button>
            </div>
            <div className="text-6xl mb-4">🚧</div>
            <h3 className="text-2xl font-bold text-white mb-4">Ce jeu arrive bientôt !</h3>
            <p className="text-white/80">Nous travaillons sur ce jeu passionnant. Reviens bientôt !</p>
          </div>
        )}
      </div>
    </div>
  )
}
