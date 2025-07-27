import { test, expect } from '@playwright/test'

test.describe('Recherche de langues dans le dropdown', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
  })

  test('Recherche par début de nom de langue', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).toBeVisible()
    
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    await expect(searchInput).toBeVisible()
    await searchInput.focus()
    
    await searchInput.fill('Fra')
    await page.waitForTimeout(300)
    
    const languageOptions = page.locator('[role="option"]')
    await expect(languageOptions).toHaveCount(1)
    await expect(languageOptions.first()).toContainText('Français')
  })

  test('Recherche par code de langue', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    
    await searchInput.fill('fr')
    await page.waitForTimeout(300)
    
    const languageOptions = page.locator('[role="option"]')
    await expect(languageOptions).toHaveCount(1)
    await expect(languageOptions.first()).toContainText('Français')
  })

  test('Navigation clavier dans les résultats', async ({ page }) => {
    await page.click('[data-testid="language-dropdown-button"]')
    const searchInput = page.locator('input[placeholder*="rechercher"]')
    
    await searchInput.fill('a')
    await page.waitForTimeout(300)
    
    await page.keyboard.press('ArrowDown')
    await page.keyboard.press('Enter')
    
    await expect(page.locator('[data-testid="language-dropdown-menu"]')).not.toBeVisible()
  })
})
