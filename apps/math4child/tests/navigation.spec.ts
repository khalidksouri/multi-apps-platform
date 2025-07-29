import { test, expect } from '@playwright/test'

test.describe('Math4Child Navigation', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3000')
  })

  test('should display navigation header', async ({ page }) => {
    await expect(page.locator('div:has-text("M4C")')).toBeVisible()
    await expect(page.locator('h1:has-text("Math4Child")')).toBeVisible()
  })

  test('should navigate between pages', async ({ page }) => {
    await page.click('text=Exercices')
    await expect(page).toHaveURL(/exercises/)
    
    await page.click('h1:has-text("Math4Child")')
    await expect(page).toHaveURL('http://localhost:3000/')
  })

  test('should change language', async ({ page }) => {
    await page.click('button:has(text("🇫🇷"))')
    await page.click('text=English')
    await expect(page.locator('text=Exercises')).toBeVisible()
  })
})
