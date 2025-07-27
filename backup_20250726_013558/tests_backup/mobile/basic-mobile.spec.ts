import { test, expect } from '@playwright/test'

test.describe('Math4Child - Tests Mobiles de Base', () => {
  
  test('Interface mobile responsive', async ({ page }) => {
    await page.goto('/')
    
    // Vérifier chargement mobile
    await expect(page.locator('[data-testid="app-title"]')).toBeVisible({ timeout: 30000 })
    
    // Test navigation tactile
    const startButton = page.locator('[data-testid="start-game-button"]')
    if (await startButton.isVisible()) {
      await startButton.tap()
      await expect(page.locator('[data-testid="math-question"]')).toBeVisible()
    }
    
    // Screenshot mobile
    await page.screenshot({ path: 'test-results/mobile-interface.png', fullPage: true })
  })
  
  test('Sélecteur de langue mobile', async ({ page }) => {
    await page.goto('/')
    
    // Ouvrir dropdown langue
    const languageButton = page.locator('[data-testid="language-dropdown-button"]')
    await expect(languageButton).toBeVisible()
    await languageButton.tap()
    
    // Vérifier menu déroulant
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).toBeVisible()
    
    // Test recherche de langue
    const searchInput = page.locator('[data-testid="language-search-input"]')
    if (await searchInput.isVisible()) {
      await searchInput.fill('Fra')
      await page.waitForTimeout(500)
      
      // Vérifier filtrage
      const options = page.locator('[role="option"]')
      await expect(options).toHaveCount(1)
    }
  })
  
  test('Performance mobile', async ({ page }) => {
    const startTime = Date.now()
    
    await page.goto('/')
    await page.waitForSelector('[data-testid="app-title"]')
    
    const loadTime = Date.now() - startTime
    
    // Performance mobile acceptable (< 4 secondes)
    expect(loadTime).toBeLessThan(4000)
    
    console.log(`📱 Temps de chargement mobile: ${loadTime}ms`)
  })
})
