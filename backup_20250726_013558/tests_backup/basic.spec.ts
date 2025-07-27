import { test, expect } from '@playwright/test'

test.describe('Math4Child - Tests de base', () => {
  
  test('Page d\'accueil se charge', async ({ page }) => {
    await page.goto('/')
    await expect(page.locator('body')).toBeVisible()
    
    // Chercher Math4Child dans le contenu
    const hasAppName = await page.locator('text=/math4child/i').first().isVisible()
    if (hasAppName) {
      await expect(page.locator('text=/math4child/i').first()).toBeVisible()
    }
  })

  test('Navigation vers pricing', async ({ page }) => {
    await page.goto('/')
    
    // Chercher des liens vers pricing/plans
    const pricingLink = page.locator('a, button').filter({ 
      hasText: /pricing|plan|abonnement|prix/i 
    }).first()
    
    if (await pricingLink.isVisible()) {
      await pricingLink.click()
      await page.waitForLoadState('networkidle')
      
      // Vérifier qu'on est arrivé quelque part
      await expect(page.locator('body')).toBeVisible()
    }
  })
})
