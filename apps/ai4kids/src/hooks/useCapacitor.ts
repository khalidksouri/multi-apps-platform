import { useEffect, useState } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { SplashScreen } from '@capacitor/splash-screen';

export const useCapacitor = () => {
  const [isNative, setIsNative] = useState(false);
  const [platform, setPlatform] = useState<string>('web');

  useEffect(() => {
    const setupCapacitor = async () => {
      const native = Capacitor.isNativePlatform();
      setIsNative(native);
      setPlatform(Capacitor.getPlatform());

      if (native) {
        // Configuration de la barre de statut
        await StatusBar.setStyle({ style: Style.Dark });
        await StatusBar.setBackgroundColor({ color: '#4ECDC4' });
        
        // Masquer le splash screen
        await SplashScreen.hide();
      }
    };

    setupCapacitor();
  }, []);

  return { isNative, platform };
};
