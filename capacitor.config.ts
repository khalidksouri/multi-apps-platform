import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.math4child.app',
  appName: 'Math4Child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: "#3b82f6",
      showSpinner: false
    },
    StatusBar: {
      style: "dark",
      backgroundColor: "#3b82f6"
    }
  }
};

export default config;
