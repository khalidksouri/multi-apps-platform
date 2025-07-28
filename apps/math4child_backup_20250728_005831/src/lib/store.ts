import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  email: string;
  name: string;
  progress: {
    currentLevel: string;
    correctAnswers: Record<string, number>;
    unlockedLevels: string[];
    totalQuestions: number;
    freeQuestionsUsed: number;
  };
  subscription: { type: string; devices: string[]; };
}

interface Exercise {
  type: string;
  level: string;
  question: { num1: number; num2: number; operator: string; correctAnswer: number; };
  difficulty: number;
  metadata: { estimatedTime: number; hints: string[]; explanation: string; };
}

interface AppState {
  user: User | null;
  token: string | null;
  currentExercises: Exercise[];
  currentExerciseIndex: number;
  sessionId: string | null;
  currentLanguage: string;
  isLoading: boolean;
  error: string | null;
  
  setUser: (user: User) => void;
  setToken: (token: string) => void;
  logout: () => void;
  setCurrentExercises: (exercises: Exercise[]) => void;
  nextExercise: () => void;
  setLanguage: (language: string) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
}

export const useAppStore = create<AppState>()(
  persist(
    (set, get) => ({
      user: null, token: null, currentExercises: [], currentExerciseIndex: 0,
      sessionId: null, currentLanguage: 'fr', isLoading: false, error: null,

      setUser: (user) => set({ user }),
      setToken: (token) => set({ token }),
      logout: () => set({ user: null, token: null, currentExercises: [], currentExerciseIndex: 0, sessionId: null }),
      setCurrentExercises: (exercises) => set({ currentExercises: exercises, currentExerciseIndex: 0 }),
      nextExercise: () => {
        const { currentExerciseIndex, currentExercises } = get();
        if (currentExerciseIndex < currentExercises.length - 1) {
          set({ currentExerciseIndex: currentExerciseIndex + 1 });
        }
      },
      setLanguage: (language) => set({ currentLanguage: language }),
      setLoading: (loading) => set({ isLoading: loading }),
      setError: (error) => set({ error })
    }),
    { name: 'math4child-storage', partialize: (state) => ({ token: state.token, currentLanguage: state.currentLanguage, user: state.user }) }
  )
);
