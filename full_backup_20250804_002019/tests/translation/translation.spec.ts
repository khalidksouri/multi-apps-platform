// ===================================================================
// 🧪 TESTS DE TRADUCTION MATH4CHILD - VERSION FINALE
// Vérification complète de toutes les traductions
// ===================================================================

import { test, expect } from '@playwright/test';

const TEST_LANGUAGES = ['fr', 'en', 'es', 'ar', 'de', 'zh', 'fi'];

test.describe('Math4Child - Tests de Traduction Finaux', () => {
  
  for (const lang of TEST_LANGUAGES) {
    test(`Toutes les traductions fonctionnent en ${lang} @translation-final`, async ({ page }) => {
      await page.goto('/');
      
      // Changer de langue
      await page.click('[data-testid="language-selector"]');
      await page.click(`[data-language="${lang}"]`);
      
      // Attendre que la traduction soit appliquée
      await page.waitForTimeout(1000);
      
      // Vérifier les éléments traduits selon les images problématiques
      
      // 1. Header et tagline
      await expect(page.locator('h1')).toContainText('Math4Child');
      
      // 2. Badge d'application (doit être traduit)
      const badge = page.locator('text=/App.*#1|Bildungs.*#1|应用.*第一|التطبيق.*رقم|ykkös.*koulutus/i');
      await expect(badge).toBeVisible();
      
      // 3. Titre principal "Application Corrigée"
      const mainTitle = page.locator('h2').first();
      await expect(mainTitle).toBeVisible();
      
      // 4. Section Jeux Mathématiques (doit être traduite)
      if (lang === 'fr') {
        await expect(page.locator('text=Jeux Mathématiques')).toBeVisible();
      } else if (lang === 'en') {
        await expect(page.locator('text=Math Games')).toBeVisible();
      } else if (lang === 'es') {
        await expect(page.locator('text=Juegos Matemáticos')).toBeVisible();
      } else if (lang === 'ar') {
        await expect(page.locator('text=الألعاب الرياضية')).toBeVisible();
      } else if (lang === 'de') {
        await expect(page.locator('text=Mathe-Spiele')).toBeVisible();
      } else if (lang === 'zh') {
        await expect(page.locator('text=数学游戏')).toBeVisible();
      } else if (lang === 'fi') {
        await expect(page.locator('text=Matematiikkapelit')).toBeVisible();
      }
      
      // 5. Bouton "Découvrir les Exercices" (problème dans les images)
      if (lang === 'fr') {
        await expect(page.locator('text=Découvrir les Exercices')).toBeVisible();
      } else if (lang === 'en') {
        await expect(page.locator('text=Discover Exercises')).toBeVisible();
      } else if (lang === 'es') {
        await expect(page.locator('text=Descubrir Ejercicios')).toBeVisible();
      } else if (lang === 'ar') {
        await expect(page.locator('text=اكتشف التمارين')).toBeVisible();
      }
      
      // 6. Section "Pourquoi choisir" (problème dans les images)
      if (lang === 'fr') {
        await expect(page.locator('text=Pourquoi choisir Math4Child')).toBeVisible();
      } else if (lang === 'en') {
        await expect(page.locator('text=Why choose Math4Child')).toBeVisible();
      } else if (lang === 'es') {
        await expect(page.locator('text=Por qué elegir Math4Child')).toBeVisible();
      } else if (lang === 'ar') {
        await expect(page.locator('text=لماذا تختار Math4Child')).toBeVisible();
      }
      
      // 7. Statistiques traduites
      if (lang === 'fr') {
        await expect(page.locator('text=Familles')).toBeVisible();
        await expect(page.locator('text=Questions résolues')).toBeVisible();
      } else if (lang === 'en') {
        await expect(page.locator('text=Families')).toBeVisible();
        await expect(page.locator('text=Questions solved')).toBeVisible();
      }
      
      // 8. Message de confiance traduit
      const trustedMessage = page.locator('text=/100k.*famil|familia|عائلة|Familie|家庭|perhe/i');
      await expect(trustedMessage).toBeVisible();
      
      // 9. Vérifier RTL pour l'arabe
      if (lang === 'ar') {
        const dir = await page.locator('body, [dir="rtl"]').first().getAttribute('dir');
        expect(dir).toBe('rtl');
        
        // Vérifier le contenu en arabe
        await expect(page.locator('body')).toContainText(/العربية|الرياضيات|ألعاب/);
      }
    });
  }

  test('Aucune clé de traduction non traduite @no-missing-keys', async ({ page }) => {
    await page.goto('/');
    
    const languages = TEST_LANGUAGES;
    const missingTranslations: string[] = [];
    
    for (const lang of languages) {
      // Changer de langue
      await page.click('[data-testid="language-selector"]');
      await page.click(`[data-language="${lang}"]`);
      await page.waitForTimeout(500);
      
      // Vérifier qu'il n'y a pas de textes en français qui restent dans d'autres langues
      if (lang !== 'fr') {
        const frenchTexts = await page.locator('text=/Pourquoi choisir Math4Child|Déjà 100k|familles nous font/').count();
        if (frenchTexts > 0) {
          missingTranslations.push(`${lang}: Textes français non traduits`);
        }
      }
      
      // Vérifier qu'il n'y a pas de clés de traduction brutes
      const rawKeys = await page.locator('text=/^[A-Z_]+$/').count();
      if (rawKeys > 0) {
        missingTranslations.push(`${lang}: ${rawKeys} clés brutes non traduites`);
      }
    }
    
    expect(missingTranslations).toHaveLength(0);
  });
});
