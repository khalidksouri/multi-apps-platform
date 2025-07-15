export const utils = {
  formatDate: (date: Date): string => {
    return date.toISOString().split('T')[0];
  },
  
  generateId: (): string => {
    return Math.random().toString(36).substr(2, 9);
  },
  
  delay: (ms: number): Promise<void> => {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
};

export type ApiResponse<T = any> = {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
};

export const createApiResponse = <T>(
  success: boolean,
  data?: T,
  error?: string
): ApiResponse<T> => ({
  success,
  data,
  error,
  timestamp: new Date().toISOString(),
});
