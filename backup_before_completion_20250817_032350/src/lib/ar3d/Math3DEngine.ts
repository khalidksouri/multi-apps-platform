// Math3D Engine simplifié (Three.js sera ajouté plus tard)
export interface Math3DObject {
  id: string
  type: 'cube' | 'sphere' | 'number'
  value: number
  position: { x: number; y: number; z: number }
  color: string
}

export interface MathScene {
  operation: string
  objects: Math3DObject[]
  result: number
}

export class Math3DEngine {
  constructor(canvas: HTMLCanvasElement) {
    console.log('Math3D Engine initialized (Three.js loading...)')
  }
  
  createMathScene(operation: string, a: number, b: number, result: number): MathScene {
    return {
      operation,
      objects: [],
      result
    }
  }
  
  renderScene(scene: MathScene) {
    console.log('Rendering 3D scene:', scene)
  }
  
  dispose() {
    console.log('3D Engine disposed')
  }
  
  resize(width: number, height: number) {
    console.log('3D Engine resized:', width, height)
  }
}
