import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.multiapps.budgetcron',
  appName: '💰 BudgetCron',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#3b82f6",
      showSpinner: true,
      spinnerColor: "#ffffff"
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#3b82f6"
    },
    Haptics: {
      enabled: true
    }
  },
  ios: {
    contentInset: 'automatic',
    backgroundColor: '#3b82f6'
  },
  android: {
    allowMixedContent: true,
    backgroundColor: '#3b82f6'
  }
};

export default config;
