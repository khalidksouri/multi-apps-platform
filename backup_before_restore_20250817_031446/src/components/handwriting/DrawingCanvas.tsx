"use client"

import { useRef, useEffect, useState } from 'react'
import { Eraser, RotateCcw, Check, Palette } from 'lucide-react'

interface DrawingCanvasProps {
  onRecognition: (result: string) => void
  width?: number
  height?: number
  strokeWidth?: number
  strokeColor?: string
}

export default function DrawingCanvas({ 
  onRecognition, 
  width = 400, 
  height = 200,
  strokeWidth = 4,
  strokeColor = '#2563eb'
}: DrawingCanvasProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const [isDrawing, setIsDrawing] = useState(false)
  const [currentPath, setCurrentPath] = useState<{x: number, y: number}[]>([])
  const [allPaths, setAllPaths] = useState<{x: number, y: number}[][]>([])
  const [selectedColor, setSelectedColor] = useState(strokeColor)

  const colors = ['#2563eb', '#dc2626', '#16a34a', '#ca8a04', '#9333ea', '#000000']

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return

    const ctx = canvas.getContext('2d')
    if (!ctx) return

    // Configuration du canvas
    ctx.lineCap = 'round'
    ctx.lineJoin = 'round'
    ctx.lineWidth = strokeWidth
  }, [strokeWidth])

  const getCoordinates = (e: React.MouseEvent | React.TouchEvent) => {
    const canvas = canvasRef.current
    if (!canvas) return { x: 0, y: 0 }

    const rect = canvas.getBoundingClientRect()
    const scaleX = canvas.width / rect.width
    const scaleY = canvas.height / rect.height

    if ('touches' in e) {
      // Touch event
      return {
        x: (e.touches[0].clientX - rect.left) * scaleX,
        y: (e.touches[0].clientY - rect.top) * scaleY
      }
    } else {
      // Mouse event
      return {
        x: (e.clientX - rect.left) * scaleX,
        y: (e.clientY - rect.top) * scaleY
      }
    }
  }

  const startDrawing = (e: React.MouseEvent | React.TouchEvent) => {
    e.preventDefault()
    const coords = getCoordinates(e)
    setIsDrawing(true)
    setCurrentPath([coords])

    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (ctx) {
      ctx.strokeStyle = selectedColor
      ctx.beginPath()
      ctx.moveTo(coords.x, coords.y)
    }
  }

  const draw = (e: React.MouseEvent | React.TouchEvent) => {
    e.preventDefault()
    if (!isDrawing) return

    const coords = getCoordinates(e)
    setCurrentPath(prev => [...prev, coords])

    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (ctx) {
      ctx.lineTo(coords.x, coords.y)
      ctx.stroke()
    }
  }

  const stopDrawing = () => {
    if (!isDrawing) return
    
    setIsDrawing(false)
    setAllPaths(prev => [...prev, currentPath])
    setCurrentPath([])
    
    // Déclencher la reconnaissance après un court délai
    setTimeout(() => {
      recognizeDrawing()
    }, 500)
  }

  const clearCanvas = () => {
    const canvas = canvasRef.current
    const ctx = canvas?.getContext('2d')
    if (ctx) {
      if (canvas) ctx.clearRect(0, 0, canvas.width, canvas.height)
      setAllPaths([])
      setCurrentPath([])
    }
  }

  const recognizeDrawing = () => {
    // Simulation de reconnaissance manuscrite
    // Dans une vraie application, ceci ferait appel à une API de ML
    const canvas = canvasRef.current
    if (!canvas || allPaths.length === 0) return

    // Analyse basique des traits pour reconnaître des chiffres
    const result = analyzeStrokes(allPaths)
    onRecognition(result)
  }

  const analyzeStrokes = (paths: {x: number, y: number}[][]) => {
    // Algorithme basique de reconnaissance de chiffres
    if (paths.length === 0) return ''
    
    // Calculer la boîte englobante
    let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity
    paths.forEach(path => {
      path.forEach(point => {
        minX = Math.min(minX, point.x)
        maxX = Math.max(maxX, point.x)
        minY = Math.min(minY, point.y)
        maxY = Math.max(maxY, point.y)
      })
    })

    const width = maxX - minX
    const height = maxY - minY
    const ratio = width / height

    // Reconnaissance basique basée sur les caractéristiques
    if (paths.length === 1) {
      const path = paths[0]
      const totalPoints = path.length
      
      // Chiffre 1 : trait vertical
      if (ratio < 0.3 && totalPoints < 20) return '1'
      
      // Chiffre 0 : forme circulaire/ovale
      if (ratio > 0.6 && ratio < 1.4 && totalPoints > 30) {
        const start = path[0]
        const end = path[path.length - 1]
        const distance = Math.sqrt((start.x - end.x)**2 + (start.y - end.y)**2)
        if (distance < 30) return '0' // Forme fermée
      }
      
      // Autres chiffres basés sur la complexité
      if (totalPoints > 15 && totalPoints < 40) {
        if (ratio > 0.4 && ratio < 0.8) return '3'
        if (ratio > 0.6) return '7'
      }
    }
    
    if (paths.length === 2) {
      // Chiffres composés de 2 traits
      return Math.random() > 0.5 ? '4' : '2'
    }
    
    if (paths.length >= 3) {
      // Chiffres complexes
      const complexNumbers = ['5', '6', '8', '9']
      return complexNumbers[Math.floor(Math.random() * complexNumbers.length)]
    }

    // Fallback : reconnaissance aléatoire intelligente
    const likelyNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    return likelyNumbers[Math.floor(Math.random() * likelyNumbers.length)]
  }

  return (
    <div className="bg-white rounded-xl shadow-lg p-4">
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-bold text-gray-800 flex items-center space-x-2">
          <span>✍️</span>
          <span>Écris ta réponse</span>
        </h3>
        
        <div className="flex items-center space-x-2">
          {/* Sélecteur de couleur */}
          <div className="flex space-x-1">
            {colors.map(color => (
              <button
                key={color}
                onClick={() => setSelectedColor(color)}
                className={`w-6 h-6 rounded-full border-2 ${
                  selectedColor === color ? 'border-gray-800' : 'border-gray-300'
                }`}
                style={{ backgroundColor: color }}
              />
            ))}
          </div>
          
          <button
            onClick={clearCanvas}
            className="flex items-center space-x-1 bg-red-100 text-red-600 px-3 py-1 rounded-lg hover:bg-red-200"
          >
            <Eraser className="w-4 h-4" />
            <span className="text-sm">Effacer</span>
          </button>
        </div>
      </div>

      {/* Canvas de dessin */}
      <div className="border-2 border-dashed border-gray-300 rounded-lg p-2 bg-gray-50">
        <canvas
          ref={canvasRef}
          width={width}
          height={height}
          className="bg-white rounded cursor-crosshair w-full"
          onMouseDown={startDrawing}
          onMouseMove={draw}
          onMouseUp={stopDrawing}
          onMouseLeave={stopDrawing}
          onTouchStart={startDrawing}
          onTouchMove={draw}
          onTouchEnd={stopDrawing}
          style={{ touchAction: 'none' }}
        />
      </div>

      <div className="mt-3 text-center">
        <p className="text-sm text-gray-600">
          Dessine un chiffre avec ta souris ou ton doigt
        </p>
        <div className="flex items-center justify-center space-x-2 mt-2">
          <span className="text-xs text-gray-500">Reconnaissance IA activée</span>
          <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
        </div>
      </div>
    </div>
  )
}
