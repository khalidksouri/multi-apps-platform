import { test as setup, expect } from '@playwright/test'
import { exec } from 'child_process'
import { promisify } from 'util'

const execAsync = promisify(exec)

setup('Setup Android APK Environment', async () => {
  console.log('🤖 Configuration environnement Android APK...')

  // 1. Vérifier Android SDK
  try {
    await execAsync('adb version')
    console.log('✅ ADB disponible')
  } catch (error) {
    throw new Error('❌ Android SDK non installé. Installez Android Studio.')
  }

  // 2. Vérifier/lancer émulateur
  try {
    const { stdout } = await execAsync('adb devices')
    if (!stdout.includes('device')) {
      console.log('🚀 Lancement émulateur Android...')
      
      // Lancer émulateur en arrière-plan
      exec('emulator -avd Pixel_7_API_34 -no-snapshot-load &')
      
      // Attendre démarrage émulateur
      let attempts = 0
      while (attempts < 40) {
        try {
          const { stdout: devices } = await execAsync('adb devices')
          if (devices.includes('device')) {
            console.log('✅ Émulateur Android prêt')
            break
          }
        } catch {}
        
        await new Promise(resolve => setTimeout(resolve, 5000))
        attempts++
      }
      
      if (attempts >= 40) {
        throw new Error('❌ Timeout: Émulateur Android non démarré')
      }
    } else {
      console.log('✅ Device Android déjà connecté')
    }
  } catch (error) {
    console.error('❌ Erreur émulateur Android:', error)
    throw error
  }

  // 3. Build et installer APK
  try {
    console.log('🔨 Build APK Math4Child...')
    await execAsync('npm run build:android:debug')
    
    console.log('📲 Installation APK sur émulateur...')
    await execAsync('adb install -r android/app/build/outputs/apk/debug/app-debug.apk')
    
    console.log('✅ APK installé avec succès')
  } catch (error) {
    console.error('❌ Erreur build/installation APK:', error)
    throw error
  }

  // 4. Lancer l'application
  try {
    console.log('🚀 Lancement Math4Child sur Android...')
    await execAsync('adb shell am start -n com.gotest.math4child/.MainActivity')
    
    // Attendre chargement app
    await new Promise(resolve => setTimeout(resolve, 15000))
    
    console.log('✅ Math4Child lancé sur Android')
  } catch (error) {
    console.error('❌ Erreur lancement app:', error)
    throw error
  }
})
