import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  bundledWebRuntime: false,
  
  server: {
    androidScheme: 'https',
    iosScheme: 'https',
    hostname: 'math4child.app',
    cleartext: false,
  },

  plugins: {
    SplashScreen: {
      launchShowDuration: 2000,
      launchAutoHide: true,
      backgroundColor: '#667eea',
      androidSplashResourceName: 'splash',
      androidScaleType: 'CENTER_CROP',
      showSpinner: true,
      androidSpinnerStyle: 'large',
      iosSpinnerStyle: 'small',
      spinnerColor: '#ffffff'
    },
    
    StatusBar: {
      backgroundColor: '#667eea',
      style: 'light',
      overlay: false
    },
    
    App: {
      name: 'Math4Child',
      description: 'Application éducative de mathématiques - GOTEST',
      version: '4.0.0'
    },
    
    Keyboard: {
      resize: 'body',
      style: 'dark',
      resizeOnFullScreen: true
    },
    
    Device: {
      name: 'Math4Child Device Info'
    },
    
    Haptics: {},
    
    LocalNotifications: {
      smallIcon: 'ic_stat_icon_config_sample',
      iconColor: '#667eea'
    }
  },

  android: {
    allowMixedContent: true,
    captureInput: true,
    webContentsDebuggingEnabled: false, // Production
    loggingBehavior: 'production',
    minWebViewVersion: 60,
    buildOptions: {
      keystorePath: '',
      keystorePassword: '',
      keystoreAlias: '',
      keystoreAliasPassword: '',
      releaseType: 'APK',
      signingType: 'apksigner'
    }
  },

  ios: {
    scheme: 'Math4Child',
    contentInset: 'automatic',
    scrollEnabled: true,
    backgroundColor: '#667eea',
    buildOptions: {
      developmentTeam: '',
      packageType: 'development',
      codeSignIdentity: 'iPhone Developer'
    }
  }
};

export default config;
