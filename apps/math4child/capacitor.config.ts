/// <reference types="@capacitor/cli" />

interface CapacitorConfig {
  appId: string
  appName: string
  webDir: string
  bundledWebRuntime?: boolean
  server?: {
    androidScheme?: string
  }
  plugins?: {
    SplashScreen?: {
      launchShowDuration?: number
      backgroundColor?: string
      showSpinner?: boolean
    }
    StatusBar?: {
      style?: string
      backgroundColor?: string
    }
  }
}

const config: CapacitorConfig = {
  appId: 'com.math4child.app',
  appName: 'Math4Child',
  webDir: 'out',
  bundledWebRuntime: false,
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      backgroundColor: '#667eea',
      showSpinner: false
    },
    StatusBar: {
      style: 'dark',
      backgroundColor: '#667eea'
    }
  }
}

export default config
