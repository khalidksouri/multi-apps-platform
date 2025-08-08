"use client"

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { useParams, useRouter } from 'next/navigation'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'
import { ExerciseEngine, Operation } from '@/components/exercises/ExerciseEngine'
import { HandwritingRecognition } from '@/components/features/HandwritingRecognition'
import { ARMathVisualizer } from '@/components/features/ARMathVisualizer'
import { VoiceAssistant } from '@/components/features/VoiceAssistant'

export default function LevelPage() {
  const params = useParams()
  const router = useRouter()
  const { t } = useLanguage()
  const level = parseInt(params.level as string)
  
  const [mounted, setMounted] = useState(false)
  const [selectedOperation, setSelectedOperation] = useState<Operation>('addition')
  const [isPlaying, setIsPlaying] = useState(false)
  const [currentMode, setCurrentMode] = useState<'traditional' | 'handwriting' | 'ar' | 'voice'>('traditional')
  const [currentProblem, setCurrentProblem] = useState<any>(null)

  const levelConfig = {
    1: { operations: ['addition'], name: 'Découverte' },
    2: { operations: ['addition', 'subtraction'], name: 'Exploration' },
    3: { operations: ['addition', 'subtraction', 'multiplication'], name: 'Maîtrise' },
    4: { operations: ['addition', 'subtraction', 'multiplication', 'division'], name: 'Expert' },
    5: { operations: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'], name: 'Champion' }
  }

  const config = levelConfig[level as keyof typeof levelConfig]

  useEffect(() => {
    setMounted(true)
    
    if (!config) {
      router.push('/exercises')
      return
    }

    setSelectedOperation(config.operations[0] as Operation)
  }, [level, config, router])

  if (!mounted || !config) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-500"></div>
      </div>
    )
  }

  const generateProblem = () => {
    return { num1: 5, num2: 3, operation: '+' }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50">
      <header className="bg-white shadow-sm border-b sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex justify-between items-center">
            <Link href="/" className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
                <span className="text-white font-bold text-lg">🧮</span>
              </div>
              <span className="font-bold text-xl text-gray-800">Math4Child</span>
            </Link>
            
            <div className="flex items-center gap-4">
              <Link href="/exercises" className="text-gray-600 hover:text-blue-600 transition-colors">
                ← Retour
              </Link>
              <LanguageSelector />
            </div>
          </div>
        </div>
      </header>

      <div className="py-8">
        <div className="max-w-7xl mx-auto px-4">
          
          {!isPlaying ? (
            <div className="grid lg:grid-cols-3 gap-8">
              <div className="lg:col-span-2 space-y-6">
                <div className="bg-white rounded-2xl p-6 shadow-lg">
                  <h1 className="text-3xl font-bold text-gray-800 mb-4">
                    Niveau {level} - {config.name}
                  </h1>
                  
                  <div className="mb-6">
                    <h3 className="text-lg font-bold text-gray-800 mb-3">Choisis ton opération</h3>
                    <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                      {config.operations.map((operation) => (
                        <button
                          key={operation}
                          onClick={() => setSelectedOperation(operation as Operation)}
                          className={`p-4 rounded-xl border-2 transition-all ${
                            selectedOperation === operation 
                              ? 'border-purple-500 bg-purple-50' 
                              : 'border-gray-200 hover:border-purple-300'
                          }`}
                        >
                          <div className="text-2xl mb-2">
                            {operation === 'addition' ? '➕' : 
                             operation === 'subtraction' ? '➖' :
                             operation === 'multiplication' ? '✖️' : '➗'}
                          </div>
                          <div className="text-sm font-medium">{operation}</div>
                        </button>
                      ))}
                    </div>
                  </div>

                  <div className="mb-6">
                    <h3 className="text-lg font-bold text-gray-800 mb-3">🚀 Choisis ton mode révolutionnaire</h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                      {[
                        { mode: 'traditional', icon: '🖥️', title: 'Mode Classique IA' },
                        { mode: 'handwriting', icon: '✍️', title: 'Écriture Manuscrite' },
                        { mode: 'ar', icon: '🥽', title: 'Réalité Augmentée' },
                        { mode: 'voice', icon: '🎙️', title: 'Assistant Vocal IA' }
                      ].map((modeOption) => (
                        <button
                          key={modeOption.mode}
                          onClick={() => setCurrentMode(modeOption.mode as any)}
                          className={`p-4 rounded-xl border-2 transition-all ${
                            currentMode === modeOption.mode
                              ? 'border-blue-500 bg-blue-50'
                              : 'border-gray-200 hover:border-blue-300'
                          }`}
                        >
                          <div className="text-3xl mb-2">{modeOption.icon}</div>
                          <h4 className="font-bold">{modeOption.title}</h4>
                        </button>
                      ))}
                    </div>
                  </div>

                  <button
                    onClick={() => {
                      setIsPlaying(true)
                      if (currentMode === 'ar') {
                        setCurrentProblem(generateProblem())
                      }
                    }}
                    className="w-full bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white px-8 py-4 rounded-xl font-bold text-lg"
                  >
                    🚀 Lancer l'Innovation !
                  </button>
                </div>
              </div>

              <div>
                <VoiceAssistant 
                  mathLevel={level}
                  currentProblem={currentProblem}
                  userPerformance={{}}
                  onHint={() => {}}
                  onEncouragement={() => {}}
                />
              </div>
            </div>
          ) : (
            <div className="max-w-4xl mx-auto">
              {currentMode === 'traditional' && (
                <ExerciseEngine
                  level={level}
                  operation={selectedOperation}
                  onAnswer={() => {}}
                  onComplete={() => setIsPlaying(false)}
                />
              )}

              {currentMode === 'handwriting' && (
                <div className="space-y-6">
                  <h2 className="text-2xl font-bold text-center">✍️ Mode Écriture Manuscrite</h2>
                  <HandwritingRecognition
                    onAnswer={() => {}}
                    placeholder="Écris ta réponse"
                  />
                </div>
              )}

              {currentMode === 'ar' && currentProblem && (
                <div className="space-y-6">
                  <h2 className="text-2xl font-bold text-center">🥽 Réalité Augmentée Mathématique</h2>
                  <ARMathVisualizer
                    mathConcept={selectedOperation}
                    problem={currentProblem}
                    onComplete={() => setCurrentProblem(generateProblem())}
                  />
                </div>
              )}

              <div className="text-center mt-8">
                <button
                  onClick={() => setIsPlaying(false)}
                  className="bg-gray-500 hover:bg-gray-600 text-white px-6 py-3 rounded-lg"
                >
                  ← Retour à la sélection
                </button>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
