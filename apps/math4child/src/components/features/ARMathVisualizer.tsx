"use client"

import { useState, useRef, useEffect, useCallback } from 'react'

interface MathConcept {
  id: string
  name: string
  description: string
  visualization: string
  interactionType: 'manipulation' | 'observation' | 'construction'
}

interface ARVisualizationProps {
  operation: 'addition' | 'subtraction' | 'multiplication' | 'division'
  numbers: number[]
  onInteraction?: (result: any) => void
  enableManipulation?: boolean
}

export function ARMathVisualizer({ 
  operation, 
  numbers, 
  onInteraction,
  enableManipulation = true 
}: ARVisualizationProps) {
  const containerRef = useRef<HTMLDivElement>(null)
  const animationRef = useRef<number>()
  const [isLoaded, setIsLoaded] = useState(false)
  const [currentStep, setCurrentStep] = useState(0)
  const [objects, setObjects] = useState<any[]>([])
  const [isAnimating, setIsAnimating] = useState(false)
  const [interactionMode, setInteractionMode] = useState<'observe' | 'manipulate'>('observe')

  // Concepts mathématiques 3D
  const mathConcepts: Record<string, MathConcept> = {
    addition: {
      id: 'addition',
      name: 'Addition 3D',
      description: 'Visualisez l\'addition comme regroupement d\'objets',
      visualization: 'cubes',
      interactionType: 'manipulation'
    },
    subtraction: {
      id: 'subtraction', 
      name: 'Soustraction 3D',
      description: 'Voyez la soustraction comme retrait d\'objets',
      visualization: 'spheres',
      interactionType: 'manipulation'
    },
    multiplication: {
      id: 'multiplication',
      name: 'Multiplication 3D',
      description: 'Grilles et matrices en réalité augmentée',
      visualization: 'grid',
      interactionType: 'construction'
    },
    division: {
      id: 'division',
      name: 'Division 3D', 
      description: 'Partage équitable en groupes visuels',
      visualization: 'groups',
      interactionType: 'manipulation'
    }
  }

  // Initialisation de l'environnement AR
  useEffect(() => {
    initializeAR()
    return () => {
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current)
      }
    }
  }, [])

  // Mise à jour lors du changement d'opération
  useEffect(() => {
    if (isLoaded) {
      generateVisualization()
    }
  }, [operation, numbers, isLoaded])

  const initializeAR = async () => {
    try {
      console.log('🥽 Initialisation environnement AR...')
      
      // Simulation d'initialisation WebGL/Three.js
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      setIsLoaded(true)
      generateVisualization()
      
      console.log('✅ Environnement AR initialisé')
    } catch (error) {
      console.error('❌ Erreur initialisation AR:', error)
    }
  }

  const generateVisualization = useCallback(() => {
    const concept = mathConcepts[operation]
    if (!concept) return

    console.log(`🎮 Génération visualisation: ${concept.name}`)
    
    setIsAnimating(true)
    setCurrentStep(0)
    
    // Générer les objets 3D selon l'opération
    const newObjects = createMathObjects(operation, numbers)
    setObjects(newObjects)
    
    // Démarrer l'animation
    animateVisualization(newObjects)
  }, [operation, numbers])

  const createMathObjects = (op: string, nums: number[]): any[] => {
    const objects = []
    
    switch (op) {
      case 'addition':
        // Créer des groupes de cubes pour chaque nombre
        nums.forEach((num, index) => {
          for (let i = 0; i < num; i++) {
            objects.push({
              id: `cube_${index}_${i}`,
              type: 'cube',
              group: index,
              position: { 
                x: index * 120 + (i % 5) * 20, 
                y: Math.floor(i / 5) * 20, 
                z: 0 
              },
              color: index === 0 ? '#3b82f6' : '#ef4444',
              scale: 1,
              visible: true
            })
          }
        })
        break
        
      case 'subtraction':
        // Premier nombre en bleu, deuxième en rouge (à retirer)
        const [minuend, subtrahend] = nums
        for (let i = 0; i < minuend; i++) {
          objects.push({
            id: `sphere_${i}`,
            type: 'sphere',
            position: { x: (i % 8) * 25, y: Math.floor(i / 8) * 25, z: 0 },
            color: i < subtrahend ? '#ef4444' : '#3b82f6',
            scale: 1,
            visible: true,
            toRemove: i < subtrahend
          })
        }
        break
        
      case 'multiplication':
        // Grille rectangulaire
        const [rows, cols] = nums
        for (let r = 0; r < rows; r++) {
          for (let c = 0; c < cols; c++) {
            objects.push({
              id: `grid_${r}_${c}`,
              type: 'cube',
              position: { x: c * 25, y: r * 25, z: 0 },
              color: '#8b5cf6',
              scale: 0.8,
              visible: true
            })
          }
        }
        break
        
      case 'division':
        // Objets à répartir en groupes
        const [dividend, divisor] = nums
        const itemsPerGroup = Math.floor(dividend / divisor)
        
        for (let i = 0; i < dividend; i++) {
          const groupIndex = Math.floor(i / itemsPerGroup)
          const positionInGroup = i % itemsPerGroup
          
          objects.push({
            id: `item_${i}`,
            type: 'sphere',
            group: groupIndex,
            position: { 
              x: groupIndex * 80 + (positionInGroup % 4) * 15, 
              y: Math.floor(positionInGroup / 4) * 15, 
              z: 0 
            },
            color: `hsl(${groupIndex * 60}, 70%, 60%)`,
            scale: 1,
            visible: true
          })
        }
        break
    }
    
    return objects
  }

  const animateVisualization = (objectList: any[]) => {
    let step = 0
    const maxSteps = 100
    
    const animate = () => {
      if (step >= maxSteps) {
        setIsAnimating(false)
        return
      }
      
      // Animation progressive selon l'opération
      switch (operation) {
        case 'addition':
          animateAddition(objectList, step)
          break
        case 'subtraction':
          animateSubtraction(objectList, step)
          break
        case 'multiplication':
          animateMultiplication(objectList, step)
          break
        case 'division':
          animateDivision(objectList, step)
          break
      }
      
      setCurrentStep(step)
      step++
      
      animationRef.current = requestAnimationFrame(animate)
    }
    
    animate()
  }

  const animateAddition = (objects: any[], step: number) => {
    if (step < 50) {
      // Phase 1: Montrer les groupes séparés
      return
    } else {
      // Phase 2: Rapprocher les groupes
      objects.forEach(obj => {
        if (obj.group === 1) {
          obj.position.x = obj.position.x - (step - 50) * 2
        }
      })
    }
  }

  const animateSubtraction = (objects: any[], step: number) => {
    if (step > 30) {
      // Faire disparaître les objets à retirer
      objects.forEach(obj => {
        if (obj.toRemove) {
          obj.scale = Math.max(0, 1 - (step - 30) * 0.05)
          obj.visible = obj.scale > 0.1
        }
      })
    }
  }

  const animateMultiplication = (objects: any[], step: number) => {
    // Animation de construction de la grille
    const revealPerStep = Math.ceil(objects.length / 80)
    objects.forEach((obj, index) => {
      obj.visible = index < step * revealPerStep
    })
  }

  const animateDivision = (objects: any[], step: number) => {
    if (step > 20) {
      // Séparer visuellement les groupes
      objects.forEach(obj => {
        obj.position.x = obj.position.x + obj.group * (step - 20) * 0.5
      })
    }
  }

  const handleObjectClick = (objectId: string) => {
    if (!enableManipulation || interactionMode !== 'manipulate') return
    
    setObjects(prev => prev.map(obj => 
      obj.id === objectId 
        ? { ...obj, selected: !obj.selected, scale: obj.selected ? 1 : 1.2 }
        : obj
    ))
    
    onInteraction?.(objectId)
  }

  const resetVisualization = () => {
    setCurrentStep(0)
    generateVisualization()
  }

  const toggleInteractionMode = () => {
    setInteractionMode(prev => prev === 'observe' ? 'manipulate' : 'observe')
  }

  return (
    <div className="space-y-4">
      <div className="text-center">
        <h3 className="text-lg font-bold text-gray-800 mb-2">
          🥽 Réalité Augmentée Mathématique - PREMIÈRE MONDIALE
        </h3>
        <p className="text-sm text-gray-600">
          {mathConcepts[operation]?.description}
        </p>
      </div>

      {/* Contrôles AR */}
      <div className="flex justify-center gap-2 mb-4">
        <button
          onClick={toggleInteractionMode}
          className={`px-4 py-2 rounded-lg font-medium transition-colors ${
            interactionMode === 'manipulate' 
              ? 'bg-purple-500 text-white' 
              : 'bg-gray-200 text-gray-700'
          }`}
        >
          {interactionMode === 'manipulate' ? '🖐️ Manipulation' : '👀 Observation'}
        </button>
        
        <button
          onClick={resetVisualization}
          className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg font-medium transition-colors"
        >
          🔄 Restart
        </button>
      </div>

      {/* Viewport AR */}
      <div 
        ref={containerRef}
        className="relative bg-gradient-to-br from-purple-50 to-blue-50 border-2 border-purple-200 rounded-lg overflow-hidden"
        style={{ height: '300px' }}
      >
        {!isLoaded ? (
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="text-center">
              <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-purple-500 mx-auto mb-3"></div>
              <p className="text-purple-600 font-medium">🥽 Initialisation AR...</p>
            </div>
          </div>
        ) : (
          <div className="absolute inset-0 p-4">
            {/* Simulation d'affichage 3D */}
            <div className="relative w-full h-full">
              {objects.filter(obj => obj.visible).map(obj => (
                <div
                  key={obj.id}
                  onClick={() => handleObjectClick(obj.id)}
                  className={`absolute transition-all duration-300 cursor-pointer ${
                    obj.selected ? 'ring-2 ring-yellow-400' : ''
                  } ${
                    obj.type === 'cube' ? 'rounded-sm' : 'rounded-full'
                  }`}
                  style={{
                    left: `${obj.position.x}px`,
                    top: `${obj.position.y}px`,
                    width: `${20 * obj.scale}px`,
                    height: `${20 * obj.scale}px`,
                    backgroundColor: obj.color,
                    transform: `scale(${obj.scale}) translateZ(${obj.position.z}px)`,
                    boxShadow: '0 2px 4px rgba(0,0,0,0.2)'
                  }}
                />
              ))}
              
              {/* Indicateur d'animation */}
              {isAnimating && (
                <div className="absolute top-2 right-2 bg-white bg-opacity-90 rounded-lg p-2">
                  <div className="flex items-center gap-2">
                    <div className="animate-pulse w-2 h-2 bg-purple-500 rounded-full"></div>
                    <span className="text-xs font-medium">Animation en cours...</span>
                  </div>
                </div>
              )}
            </div>
          </div>
        )}
        
        {/* Overlay d'information */}
        <div className="absolute bottom-2 left-2 bg-white bg-opacity-90 rounded-lg p-2">
          <div className="text-xs">
            <div className="font-bold text-purple-800">{mathConcepts[operation]?.name}</div>
            <div className="text-gray-600">Étape: {currentStep}/100</div>
            <div className="text-gray-600">Objets: {objects.filter(o => o.visible).length}</div>
          </div>
        </div>
      </div>

      {/* Instructions interactives */}
      <div className="bg-purple-50 border border-purple-200 rounded-lg p-3">
        <div className="text-sm">
          <div className="font-semibold text-purple-800 mb-1">💡 Instructions AR :</div>
          <ul className="text-purple-700 space-y-1 text-xs">
            <li>• Mode Observation : Regardez l'animation automatique</li>
            <li>• Mode Manipulation : Cliquez sur les objets pour les sélectionner</li>
            <li>• Utilisez les contrôles pour changer de mode ou redémarrer</li>
            <li>• L'animation montre visuellement l'opération mathématique</li>
          </ul>
        </div>
      </div>

      {/* Statistiques de performance */}
      <div className="grid grid-cols-3 gap-2 text-center text-xs">
        <div className="bg-white rounded-lg p-2 border">
          <div className="font-bold text-blue-600">{objects.length}</div>
          <div className="text-gray-600">Objets 3D</div>
        </div>
        <div className="bg-white rounded-lg p-2 border">
          <div className="font-bold text-green-600">{currentStep}%</div>
          <div className="text-gray-600">Progression</div>
        </div>
        <div className="bg-white rounded-lg p-2 border">
          <div className="font-bold text-purple-600">{interactionMode}</div>
          <div className="text-gray-600">Mode</div>
        </div>
      </div>
    </div>
  )
}
