// tests/digital4kids.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Digital4Kids - Marketing Digital pour Enfants', () => {

  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:3006');
  });

  test('Page d\'accueil Digital4Kids se charge correctement', async ({ page }) => {
    // Vérifier le titre
    await expect(page).toHaveTitle(/Digital4Kids/);
    
    // Vérifier la présence du logo
    await expect(page.locator('text=Digital4Kids')).toBeVisible();
    
    // Vérifier le message de bienvenue
    await expect(page.locator('text=Bienvenue dans Digital4Kids')).toBeVisible();
    
    // Vérifier la description principale
    await expect(page.locator('text=Découvre le monde passionnant du marketing digital')).toBeVisible();
  });

  test('Les groupes d\'âge sont correctement affichés', async ({ page }) => {
    // Vérifier les badges d'âge
    await expect(page.locator('text=5-8 ans : Quiz simples')).toBeVisible();
    await expect(page.locator('text=9-12 ans : Concepts avancés')).toBeVisible();
    await expect(page.locator('text=13-14 ans : Stratégies marketing')).toBeVisible();
  });

  test('Les trois sections principales sont présentes', async ({ page }) => {
    // Quiz Interactifs
    await expect(page.locator('text=Quiz Interactifs')).toBeVisible();
    await expect(page.locator('text=Teste tes connaissances en marketing digital')).toBeVisible();
    
    // Photos Marketing
    await expect(page.locator('text=Photos Marketing')).toBeVisible();
    await expect(page.locator('text=Découvre comment les images racontent des histoires')).toBeVisible();
    
    // E-Learning
    await expect(page.locator('text=E-Learning')).toBeVisible();
    await expect(page.locator('text=Apprends le marketing digital étape par étape')).toBeVisible();
  });

  test('Navigation vers la page Quiz fonctionne', async ({ page }) => {
    // Cliquer sur le bouton Quiz
    await page.click('text=Commencer >> nth=0');
    
    // Vérifier que nous sommes sur la page quiz
    await expect(page.locator('text=Quiz Marketing Digital')).toBeVisible();
    await expect(page.locator('text=Choisis un quiz adapté à ton âge')).toBeVisible();
  });

  test('Les quiz sont affichés par catégorie d\'âge', async ({ page }) => {
    // Aller à la page quiz
    await page.click('text=Commencer >> nth=0');
    
    // Vérifier les quiz disponibles
    await expect(page.locator('text=Les Réseaux Sociaux')).toBeVisible();
    await expect(page.locator('text=La Publicité Amusante')).toBeVisible();
    await expect(page.locator('text=Créer du Contenu')).toBeVisible();
    
    // Vérifier les groupes d'âge des quiz
    await expect(page.locator('text=5-8')).toBeVisible();
    await expect(page.locator('text=9-12')).toBeVisible();
    await expect(page.locator('text=13-14')).toBeVisible();
  });

  test('Quiz réseaux sociaux pour enfants 5-8 ans', async ({ page }) => {
    // Aller à la page quiz
    await page.click('text=Commencer >> nth=0');
    
    // Sélectionner le quiz réseaux sociaux
    await page.click('text=Les Réseaux Sociaux');
    
    // Vérifier que le quiz démarre
    await expect(page.locator('text=Question 1 sur')).toBeVisible();
    await expect(page.locator('text=Quel emoji utilise-t-on pour dire "j\'aime"')).toBeVisible();
    
    // Vérifier les options de réponse
    await expect(page.locator('text=❤️ Cœur rouge')).toBeVisible();
    await expect(page.locator('text=😢 Visage triste')).toBeVisible();
    await expect(page.locator('text=😡 Visage en colère')).toBeVisible();
    await expect(page.locator('text=🤔 Visage pensif')).toBeVisible();
  });

  test('Interaction complète avec un quiz', async ({ page }) => {
    // Aller à la page quiz et commencer
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Répondre à la première question
    await page.click('text=❤️ Cœur rouge');
    await page.click('text=Question suivante');
    
    // Attendre le message de succès
    await expect(page.locator('text=Bonne réponse')).toBeVisible();
    
    // Vérifier la progression
    await expect(page.locator('text=Question 2 sur')).toBeVisible();
  });

  test('Statistiques et progression de l\'utilisateur', async ({ page }) => {
    // Vérifier les statistiques initiales sur la page d'accueil
    await expect(page.locator('text=Quiz Complétés')).toBeVisible();
    await expect(page.locator('text=Badges Gagnés')).toBeVisible();
    await expect(page.locator('text=Niveau Actuel')).toBeVisible();
    
    // Vérifier les valeurs initiales
    await expect(page.locator('text=0').first()).toBeVisible(); // Quiz complétés
    await expect(page.locator('text=1')).toBeVisible(); // Niveau actuel
  });

  test('Design responsive sur mobile', async ({ page }) => {
    // Définir une taille d'écran mobile
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Vérifier que les éléments sont toujours visibles
    await expect(page.locator('text=Digital4Kids')).toBeVisible();
    await expect(page.locator('text=Bienvenue dans Digital4Kids')).toBeVisible();
    
    // Vérifier que les cartes s'adaptent
    const quizCard = page.locator('text=Quiz Interactifs').locator('..');
    await expect(quizCard).toBeVisible();
  });

  test('Navigation retour depuis les pages secondaires', async ({ page }) => {
    // Aller à la page quiz
    await page.click('text=Commencer >> nth=0');
    
    // Vérifier le bouton retour
    await expect(page.locator('text=Retour')).toBeVisible();
    
    // Cliquer sur retour
    await page.click('text=Retour');
    
    // Vérifier retour à l'accueil
    await expect(page.locator('text=Bienvenue dans Digital4Kids')).toBeVisible();
  });

  test('Page Photos en développement', async ({ page }) => {
    // Aller à la page photos
    await page.click('text=Commencer >> nth=1');
    
    // Vérifier le contenu de la page
    await expect(page.locator('text=Photos Marketing')).toBeVisible();
    await expect(page.locator('text=Fonctionnalité en développement')).toBeVisible();
    await expect(page.locator('text=Analyse d\'images publicitaires')).toBeVisible();
  });

  test('Page E-Learning en développement', async ({ page }) => {
    // Aller à la page e-learning
    await page.click('text=Commencer >> nth=2');
    
    // Vérifier le contenu de la page
    await expect(page.locator('text=E-Learning Marketing')).toBeVisible();
    await expect(page.locator('text=Modules d\'apprentissage en préparation')).toBeVisible();
    await expect(page.locator('text=Les bases du marketing')).toBeVisible();
  });

  test('Accessibilité - Navigation au clavier', async ({ page }) => {
    // Tester la navigation au clavier
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    
    // Vérifier que les éléments peuvent être focalisés
    const focusedElement = page.locator(':focus');
    await expect(focusedElement).toBeVisible();
  });

  test('Performance - Temps de chargement', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('http://localhost:3006');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    
    // La page doit se charger en moins de 3 secondes
    expect(loadTime).toBeLessThan(3000);
    console.log(`Digital4Kids loaded in ${loadTime}ms`);
  });

  test('Animations et interactions', async ({ page }) => {
    // Vérifier les animations hover
    const quizCard = page.locator('text=Quiz Interactifs').locator('..');
    
    // Hover sur la carte
    await quizCard.hover();
    
    // Vérifier que l'élément est interactif
    await expect(quizCard).toBeVisible();
    
    // Cliquer sur le CTA principal
    await page.click('text=Commencer l\'aventure');
    
    // Vérifier la navigation
    await expect(page.locator('text=Quiz Marketing Digital')).toBeVisible();
  });

  test('Gestion des erreurs - Quiz sans sélection', async ({ page }) => {
    // Aller au quiz
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Essayer de passer sans sélectionner de réponse
    await page.click('text=Question suivante');
    
    // Vérifier le message d'erreur
    await expect(page.locator('text=Sélectionne une réponse')).toBeVisible();
  });

  test('Finalisation complète d\'un quiz', async ({ page }) => {
    // Commencer le quiz le plus court
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Répondre à toutes les questions
    await page.click('text=❤️ Cœur rouge');
    await page.click('text=Question suivante');
    
    // Attendre la transition
    await page.waitForTimeout(2500);
    
    // Répondre à la deuxième question
    await page.click('text=Sur un réseau social');
    await page.click('text=Terminer');
    
    // Attendre la transition
    await page.waitForTimeout(2500);
    
    // Vérifier la page de résultats
    await expect(page.locator('text=Quiz Terminé')).toBeVisible();
    await expect(page.locator('text=%')).toBeVisible();
  });

  test('Fonctionnalités multi-langues (préparation)', async ({ page }) => {
    // Vérifier que le contenu est en français par défaut
    await expect(page.locator('text=Bienvenue dans Digital4Kids')).toBeVisible();
    await expect(page.locator('text=Marketing Digital')).toBeVisible();
    
    // Structure prête pour l'internationalisation
    const title = await page.locator('h1').first().textContent();
    expect(title).toContain('Digital4Kids');
  });

});

// tests/digital4kids-educational-content.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Digital4Kids - Contenu Éducatif', () => {

  test('Contenu adapté aux différents groupes d\'âge', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Aller aux quiz
    await page.click('text=Commencer >> nth=0');
    
    // Vérifier le quiz 5-8 ans
    const easyQuiz = page.locator('text=Les Réseaux Sociaux').locator('..');
    await expect(easyQuiz.locator('text=5-8')).toBeVisible();
    
    // Vérifier le quiz 9-12 ans
    const mediumQuiz = page.locator('text=La Publicité Amusante').locator('..');
    await expect(mediumQuiz.locator('text=9-12')).toBeVisible();
    
    // Vérifier le quiz 13-14 ans
    const hardQuiz = page.locator('text=Créer du Contenu').locator('..');
    await expect(hardQuiz.locator('text=13-14')).toBeVisible();
  });

  test('Concepts marketing adaptés aux enfants', async ({ page }) => {
    await page.goto('http://localhost:3006');
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Vérifier que les questions sont adaptées aux enfants
    await expect(page.locator('text=Quel emoji utilise-t-on')).toBeVisible();
    
    // Vérifier que les options sont simples et visuelles
    await expect(page.locator('text=❤️')).toBeVisible();
    await expect(page.locator('text=😢')).toBeVisible();
  });

  test('Explications pédagogiques après les réponses', async ({ page }) => {
    await page.goto('http://localhost:3006');
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Répondre correctement
    await page.click('text=❤️ Cœur rouge');
    await page.click('text=Question suivante');
    
    // Vérifier le feedback positif
    await expect(page.locator('text=Bonne réponse')).toBeVisible();
  });

  test('Système de points et récompenses', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Vérifier le système de points sur l'accueil
    await expect(page.locator('text=0 points')).toBeVisible();
    
    // Commencer un quiz
    await page.click('text=Commencer >> nth=0');
    await page.click('text=Les Réseaux Sociaux');
    
    // Vérifier l'affichage des points dans le quiz
    await expect(page.locator('text=points')).toBeVisible();
  });

});

// tests/digital4kids-safety.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Digital4Kids - Sécurité et Protection', () => {

  test('Aucune collecte de données personnelles', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Vérifier qu'il n'y a pas de formulaires de données personnelles
    const inputs = await page.locator('input[type="email"], input[type="text"], input[type="password"]').count();
    expect(inputs).toBe(0);
    
    // Vérifier qu'il n'y a pas de cookies de tracking
    const cookies = await page.context().cookies();
    const trackingCookies = cookies.filter(cookie => 
      cookie.name.includes('track') || 
      cookie.name.includes('analytics') || 
      cookie.name.includes('marketing')
    );
    expect(trackingCookies.length).toBe(0);
  });

  test('Contenu approprié pour enfants', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Vérifier l'absence de contenu inapproprié
    const pageContent = await page.textContent('body');
    
    // Mots clés qui ne devraient pas apparaître
    const inappropriateWords = ['achat', 'carte bancaire', 'paiement', 'pub cachée'];
    inappropriateWords.forEach(word => {
      expect(pageContent?.toLowerCase()).not.toContain(word);
    });
    
    // Vérifier la présence de contenu éducatif approprié
    expect(pageContent).toContain('apprends');
    expect(pageContent).toContain('découvre');
    expect(pageContent).toContain('amusant');
  });

  test('Navigation sécurisée - pas de liens externes', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Vérifier qu'il n'y a pas de liens externes non sécurisés
    const externalLinks = await page.locator('a[href^="http"]:not([href^="http://localhost"])').count();
    expect(externalLinks).toBe(0);
  });

  test('Interface adaptée aux enfants', async ({ page }) => {
    await page.goto('http://localhost:3006');
    
    // Vérifier les couleurs vives et attractives
    const coloredElements = await page.locator('[class*="gradient"], [class*="color"]').count();
    expect(coloredElements).toBeGreaterThan(0);
    
    // Vérifier la présence d'emojis
    const pageText = await page.textContent('body');
    const emojiRegex = /[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]/gu;
    const hasEmojis = emojiRegex.test(pageText || '');
    expect(hasEmojis).toBe(true);
  });

});

// playwright.config.ts update for Digital4Kids
/*
Add to existing playwright.config.ts:

{
  name: 'digital4kids',
  use: { 
    ...devices['Desktop Chrome'],
    baseURL: 'http://localhost:3006'
  },
},

And update webServer array:
{
  command: 'cd /Users/khalidksouri/global-multi-apps-workspace/digital4kids && npm start',
  port: 3006,
  reuseExistingServer: !process.env.CI,
},
*/