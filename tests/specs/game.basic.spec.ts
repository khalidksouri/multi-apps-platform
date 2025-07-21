// ===================================================================
// TESTS DU JEU MATHÉMATIQUE
// Tests de base du système de jeu
// ===================================================================

import { test, expect } from '../utils/test-fixtures';

test.describe('Math4Child - Jeu mathématique', () => {

  test('Démarrage d\'une partie - Addition niveau débutant @smoke', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Vérifier qu'on est dans la vue du jeu
    await expect(newUser.page.locator('.game-view, [data-testid="game"]')).toBeVisible();
    
    // Vérifier qu'un problème mathématique est affiché
    await expect(newUser.page.locator('.problem, [data-testid="problem"]')).toContainText(/\d+\s*\+\s*\d+\s*=\s*\?/);
    
    // Vérifier la présence du champ de réponse
    await expect(newUser.page.locator('input[type="text"], input[inputmode="numeric"]')).toBeVisible();
    
    // Vérifier les boutons d'action
    await expect(newUser.page.locator('button:has-text("Validate"), button:has-text("Valider")')).toBeVisible();
  });

  test('Résolution correcte d\'un problème @critical', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Extraire le problème affiché
    const problemText = await newUser.page.locator('.problem, [data-testid="problem"]').first().textContent();
    const match = problemText?.match(/(\d+)\s*\+\s*(\d+)\s*=\s*\?/);
    
    if (match) {
      const num1 = parseInt(match[1]);
      const num2 = parseInt(match[2]);
      const correctAnswer = num1 + num2;
      
      // Saisir la bonne réponse
      await newUser.solveMathProblem(correctAnswer);
      
      // Vérifier le feedback positif
      await expect(newUser.page.locator('.correct, .success, [data-testid="correct"]')).toBeVisible();
      await expect(newUser.page.locator('body')).toContainText(/correct|bonne|good|+10/i);
    }
  });

  test('Résolution incorrecte d\'un problème', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Saisir une mauvaise réponse (9999)
    await newUser.solveMathProblem(9999);
    
    // Vérifier le feedback négatif
    await expect(newUser.page.locator('.incorrect, .error, [data-testid="incorrect"]')).toBeVisible();
    await expect(newUser.page.locator('body')).toContainText(/wrong|mauvaise|incorrect/i);
  });

  test('Compteur de progression dans le jeu', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Vérifier la présence du compteur de progression
    await expect(newUser.page.locator('[data-testid="progress"], .progress-counter')).toContainText(/\d+\/100/);
    
    // Vérifier l'affichage du niveau et de l'opération actuels
    await expect(newUser.page.locator('.game-header, [data-testid="game-info"]')).toContainText(/beginner|débutant/i);
    await expect(newUser.page.locator('.game-header, [data-testid="game-info"]')).toContainText(/addition/i);
  });

  test('Bouton retour aux niveaux', async ({ newUser }) => {
    await newUser.startGame('beginner', 'addition');
    
    // Cliquer sur le bouton retour
    await newUser.page.locator('button:has-text("Back"), button:has-text("Retour")').first().click();
    
    // Vérifier qu'on est revenu à la page d'accueil
    await expect(newUser.page.locator('[data-testid="levels"], .levels-grid')).toBeVisible();
    await expect(newUser.page.locator('h1')).toContainText(/Math4Child/i);
  });

});
