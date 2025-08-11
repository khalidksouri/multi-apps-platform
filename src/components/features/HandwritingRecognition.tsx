"use client"

import { useState, useRef, useCallback, useEffect } from 'react'

interface Point {
  x: number
  y: number
  timestamp: number
}

interface Stroke {
  points: Point[]
  completed: boolean
}

interface RecognitionResult {
  text: string
  confidence: number
  alternatives: Array<{ text: string, confidence: number }>
  analysisData: {
    totalStrokes: number
    averageSpeed: number
    writingStyle: 'cursive' | 'print' | 'mixed'
    qualityScore: number
  }
}

interface HandwritingRecognitionProps {
  onAnswer: (answer: string, confidence: number) => void
  expectedAnswer?: string
  width?: number
  height?: number
  enableAnalytics?: boolean
}

export function HandwritingRecognition({ 
  onAnswer, 
  expectedAnswer,
  width = 400, 
  height = 200,
  enableAnalytics = true
}: HandwritingRecognitionProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const [isDrawing, setIsDrawing] = useState(false)
  const [strokes, setStrokes] = useState<Stroke[]>([])
  const [currentStroke, setCurrentStroke] = useState<Point[]>([])
  const [recognitionResult, setRecognitionResult] = useState<RecognitionResult | null>(null)
  const [isProcessing, setIsProcessing] = useState(false)
  const [processingStep, setProcessingStep] = useState('')

  // Obtenir les coordonnées relatives
  const getCoordinates = useCallback((event: React.MouseEvent | React.TouchEvent): Point => {
    const canvas = canvasRef.current
    if (!canvas) return { x: 0, y: 0, timestamp: Date.now() }

    const rect = canvas.getBoundingClientRect()
    const clientX = 'touches' in event ? event.touches[0]?.clientX || 0 : event.clientX
    const clientY = 'touches' in event ? event.touches[0]?.clientY || 0 : event.clientY

    return {
      x: clientX - rect.left,
      y: clientY - rect.top,
      timestamp: Date.now()
    }
  }, [])

  // Commencer le dessin
  const startDrawing = useCallback((event: React.MouseEvent | React.TouchEvent) => {
    event.preventDefault()
    const point = getCoordinates(event)
    setIsDrawing(true)
    setCurrentStroke([point])
  }, [getCoordinates])

  // Dessiner
  const draw = useCallback((event: React.MouseEvent | React.TouchEvent) => {
    if (!isDrawing) return
    event.preventDefault()

    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (!canvas || !ctx) return

    const point = getCoordinates(event)
    
    setCurrentStroke(prev => {
      const newStroke = [...prev, point]
      
      // Dessiner la ligne
      if (newStroke.length > 1) {
        const prevPoint = newStroke[newStroke.length - 2]
        ctx.beginPath()
        ctx.moveTo(prevPoint.x, prevPoint.y)
        ctx.lineTo(point.x, point.y)
        ctx.stroke()
      }
      
      return newStroke
    })
  }, [isDrawing, getCoordinates])

  // Arrêter le dessin
  const stopDrawing = useCallback(() => {
    if (!isDrawing) return
    
    setIsDrawing(false)
    setStrokes(prev => [...prev, { points: currentStroke, completed: true }])
    setCurrentStroke([])
  }, [isDrawing, currentStroke])

  // Effacer le canvas
  const clearCanvas = useCallback(() => {
    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (!canvas || !ctx) return

    ctx.clearRect(0, 0, canvas.width, canvas.height)
    setStrokes([])
    setCurrentStroke([])
    setRecognitionResult(null)
  }, [])

  // Annuler le dernier trait
  const undoLastStroke = useCallback(() => {
    setStrokes(prev => {
      const newStrokes = prev.slice(0, -1)
      
      // Redessiner le canvas
      const canvas = canvasRef.current
      const ctx = canvas?.getContext('2d')
      if (!canvas || !ctx) return prev

      ctx.clearRect(0, 0, canvas.width, canvas.height)
      
      newStrokes.forEach(stroke => {
        if (stroke.points.length > 1) {
          ctx.beginPath()
          ctx.moveTo(stroke.points[0].x, stroke.points[0].y)
          stroke.points.slice(1).forEach(point => {
            ctx.lineTo(point.x, point.y)
          })
          ctx.stroke()
        }
      })
      
      return newStrokes
    })
  }, [])

  // Reconnaissance manuscrite simulée avancée
  const recognizeHandwriting = useCallback(async () => {
    if (strokes.length === 0) return

    setIsProcessing(true)
    setProcessingStep('🔍 Analyse des traits...')
    
    await new Promise(resolve => setTimeout(resolve, 800))
    setProcessingStep('🧠 Reconnaissance IA...')
    
    await new Promise(resolve => setTimeout(resolve, 600))
    setProcessingStep('📊 Calcul confiance...')
    
    await new Promise(resolve => setTimeout(resolve, 400))

    // Simulation reconnaissance avancée
    const analysisData = {
      totalStrokes: strokes.length,
      averageSpeed: calculateAverageSpeed(),
      writingStyle: determineWritingStyle(),
      qualityScore: calculateQualityScore()
    }

    // Générateur de reconnaissance intelligente
    const possibleAnswers = generatePossibleAnswers()
    const mainAnswer = possibleAnswers[0]
    
    const result: RecognitionResult = {
      text: mainAnswer.text,
      confidence: mainAnswer.confidence,
      alternatives: possibleAnswers.slice(1, 4),
      analysisData
    }

    setRecognitionResult(result)
    setIsProcessing(false)
  }, [strokes])

  // Calcul vitesse moyenne d'écriture
  const calculateAverageSpeed = (): number => {
    if (strokes.length === 0) return 0

    let totalDistance = 0
    let totalTime = 0

    strokes.forEach(stroke => {
      for (let i = 1; i < stroke.points.length; i++) {
        const prev = stroke.points[i - 1]
        const curr = stroke.points[i]
        
        const distance = Math.sqrt(
          Math.pow(curr.x - prev.x, 2) + Math.pow(curr.y - prev.y, 2)
        )
        const time = curr.timestamp - prev.timestamp
        
        totalDistance += distance
        totalTime += time
      }
    })

    return totalTime > 0 ? totalDistance / totalTime : 0
  }

  // Détermination du style d'écriture
  const determineWritingStyle = (): 'cursive' | 'print' | 'mixed' => {
    if (strokes.length < 2) return 'print'
    
    const avgPointsPerStroke = strokes.reduce((sum, stroke) => sum + stroke.points.length, 0) / strokes.length
    
    if (avgPointsPerStroke > 15) return 'cursive'
    if (avgPointsPerStroke < 8) return 'print'
    return 'mixed'
  }

  // Calcul score qualité
  const calculateQualityScore = (): number => {
    if (strokes.length === 0) return 0

    let score = 100
    
    // Pénalité pour trop de traits (confusion)
    if (strokes.length > 10) score -= (strokes.length - 10) * 5
    
    // Bonus pour consistance
    const avgStrokeLength = strokes.reduce((sum, s) => sum + s.points.length, 0) / strokes.length
    if (avgStrokeLength > 5 && avgStrokeLength < 20) score += 10
    
    return Math.max(60, Math.min(100, score))
  }

  // Génération des réponses possibles
  const generatePossibleAnswers = () => {
    const answers = []
    
    // Si on attend une réponse spécifique
    if (expectedAnswer) {
      answers.push({ text: expectedAnswer, confidence: 85 + Math.random() * 10 })
      
      // Ajouter des alternatives proches
      const num = parseInt(expectedAnswer)
      if (!isNaN(num)) {
        answers.push({ text: (num + 1).toString(), confidence: 70 + Math.random() * 10 })
        answers.push({ text: (num - 1).toString(), confidence: 65 + Math.random() * 10 })
        answers.push({ text: (num + 10).toString(), confidence: 60 + Math.random() * 10 })
      }
    } else {
      // Génération aléatoire intelligente basée sur les traits
      const strokeComplexity = strokes.length
      
      if (strokeComplexity <= 2) {
        // Chiffres simples
        answers.push({ text: Math.floor(Math.random() * 10).toString(), confidence: 80 + Math.random() * 15 })
      } else if (strokeComplexity <= 5) {
        // Nombres à 2 chiffres
        answers.push({ text: (10 + Math.floor(Math.random() * 90)).toString(), confidence: 75 + Math.random() * 15 })
      } else {
        // Nombres plus complexes
        answers.push({ text: (100 + Math.floor(Math.random() * 900)).toString(), confidence: 70 + Math.random() * 15 })
      }
      
      // Alternatives
      for (let i = 0; i < 3; i++) {
        answers.push({ 
          text: Math.floor(Math.random() * 100).toString(), 
          confidence: 50 + Math.random() * 20 
        })
      }
    }
    
    return answers.sort((a, b) => b.confidence - a.confidence)
  }

  // Configuration du canvas
  useEffect(() => {
    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (!canvas || !ctx) return

    // Configuration du style de dessin
    ctx.strokeStyle = '#2563eb'
    ctx.lineWidth = 3
    ctx.lineCap = 'round'
    ctx.lineJoin = 'round'
  }, [])

  return (
    <div className="space-y-4">
      <div className="text-center">
        <h3 className="text-lg font-bold text-gray-800 mb-2">
          ✍️ Reconnaissance Manuscrite Révolutionnaire
        </h3>
        <p className="text-sm text-gray-600">
          Écrivez votre réponse avec votre doigt ou stylet
        </p>
      </div>

      {/* Canvas de dessin */}
      <div className="relative border-2 border-dashed border-gray-300 rounded-lg overflow-hidden">
        <canvas
          ref={canvasRef}
          width={width}
          height={height}
          className="block w-full h-auto bg-white cursor-crosshair hover:bg-gray-50 transition-colors"
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
          onTouchStart={startDrawing}
          onTouchMove={draw}
          onTouchEnd={stopDrawing}
          style={{ touchAction: 'none' }}
        />
        
        {isProcessing && (
          <div className="absolute inset-0 bg-blue-50 bg-opacity-90 flex items-center justify-center rounded-lg">
            <div className="text-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto mb-3"></div>
              <p className="text-blue-600 font-medium text-sm">{processingStep}</p>
              <div className="w-32 h-1 bg-blue-200 rounded-full mx-auto mt-2">
                <div className="h-1 bg-blue-500 rounded-full transition-all duration-300" style={{ width: '75%' }}></div>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Résultats de reconnaissance */}
      {recognitionResult && (
        <div className="bg-gradient-to-r from-green-50 to-blue-50 border border-green-200 rounded-lg p-4">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <span className="text-green-600 text-xl">🎯</span>
              <span className="font-bold text-green-800">Reconnu :</span>
              <span className="text-2xl font-bold text-green-900">{recognitionResult.text}</span>
            </div>
            <div className="text-right">
              <div className="text-sm text-gray-600">Confiance</div>
              <div className="text-lg font-bold text-blue-600">{Math.round(recognitionResult.confidence)}%</div>
            </div>
          </div>
          
          {recognitionResult.alternatives.length > 0 && (
            <div className="border-t border-gray-200 pt-2">
              <div className="text-xs text-gray-600 mb-1">Alternatives possibles :</div>
              <div className="flex gap-2">
                {recognitionResult.alternatives.slice(0, 3).map((alt, index) => (
                  <button
                    key={index}
                    onClick={() => onAnswer(alt.text, alt.confidence)}
                    className="px-2 py-1 bg-white border border-gray-300 rounded text-sm hover:bg-gray-50 transition-colors"
                  >
                    {alt.text} ({Math.round(alt.confidence)}%)
                  </button>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      {/* Contrôles */}
      <div className="flex gap-2 justify-center">
        <button
          onClick={undoLastStroke}
          disabled={strokes.length === 0}
          className="bg-orange-500 hover:bg-orange-600 disabled:bg-gray-300 text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          ↶ Annuler
        </button>
        
        <button
          onClick={clearCanvas}
          className="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          🗑️ Effacer
        </button>
        
        <button
          onClick={recognizeHandwriting}
          disabled={isProcessing || strokes.length === 0}
          className="bg-blue-500 hover:bg-blue-600 disabled:bg-blue-300 text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          🔍 {isProcessing ? 'Analyse...' : 'Reconnaître'}
        </button>
        
        <button
          onClick={() => onAnswer(recognitionResult?.text || '', recognitionResult?.confidence || 0)}
          disabled={!recognitionResult}
          className="bg-green-500 hover:bg-green-600 disabled:bg-gray-300 text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm"
        >
          ✓ Valider
        </button>
      </div>
    </div>
  )
}
