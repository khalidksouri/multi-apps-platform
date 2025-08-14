import { test, expect } from '@playwright/test';

test.describe('Math4Child v4.2.0 - Validation Fonctionnelle', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('✅ Éléments REQUIS présents', async ({ page }) => {
    // Vérifications positives selon spécifications MATH4CHILD
    await expect(page.locator('text=Math4Child')).toBeVisible();
    await expect(page.locator('text=v4.2.0')).toBeVisible();
    await expect(page.locator('text=support@math4child.com')).toBeVisible();
    await expect(page.locator('text=commercial@math4child.com')).toBeVisible();
    await expect(page.locator('text=LE PLUS CHOISI')).toBeVisible();
    await expect(page.locator('text=200+')).toBeVisible();
    await expect(page.locator('text=PREMIÈRE MONDIALE')).toBeVisible();
    
    console.log('✅ Tous les éléments requis sont présents');
  });

  test('🌍 LANGUES - Drapeaux arabes spécifiques', async ({ page }) => {
    await page.click('button:has-text("Français")');
    
    // Vérifier drapeaux selon spécifications MATH4CHILD
    await expect(page.locator('text=🇲🇦')).toBeVisible(); // Maroc pour Afrique
    await expect(page.locator('text=🇵🇸')).toBeVisible(); // Palestine pour Moyen-Orient
    
    console.log('✅ Drapeaux arabes conformes aux spécifications');
  });

  test('💳 PLANS - Profils selon spécifications exactes', async ({ page }) => {
    // Vérifier les prix selon spécifications MATH4CHILD
    await expect(page.locator('text=€4.99')).toBeVisible(); // BASIC
    await expect(page.locator('text=€9.99')).toBeVisible(); // STANDARD  
    await expect(page.locator('text=€14.99')).toBeVisible(); // PREMIUM
    await expect(page.locator('text=€19.99')).toBeVisible(); // FAMILLE
    await expect(page.locator('text=€29.99')).toBeVisible(); // ULTIMATE
    
    // Vérifier que PREMIUM est marqué comme le plus choisi
    const premiumPlan = page.locator('[class*="ring-4 ring-yellow-400"]');
    await expect(premiumPlan).toBeVisible();
    
    console.log('✅ Plans d\'abonnement conformes aux spécifications');
  });

  test('🎮 PROGRESSION - 5 niveaux avec 100 réponses min', async ({ page }) => {
    // Vérifier les 5 niveaux selon spécifications
    for (let i = 1; i <= 5; i++) {
      await expect(page.locator(`text=Niveau ${i}`)).toBeVisible();
    }
    
    // Vérifier l'exigence des 100 réponses
    await expect(page.locator('text=100 bonnes réponses minimum')).toBeVisible();
    
    console.log('✅ Système de progression conforme');
  });

  test('🧮 OPÉRATIONS - 5 opérations mathématiques', async ({ page }) => {
    // Vérifier les 5 opérations selon spécifications
    await expect(page.locator('text=Addition')).toBeVisible();
    await expect(page.locator('text=Soustraction')).toBeVisible();
    await expect(page.locator('text=Multiplication')).toBeVisible();
    await expect(page.locator('text=Division')).toBeVisible();
    await expect(page.locator('text=Mixte')).toBeVisible();
    
    console.log('✅ 5 opérations mathématiques présentes');
  });

  test('🚀 INNOVATIONS - 6 fonctionnalités révolutionnaires', async ({ page }) => {
    // Vérifier les 6 innovations selon spécifications
    await expect(page.locator('text=IA Adaptative Avancée')).toBeVisible();
    await expect(page.locator('text=Reconnaissance Manuscrite')).toBeVisible();
    await expect(page.locator('text=Réalité Augmentée 3D')).toBeVisible();
    await expect(page.locator('text=Assistant Vocal IA')).toBeVisible();
    await expect(page.locator('text=Moteur d\'Exercices Révolutionnaire')).toBeVisible();
    await expect(page.locator('text=Système Langues Universel')).toBeVisible();
    
    console.log('✅ 6 innovations révolutionnaires présentes');
  });

  test('💰 RÉDUCTIONS - Système selon spécifications', async ({ page }) => {
    // Vérifier les réductions selon spécifications MATH4CHILD
    await expect(page.locator('text=-10%')).toBeVisible(); // Trimestriel
    await expect(page.locator('text=-30%')).toBeVisible(); // Annuel
    await expect(page.locator('text=-75%')).toBeVisible(); // Multi-plateformes
    
    console.log('✅ Système de réductions conforme');
  });

  test('📱 DESIGN - Interface riche et attrayante', async ({ page }) => {
    // Vérifier le design riche selon spécifications
    await expect(page.locator('[class*="gradient"]')).toBeVisible();
    await expect(page.locator('[class*="backdrop-blur"]')).toBeVisible();
    await expect(page.locator('[class*="transform"]')).toBeVisible();
    
    console.log('✅ Design interactif et attrayant conforme');
  });
});
