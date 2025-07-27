import { test, expect } from '@playwright/test'

test.describe('Math4Child - Interactions Complètes', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    await expect(page.locator('h1').first()).toContainText('Math pour enfants')
  })

  test('🌍 Sélecteur de langues interactif', async ({ page }) => {
    console.log('🌍 Test du sélecteur de langues...')
    
    // Ouvrir le dropdown
    await page.locator('button[data-testid="language-selector"]').click()
    await expect(page.locator('input[placeholder*="Rechercher"]')).toBeVisible()
    
    // Tester la recherche
    await page.fill('input[placeholder*="Rechercher"]', 'Eng')
    await expect(page.locator('text=English')).toBeVisible()
    
    // Sélectionner une langue
    await page.locator('text=English').click()
    await expect(page.locator('button:has-text("English")')).toBeVisible()
    
    // Vérifier que le dropdown se ferme
    await expect(page.locator('input[placeholder*="Rechercher"]')).toBeHidden()
  })

  test('🎮 Cartes fonctionnalités cliquables', async ({ page }) => {
    console.log('🎮 Test des cartes fonctionnalités...')
    
    const featureCards = page.locator('.feature-card')
    await expect(featureCards).toHaveCount(5)
    
    // Tester chaque carte avec gestion des dialogues
    for (let i = 0; i < 5; i++) {
      const card = featureCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Fonctionnalité:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('📊 Statistiques interactives', async ({ page }) => {
    console.log('📊 Test des statistiques...')
    
    const statCards = page.locator('.stat-card')
    await expect(statCards).toHaveCount(3)
    
    // Tester chaque statistique
    for (let i = 0; i < 3; i++) {
      const card = statCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Statistique:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('📱 Plateformes téléchargement', async ({ page }) => {
    console.log('📱 Test des plateformes...')
    
    const platformCards = page.locator('.platform-card')
    await expect(platformCards).toHaveCount(3)
    
    // Tester chaque plateforme
    for (let i = 0; i < 3; i++) {
      const card = platformCards.nth(i)
      
      // Configurer le gestionnaire de dialog avant le clic
      page.on('dialog', async dialog => {
        expect(dialog.message()).toContain('Téléchargement:')
        await dialog.accept()
      })
      
      await card.click()
      await page.waitForTimeout(300)
    }
  })

  test('💰 Modal Pricing Complet', async ({ page }) => {
    console.log('💰 Test du modal pricing...')
    
    // Ouvrir le modal
    await page.locator('button:has-text("Voir les prix")').click()
    await expect(page.locator('.pricing-modal')).toBeVisible()
    
    // Tester les périodes
    const periods = [
      { name: 'Mensuel', discount: '' },
      { name: 'Trimestriel', discount: '-10%' },
      { name: 'Annuel', discount: '-30%' }
    ]
    
    for (const period of periods) {
      await page.locator(`button:has-text("${period.name}")`).click()
      
      if (period.discount) {
        await expect(page.locator(`text=${period.discount}`)).toBeVisible()
      }
    }
    
    // Fermer le modal
    await page.locator('button:has-text("×")').click()
    await expect(page.locator('.pricing-modal')).toBeHidden()
  })

  test('📱 Test Responsive', async ({ page }) => {
    console.log('📱 Test responsive...')
    
    // Test mobile
    await page.setViewportSize({ width: 375, height: 667 })
    await page.reload()
    await page.waitForLoadState('networkidle')
    
    await expect(page.locator('h1').first()).toBeVisible()
    await expect(page.locator('.feature-card').first()).toBeVisible()
    
    // Remettre desktop
    await page.setViewportSize({ width: 1280, height: 720 })
  })
})

test('🎉 Validation Globale', async ({ page }) => {
  await page.goto('/')
  await page.waitForLoadState('networkidle')
  
  console.log('🚀 Validation globale...')
  
  // Vérifications critiques - CORRIGÉES selon le nouveau design
  await expect(page.locator('h1').first()).toContainText('Math pour enfants')
  await expect(page.locator('.feature-card')).toHaveCount(5)
  await expect(page.locator('.stat-card')).toHaveCount(3)
  await expect(page.locator('.platform-card')).toHaveCount(3)
  
  console.log('🎉 VALIDATION RÉUSSIE !') 
})
