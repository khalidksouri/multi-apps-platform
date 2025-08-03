import { test, expect } from '@playwright/test'

const APPS = [
  { name: 'postmath', port: 3001 },
  { name: 'unitflip', port: 3002 },
  { name: 'budgetcron', port: 3003 },
  { name: 'ai4kids', port: 3004 },
  { name: 'multiai', port: 3005 }
]

for (const app of APPS) {
  test.describe(`${app.name} - Compteur de langues`, () => {
    
    test('Affiche exactement 20 langues', async ({ page }) => {
      await page.goto(`http://localhost:${app.port}`)
      
      // Vérifier le compteur exact
      const counter = page.locator('[data-testid="language-counter"]')
      await expect(counter).toContainText('20 langues disponibles')
      
      // Vérifier le nombre d'options dans le sélecteur
      const options = page.locator('[data-testid="language-selector"] option')
      await expect(options).toHaveCount(20)
    })
    
    test('Affiche les statistiques RTL/LTR correctes', async ({ page }) => {
      await page.goto(`http://localhost:${app.port}`)
      
      // Vérifier les statistiques détaillées
      const counter = page.locator('[data-testid="language-counter"]')
      await expect(counter).toContainText('3 RTL + 17 LTR')
    })
    
  })
}
