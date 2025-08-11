import { test, expect } from '@playwright/test'

test.describe('Math4Child v4.2.0 - Tests de Base', () => {
  test('Page d\'accueil se charge correctement', async ({ page }) => {
    await page.goto('/')
    
    // Vérifier le titre
    await expect(page).toHaveTitle(/Math4Child/)
    
    // Vérifier le contenu principal
    await expect(page.locator('h1')).toContainText('Math4Child')
    
    // Vérifier que les boutons principaux sont présents
    await expect(page.locator('text=Découvrir les Innovations')).toBeVisible()
  })

  test('Navigation vers les exercices', async ({ page }) => {
    await page.goto('/')
    
    // Cliquer sur le lien exercices
    await page.click('text=Découvrir les Innovations')
    
    // Vérifier qu'on arrive sur la page exercices
    await expect(page).toHaveURL(/exercises/)
    await expect(page.locator('h1')).toContainText('Exercices')
  })

  test('Navigation vers le profil', async ({ page }) => {
    await page.goto('/')
    
    // Aller au profil
    await page.goto('/profile')
    
    // Vérifier le contenu du profil
    await expect(page.locator('h1')).toContainText('Profil')
  })
})
