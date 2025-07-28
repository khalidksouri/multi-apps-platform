// =============================================================================
// TYPES ET INTERFACES POUR LE SYSTÈME MULTI-DEVICES
// =============================================================================

export type DeviceType = 'web' | 'android' | 'ios';
export type SubscriptionType = 'free' | 'monthly' | 'quarterly' | 'yearly';

export interface Device {
  id: string;
  type: DeviceType;
  name: string;
  icon: string;
  platform: string;
}

export interface DeviceSubscription {
  deviceId: string;
  deviceType: DeviceType;
  subscriptionType: SubscriptionType;
  price: number;
  originalPrice: number;
  discount: number;
  startDate: Date;
  endDate: Date;
  isActive: boolean;
}

export interface UserProgress {
  totalCorrectAnswers: number;
  completedLevels: number[]; // Niveaux complétés (accès permanent)
  unlockedLevels: number[]; // Niveaux débloqués (incluant les complétés)
  currentLevel: number;
  levelProgress: { [levelId: number]: number }; // Progression par niveau (0-100)
}

export interface MultiDeviceUser {
  id: string;
  name: string;
  email: string;
  progress: UserProgress;
  devices: Device[];
  subscriptions: DeviceSubscription[];
  createdAt: Date;
  lastActiveDevice: string;
}

// =============================================================================
// DONNÉES DES DEVICES DISPONIBLES
// =============================================================================

export const AVAILABLE_DEVICES: Device[] = [
  {
    id: 'web',
    type: 'web',
    name: 'Web (Desktop)',
    icon: '💻',
    platform: 'Browser'
  },
  {
    id: 'android',
    type: 'android', 
    name: 'Android',
    icon: '📱',
    platform: 'Google Play'
  },
  {
    id: 'ios',
    type: 'ios',
    name: 'iOS',
    icon: '📱',
    platform: 'App Store'
  }
];

// =============================================================================
// TARIFICATION AVEC RÉDUCTIONS MULTI-DEVICES
// =============================================================================

export interface SubscriptionPlan {
  type: SubscriptionType;
  name: string;
  basePrice: number;
  duration: number; // en mois
  features: string[];
  popular?: boolean;
  badge?: string;
  color: string;
}

export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    type: 'free',
    name: 'Gratuit',
    basePrice: 0,
    duration: 0,
    features: ['50 questions', 'Accès limité aux niveaux', 'Support email'],
    color: 'gray'
  },
  {
    type: 'monthly',
    name: 'Mensuel',
    basePrice: 9.99,
    duration: 1,
    features: ['Questions illimitées', 'Tous les niveaux', 'Support prioritaire', 'Statistiques'],
    popular: true,
    color: 'blue'
  },
  {
    type: 'quarterly',
    name: 'Trimestriel',
    basePrice: 26.97,
    duration: 3,
    features: ['Tout du mensuel', '10% d\'économies', 'Support premium'],
    badge: '-10% 💰',
    color: 'orange'
  },
  {
    type: 'yearly',
    name: 'Annuel',
    basePrice: 83.93,
    duration: 12,
    features: ['Tout du mensuel', '30% d\'économies', 'Support VIP', 'Beta features'],
    badge: '-30% 🔥',
    color: 'green'
  }
];

// =============================================================================
// LOGIQUE DE CALCUL DES RÉDUCTIONS MULTI-DEVICES
// =============================================================================

export const calculateDeviceDiscount = (existingSubscriptions: DeviceSubscription[]): number => {
  const activeSubscriptions = existingSubscriptions.filter(sub => sub.isActive);
  
  switch (activeSubscriptions.length) {
    case 0:
      return 0; // Prix normal pour le premier device
    case 1:
      return 50; // 50% de réduction pour le deuxième device
    case 2:
      return 75; // 75% de réduction pour le troisième device
    default:
      return 75; // Maximum 75% de réduction
  }
};

export const calculateSubscriptionPrice = (
  plan: SubscriptionPlan,
  existingSubscriptions: DeviceSubscription[]
): { price: number; originalPrice: number; discount: number } => {
  const originalPrice = plan.basePrice;
  const discount = calculateDeviceDiscount(existingSubscriptions);
  const price = originalPrice * (1 - discount / 100);
  
  return {
    price: Math.round(price * 100) / 100,
    originalPrice,
    discount
  };
};

// =============================================================================
// GESTION DES NIVEAUX ET PROGRESSION
// =============================================================================

export const canAccessLevel = (levelId: number, userProgress: UserProgress): boolean => {
  // Toujours accès aux niveaux complétés
  if (userProgress.completedLevels.includes(levelId)) {
    return true;
  }
  
  // Accès aux niveaux débloqués
  return userProgress.unlockedLevels.includes(levelId);
};

export const markLevelCompleted = (levelId: number, userProgress: UserProgress): UserProgress => {
  const newProgress = { ...userProgress };
  
  // Marquer le niveau comme complété
  if (!newProgress.completedLevels.includes(levelId)) {
    newProgress.completedLevels.push(levelId);
  }
  
  // Assurer que le niveau suivant est débloqué
  const nextLevel = levelId + 1;
  if (nextLevel <= 5 && !newProgress.unlockedLevels.includes(nextLevel)) {
    newProgress.unlockedLevels.push(nextLevel);
  }
  
  // Mettre à jour le niveau actuel
  newProgress.currentLevel = Math.max(newProgress.currentLevel, levelId);
  
  return newProgress;
};

// =============================================================================
// UTILITAIRES POUR LA GESTION DES ABONNEMENTS
// =============================================================================

export const getActiveSubscriptions = (user: MultiDeviceUser): DeviceSubscription[] => {
  const now = new Date();
  return user.subscriptions.filter(sub => 
    sub.isActive && sub.endDate > now
  );
};

export const getSubscriptionByDevice = (
  user: MultiDeviceUser, 
  deviceType: DeviceType
): DeviceSubscription | null => {
  const activeSubscriptions = getActiveSubscriptions(user);
  return activeSubscriptions.find(sub => sub.deviceType === deviceType) || null;
};

export const hasActiveSubscription = (user: MultiDeviceUser, deviceType?: DeviceType): boolean => {
  const activeSubscriptions = getActiveSubscriptions(user);
  
  if (deviceType) {
    return activeSubscriptions.some(sub => sub.deviceType === deviceType);
  }
  
  return activeSubscriptions.length > 0;
};

export const getDeviceSubscriptionSummary = (user: MultiDeviceUser) => {
  const activeSubscriptions = getActiveSubscriptions(user);
  const summary = {
    totalDevices: activeSubscriptions.length,
    devices: activeSubscriptions.map(sub => sub.deviceType),
    totalMonthlyValue: activeSubscriptions.reduce((sum, sub) => {
      const monthlyValue = sub.subscriptionType === 'yearly' ? sub.originalPrice / 12 :
                          sub.subscriptionType === 'quarterly' ? sub.originalPrice / 3 :
                          sub.originalPrice;
      return sum + monthlyValue;
    }, 0),
    totalSavings: activeSubscriptions.reduce((sum, sub) => 
      sum + (sub.originalPrice - sub.price), 0
    )
  };
  
  return summary;
};

// =============================================================================
// SIMULATION D'API POUR LA GESTION DES UTILISATEURS
// =============================================================================

export class DeviceSubscriptionManager {
  private users: Map<string, MultiDeviceUser> = new Map();

  createUser(name: string, email: string): MultiDeviceUser {
    const user: MultiDeviceUser = {
      id: Date.now().toString(),
      name,
      email,
      progress: {
        totalCorrectAnswers: 0,
        completedLevels: [],
        unlockedLevels: [1], // Premier niveau débloqué par défaut
        currentLevel: 1,
        levelProgress: { 1: 0 }
      },
      devices: [],
      subscriptions: [],
      createdAt: new Date(),
      lastActiveDevice: 'web'
    };

    this.users.set(user.id, user);
    return user;
  }

  getUser(userId: string): MultiDeviceUser | null {
    return this.users.get(userId) || null;
  }

  updateUserProgress(userId: string, progress: UserProgress): boolean {
    const user = this.users.get(userId);
    if (!user) return false;

    user.progress = progress;
    this.users.set(userId, user);
    return true;
  }

  addDeviceSubscription(
    userId: string,
    deviceType: DeviceType,
    subscriptionType: SubscriptionType
  ): DeviceSubscription | null {
    const user = this.users.get(userId);
    if (!user) return null;

    const plan = SUBSCRIPTION_PLANS.find(p => p.type === subscriptionType);
    if (!plan) return null;

    const pricing = calculateSubscriptionPrice(plan, user.subscriptions);
    const startDate = new Date();
    const endDate = new Date();
    endDate.setMonth(endDate.getMonth() + plan.duration);

    const subscription: DeviceSubscription = {
      deviceId: deviceType,
      deviceType,
      subscriptionType,
      price: pricing.price,
      originalPrice: pricing.originalPrice,
      discount: pricing.discount,
      startDate,
      endDate,
      isActive: true
    };

    user.subscriptions.push(subscription);
    
    // Ajouter le device s'il n'existe pas
    if (!user.devices.find(d => d.type === deviceType)) {
      const device = AVAILABLE_DEVICES.find(d => d.type === deviceType);
      if (device) {
        user.devices.push(device);
      }
    }

    this.users.set(userId, user);
    return subscription;
  }

  getDeviceOptions(userId: string) {
    const user = this.users.get(userId);
    if (!user) return [];

    const activeSubscriptions = getActiveSubscriptions(user);
    const subscribedDevices = activeSubscriptions.map(sub => sub.deviceType);

    return AVAILABLE_DEVICES.map(device => ({
      ...device,
      isSubscribed: subscribedDevices.includes(device.type),
      subscription: activeSubscriptions.find(sub => sub.deviceType === device.type),
      pricing: subscribedDevices.includes(device.type) ? null : 
        SUBSCRIPTION_PLANS.map(plan => ({
          ...plan,
          ...calculateSubscriptionPrice(plan, user.subscriptions)
        }))
    }));
  }
}

// Instance globale (en production, utiliser un state manager)
export const deviceManager = new DeviceSubscriptionManager();
