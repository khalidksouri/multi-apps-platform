export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: Date;
}

export interface APIResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
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

export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface ConversionResult {
  id: string;
  category: string;
  fromValue: number;
  fromUnit: string;
  toValue: number;
  toUnit: string;
  formula: string;
  createdAt: Date;
}
