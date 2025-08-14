import { test, expect } from '@playwright/test';

test.describe('Math4Child v4.2.0 - Tests E2E Complets (CONFORMITÉ TOTALE)', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
  });

  test('Page d\'accueil - Éléments requis selon README.md', async ({ page }) => {
    // Vérifier le titre
    await expect(page).toHaveTitle(/Math4Child v4.2.0/);
    
    // Vérifier la marque Math4Child (seule marque visible)
    await expect(page.locator('text=Math4Child')).toBeVisible();
    
    // Vérifier la version
    await expect(page.locator('text=v4.2.0')).toBeVisible();
    
    // Vérifier les 200+ langues supportées
    await expect(page.locator('text=200+')).toBeVisible();
    await expect(page.locator('text=Langues Supportées')).toBeVisible();
    
    // Vérifier les 5 niveaux de progression
    await expect(page.locator('text=5')).toBeVisible();
    await expect(page.locator('text=Niveaux de Progression')).toBeVisible();
    
    // Vérifier les 100 réponses minimum
    await expect(page.locator('text=100')).toBeVisible();
    await expect(page.locator('text=Réponses Min/Niveau')).toBeVisible();
    
    // Vérifier les 6 innovations révolutionnaires
    await expect(page.locator('text=6')).toBeVisible();
    await expect(page.locator('text=Innovations Révolutionnaires')).toBeVisible();
  });

  test('🔒 CONFORMITÉ TOTALE - Aucun élément interdit affiché', async ({ page }) => {
    // Vérifier que les références interdites n'apparaissent JAMAIS
    await expect(page.locator('text=GOTEST')).not.toBeVisible();
    await expect(page.locator('text=53958712100028')).not.toBeVisible();
    await expect(page.locator('text=gotesttech@gmail.com')).not.toBeVisible();
    await expect(page.locator('text=Spécifications primordiales')).not.toBeVisible();
    await expect(page.locator('text=SPÉCIFICATIONS PRIMORDIALES')).not.toBeVisible();
    await expect(page.locator('text=Tarification compétitive selon spécifications README.md')).not.toBeVisible();
    
    console.log('✅ CONFORMITÉ VALIDÉE: Aucun élément interdit trouvé');
  });

  test('Contacts conformes - Seuls les emails autorisés', async ({ page }) => {
    // Vérifier que seuls les emails autorisés apparaissent
    await expect(page.locator('text=support@math4child.com')).toBeVisible();
    await expect(page.locator('text=commercial@math4child.com')).toBeVisible();
    
    // Double vérification: aucun email interdit
    await expect(page.locator('text=gotesttech@gmail.com')).not.toBeVisible();
  });

  test('Plan PREMIUM - Correctement marqué "LE PLUS CHOISI"', async ({ page }) => {
    await expect(page.locator('text=LE PLUS CHOISI')).toBeVisible();
    await expect(page.locator('text=PREMIUM')).toBeVisible();
    
    // Vérifier que PREMIUM est visuellement mis en avant
    const premiumPlan = page.locator('[class*="ring-4 ring-yellow-400"]');
    await expect(premiumPlan).toBeVisible();
  });

  test('5 Plans d\'abonnement selon README.md', async ({ page }) => {
    // Vérifier les 5 plans avec profils exacts
    await expect(page.locator('text=BASIC')).toBeVisible();
    await expect(page.locator('text=STANDARD')).toBeVisible();
    await expect(page.locator('text=PREMIUM')).toBeVisible();
    await expect(page.locator('text=FAMILLE')).toBeVisible();
    await expect(page.locator('text=ULTIMATE')).toBeVisible();
    
    // Vérifier les prix exacts selon README.md
    await expect(page.locator('text=€4.99')).toBeVisible();
    await expect(page.locator('text=€9.99')).toBeVisible();
    await expect(page.locator('text=€14.99')).toBeVisible();
    await expect(page.locator('text=€19.99')).toBeVisible();
    await expect(page.locator('text=€29.99')).toBeVisible();
  });

  test('200+ Langues avec drapeaux spécifiques', async ({ page }) => {
    // Cliquer sur le sélecteur de langue
    await page.click('button:has-text("Français")');
    
    // Vérifier drapeaux spécifiques selon README.md
    await expect(page.locator('text=🇲🇦')).toBeVisible(); // Arabe Afrique
    await expect(page.locator('text=🇵🇸')).toBeVisible(); // Arabe Moyen-Orient
    
    // Vérifier l'indication des 200+ langues
    await expect(page.locator('text=+180 autres langues disponibles')).toBeVisible();
  });

  test('6 Innovations révolutionnaires', async ({ page }) => {
    // Vérifier les 6 innovations
    await expect(page.locator('text=IA Adaptative Avancée')).toBeVisible();
    await expect(page.locator('text=Reconnaissance Manuscrite')).toBeVisible();
    await expect(page.locator('text=Réalité Augmentée 3D')).toBeVisible();
    await expect(page.locator('text=Assistant Vocal IA')).toBeVisible();
    await expect(page.locator('text=Moteur d\'Exercices Révolutionnaire')).toBeVisible();
    await expect(page.locator('text=Système Langues Universel')).toBeVisible();
    
    // Vérifier la mention "PREMIÈRE MONDIALE"
    await expect(page.locator('text=PREMIÈRE MONDIALE')).toBeVisible();
  });

  test('5 Opérations mathématiques', async ({ page }) => {
    // Vérifier les 5 opérations
    await expect(page.locator('text=Addition')).toBeVisible();
    await expect(page.locator('text=Soustraction')).toBeVisible();
    await expect(page.locator('text=Multiplication')).toBeVisible();
    await expect(page.locator('text=Division')).toBeVisible();
    await expect(page.locator('text=Mixte')).toBeVisible();
  });

  test('Footer - Informations 100% conformes', async ({ page }) => {
    // Vérifier les éléments du footer conformes
    await expect(page.locator('footer')).toBeVisible();
    await expect(page.locator('text=© 2025 Math4Child')).toBeVisible();
    await expect(page.locator('text=200+ Langues')).toBeVisible();
    await expect(page.locator('text=IA Adaptative')).toBeVisible();
    await expect(page.locator('text=100% Sécurisé')).toBeVisible();
    
    // Vérifier la conformité sécurité
    await expect(page.locator('text=Conformité COPPA/GDPR')).toBeVisible();
    await expect(page.locator('text=Chiffrement bout-en-bout')).toBeVisible();
    
    // Double vérification: aucune référence interdite
    await expect(page.locator('footer')).not.toContainText('GOTEST');
    await expect(page.locator('footer')).not.toContainText('53958712100028');
    await expect(page.locator('footer')).not.toContainText('gotesttech');
  });
});
