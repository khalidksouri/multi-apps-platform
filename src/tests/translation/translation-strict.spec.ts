import { test, expect } from '@playwright/test'

const LANGUAGES_TO_TEST = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true }
]

test.describe('Tests de traduction stricts - Math4Child', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Vérifie la disponibilité de toutes les langues', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).toBeVisible()
    
    for (const language of LANGUAGES_TO_TEST) {
      const languageOption = page.locator(`[data-testid="language-option-${language.code}"]`)
      await expect(languageOption).toBeVisible()
      await expect(languageOption.locator('text=' + language.flag)).toBeVisible()
      await expect(languageOption.locator('text=' + language.name)).toBeVisible()
    }
  })

  for (const language of LANGUAGES_TO_TEST) {
    test(`Traduction complète en ${language.name} (${language.code})`, async ({ page }) => {
      await page.click('[data-testid="language-dropdown-button"]')
      await page.click(`[data-testid="language-option-${language.code}"]`)
      await page.waitForTimeout(500)
      
      if (language.rtl) {
        const htmlDir = await page.getAttribute('html', 'dir')
        expect(htmlDir).toBe('rtl')
      } else {
        const htmlDir = await page.getAttribute('html', 'dir')
        expect(htmlDir).toBe('ltr')
      }
      
      const htmlLang = await page.getAttribute('html', 'lang')
      expect(htmlLang).toBe(language.code)
      
      const title = page.locator('h1').first()
      if (await title.isVisible()) {
        const text = await title.textContent()
        expect(text).toBeTruthy()
        expect(text?.length).toBeGreaterThan(2)
        
        if (language.code === 'ar') {
          expect(text).toMatch(/[\u0600-\u06FF]/)
        } else if (language.code === 'zh') {
          expect(text).toMatch(/[\u4e00-\u9fff]/)
        }
      }
    })
  }
})
