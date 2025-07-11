export interface User {
  id: string;
  email: string;
  name: string;
  accountType: AccountType;
  createdAt: Date;
  updatedAt: Date;
  preferences: UserPreferences;
}

export type AccountType = 'gratuit' | 'premium' | 'business';

export interface UserPreferences {
  language: string;
  timezone: string;
  notifications: {
    email: boolean;
    push: boolean;
    security: boolean;
  };
  theme: 'light' | 'dark' | 'auto';
}

export interface APIResponse<T = any> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: any;
  };
  meta?: {
    page?: number;
    limit?: number;
    total?: number;
  };
}
