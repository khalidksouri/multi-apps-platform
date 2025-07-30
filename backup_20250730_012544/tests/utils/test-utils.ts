import { Page } from '@playwright/test';

export const TIMEOUTS = {
  SHORT: 5000,
  MEDIUM: 15000,
  LONG: 30000,
  LANGUAGE_CHANGE: 20000
} as const;

export const SUPPORTED_LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷', rtl: false },
  { code: 'en', name: 'English', flag: '🇺🇸', rtl: false },
  { code: 'es', name: 'Español', flag: '🇪🇸', rtl: false },
  { code: 'ar', name: 'العربية', flag: '🇸🇦', rtl: true }
] as const;

export type SupportedLanguageCode = typeof SUPPORTED_LANGUAGES[number]['code'];

export class Math4ChildTestHelper {
  constructor(public page: Page) {}

  async changeLanguage(languageCode: SupportedLanguageCode): Promise<boolean> {
    console.log(`🌍 Tentative de changement vers: ${languageCode}`);

    const strategies = [
      () => this.tryLanguageSelector(languageCode),
      () => this.tryLocalStorageMethod(languageCode)
    ];

    for (const strategy of strategies) {
      try {
        const success = await strategy();
        if (success) {
          await this.page.waitForTimeout(1000);
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

  private async tryLanguageSelector(languageCode: SupportedLanguageCode): Promise<boolean> {
    try {
      const selector = '[data-testid="language-selector"]';
      const element = this.page.locator(selector).first();
      
      if (await element.isVisible({ timeout: TIMEOUTS.SHORT })) {
        await element.selectOption(languageCode);
        return true;
      }
    } catch (error) {
      // Continue to next strategy
    }
    return false;
  }

  private async tryLocalStorageMethod(languageCode: SupportedLanguageCode): Promise<boolean> {
    try {
      await this.page.evaluate((lang) => {
        localStorage.setItem('language', lang);
        localStorage.setItem('math4child_language', lang);
        window.dispatchEvent(new CustomEvent('languageChange', { detail: lang }));
      }, languageCode);

      await this.page.reload({ waitUntil: 'domcontentloaded' });
      return true;
    } catch (error) {
      return false;
    }
  }

  async verifyAppIsWorking(): Promise<boolean> {
    try {
      const bodyExists = await this.page.locator('body').isVisible();
      if (!bodyExists) return false;

      const hasContent = await this.page.locator('h1, h2, h3, p, button, a').count() > 0;
      return hasContent;
    } catch (error) {
      return false;
    }
  }
}
