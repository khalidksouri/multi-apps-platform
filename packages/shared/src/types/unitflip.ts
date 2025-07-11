export interface Conversion {
  id: string;
  category: ConversionCategory;
  fromValue: number;
  fromUnit: string;
  toValue: number;
  toUnit: string;
  accuracy: number;
  createdAt: Date;
}

export type ConversionCategory = 
  | 'temperature' 
  | 'length' 
  | 'weight' 
  | 'volume' 
  | 'speed' 
  | 'energy' 
  | 'pressure' 
  | 'power';

export interface VoiceCommand {
  id: string;
  transcript: string;
  confidence: number;
  conversion?: Conversion;
  error?: string;
  processedAt: Date;
}
