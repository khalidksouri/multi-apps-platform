import { test, expect, Page } from '@playwright/test';

// Configuration des langues à tester
const LANGUAGES_CONFIG = [
  { 
    code: 'fr', 
    name: 'Français', 
    flag: '🇫🇷',
    expectedTexts: {
      planGratuit: 'Plan Gratuit',
      planPremium: 'Plan Premium', 
      planFamille: 'Plan Famille',
      planEcole: 'Plan École',
      gratuit: 'gratuit',
      confirmer: 'Confirmer',
      annuler: 'Annuler',
      abonnement: 'l\'abonnement',
      mathematics: 'mathématiques'
    }
  },
  { 
    code: 'ar', 
    name: 'العربية', 
    flag: '🇸🇦',
    expectedTexts: {
      planGratuit: 'خطة مجانية',
      planPremium: 'خطة Premium',
      planFamille: 'خطة العائلة', 
      planEcole: 'خطة المدرسة',
      gratuit: 'مجاني',
      confirmer: 'تأكيد الاشتراك',
      annuler: 'إلغاء',
      abonnement: 'الاشتراك',
      mathematics: 'الرياضيات'
    }
  },
  { 
    code: 'de', 
    name: 'Deutsch', 
    flag: '🇩🇪',
    expectedTexts: {
      planGratuit: 'Kostenloses Paket',
      planPremium: 'Premium-Paket',
      planFamille: 'Familien-Paket',
      planEcole: 'Schul-Paket', 
      gratuit: 'kostenlos',
      confirmer: 'Abonnement bestätigen',
      annuler: 'Abbrechen',
      abonnement: 'Abonnement',
      mathematics: 'Mathematik'
    }
  },
  { 
    code: 'it', 
    name: 'Italiano', 
    flag: '🇮🇹',
    expectedTexts: {
      planGratuit: 'Piano Gratuito',
      planPremium: 'Piano Premium',
      planFamille: 'Piano Famiglia',
      planEcole: 'Piano Scuola',
      gratuit: 'gratis',
      confirmer: 'Conferma abbonamento',
      annuler: 'Annulla',
      abonnement: 'abbonamento',
      mathematics: 'matematica'
    }
  }
];

// Types pour les erreurs détectées
interface TranslationError {
  language: string;
  element: string;
  expected: string;
  actual: string;
  severity: 'critical' | 'major' | 'minor';
  errorType: 'missing' | 'incorrect' | 'untranslated';
}

class TranslationErrorDetector {
  private errors: TranslationError[] = [];
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Changer de langue sur la page
  async switchLanguage(languageCode: string): Promise<void> {
    try {
      const success = await this.page.evaluate(async (code) => {
        // Essayer différentes méthodes de changement de langue
        const methods = [
          () => {
            const dropdown = document.querySelector('[data-testid="language-dropdown-button"]') as HTMLElement;
            if (dropdown) {
              dropdown.click();
              setTimeout(() => {
                const option = document.querySelector(`[data-testid="language-option-${code}"]`) as HTMLElement;
                if (option) option.click();
              }, 500);
              return true;
            }
            return false;
          },
          () => {
            const select = document.querySelector('select[name="language"], select[name="lang"]') as HTMLSelectElement;
            if (select) {
              select.value = code;
              select.dispatchEvent(new Event('change', { bubbles: true }));
              return true;
            }
            return false;
          },
          () => {
            const button = document.querySelector(`button[data-lang="${code}"]`) as HTMLElement;
            if (button) {
              button.click();
              return true;
            }
            return false;
          }
        ];

        for (const method of methods) {
          try {
            if (method()) return true;
          } catch (e) {
            continue;
          }
        }
        return false;
      }, languageCode);

      if (success) {
        await this.page.waitForTimeout(2000);
      } else {
        console.warn(`⚠️  Impossible de changer vers ${languageCode} - méthode automatique`);
      }
    } catch (error) {
      console.warn(`Erreur changement langue ${languageCode}:`, error.message);
    }
  }

  // Détecter les erreurs de traduction pour les modales de pricing
  async detectPricingModalErrors(language: any): Promise<void> {
    const triggerSelectors = [
      'button:has-text("gratuit")', 
      'button:has-text("Essai")',
      'button:has-text("Premium")',
      'button:has-text("Famille")',
      'button:has-text("École")',
      '.pricing-button',
      '[data-testid*="pricing"]',
      '[data-testid*="plan"]'
    ];

    for (const selector of triggerSelectors) {
      try {
        const elements = this.page.locator(selector);
        const count = await elements.count();
        
        for (let i = 0; i < Math.min(count, 3); i++) {
          const element = elements.nth(i);
          if (await element.isVisible({ timeout: 1000 })) {
            await element.click();
            await this.page.waitForTimeout(1500);
            
            await this.checkModalTranslations(language);
            
            // Fermer la modale
            await this.page.keyboard.press('Escape');
            await this.page.waitForTimeout(500);
            
            // Alternative pour fermer
            const closeButtons = this.page.locator('button:has-text("×"), button:has-text("Fermer"), [aria-label="Close"]');
            if (await closeButtons.first().isVisible({ timeout: 1000 })) {
              await closeButtons.first().click();
              await this.page.waitForTimeout(500);
            }
          }
        }
      } catch (error) {
        // Continuer avec le prochain sélecteur
      }
    }
  }

  // Vérifier les traductions dans les modales
  async checkModalTranslations(language: any): Promise<void> {
    const modalSelectors = [
      '.modal',
      '[role="dialog"]',
      '.popup',
      '.pricing-modal',
      '.dialog',
      '[data-testid*="modal"]'
    ];

    for (const modalSelector of modalSelectors) {
      const modal = this.page.locator(modalSelector).first();
      if (await modal.isVisible({ timeout: 2000 })) {
        
        // Vérifier tous les textes dans la modale
        const textElements = modal.locator('h1, h2, h3, p, button, span, div:not(:has(*))').all();
        
        for (const element of await textElements) {
          if (await element.isVisible({ timeout: 500 })) {
            const text = await element.textContent();
            if (text && text.trim().length > 1) {
              this.validateElementText(text.trim(), language, 'modal-content');
            }
          }
        }
        break;
      }
    }
  }

  // Valider le texte d'un élément
  private validateElementText(text: string, language: any, elementType: string): void {
    // Vérifier si du français apparaît dans d'autres langues
    if (language.code !== 'fr' && this.containsFrenchWords(text)) {
      this.addError({
        language: language.name,
        element: elementType,
        expected: `Traduction en ${language.name}`,
        actual: text,
        severity: 'major',
        errorType: 'untranslated'
      });
    }

    // Vérifier les textes vides ou trop courts
    if (text.length < 2) {
      this.addError({
        language: language.name,
        element: elementType,
        expected: 'Texte significatif',
        actual: text || 'VIDE',
        severity: 'critical',
        errorType: 'missing'
      });
    }
  }

  // Détecter les mots français dans d'autres langues
  private containsFrenchWords(text: string): boolean {
    const frenchWords = [
      'gratuit', 'confirmer', 'annuler', 'abonnement', 'plan', 
      'famille', 'école', 'premium', 'mois', 'mathématiques',
      'essai', 'prix', 'tarif', 'offre'
    ];
    
    const normalizedText = text.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '');
    return frenchWords.some(word => normalizedText.includes(word));
  }

  // Ajouter une erreur à la liste
  private addError(error: TranslationError): void {
    this.errors.push(error);
    console.warn(`🚨 Erreur détectée:`, error);
  }

  // Obtenir toutes les erreurs
  getErrors(): TranslationError[] {
    return this.errors;
  }

  // Générer un rapport d'erreurs
  generateReport(): string {
    if (this.errors.length === 0) {
      return '\n✅ Aucune erreur de traduction détectée!\n';
    }

    let report = '\n📊 RAPPORT D\'ERREURS DE TRADUCTION\n';
    report += '=====================================\n\n';
    report += `🚨 Total des erreurs: ${this.errors.length}\n\n`;

    const errorsByLanguage = this.errors.reduce((acc, error) => {
      if (!acc[error.language]) acc[error.language] = [];
      acc[error.language].push(error);
      return acc;
    }, {} as Record<string, TranslationError[]>);

    for (const [language, errors] of Object.entries(errorsByLanguage)) {
      report += `🌐 ${language} (${errors.length} erreurs):\n`;
      report += '─'.repeat(40) + '\n';
      
      errors.forEach((error, index) => {
        report += `${index + 1}. [${error.severity.toUpperCase()}] ${error.element}\n`;
        report += `   Attendu: "${error.expected}"\n`;
        report += `   Actuel:  "${error.actual}"\n`;
        report += `   Type:    ${error.errorType}\n\n`;
      });
    }

    return report;
  }
}

test.describe('🌐 Détection automatique des erreurs de traduction', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await page.waitForLoadState('networkidle');
  });

  for (const language of LANGUAGES_CONFIG) {
    test(`Analyse ${language.name} (${language.code})`, async ({ page }) => {
      const detector = new TranslationErrorDetector(page);
      
      // Changer vers la langue testée
      await detector.switchLanguage(language.code);
      
      // Attendre le changement de langue
      await page.waitForTimeout(2000);
      
      // Détecter les erreurs dans les modales de pricing
      await detector.detectPricingModalErrors(language);
      
      // Vérifier la page principale
      const mainTitle = page.locator('h1').first();
      if (await mainTitle.isVisible({ timeout: 2000 })) {
        const titleText = await mainTitle.textContent();
        if (titleText) {
          detector['validateElementText'](titleText, language, 'main-title');
        }
      }
      
      // Générer et afficher le rapport
      const errors = detector.getErrors();
      const report = detector.generateReport();
      
      console.log(report);
      
      // Sauvegarder le rapport
      if (errors.length > 0) {
        const fs = require('fs');
        const reportPath = `test-results/translation/errors-${language.code}-${Date.now()}.json`;
        fs.writeFileSync(reportPath, JSON.stringify({
          language: language.name,
          code: language.code,
          timestamp: new Date().toISOString(),
          errors: errors,
          summary: {
            total: errors.length,
            critical: errors.filter(e => e.severity === 'critical').length,
            major: errors.filter(e => e.severity === 'major').length,
            minor: errors.filter(e => e.severity === 'minor').length
          }
        }, null, 2));
      }
      
      // Le test échoue seulement s'il y a des erreurs critiques
      const criticalErrors = errors.filter(e => e.severity === 'critical');
      if (criticalErrors.length > 0) {
        console.error(`❌ ${criticalErrors.length} erreurs critiques en ${language.name}`);
      }
      
      expect(criticalErrors.length).toBe(0);
    });
  }
});
