export interface Transaction {
  id: string;
  amount: number;
  merchant: string;
  category: string;
  date: Date;
  description?: string;
  bankId: string;
  isRecurring: boolean;
  tags: string[];
}

export interface Bank {
  id: string;
  name: string;
  type: BankType;
  status: BankStatus;
  lastSync: Date;
  balance: number;
  currency: string;
}

export type BankType = 'checking' | 'savings' | 'credit';
export type BankStatus = 'active' | 'inactive' | 'error' | 'syncing';

export interface AIInsight {
  id: string;
  type: InsightType;
  title: string;
  description: string;
  confidence: number;
  suggestedAction?: string;
  potentialSavings?: number;
  createdAt: Date;
}

export type InsightType = 
  | 'spending_pattern' 
  | 'budget_alert' 
  | 'savings_opportunity' 
  | 'unusual_activity';
