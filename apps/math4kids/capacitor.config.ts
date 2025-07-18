import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.multiapps.math4kids',
  appName: '🧮 Math4Kids Enhanced',
  webDir: 'dist',
  
  server: {
    androidScheme: 'https',
    iosScheme: 'https'
  },

  plugins: {
    SplashScreen: {
      launchShowDuration: 3000,
      launchAutoHide: true,
      backgroundColor: "#8b5cf6",
      showSpinner: true,
      spinnerColor: "#ffffff"
    },
    
    StatusBar: {
      style: 'light',
      backgroundColor: "#8b5cf6"
    },
    
    Haptics: {
      enabled: true
    },
    
    Keyboard: {
      resize: 'body',
      style: 'dark'
    }
  },

  ios: {
    contentInset: 'automatic',
    backgroundColor: '#8b5cf6'
  },

  android: {
    backgroundColor: '#8b5cf6',
    allowMixedContent: true
  }
};

export default config;
