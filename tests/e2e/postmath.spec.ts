import { test, expect } from '@playwright/test';

test.describe('Postmath Application', () => {
  test('should display welcome message', async ({ page }) => {
    await page.goto('/');
    
    // Vérifier que la page se charge avec le bon titre
    await expect(page).toHaveTitle(/Postmath/i);
    
    // Vérifier la présence du message de bienvenue
    await expect(page.locator('text=Postmath API is running')).toBeVisible();
    
    // Vérifier le titre principal
    await expect(page.locator('h1')).toContainText('Postmath');
    
    // Vérifier que les endpoints API sont affichés
    await expect(page.locator('text=/health')).toBeVisible();
  });

  test('should have healthy status endpoint', async ({ request }) => {
    const response = await request.get('/health');
    expect(response.ok()).toBeTruthy();
    
    const data = await response.json();
    expect(data.status).toBe('healthy');
    expect(data.service).toBe('postmath');
  });

  test('should calculate math operations', async ({ request }) => {
    // Test addition
    const addResponse = await request.get('/api/calculate?operation=add&a=5&b=3');
    expect(addResponse.ok()).toBeTruthy();
    
    const addData = await addResponse.json();
    expect(addData.result).toBe(8);
    expect(addData.operation).toBe('add');

    // Test multiplication
    const multiplyResponse = await request.get('/api/calculate?operation=multiply&a=4&b=6');
    expect(multiplyResponse.ok()).toBeTruthy();
    
    const multiplyData = await multiplyResponse.json();
    expect(multiplyData.result).toBe(24);
  });

  test('should handle invalid operations', async ({ request }) => {
    const response = await request.get('/api/calculate?operation=invalid&a=1&b=2');
    expect(response.status()).toBe(400);
    
    const data = await response.json();
    expect(data.error).toContain('Opération non supportée');
  });
});
