// Types principaux pour Math4Child

export interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
  rtl?: boolean;
}

export interface Feature {
  id: string;
  title: string;
  description: string;
  icon: React.ReactNode;
  gradient: string;
  stats?: string;
}

export interface PricingPlan {
  id: string;
  name: string;
  price: number;
  originalPrice?: number;
  features: string[];
  popular?: boolean;
  color: string;
}

export interface PerformanceMetrics {
  domContentLoaded: number;
  loadComplete: number;
  firstPaint: number;
  firstContentfulPaint: number;
}

export interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '4xl' | '5xl';
  className?: string;
}

export interface LanguageSelectorProps {
  languages: Language[];
  selectedLanguage: Language;
  onLanguageChange: (language: Language) => void;
  className?: string;
}

export interface PricingCardProps {
  plan: PricingPlan;
  onSelect: (planId: string) => void;
  className?: string;
}
