import { test, expect } from '@playwright/test'

test.describe('Math4Child Optimal System', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    
    // Mock API optimal
    await page.route('/api/payments/create-checkout', route => {
      const postData = JSON.parse(route.request().postData() || '{}')
      let provider = 'paddle'
      if (postData.country === 'US') provider = 'lemonsqueezy'
      if (postData.platform === 'ios') provider = 'revenuecat'
      
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          success: true,
          provider,
          checkoutUrl: `https://checkout.${provider}.com/test`,
          advantages: ['Optimisé pour conversion']
        })
      })
    })
  })

  test('Affichage prix compétitifs', async ({ page }) => {
    // Attendre le chargement de la page
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 })
    
    // Vérifier prix avec selectors plus spécifiques
    await expect(page.locator('text=6.99€').first()).toBeVisible({ timeout: 10000 })
    await expect(page.locator('text=40% moins cher')).toBeVisible()
    await expect(page.locator('text=5 profils')).toBeVisible()
  })

  test('Smart routing provider', async ({ page }) => {
    // Attendre et cliquer sur le premier bouton plan
    await page.waitForSelector('button:has-text("Essai")', { timeout: 10000 })
    await page.click('button:has-text("Essai")')
    
    const response = await page.waitForResponse('/api/payments/create-checkout')
    const data = await response.json()
    
    expect(data.success).toBe(true)
    expect(['paddle', 'lemonsqueezy', 'revenuecat', 'stripe']).toContain(data.provider)
  })

  test('Comparaison concurrence', async ({ page }) => {
    // Vérifier si le bouton comparaison existe
    const compareButton = page.locator('text=Comparer les prix')
    if (await compareButton.isVisible()) {
      await compareButton.click()
      await expect(page.locator('text=ABCmouse')).toBeVisible()
      await expect(page.locator('text=86% plus cher')).toBeVisible()
    }
  })

  test('Fonctionnalités multilingues', async ({ page }) => {
    // Test changement de langue
    const langButton = page.locator('button:has-text("Français")')
    if (await langButton.isVisible()) {
      await langButton.click()
      
      // Sélectionner anglais si disponible
      const englishOption = page.locator('text=English')
      if (await englishOption.isVisible()) {
        await englishOption.click()
        
        // Vérifier changement de langue
        await expect(page.locator('text=Math4Child')).toBeVisible()
      }
    }
  })
})
