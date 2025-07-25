import { test as setup, expect } from '@playwright/test'
import { exec } from 'child_process'
import { promisify } from 'util'

const execAsync = promisify(exec)

setup('Setup iOS App Environment', async () => {
  console.log('🍎 Configuration environnement iOS App...')

  // Vérifier macOS
  if (process.platform !== 'darwin') {
    throw new Error('❌ Tests iOS disponibles uniquement sur macOS')
  }

  // 1. Vérifier Xcode
  try {
    await execAsync('xcrun xcodebuild -version')
    console.log('✅ Xcode disponible')
  } catch (error) {
    throw new Error('❌ Xcode non installé. Téléchargez depuis App Store.')
  }

  // 2. Vérifier simulateurs
  try {
    const { stdout } = await execAsync('xcrun simctl list devices available')
    
    if (!stdout.includes('iPhone')) {
      throw new Error('❌ Aucun simulateur iPhone disponible')
    }
    
    console.log('✅ Simulateurs iOS disponibles')
  } catch (error) {
    console.error('❌ Erreur simulateurs iOS:', error)
    throw error
  }

  // 3. Lancer simulateur
  try {
    console.log('🚀 Lancement simulateur iPhone...')
    
    await execAsync('xcrun simctl boot "iPhone 14" || true')
    await execAsync('open -a Simulator')
    
    // Attendre simulateur prêt
    await new Promise(resolve => setTimeout(resolve, 20000))
    
    console.log('✅ Simulateur iPhone prêt')
  } catch (error) {
    console.error('❌ Erreur simulateur iPhone:', error)
    throw error
  }

  // 4. Build et installer app
  try {
    console.log('🔨 Build app iOS Math4Child...')
    await execAsync('npm run build:ios:debug')
    
    console.log('📲 Installation app sur simulateur...')
    await execAsync('npx cap run ios --target="iPhone 14"')
    
    console.log('✅ App iOS installée avec succès')
  } catch (error) {
    console.error('❌ Erreur build/installation iOS:', error)
    throw error
  }

  // 5. Attendre lancement app
  try {
    console.log('🚀 Lancement Math4Child sur iOS...')
    
    // L'app se lance automatiquement après installation Capacitor
    await new Promise(resolve => setTimeout(resolve, 15000))
    
    console.log('✅ Math4Child lancé sur iOS')
  } catch (error) {
    console.error('❌ Erreur lancement app iOS:', error)
    throw error
  }
})
