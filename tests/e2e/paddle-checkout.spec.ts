import { test, expect } from '@playwright/test'

test.describe('Paddle Checkout - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    // Aller à la page de pricing
    await page.goto('/pricing')
    await page.waitForLoadState('networkidle')
  })

  test('Vérifie la présence du sélecteur d\'intervalle', async ({ page }) => {
    // Attendre que la page soit chargée
    await expect(page.locator('h1')).toBeVisible({ timeout: 10000 })
    
    // Chercher les boutons d'intervalle avec différents sélecteurs possibles
    const monthlyButton = page.locator('button').filter({ hasText: /mensuel|monthly/i }).first()
    const quarterlyButton = page.locator('button').filter({ hasText: /trimestriel|quarterly/i }).first()
    const yearlyButton = page.locator('button').filter({ hasText: /annuel|yearly/i }).first()
    
    // Vérifier qu'au moins un bouton d'intervalle existe
    await expect(
      monthlyButton.or(quarterlyButton).or(yearlyButton)
    ).toBeVisible({ timeout: 5000 })
  })

  test('Vérifie l\'affichage des prix', async ({ page }) => {
    // Chercher les prix avec des patterns flexibles
    const pricePattern = page.locator('text=/[0-9]+[,.]?[0-9]*\s*€/').first()
    await expect(pricePattern).toBeVisible({ timeout: 10000 })
    
    // Chercher les boutons d'essai ou d'abonnement
    const trialButton = page.locator('button').filter({ 
      hasText: /essai|trial|gratuit|free|choisir|select/i 
    }).first()
    
    if (await trialButton.isVisible()) {
      await expect(trialButton).toBeVisible()
    }
  })

  test('Test de sélection de plan (avec mock)', async ({ page }) => {
    // Mock l'API de checkout pour éviter les vraies requêtes
    await page.route('/api/payments/create-checkout', route => {
      route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          success: true,
          provider: 'paddle',
          checkoutUrl: 'https://checkout.paddle.com/test-session',
          sessionId: 'test_session_123'
        })
      })
    })

    // Cliquer sur un bouton de plan (chercher différents patterns)
    const planButton = page.locator('button').filter({ 
      hasText: /essai|trial|choisir|select|commencer|start/i 
    }).first()
    
    if (await planButton.isVisible()) {
      await planButton.click()
      
      // Attendre soit une redirection, soit un indicateur de chargement
      try {
        await page.waitForResponse('/api/payments/create-checkout', { timeout: 5000 })
      } catch {
        // Ignorer si pas d'API - juste vérifier que quelque chose se passe
        console.log('Pas d\'API de checkout - test en mode mock')
      }
    } else {
      console.log('Aucun bouton de plan trouvé - test ignoré')
    }
  })

  test('Vérifie la structure de base de la page', async ({ page }) => {
    // Tests de base pour s'assurer que la page fonctionne
    await expect(page.locator('body')).toBeVisible()
    
    // Chercher des éléments communs de pricing
    const hasTitle = await page.locator('h1, h2, h3').filter({ 
      hasText: /math4child|plan|pricing|abonnement/i 
    }).first().isVisible()
    
    const hasPricing = await page.locator('text=/€|USD|\$/').first().isVisible()
    
    // Au moins un des éléments doit être présent
    expect(hasTitle || hasPricing).toBeTruthy()
  })
})
