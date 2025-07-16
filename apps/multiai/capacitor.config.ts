import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.multiapps.multiai',
  appName: '🤖 MultiAI Search',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#6b7280",
      showSpinner: true,
      spinnerColor: "#ffffff"
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#6b7280"
    },
    Haptics: {
      enabled: true
    }
  },
  ios: {
    contentInset: 'automatic',
    backgroundColor: '#6b7280'
  },
  android: {
    allowMixedContent: true,
    backgroundColor: '#6b7280'
  }
};

export default config;
