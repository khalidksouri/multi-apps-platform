// =============================================
// 📄 tests/support/helpers.ts
// =============================================
import { Page, Locator } from '@playwright/test';

export class TestHelpers {
  static async waitForElement(page: Page, selector: string, timeout: number = 10000): Promise<Locator> {
    const element = page.locator(selector);
    await element.waitFor({ timeout });
    return element;
  }

  static async waitForText(page: Page, text: string, timeout: number = 10000): Promise<Locator> {
    const element = page.getByText(text);
    await element.waitFor({ timeout });
    return element;
  }

  static async fillFormField(page: Page, fieldName: string, value: string): Promise<void> {
    const selectors = [
      `[data-testid="${fieldName}"]`,
      `[name="${fieldName}"]`,
      `input[placeholder*="${fieldName}"]`,
      `label:has-text("${fieldName}") + input`
    ];

    for (const selector of selectors) {
      try {
        const field = page.locator(selector).first();
        await field.waitFor({ timeout: 5000 });
        await field.clear();
        await field.fill(value);
        return;
      } catch (error) {
        continue;
      }
    }
    
    throw new Error(`Could not find form field: ${fieldName}`);
  }

  static async clickButton(page: Page, buttonText: string): Promise<void> {
    const selectors = [
      `button:has-text("${buttonText}")`,
      `[data-testid="${buttonText}"]`,
      `input[type="button"][value="${buttonText}"]`,
      `input[type="submit"][value="${buttonText}"]`
    ];

    for (const selector of selectors) {
      try {
        const button = page.locator(selector).first();
        await button.waitFor({ timeout: 5000 });
        await button.click();
        return;
      } catch (error) {
        continue;
      }
    }
    
    throw new Error(`Could not find button: ${buttonText}`);
  }

  static async selectDropdownOption(page: Page, selectName: string, optionValue: string): Promise<void> {
    const select = page.locator(`select[name="${selectName}"], [data-testid="${selectName}"]`);
    await select.selectOption(optionValue);
  }

  static async uploadFile(page: Page, inputSelector: string, filePath: string): Promise<void> {
    const fileInput = page.locator(inputSelector);
    await fileInput.setInputFiles(filePath);
  }

  static async scrollToElement(page: Page, selector: string): Promise<void> {
    const element = page.locator(selector);
    await element.scrollIntoViewIfNeeded();
  }

  static async takeElementScreenshot(page: Page, selector: string, name: string): Promise<void> {
    const element = page.locator(selector);
    await element.screenshot({ path: `test-results/screenshots/${name}.png` });
  }

  static async getElementText(page: Page, selector: string): Promise<string> {
    const element = page.locator(selector);
    return await element.textContent() || '';
  }

  static async isElementVisible(page: Page, selector: string): Promise<boolean> {
    try {
      const element = page.locator(selector);
      await element.waitFor({ state: 'visible', timeout: 5000 });
      return true;
    } catch {
      return false;
    }
  }

  static async waitForNetworkResponse(page: Page, urlPattern: string, timeout: number = 30000): Promise<any> {
    return page.waitForResponse(
      response => response.url().includes(urlPattern) && response.status() === 200,
      { timeout }
    );
  }

  static generateRandomString(length: number = 8): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < length; i++) {
      result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result;
  }

  static generateRandomEmail(): string {
    return `test.${this.generateRandomString()}@example.com`;
  }

  static formatCurrency(amount: number, currency: string = 'EUR'): string {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: currency
    }).format(amount);
  }

  static delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}