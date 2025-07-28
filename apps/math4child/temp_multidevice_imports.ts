import {
  DeviceSubscriptionManager,
  deviceManager,
  AVAILABLE_DEVICES,
  SUBSCRIPTION_PLANS,
  calculateSubscriptionPrice,
  getActiveSubscriptions,
  canAccessLevel,
  markLevelCompleted,
  type MultiDeviceUser,
  type DeviceSubscription,
  type DeviceType,
  type UserProgress
} from '../lib/devices';
