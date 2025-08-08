"use client"

import { useState, useEffect, useRef, useCallback } from 'react'

interface ARVisualizerProps {
  mathConcept: 'addition' | 'subtraction' | 'multiplication' | 'division' | 'fractions' | 'geometry'
  problem: { num1: number, num2: number, operation: string, result?: number }
  onComplete: (understood: boolean, timeSpent: number) => void
  onProgress?: (step: number, totalSteps: number) => void
  enableAnalytics?: boolean
  language?: string
}

interface ARObject {
  id: string
  type: 'cube' | 'sphere' | 'cylinder' | 'pyramid' | 'text' | 'particle'
  position: { x: number, y: number, z: number }
  rotation: { x: number, y: number, z: number }
  scale: { x: number, y: number, z: number }
  color: string
  opacity: number
  animation?: {
    type: 'move' | 'rotate' | 'scale' | 'fade'
    duration: number
    target: any
    easing: string
  }
}

interface ARScene {
  objects: ARObject[]
  lighting: {
    ambient: number
    directional: { intensity: number, position: { x: number, y: number, z: number } }
  }
  camera: {
    position: { x: number, y: number, z: number }
    target: { x: number, y: number, z: number }
    fov: number
  }
}

interface InteractionAnalytics {
  startTime: number
  endTime?: number
  interactions: Array<{
    type: 'touch' | 'gesture' | 'voice' | 'gaze'
    timestamp: number
    position?: { x: number, y: number }
    data?: any
  }>
  engagement: number
  comprehensionIndicators: {
    timeOnConcept: number
    correctGestures: number
    helpRequests: number
    selfCorrections: number
  }
}

export function ARMathVisualizerAdvanced({ 
  mathConcept, 
  problem, 
  onComplete, 
  onProgress,
  enableAnalytics = true,
  language = 'fr' 
}: ARVisualizerProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)
  const [isARActive, setIsARActive] = useState(false)
  const [currentStep, setCurrentStep] = useState(0)
  const [arScene, setArScene] = useState<ARScene | null>(null)
  const [isLoading, setIsLoading] = useState(false)
  const [analytics, setAnalytics] = useState<InteractionAnalytics | null>(null)
  const [userInteraction, setUserInteraction] = useState<string>('')
  const [showExplanation, setShowExplanation] = useState(false)
  const [arMode, setArMode] = useState<'basic' | 'interactive' | 'immersive'>('interactive')
  
  // Configuration des concepts mathématiques
  const mathConcepts = {
    addition: {
      title: 'Addition Visuelle 3D',
      icon: '➕',
      steps: ['Groupe Initial', 'Ajout Visual', 'Combinaison 3D', 'Résultat Animé', 'Vérification'],
      totalSteps: 5,
      description: 'Visualise l\'addition avec des objets 3D qui se combinent',
      complexity: 'beginner'
    },
    subtraction: {
      title: 'Soustraction Interactive',
      icon: '➖',
      steps: ['Groupe Complet', 'Sélection à Retirer', 'Animation Retrait', 'Résultat Final'],
      totalSteps: 4,
      description: 'Retire des objets 3D pour comprendre la soustraction',
      complexity: 'beginner'
    },
    multiplication: {
      title: 'Multiplication en Matrices 3D',
      icon: '✖️',
      steps: ['Ligne de Base', 'Duplication Rangées', 'Formation Matrice', 'Comptage Total', 'Validation'],
      totalSteps: 5,
      description: 'Crée des matrices d\'objets pour visualiser la multiplication',
      complexity: 'intermediate'
    },
    division: {
      title: 'Division par Groupes Égaux',
      icon: '➗',
      steps: ['Collection Totale', 'Formation Groupes', 'Distribution Égale', 'Vérification'],
      totalSteps: 4,
      description: 'Divise une collection en groupes égaux',
      complexity: 'intermediate'
    },
    fractions: {
      title: 'Fractions Visuelles 3D',
      icon: '¼',
      steps: ['Entier Initial', 'Division Parties', 'Sélection Fraction', 'Représentation 3D'],
      totalSteps: 4,
      description: 'Découpe des objets 3D pour comprendre les fractions',
      complexity: 'advanced'
    },
    geometry: {
      title: 'Géométrie Immersive',
      icon: '🔷',
      steps: ['Forme de Base', 'Exploration 3D', 'Propriétés', 'Transformations'],
      totalSteps: 4,
      description: 'Manipule des formes géométriques en 3D',
      complexity: 'advanced'
    }
  }

  const currentConcept = mathConcepts[mathConcept]

  // Initialisation de l'analytics
  useEffect(() => {
    if (enableAnalytics && isARActive) {
      setAnalytics({
        startTime: Date.now(),
        interactions: [],
        engagement: 0,
        comprehensionIndicators: {
          timeOnConcept: 0,
          correctGestures: 0,
          helpRequests: 0,
          selfCorrections: 0
        }
      })
    }
  }, [isARActive, enableAnalytics])

  // Gestionnaire d'interactions utilisateur
  const handleUserInteraction = useCallback((type: string, data?: any) => {
    if (!analytics) return
    
    const interaction = {
      type: type as any,
      timestamp: Date.now(),
      data
    }
    
    setAnalytics(prev => prev ? {
      ...prev,
      interactions: [...prev.interactions, interaction]
    } : null)
    
    // Mise à jour de l'engagement basé sur l'interaction
    updateEngagement(type)
  }, [analytics])

  const updateEngagement = (interactionType: string) => {
    setAnalytics(prev => {
      if (!prev) return null
      
      let engagementDelta = 0
      switch (interactionType) {
        case 'touch': engagementDelta = 5; break
        case 'gesture': engagementDelta = 10; break
        case 'voice': engagementDelta = 8; break
        case 'gaze': engagementDelta = 3; break
      }
      
      return {
        ...prev,
        engagement: Math.min(100, prev.engagement + engagementDelta)
      }
    })
  }

  // Génération de scène AR basée sur le concept mathématique
  const generateARScene = useCallback((concept: string, step: number): ARScene => {
    const { num1, num2 } = problem
    const baseObjects: ARObject[] = []
    
    switch (concept) {
      case 'addition':
        return generateAdditionScene(num1, num2, step)
      case 'subtraction':
        return generateSubtractionScene(num1, num2, step)
      case 'multiplication':
        return generateMultiplicationScene(num1, num2, step)
      case 'division':
        return generateDivisionScene(num1, num2, step)
      case 'fractions':
        return generateFractionsScene(num1, num2, step)
      case 'geometry':
        return generateGeometryScene(num1, num2, step)
      default:
        return generateDefaultScene()
    }
  }, [problem])

  const generateAdditionScene = (num1: number, num2: number, step: number): ARScene => {
    const objects: ARObject[] = []
    
    switch (step) {
      case 0: // Groupe Initial
        for (let i = 0; i < num1; i++) {
          objects.push({
            id: `group1_${i}`,
            type: 'cube',
            position: { x: -3 + i * 0.6, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.5, y: 0.5, z: 0.5 },
            color: '#ff6b6b',
            opacity: 1,
            animation: {
              type: 'fade',
              duration: 500,
              target: { opacity: 1 },
              easing: 'ease-in'
            }
          })
        }
        break
        
      case 1: // Ajout Visual
        // Premier groupe
        for (let i = 0; i < num1; i++) {
          objects.push({
            id: `group1_${i}`,
            type: 'cube',
            position: { x: -3 + i * 0.6, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.5, y: 0.5, z: 0.5 },
            color: '#ff6b6b',
            opacity: 1
          })
        }
        
        // Deuxième groupe avec animation d'arrivée
        for (let i = 0; i < num2; i++) {
          objects.push({
            id: `group2_${i}`,
            type: 'sphere',
            position: { x: 2 + i * 0.6, y: 2, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.5, y: 0.5, z: 0.5 },
            color: '#4ecdc4',
            opacity: 1,
            animation: {
              type: 'move',
              duration: 1000,
              target: { y: 0 },
              easing: 'ease-out'
            }
          })
        }
        break
        
      case 2: // Combinaison 3D
        const totalObjects = num1 + num2
        for (let i = 0; i < totalObjects; i++) {
          const isFromGroup1 = i < num1
          objects.push({
            id: `combined_${i}`,
            type: isFromGroup1 ? 'cube' : 'sphere',
            position: { x: -2 + i * 0.4, y: 0, z: 0 },
            rotation: { x: 0, y: i * 10, z: 0 },
            scale: { x: 0.4, y: 0.4, z: 0.4 },
            color: isFromGroup1 ? '#ff6b6b' : '#4ecdc4',
            opacity: 1,
            animation: {
              type: 'move',
              duration: 800,
              target: { x: -2 + i * 0.4 },
              easing: 'ease-in-out'
            }
          })
        }
        break
        
      case 3: // Résultat Animé
        objects.push({
          id: 'result_display',
          type: 'text',
          position: { x: 0, y: 2, z: 0 },
          rotation: { x: 0, y: 0, z: 0 },
          scale: { x: 2, y: 2, z: 2 },
          color: '#2ecc71',
          opacity: 0,
          animation: {
            type: 'scale',
            duration: 1000,
            target: { x: 3, y: 3, z: 3, opacity: 1 },
            easing: 'bounce'
          }
        })
        
        // Objets groupés finaux
        for (let i = 0; i < num1 + num2; i++) {
          objects.push({
            id: `final_${i}`,
            type: 'cylinder',
            position: { x: -2 + i * 0.3, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.3, y: 0.8, z: 0.3 },
            color: '#f39c12',
            opacity: 1
          })
        }
        break
    }
    
    return {
      objects,
      lighting: {
        ambient: 0.6,
        directional: { intensity: 0.8, position: { x: 5, y: 10, z: 5 } }
      },
      camera: {
        position: { x: 0, y: 3, z: 8 },
        target: { x: 0, y: 0, z: 0 },
        fov: 45
      }
    }
  }

  const generateSubtractionScene = (num1: number, num2: number, step: number): ARScene => {
    const objects: ARObject[] = []
    
    switch (step) {
      case 0: // Groupe Complet
        for (let i = 0; i < num1; i++) {
          objects.push({
            id: `initial_${i}`,
            type: 'cube',
            position: { x: -2 + i * 0.5, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.4, y: 0.4, z: 0.4 },
            color: '#3498db',
            opacity: 1
          })
        }
        break
        
      case 1: // Sélection à Retirer
        for (let i = 0; i < num1; i++) {
          objects.push({
            id: `obj_${i}`,
            type: 'cube',
            position: { x: -2 + i * 0.5, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.4, y: 0.4, z: 0.4 },
            color: i < num2 ? '#e74c3c' : '#3498db', // Objets à retirer en rouge
            opacity: 1,
            animation: i < num2 ? {
              type: 'scale',
              duration: 500,
              target: { x: 0.6, y: 0.6, z: 0.6 },
              easing: 'ease-in-out'
            } : undefined
          })
        }
        break
        
      case 2: // Animation Retrait
        // Objets restants
        for (let i = num2; i < num1; i++) {
          objects.push({
            id: `remaining_${i}`,
            type: 'cube',
            position: { x: -1 + (i - num2) * 0.5, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.4, y: 0.4, z: 0.4 },
            color: '#2ecc71',
            opacity: 1
          })
        }
        
        // Objets retirés (disparaissent)
        for (let i = 0; i < num2; i++) {
          objects.push({
            id: `removed_${i}`,
            type: 'cube',
            position: { x: 3 + i * 0.3, y: -2, z: 0 },
            rotation: { x: 45, y: 45, z: 0 },
            scale: { x: 0.2, y: 0.2, z: 0.2 },
            color: '#95a5a6',
            opacity: 0.3,
            animation: {
              type: 'fade',
              duration: 1000,
              target: { opacity: 0 },
              easing: 'ease-out'
            }
          })
        }
        break
    }
    
    return {
      objects,
      lighting: {
        ambient: 0.5,
        directional: { intensity: 0.9, position: { x: -5, y: 8, z: 3 } }
      },
      camera: {
        position: { x: 0, y: 2, z: 6 },
        target: { x: 0, y: 0, z: 0 },
        fov: 50
      }
    }
  }

  const generateMultiplicationScene = (num1: number, num2: number, step: number): ARScene => {
    const objects: ARObject[] = []
    
    switch (step) {
      case 0: // Ligne de Base
        for (let i = 0; i < num1; i++) {
          objects.push({
            id: `base_${i}`,
            type: 'sphere',
            position: { x: -2 + i * 0.8, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            scale: { x: 0.3, y: 0.3, z: 0.3 },
            color: '#9b59b6',
            opacity: 1,
            animation: {
              type: 'move',
              duration: 300 * i,
              target: { y: 0 },
              easing: 'bounce'
            }
          })
        }
        break
        
      case 1: // Duplication Rangées
        for (let row = 0; row < num2; row++) {
          for (let col = 0; col < num1; col++) {
            const delay = row * 200 + col * 50
            objects.push({
              id: `matrix_${row}_${col}`,
              type: 'sphere',
              position: { x: -2 + col * 0.8, y: row * 0.8, z: 0 },
              rotation: { x: 0, y: 0, z: 0 },
              scale: { x: 0, y: 0, z: 0 },
              color: row === 0 ? '#9b59b6' : '#e67e22',
              opacity: 1,
              animation: {
                type: 'scale',
                duration: 400,
                target: { x: 0.3, y: 0.3, z: 0.3 },
                easing: 'ease-out'
              }
            })
          }
        }
        break
        
      case 2: // Formation Matrice
        for (let row = 0; row < num2; row++) {
          for (let col = 0; col < num1; col++) {
            objects.push({
              id: `grid_${row}_${col}`,
              type: 'cube',
              position: { x: -2 + col * 0.6, y: row * 0.6, z: 0 },
              rotation: { x: 0, y: row * 15 + col * 10, z: 0 },
              scale: { x: 0.25, y: 0.25, z: 0.25 },
              color: `hsl(${(row * 60 + col * 30) % 360}, 70%, 60%)`,
              opacity: 1,
              animation: {
                type: 'rotate',
                duration: 2000,
                target: { y: 360 },
                easing: 'linear'
              }
            })
          }
        }
        break
    }
    
    return {
      objects,
      lighting: {
        ambient: 0.4,
        directional: { intensity: 1.0, position: { x: 0, y: 15, z: 8 } }
      },
      camera: {
        position: { x: 0, y: 4, z: 8 },
        target: { x: 0, y: 1, z: 0 },
        fov: 40
      }
    }
  }

  const generateDivisionScene = (num1: number, num2: number, step: number): ARScene => {
    const objects: ARObject[] = []
    const groupSize = Math.floor(num1 / num2)
    
    switch (step) {
      case 0: // Collection Totale
        for (let i = 0; i < num1; i++) {
          const angle = (i / num1) * Math.PI * 2
          objects.push({
            id: `total_${i}`,
            type: 'pyramid',
            position: { 
              x: Math.cos(angle) * 2, 
              y: 0, 
              z: Math.sin(angle) * 2 
            },
            rotation: { x: 0, y: angle * 180 / Math.PI, z: 0 },
            scale: { x: 0.3, y: 0.3, z: 0.3 },
            color: '#1abc9c',
            opacity: 1
          })
        }
        break
        
      case 1: // Formation Groupes
        for (let group = 0; group < num2; group++) {
          for (let item = 0; item < groupSize; item++) {
            const objIndex = group * groupSize + item
            if (objIndex < num1) {
              objects.push({
                id: `group_${group}_${item}`,
                type: 'pyramid',
                position: { 
                  x: -3 + group * 2, 
                  y: 0, 
                  z: -1 + item * 0.5 
                },
                rotation: { x: 0, y: 0, z: 0 },
                scale: { x: 0.25, y: 0.25, z: 0.25 },
                color: `hsl(${group * 60}, 80%, 60%)`,
                opacity: 1,
                animation: {
                  type: 'move',
                  duration: 1000,
                  target: { x: -3 + group * 2, z: -1 + item * 0.5 },
                  easing: 'ease-in-out'
                }
              })
            }
          }
        }
        break
    }
    
    return {
      objects,
      lighting: {
        ambient: 0.7,
        directional: { intensity: 0.6, position: { x: 10, y: 10, z: 10 } }
      },
      camera: {
        position: { x: 0, y: 5, z: 10 },
        target: { x: 0, y: 0, z: 0 },
        fov: 55
      }
    }
  }

  const generateFractionsScene = (num1: number, num2: number, step: number): ARScene => {
    // Implémentation des fractions en 3D
    return generateDefaultScene()
  }

  const generateGeometryScene = (num1: number, num2: number, step: number): ARScene => {
    // Implémentation de la géométrie interactive
    return generateDefaultScene()
  }

  const generateDefaultScene = (): ARScene => {
    return {
      objects: [{
        id: 'default',
        type: 'cube',
        position: { x: 0, y: 0, z: 0 },
        rotation: { x: 0, y: 0, z: 0 },
        scale: { x: 1, y: 1, z: 1 },
        color: '#3498db',
        opacity: 1
      }],
      lighting: {
        ambient: 0.5,
        directional: { intensity: 0.8, position: { x: 5, y: 5, z: 5 } }
      },
      camera: {
        position: { x: 0, y: 0, z: 5 },
        target: { x: 0, y: 0, z: 0 },
        fov: 45
      }
    }
  }

  const startAR = async () => {
    setIsLoading(true)
    setIsARActive(true)
    setCurrentStep(0)
    
    try {
      // Simulation du chargement AR
      await new Promise(resolve => setTimeout(resolve, 1500))
      
      const initialScene = generateARScene(mathConcept, 0)
      setArScene(initialScene)
      
      handleUserInteraction('touch', { action: 'start_ar' })
      
      animateSteps()
    } catch (error) {
      console.error('Erreur initialisation AR:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const animateSteps = () => {
    const totalSteps = currentConcept.totalSteps
    let step = 0
    
    const interval = setInterval(() => {
      if (step < totalSteps) {
        setCurrentStep(step)
        
        const scene = generateARScene(mathConcept, step)
        setArScene(scene)
        
        if (onProgress) {
          onProgress(step + 1, totalSteps)
        }
        
        handleUserInteraction('gesture', { step, concept: mathConcept })
        
        step++
      } else {
        clearInterval(interval)
        setShowExplanation(true)
        
        if (analytics) {
          setAnalytics(prev => prev ? {
            ...prev,
            endTime: Date.now(),
            comprehensionIndicators: {
              ...prev.comprehensionIndicators,
              timeOnConcept: Date.now() - prev.startTime
            }
          } : null)
        }
      }
    }, 2500) // Durée entre chaque étape
  }

  const renderARCanvas = () => {
    if (!arScene) return null
    
    // Simulation du rendu 3D en 2D (Canvas API)
    const canvasWidth = 600
    const canvasHeight = 400
    
    return (
      <div className="relative bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-900 rounded-2xl overflow-hidden">
        <canvas
          ref={canvasRef}
          width={canvasWidth}
          height={canvasHeight}
          className="w-full h-full"
          onClick={(e) => handleUserInteraction('touch', { x: e.clientX, y: e.clientY })}
        />
        
        {/* Overlay d'informations AR */}
        <div className="absolute top-4 left-4 bg-black bg-opacity-50 text-white px-3 py-2 rounded-lg">
          <div className="text-sm font-bold">Mode AR Actif</div>
          <div className="text-xs">Étape {currentStep + 1}/{currentConcept.totalSteps}</div>
        </div>
        
        {/* Contrôles AR */}
        <div className="absolute bottom-4 right-4 flex gap-2">
          <button
            onClick={() => setArMode(arMode === 'basic' ? 'interactive' : arMode === 'interactive' ? 'immersive' : 'basic')}
            className="bg-white bg-opacity-20 text-white px-3 py-2 rounded-lg text-sm font-medium hover:bg-opacity-30 transition-all"
          >
            Mode: {arMode}
          </button>
          
          <button
            onClick={() => handleUserInteraction('voice', { action: 'help_request' })}
            className="bg-blue-500 bg-opacity-80 text-white px-3 py-2 rounded-lg text-sm font-medium hover:bg-opacity-100 transition-all"
          >
            🎙️ Aide
          </button>
        </div>
        
        {/* Particules d'ambiance */}
        <div className="absolute inset-0 pointer-events-none">
          {Array.from({ length: 20 }, (_, i) => (
            <div
              key={i}
              className="absolute w-2 h-2 bg-white rounded-full opacity-20 animate-pulse"
              style={{
                left: `${Math.random() * 100}%`,
                top: `${Math.random() * 100}%`,
                animationDelay: `${Math.random() * 2}s`,
                animationDuration: `${2 + Math.random() * 3}s`
              }}
            />
          ))}
        </div>
      </div>
    )
  }

  // Rendu de l'objet 3D sur canvas (simulation)
  useEffect(() => {
    if (!canvasRef.current || !arScene) return
    
    const canvas = canvasRef.current
    const ctx = canvas.getContext('2d')
    if (!ctx) return
    
    // Nettoyer le canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    // Dessiner les objets AR (simulation 2D->3D)
    arScene.objects.forEach((obj, index) => {
      const x = canvas.width / 2 + obj.position.x * 50
      const y = canvas.height / 2 - obj.position.y * 50
      const size = 30 * Math.max(obj.scale.x, obj.scale.y)
      
      ctx.save()
      ctx.globalAlpha = obj.opacity
      ctx.fillStyle = obj.color
      ctx.translate(x, y)
      ctx.rotate(obj.rotation.y * Math.PI / 180)
      
      switch (obj.type) {
        case 'cube':
          ctx.fillRect(-size/2, -size/2, size, size)
          ctx.strokeStyle = '#ffffff'
          ctx.lineWidth = 2
          ctx.strokeRect(-size/2, -size/2, size, size)
          break
          
        case 'sphere':
          ctx.beginPath()
          ctx.arc(0, 0, size/2, 0, Math.PI * 2)
          ctx.fill()
          ctx.stroke()
          break
          
        case 'cylinder':
          ctx.fillRect(-size/3, -size/2, size*2/3, size)
          ctx.beginPath()
          ctx.arc(0, -size/2, size/3, 0, Math.PI * 2)
          ctx.fill()
          ctx.arc(0, size/2, size/3, 0, Math.PI * 2)
          ctx.fill()
          break
          
        case 'pyramid':
          ctx.beginPath()
          ctx.moveTo(0, -size/2)
          ctx.lineTo(-size/2, size/2)
          ctx.lineTo(size/2, size/2)
          ctx.closePath()
          ctx.fill()
          ctx.stroke()
          break
          
        case 'text':
          ctx.font = `${size}px Arial`
          ctx.fillStyle = obj.color
          ctx.textAlign = 'center'
          ctx.fillText(`${problem.num1} ${problem.operation} ${problem.num2} = ${problem.result || '?'}`, 0, size/4)
          break
      }
      
      ctx.restore()
    })
  }, [arScene, problem])

  const handleComplete = (understood: boolean) => {
    const timeSpent = analytics ? Date.now() - analytics.startTime : 0
    
    if (analytics && enableAnalytics) {
      console.log('📊 Analytics AR:', {
        concept: mathConcept,
        timeSpent,
        interactions: analytics.interactions.length,
        engagement: analytics.engagement,
        understood
      })
    }
    
    onComplete(understood, timeSpent)
  }

  if (!isARActive) {
    return (
      <div className="bg-white rounded-2xl p-8 shadow-xl border-2 border-purple-200">
        <div className="text-center">
          <div className="mb-6">
            <div className="text-6xl mb-4">{currentConcept.icon}</div>
            <h3 className="text-2xl font-bold text-gray-800 mb-2">
              {currentConcept.title}
            </h3>
            <p className="text-gray-600 mb-4">{currentConcept.description}</p>
            
            <div className="bg-gradient-to-r from-purple-100 to-blue-100 rounded-lg p-4 mb-6">
              <div className="text-lg font-bold text-purple-800 mb-2">
                Problème: {problem.num1} {problem.operation} {problem.num2} = ?
              </div>
              <div className="text-sm text-purple-600">
                Complexité: {currentConcept.complexity} • {currentConcept.totalSteps} étapes
              </div>
            </div>
          </div>
          
          <div className="grid grid-cols-3 gap-4 mb-6">
            <div className="bg-blue-50 p-3 rounded-lg">
              <div className="text-2xl text-blue-600 mb-1">🥽</div>
              <div className="text-sm font-medium">Réalité Augmentée</div>
            </div>
            <div className="bg-green-50 p-3 rounded-lg">
              <div className="text-2xl text-green-600 mb-1">🎯</div>
              <div className="text-sm font-medium">Interactive</div>
            </div>
            <div className="bg-purple-50 p-3 rounded-lg">
              <div className="text-2xl text-purple-600 mb-1">📊</div>
              <div className="text-sm font-medium">Analytics IA</div>
            </div>
          </div>
          
          <button
            onClick={startAR}
            disabled={isLoading}
            className="bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 disabled:from-gray-400 disabled:to-gray-500 text-white px-8 py-4 rounded-xl font-bold text-lg shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105"
          >
            {isLoading ? (
              <div className="flex items-center gap-2">
                <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white"></div>
                Initialisation AR...
              </div>
            ) : (
              <>🚀 Lancer l'Expérience AR</>
            )}
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white rounded-2xl p-6 shadow-xl border-2 border-purple-200">
      <div className="text-center mb-6">
        <h3 className="text-xl font-bold text-gray-800 mb-2 flex items-center justify-center gap-2">
          <span className="text-2xl">{currentConcept.icon}</span>
          {currentConcept.title}
        </h3>
        
        <div className="flex justify-center mb-4">
          {currentConcept.steps.map((step, index) => (
            <div 
              key={index}
              className={`px-3 py-1 mx-1 rounded-full text-xs font-medium transition-all duration-500 ${
                index <= currentStep 
                  ? 'bg-purple-500 text-white transform scale-105' 
                  : 'bg-gray-200 text-gray-600'
              }`}
            >
              {step}
            </div>
          ))}
        </div>
      </div>

      <div className="mb-6">
        {renderARCanvas()}
      </div>

      {/* Analytics en temps réel */}
      {enableAnalytics && analytics && (
        <div className="bg-gray-50 rounded-lg p-3 mb-4">
          <div className="grid grid-cols-4 gap-4 text-center text-xs">
            <div>
              <div className="font-bold text-blue-600">{analytics.interactions.length}</div>
              <div className="text-gray-600">Interactions</div>
            </div>
            <div>
              <div className="font-bold text-green-600">{analytics.engagement}%</div>
              <div className="text-gray-600">Engagement</div>
            </div>
            <div>
              <div className="font-bold text-purple-600">
                {Math.round((Date.now() - analytics.startTime) / 1000)}s
              </div>
              <div className="text-gray-600">Temps</div>
            </div>
            <div>
              <div className="font-bold text-orange-600">{currentStep + 1}/{currentConcept.totalSteps}</div>
              <div className="text-gray-600">Progression</div>
            </div>
          </div>
        </div>
      )}

      {showExplanation && (
        <div className="bg-green-50 border border-green-200 rounded-lg p-4 mb-4">
          <div className="text-center">
            <div className="text-green-600 text-3xl mb-3">🎉</div>
            <h4 className="font-bold text-green-800 mb-2">Expérience AR Terminée !</h4>
            <p className="text-green-700 mb-4">
              Tu as exploré {problem.num1} {problem.operation} {problem.num2} en réalité augmentée !
            </p>
            
            <div className="text-lg font-bold text-green-800 mb-4">
              Résultat : {problem.num1} {problem.operation} {problem.num2} = {
                problem.operation === '+' ? problem.num1 + problem.num2 :
                problem.operation === '-' ? problem.num1 - problem.num2 :
                problem.operation === '×' ? problem.num1 * problem.num2 :
                problem.operation === '÷' ? Math.floor(problem.num1 / problem.num2) : '?'
              }
            </div>
            
            <div className="flex gap-2 justify-center">
              <button
                onClick={() => handleComplete(true)}
                className="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-lg font-medium transition-colors"
              >
                ✅ J'ai compris !
              </button>
              <button
                onClick={() => handleComplete(false)}
                className="bg-orange-500 hover:bg-orange-600 text-white px-6 py-2 rounded-lg font-medium transition-colors"
              >
                🤔 Revoir
              </button>
              <button
                onClick={() => {
                  setIsARActive(false)
                  setCurrentStep(0)
                  setShowExplanation(false)
                  setArScene(null)
                }}
                className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg font-medium transition-colors"
              >
                🔄 Recommencer
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
