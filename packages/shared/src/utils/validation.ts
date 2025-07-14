import { z } from 'zod';

// =============================================
// SCHÉMAS DE VALIDATION PARTAGÉS
// =============================================

// Validation d'email
export const emailSchema = z
  .string()
  .email('Format d\'email invalide')
  .min(1, 'Email requis');

// Validation de mot de passe
export const passwordSchema = z
  .string()
  .min(8, 'Le mot de passe doit contenir au moins 8 caractères')
  .regex(/[A-Z]/, 'Doit contenir une majuscule')
  .regex(/[a-z]/, 'Doit contenir une minuscule')
  .regex(/[0-9]/, 'Doit contenir un chiffre')
  .regex(/[^A-Za-z0-9]/, 'Doit contenir un caractère spécial');

// Validation d'expédition
export const shippingSchema = z.object({
  departure: z.string().min(1, 'Ville de départ requise'),
  destination: z.string().min(1, 'Ville de destination requise'),
  weight: z
    .number()
    .min(0.1, 'Poids minimum 0.1kg')
    .max(30, 'Poids maximum 30kg'),
  dimensions: z
    .string()
    .regex(/^\d+x\d+x\d+$/, 'Format: LxlxH (ex: 30x20x15)')
});

// Validation de conversion d'unités
export const conversionSchema = z.object({
  value: z.number().min(0, 'La valeur doit être positive'),
  fromUnit: z.string().min(1, 'Unité source requise'),
  toUnit: z.string().min(1, 'Unité cible requise'),
  category: z.enum(['temperature', 'length', 'weight', 'volume'])
});

// Validation de budget
export const budgetSchema = z.object({
  amount: z.number().min(0, 'Le montant doit être positif'),
  category: z.string().min(1, 'Catégorie requise'),
  description: z.string().optional(),
  date: z.date()
});

// Validation d'enfant (AI4Kids)
export const childSchema = z.object({
  name: z.string().min(1, 'Nom requis').max(50, 'Nom trop long'),
  age: z.number().min(3, 'Âge minimum 3 ans').max(18, 'Âge maximum 18 ans'),
  parentEmail: emailSchema,
  level: z.number().min(1).max(10)
});

// =============================================
// FONCTIONS DE VALIDATION
// =============================================

export function validateEmail(email: string): boolean {
  try {
    emailSchema.parse(email);
    return true;
  } catch {
    return false;
  }
}

export function validatePassword(password: string): {
  isValid: boolean;
  errors: string[];
} {
  try {
    passwordSchema.parse(password);
    return { isValid: true, errors: [] };
  } catch (error) {
    if (error instanceof z.ZodError) {
      return {
        isValid: false,
        errors: error.errors.map(e => e.message)
      };
    }
    return { isValid: false, errors: ['Erreur de validation'] };
  }
}

export function validateShipping(data: any): {
  isValid: boolean;
  errors: Record<string, string>;
} {
  try {
    shippingSchema.parse(data);
    return { isValid: true, errors: {} };
  } catch (error) {
    if (error instanceof z.ZodError) {
      const errors: Record<string, string> = {};
      error.errors.forEach(e => {
        if (e.path.length > 0) {
          errors[e.path[0] as string] = e.message;
        }
      });
      return { isValid: false, errors };
    }
    return { isValid: false, errors: { general: 'Erreur de validation' } };
  }
}

export function validateNumericInput(
  value: string,
  min?: number,
  max?: number
): { isValid: boolean; value?: number; error?: string } {
  const num = parseFloat(value);
  
  if (isNaN(num)) {
    return { isValid: false, error: 'Doit être un nombre valide' };
  }
  
  if (min !== undefined && num < min) {
    return { isValid: false, error: `Valeur minimum: ${min}` };
  }
  
  if (max !== undefined && num > max) {
    return { isValid: false, error: `Valeur maximum: ${max}` };
  }
  
  return { isValid: true, value: num };
}

// =============================================
// VALIDATEURS SPÉCIALISÉS
// =============================================

export function validateDimensions(dimensions: string): boolean {
  const regex = /^\d+x\d+x\d+$/;
  if (!regex.test(dimensions)) return false;
  
  const [l, w, h] = dimensions.split('x').map(Number);
  return l > 0 && w > 0 && h > 0 && l <= 200 && w <= 200 && h <= 200;
}

export function validatePostalCode(code: string, country: string = 'FR'): boolean {
  const patterns = {
    FR: /^\d{5}$/,
    US: /^\d{5}(-\d{4})?$/,
    UK: /^[A-Z]{1,2}\d[A-Z\d]? ?\d[A-Z]{2}$/i,
    DE: /^\d{5}$/
  };
  
  const pattern = patterns[country as keyof typeof patterns];
  return pattern ? pattern.test(code) : false;
}

export function validatePhoneNumber(phone: string, country: string = 'FR'): boolean {
  const patterns = {
    FR: /^(?:\+33|0)[1-9](?:[0-9]{8})$/,
    US: /^\+?1?[2-9]\d{2}[2-9]\d{2}\d{4}$/,
    UK: /^\+?44[1-9]\d{8,9}$/
  };
  
  const pattern = patterns[country as keyof typeof patterns];
  return pattern ? pattern.test(phone.replace(/[\s-]/g, '')) : false;
}

// =============================================
// TYPES D'EXPORT
// =============================================

export type ValidationResult<T> = {
  isValid: boolean;
  data?: T;
  errors?: Record<string, string>;
};

export type ValidatorFunction<T> = (data: unknown) => ValidationResult<T>;