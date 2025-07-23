import type { CapacitorConfig } from '@capacitor/cli'

const config: CapacitorConfig = {
  appId: 'com.math4child.app',
  appName: 'Math4Child',
  webDir: 'out',
  server: { androidScheme: 'https' },
  plugins: {
    SplashScreen: { launchShowDuration: 2000, backgroundColor: '#667eea', showSpinner: false },
    StatusBar: { style: 'dark', backgroundColor: '#667eea' }
  }
}

export default config
