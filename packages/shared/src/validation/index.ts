// Validation de base sans dépendances externes
export interface ValidationResult<T> {
  success: boolean;
  data?: T;
  errors?: string[];
}

// Validation d'email simple
export const validateEmail = (email: string): boolean => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

// Validation de mot de passe
export const validatePassword = (password: string): boolean => {
  return password.length >= 8 && 
         /[A-Z]/.test(password) && 
         /[a-z]/.test(password) && 
         /[0-9]/.test(password) && 
         /[^A-Za-z0-9]/.test(password);
};

// Validation des données d'expédition
export const validateShippingData = (data: any): ValidationResult<any> => {
  const errors: string[] = [];
  
  if (!data.departure || typeof data.departure !== 'string' || data.departure.trim().length === 0) {
    errors.push('Ville de départ requise');
  }
  
  if (!data.destination || typeof data.destination !== 'string' || data.destination.trim().length === 0) {
    errors.push('Ville de destination requise');
  }
  
  if (!data.weight || typeof data.weight !== 'number' || data.weight <= 0 || data.weight > 30) {
    errors.push('Poids invalide (0.1-30kg)');
  }
  
  if (!data.dimensions || typeof data.dimensions !== 'string' || !/^\d+x\d+x\d+$/.test(data.dimensions)) {
    errors.push('Format dimensions invalide (LxlxH)');
  }
  
  // Vérifier les tentatives d'injection
  const dangerousPatterns = [
    /<script/i,
    /javascript:/i,
    /on\w+\s*=/i,
    /drop\s+table/i,
    /union\s+select/i,
    /insert\s+into/i,
    /delete\s+from/i,
    /update\s+set/i
  ];
  
  const allValues = [data.departure, data.destination, data.dimensions].join(' ');
  for (const pattern of dangerousPatterns) {
    if (pattern.test(allValues)) {
      errors.push('Contenu suspect détecté');
      break;
    }
  }
  
  return {
    success: errors.length === 0,
    data: errors.length === 0 ? data : undefined,
    errors: errors.length > 0 ? errors : undefined
  };
};

// Sanitisation de base
export const sanitizeString = (str: string): string => {
  return str.replace(/[<>\"'&]/g, (match) => {
    const replacements: { [key: string]: string } = {
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;',
      '&': '&amp;'
    };
    return replacements[match] || match;
  });
};

// Génération d'ID simple
export const generateId = (): string => {
  return Date.now().toString(36) + Math.random().toString(36).substr(2);
};
