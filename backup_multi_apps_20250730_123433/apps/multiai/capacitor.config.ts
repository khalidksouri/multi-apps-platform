import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.multiai',
  appName: 'Multiai',
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
