import { test, expect } from '@playwright/test'

test.describe('postmath - Application Tests', () => {
  
  test('postmath loads successfully', async ({ page }) => {
    await page.goto('http://localhost:300 unitflip budgetcron ai4kids multiai')
    
    // Vérifier que l'application se charge
    await expect(page).toHaveTitle(/postmath/i)
    
    // Vérifier que le sélecteur de langue est présent
    await expect(page.locator('[data-testid="language-selector"]')).toBeVisible()
    
    // Vérifier le compteur de langues
    await expect(page.locator('[data-testid="language-counter"]')).toContainText('20 langues')
  })
  
  test('postmath language switching works', async ({ page }) => {
    await page.goto('http://localhost:300 unitflip budgetcron ai4kids multiai')
    
    // Changer vers le français
    await page.selectOption('[data-testid="language-selector"]', 'fr')
    await expect(page.locator('html')).toHaveAttribute('lang', 'fr')
    
    // Changer vers l'arabe (RTL)
    await page.selectOption('[data-testid="language-selector"]', 'ar')
    await expect(page.locator('html')).toHaveAttribute('dir', 'rtl')
    await expect(page.locator('html')).toHaveAttribute('lang', 'ar')
  })
  
})
