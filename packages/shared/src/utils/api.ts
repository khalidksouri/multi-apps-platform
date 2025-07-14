// =============================================
// UTILITAIRES API PARTAGÉS
// =============================================

export interface ApiRequestConfig {
  method?: 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';
  headers?: Record<string, string>;
  body?: any;
  timeout?: number;
  retries?: number;
  retryDelay?: number;
  baseUrl?: string;
}

export interface ApiResponse<T = any> {
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
    timestamp?: string;
  };
}

export interface ApiError {
  code: string;
  message: string;
  status?: number;
  details?: any;
}

// =============================================
// CLIENT API PRINCIPAL
// =============================================

export class ApiClient {
  private baseUrl: string;
  private defaultHeaders: Record<string, string>;
  private timeout: number;
  private retries: number;

  constructor(config: {
    baseUrl?: string;
    headers?: Record<string, string>;
    timeout?: number;
    retries?: number;
  } = {}) {
    this.baseUrl = config.baseUrl || '';
    this.defaultHeaders = {
      'Content-Type': 'application/json',
      ...config.headers
    };
    this.timeout = config.timeout || 30000;
    this.retries = config.retries || 3;
  }

  async request<T>(
    endpoint: string,
    config: ApiRequestConfig = {}
  ): Promise<ApiResponse<T>> {
    const {
      method = 'GET',
      headers = {},
      body,
      timeout = this.timeout,
      retries = this.retries,
      retryDelay = 1000
    } = config;

    const url = this.buildUrl(endpoint, config.baseUrl);
    const requestHeaders = { ...this.defaultHeaders, ...headers };

    let lastError: Error | null = null;

    for (let attempt = 0; attempt <= retries; attempt++) {
      try {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeout);

        const response = await fetch(url, {
          method,
          headers: requestHeaders,
          body: body ? JSON.stringify(body) : undefined,
          signal: controller.signal
        });

        clearTimeout(timeoutId);

        const result = await this.handleResponse<T>(response);

        if (result.success || attempt === retries) {
          return result;
        }

        // Retry pour les erreurs 5xx
        if (response.status >= 500 && attempt < retries) {
          await this.delay(retryDelay * Math.pow(2, attempt));
          continue;
        }

        return result;

      } catch (error) {
        lastError = error as Error;
        
        if (attempt < retries) {
          await this.delay(retryDelay * Math.pow(2, attempt));
          continue;
        }
      }
    }

    return {
      success: false,
      error: {
        code: 'NETWORK_ERROR',
        message: lastError?.message || 'Erreur réseau inconnue'
      }
    };
  }

  private buildUrl(endpoint: string, baseUrl?: string): string {
    const base = baseUrl || this.baseUrl;
    const cleanBase = base.replace(/\/$/, '');
    const cleanEndpoint = endpoint.replace(/^\//, '');
    return `${cleanBase}/${cleanEndpoint}`;
  }

  private async handleResponse<T>(response: Response): Promise<ApiResponse<T>> {
    try {
      const contentType = response.headers.get('content-type');
      const isJson = contentType?.includes('application/json');

      if (!response.ok) {
        const errorData = isJson ? await response.json() : { message: response.statusText };
        
        return {
          success: false,
          error: {
            code: this.getErrorCode(response.status),
            message: errorData.message || 'Erreur inconnue',
            details: errorData
          }
        };
      }

      const data = isJson ? await response.json() : await response.text();

      return {
        success: true,
        data: data as T,
        meta: {
          timestamp: new Date().toISOString()
        }
      };

    } catch (error) {
      return {
        success: false,
        error: {
          code: 'PARSE_ERROR',
          message: 'Erreur lors du parsing de la réponse'
        }
      };
    }
  }

  private getErrorCode(status: number): string {
    const codes: Record<number, string> = {
      400: 'BAD_REQUEST',
      401: 'UNAUTHORIZED',
      403: 'FORBIDDEN',
      404: 'NOT_FOUND',
      409: 'CONFLICT',
      422: 'VALIDATION_ERROR',
      429: 'RATE_LIMITED',
      500: 'INTERNAL_ERROR',
      502: 'BAD_GATEWAY',
      503: 'SERVICE_UNAVAILABLE',
      504: 'GATEWAY_TIMEOUT'
    };

    return codes[status] || 'UNKNOWN_ERROR';
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  // ===== MÉTHODES RACCOURCIES =====

  async get<T>(endpoint: string, config?: Omit<ApiRequestConfig, 'method'>): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, { ...config, method: 'GET' });
  }

  async post<T>(endpoint: string, data?: any, config?: Omit<ApiRequestConfig, 'method' | 'body'>): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, { ...config, method: 'POST', body: data });
  }

  async put<T>(endpoint: string, data?: any, config?: Omit<ApiRequestConfig, 'method' | 'body'>): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, { ...config, method: 'PUT', body: data });
  }

  async patch<T>(endpoint: string, data?: any, config?: Omit<ApiRequestConfig, 'method' | 'body'>): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, { ...config, method: 'PATCH', body: data });
  }

  async delete<T>(endpoint: string, config?: Omit<ApiRequestConfig, 'method'>): Promise<ApiResponse<T>> {
    return this.request<T>(endpoint, { ...config, method: 'DELETE' });
  }

  // ===== CONFIGURATION =====

  setBaseUrl(baseUrl: string): void {
    this.baseUrl = baseUrl;
  }

  setDefaultHeader(key: string, value: string): void {
    this.defaultHeaders[key] = value;
  }

  removeDefaultHeader(key: string): void {
    delete this.defaultHeaders[key];
  }

  setAuthToken(token: string): void {
    this.setDefaultHeader('Authorization', `Bearer ${token}`);
  }

  clearAuthToken(): void {
    this.removeDefaultHeader('Authorization');
  }
}

// =============================================
// FONCTIONS UTILITAIRES
// =============================================

export function createApiClient(config?: {
  baseUrl?: string;
  headers?: Record<string, string>;
  timeout?: number;
  retries?: number;
}): ApiClient {
  return new ApiClient(config);
}

export function isApiError(response: ApiResponse): response is ApiResponse & { success: false; error: ApiError } {
  return !response.success && !!response.error;
}

export function handleApiError(response: ApiResponse): never {
  if (isApiError(response)) {
    throw new Error(`[${response.error.code}] ${response.error.message}`);
  }
  throw new Error('Erreur API inconnue');
}

export function buildQueryString(params: Record<string, any>): string {
  const searchParams = new URLSearchParams();
  
  Object.entries(params).forEach(([key, value]) => {
    if (value !== null && value !== undefined && value !== '') {
      if (Array.isArray(value)) {
        value.forEach(item => searchParams.append(key, String(item)));
      } else {
        searchParams.append(key, String(value));
      }
    }
  });
  
  return searchParams.toString();
}

export function parseApiResponse<T>(response: any): ApiResponse<T> {
  if (typeof response !== 'object' || response === null) {
    return {
      success: false,
      error: {
        code: 'INVALID_RESPONSE',
        message: 'Réponse API invalide'
      }
    };
  }

  return {
    success: response.success === true,
    data: response.data,
    error: response.error,
    meta: response.meta
  };
}

// =============================================
// HOOKS ET UTILITAIRES SPÉCIALISÉS
// =============================================

export class ApiCache {
  private cache = new Map<string, { data: any; timestamp: number; ttl: number }>();

  set(key: string, data: any, ttl: number = 300000): void { // 5 minutes par défaut
    this.cache.set(key, {
      data,
      timestamp: Date.now(),
      ttl
    });
  }

  get(key: string): any | null {
    const cached = this.cache.get(key);
    
    if (!cached) return null;
    
    if (Date.now() - cached.timestamp > cached.ttl) {
      this.cache.delete(key);
      return null;
    }
    
    return cached.data;
  }

  clear(): void {
    this.cache.clear();
  }

  delete(key: string): void {
    this.cache.delete(key);
  }
}

export class ApiRateLimiter {
  private requests = new Map<string, number[]>();
  private limit: number;
  private window: number; // en ms

  constructor(limit: number = 100, window: number = 60000) { // 100 requêtes par minute
    this.limit = limit;
    this.window = window;
  }

  canMakeRequest(key: string = 'default'): boolean {
    const now = Date.now();
    const requests = this.requests.get(key) || [];
    
    // Nettoyer les anciennes requêtes
    const validRequests = requests.filter(time => now - time < this.window);
    
    if (validRequests.length >= this.limit) {
      return false;
    }
    
    validRequests.push(now);
    this.requests.set(key, validRequests);
    
    return true;
  }

  getTimeUntilReset(key: string = 'default'): number {
    const requests = this.requests.get(key) || [];
    if (requests.length === 0) return 0;
    
    const oldestRequest = Math.min(...requests);
    const resetTime = oldestRequest + this.window;
    
    return Math.max(0, resetTime - Date.now());
  }
}

// =============================================
// INSTANCES PARTAGÉES
// =============================================

export const defaultApiClient = createApiClient();
export const apiCache = new ApiCache();
export const apiRateLimiter = new ApiRateLimiter();

// =============================================
// TYPES D'EXPORT
// =============================================

export type RequestMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE';
export type ApiClientInstance = ApiClient;