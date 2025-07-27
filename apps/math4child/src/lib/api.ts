const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001/api';

class ApiClient {
  private baseURL: string;
  private token: string | null = null;

  constructor(baseURL: string) {
    this.baseURL = baseURL;
  }

  setToken(token: string) {
    this.token = token;
  }

  private async request(endpoint: string, options: RequestInit = {}) {
    const url = `${this.baseURL}${endpoint}`;
    const headers = { 'Content-Type': 'application/json', ...options.headers };
    if (this.token) headers.Authorization = `Bearer ${this.token}`;

    const response = await fetch(url, { ...options, headers });
    if (!response.ok) {
      const error = await response.json().catch(() => ({ message: 'Network error' }));
      throw new Error(error.message || `HTTP ${response.status}`);
    }
    return response.json();
  }

  async register(data: { email: string; password: string; name: string }) {
    return this.request('/auth/register', { method: 'POST', body: JSON.stringify(data) });
  }

  async login(data: { email: string; password: string }) {
    return this.request('/auth/login', { method: 'POST', body: JSON.stringify(data) });
  }

  async generateExercises(data: { type: string; level: string; count?: number }) {
    return this.request('/exercises/generate', { method: 'POST', body: JSON.stringify(data) });
  }

  async validateAnswer(data: { exerciseData: any; userAnswer: number; sessionId: string }) {
    return this.request('/exercises/validate', { method: 'POST', body: JSON.stringify(data) });
  }
}

export const apiClient = new ApiClient(API_BASE_URL);
