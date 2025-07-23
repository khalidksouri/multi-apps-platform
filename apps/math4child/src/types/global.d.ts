// Global type declarations for Math4Child

declare module '@/contexts/LanguageContext' {
  export interface Language {
    code: string;
    name: string;
    nativeName: string;
    direction: 'ltr' | 'rtl';
  }
  
  export interface LanguageContextType {
    currentLanguage: string;
    changeLanguage: (language: string) => void;
    t: (key: string, fallback?: string) => string;
    availableLanguages: Language[];
  }
  
  export function LanguageProvider({ children, defaultLanguage }: {
    children: React.ReactNode;
    defaultLanguage?: string;
  }): JSX.Element;
  
  export function useLanguage(): LanguageContextType;
}

declare module '@/lib/optimal-payments' {
  export interface PaymentProvider {
    name: string;
    isAvailable: boolean;
    priority: number;
  }
  
  export interface PaymentIntent {
    amount: number;
    currency: string;
    provider?: string;
    metadata?: Record<string, string>;
  }
  
  export interface PaymentResponse {
    provider: string;
    clientSecret?: string;
    checkoutUrl?: string;
    productId?: string;
    amount: number;
    currency: string;
    success: boolean;
    error?: string;
  }
  
  export class OptimalPayments {
    getOptimalProvider(): PaymentProvider;
    createPaymentIntent(intent: PaymentIntent): Promise<PaymentResponse>;
  }
  
  export const optimalPayments: OptimalPayments;
  export default optimalPayments;
}
