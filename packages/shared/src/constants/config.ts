// =============================================
// CONSTANTES DE CONFIGURATION PARTAGÉES
// =============================================

// ===== URLS DES APPLICATIONS =====
export const APP_URLS = {
  AI4KIDS: process.env.AI4KIDS_URL || 'http://localhost:3004',
  MULTIAI: process.env.MULTIAI_URL || 'http://localhost:3005',
  BUDGETCRON: process.env.BUDGETCRON_URL || 'http://localhost:3003',
  UNITFLIP: process.env.UNITFLIP_URL || 'http://localhost:3002',
  POSTMATH: process.env.POSTMATH_URL || 'http://localhost:3001'
} as const;

// ===== PORTS DES APPLICATIONS =====
export const APP_PORTS = {
  AI4KIDS: 3004,
  MULTIAI: 3005,
  BUDGETCRON: 3003,
  UNITFLIP: 3002,
  POSTMATH: 3001
} as const;

// ===== TIMEOUTS =====
export const TIMEOUTS = {
  API_REQUEST: 30000,
  PAGE_LOAD: 60000,
  ACTION: 10000,
  NAVIGATION: 30000,
  PERFORMANCE: 120000,
  ACCESSIBILITY: 45000,
  SECURITY: 90000
} as const;

// ===== LIMITES =====
export const LIMITS = {
  SHIPPING: {
    MAX_WEIGHT: 30,
    MIN_WEIGHT: 0.1,
    MAX_DIMENSION: 200,
    MIN_DIMENSION: 1
  },
  BUDGET: {
    MAX_AMOUNT: 999999.99,
    MIN_AMOUNT: 0.01,
    MAX_CATEGORIES: 20
  },
  CONVERSION: {
    MAX_VALUE: 1000000,
    MIN_VALUE: -1000000,
    PRECISION: 6
  },
  AI4KIDS: {
    MIN_AGE: 3,
    MAX_AGE: 18,
    MAX_SESSION_TIME: 120, // minutes
    MAX_DAILY_TIME: 180 // minutes
  },
  UPLOAD: {
    MAX_FILE_SIZE: 10 * 1024 * 1024, // 10MB
    ALLOWED_TYPES: ['image/jpeg', 'image/png', 'image/gif', 'application/pdf']
  }
} as const;

// ===== CODES D'ERREUR =====
export const ERROR_CODES = {
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  NETWORK_ERROR: 'NETWORK_ERROR',
  AUTH_ERROR: 'AUTH_ERROR',
  NOT_FOUND: 'NOT_FOUND',
  SERVER_ERROR: 'SERVER_ERROR',
  RATE_LIMITED: 'RATE_LIMITED',
  TIMEOUT: 'TIMEOUT',
  PERMISSION_DENIED: 'PERMISSION_DENIED'
} as const;

// ===== MESSAGES D'ERREUR =====
export const ERROR_MESSAGES = {
  [ERROR_CODES.VALIDATION_ERROR]: 'Données invalides',
  [ERROR_CODES.NETWORK_ERROR]: 'Erreur de connexion',
  [ERROR_CODES.AUTH_ERROR]: 'Authentification requise',
  [ERROR_CODES.NOT_FOUND]: 'Ressource non trouvée',
  [ERROR_CODES.SERVER_ERROR]: 'Erreur serveur',
  [ERROR_CODES.RATE_LIMITED]: 'Trop de requêtes',
  [ERROR_CODES.TIMEOUT]: 'Délai d\'attente dépassé',
  [ERROR_CODES.PERMISSION_DENIED]: 'Permission refusée'
} as const;

// ===== STATUTS =====
export const STATUS = {
  LOADING: 'loading',
  SUCCESS: 'success',
  ERROR: 'error',
  IDLE: 'idle'
} as const;

export const HTTP_STATUS = {
  OK: 200,
  CREATED: 201,
  NO_CONTENT: 204,
  BAD_REQUEST: 400,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  VALIDATION_ERROR: 422,
  RATE_LIMITED: 429,
  INTERNAL_ERROR: 500,
  BAD_GATEWAY: 502,
  SERVICE_UNAVAILABLE: 503,
  GATEWAY_TIMEOUT: 504
} as const;

// ===== LANGUES ET LOCALES =====
export const LOCALES = {
  FR: 'fr-FR',
  EN: 'en-US',
  ES: 'es-ES',
  DE: 'de-DE'
} as const;

export const CURRENCIES = {
  EUR: 'EUR',
  USD: 'USD',
  GBP: 'GBP',
  JPY: 'JPY'
} as const;

export const TIMEZONES = {
  PARIS: 'Europe/Paris',
  LONDON: 'Europe/London',
  NEW_YORK: 'America/New_York',
  TOKYO: 'Asia/Tokyo',
  UTC: 'UTC'
} as const;

// ===== FORMATS =====
export const DATE_FORMATS = {
  SHORT: 'dd/MM/yyyy',
  LONG: 'dd MMMM yyyy',
  TIME: 'HH:mm',
  DATETIME: 'dd/MM/yyyy HH:mm',
  ISO: 'yyyy-MM-dd',
  ISO_DATETIME: 'yyyy-MM-dd\'T\'HH:mm:ss'
} as const;

export const NUMBER_FORMATS = {
  DECIMAL: { minimumFractionDigits: 2, maximumFractionDigits: 2 },
  INTEGER: { minimumFractionDigits: 0, maximumFractionDigits: 0 },
  PERCENTAGE: { style: 'percent', minimumFractionDigits: 1 },
  CURRENCY: { style: 'currency', currency: 'EUR' }
} as const;

// ===== CATÉGORIES =====
export const CONVERSION_CATEGORIES = {
  TEMPERATURE: 'temperature',
  LENGTH: 'length',
  WEIGHT: 'weight',
  VOLUME: 'volume',
  SPEED: 'speed',
  ENERGY: 'energy',
  PRESSURE: 'pressure',
  POWER: 'power'
} as const;

export const BUDGET_CATEGORIES = {
  FOOD: 'alimentation',
  TRANSPORT: 'transport',
  ENTERTAINMENT: 'loisirs',
  HOUSING: 'logement',
  HEALTH: 'sante',
  EDUCATION: 'education',
  SHOPPING: 'achats',
  OTHER: 'autre'
} as const;

// ===== UNITÉS DE MESURE =====
export const UNITS = {
  TEMPERATURE: {
    CELSIUS: 'celsius',
    FAHRENHEIT: 'fahrenheit',
    KELVIN: 'kelvin'
  },
  LENGTH: {
    METERS: 'meters',
    KILOMETERS: 'kilometers',
    CENTIMETERS: 'centimeters',
    FEET: 'feet',
    INCHES: 'inches'
  },
  WEIGHT: {
    KILOGRAMS: 'kilograms',
    GRAMS: 'grams',
    POUNDS: 'pounds',
    OUNCES: 'ounces'
  }
} as const;

// ===== TRANSPORTEURS =====
export const CARRIERS = {
  COLISSIMO: 'colissimo',
  CHRONOPOST: 'chronopost',
  UPS: 'ups',
  DHL: 'dhl',
  FEDEX: 'fedex',
  DPD: 'dpd'
} as const;

// ===== RÔLES ET PERMISSIONS =====
export const USER_ROLES = {
  ADMIN: 'admin',
  USER: 'user',
  CHILD: 'child',
  PARENT: 'parent',
  GUEST: 'guest'
} as const;

export const PERMISSIONS = {
  READ: 'read',
  WRITE: 'write',
  DELETE: 'delete',
  ADMIN: 'admin'
} as const;

// ===== FEATURE FLAGS =====
export const FEATURE_FLAGS = {
  BETA_FEATURES: 'betaFeatures',
  PERFORMANCE_MONITORING: 'performanceMonitoring',
  ACCESSIBILITY_CHECKS: 'accessibilityChecks',
  SECURITY_SCANNING: 'securityScanning',
  AI_INSIGHTS: 'aiInsights',
  REAL_TIME_SYNC: 'realTimeSync'
} as const;

// ===== REGEX PATTERNS =====
export const PATTERNS = {
  EMAIL: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  PHONE_FR: /^(?:\+33|0)[1-9](?:[0-9]{8})$/,
  POSTAL_CODE_FR: /^\d{5}$/,
  DIMENSIONS: /^\d+x\d+x\d+$/,
  UUID: /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i,
  PASSWORD_STRONG: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/
} as const;

// ===== CONFIGURATION API =====
export const API_CONFIG = {
  BASE_URL: process.env.API_BASE_URL || '/api',
  TIMEOUT: 30000,
  RETRIES: 3,
  RETRY_DELAY: 1000,
  RATE_LIMIT: {
    REQUESTS: 100,
    WINDOW: 60000 // 1 minute
  }
} as const;

// ===== CONFIGURATION DE TEST =====
export const TEST_CONFIG = {
  BROWSER: process.env.BROWSER || 'chromium',
  HEADLESS: process.env.HEADLESS !== 'false',
  VIEWPORT: {
    WIDTH: parseInt(process.env.VIEWPORT_WIDTH || '1280'),
    HEIGHT: parseInt(process.env.VIEWPORT_HEIGHT || '720')
  },
  DEVICES: {
    MOBILE: { width: 375, height: 667 },
    TABLET: { width: 768, height: 1024 },
    DESKTOP: { width: 1280, height: 720 }
  }
} as const;

// ===== SEUILS DE PERFORMANCE =====
export const PERFORMANCE_THRESHOLDS = {
  PAGE_LOAD: 5000,
  DOM_CONTENT_LOADED: 3000,
  FIRST_CONTENTFUL_PAINT: 2000,
  LARGEST_CONTENTFUL_PAINT: 4000,
  CUMULATIVE_LAYOUT_SHIFT: 0.1,
  TOTAL_BLOCKING_TIME: 300,
  INTERACTION: 2000,
  API_RESPONSE: 3000
} as const;

// ===== CONFIGURATION ACCESSIBILITÉ =====
export const A11Y_CONFIG = {
  WCAG_LEVEL: 'AA',
  CONTRAST_RATIO: {
    NORMAL: 4.5,
    LARGE: 3.0
  },
  ARIA_ROLES: [
    'button', 'link', 'navigation', 'main', 'banner', 'contentinfo',
    'complementary', 'form', 'search', 'region', 'article', 'section'
  ]
} as const;

// ===== CONFIGURATION SÉCURITÉ =====
export const SECURITY_CONFIG = {
  HEADERS: {
    CSP: "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'",
    HSTS: 'max-age=31536000; includeSubDomains',
    X_FRAME_OPTIONS: 'DENY',
    X_CONTENT_TYPE_OPTIONS: 'nosniff'
  },
  SESSION: {
    TIMEOUT: 30 * 60 * 1000, // 30 minutes
    REFRESH_THRESHOLD: 5 * 60 * 1000 // 5 minutes
  }
} as const;

// ===== ENVIRONNEMENTS =====
export const ENVIRONMENTS = {
  DEVELOPMENT: 'development',
  TEST: 'test',
  STAGING: 'staging',
  PRODUCTION: 'production'
} as const;

// ===== VERSION ET INFO =====
export const APP_INFO = {
  VERSION: process.env.npm_package_version || '1.0.0',
  NAME: 'Multi-Apps Testing Suite',
  DESCRIPTION: 'Suite de tests BDD pour applications multiples',
  BUILD_DATE: new Date().toISOString(),
  ENVIRONMENT: process.env.NODE_ENV || 'development'
} as const;

// ===== EXPORT DE TYPES =====
export type Locale = typeof LOCALES[keyof typeof LOCALES];
export type Currency = typeof CURRENCIES[keyof typeof CURRENCIES];
export type Timezone = typeof TIMEZONES[keyof typeof TIMEZONES];
export type ConversionCategory = typeof CONVERSION_CATEGORIES[keyof typeof CONVERSION_CATEGORIES];
export type BudgetCategory = typeof BUDGET_CATEGORIES[keyof typeof BUDGET_CATEGORIES];
export type UserRole = typeof USER_ROLES[keyof typeof USER_ROLES];
export type Permission = typeof PERMISSIONS[keyof typeof PERMISSIONS];
export type Environment = typeof ENVIRONMENTS[keyof typeof ENVIRONMENTS];
export type ErrorCode = typeof ERROR_CODES[keyof typeof ERROR_CODES];