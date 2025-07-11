export interface Child {
  id: string;
  name: string;
  age: number;
  parentEmail: string;
  level: number;
  totalStars: number;
  completedActivities: number;
  preferences: ChildPreferences;
  safety: SafetySettings;
}

export interface ChildPreferences {
  topics: string[];
  difficulty: DifficultyLevel;
  sessionDuration: number;
  rewardFrequency: RewardFrequency;
}

export type DifficultyLevel = 'beginner' | 'intermediate' | 'advanced';
export type RewardFrequency = 'frequent' | 'moderate' | 'rare';

export interface SafetySettings {
  parentalSupervision: boolean;
  contentFiltering: boolean;
  timeRestrictions: {
    dailyLimit: number;
    allowedHours: { start: string; end: string; };
  };
}

export interface ChatMessage {
  id: string;
  content: string;
  sender: 'child' | 'roby';
  timestamp: Date;
  flagged: boolean;
  parentNotified: boolean;
}
