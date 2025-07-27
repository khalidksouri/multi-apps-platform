import { test as setup, expect } from '@playwright/test'

setup('vérifier que le serveur répond', async ({ page }) => {
  // Aller à la page d'accueil
  await page.goto('/')
  
  // Vérifier que la page charge
  await expect(page.locator('body')).toBeVisible()
  
  console.log('✅ Serveur accessible')
})

setup('vérifier les pages de test', async ({ page }) => {
  // Vérifier page de test Stripe
  await page.goto('/stripe-test')
  await expect(page.locator('h1')).toContainText('Test des Paiements')
  console.log('✅ Page Stripe accessible')
  
  // Vérifier page d'accueil
  await page.goto('/')
  await expect(page.locator('body')).toBeVisible()
  console.log('✅ Page d\'accueil accessible')
})
