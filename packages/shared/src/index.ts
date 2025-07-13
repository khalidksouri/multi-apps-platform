// Types pour l'API de shipping
export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

export interface APIResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
}

// Types pour la conversion d'unités
export interface ConversionResult {
  value: number;
  unit: string;
  explanation: string;
}

export interface UnitCategory {
  id: string;
  name: string;
  units: UnitDefinition[];
}

export interface UnitDefinition {
  id: string;
  name: string;
  symbol: string;
  toBase: (value: number) => number;
  fromBase: (value: number) => number;
}

// Types pour le budget
export interface BudgetCategory {
  id: string;
  name: string;
  budget: number;
  spent: number;
  color: string;
}

export interface BudgetInsight {
  id: number;
  type: 'savings_opportunity' | 'budget_alert' | 'spending_pattern';
  title: string;
  description: string;
  confidence: number;
  color: string;
}

export interface BankAccount {
  id: string;
  name: string;
  type: string;
  balance: number;
  status: 'active' | 'error' | 'pending';
  lastSync: Date;
}