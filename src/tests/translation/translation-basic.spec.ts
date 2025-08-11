import { test, expect } from '@playwright/test'

const LANGUAGES_TO_TEST = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' }
]

test.describe('Tests de traduction - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Dropdown de langues est visible', async ({ page }) => {
    const dropdown = page.locator('[data-testid="language-dropdown-button"]')
    await expect(dropdown).toBeVisible()
  })

  for (const language of LANGUAGES_TO_TEST) {
    test(`Sélection de ${language.name}`, async ({ page }) => {
      await page.click('[data-testid="language-dropdown-button"]')
      await page.click(`[data-testid="language-option-${language.code}"]`)
      
      const dropdownButton = page.locator('[data-testid="language-dropdown-button"]')
      await expect(dropdownButton).toContainText(language.name)
    })
  }
})
