import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#3B82F6',
      showSpinner: false
    },
    StatusBar: {
      style: 'default',
      backgroundColor: '#3B82F6'
    },
    Keyboard: {
      resize: 'body',
      style: 'dark'
    }
  },
  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: process.env.NODE_ENV === 'development'
  },
  ios: {
    contentInset: 'automatic',
    scrollEnabled: true,
    webContentsDebuggingEnabled: process.env.NODE_ENV === 'development'
    // FIX: buildOptions supprimé - n'existe pas dans CapacitorConfig
  }
};

export default config;
