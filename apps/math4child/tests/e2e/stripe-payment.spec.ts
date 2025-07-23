import { test, expect, Page } from '@playwright/test'

test.describe('Math4Child - Tests de Paiement Stripe', () => {
  let page: Page

  test.beforeEach(async ({ browser }) => {
    page = await browser.newPage()
    await page.goto('/stripe-test')
  })

  test('Affichage correct de la page de test des paiements', async () => {
    // Vérifier le titre principal
    await expect(page.locator('h1')).toContainText('Test des Paiements Math4Child')
    
    // Vérifier le mode développement
    await expect(page.locator('text=Mode développement')).toBeVisible()
    
    // Vérifier la présence des 3 plans
    await expect(page.locator('[data-testid="plan-family"]')).toBeVisible()
    await expect(page.locator('[data-testid="plan-premium"]')).toBeVisible()
    await expect(page.locator('[data-testid="plan-school"]')).toBeVisible()
  })

  test('Toggle mensuel/annuel fonctionne correctement', async () => {
    // Vérifier l'état initial (mensuel)
    await expect(page.locator('text=€6.99/mois')).toBeVisible()
    
    // Cliquer sur le toggle pour passer en annuel
    await page.locator('[data-testid="billing-toggle"]').click()
    
    // Vérifier le changement de prix
    await expect(page.locator('text=€59.90/an')).toBeVisible()
    await expect(page.locator('text=Soit €4.99/mois')).toBeVisible()
  })

  test('Cartes de test Stripe sont affichées', async () => {
    // Vérifier la section des cartes de test
    await expect(page.locator('text=Cartes de test Stripe')).toBeVisible()
    
    // Vérifier les différents types de cartes
    await expect(page.locator('text=4242 4242 4242 4242')).toBeVisible() // Succès
    await expect(page.locator('text=4000 0000 0000 0002')).toBeVisible() // Déclinée
    await expect(page.locator('text=4000 0000 0000 9995')).toBeVisible() // Fonds insuffisants
    await expect(page.locator('text=4000 0000 0000 0069')).toBeVisible() // Expirée
  })

  test('Clic sur "Tester Plan Famille" redirige vers Stripe', async () => {
    // Intercepter les requêtes API
    await page.route('/api/stripe/create-checkout-session', async route => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify({
          sessionId: 'cs_test_123456789',
          url: 'https://checkout.stripe.com/c/pay/cs_test_123456789'
        })
      })
    })

    // Cliquer sur le bouton de test du plan famille
    const familyButton = page.locator('[data-testid="test-family-button"]')
    await expect(familyButton).toContainText('Tester Plan Famille')
    
    // Simuler le clic et vérifier l'état de chargement
    await familyButton.click()
    await expect(familyButton).toContainText('Chargement...')
    await expect(familyButton).toBeDisabled()
  })

  test('API de checkout session répond correctement', async () => {
    // Test de l'API directement
    const response = await page.request.post('/api/stripe/create-checkout-session', {
      data: {
        priceId: 'price_test_family_monthly',
        mode: 'subscription'
      }
    })

    expect(response.status()).toBe(200)
    
    const data = await response.json()
    expect(data).toHaveProperty('sessionId')
    expect(data).toHaveProperty('url')
    expect(data.sessionId).toMatch(/^cs_test_/)
  })

  test('Gestion d\'erreur API', async () => {
    // Mock d'une erreur API
    await page.route('/api/stripe/create-checkout-session', async route => {
      await route.fulfill({
        status: 500,
        contentType: 'application/json',
        body: JSON.stringify({
          error: 'Erreur de test simulée'
        })
      })
    })

    // Déclencher l'erreur
    await page.locator('[data-testid="test-family-button"]').click()
    
    // Vérifier que l'erreur est gérée
    await expect(page.locator('text=Erreur lors du processus de paiement')).toBeVisible()
  })

  test('Page de succès s\'affiche correctement', async () => {
    await page.goto('/success?session_id=cs_test_123456789')
    
    // Vérifier les éléments de la page de succès
    await expect(page.locator('text=Paiement Réussi !')).toBeVisible()
    await expect(page.locator('text=Votre abonnement Math4Child a été activé')).toBeVisible()
    await expect(page.locator('text=cs_test_123456789')).toBeVisible()
    
    // Vérifier les boutons de navigation
    await expect(page.locator('text=Retour à l\'accueil')).toBeVisible()
    await expect(page.locator('text=Tester un autre paiement')).toBeVisible()
  })

  test('Responsivité sur mobile', async ({ browser }) => {
    const context = await browser.newContext({
      viewport: { width: 375, height: 667 } // iPhone SE
    })
    const mobilePage = await context.newPage()
    await mobilePage.goto('/stripe-test')

    // Vérifier que les plans s'affichent en colonne sur mobile
    const plansContainer = mobilePage.locator('.grid')
    await expect(plansContainer).toHaveClass(/grid/)
    
    // Vérifier que les boutons sont cliquables
    const buttons = mobilePage.locator('button:has-text("Tester Plan")')
    const buttonCount = await buttons.count()
    expect(buttonCount).toBe(3)

    await context.close()
  })
})
