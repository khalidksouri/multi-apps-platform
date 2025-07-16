import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.multiapps.ai4kids',
  appName: '🎨 AI4Kids',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#ec4899",
      showSpinner: true,
      spinnerColor: "#ffffff"
    },
    StatusBar: {
      style: 'light',
      backgroundColor: "#ec4899"
    },
    Haptics: {
      enabled: true
    }
  },
  ios: {
    contentInset: 'automatic',
    backgroundColor: '#ec4899'
  },
  android: {
    allowMixedContent: true,
    backgroundColor: '#ec4899'
  }
};

export default config;
