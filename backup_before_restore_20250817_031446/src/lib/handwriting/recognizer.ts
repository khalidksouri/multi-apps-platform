// =============================================================================
// 🧠 MOTEUR DE RECONNAISSANCE MANUSCRITE MATH4CHILD v4.2.0
// =============================================================================

export interface Point {
  x: number;
  y: number;
  timestamp?: number;
}

export interface Stroke {
  points: Point[];
  color?: string;
  width?: number;
}

export interface Recognition {
  character: string;
  confidence: number;
  alternatives: { character: string; confidence: number }[];
}

export class HandwritingRecognizer {
  
  static recognizeStrokes(strokes: Stroke[]): Recognition {
    if (strokes.length === 0) {
      return { character: '', confidence: 0, alternatives: [] };
    }

    // Préprocessing des traits
    const normalizedStrokes = this.normalizeStrokes(strokes);
    
    // Extraction des caractéristiques
    const features = this.extractFeatures(normalizedStrokes);
    
    // Classification
    const result = this.classify(features);
    
    return result;
  }
  
  private static normalizeStrokes(strokes: Stroke[]): Stroke[] {
    // Trouver la boîte englobante
    let minX = Infinity, maxX = -Infinity;
    let minY = Infinity, maxY = -Infinity;
    
    strokes.forEach(stroke => {
      stroke.points.forEach(point => {
        minX = Math.min(minX, point.x);
        maxX = Math.max(maxX, point.x);
        minY = Math.min(minY, point.y);
        maxY = Math.max(maxY, point.y);
      });
    });
    
    const width = maxX - minX;
    const height = maxY - minY;
    const size = Math.max(width, height);
    
    // Normaliser à une taille standard (100x100)
    const scale = 100 / size;
    const offsetX = (100 - width * scale) / 2;
    const offsetY = (100 - height * scale) / 2;
    
    return strokes.map(stroke => ({
      ...stroke,
      points: stroke.points.map(point => ({
        x: (point.x - minX) * scale + offsetX,
        y: (point.y - minY) * scale + offsetY,
        timestamp: point.timestamp
      }))
    }));
  }
  
  private static extractFeatures(strokes: Stroke[]) {
    const features = {
      strokeCount: strokes.length,
      totalPoints: strokes.reduce((sum, stroke) => sum + stroke.points.length, 0),
      aspectRatio: 0,
      curvature: 0,
      intersections: 0,
      endpoints: strokes.length * 2,
      closedShapes: 0,
      corners: 0,
      straightLines: 0
    };
    
    // Calculer l'aspect ratio
    if (strokes.length > 0) {
      let minX = Infinity, maxX = -Infinity;
      let minY = Infinity, maxY = -Infinity;
      
      strokes.forEach(stroke => {
        stroke.points.forEach(point => {
          minX = Math.min(minX, point.x);
          maxX = Math.max(maxX, point.x);
          minY = Math.min(minY, point.y);
          maxY = Math.max(maxY, point.y);
        });
      });
      
      features.aspectRatio = (maxX - minX) / (maxY - minY);
    }
    
    // Détecter les formes fermées
    strokes.forEach(stroke => {
      if (stroke.points.length > 10) {
        const start = stroke.points[0];
        const end = stroke.points[stroke.points.length - 1];
        const distance = Math.sqrt((start.x - end.x)**2 + (start.y - end.y)**2);
        if (distance < 15) {
          features.closedShapes++;
        }
      }
    });
    
    return features;
  }
  
  private static classify(features: any): Recognition {
    const patterns = [
      {
        character: '0',
        match: (f: any) => f.strokeCount === 1 && f.closedShapes > 0 && f.aspectRatio > 0.6 && f.aspectRatio < 1.4
      },
      {
        character: '1',
        match: (f: any) => f.strokeCount <= 2 && f.aspectRatio < 0.5 && f.closedShapes === 0
      },
      {
        character: '2',
        match: (f: any) => f.strokeCount >= 1 && f.strokeCount <= 3 && f.aspectRatio > 0.5 && f.closedShapes === 0
      },
      {
        character: '3',
        match: (f: any) => f.strokeCount >= 1 && f.strokeCount <= 2 && f.aspectRatio > 0.4 && f.aspectRatio < 0.9
      },
      {
        character: '4',
        match: (f: any) => f.strokeCount >= 2 && f.strokeCount <= 3 && f.aspectRatio > 0.6
      },
      {
        character: '5',
        match: (f: any) => f.strokeCount >= 2 && f.strokeCount <= 4 && f.aspectRatio > 0.5
      },
      {
        character: '6',
        match: (f: any) => f.strokeCount === 1 && f.closedShapes > 0 && f.aspectRatio > 0.5 && f.aspectRatio < 1.2
      },
      {
        character: '7',
        match: (f: any) => f.strokeCount >= 1 && f.strokeCount <= 2 && f.aspectRatio > 0.4 && f.aspectRatio < 1.0
      },
      {
        character: '8',
        match: (f: any) => (f.strokeCount === 1 && f.closedShapes > 0) || f.strokeCount === 2
      },
      {
        character: '9',
        match: (f: any) => f.strokeCount === 1 && f.closedShapes > 0 && f.aspectRatio > 0.5 && f.aspectRatio < 1.2
      }
    ];
    
    const results = patterns.map(pattern => {
      const matches = pattern.match(features);
      const confidence = matches ? this.calculateConfidence(features, pattern.character) : 0;
      return { character: pattern.character, confidence };
    }).filter(result => result.confidence > 0).sort((a, b) => b.confidence - a.confidence);
    
    if (results.length === 0) {
      const fallback = this.fallbackRecognition(features);
      return {
        character: fallback,
        confidence: 0.3,
        alternatives: []
      };
    }
    
    return {
      character: results[0].character,
      confidence: results[0].confidence,
      alternatives: results.slice(1, 3)
    };
  }
  
  private static calculateConfidence(features: any, character: string): number {
    let confidence = 0.5;
    
    switch (character) {
      case '0':
        if (features.closedShapes > 0) confidence += 0.3;
        if (features.strokeCount === 1) confidence += 0.2;
        break;
      case '1':
        if (features.strokeCount <= 2) confidence += 0.2;
        if (features.aspectRatio < 0.5) confidence += 0.3;
        break;
      case '8':
        if (features.closedShapes > 0) confidence += 0.2;
        if (features.strokeCount <= 2) confidence += 0.2;
        break;
    }
    
    return Math.min(confidence, 1.0);
  }
  
  private static fallbackRecognition(features: any): string {
    if (features.strokeCount === 1 && features.closedShapes > 0) {
      return Math.random() > 0.5 ? '0' : '6';
    }
    
    if (features.strokeCount <= 2 && features.aspectRatio < 0.5) {
      return '1';
    }
    
    if (features.strokeCount >= 3) {
      const complex = ['4', '5', '8', '9'];
      return complex[Math.floor(Math.random() * complex.length)];
    }
    
    const numbers = ['2', '3', '7'];
    return numbers[Math.floor(Math.random() * numbers.length)];
  }
}
