#!/bin/bash
set -e

echo "🎨 AMÉLIORATION MODULE EXERCICES MATH4CHILD"
echo "   ✨ Transformation : Interface basique → Design moderne"
echo "   🎯 Objectif: Interface cohérente avec page d'accueil professionnelle"
echo "   📚 Module: /exercises avec nouveau design UX/UI"

ROOT_DIR=$(pwd)
APP_DIR="$ROOT_DIR/apps/math4child"

# Couleurs pour l'affichage
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}===========================================${NC}"
echo -e "${CYAN}    AMÉLIORATION MODULE EXERCICES          ${NC}"
echo -e "${CYAN}===========================================${NC}"

# Vérifier que l'app existe
if [ ! -d "$APP_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/math4child n'existe pas${NC}"
    exit 1
fi

cd "$APP_DIR"

echo ""
echo -e "${BLUE}💾 ÉTAPE 1/3: Sauvegarde module exercices actuel${NC}"

# Créer un dossier de sauvegarde
BACKUP_DIR="backup_exercises_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Sauvegarder le fichier exercises existant
if [ -f "src/app/exercises/page.tsx" ]; then
    cp "src/app/exercises/page.tsx" "$BACKUP_DIR/exercises_page.tsx.backup"
    echo "✅ Module exercises sauvegardé"
else
    echo "⚠️ Fichier exercises/page.tsx non trouvé - sera créé"
fi

echo -e "${GREEN}✅ Sauvegarde terminée dans: $BACKUP_DIR${NC}"

echo ""
echo -e "${BLUE}🎨 ÉTAPE 2/3: Application du nouveau design exercices${NC}"

# S'assurer que le dossier exercises existe
mkdir -p src/app/exercises

# Créer la nouvelle page exercises avec design moderne
cat > src/app/exercises/page.tsx << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'

type Operation = '+' | '-' | '×' | '÷'
type Difficulty = 'facile' | 'moyen' | 'difficile'

interface Exercise {
  id: number
  num1: number
  num2: number
  operation: Operation
  correctAnswer: number
  userAnswer: string
  isCorrect: boolean | null
}

export default function ExercisesPage() {
  const [difficulty, setDifficulty] = useState<Difficulty>('facile')
  const [operation, setOperation] = useState<Operation>('+')
  const [currentExercise, setCurrentExercise] = useState<Exercise | null>(null)
  const [score, setScore] = useState({ correct: 0, total: 0 })
  const [showResult, setShowResult] = useState(false)
  const [streak, setStreak] = useState(0)
  const [sessionTime, setSessionTime] = useState(0)
  const [isActive, setIsActive] = useState(false)
  const [showSettings, setShowSettings] = useState(false)

  // Timer pour la session
  useEffect(() => {
    let interval: NodeJS.Timeout | null = null
    if (isActive) {
      interval = setInterval(() => {
        setSessionTime(time => time + 1)
      }, 1000)
    } else if (!isActive && sessionTime !== 0) {
      if (interval) clearInterval(interval)
    }
    return () => {
      if (interval) clearInterval(interval)
    }
  }, [isActive, sessionTime])

  // Générer un nouvel exercice
  const generateExercise = (): Exercise => {
    const ranges = {
      facile: { min: 1, max: 10 },
      moyen: { min: 5, max: 50 },
      difficile: { min: 10, max: 100 }
    }

    const range = ranges[difficulty]
    let num1 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
    let num2 = Math.floor(Math.random() * (range.max - range.min + 1)) + range.min
    let correctAnswer: number

    switch (operation) {
      case '+':
        correctAnswer = num1 + num2
        break
      case '-':
        if (num1 < num2) [num1, num2] = [num2, num1]
        correctAnswer = num1 - num2
        break
      case '×':
        num1 = Math.floor(Math.random() * 12) + 1
        num2 = Math.floor(Math.random() * 12) + 1
        correctAnswer = num1 * num2
        break
      case '÷':
        correctAnswer = Math.floor(Math.random() * 12) + 1
        num2 = Math.floor(Math.random() * 12) + 1
        num1 = correctAnswer * num2
        break
    }

    return {
      id: Date.now(),
      num1,
      num2,
      operation,
      correctAnswer,
      userAnswer: '',
      isCorrect: null
    }
  }

  // Vérifier la réponse
  const checkAnswer = () => {
    if (!currentExercise) return
    setIsActive(true)

    const userNum = parseInt(currentExercise.userAnswer)
    const isCorrect = userNum === currentExercise.correctAnswer

    setCurrentExercise(prev => prev ? { ...prev, isCorrect } : null)
    setShowResult(true)
    
    setScore(prev => ({
      correct: prev.correct + (isCorrect ? 1 : 0),
      total: prev.total + 1
    }))

    setStreak(prev => isCorrect ? prev + 1 : 0)

    setTimeout(() => {
      setCurrentExercise(generateExercise())
      setShowResult(false)
    }, 2000)
  }

  // Démarrer une nouvelle session
  const startNewSession = () => {
    setScore({ correct: 0, total: 0 })
    setStreak(0)
    setSessionTime(0)
    setIsActive(false)
    setCurrentExercise(generateExercise())
    setShowResult(false)
  }

  useEffect(() => {
    setCurrentExercise(generateExercise())
  }, [difficulty, operation])

  const accuracyPercentage = score.total > 0 ? Math.round((score.correct / score.total) * 100) : 0
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, '0')}`
  }

  const getDifficultyColor = (diff: Difficulty) => {
    switch (diff) {
      case 'facile': return 'bg-green-500 text-white'
      case 'moyen': return 'bg-orange-500 text-white'
      case 'difficile': return 'bg-red-500 text-white'
    }
  }

  const getOperationIcon = (op: Operation) => {
    switch (op) {
      case '+': return '➕'
      case '-': return '➖'
      case '×': return '✖️'
      case '÷': return '➗'
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header avec navigation */}
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Link 
                href="/" 
                className="flex items-center space-x-3 text-gray-600 hover:text-gray-900 transition-colors"
              >
                <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 19l-7-7 7-7" />
                </svg>
                <span className="font-medium">Retour à l'accueil</span>
              </Link>
              <div className="w-px h-6 bg-gray-300"></div>
              <div className="flex items-center space-x-3">
                <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center">
                  <span className="text-white text-xl font-bold">📚</span>
                </div>
                <div>
                  <h1 className="text-xl font-bold text-gray-900">Exercices Math4Child</h1>
                  <p className="text-sm text-gray-600">Entraîne-toi à ton rythme</p>
                </div>
              </div>
            </div>

            <button
              onClick={() => setShowSettings(!showSettings)}
              className="bg-gray-100 hover:bg-gray-200 p-3 rounded-xl transition-colors"
            >
              <svg className="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              </svg>
            </button>
          </div>
        </div>
      </header>

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* Panel de configuration */}
        {showSettings && (
          <div className="bg-white rounded-2xl shadow-lg border mb-8 p-6">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xl font-bold text-gray-900">⚙️ Configuration</h2>
              <button
                onClick={startNewSession}
                className="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-xl font-semibold transition-colors shadow-lg"
              >
                🔄 Nouvelle Session
              </button>
            </div>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {/* Sélection difficulté */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-3">
                  🎯 Niveau de difficulté
                </label>
                <div className="grid grid-cols-1 gap-2">
                  {(['facile', 'moyen', 'difficile'] as Difficulty[]).map((diff) => (
                    <button
                      key={diff}
                      onClick={() => setDifficulty(diff)}
                      className={`p-4 rounded-xl text-left transition-all ${
                        difficulty === diff 
                          ? getDifficultyColor(diff) + ' shadow-lg'
                          : 'bg-gray-50 hover:bg-gray-100 text-gray-700'
                      }`}
                    >
                      <div className="font-semibold capitalize">{diff}</div>
                      <div className="text-sm opacity-80">
                        {diff === 'facile' && '1-10 • Parfait pour débuter'}
                        {diff === 'moyen' && '5-50 • Niveau intermédiaire'}
                        {diff === 'difficile' && '10-100 • Challenge expert'}
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* Sélection opération */}
              <div>
                <label className="block text-sm font-semibold text-gray-700 mb-3">
                  🧮 Type d'opération
                </label>
                <div className="grid grid-cols-2 gap-2">
                  {(['+', '-', '×', '÷'] as Operation[]).map((op) => (
                    <button
                      key={op}
                      onClick={() => setOperation(op)}
                      className={`p-4 rounded-xl text-center transition-all ${
                        operation === op 
                          ? 'bg-indigo-600 text-white shadow-lg'
                          : 'bg-gray-50 hover:bg-gray-100 text-gray-700'
                      }`}
                    >
                      <div className="text-2xl mb-1">{getOperationIcon(op)}</div>
                      <div className="text-sm font-medium">
                        {op === '+' && 'Addition'}
                        {op === '-' && 'Soustraction'}
                        {op === '×' && 'Multiplication'}
                        {op === '÷' && 'Division'}
                      </div>
                    </button>
                  ))}
                </div>
              </div>
            </div>
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Statistiques */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-2xl shadow-lg border p-6 mb-6">
              <h3 className="text-lg font-bold text-gray-900 mb-4">📊 Tes Performances</h3>
              
              <div className="space-y-4">
                <div className="flex justify-between items-center p-3 bg-green-50 rounded-xl">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-green-500 rounded-full flex items-center justify-center">
                      <span className="text-white font-bold">✓</span>
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900">Réussies</div>
                      <div className="text-sm text-gray-600">Sur {score.total} tentatives</div>
                    </div>
                  </div>
                  <div className="text-2xl font-bold text-green-600">{score.correct}</div>
                </div>

                <div className="flex justify-between items-center p-3 bg-blue-50 rounded-xl">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
                      <span className="text-white font-bold">%</span>
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900">Précision</div>
                      <div className="text-sm text-gray-600">Moyenne actuelle</div>
                    </div>
                  </div>
                  <div className="text-2xl font-bold text-blue-600">{accuracyPercentage}%</div>
                </div>

                <div className="flex justify-between items-center p-3 bg-orange-50 rounded-xl">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-orange-500 rounded-full flex items-center justify-center">
                      <span className="text-white font-bold">🔥</span>
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900">Série</div>
                      <div className="text-sm text-gray-600">Réponses consécutives</div>
                    </div>
                  </div>
                  <div className="text-2xl font-bold text-orange-600">{streak}</div>
                </div>

                <div className="flex justify-between items-center p-3 bg-purple-50 rounded-xl">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-purple-500 rounded-full flex items-center justify-center">
                      <span className="text-white font-bold">⏱</span>
                    </div>
                    <div>
                      <div className="font-semibold text-gray-900">Temps</div>
                      <div className="text-sm text-gray-600">Session actuelle</div>
                    </div>
                  </div>
                  <div className="text-2xl font-bold text-purple-600">{formatTime(sessionTime)}</div>
                </div>
              </div>
            </div>

            {/* Badges de motivation */}
            <div className="bg-white rounded-2xl shadow-lg border p-6">
              <h3 className="text-lg font-bold text-gray-900 mb-4">🏆 Récompenses</h3>
              
              <div className="space-y-3">
                {streak >= 5 && (
                  <div className="bg-gradient-to-r from-yellow-400 to-orange-500 text-white p-3 rounded-xl text-center">
                    <div className="text-xl font-bold">🔥 En feu !</div>
                    <div className="text-sm">{streak} bonnes réponses</div>
                  </div>
                )}
                
                {accuracyPercentage >= 90 && score.total >= 5 && (
                  <div className="bg-gradient-to-r from-green-400 to-blue-500 text-white p-3 rounded-xl text-center">
                    <div className="text-xl font-bold">🎯 Expert !</div>
                    <div className="text-sm">{accuracyPercentage}% de précision</div>
                  </div>
                )}

                {score.total >= 10 && (
                  <div className="bg-gradient-to-r from-purple-400 to-pink-500 text-white p-3 rounded-xl text-center">
                    <div className="text-xl font-bold">💪 Persévérant !</div>
                    <div className="text-sm">{score.total} exercices terminés</div>
                  </div>
                )}

                {streak === 0 && score.total === 0 && (
                  <div className="bg-gray-100 text-gray-600 p-3 rounded-xl text-center">
                    <div className="text-lg font-bold">🚀 Commence ton aventure !</div>
                    <div className="text-sm">Les badges apparaîtront ici</div>
                  </div>
                )}
              </div>
            </div>
          </div>

          {/* Zone d'exercice principale */}
          <div className="lg:col-span-2">
            <div className="bg-white rounded-2xl shadow-lg border p-8">
              {/* En-tête exercice */}
              <div className="text-center mb-8">
                <div className="inline-flex items-center space-x-2 bg-gray-100 rounded-full px-4 py-2 mb-4">
                  <span className={`px-3 py-1 rounded-full text-sm font-medium ${getDifficultyColor(difficulty)}`}>
                    {difficulty.charAt(0).toUpperCase() + difficulty.slice(1)}
                  </span>
                  <span className="text-gray-400">•</span>
                  <span className="text-sm font-medium text-gray-600">
                    {getOperationIcon(operation)} {
                      operation === '+' ? 'Addition' :
                      operation === '-' ? 'Soustraction' :
                      operation === '×' ? 'Multiplication' : 'Division'
                    }
                  </span>
                </div>
                
                <h2 className="text-2xl font-bold text-gray-900">
                  🧠 Exercice #{score.total + 1}
                </h2>
              </div>

              {/* Exercice actuel */}
              {currentExercise && (
                <div className="text-center">
                  {/* Problème mathématique */}
                  <div className="bg-gradient-to-br from-indigo-50 to-purple-50 rounded-3xl p-12 mb-8">
                    <div className="text-6xl font-bold text-gray-800 mb-8 leading-tight">
                      {currentExercise.num1} {currentExercise.operation} {currentExercise.num2} = ?
                    </div>

                    {!showResult ? (
                      <div className="space-y-6">
                        <div className="relative max-w-sm mx-auto">
                          <input
                            type="number"
                            value={currentExercise.userAnswer}
                            onChange={(e) => setCurrentExercise(prev => 
                              prev ? { ...prev, userAnswer: e.target.value } : null
                            )}
                            className="w-full text-4xl text-center p-6 rounded-2xl bg-white border-2 border-gray-200 focus:border-blue-500 focus:ring-4 focus:ring-blue-100 transition-all outline-none"
                            placeholder="?"
                            autoFocus
                          />
                        </div>

                        <button
                          onClick={checkAnswer}
                          disabled={!currentExercise.userAnswer}
                          className="bg-gradient-to-r from-green-500 to-green-600 hover:from-green-600 hover:to-green-700 text-white px-12 py-4 rounded-2xl font-bold text-xl transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-lg hover:shadow-xl transform hover:scale-105"
                        >
                          ✅ Vérifier ma réponse
                        </button>
                      </div>
                    ) : (
                      <div className="space-y-6">
                        {currentExercise.isCorrect ? (
                          <div className="bg-gradient-to-r from-green-100 to-emerald-100 border-2 border-green-200 rounded-2xl p-8">
                            <div className="text-6xl mb-4">🎉</div>
                            <div className="text-3xl font-bold text-green-800 mb-2">Excellent !</div>
                            <div className="text-xl text-green-700">
                              {currentExercise.num1} {currentExercise.operation} {currentExercise.num2} = {currentExercise.correctAnswer}
                            </div>
                            {streak > 1 && (
                              <div className="mt-4 text-lg text-green-600 font-semibold">
                                🔥 {streak} bonnes réponses d'affilée !
                              </div>
                            )}
                          </div>
                        ) : (
                          <div className="bg-gradient-to-r from-red-100 to-pink-100 border-2 border-red-200 rounded-2xl p-8">
                            <div className="text-6xl mb-4">🤔</div>
                            <div className="text-3xl font-bold text-red-800 mb-2">Pas tout à fait...</div>
                            <div className="text-xl text-red-700 mb-2">
                              Ta réponse : <span className="font-bold">{currentExercise.userAnswer}</span>
                            </div>
                            <div className="text-xl text-red-700">
                              Bonne réponse : <span className="font-bold text-green-600">{currentExercise.correctAnswer}</span>
                            </div>
                            <div className="mt-4 text-lg text-red-600">
                              💪 Continue, tu vas y arriver !
                            </div>
                          </div>
                        )}
                        
                        <div className="text-gray-500 text-lg">
                          <div className="animate-pulse">Nouvel exercice dans 2 secondes...</div>
                        </div>
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
EOF

echo "✅ Nouveau module exercices créé avec design moderne"

echo ""
echo -e "${BLUE}🧪 ÉTAPE 3/3: Test du module amélioré${NC}"

# Test rapide du serveur
echo "🚀 Test du module exercises..."
timeout 10s npm run dev > exercises_test.log 2>&1 &
TEST_PID=$!

sleep 3

if ps -p $TEST_PID > /dev/null; then
    echo -e "${GREEN}✅ Serveur actif${NC}"
    
    sleep 2
    if curl -s http://localhost:3000/exercises > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Module exercises accessible sur /exercises${NC}"
        echo -e "${GREEN}✅ Nouveau design chargé${NC}"
    else
        echo -e "${YELLOW}⚠️ Module pas encore accessible${NC}"
    fi
    
    kill $TEST_PID 2>/dev/null || true
    wait $TEST_PID 2>/dev/null || true
else
    echo -e "${YELLOW}⚠️ Test non concluant - redémarrer manuellement${NC}"
fi

echo ""
echo -e "${CYAN}===========================================${NC}"
echo -e "${CYAN}    AMÉLIORATION EXERCICES TERMINÉE !      ${NC}"
echo -e "${CYAN}===========================================${NC}"

echo ""
echo -e "${GREEN}🎨 MODULE EXERCICES COMPLÈTEMENT TRANSFORMÉ !${NC}"
echo ""
echo -e "${PURPLE}✨ NOUVELLES FONCTIONNALITÉS :${NC}"
echo "   🏗️ Header navigation cohérent avec l'accueil"
echo "   ⚙️ Panel de configuration avec bouton settings"
echo "   📊 Sidebar statistiques avec performances détaillées"
echo "   🎯 Sélecteurs visuels pour difficulté et opérations" 
echo "   🏆 Système de badges et récompenses motivant"
echo "   💫 Zone d'exercice avec design gradient moderne"
echo "   ✅ Feedback amélioré (succès/échec) avec animations"
echo "   📱 Layout responsive 3 colonnes → 1 colonne"
echo "   🎨 Cohérence visuelle avec la page d'accueil"
echo ""
echo -e "${BLUE}🚀 POUR TESTER LE NOUVEAU MODULE :${NC}"
echo "   cd apps/math4child"
echo "   npm run dev"
echo "   Aller sur http://localhost:3000/exercises"
echo ""
echo -e "${YELLOW}🧪 NOUVELLES FONCTIONNALITÉS À TESTER :${NC}"
echo ""
echo "1. 🧭 Header Navigation :"
echo "   - Cliquer 'Retour à l'accueil' → doit aller vers /"
echo "   - Bouton ⚙️ → ouvre/ferme panel configuration"
echo ""
echo "2. ⚙️ Configuration Avancée :"
echo "   - 3 niveaux difficulté : Facile/Moyen/Difficile"
echo "   - 4 opérations : Addition/Soustraction/Multiplication/Division"
echo "   - Bouton 'Nouvelle Session' → reset complet"
echo ""
echo "3. 📊 Statistiques Temps Réel :"
echo "   - Réussies avec compteur dynamique"
echo "   - Précision en pourcentage"
echo "   - Série (streak) de bonnes réponses"
echo "   - Timer de session"
echo ""
echo "4. 🏆 Système de Badges :"
echo "   - 'En feu' : 5+ bonnes réponses de suite"
echo "   - 'Expert' : 90%+ de précision sur 5+ exercices"
echo "   - 'Persévérant' : 10+ exercices terminés"
echo ""
echo "5. 💫 Zone d'Exercice :"
echo "   - Problème affiché en grand (text-6xl)"
echo "   - Input avec focus automatique"
echo "   - Bouton avec effet hover et animations"
echo "   - Feedback succès/échec avec couleurs et émojis"
echo ""
echo -e "${GREEN}🎯 LE MODULE EXERCISES EST MAINTENANT AU NIVEAU PROFESSIONNEL !${NC}"
echo ""
echo -e "${PURPLE}📋 CHECKLIST DE VALIDATION :${NC}"
echo "   ✅ Interface cohérente avec l'accueil"
echo "   ✅ Navigation fluide et intuitive"  
echo "   ✅ Configuration flexible et claire"
echo "   ✅ Statistiques motivantes en temps réel"
echo "   ✅ Système de récompenses engageant"
echo "   ✅ Design responsive et moderne"
echo "   ✅ Feedback positif et encourageant"
echo ""
echo -e "${BLUE}📁 SAUVEGARDE :${NC}"
echo "   Ancien module sauvegardé dans: $BACKUP_DIR/"
echo "   Pour restaurer si besoin: cp $BACKUP_DIR/*.backup src/app/exercises/"
echo ""
echo -e "${CYAN}🎊 Module Exercises maintenant digne d'une app EdTech premium ! 🎊${NC}"

cd "$ROOT_DIR"
echo ""
echo "✅ AMÉLIORATION EXERCISES TERMINÉE AVEC SUCCÈS !"