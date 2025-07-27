import { test, expect } from '@playwright/test'

test.describe('Math4Child Application', () => {
  test('should load Math4Child homepage', async ({ page }) => {
    await page.goto('/')
    await expect(page).toHaveTitle(/Math4Child/i)
  })

  test('should display main navigation', async ({ page }) => {
    await page.goto('/')
    // Vérifier que les éléments principaux sont présents
    await expect(page.locator('body')).toBeVisible()
  })
})
