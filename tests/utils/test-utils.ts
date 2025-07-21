// ===================================================================
// UTILITAIRES DE TEST MATH4CHILD
// Helpers et fonctions partagées
// ===================================================================

import { Page, expect } from '@playwright/test';

// Types Math4Child
export type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'ar' | 'zh' | 'ja' | 'ru' | 'pt' | 'it' | 'hi' | 'ko' | 'th' | 'vi' | 'tr' | 'pl' | 'nl' | 'sv' | 'da' | 'no';
export type Level = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';
export type MathOperation = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

// Configuration des langues pour tests
export const LANGUAGES_CONFIG = {
  'en': { name: 'English', flag: '🇺🇸', rtl: false, testPhrases: ['Learn math', 'English'] },
  'fr': { name: 'Français', flag: '🇫🇷', rtl: false, testPhrases: ['mathématiques', 'Français'] },
  'es': { name: 'Español', flag: '🇪🇸', rtl: false, testPhrases: ['matemáticas', 'Español'] },
  'de': { name: 'Deutsch', flag: '🇩🇪', rtl: false, testPhrases: ['Mathematik', 'Deutsch'] },
  'ar': { name: 'العربية', flag: '🇸🇦', rtl: true, testPhrases: ['الرياضيات', 'العربية'] },
  'zh': { name: '中文', flag: '🇨🇳', rtl: false, testPhrases: ['数学', '中文'] },
  'ja': { name: '日本語', flag: '🇯🇵', rtl: false, testPhrases: ['数学', '日本語'] },
  'ru': { name: 'Русский', flag: '🇷🇺', rtl: false, testPhrases: ['математика', 'Русский'] },
  'pt': { name: 'Português', flag: '🇵🇹', rtl: false, testPhrases: ['matemática', 'Português'] },
  'it': { name: 'Italiano', flag: '🇮🇹', rtl: false, testPhrases: ['matematica', 'Italiano'] }
};

// Sélecteurs communs de l'application
export const SELECTORS = {
  // Header
  appLogo: '[data-testid="app-logo"], .logo, header .calculator',
  appTitle: 'h1:has-text("Math4Child")',
  languageSelector: 'select, [data-testid="language-selector"], .language-selector select',
  freeQuestionsCounter: '[data-testid="free-questions"], .free-questions',
  
  // Navigation
  subscribeButton: 'button:has-text("Subscribe"), button:has-text("S\'abonner"), .subscribe-btn',
  backButton: 'button:has-text("Back"), button:has-text("Retour"), .back-btn',
  
  // Niveaux
  levelsGrid: '[data-testid="levels"], .levels-grid, .levels',
  levelCard: (level: string) => `[data-testid="level-${level}"], .level-${level}, [data-level="${level}"]`,
  progressBar: '.progress, [role="progressbar"], .progress-bar',
  
  // Opérations
  operationsGrid: '[data-testid="operations"], .operations-grid, .operations',
  operationCard: (op: string) => `[data-testid="operation-${op}"], .operation-${op}, [data-operation="${op}"]`,
  
  // Jeu
  gameView: '.game-view, [data-testid="game"], .game-container',
  mathProblem: '.problem, [data-testid="problem"], .math-problem',
  answerInput: 'input[type="text"], input[inputmode="numeric"], .answer-input',
  validateButton: 'button:has-text("Validate"), button:has-text("Valider"), .validate-btn',
  nextButton: 'button:has-text("Next"), button:has-text("Suivant"), .next-btn',
  feedback: '.feedback, [data-testid="feedback"], .correct, .incorrect',
  gameProgress: '[data-testid="progress"], .progress-counter, .game-progress',
  
  // Abonnements
  subscriptionView: '.subscription-view, [data-testid="subscription"], .subscription',
  subscriptionTitle: '.subscription-title, h1:has-text("Subscription"), h1:has-text("Abonnement")',
  planCard: (plan: string) => `[data-testid="plan-${plan}"], .plan-${plan}, [data-plan="${plan}"]`,
  deviceSelector: (device: string) => `[data-device="${device}"], .device-${device}`,
  
  // Stats
  statsGrid: '.stats, [data-testid="stats"], .statistics',
  statCard: '.stat-card, .stats > div'
};

// Classe helper principale pour les tests Math4Child
export class Math4ChildTestHelper {
  constructor(private page: Page) {}

  // Navigation et setup
  async navigateToApp(waitForLoad = true) {
    await this.page.goto('/');
    if (waitForLoad) {
      await this.waitForAppLoad();
    }
  }

  async waitForAppLoad() {
    await Promise.race([
      this.page.waitForSelector(SELECTORS.appTitle, { timeout: 15000 }),
      this.page.waitForSelector(SELECTORS.appLogo, { timeout: 15000 }),
      this.page.waitForSelector('h1', { timeout: 15000 })
    ]);
    await this.page.waitForLoadState('networkidle', { timeout: 10000 });
  }

  // Gestion des langues
  async selectLanguage(language: SupportedLanguage, verifyChange = true) {
    try {
      const selector = await this.findLanguageSelector();
      await selector.selectOption(language);
      
      if (verifyChange) {
        await this.page.waitForTimeout(1500); // Attendre la traduction
        await this.verifyLanguageChange(language);
      }
      
      return true;
    } catch (error) {
      throw new Error(`Impossible de changer vers la langue ${language}: ${error}`);
    }
  }

  private async findLanguageSelector() {
    const selectors = [
      SELECTORS.languageSelector,
      'select:has(option[value="fr"])', // Sélecteur générique
      'header select',
      '.header select'
    ];

    for (const selector of selectors) {
      try {
        const element = this.page.locator(selector).first();
        if (await element.isVisible()) {
          return element;
        }
      } catch (continue) {}
    }
    
    throw new Error('Sélecteur de langue non trouvé');
  }

  private async verifyLanguageChange(language: SupportedLanguage) {
    const config = LANGUAGES_CONFIG[language];
    if (!config) return;

    // Vérifier RTL pour l'arabe
    if (config.rtl) {
      await expect(this.page.locator('body, .rtl, [dir="rtl"]').first()).toHaveAttribute('dir', 'rtl');
    }

    // Vérifier la présence de phrases de test
    for (const phrase of config.testPhrases) {
      await expect(this.page.locator('body')).toContainText(new RegExp(phrase, 'i'));
    }
  }

  // Gestion des niveaux et jeu
  async selectLevel(level: Level) {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    await expect(levelElement).toBeVisible();
    await levelElement.click();
    await this.page.waitForTimeout(500);
  }

  async selectOperation(operation: MathOperation) {
    const operationElement = this.page.locator(SELECTORS.operationCard(operation)).first();
    await expect(operationElement).toBeVisible();
    await operationElement.click();
    await this.page.waitForTimeout(500);
  }

  async startGame(level: Level, operation: MathOperation) {
    await this.selectLevel(level);
    
    // Attendre que les opérations apparaissent
    await this.page.waitForSelector(SELECTORS.operationsGrid, { timeout: 5000 });
    await this.selectOperation(operation);
    
    // Vérifier qu'on est dans la vue de jeu
    await this.page.waitForSelector(SELECTORS.gameView, { timeout: 10000 });
  }

  // Résolution de problèmes mathématiques
  async solveMathProblem(answer?: number): Promise<boolean> {
    // Extraire le problème si pas de réponse fournie
    if (answer === undefined) {
      answer = await this.extractMathProblemAnswer();
    }

    const answerInput = this.page.locator(SELECTORS.answerInput).first();
    await answerInput.fill(answer.toString());
    
    const validateButton = this.page.locator(SELECTORS.validateButton).first();
    await validateButton.click();
    
    return await this.waitForFeedback();
  }

  private async extractMathProblemAnswer(): Promise<number> {
    const problemText = await this.page.locator(SELECTORS.mathProblem).first().textContent();
    if (!problemText) throw new Error('Problème mathématique non trouvé');

    // Expressions régulières pour différents types de problèmes
    const additionMatch = problemText.match(/(\d+)\s*\+\s*(\d+)\s*=\s*\?/);
    const subtractionMatch = problemText.match(/(\d+)\s*-\s*(\d+)\s*=\s*\?/);
    const multiplicationMatch = problemText.match(/(\d+)\s*[×*]\s*(\d+)\s*=\s*\?/);
    const divisionMatch = problemText.match(/(\d+)\s*[÷/]\s*(\d+)\s*=\s*\?/);

    if (additionMatch) {
      return parseInt(additionMatch[1]) + parseInt(additionMatch[2]);
    } else if (subtractionMatch) {
      return parseInt(subtractionMatch[1]) - parseInt(subtractionMatch[2]);
    } else if (multiplicationMatch) {
      return parseInt(multiplicationMatch[1]) * parseInt(multiplicationMatch[2]);
    } else if (divisionMatch) {
      return parseInt(divisionMatch[1]) / parseInt(divisionMatch[2]);
    }
    
    throw new Error(`Format de problème non reconnu: ${problemText}`);
  }

  private async waitForFeedback(): Promise<boolean> {
    await this.page.waitForSelector(SELECTORS.feedback, { timeout: 5000 });
    
    // Déterminer si c'est correct ou incorrect
    const feedbackElement = this.page.locator(SELECTORS.feedback).first();
    const feedbackText = await feedbackElement.textContent() || '';
    const feedbackClass = await feedbackElement.getAttribute('class') || '';
    
    return feedbackText.toLowerCase().includes('correct') || 
           feedbackText.toLowerCase().includes('bonne') ||
           feedbackClass.includes('correct') ||
           feedbackClass.includes('success');
  }

  // Navigation vers abonnements
  async navigateToSubscription() {
    const subscribeButton = this.page.locator(SELECTORS.subscribeButton).first();
    await subscribeButton.click();
    await this.page.waitForSelector(SELECTORS.subscriptionView, { timeout: 10000 });
  }

  // Vérifications communes
  async checkFreeQuestionsCounter(): Promise<string | null> {
    try {
      const counter = this.page.locator(SELECTORS.freeQuestionsCounter).first();
      return await counter.textContent();
    } catch {
      return null;
    }
  }

  async verifyLevelLocked(level: Level): Promise<boolean> {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    const className = await levelElement.getAttribute('class') || '';
    
    return className.includes('locked') || 
           className.includes('disabled') || 
           className.includes('opacity-60');
  }

  async verifyProgressBar(level: Level, expectedProgress?: number): Promise<void> {
    const levelElement = this.page.locator(SELECTORS.levelCard(level)).first();
    const progressBar = levelElement.locator(SELECTORS.progressBar).first();
    
    await expect(progressBar).toBeVisible();
    
    if (expectedProgress !== undefined) {
      const progressText = await levelElement.textContent();
      expect(progressText).toContain(`${expectedProgress}/100`);
    }
  }

  // Responsive design helpers
  async setMobileViewport() {
    await this.page.setViewportSize({ width: 375, height: 812 }); // iPhone X
  }

  async setTabletViewport() {
    await this.page.setViewportSize({ width: 768, height: 1024 }); // iPad
  }

  async setDesktopViewport() {
    await this.page.setViewportSize({ width: 1920, height: 1080 }); // Desktop HD
  }

  // Performance helpers
  async measurePageLoadTime(): Promise<number> {
    const startTime = Date.now();
    await this.navigateToApp();
    return Date.now() - startTime;
  }

  async measureLanguageSwitch(language: SupportedLanguage): Promise<number> {
    const startTime = Date.now();
    await this.selectLanguage(language);
    return Date.now() - startTime;
  }

  // État et données
  async clearUserData() {
    await this.page.evaluate(() => {
      localStorage.clear();
      sessionStorage.clear();
    });
  }

  async setUserProgress(progress: any) {
    await this.page.evaluate((data) => {
      localStorage.setItem('math4child-progress', JSON.stringify(data));
    }, progress);
  }

  async getUserProgress(): Promise<any> {
    return await this.page.evaluate(() => {
      const data = localStorage.getItem('math4child-progress');
      return data ? JSON.parse(data) : null;
    });
  }
}
