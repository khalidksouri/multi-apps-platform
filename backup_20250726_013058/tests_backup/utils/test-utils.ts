import { Page, Locator } from '@playwright/test'

// Sélecteurs robustes pour Math4Child
export const selectors = {
  // Interface principale
  appLogo: '[data-testid="app-logo"], .logo, header .calculator',
  appTitle: 'h1:has-text("Math4Child")',
  languageSelector: 'select, [data-testid="language-selector"], .language-selector select',
  
  // Navigation
  subscribeButton: 'button:has-text("Subscribe"), button:has-text("S\'abonner"), .subscribe-btn',
  backButton: 'button:has-text("Back"), button:has-text("Retour"), .back-btn',
  
  // Tests
  gameView: '.game-view, [data-testid="game"], .game-container',
  feedback: '.feedback, [data-testid="feedback"], .correct, .incorrect'
}

// Fonction pour attendre et obtenir un élément avec fallbacks
export async function waitForElement(page: Page, selectors: string[]): Promise<Locator> {
  for (const selector of selectors) {
    try {
      const element = page.locator(selector).first()
      if (await element.isVisible({ timeout: 5000 })) {
        return element
      }
    } catch (error) {
      // Continue avec le sélecteur suivant
    }
  }
  
  throw new Error('Aucun sélecteur trouvé parmi: ' + selectors.join(', '))
}

// Fonction pour trouver le sélecteur de langue
export async function findLanguageSelector(page: Page): Promise<Locator> {
  const languageSelectors = [
    'select[name="language"]',
    'select[name="lang"]', 
    'select:has(option[value="fr"])',
    'select:has(option[value="en"])',
    '.language-selector select',
    '[data-testid="language-selector"]'
  ]
  
  for (const selector of languageSelectors) {
    try {
      const element = page.locator(selector).first()
      if (await element.isVisible({ timeout: 2000 })) {
        return element
      }
    } catch (error) {
      // Continue avec le sélecteur suivant
    }
  }
  
  throw new Error('Sélecteur de langue non trouvé')
}

// Fonction pour détecter la langue actuelle
export async function detectCurrentLanguage(page: Page): Promise<string> {
  const frenchIndicators = [
    'Français',
    'Accueil', 
    'Bienvenue',
    'éducative',
    'famille'
  ]
  
  // Vérifier les indicateurs français
  for (const indicator of frenchIndicators) {
    try {
      if (await page.locator('text=' + indicator).first().isVisible({ timeout: 1000 })) {
        return 'fr'
      }
    } catch (error) {
      // Continue
    }
  }
  
  return 'unknown'
}

// Fonction pour changer de langue
export async function changeLanguage(page: Page, targetLang: 'fr' | 'en'): Promise<boolean> {
  try {
    const selector = await findLanguageSelector(page)
    await selector.selectOption(targetLang)
    
    // Attendre un peu pour que le changement prenne effet
    await page.waitForTimeout(1000)
    
    return true
  } catch (error) {
    console.log('Impossible de changer la langue:', error.message)
    return false
  }
}

// Fonction pour valider une réponse correcte (REGEX CORRIGEE)
export function validateAnswer(answer: string): boolean {
  // Regex corrigées pour éviter l'erreur "Nothing to repeat"
  const correctPatterns = [
    /correct/i,
    /bonne/i,
    /good/i,
    /\+10/,  // CORRIGE: échappé correctement
    /bravo/i,
    /excellent/i
  ]
  
  return correctPatterns.some(pattern => pattern.test(answer))
}

export default {
  selectors,
  waitForElement,
  findLanguageSelector,
  detectCurrentLanguage,
  changeLanguage,
  validateAnswer
}
