import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#667eea",
      showSpinner: true,
      spinnerColor: "#ffffff"
    }
  }
};

export default config;
