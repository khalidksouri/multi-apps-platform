// =============================================
// UTILITAIRES DE CHAÎNES DE CARACTÈRES
// =============================================

// ===== FORMATAGE =====

export function capitalize(str: string): string {
  if (!str) return '';
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

export function capitalizeWords(str: string): string {
  if (!str) return '';
  return str.replace(/\w\S*/g, capitalize);
}

export function camelCase(str: string): string {
  return str
    .replace(/(?:^\w|[A-Z]|\b\w)/g, (word, index) => {
      return index === 0 ? word.toLowerCase() : word.toUpperCase();
    })
    .replace(/\s+/g, '');
}

export function kebabCase(str: string): string {
  return str
    .replace(/([a-z])([A-Z])/g, '$1-$2')
    .replace(/[\s_]+/g, '-')
    .toLowerCase();
}

export function snakeCase(str: string): string {
  return str
    .replace(/([a-z])([A-Z])/g, '$1_$2')
    .replace(/[\s-]+/g, '_')
    .toLowerCase();
}

// ===== NETTOYAGE =====

export function sanitizeHtml(str: string): string {
  const map: Record<string, string> = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#x27;',
    '/': '&#x2F;'
  };
  
  return str.replace(/[&<>"'/]/g, (char) => map[char]);
}

export function removeAccents(str: string): string {
  return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
}

export function cleanWhitespace(str: string): string {
  return str.replace(/\s+/g, ' ').trim();
}

export function removeSpecialChars(str: string, keep: string = ''): string {
  const pattern = new RegExp(`[^a-zA-Z0-9${keep}]`, 'g');
  return str.replace(pattern, '');
}

// ===== VALIDATION =====

export function isEmail(str: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(str);
}

export function isUrl(str: string): boolean {
  try {
    new URL(str);
    return true;
  } catch {
    return false;
  }
}

export function isPhoneNumber(str: string, country: string = 'FR'): boolean {
  const patterns = {
    FR: /^(?:\+33|0)[1-9](?:[0-9]{8})$/,
    US: /^\+?1?[2-9]\d{2}[2-9]\d{2}\d{4}$/,
    UK: /^\+?44[1-9]\d{8,9}$/
  };
  
  const pattern = patterns[country as keyof typeof patterns];
  return pattern ? pattern.test(str.replace(/[\s-]/g, '')) : false;
}

export function containsOnlyNumbers(str: string): boolean {
  return /^\d+$/.test(str);
}

export function containsOnlyLetters(str: string): boolean {
  return /^[a-zA-ZÀ-ÿ]+$/.test(str);
}

// ===== TRANSFORMATION =====

export function truncate(str: string, length: number, suffix: string = '...'): string {
  if (str.length <= length) return str;
  return str.slice(0, length - suffix.length) + suffix;
}

export function truncateWords(str: string, wordCount: number, suffix: string = '...'): string {
  const words = str.split(' ');
  if (words.length <= wordCount) return str;
  return words.slice(0, wordCount).join(' ') + suffix;
}

export function reverse(str: string): string {
  return str.split('').reverse().join('');
}

export function shuffle(str: string): string {
  const arr = str.split('');
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr.join('');
}

// ===== RECHERCHE ET CORRESPONDANCE =====

export function fuzzyMatch(str: string, pattern: string): boolean {
  const strLower = str.toLowerCase();
  const patternLower = pattern.toLowerCase();
  
  let strIndex = 0;
  let patternIndex = 0;
  
  while (strIndex < strLower.length && patternIndex < patternLower.length) {
    if (strLower[strIndex] === patternLower[patternIndex]) {
      patternIndex++;
    }
    strIndex++;
  }
  
  return patternIndex === patternLower.length;
}

export function highlightText(text: string, query: string): string {
  if (!query) return text;
  
  const regex = new RegExp(`(${escapeRegExp(query)})`, 'gi');
  return text.replace(regex, '<mark>$1</mark>');
}

export function escapeRegExp(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// ===== GÉNÉRATION =====

export function generateSlug(str: string): string {
  return removeAccents(str)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

export function generateRandomString(
  length: number = 8,
  charset: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
): string {
  let result = '';
  for (let i = 0; i < length; i++) {
    result += charset.charAt(Math.floor(Math.random() * charset.length));
  }
  return result;
}

export function generateUuid(): string {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// ===== FORMATAGE SPÉCIALISÉ =====

export function formatPrice(
  amount: number,
  currency: string = 'EUR',
  locale: string = 'fr-FR'
): string {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency
  }).format(amount);
}

export function formatFileSize(bytes: number): string {
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  if (bytes === 0) return '0 Bytes';
  
  const i = Math.floor(Math.log(bytes) / Math.log(1024));
  return Math.round(bytes / Math.pow(1024, i) * 100) / 100 + ' ' + sizes[i];
}

export function formatPhoneNumber(phone: string, country: string = 'FR'): string {
  const digitsOnly = phone.replace(/\D/g, '');
  
  switch (country) {
    case 'FR':
      if (digitsOnly.length === 10) {
        return digitsOnly.replace(/(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/, '$1 $2 $3 $4 $5');
      }
      break;
    case 'US':
      if (digitsOnly.length === 10) {
        return digitsOnly.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
      }
      break;
  }
  
  return phone;
}

// ===== ANALYSE =====

export function getWordCount(str: string): number {
  return str.trim().split(/\s+/).filter(word => word.length > 0).length;
}

export function getCharacterFrequency(str: string): Record<string, number> {
  const frequency: Record<string, number> = {};
  
  for (const char of str.toLowerCase()) {
    frequency[char] = (frequency[char] || 0) + 1;
  }
  
  return frequency;
}

export function getReadingTime(text: string, wordsPerMinute: number = 200): number {
  const wordCount = getWordCount(text);
  return Math.ceil(wordCount / wordsPerMinute);
}

// ===== MASQUAGE ET SÉCURITÉ =====

export function maskEmail(email: string): string {
  const [local, domain] = email.split('@');
  if (!local || !domain) return email;
  
  const maskedLocal = local.length > 2 
    ? local[0] + '*'.repeat(local.length - 2) + local[local.length - 1]
    : local;
    
  return `${maskedLocal}@${domain}`;
}

export function maskPhoneNumber(phone: string): string {
  const digits = phone.replace(/\D/g, '');
  if (digits.length < 4) return phone;
  
  const visible = 2;
  const masked = '*'.repeat(digits.length - visible * 2);
  return digits.slice(0, visible) + masked + digits.slice(-visible);
}

export function maskCreditCard(cardNumber: string): string {
  const digits = cardNumber.replace(/\D/g, '');
  if (digits.length < 8) return cardNumber;
  
  return '**** **** **** ' + digits.slice(-4);
}

// ===== CONSTANTES UTILES =====

export const REGEX_PATTERNS = {
  EMAIL: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  URL: /^https?:\/\/.+/,
  PHONE_FR: /^(?:\+33|0)[1-9](?:[0-9]{8})$/,
  POSTAL_CODE_FR: /^\d{5}$/,
  PASSWORD_STRONG: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
  UUID: /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i,
  HEX_COLOR: /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/,
  CREDIT_CARD: /^\d{4}\s?\d{4}\s?\d{4}\s?\d{4}$/
} as const;

export const CHARSETS = {
  ALPHANUMERIC: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
  NUMERIC: '0123456789',
  ALPHA: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
  ALPHA_UPPER: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  ALPHA_LOWER: 'abcdefghijklmnopqrstuvwxyz',
  SPECIAL: '!@#$%^&*()_+-=[]{}|;:,.<>?',
  PASSWORD: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*'
} as const;