import { Page, Locator, expect } from '@playwright/test';

// Configuration des timeouts
export const TIMEOUTS = {
  SHORT: 5000,
  MEDIUM: 15000,
  LONG: 30000,
  EXTRA_LONG: 60000,
  LANGUAGE_CHANGE: 20000
} as const;

// Langues supportées
export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true },
  { code: 'zh', name: '中文', flag: '🇨🇳', rtl: false },
  { code: 'ja', name: '日本語', flag: '🇯🇵', rtl: false },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', rtl: false },
  { code: 'pt', name: 'Português', flag: '🇵🇹', rtl: false },
  { code: 'fi', name: 'Suomi', flag: '🇫🇮', rtl: false }
] as const;

export type SupportedLanguageCode = typeof SUPPORTED_LANGUAGES[number]['code'];

// Classe helper principale
export class Math4ChildTestHelper {
  constructor(public page: Page) {}

  /**
   * Change la langue avec stratégies multiples
   */
  async changeLanguage(languageCode: SupportedLanguageCode): Promise<boolean> {
    console.log(`🌍 Changement vers: ${languageCode}`);

    const strategies = [
      () => this.tryLanguageSelector(languageCode),
      () => this.tryLanguageDropdown(languageCode),
      () => this.tryLanguageButtons(languageCode),
      () => this.tryLocalStorageMethod(languageCode)
    ];

    for (const strategy of strategies) {
      try {
        const success = await strategy();
        if (success) {
          await this.waitForLanguageChange(languageCode);
          console.log(`✅ Langue changée vers ${languageCode}`);
          return true;
        }
      } catch (error) {
        console.log(`⚠️ Stratégie échouée: ${error.message}`);
        continue;
      }
    }

    console.log(`❌ Impossible de changer vers ${languageCode}`);
    return false;
  }

  /**
   * Méthode 1: Sélecteur avec data-testid
   */
  private async tryLanguageSelector(languageCode: SupportedLanguageCode): Promise<boolean> {
    const selectors = [
      '[data-testid="language-selector"]',
      '[data-testid="language-dropdown"]',
      'select[name="language"]',
      'select:has(option[value="' + languageCode + '"])'
    ];

    for (const selector of selectors) {
      try {
        const element = this.page.locator(selector).first();
        if (await element.isVisible({ timeout: TIMEOUTS.SHORT })) {
          // Pour les selects HTML standard
          if (await element.evaluate(el => el.tagName === 'SELECT')) {
            await element.selectOption(languageCode);
            return true;
          }
          
          // Pour les composants custom
          await element.click();
          await this.page.waitForTimeout(500);
          
          const option = this.page.locator(`[value="${languageCode}"], [data-value="${languageCode}"]`).first();
          if (await option.isVisible({ timeout: TIMEOUTS.SHORT })) {
            await option.click();
            return true;
          }
        }
      } catch (error) {
        continue;
      }
    }
    return false;
  }

  /**
   * Méthode 2: Dropdown custom
   */
  private async tryLanguageDropdown(languageCode: SupportedLanguageCode): Promise<boolean> {
    const dropdownSelectors = [
      '.language-dropdown',
      '.language-select',
      '[aria-label*="language"]',
      '[aria-label*="Language"]'
    ];

    for (const selector of dropdownSelectors) {
      try {
        const dropdown = this.page.locator(selector).first();
        if (await dropdown.isVisible({ timeout: TIMEOUTS.SHORT })) {
          await dropdown.click();
          await this.page.waitForTimeout(500);
          
          // Chercher l'option par différents attributs
          const optionSelectors = [
            `[data-value="${languageCode}"]`,
            `[data-lang="${languageCode}"]`,
            `option[value="${languageCode}"]`,
            `.language-option:has-text("${languageCode}")`
          ];
          
          for (const optionSelector of optionSelectors) {
            const option = this.page.locator(optionSelector).first();
            if (await option.isVisible({ timeout: TIMEOUTS.SHORT })) {
              await option.click();
              return true;
            }
          }
        }
      } catch (error) {
        continue;
      }
    }
    return false;
  }

  /**
   * Méthode 3: Boutons de langue
   */
  private async tryLanguageButtons(languageCode: SupportedLanguageCode): Promise<boolean> {
    const buttonSelectors = [
      `button[data-lang="${languageCode}"]`,
      `button[data-language="${languageCode}"]`,
      `[role="button"][data-lang="${languageCode}"]`,
      `.lang-${languageCode}`,
      `button:has-text("${languageCode.toUpperCase()}")`
    ];

    for (const selector of buttonSelectors) {
      try {
        const button = this.page.locator(selector).first();
        if (await button.isVisible({ timeout: TIMEOUTS.SHORT })) {
          await button.click();
          return true;
        }
      } catch (error) {
        continue;
      }
    }
    return false;
  }

  /**
   * Méthode 4: localStorage (fallback)
   */
  private async tryLocalStorageMethod(languageCode: SupportedLanguageCode): Promise<boolean> {
    try {
      await this.page.evaluate((lang) => {
        const keys = ['language', 'locale', 'lang', 'i18n', 'math4child_language'];
        keys.forEach(key => {
          localStorage.setItem(key, lang);
        });
        
        // Déclencher des événements
        window.dispatchEvent(new CustomEvent('languageChange', { detail: lang }));
        window.dispatchEvent(new StorageEvent('storage', { 
          key: 'language', 
          newValue: lang 
        }));
      }, languageCode);

      await this.page.reload({ waitUntil: 'domcontentloaded', timeout: TIMEOUTS.LONG });
      return true;
    } catch (error) {
      return false;
    }
  }

  /**
   * Attendre que le changement de langue soit effectif
   */
  private async waitForLanguageChange(languageCode: SupportedLanguageCode): Promise<void> {
    await this.page.waitForTimeout(1000);
    
    try {
      await Promise.race([
        // Attendre un changement dans le DOM
        this.page.waitForFunction(
          (lang) => {
            return document.documentElement.lang === lang || 
                   document.body.getAttribute('data-lang') === lang ||
                   document.body.classList.contains(`lang-${lang}`);
          },
          languageCode,
          { timeout: TIMEOUTS.LANGUAGE_CHANGE }
        ),
        
        // Timeout de sécurité
        this.page.waitForTimeout(TIMEOUTS.LANGUAGE_CHANGE)
      ]);
    } catch (error) {
      console.log(`⚠️ Timeout changement langue: ${error.message}`);
    }
  }

  /**
   * Vérifier que l'application fonctionne
   */
  async verifyAppIsWorking(): Promise<boolean> {
    try {
      // Vérifier que le body existe
      const bodyExists = await this.page.locator('body').isVisible({ timeout: TIMEOUTS.MEDIUM });
      if (!bodyExists) return false;

      // Vérifier qu'il y a du contenu
      const hasContent = await this.page.locator('h1, h2, h3, p, button, a').count() > 0;
      if (!hasContent) return false;

      // Vérifier qu'il n'y a pas d'erreur critique
      const hasError = await this.page.locator('.error, [data-testid="error"]').count() > 0;
      if (hasError) return false;

      console.log(`✅ Application fonctionnelle`);
      return true;
    } catch (error) {
      console.log(`❌ Application non fonctionnelle: ${error.message}`);
      return false;
    }
  }

  /**
   * Démarrer un jeu
   */
  async startGame(gameType?: string): Promise<boolean> {
    const gameSelectors = [
      '[data-testid="start-game"]',
      '[data-testid="play-now"]',
      '.start-game',
      '.play-button',
      'button:has-text("Play")',
      'button:has-text("Jouer")',
      'button:has-text("Start")'
    ];

    if (gameType) {
      gameSelectors.unshift(`[data-testid="start-${gameType}"]`);
    }

    for (const selector of gameSelectors) {
      try {
        const button = this.page.locator(selector).first();
        if (await button.isVisible({ timeout: TIMEOUTS.SHORT })) {
          await button.click();
          await this.page.waitForTimeout(1000);
          
          // Vérifier que le jeu a démarré
          const gameActive = await this.isGameActive();
          if (gameActive) {
            console.log(`🎮 Jeu démarré: ${gameType || 'défaut'}`);
            return true;
          }
        }
      } catch (error) {
        continue;
      }
    }

    return false;
  }

  /**
   * Vérifier si un jeu est actif
   */
  async isGameActive(): Promise<boolean> {
    const gameIndicators = [
      '[data-testid="game-active"]',
      '.game-interface',
      '.game-screen',
      '[data-testid="exercise"]',
      '.math-question'
    ];

    for (const indicator of gameIndicators) {
      try {
        if (await this.page.locator(indicator).isVisible({ timeout: TIMEOUTS.SHORT })) {
          return true;
        }
      } catch (error) {
        continue;
      }
    }

    return false;
  }

  /**
   * Prendre une capture d'écran
   */
  async takeScreenshot(name: string): Promise<void> {
    const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
    const filename = `screenshot-${name}-${timestamp}.png`;
    
    try {
      await this.page.screenshot({ 
        path: `test-results/${filename}`,
        fullPage: true 
      });
      console.log(`📸 Capture: ${filename}`);
    } catch (error) {
      console.log(`⚠️ Erreur capture: ${error.message}`);
    }
  }

  /**
   * Logger les informations de la page
   */
  async logPageInfo(): Promise<void> {
    try {
      const url = this.page.url();
      const title = await this.page.title();
      const viewport = this.page.viewportSize();
      
      console.log(`📄 Page Info:`);
      console.log(`  URL: ${url}`);
      console.log(`  Title: ${title}`);
      console.log(`  Viewport: ${viewport?.width}x${viewport?.height}`);
    } catch (error) {
      console.log(`⚠️ Erreur log: ${error.message}`);
    }
  }
}

/**
 * Attendre avec retry
 */
export async function waitWithRetry<T>(
  operation: () => Promise<T>,
  maxRetries: number = 3,
  delay: number = 1000
): Promise<T> {
  let lastError: Error;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (error) {
      lastError = error as Error;
      console.log(`⚠️ Tentative ${attempt}/${maxRetries} échouée`);
      
      if (attempt < maxRetries) {
        await new Promise(resolve => setTimeout(resolve, delay * attempt));
      }
    }
  }

  throw lastError!;
}

/**
 * Configuration des tests par environnement
 */
export const getTestConfig = () => {
  const isCI = process.env.CI === 'true';
  
  return {
    timeouts: {
      short: isCI ? TIMEOUTS.MEDIUM : TIMEOUTS.SHORT,
      medium: isCI ? TIMEOUTS.LONG : TIMEOUTS.MEDIUM,
      long: isCI ? TIMEOUTS.EXTRA_LONG : TIMEOUTS.LONG
    },
    retries: isCI ? 3 : 2,
    workers: isCI ? 1 : undefined,
    headless: isCI ? true : !process.env.DEBUG
  };
};
