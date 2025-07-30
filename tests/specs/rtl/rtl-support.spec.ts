import { test, expect } from '@playwright/test'

const APPS = [
  { name: 'postmath', port: 3001 },
  { name: 'unitflip', port: 3002 },
  { name: 'budgetcron', port: 3003 },
  { name: 'ai4kids', port: 3004 },
  { name: 'multiai', port: 3005 }
]

const RTL_LANGUAGES = ['ar', 'he', 'fa']

for (const app of APPS) {
  test.describe(`${app.name} - Support RTL`, () => {
    
    for (const lang of RTL_LANGUAGES) {
      test(`Support RTL pour ${lang}`, async ({ page }) => {
        await page.goto(`http://localhost:${app.port}`)
        
        // Changer vers la langue RTL
        await page.selectOption('[data-testid="language-selector"]', lang)
        
        // Vérifier la direction RTL
        await expect(page.locator('html')).toHaveAttribute('dir', 'rtl')
        await expect(page.locator('body')).toHaveClass(/rtl/)
        
        // Vérifier la persistance après rechargement
        await page.reload()
        await expect(page.locator('html')).toHaveAttribute('dir', 'rtl')
        await expect(page.locator('[data-testid="language-selector"]')).toHaveValue(lang)
      })
    }
    
  })
}
