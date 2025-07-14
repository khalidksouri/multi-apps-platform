import { useState, useEffect, useCallback } from 'react';
import { ApiClient } from '../utils/api';
import { USER_ROLES, type UserRole } from '../constants/config';

// =============================================
// TYPES D'AUTHENTIFICATION
// =============================================

export interface User {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  avatar?: string;
  preferences: UserPreferences;
  createdAt: Date;
  updatedAt: Date;
}

export interface UserPreferences {
  language: string;
  timezone: string;
  currency: string;
  theme: 'light' | 'dark' | 'auto';
  notifications: {
    email: boolean;
    push: boolean;
    security: boolean;
  };
}

export interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
}

export interface LoginCredentials {
  email: string;
  password: string;
  rememberMe?: boolean;
}

export interface RegisterData {
  email: string;
  password: string;
  name: string;
  role?: UserRole;
  acceptTerms: boolean;
}

export interface AuthHookReturn {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  login: (credentials: LoginCredentials) => Promise<boolean>;
  register: (data: RegisterData) => Promise<boolean>;
  logout: () => Promise<void>;
  refreshToken: () => Promise<boolean>;
  updateProfile: (updates: Partial<User>) => Promise<boolean>;
  resetPassword: (email: string) => Promise<boolean>;
  hasRole: (role: UserRole) => boolean;
  hasPermission: (permission: string) => boolean;
  clearError: () => void;
}

// =============================================
// STORAGE UTILITAIRES
// =============================================

const TOKEN_KEY = 'auth_token';
const USER_KEY = 'auth_user';
const REFRESH_TOKEN_KEY = 'auth_refresh_token';

function getStoredToken(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem(TOKEN_KEY);
}

function setStoredToken(token: string): void {
  if (typeof window === 'undefined') return;
  localStorage.setItem(TOKEN_KEY, token);
}

function removeStoredToken(): void {
  if (typeof window === 'undefined') return;
  localStorage.removeItem(TOKEN_KEY);
}

function getStoredUser(): User | null {
  if (typeof window === 'undefined') return null;
  const stored = localStorage.getItem(USER_KEY);
  return stored ? JSON.parse(stored) : null;
}

function setStoredUser(user: User): void {
  if (typeof window === 'undefined') return;
  localStorage.setItem(USER_KEY, JSON.stringify(user));
}

function removeStoredUser(): void {
  if (typeof window === 'undefined') return;
  localStorage.removeItem(USER_KEY);
}

// =============================================
// HOOK D'AUTHENTIFICATION
// =============================================

export function useAuth(apiClient?: ApiClient): AuthHookReturn {
  const [authState, setAuthState] = useState<AuthState>({
    user: null,
    token: null,
    isAuthenticated: false,
    isLoading: true,
    error: null
  });

  const api = apiClient || new ApiClient();

  // Initialisation au chargement
  useEffect(() => {
    const initAuth = async () => {
      const storedToken = getStoredToken();
      const storedUser = getStoredUser();

      if (storedToken && storedUser) {
        api.setAuthToken(storedToken);
        
        // Vérifier si le token est encore valide
        try {
          const response = await api.get('/auth/verify');
          if (response.success) {
            setAuthState({
              user: storedUser,
              token: storedToken,
              isAuthenticated: true,
              isLoading: false,
              error: null
            });
            return;
          }
        } catch {
          // Token invalide, nettoyer le storage
          removeStoredToken();
          removeStoredUser();
          api.clearAuthToken();
        }
      }

      setAuthState(prev => ({
        ...prev,
        isLoading: false
      }));
    };

    initAuth();
  }, []);

  // ===== FONCTIONS D'AUTHENTIFICATION =====

  const login = useCallback(async (credentials: LoginCredentials): Promise<boolean> => {
    setAuthState(prev => ({ ...prev, isLoading: true, error: null }));

    try {
      const response = await api.post('/auth/login', credentials);

      if (response.success && response.data) {
        const { user, token, refreshToken } = response.data;

        // Stocker les données d'auth
        setStoredToken(token);
        setStoredUser(user);
        if (refreshToken) {
          localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
        }

        // Configurer l'API client
        api.setAuthToken(token);

        setAuthState({
          user,
          token,
          isAuthenticated: true,
          isLoading: false,
          error: null
        });

        return true;
      } else {
        setAuthState(prev => ({
          ...prev,
          isLoading: false,
          error: response.error?.message || 'Erreur de connexion'
        }));
        return false;
      }
    } catch (error) {
      setAuthState(prev => ({
        ...prev,
        isLoading: false,
        error: 'Erreur de connexion'
      }));
      return false;
    }
  }, [api]);

  const register = useCallback(async (data: RegisterData): Promise<boolean> => {
    setAuthState(prev => ({ ...prev, isLoading: true, error: null }));

    try {
      const response = await api.post('/auth/register', data);

      if (response.success && response.data) {
        const { user, token, refreshToken } = response.data;

        // Stocker les données d'auth
        setStoredToken(token);
        setStoredUser(user);
        if (refreshToken) {
          localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
        }

        // Configurer l'API client
        api.setAuthToken(token);

        setAuthState({
          user,
          token,
          isAuthenticated: true,
          isLoading: false,
          error: null
        });

        return true;
      } else {
        setAuthState(prev => ({
          ...prev,
          isLoading: false,
          error: response.error?.message || 'Erreur lors de l\'inscription'
        }));
        return false;
      }
    } catch (error) {
      setAuthState(prev => ({
        ...prev,
        isLoading: false,
        error: 'Erreur lors de l\'inscription'
      }));
      return false;
    }
  }, [api]);

  const logout = useCallback(async (): Promise<void> => {
    setAuthState(prev => ({ ...prev, isLoading: true }));

    try {
      // Notifier le serveur de la déconnexion
      await api.post('/auth/logout');
    } catch {
      // Ignorer les erreurs de déconnexion côté serveur
    }

    // Nettoyer le storage local
    removeStoredToken();
    removeStoredUser();
    localStorage.removeItem(REFRESH_TOKEN_KEY);

    // Nettoyer l'API client
    api.clearAuthToken();

    setAuthState({
      user: null,
      token: null,
      isAuthenticated: false,
      isLoading: false,
      error: null
    });
  }, [api]);

  const refreshToken = useCallback(async (): Promise<boolean> => {
    const storedRefreshToken = localStorage.getItem(REFRESH_TOKEN_KEY);
    
    if (!storedRefreshToken) {
      await logout();
      return false;
    }

    try {
      const response = await api.post('/auth/refresh', {
        refreshToken: storedRefreshToken
      });

      if (response.success && response.data) {
        const { user, token, refreshToken: newRefreshToken } = response.data;

        // Mettre à jour le storage
        setStoredToken(token);
        setStoredUser(user);
        if (newRefreshToken) {
          localStorage.setItem(REFRESH_TOKEN_KEY, newRefreshToken);
        }

        // Configurer l'API client
        api.setAuthToken(token);

        setAuthState(prev => ({
          ...prev,
          user,
          token,
          isAuthenticated: true
        }));

        return true;
      } else {
        await logout();
        return false;
      }
    } catch {
      await logout();
      return false;
    }
  }, [api, logout]);

  const updateProfile = useCallback(async (updates: Partial<User>): Promise<boolean> => {
    if (!authState.user) return false;

    setAuthState(prev => ({ ...prev, isLoading: true, error: null }));

    try {
      const response = await api.patch('/auth/profile', updates);

      if (response.success && response.data) {
        const updatedUser = { ...authState.user, ...response.data };
        
        setStoredUser(updatedUser);
        setAuthState(prev => ({
          ...prev,
          user: updatedUser,
          isLoading: false
        }));

        return true;
      } else {
        setAuthState(prev => ({
          ...prev,
          isLoading: false,
          error: response.error?.message || 'Erreur lors de la mise à jour'
        }));
        return false;
      }
    } catch {
      setAuthState(prev => ({
        ...prev,
        isLoading: false,
        error: 'Erreur lors de la mise à jour'
      }));
      return false;
    }
  }, [api, authState.user]);

  const resetPassword = useCallback(async (email: string): Promise<boolean> => {
    setAuthState(prev => ({ ...prev, isLoading: true, error: null }));

    try {
      const response = await api.post('/auth/reset-password', { email });

      setAuthState(prev => ({
        ...prev,
        isLoading: false,
        error: response.success ? null : (response.error?.message || 'Erreur lors de la réinitialisation')
      }));

      return response.success;
    } catch {
      setAuthState(prev => ({
        ...prev,
        isLoading: false,
        error: 'Erreur lors de la réinitialisation'
      }));
      return false;
    }
  }, [api]);

  // ===== FONCTIONS D'AUTORISATION =====

  const hasRole = useCallback((role: UserRole): boolean => {
    return authState.user?.role === role;
  }, [authState.user]);

  const hasPermission = useCallback((permission: string): boolean => {
    if (!authState.user) return false;

    // Admin a toutes les permissions
    if (authState.user.role === USER_ROLES.ADMIN) return true;

    // Logique de permissions basée sur les rôles
    const rolePermissions: Record<UserRole, string[]> = {
      [USER_ROLES.ADMIN]: ['read', 'write', 'delete', 'admin'],
      [USER_ROLES.USER]: ['read', 'write'],
      [USER_ROLES.CHILD]: ['read'],
      [USER_ROLES.PARENT]: ['read', 'write', 'child_manage'],
      [USER_ROLES.GUEST]: ['read']
    };

    const userPermissions = rolePermissions[authState.user.role] || [];
    return userPermissions.includes(permission);
  }, [authState.user]);

  const clearError = useCallback(() => {
    setAuthState(prev => ({ ...prev, error: null }));
  }, []);

  return {
    user: authState.user,
    token: authState.token,
    isAuthenticated: authState.isAuthenticated,
    isLoading: authState.isLoading,
    error: authState.error,
    login,
    register,
    logout,
    refreshToken,
    updateProfile,
    resetPassword,
    hasRole,
    hasPermission,
    clearError
  };
}

// =============================================
// HOOKS UTILITAIRES
// =============================================

export function useRequireAuth(redirectTo?: string): AuthHookReturn {
  const auth = useAuth();

  useEffect(() => {
    if (!auth.isLoading && !auth.isAuthenticated) {
      if (redirectTo && typeof window !== 'undefined') {
        window.location.href = redirectTo;
      }
    }
  }, [auth.isAuthenticated, auth.isLoading, redirectTo]);

  return auth;
}

export function useRequireRole(requiredRole: UserRole, redirectTo?: string): AuthHookReturn {
  const auth = useAuth();

  useEffect(() => {
    if (!auth.isLoading && (!auth.isAuthenticated || !auth.hasRole(requiredRole))) {
      if (redirectTo && typeof window !== 'undefined') {
        window.location.href = redirectTo;
      }
    }
  }, [auth.isAuthenticated, auth.isLoading, auth.user?.role, requiredRole, redirectTo]);

  return auth;
}

export function useRequirePermission(permission: string, redirectTo?: string): AuthHookReturn {
  const auth = useAuth();

  useEffect(() => {
    if (!auth.isLoading && (!auth.isAuthenticated || !auth.hasPermission(permission))) {
      if (redirectTo && typeof window !== 'undefined') {
        window.location.href = redirectTo;
      }
    }
  }, [auth.isAuthenticated, auth.isLoading, permission, redirectTo]);

  return auth;
}

// =============================================
// CONTEXT PROVIDER (OPTIONNEL)
// =============================================

import { createContext, useContext } from 'react';

const AuthContext = createContext<AuthHookReturn | null>(null);

export function AuthProvider({ children, apiClient }: { 
  children: React.ReactNode;
  apiClient?: ApiClient;
}): JSX.Element {
  const auth = useAuth(apiClient);

  return (
    <AuthContext.Provider value={auth}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuthContext(): AuthHookReturn {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuthContext must be used within an AuthProvider');
  }
  return context;
}

// =============================================
// UTILITAIRES D'EXPORT
// =============================================

export function isValidUser(user: any): user is User {
  return (
    user &&
    typeof user.id === 'string' &&
    typeof user.email === 'string' &&
    typeof user.name === 'string' &&
    Object.values(USER_ROLES).includes(user.role)
  );
}

export function sanitizeUser(user: User): Omit<User, 'password'> {
  const { ...sanitized } = user;
  return sanitized;
}