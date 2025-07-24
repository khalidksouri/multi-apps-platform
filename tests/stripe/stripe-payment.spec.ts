import { test, expect } from '@playwright/test'

test.describe('💳 Tests de Paiement Stripe', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/stripe-test')
  })

  test('Page de test Stripe se charge', async ({ page }) => {
    await expect(page.locator('h1')).toContainText('Test des Paiements')
    await expect(page.locator('text=Mode développement')).toBeVisible()
    console.log('✅ Page Stripe chargée')
  })

  test('Cartes de test sont affichées', async ({ page }) => {
    const cards = [
      '4242 4242 4242 4242', // Succès
      '4000 0000 0000 0002', // Déclinée
      '4000 0000 0000 9995', // Fonds insuffisants
      '4000 0000 0000 0069'  // Expirée
    ]
    
    for (const card of cards) {
      await expect(page.locator(`text=${card}`)).toBeVisible()
      console.log(`✅ Carte trouvée: ${card}`)
    }
  })

  test('Plans de test sont affichés', async ({ page }) => {
    await expect(page.locator('text=Plan Famille')).toBeVisible()
    await expect(page.locator('text=Plan Premium')).toBeVisible()
    await expect(page.locator('text=Plan École')).toBeVisible()
    console.log('✅ Tous les plans affichés')
  })

  test('Toggle mensuel/annuel fonctionne', async ({ page }) => {
    // Vérifier état initial
    await expect(page.locator('text=€6.99')).toBeVisible()
    
    // Passer en annuel
    await page.click('button:has-text("Annuel")')
    await expect(page.locator('text=€59.90')).toBeVisible()
    
    console.log('✅ Toggle mensuel/annuel fonctionne')
  })

  test('API de checkout répond', async ({ page }) => {
    const response = await page.request.get('/api/stripe/create-checkout-session')
    expect(response.status()).toBe(200)
    
    const data = await response.json()
    expect(data).toHaveProperty('status', 'OK')
    
    console.log('✅ API de checkout opérationnelle')
  })
})
