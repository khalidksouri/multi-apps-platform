export interface AIProvider {
  id: string;
  name: string;
  status: 'active' | 'inactive' | 'error';
  responseTime: number;
  reliability: number;
  cost: number;
}

export interface SearchQuery {
  id: string;
  text: string;
  selectedAIs: string[];
  mode: SearchMode;
  responses: AIResponse[];
  analysis: ComparisonAnalysis;
  createdAt: Date;
}

export type SearchMode = 'general' | 'code' | 'creative' | 'research' | 'business' | 'academic';

export interface AIResponse {
  aiId: string;
  content: string;
  confidence: number;
  responseTime: number;
  tokensUsed: number;
  error?: string;
}

export interface ComparisonAnalysis {
  consensus: number;
  keyDifferences: string[];
  recommendation: string;
  reliabilityScore: number;
}
