import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.math4kids.app',
  appName: 'math4kids',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  }
};

export default config;
