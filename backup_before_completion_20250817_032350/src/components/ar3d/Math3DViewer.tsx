"use client"

import { useRef, useEffect, useState } from 'react'
import { Math3DEngine, type MathScene } from '@/lib/ar3d/Math3DEngine'
import { RotateCcw, Maximize, Settings, Eye, EyeOff } from 'lucide-react'

interface Math3DViewerProps {
  operation: string
  numberA: number
  numberB: number
  result: number
  width?: number
  height?: number
  autoRotate?: boolean
}

export default function Math3DViewer({
  operation,
  numberA,
  numberB,
  result,
  width = 800,
  height = 600,
  autoRotate = true
}: Math3DViewerProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const engineRef = useRef<Math3DEngine | null>(null)
  const [isLoaded, setIsLoaded] = useState(false)
  const [isVisible, setIsVisible] = useState(true)
  const [selectedView, setSelectedView] = useState<'default' | 'top' | 'side' | 'perspective'>('perspective')

  useEffect(() => {
    if (!canvasRef.current) return

    try {
      // Initialiser le moteur 3D
      engineRef.current = new Math3DEngine(canvasRef.current)
      
      // Créer et rendre la scène mathématique
      const mathScene = engineRef.current.createMathScene(operation, numberA, numberB, result)
      engineRef.current.renderScene(mathScene)
      
      setIsLoaded(true)
    } catch (error) {
      console.error('Erreur initialisation 3D:', error)
    }

    return () => {
      if (engineRef.current) {
        engineRef.current.dispose()
      }
    }
  }, [operation, numberA, numberB, result])

  useEffect(() => {
    // Mettre à jour la taille si elle change
    if (engineRef.current) {
      engineRef.current.resize(width, height)
    }
  }, [width, height])

  const resetView = () => {
    if (engineRef.current) {
      const mathScene = engineRef.current.createMathScene(operation, numberA, numberB, result)
      engineRef.current.renderScene(mathScene)
    }
  }

  const changeView = (view: typeof selectedView) => {
    setSelectedView(view)
    // Ici on pourrait changer la position de la caméra selon la vue
  }

  if (!isVisible) {
    return (
      <div className="bg-gray-100 rounded-xl p-8 text-center">
        <button
          onClick={() => setIsVisible(true)}
          className="flex items-center space-x-2 bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 mx-auto"
        >
          <Eye className="w-5 h-5" />
          <span>Afficher la 3D</span>
        </button>
      </div>
    )
  }

  return (
    <div className="bg-white rounded-xl shadow-xl overflow-hidden">
      {/* Header avec contrôles */}
      <div className="bg-gradient-to-r from-purple-500 to-blue-600 text-white px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-2">
            <span className="text-2xl">🥽</span>
            <div>
              <h3 className="font-bold text-lg">Réalité Augmentée 3D</h3>
              <p className="text-sm opacity-90">Math4Child v4.2.0 - Innovation Mondiale</p>
            </div>
          </div>
          
          <div className="flex items-center space-x-2">
            <button
              onClick={resetView}
              className="bg-white bg-opacity-20 hover:bg-opacity-30 p-2 rounded-lg transition-colors"
              title="Réinitialiser la vue"
            >
              <RotateCcw className="w-5 h-5" />
            </button>
            
            <button
              onClick={() => setIsVisible(false)}
              className="bg-white bg-opacity-20 hover:bg-opacity-30 p-2 rounded-lg transition-colors"
              title="Masquer la 3D"
            >
              <EyeOff className="w-5 h-5" />
            </button>
          </div>
        </div>
      </div>

      {/* Zone 3D */}
      <div className="relative">
        <canvas
          ref={canvasRef}
          width={width}
          height={height}
          className="w-full block"
          style={{ maxWidth: '100%', height: 'auto' }}
        />
        
        {!isLoaded && (
          <div className="absolute inset-0 bg-gray-100 flex items-center justify-center">
            <div className="text-center">
              <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-purple-500 mx-auto mb-4"></div>
              <p className="text-gray-600">Initialisation de la 3D...</p>
            </div>
          </div>
        )}
        
        {/* Indicateur de chargement Three.js */}
        {isLoaded && (
          <div className="absolute top-4 left-4 bg-green-500 text-white px-3 py-1 rounded-full text-sm font-medium">
            3D Active
          </div>
        )}
      </div>

      {/* Contrôles de vue */}
      <div className="bg-gray-50 px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex space-x-2">
            {[
              { id: 'perspective', name: '🎯 Perspective', desc: 'Vue par défaut' },
              { id: 'top', name: '⬆️ Dessus', desc: 'Vue du dessus' },
              { id: 'side', name: '➡️ Côté', desc: 'Vue de côté' }
            ].map(view => (
              <button
                key={view.id}
                onClick={() => changeView(view.id as any)}
                className={`px-3 py-2 rounded-lg text-sm font-medium transition-colors ${
                  selectedView === view.id 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-100'
                }`}
                title={view.desc}
              >
                {view.name}
              </button>
            ))}
          </div>
          
          <div className="text-right">
            <div className="text-sm font-medium text-gray-800">
              {numberA} {operation === 'addition' ? '+' : operation === 'subtraction' ? '-' : operation === 'multiplication' ? '×' : '÷'} {numberB} = {result}
            </div>
            <div className="text-xs text-gray-600">
              {operation === 'addition' ? 'Addition visuelle' :
               operation === 'subtraction' ? 'Soustraction interactive' :
               operation === 'multiplication' ? 'Grille multiplicative' :
               'Division en groupes'}
            </div>
          </div>
        </div>
      </div>

      {/* Instructions */}
      <div className="bg-blue-50 border-t border-blue-200 px-6 py-3">
        <div className="flex items-start space-x-3">
          <span className="text-blue-500 text-lg">💡</span>
          <div className="text-sm text-blue-800">
            <strong>Comment ça marche :</strong>
            <ul className="mt-1 space-y-1">
              <li>• Les objets 3D représentent les nombres et opérations</li>
              <li>• Chaque couleur a une signification mathématique</li>
              <li>• Les animations aident à comprendre le concept</li>
              <li>• La caméra tourne automatiquement pour une vue complète</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}
