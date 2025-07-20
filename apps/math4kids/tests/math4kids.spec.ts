import { expect, test } from '@playwright/test';

test.describe('Math4Kids Enhanced', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    // Attendre que l'application se charge complètement
    await page.waitForLoadState('networkidle');
    // Attendre la disparition du loader
    await page.waitForSelector('#loading', { state: 'detached', timeout: 10000 });
  });

  test('should display the Math4Kids title', async ({ page }) => {
    // Vérifier que le titre principal est visible
    await expect(page.locator('h1')).toContainText('Math4Kids');
    
    // Vérifier la présence de l'emoji caractéristique
    await expect(page.locator('text=🧮')).toBeVisible();
    
    // Vérifier le sous-titre
    await expect(page.locator('text=Apprendre les maths')).toBeVisible();
  });

  test('should start a new game', async ({ page }) => {
    // Chercher le bouton avec l'icône rocket et le texte spécifique
    const startButton = page.getByRole('button', { name: /🚀.*Commencer le jeu/i });
    await expect(startButton).toBeVisible();
    
    // Cliquer sur le bouton
    await startButton.click();
    
    // Vérifier qu'on arrive sur l'écran de jeu
    // Chercher les éléments spécifiques à l'écran de jeu
    await expect(page.locator('text=Score')).toBeVisible();
    await expect(page.locator('text=Vies')).toBeVisible();
    await expect(page.locator('text=Série')).toBeVisible();
  });

  test('should change language to English', async ({ page }) => {
    // Cliquer sur le sélecteur de langue (globe avec drapeau français)
    const languageButton = page.locator('button:has-text("🇫🇷")').first();
    await expect(languageButton).toBeVisible();
    await languageButton.click();
    
    // Attendre que le dropdown soit visible
    await expect(page.locator('text=Choisir la langue')).toBeVisible();
    
    // Sélectionner l'anglais spécifiquement (premier anglais GB)
    const englishButton = page.getByRole('button', { name: /🇬🇧.*English.*English$/i });
    await expect(englishButton).toBeVisible();
    await englishButton.click();
    
    // Vérifier que l'interface a changé en anglais
    await expect(page.getByText('🚀 Start Game')).toBeVisible();
    await expect(page.getByText('Learn math while having fun!')).toBeVisible();
  });

  test('should select different difficulty levels', async ({ page }) => {
    // Vérifier que les niveaux de difficulté sont présents
    for (let level = 1; level <= 5; level++) {
      const levelButton = page.locator(`button:has-text("${level}")`).first();
      await expect(levelButton).toBeVisible();
      
      // Cliquer sur le niveau
      await levelButton.click();
      
      // Vérifier que le niveau est sélectionné (changement de style)
      await expect(levelButton).toHaveClass(/bg-white/);
    }
  });

  test('should select different math operations', async ({ page }) => {
    const operations = ['Addition', 'Soustraction', 'Multiplication', 'Division'];
    
    for (const operation of operations) {
      const operationButton = page.getByRole('button', { name: new RegExp(operation, 'i') });
      await expect(operationButton).toBeVisible();
      
      // Cliquer sur l'opération
      await operationButton.click();
      
      // Vérifier que l'opération est sélectionnée
      await expect(operationButton).toHaveClass(/bg-white/);
    }
  });

  test('should navigate to settings', async ({ page }) => {
    // Cliquer sur le bouton paramètres
    const settingsButton = page.getByRole('button', { name: /Paramètres/i });
    await expect(settingsButton).toBeVisible();
    await settingsButton.click();
    
    // Vérifier qu'on arrive sur l'écran des paramètres
    await expect(page.locator('h2:has-text("Paramètres")')).toBeVisible();
    await expect(page.locator('text=Langue')).toBeVisible();
    await expect(page.locator('text=Son')).toBeVisible();
  });

  test('should toggle sound settings', async ({ page }) => {
    // Aller aux paramètres
    const settingsButton = page.getByRole('button', { name: /Paramètres/i });
    await settingsButton.click();
    
    // Attendre que l'écran des paramètres se charge
    await expect(page.locator('h2:has-text("Paramètres")')).toBeVisible();
    
    // Trouver et cliquer sur le bouton son
    const soundButton = page.locator('button:has-text("🔊 ON"), button:has-text("🔇 OFF")').first();
    await expect(soundButton).toBeVisible();
    
    // Vérifier l'état initial
    const initialText = await soundButton.textContent();
    
    // Cliquer pour changer l'état
    await soundButton.click();
    
    // Vérifier que l'état a changé
    const newText = await soundButton.textContent();
    expect(newText).not.toBe(initialText);
  });

  test('should display language dropdown with multiple languages', async ({ page }) => {
    // Ouvrir le sélecteur de langue
    const languageButton = page.locator('button:has-text("🇫🇷")').first();
    await languageButton.click();
    
    // Vérifier que le dropdown contient plusieurs langues
    await expect(page.locator('text=Europe')).toBeVisible();
    await expect(page.locator('text=Asia')).toBeVisible();
    await expect(page.locator('text=Americas')).toBeVisible();
    
    // Vérifier quelques langues spécifiques
    await expect(page.locator('button:has-text("🇩🇪")')).toBeVisible(); // Allemand
    await expect(page.locator('button:has-text("🇪🇸")')).toBeVisible(); // Espagnol
    await expect(page.locator('button:has-text("🇨🇳")')).toBeVisible(); // Chinois
  });

  test('should be responsive on mobile', async ({ page }) => {
    // Simuler un écran mobile
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Vérifier que les éléments principaux sont toujours visibles
    await expect(page.locator('h1:has-text("Math4Kids")')).toBeVisible();
    await expect(page.getByRole('button', { name: /🚀.*Commencer le jeu/i })).toBeVisible();
    
    // Vérifier que le sélecteur de langue est adapté au mobile
    const languageButton = page.locator('button:has-text("🇫🇷")').first();
    await expect(languageButton).toBeVisible();
  });

  test('should start a complete game flow', async ({ page }) => {
    // Sélectionner niveau 1 (débutant)
    const level1Button = page.locator('button:has-text("1")').first();
    await level1Button.click();
    
    // Sélectionner addition
    const additionButton = page.getByRole('button', { name: /Addition/i });
    await additionButton.click();
    
    // Commencer le jeu
    const startButton = page.getByRole('button', { name: /🚀.*Commencer le jeu/i });
    await startButton.click();
    
    // Vérifier qu'on arrive sur l'écran de jeu
    await expect(page.locator('text=Level 1')).toBeVisible();
    await expect(page.locator('input[placeholder="Réponse"]')).toBeVisible();
    
    // Vérifier qu'une question mathématique est affichée
    await expect(page.locator('text= + ')).toBeVisible();
    await expect(page.locator('text= = ?')).toBeVisible();
  });

  test('should maintain app state across navigation', async ({ page }) => {
    // Changer la langue
    const languageButton = page.locator('button:has-text("🇫🇷")').first();
    await languageButton.click();
    
    const englishButton = page.getByRole('button', { name: /🇬🇧.*English.*English$/i });
    await englishButton.click();
    
    // Aller aux paramètres
    const settingsButton = page.getByRole('button', { name: /Settings/i });
    await settingsButton.click();
    
    // Retourner à l'accueil
    const homeButton = page.locator('button:has([data-lucide="home"])').first();
    await homeButton.click();
    
    // Vérifier que la langue anglaise est conservée
    await expect(page.getByText('🚀 Start Game')).toBeVisible();
    await expect(page.getByText('Learn math while having fun!')).toBeVisible();
  });
});