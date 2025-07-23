import { test, expect } from '@playwright/test'

/**
 * Tests critiques Stripe pour validation Netlify
 * Seulement les fonctionnalités essentielles
 */
test.describe('Tests Critiques Stripe - Netlify', () => {
  
  test('Page de test Stripe se charge correctement', async ({ page }) => {
    await page.goto('/stripe-test')
    
    await expect(page.locator('h1')).toContainText('Test des Paiements Math4Child')
    await expect(page.locator('[data-testid="plan-family"]')).toBeVisible()
    await expect(page.locator('text=4242 4242 4242 4242')).toBeVisible()
  })

  test('Toggle prix fonctionne', async ({ page }) => {
    await page.goto('/stripe-test')
    
    await page.locator('[data-testid="billing-toggle"]').click()
    await expect(page.locator('text=€59.90/an')).toBeVisible()
  })

  test('API checkout répond (mock)', async ({ page }) => {
    await page.route('/api/stripe/create-checkout-session', route => {
      route.fulfill({
        status: 200,
        body: JSON.stringify({ sessionId: 'cs_test_netlify', url: 'https://checkout.stripe.com/test' })
      })
    })
    
    await page.goto('/stripe-test')
    
    const response = await page.request.post('/api/stripe/create-checkout-session', {
      data: { priceId: 'price_test', mode: 'subscription' }
    })
    
    expect(response.status()).toBe(200)
  })
})
