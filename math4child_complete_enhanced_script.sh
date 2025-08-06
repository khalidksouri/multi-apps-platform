export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr" className="scroll-smooth">
      <head>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet" />
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="default" />
        <meta name="format-detection" content="telephone=no" />
        <meta name="mobile-web-app-capable" content="yes" />
        <meta name="msapplication-TileColor" content="#667eea" />
        <meta name="msapplication-config" content="/browserconfig.xml" />
      </head>
      <body className="font-inter antialiased bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 min-h-screen">
        <LanguageProvider>
          <Navigation />
          <main className="pt-20 pb-10">
            {children}
          </main>
        </LanguageProvider>
      </body>
    </html>
  )
}'

# ===================================================================
# 📄 ÉTAPE 9: TESTS COMPLETS (E2E, TRADUCTION, API, PERFORMANCE)
# ===================================================================

print_step "ÉTAPE 9: CRÉATION DES TESTS COMPLETS"

# Tests E2E avec Playwright
create_file "tests/e2e/math4child.spec.ts" '// Tests E2E complets Math4Child avec Playwright
import { test, expect, Page } from "@playwright/test"

test.describe("Math4Child - Tests E2E Complets", () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto("/")
    await page.waitForLoadState("networkidle")
  })

  test("Page d'\''accueil se charge correctement @smoke", async ({ page }) => {
    // Vérifier les éléments principaux
    await expect(page.locator("h1")).toContainText("Math4Child")
    await expect(page.getByText("Apprendre les maths")).toBeVisible()
    
    // Vérifier la navigation
    await expect(page.getByRole("navigation")).toBeVisible()
    await expect(page.getByText("Commencer l'\''Aventure")).toBeVisible()
    await expect(page.getByText("Voir les Plans")).toBeVisible()
    
    console.log("✅ Page d'\''accueil chargée correctement")
  })

  test("Sélecteur de langues fonctionne @translation", async ({ page }) => {
    // Ouvrir le sélecteur de langues
    await page.getByRole("button", { name: /français/i }).click()
    
    // Vérifier que le dropdown s'\''ouvre
    await expect(page.getByText("Rechercher une langue")).toBeVisible()
    
    // Tester la recherche
    await page.getByPlaceholder("Rechercher une langue").fill("english")
    await expect(page.getByText("English")).toBeVisible()
    
    // Sélectionner l'\''anglais
    await page.getByText("English", { exact: true }).click()
    
    // Vérifier le changement de langue
    await expect(page.getByText("Learn math while having fun")).toBeVisible()
    
    console.log("✅ Sélecteur de langues fonctionnel")
  })

  test("Modal de pricing s'\''ouvre et fonctionne @pricing", async ({ page }) => {
    // Ouvrir le modal de pricing
    await page.getByText("Voir les Plans").click()
    
    // Vérifier que le modal s'\''ouvre
    await expect(page.getByText("Plans Math4Child")).toBeVisible()
    
    // Vérifier les plans
    await expect(page.getByText("Gratuit")).toBeVisible()
    await expect(page.getByText("Mensuel")).toBeVisible()
    await expect(page.getByText("Annuel")).toBeVisible()
    
    // Fermer le modal
    await page.getByRole("button", { name: /fermer/i }).click()
    
    console.log("✅ Modal de pricing fonctionnel")
  })

  test("Navigation responsive @responsive", async ({ page }) => {
    // Tester différentes tailles d'\''écran
    await page.setViewportSize({ width: 375, height: 667 }) // Mobile
    await expect(page.getByRole("navigation")).toBeVisible()
    
    await page.setViewportSize({ width: 768, height: 1024 }) // Tablet
    await expect(page.getByText("Math4Child")).toBeVisible()
    
    await page.setViewportSize({ width: 1920, height: 1080 }) // Desktop
    await expect(page.getByText("195+ langues")).toBeVisible()
    
    console.log("✅ Design responsive vérifié")
  })

  test("Performance et vitesse @performance", async ({ page }) => {
    const startTime = Date.now()
    
    await page.goto("/")
    await page.waitForLoadState("networkidle")
    
    const loadTime = Date.now() - startTime
    
    // Vérifier que la page se charge en moins de 3 secondes
    expect(loadTime).toBeLessThan(3000)
    
    // Vérifier les Web Vitals
    const metrics = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries()
          resolve(entries.map(entry => ({
            name: entry.name,
            value: entry.value
          })))
        }).observe({ entryTypes: ["navigation", "paint"] })
      })
    })
    
    console.log("📊 Métriques de performance:", metrics)
    console.log(`✅ Page chargée en ${loadTime}ms`)
  })

  test("Support RTL pour l'\''arabe @rtl", async ({ page }) => {
    // Changer vers l'\''arabe
    await page.getByRole("button", { name: /français/i }).click()
    await page.getByPlaceholder("Rechercher une langue").fill("العربية")
    await page.getByText("العربية").click()
    
    // Vérifier le support RTL
    const htmlDir = await page.getAttribute("html", "dir")
    expect(htmlDir).toBe("rtl")
    
    // Vérifier le contenu en arabe
    await expect(page.getByText("تعلم الرياضيات بالمتعة")).toBeVisible()
    
    console.log("✅ Support RTL vérifié")
  })
})

test.describe("Math4Child - Tests Fonctionnels Avancés", () => {
  
  test("Génération de questions mathématiques @math", async ({ page }) => {
    await page.goto("/exercises")
    
    // Vérifier la génération de questions
    await expect(page.getByText(/\d+\s*[+\-×÷]\s*\d+/)).toBeVisible()
    
    // Tester une réponse
    await page.getByRole("button", { name: /\d+/ }).first().click()
    
    console.log("✅ Génération de questions testée")
  })

  test("Progression des niveaux @levels", async ({ page }) => {
    await page.goto("/profile")
    
    // Vérifier l'\''affichage des niveaux
    await expect(page.getByText("Niveau 1")).toBeVisible()
    await expect(page.getByText("Débutant")).toBeVisible()
    
    console.log("✅ Système de niveaux vérifié")
  })
})'

# Tests de traduction spécifiques
create_file "tests/translation/language-coverage.spec.ts" '// Tests de couverture linguistique Math4Child
import { test, expect } from "@playwright/test"
import { WORLD_LANGUAGES } from "../../src/data/languages/worldLanguages"
import { TRANSLATIONS, getSupportedTranslationLanguages } from "../../src/lib/translations/worldTranslations"

test.describe("Tests de Traduction Math4Child", () => {

  test("Toutes les langues sont correctement définies @translation", async () => {
    // Vérifier qu'\''on a bien 195+ langues
    expect(WORLD_LANGUAGES.length).toBeGreaterThanOrEqual(195)
    
    // Vérifier que chaque langue a les propriétés requises
    WORLD_LANGUAGES.forEach(lang => {
      expect(lang.code).toBeTruthy()
      expect(lang.name).toBeTruthy()
      expect(lang.nativeName).toBeTruthy()
      expect(lang.flag).toBeTruthy()
      expect(lang.region).toBeTruthy()
      expect(lang.countryCode).toBeTruthy()
    })
    
    console.log(`✅ ${WORLD_LANGUAGES.length} langues vérifiées`)
  })

  test("Support RTL correct @rtl", async () => {
    const rtlLanguages = WORLD_LANGUAGES.filter(lang => lang.rtl)
    
    // Vérifier qu'\''on a les langues RTL principales
    expect(rtlLanguages.some(lang => lang.code === "ar")).toBe(true)
    expect(rtlLanguages.some(lang => lang.code === "fa")).toBe(true)
    expect(rtlLanguages.some(lang => lang.code === "ur")).toBe(true)
    
    // Vérifier qu'\''aucune langue RTL n'\''a l'\''hébreu
    expect(rtlLanguages.some(lang => lang.code === "he")).toBe(false)
    
    console.log(`✅ ${rtlLanguages.length} langues RTL vérifiées`)
  })

  test("Traductions principales disponibles @core-translations", async () => {
    const supportedLangs = getSupportedTranslationLanguages()
    
    // Vérifier les langues principales
    const mainLanguages = ["fr", "en", "ar", "es", "de", "zh", "ja"]
    mainLanguages.forEach(lang => {
      expect(supportedLangs.includes(lang)).toBe(true)
    })
    
    console.log(`✅ ${supportedLangs.length} traductions vérifiées`)
  })

  test("Clés de traduction cohérentes @translation-keys", async () => {
    const frenchKeys = Object.keys(TRANSLATIONS.fr)
    
    // Vérifier que toutes les langues ont les mêmes clés de base
    Object.keys(TRANSLATIONS).forEach(lang => {
      const langKeys = Object.keys(TRANSLATIONS[lang as keyof typeof TRANSLATIONS])
      const commonKeys = ["title", "subtitle", "startAdventure", "viewPlans"]
      
      commonKeys.forEach(key => {
        expect(langKeys.includes(key)).toBe(true)
      })
    })
    
    console.log("✅ Cohérence des clés de traduction vérifiée")
  })

  test("Répartition géographique équilibrée @geography", async () => {
    const regionCounts = {
      Europe: WORLD_LANGUAGES.filter(l => l.region === "Europe").length,
      Asia: WORLD_LANGUAGES.filter(l => l.region === "Asia").length,
      MENA: WORLD_LANGUAGES.filter(l => l.region === "MENA").length,
      Africa: WORLD_LANGUAGES.filter(l => l.region === "Africa").length,
      Americas: WORLD_LANGUAGES.filter(l => l.region === "Americas").length,
      Oceania: WORLD_LANGUAGES.filter(l => l.region === "Oceania").length
    }
    
    // Vérifier qu'\''on a une bonne répartition
    expect(regionCounts.Europe).toBeGreaterThan(30)
    expect(regionCounts.Asia).toBeGreaterThan(40)
    expect(regionCounts.MENA).toBeGreaterThan(5)
    expect(regionCounts.Africa).toBeGreaterThan(15)
    expect(regionCounts.Americas).toBeGreaterThan(15)
    expect(regionCounts.Oceania).toBeGreaterThan(5)
    
    console.log("📊 Répartition géographique:", regionCounts)
  })
})'

# Tests API et backend
create_file "tests/api/pricing-api.spec.ts" '// Tests API pour le système de pricing
import { test, expect } from "@playwright/test"
import { getPricingForCountry, calculateTotalPrice, formatPrice } from "../../src/data/pricing/adaptivePricing"

test.describe("Tests API Pricing", () => {

  test("Pricing adaptatif par pays @pricing-api", async () => {
    // Tester différents pays
    const countries = ["FR", "US", "CN", "IN", "BR", "NG"]
    
    countries.forEach(country => {
      const pricing = getPricingForCountry(country)
      
      expect(pricing.country).toBe(country)
      expect(pricing.prices.monthly).toBeGreaterThan(0)
      expect(pricing.prices.annual).toBeGreaterThan(0)
      expect(pricing.purchasingPowerIndex).toBeGreaterThan(0)
    })
    
    console.log(`✅ Pricing testé pour ${countries.length} pays`)
  })

  test("Calculs de prix avec réductions @pricing-calculations", async () => {
    const pricing = getPricingForCountry("FR")
    
    // Test prix de base
    const monthlyPrice = calculateTotalPrice(pricing, "monthly", 1)
    expect(monthlyPrice).toBeGreaterThan(pricing.prices.monthly)
    
    // Test réductions multi-device
    const twoDevicePrice = calculateTotalPrice(pricing, "monthly", 2)
    const threeDevicePrice = calculateTotalPrice(pricing, "monthly", 3)
    
    expect(twoDevicePrice).toBeLessThan(monthlyPrice)
    expect(threeDevicePrice).toBeLessThan(twoDevicePrice)
    
    console.log("✅ Calculs de réductions vérifiés")
  })

  test("Formatage des prix par devise @price-formatting", async () => {
    const testCases = [
      { amount: 9.99, currency: "EUR", symbol: "€", expected: "€9.99" },
      { amount: 1099, currency: "JPY", symbol: "¥", expected: "¥1,099" },
      { amount: 199, currency: "INR", symbol: "₹", expected: "₹199.00" }
    ]
    
    testCases.forEach(({ amount, currency, symbol, expected }) => {
      const formatted = formatPrice(amount, currency, symbol)
      expect(formatted).toBe(expected)
    })
    
    console.log("✅ Formatage des prix vérifié")
  })
})'

# Tests de performance et stress
create_file "tests/performance/load-test.spec.ts" '// Tests de performance et de charge Math4Child
import { test, expect } from "@playwright/test"

test.describe("Tests de Performance Math4Child", () => {

  test("Performance de chargement initial @performance", async ({ page }) => {
    const startTime = Date.now()
    
    await page.goto("/")
    await page.waitForLoadState("domcontentloaded")
    
    const domLoadTime = Date.now() - startTime
    
    // Vérifier que le DOM se charge en moins de 2 secondes
    expect(domLoadTime).toBeLessThan(2000)
    
    console.log(`✅ DOM chargé en ${domLoadTime}ms`)
  })

  test("Performance du sélecteur de langues @performance", async ({ page }) => {
    await page.goto("/")
    
    const startTime = Date.now()
    
    // Ouvrir le sélecteur
    await page.getByRole("button", { name: /français/i }).click()
    await page.waitForSelector("[placeholder=\"Rechercher une langue\"]")
    
    const openTime = Date.now() - startTime
    
    // Le sélecteur doit s'\''ouvrir en moins de 500ms
    expect(openTime).toBeLessThan(500)
    
    console.log(`✅ Sélecteur ouvert en ${openTime}ms`)
  })

  test("Recherche de langues performante @search-performance", async ({ page }) => {
    await page.goto("/")
    await page.getByRole("button", { name: /français/i }).click()
    
    const searchInput = page.getByPlaceholder("Rechercher une langue")
    
    const startTime = Date.now()
    
    // Rechercher rapidement
    await searchInput.fill("eng")
    await page.waitForSelector("text=English")
    
    const searchTime = Date.now() - startTime
    
    // La recherche doit être instantanée (< 200ms)
    expect(searchTime).toBeLessThan(200)
    
    console.log(`✅ Recherche effectuée en ${searchTime}ms`)
  })

  test("Test de stress sélection multiple langues @stress", async ({ page }) => {
    await page.goto("/")
    
    const languages = ["english", "español", "deutsch", "italiano", "português"]
    
    for (const lang of languages) {
      await page.getByRole("button", { name: /français|english|español|deutsch|italiano|português/i }).click()
      await page.getByPlaceholder("Rechercher une langue").fill(lang)
      await page.getByText(lang, { exact: false }).first().click()
      await page.waitForTimeout(100) // Petite pause entre les changements
    }
    
    console.log(`✅ Test de stress réussi avec ${languages.length} changements`)
  })

  test("Mémoire et fuites @memory", async ({ page }) => {
    await page.goto("/")
    
    // Mesurer l'\''utilisation mémoire initiale
    const initialMemory = await page.evaluate(() => {
      return (performance as any).memory?.usedJSHeapSize || 0
    })
    
    // Effectuer de nombreuses opérations
    for (let i = 0; i < 10; i++) {
      await page.getByRole("button", { name: /français/i }).click()
      await page.getByRole("button", { name: /fermer/i }).click()
    }
    
    // Mesurer la mémoire finale
    const finalMemory = await page.evaluate(() => {
      return (performance as any).memory?.usedJSHeapSize || 0
    })
    
    const memoryIncrease = finalMemory - initialMemory
    
    // L'\''augmentation de mémoire ne doit pas dépasser 10MB
    expect(memoryIncrease).toBeLessThan(10 * 1024 * 1024)
    
    console.log(`✅ Utilisation mémoire: +${Math.round(memoryIncrease / 1024)}KB`)
  })
})'

# Configuration Playwright
create_file "playwright.config.ts" 'import { defineConfig, devices } from "@playwright/test"

export default defineConfig({
  testDir: "./tests",
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ["html", { outputFolder: "playwright-report" }],
    ["json", { outputFile: "test-results.json" }],
    ["line"]
  ],
  use: {
    baseURL: "http://localhost:3000",
    trace: "on-first-retry",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
  },

  projects: [
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"] },
    },
    {
      name: "firefox", 
      use: { ...devices["Desktop Firefox"] },
    },
    {
      name: "webkit",
      use: { ...devices["Desktop Safari"] },
    },
    {
      name: "mobile-chrome",
      use: { ...devices["Pixel 5"] },
    },
    {
      name: "mobile-safari",
      use: { ...devices["iPhone 12"] },
    },
    {
      name: "tablet",
      use: { ...devices["iPad Pro"] },
    },
  ],

  webServer: {
    command: "npm run dev",
    url: "http://localhost:3000",
    reuseExistingServer: !process.env.CI,
    timeout: 120 * 1000,
  },
})'

# ===================================================================
# 📄 ÉTAPE 10: CONFIGURATION ET FINALISATION
# ===================================================================

print_step "ÉTAPE 10: CONFIGURATION ET FINALISATION"

# Package.json enrichi avec tous les scripts
create_file "package.json" '{
  "name": "math4child",
  "version": "4.0.0",
  "description": "Math4Child - Application éducative révolutionnaire pour les mathématiques",
  "private": true,
  "engines": {
    "node": ">=18.17.0",
    "npm": ">=9.0.0"
  },
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "export": "next export",
    "lint": "next lint --quiet",
    "lint:fix": "next lint --fix",
    "type-check": "tsc --noEmit",
    "clean": "rm -rf .next out dist node_modules/.cache",
    
    "test": "playwright test",
    "test:e2e": "playwright test tests/e2e",
    "test:translation": "playwright test tests/translation",
    "test:api": "playwright test tests/api", 
    "test:performance": "playwright test tests/performance",
    "test:smoke": "playwright test --grep @smoke",
    "test:critical": "playwright test --grep @critical",
    "test:headed": "playwright test --headed",
    "test:ui": "playwright test --ui",
    "test:report": "playwright show-report",
    
    "install:browsers": "playwright install",
    "install:deps": "playwright install-deps",
    
    "build:prod": "npm run lint:fix && npm run type-check && npm run build",
    "deploy": "npm run build:prod && npm run test:smoke",
    
    "translation:check": "node scripts/check-translations.js",
    "translation:report": "node scripts/translation-report.js",
    
    "dev:clean": "npm run clean && npm run dev",
    "validate": "npm run lint && npm run type-check && npm run test:smoke"
  },
  "dependencies": {
    "next": "14.2.30",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "lucide-react": "0.469.0"
  },
  "devDependencies": {
    "typescript": "5.4.5",
    "@types/node": "20.14.8",
    "@types/react": "18.3.3",
    "@types/react-dom": "18.3.0",
    "eslint": "8.57.0",
    "eslint-config-next": "14.2.30",
    "tailwindcss": "3.4.13",
    "autoprefixer": "10.4.20",
    "postcss": "8.4.47",
    "@playwright/test": "1.48.0"
  },
  "keywords": [
    "math",
    "education",
    "children",
    "multilingual",
    "adaptive-ai",
    "gamification",
    "195-languages",
    "learning",
    "mathematics",
    "kids-app"
  ],
  "author": {
    "name": "GOTEST",
    "email": "gotesttech@gmail.com",
    "url": "https://www.math4child.com"
  },
  "license": "PROPRIETARY",
  "homepage": "https://www.math4child.com",
  "repository": {
    "type": "git",
    "url": "https://github.com/khalidksouri/multi-apps-platform.git"
  },
  "bugs": {
    "url": "https://github.com/khalidksouri/multi-apps-platform/issues"
  }
}'

# Styles CSS ultra-enrichis
create_file "src/app/globals.css" '@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

@import url("https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap");

@layer base {
  html {
    font-family: "Inter", system-ui, -apple-system, sans-serif;
    scroll-behavior: smooth;
  }
  
  body {
    @apply font-inter antialiased;
    font-feature-settings: "cv02", "cv03", "cv04", "cv11";
  }
  
  * {
    @apply border-border;
  }
}

@layer components {
  .btn-primary {
    @apply bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-3 rounded-xl font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200;
  }
  
  .btn-secondary {
    @apply bg-white text-blue-600 border-2 border-blue-600 px-6 py-3 rounded-xl font-semibold hover:bg-blue-50 hover:shadow-lg transform hover:scale-105 transition-all duration-200;
  }
  
  .card {
    @apply bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition-all duration-300;
  }
  
  .card-premium {
    @apply bg-gradient-to-br from-white to-blue-50 rounded-3xl shadow-xl p-8 hover:shadow-2xl transition-all duration-500 border border-blue-100;
  }
  
  .gradient-text {
    @apply bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent;
  }
  
  .bg-grid-pattern {
    background-image: 
      linear-gradient(rgba(59, 130, 246, 0.1) 1px, transparent 1px),
      linear-gradient(90deg, rgba(59, 130, 246, 0.1) 1px, transparent 1px);
    background-size: 20px 20px;
  }
}

/* Animations avancées */
@keyframes float {
  0%, 100% { 
    transform: translateY(0px) rotate(0deg);
  }
  25% {
    transform: translateY(-5px) rotate(1deg);
  }
  50% { 
    transform: translateY(-10px) rotate(0deg);
  }
  75% {
    transform: translateY(-5px) rotate(-1deg);
  }
}

@keyframes pulse-ring {
  0% {
    transform: scale(0.33);
    opacity: 1;
  }
  80%, 100% {
    transform: scale(2.4);
    opacity: 0;
  }
}

@keyframes shine {
  0% {
    background-position: -200% center;
  }
  100% {
    background-position: 200% center;
  }
}

.float {
  animation: float 6s ease-in-out infinite;
}

.pulse-ring {
  animation: pulse-ring 2s infinite;
}

.shine {
  background: linear-gradient(90deg, 
    transparent, 
    rgba(255, 255, 255, 0.4), 
    transparent
  );
  background-size: 200% 100%;
  animation: shine 2s infinite;
}

/* Support RTL avancé */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .flex {
  flex-direction: row-reverse;
}

[dir="rtl"] .space-x-4 > :not([hidden]) ~ :not([hidden]) {
  margin-right: 1rem;
  margin-left: 0;
}

[dir="rtl"] .ml-4 {
  margin-left: 0;
  margin-right: 1rem;
}

[dir="rtl"] .mr-4 {
  margin-right: 0;
  margin-left: 1rem;
}

/* Mobile optimizations avancées */
@media (max-width: 640px) {
  .text-6xl {
    font-size: 3.5rem;
    line-height: 1.1;
  }
  
  .text-7xl {
    font-size: 4rem;
    line-height: 1.1;
  }
  
  .text-8xl {
    font-size: 4.5rem;
    line-height: 1.1;
  }
  
  .text-9xl {
    font-size: 5rem;
    line-height: 1.1;
  }
}

@media (max-width: 480px) {
  .px-12 {
    padding-left: 2rem;
    padding-right: 2rem;
  }
  
  .py-6 {
    padding-top: 1.5rem;
    padding-bottom: 1.5rem;
  }
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f8fafc;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(180deg, #3b82f6, #8b5cf6);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(180deg, #2563eb, #7c3aed);
}

/* Amélioration de la sélection de texte */
::selection {
  background-color: rgba(59, 130, 246, 0.3);
  color: #1e40af;
}

::-moz-selection {
  background-color: rgba(59, 130, 246, 0.3);
  color: #1e40af;
}

/* Focus states améliorés */
:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Animations de chargement */
.loading-spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #3b82f6;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Effets de survol premium */
.hover-lift {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hover-lift:hover {
  transform: translateY(-4px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Responsive grid amélioré */
.responsive-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

@media (max-width: 640px) {
  .responsive-grid {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
}

/* Gradient backgrounds */
.bg-premium {
  background: linear-gradient(135deg, 
    #667eea 0%, 
    #764ba2 100%
  );
}

.bg-math {
  background: linear-gradient(135deg,
    #f093fb 0%, 
    #f5576c 50%,
    #4facfe 100%
  );
}

/* Dark mode support (pour le futur) */
@media (prefers-color-scheme: dark) {
  :root {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
  }
}

/* Accessibilité améliorée */
@media (prefers-reduced-motion: reduce) {
  .float,
  .pulse-ring,
  .shine,
  .loading-spinner {
    animation: none;
  }
  
  .hover-lift:hover {
    transform: none;
  }
}

/* High contrast mode */
@media (prefers-contrast: high) {
  .gradient-text {
    background: none;
    color: #000;
  }
  
  .bg-gradient-to-r {
    background: #000 !important;
  }
}'

# Page d'accueil ultra-riche
create_file "src/app/page.tsx" '"use client"

import Link from "next/link"
import { useState, useEffect } from "react"
import { Calculator, Play, Trophy, Globe, TrendingUp, Award, Users, Zap, Star, Shield, Smartphone, Monitor, Tablet } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import LanguageSelector from "@/components/language/LanguageSelector"
import PricingModal from "@/components/pricing/PricingModal"
import { getTotalLanguages, getLanguageStats } from "@/data/languages/worldLanguages"

export default function HomePage() {
  const [showPricing, setShowPricing] = useState(false)
  const [currentFeature, setCurrentFeature] = useState(0)
  const { t, language, totalLanguages } = useLanguage()
  
  const languageStats = getLanguageStats()

  // Animation automatique des fonctionnalités
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentFeature((prev) => (prev + 1) % 6)
    }, 4000)
    return () => clearInterval(interval)
  }, [])

  return (
    <div className="min-h-screen" dir={language === "ar" ? "rtl" : "ltr"}>
      {/* Hero Section Ultra-Premium */}
      <section className="relative overflow-hidden py-20 px-4 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
        <div className="absolute inset-0 bg-grid-pattern opacity-5"></div>
        <div className="relative max-w-7xl mx-auto">
          <div className="text-center">
            {/* Badge de lancement */}
            <div className="inline-flex items-center gap-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-full text-sm font-semibold mb-8 shadow-lg">
              <Star className="w-4 h-4" />
              Nouveau sur www.math4child.com
              <Star className="w-4 h-4" />
            </div>

            {/* Logo animé */}
            <div className="flex justify-center mb-8">
              <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-8 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300 float relative">
                <Calculator className="w-24 h-24 text-white" />
                <div className="absolute -top-2 -right-2 bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-bold">
                  {totalLanguages}+
                </div>
              </div>
            </div>
            
            {/* Titre avec gradient animé */}
            <div className="mb-8">
              <h1 className="text-7xl md:text-9xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
                Math4Child
              </h1>
              <p className="text-3xl md:text-4xl text-gray-700 font-semibold max-w-5xl mx-auto mb-4">
                {t("subtitle")}
              </p>
              <div className="flex flex-wrap justify-center gap-4 text-lg text-gray-600">
                <div className="flex items-center gap-2">
                  <Globe className="w-5 h-5 text-blue-600" />
                  <span>{totalLanguages}+ langues</span>
                </div>
                <div className="flex items-center gap-2">
                  <Users className="w-5 h-5 text-green-600" />
                  <span>5 niveaux de progression</span>
                </div>
                <div className="flex items-center gap-2">
                  <TrendingUp className="w-5 h-5 text-purple-600" />
                  <span>IA adaptative</span>
                </div>
              </div>
            </div>
            
            {/* Boutons CTA Premium */}
            <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
              <Link 
                href="/exercises"
                className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-12 py-6 rounded-2xl font-bold text-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3 relative overflow-hidden"
              >
                <div className="absolute inset-0 bg-gradient-to-r from-blue-700 to-purple-700 opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                <Play className="w-6 h-6 group-hover:animate-bounce relative z-10" />
                <span className="relative z-10">{t("startAdventure")}</span>
              </Link>
              <button
                onClick={() => setShowPricing(true)}
                className="group bg-white text-blue-600 px-12 py-6 rounded-2xl font-bold text-xl border-3 border-blue-600 hover:bg-blue-50 hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
              >
                <Trophy className="w-6 h-6 group-hover:animate-pulse" />
                <span>{t("viewPlans")}</span>
              </button>
            </div>

            {/* Sélecteur de langues Premium */}
            <div className="mb-12">
              <div className="inline-block bg-white/90 backdrop-blur-sm rounded-2xl p-6 shadow-xl border border-white/20">
                <div className="text-sm text-gray-600 mb-4 font-medium">
                  🌍 Choisissez votre langue parmi {totalLanguages}+ disponibles
                </div>
                <LanguageSelector />
              </div>
            </div>

            {/* Statistiques impressionnantes */}
            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
              {[
                { number: totalLanguages + "+", label: "Langues", icon: "🌍" },
                { number: "5", label: "Niveaux", icon: "🎯" },
                { number: "100%", label: "Gratuit 7j", icon: "🎁" },
                { number: "24/7", label: "Support", icon: "🤝" }
              ].map((stat, index) => (
                <div key={index} className="bg-white/80 backdrop-blur-sm rounded-xl p-4 shadow-lg border border-white/20">
                  <div className="text-2xl mb-2">{stat.icon}</div>
                  <div className="text-3xl font-black text-gray-900 mb-1">{stat.number}</div>
                  <div className="text-sm text-gray-600 font-medium">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités Révolutionnaires */}
      <section className="py-20 px-4 bg-white relative">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-20">
            <h2 className="text-6xl font-black mb-8 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              {t("whyMath4Child")}
            </h2>
            <p className="text-2xl text-gray-600 max-w-4xl mx-auto mb-8">
              Une technologie révolutionnaire qui s'\''adapte à chaque enfant avec une précision chirurgicale
            </p>
            <div className="inline-flex items-center gap-4 bg-gradient-to-r from-green-100 to-blue-100 px-6 py-3 rounded-full">
              <Shield className="w-5 h-5 text-green-600" />
              <span className="font-semibold text-gray-800">100% sécurisé • Données RGPD • Sans publicité</span>
            </div>
          </div>
          
          <div className="grid lg:grid-cols-3 gap-10">
            {[
              {
                icon: <TrendingUp className="w-16 h-16" />,
                title: t("adaptiveAI"),
                description: "Notre IA analyse 50+ paramètres pour adapter chaque question au niveau exact de l'\''enfant",
                color: "from-green-500 to-emerald-500",
                features: ["Analyse comportementale", "Adaptation en temps réel", "Prédiction des difficultés"]
              },
              {
                icon: <Globe className="w-16 h-16" />,
                title: `${totalLanguages}+ ${t("multiLanguage")}`,
                description: "Support natif de toutes les langues mondiales avec traduction automatique RTL",
                color: "from-blue-500 to-cyan-500",
                features: ["RTL automatique", "Traduction native", "Culture locale"]
              },
              {
                icon: <Award className="w-16 h-16" />,
                title: "5 Niveaux Gamifiés",
                description: "Progression structurée avec 100 réponses requises par niveau pour une maîtrise totale",
                color: "from-purple-500 to-pink-500",
                features: ["100 questions/niveau", "Déblocage progressif", "Système de badges"]
              },
              {
                icon: <Calculator className="w-16 h-16" />,
                title: "5 Opérations Complètes",
                description: "Addition, soustraction, multiplication, division + mode mixte avec générateur IA",
                color: "from-orange-500 to-red-500",
                features: ["Générateur IA", "Difficulté adaptative", "Explications détaillées"]
              },
              {
                icon: <Users className="w-16 h-16" />,
                title: "Mode Famille Premium",
                description: "Jusqu'\''à 10 profils enfants avec suivi parental temps réel et analytics avancés",
                color: "from-indigo-500 to-purple-500",
                features: ["10 profils max", "Analytics temps réel", "Contrôle parental"]
              },
              {
                icon: <Zap className="w-16 h-16" />,
                title: "Motivation Intelligente",
                description: "Système de récompenses psychologiquement optimisé pour maintenir l'\''engagement long terme",
                color: "from-yellow-500 to-orange-500",
                features: ["Récompenses adaptées", "Système de streaks", "Défis personnalisés"]
              }
            ].map((feature, index) => (
              <div
                key={index}
                className={`group bg-gradient-to-br from-white to-gray-50 p-10 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 border border-gray-100 relative overflow-hidden ${
                  currentFeature === index ? "ring-4 ring-blue-300 scale-105" : ""
                }`}
              >
                <div className="absolute inset-0 bg-gradient-to-br from-blue-500/5 to-purple-500/5 opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                <div className={`bg-gradient-to-r ${feature.color} p-6 rounded-2xl w-fit mb-8 group-hover:animate-pulse relative z-10`}>
                  <div className="text-white">
                    {feature.icon}
                  </div>
                </div>
                <h3 className="text-3xl font-bold mb-6 group-hover:text-blue-600 transition-colors relative z-10">{feature.title}</h3>
                <p className="text-gray-600 text-lg mb-8 leading-relaxed relative z-10">{feature.description}</p>
                <ul className="space-y-3 relative z-10">
                  {feature.features.map((item, idx) => (
                    <li key={idx} className="flex items-center gap-3 text-gray-700">
                      <div className="w-2 h-2 bg-gradient-to-r from-blue-500 to-purple-500 rounded-full"></div>
                      <span className="font-medium">{item}</span>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Multi-Plateforme */}
      <section className="py-20 px-4 bg-gradient-to-br from-gray-50 to-white">
        <div className="max-w-7xl mx-auto text-center">
          <h2 className="text-5xl font-black mb-8 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Disponible Partout, Synchronisé Toujours
          </h2>
          <p className="text-2xl text-gray-600 max-w-4xl mx-auto mb-16">
            Apprenez sur tous vos appareils avec synchronisation automatique et tarifs dégressifs
          </p>
          
          <div className="grid md:grid-cols-3 gap-8 mb-16">
            {[
              { icon: <Monitor className="w-12 h-12" />, title: "Web", desc: "www.math4child.com", discount: "Prix plein" },
              { icon: <Smartphone className="w-12 h-12" />, title: "Mobile", desc: "iOS & Android", discount: "50% sur 2e appareil" },
              { icon: <Tablet className="w-12 h-12" />, title: "Tablette", desc: "iPad & Android", discount: "75% sur 3e appareil" }
            ].map((platform, index) => (
              <div key={index} className="bg-white p-8 rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 group">
                <div className="bg-gradient-to-r from-blue-100 to-purple-100 p-6 rounded-full w-fit mx-auto mb-6 group-hover:scale-110 transition-transform">
                  <div className="text-blue-600">
                    {platform.icon}
                  </div>
                </div>
                <h3 className="text-2xl font-bold mb-4">{platform.title}</h3>
                <p className="text-gray-600 mb-4">{platform.desc}</p>
                <div className="inline-block bg-green-100 text-green-700 px-4 py-2 rounded-full text-sm font-semibold">
                  {platform.discount}
                </div>
              </div>
            ))}
          </div>
          
          {/* Avantages synchronisation */}
          <div className="bg-white p-8 rounded-2xl shadow-xl max-w-4xl mx-auto">
            <h3 className="text-3xl font-bold mb-6">Synchronisation Intelligente</h3>
            <div className="grid md:grid-cols-3 gap-6 text-center">
              <div>
                <div className="text-4xl mb-2">☁️</div>
                <div className="font-semibold text-gray-800">Cloud Automatique</div>
                <div className="text-sm text-gray-600">Progression sauvée partout</div>
              </div>
              <div>
                <div className="text-4xl mb-2">🔄</div>
                <div className="font-semibold text-gray-800">Sync Temps Réel</div>
                <div className="text-sm text-gray-600">Instantané entre appareils</div>
              </div>
              <div>
                <div className="text-4xl mb-2">📊</div>
                <div className="font-semibold text-gray-800">Analytics Unifiés</div>
                <div className="text-sm text-gray-600">Vue globale des progrès</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section Ultra-Premium */}
      <section className="py-20 px-4 bg-gradient-to-br from-blue-600 via-purple-600 to-pink-600 relative overflow-hidden">
        <div className="absolute inset-0 bg-black/10"></div>
        <div className="max-w-5xl mx-auto text-center relative z-10">
          <h2 className="text-6xl font-black text-white mb-8 leading-tight">
            Prêt à Révolutionner l'\''Apprentissage ?
          </h2>
          <p className="text-2xl text-blue-100 mb-12 max-w-3xl mx-auto">
            Rejoignez des milliers de familles qui font confiance à Math4Child pour transformer l'\''éducation mathématique
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-white text-blue-600 px-12 py-6 rounded-2xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300 shadow-xl"
            >
              🎁 Essayer Gratuitement (7 jours)
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="group bg-black/20 backdrop-blur-sm text-white px-12 py-6 rounded-2xl font-bold text-xl border-2 border-white/30 hover:bg-white/10 transform hover:scale-105 transition-all duration-300"
            >
              💎 Voir Tous les Plans
            </button>
          </div>
          
          {/* Garanties */}
          <div className="grid md:grid-cols-3 gap-6 text-white/90 text-sm">
            <div className="flex items-center justify-center gap-2">
              <Shield className="w-4 h-4" />
              <span>Garantie 30 jours</span>
            </div>
            <div className="flex items-center justify-center gap-2">
              <Users className="w-4 h-4" />
              <span>Support 24/7</span>
            </div>
            <div className="flex items-center justify-center gap-2">
              <Star className="w-4 h-4" />
              <span>Satisfaction garantie</span>
            </div>
          </div>
          
          {/* Footer info */}
          <div className="mt-12 pt-8 border-t border-white/20 text-white/70 text-sm">
            <p className="mb-2">
              🚀 <strong>www.math4child.com</strong> • Développé avec ❤️ par <strong>GOTEST</strong>
            </p>
            <p>
              📧 Contact: gotesttech@gmail.com • 🏢 SIRET: 53958712100028
            </p>
          </div>
        </div>
      </section>

      {/* Modal de Pricing */}
      {showPricing && (
        <PricingModal onClose={() => setShowPricing(false)} />
      )}
    </div>
  )
}'

# Layout enrichi avec métadonnées SEO avancées
create_file "src/app/layout.tsx" 'import "./globals.css"
import Navigation from "@/components/navigation/Navigation"
import { LanguageProvider } from "@/components/language/LanguageProvider"
import type { Metadata, Viewport } from "next"

export const metadata: Metadata = {
  metadataBase: new URL("https://www.math4child.com"),
  title: {
    default: "Math4Child - Apprendre les maths en s'\''amusant !",
    template: "%s | Math4Child"
  },
  description: "Application éducative révolutionnaire pour les mathématiques. 195+ langues, IA adaptative, 5 niveaux de progression. Développée par GOTEST pour enfants de 6-12 ans.",
  keywords: [
    "mathématiques enfants",
    "application éducative",
    "apprentissage ludique",
    "IA adaptative",
    "multilingue",
    "GOTEST",
    "195 langues",
    "progression gamifiée",
    "contrôle parental",
    "éducation numérique"
  ],
  authors: [
    { name: "GOTEST", url: "https://www.math4child.com" }
  ],
  creator: "GOTEST (SIRET: 53958712100028)",
  publisher: "GOTEST",
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  openGraph: {
    type: "website",
    locale: "fr_FR",
    alternateLocale: ["en_US", "es_ES", "de_DE", "ar_SA", "zh_CN", "ja_JP"],
    url: "https://www.math4child.com",
    siteName: "Math4Child",
    title: "Math4Child - Révolutionnons l'\''apprentissage des mathématiques",
    description: "L'\''application qui transforme les mathématiques en aventure ludique pour tous les enfants. 195+ langues, IA adaptative, 5 niveaux de progression.",
    images: [
      {
        url: "/og-image.jpg",
        width: 1200,
        height: 630,
        alt: "Math4Child - Application éducative révolutionnaire",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    site: "@Math4Child",
    creator: "@GOTEST",
    title: "Math4Child - Mathématiques ludiques pour enfants",
    description: "Apprentissage révolutionnaire des mathématiques avec IA adaptative",
    images: ["/twitter-image.jpg"],
  },
  alternates: {
    canonical: "https://www.math4child.com",
    languages: {
      "fr-FR": "https://www.math4child.com",
      "en-US": "https://www.math4child.com/en",
      "es-ES": "https://www.math4child.com/es",
      "de-DE": "https://www.math4child.com/de",
      "ar-SA": "https://www.math4child.com/ar",
      "zh-CN": "https://www.math4child.com/zh",
      "ja-JP": "https://www.math4child.com/ja",
    },
  },
  verification: {
    google: "votre-code-verification-google",
    yandex: "votre-code-verification-yandex",
    bing: "votre-code-verification-bing",
  },
  category: "education",
  classification: "Educational Application for Children",
  referrer: "origin-when-cross-origin",
}

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#667eea" },
    { media: "(prefers-color-scheme: dark)", color: "#667eea" }
  ],
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  colorScheme: "light dark",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
})#!/bin/bash

# ===================================================================
# 🚀 SCRIPT MATH4CHILD COMPLET ENRICHI - VERSION PRODUCTION
# Basé sur les spécifications complètes et le README.md
# Application révolutionnaire pour l'apprentissage des mathématiques
# Domaine: www.math4child.com | Développé par GOTEST
# ===================================================================

set -e

# Couleurs pour les messages
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m'
readonly BOLD='\033[1m'

# Variables globales
readonly PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MATH4CHILD_DIR="${PROJECT_ROOT}/apps/math4child"
readonly SRC_DIR="${MATH4CHILD_DIR}/src"

# ===================================================================
# 🛠️ FONCTIONS UTILITAIRES
# ===================================================================

print_header() {
    echo -e "${PURPLE}${BOLD}"
    echo "=============================================================="
    echo "$1"
    echo "=============================================================="
    echo -e "${NC}"
}

print_step() {
    echo -e "${YELLOW}${BOLD}🔸 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

create_directory() {
    local dir_path="$1"
    mkdir -p "$dir_path"
    print_success "Répertoire créé/vérifié: $(basename "$dir_path")"
}

create_file() {
    local file_path="$1"
    local content="$2"
    local dir_path=$(dirname "$file_path")
    
    mkdir -p "$dir_path"
    echo "$content" > "$file_path"
    print_success "Fichier créé: $(basename "$file_path")"
}

# ===================================================================
# 🎯 DÉBUT DE LA CRÉATION ENRICHIE
# ===================================================================

print_header "🚀 MATH4CHILD - CRÉATION COMPLÈTE VERSION PRODUCTION"
echo -e "${CYAN}🌍 Domaine: www.math4child.com | Développé par GOTEST${NC}"
echo -e "${CYAN}📧 Contact: gotesttech@gmail.com | SIRET: 53958712100028${NC}"
echo -e "${CYAN}🎯 Version: Production Ready avec 195+ langues${NC}"
echo ""

# Vérifications préalables
if [ ! -d "$MATH4CHILD_DIR" ]; then
    print_error "Répertoire Math4Child introuvable: $MATH4CHILD_DIR"
    exit 1
fi

cd "$MATH4CHILD_DIR"

# ===================================================================
# 📁 ÉTAPE 1: STRUCTURE COMPLÈTE DE DOSSIERS
# ===================================================================

print_step "ÉTAPE 1: CRÉATION STRUCTURE COMPLÈTE"

directories=(
    "src/app"
    "src/app/exercises"
    "src/app/profile"
    "src/app/pricing"
    "src/components/language" 
    "src/components/navigation"
    "src/components/pricing"
    "src/components/ui"
    "src/components/exercises"
    "src/components/levels"
    "src/components/auth"
    "src/hooks"
    "src/lib/translations"
    "src/lib/auth"
    "src/lib/payments"
    "src/data/languages"
    "src/data/pricing"
    "src/data/levels"
    "src/data/exercises"
    "src/utils"
    "tests/e2e"
    "tests/translation"
    "tests/api"
    "public/icons"
    "public/screenshots"
)

for dir in "${directories[@]}"; do
    create_directory "$dir"
done

# ===================================================================
# 📄 ÉTAPE 2: DONNÉES MONDIALES ENRICHIES (195+ LANGUES)
# ===================================================================

print_step "ÉTAPE 2: CRÉATION DONNÉES MONDIALES (195+ LANGUES)"

# 1. worldLanguages.ts - Version complète avec 195+ langues
create_file "src/data/languages/worldLanguages.ts" '// 195+ Langues mondiales (SANS HÉBREU) - Version Production
export interface Language {
  code: string
  name: string
  nativeName: string
  flag: string
  rtl?: boolean
  region: string
  countryCode: string
}

export const WORLD_LANGUAGES: Language[] = [
  // ===== EUROPE (45 langues) =====
  { code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷", region: "Europe", countryCode: "FR" },
  { code: "en", name: "English", nativeName: "English", flag: "🇬🇧", region: "Europe", countryCode: "GB" },
  { code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸", region: "Europe", countryCode: "ES" },
  { code: "de", name: "German", nativeName: "Deutsch", flag: "🇩🇪", region: "Europe", countryCode: "DE" },
  { code: "it", name: "Italian", nativeName: "Italiano", flag: "🇮🇹", region: "Europe", countryCode: "IT" },
  { code: "pt", name: "Portuguese", nativeName: "Português", flag: "🇵🇹", region: "Europe", countryCode: "PT" },
  { code: "ru", name: "Russian", nativeName: "Русский", flag: "🇷🇺", region: "Europe", countryCode: "RU" },
  { code: "nl", name: "Dutch", nativeName: "Nederlands", flag: "🇳🇱", region: "Europe", countryCode: "NL" },
  { code: "pl", name: "Polish", nativeName: "Polski", flag: "🇵🇱", region: "Europe", countryCode: "PL" },
  { code: "sv", name: "Swedish", nativeName: "Svenska", flag: "🇸🇪", region: "Europe", countryCode: "SE" },
  { code: "da", name: "Danish", nativeName: "Dansk", flag: "🇩🇰", region: "Europe", countryCode: "DK" },
  { code: "no", name: "Norwegian", nativeName: "Norsk", flag: "🇳🇴", region: "Europe", countryCode: "NO" },
  { code: "fi", name: "Finnish", nativeName: "Suomi", flag: "🇫🇮", region: "Europe", countryCode: "FI" },
  { code: "cs", name: "Czech", nativeName: "Čeština", flag: "🇨🇿", region: "Europe", countryCode: "CZ" },
  { code: "sk", name: "Slovak", nativeName: "Slovenčina", flag: "🇸🇰", region: "Europe", countryCode: "SK" },
  { code: "hu", name: "Hungarian", nativeName: "Magyar", flag: "🇭🇺", region: "Europe", countryCode: "HU" },
  { code: "ro", name: "Romanian", nativeName: "Română", flag: "🇷🇴", region: "Europe", countryCode: "RO" },
  { code: "bg", name: "Bulgarian", nativeName: "Български", flag: "🇧🇬", region: "Europe", countryCode: "BG" },
  { code: "hr", name: "Croatian", nativeName: "Hrvatski", flag: "🇭🇷", region: "Europe", countryCode: "HR" },
  { code: "sr", name: "Serbian", nativeName: "Српски", flag: "🇷🇸", region: "Europe", countryCode: "RS" },
  { code: "sl", name: "Slovenian", nativeName: "Slovenščina", flag: "🇸🇮", region: "Europe", countryCode: "SI" },
  { code: "et", name: "Estonian", nativeName: "Eesti", flag: "🇪🇪", region: "Europe", countryCode: "EE" },
  { code: "lv", name: "Latvian", nativeName: "Latviešu", flag: "🇱🇻", region: "Europe", countryCode: "LV" },
  { code: "lt", name: "Lithuanian", nativeName: "Lietuvių", flag: "🇱🇹", region: "Europe", countryCode: "LT" },
  { code: "el", name: "Greek", nativeName: "Ελληνικά", flag: "🇬🇷", region: "Europe", countryCode: "GR" },
  { code: "tr", name: "Turkish", nativeName: "Türkçe", flag: "🇹🇷", region: "Europe", countryCode: "TR" },
  { code: "mk", name: "Macedonian", nativeName: "Македонски", flag: "🇲🇰", region: "Europe", countryCode: "MK" },
  { code: "al", name: "Albanian", nativeName: "Shqip", flag: "🇦🇱", region: "Europe", countryCode: "AL" },
  { code: "bs", name: "Bosnian", nativeName: "Bosanski", flag: "🇧🇦", region: "Europe", countryCode: "BA" },
  { code: "me", name: "Montenegrin", nativeName: "Crnogorski", flag: "🇲🇪", region: "Europe", countryCode: "ME" },
  { code: "is", name: "Icelandic", nativeName: "Íslenska", flag: "🇮🇸", region: "Europe", countryCode: "IS" },
  { code: "mt", name: "Maltese", nativeName: "Malti", flag: "🇲🇹", region: "Europe", countryCode: "MT" },
  { code: "cy", name: "Welsh", nativeName: "Cymraeg", flag: "🏴󠁧󠁢󠁷󠁬󠁳󠁿", region: "Europe", countryCode: "GB" },
  { code: "ga", name: "Irish", nativeName: "Gaeilge", flag: "🇮🇪", region: "Europe", countryCode: "IE" },
  { code: "gd", name: "Scottish Gaelic", nativeName: "Gàidhlig", flag: "🏴󠁧󠁢󠁳󠁣󠁴󠁿", region: "Europe", countryCode: "GB" },
  { code: "eu", name: "Basque", nativeName: "Euskera", flag: "🏴󠁥󠁳󠁰󠁶󠁿", region: "Europe", countryCode: "ES" },
  { code: "ca", name: "Catalan", nativeName: "Català", flag: "🏴󠁥󠁳󠁣󠁴󠁿", region: "Europe", countryCode: "ES" },
  { code: "gl", name: "Galician", nativeName: "Galego", flag: "🏴󠁥󠁳󠁧󠁡󠁿", region: "Europe", countryCode: "ES" },
  { code: "oc", name: "Occitan", nativeName: "Occitan", flag: "🇫🇷", region: "Europe", countryCode: "FR" },
  { code: "co", name: "Corsican", nativeName: "Corsu", flag: "🇫🇷", region: "Europe", countryCode: "FR" },
  { code: "br", name: "Breton", nativeName: "Brezhoneg", flag: "🇫🇷", region: "Europe", countryCode: "FR" },
  { code: "rm", name: "Romansh", nativeName: "Rumantsch", flag: "🇨🇭", region: "Europe", countryCode: "CH" },
  { code: "lu", name: "Luxembourgish", nativeName: "Lëtzebuergesch", flag: "🇱🇺", region: "Europe", countryCode: "LU" },
  { code: "fo", name: "Faroese", nativeName: "Føroyskt", flag: "🇫🇴", region: "Europe", countryCode: "FO" },
  { code: "kl", name: "Greenlandic", nativeName: "Kalaallisut", flag: "🇬🇱", region: "Europe", countryCode: "GL" },
  { code: "se", name: "Northern Sami", nativeName: "Davvisámegiella", flag: "🇳🇴", region: "Europe", countryCode: "NO" },

  // ===== ASIE (50+ langues) =====
  { code: "zh", name: "Chinese (Simplified)", nativeName: "简体中文", flag: "🇨🇳", region: "Asia", countryCode: "CN" },
  { code: "zh-tw", name: "Chinese (Traditional)", nativeName: "繁體中文", flag: "🇹🇼", region: "Asia", countryCode: "TW" },
  { code: "ja", name: "Japanese", nativeName: "日本語", flag: "🇯🇵", region: "Asia", countryCode: "JP" },
  { code: "ko", name: "Korean", nativeName: "한국어", flag: "🇰🇷", region: "Asia", countryCode: "KR" },
  { code: "hi", name: "Hindi", nativeName: "हिन्दी", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "th", name: "Thai", nativeName: "ไทย", flag: "🇹🇭", region: "Asia", countryCode: "TH" },
  { code: "vi", name: "Vietnamese", nativeName: "Tiếng Việt", flag: "🇻🇳", region: "Asia", countryCode: "VN" },
  { code: "id", name: "Indonesian", nativeName: "Bahasa Indonesia", flag: "🇮🇩", region: "Asia", countryCode: "ID" },
  { code: "ms", name: "Malay", nativeName: "Bahasa Melayu", flag: "🇲🇾", region: "Asia", countryCode: "MY" },
  { code: "tl", name: "Filipino", nativeName: "Filipino", flag: "🇵🇭", region: "Asia", countryCode: "PH" },
  { code: "bn", name: "Bengali", nativeName: "বাংলা", flag: "🇧🇩", region: "Asia", countryCode: "BD" },
  { code: "ur", name: "Urdu", nativeName: "اردو", flag: "🇵🇰", rtl: true, region: "Asia", countryCode: "PK" },
  { code: "te", name: "Telugu", nativeName: "తెలుగు", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "mr", name: "Marathi", nativeName: "मराठी", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "ta", name: "Tamil", nativeName: "தமிழ்", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "gu", name: "Gujarati", nativeName: "ગુજરાતી", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "kn", name: "Kannada", nativeName: "ಕನ್ನಡ", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "ml", name: "Malayalam", nativeName: "മലയാളം", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "or", name: "Odia", nativeName: "ଓଡ଼ିଆ", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "pa", name: "Punjabi", nativeName: "ਪੰਜਾਬੀ", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "as", name: "Assamese", nativeName: "অসমীয়া", flag: "🇮🇳", region: "Asia", countryCode: "IN" },
  { code: "ne", name: "Nepali", nativeName: "नेपाली", flag: "🇳🇵", region: "Asia", countryCode: "NP" },
  { code: "si", name: "Sinhala", nativeName: "සිංහල", flag: "🇱🇰", region: "Asia", countryCode: "LK" },
  { code: "my", name: "Burmese", nativeName: "မြန်မာ", flag: "🇲🇲", region: "Asia", countryCode: "MM" },
  { code: "km", name: "Khmer", nativeName: "ខ្មែរ", flag: "🇰🇭", region: "Asia", countryCode: "KH" },
  { code: "lo", name: "Lao", nativeName: "ລາວ", flag: "🇱🇦", region: "Asia", countryCode: "LA" },
  { code: "ka", name: "Georgian", nativeName: "ქართული", flag: "🇬🇪", region: "Asia", countryCode: "GE" },
  { code: "hy", name: "Armenian", nativeName: "Հայերեն", flag: "🇦🇲", region: "Asia", countryCode: "AM" },
  { code: "az", name: "Azerbaijani", nativeName: "Azərbaycan", flag: "🇦🇿", region: "Asia", countryCode: "AZ" },
  { code: "kk", name: "Kazakh", nativeName: "Қазақ", flag: "🇰🇿", region: "Asia", countryCode: "KZ" },
  { code: "ky", name: "Kyrgyz", nativeName: "Кыргызча", flag: "🇰🇬", region: "Asia", countryCode: "KG" },
  { code: "uz", name: "Uzbek", nativeName: "Ozbek", flag: "🇺🇿", region: "Asia", countryCode: "UZ" },
  { code: "tk", name: "Turkmen", nativeName: "Türkmençe", flag: "🇹🇲", region: "Asia", countryCode: "TM" },
  { code: "tg", name: "Tajik", nativeName: "Тоҷикӣ", flag: "🇹🇯", region: "Asia", countryCode: "TJ" },
  { code: "mn", name: "Mongolian", nativeName: "Монгол", flag: "🇲🇳", region: "Asia", countryCode: "MN" },
  { code: "bo", name: "Tibetan", nativeName: "བོད་སྐད", flag: "🏴", region: "Asia", countryCode: "CN" },
  { code: "ug", name: "Uyghur", nativeName: "ئۇيغۇرچە", flag: "🇨🇳", rtl: true, region: "Asia", countryCode: "CN" },

  // ===== MOYEN-ORIENT & AFRIQUE DU NORD (20+ langues) =====
  { code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇲🇦", rtl: true, region: "MENA", countryCode: "MA" },
  { code: "fa", name: "Persian", nativeName: "فارسی", flag: "🇮🇷", rtl: true, region: "MENA", countryCode: "IR" },
  { code: "ku", name: "Kurdish", nativeName: "کوردی", flag: "🇮🇶", rtl: true, region: "MENA", countryCode: "IQ" },
  { code: "ps", name: "Pashto", nativeName: "پښتو", flag: "🇦🇫", rtl: true, region: "MENA", countryCode: "AF" },
  { code: "da-af", name: "Dari", nativeName: "دری", flag: "🇦🇫", rtl: true, region: "MENA", countryCode: "AF" },
  { code: "sd", name: "Sindhi", nativeName: "سنڌي", flag: "🇵🇰", rtl: true, region: "MENA", countryCode: "PK" },
  { code: "bal", name: "Balochi", nativeName: "بلۏچی", flag: "🇵🇰", rtl: true, region: "MENA", countryCode: "PK" },

  // ===== AFRIQUE (30+ langues) =====
  { code: "sw", name: "Swahili", nativeName: "Kiswahili", flag: "🇰🇪", region: "Africa", countryCode: "KE" },
  { code: "am", name: "Amharic", nativeName: "አማርኛ", flag: "🇪🇹", region: "Africa", countryCode: "ET" },
  { code: "yo", name: "Yoruba", nativeName: "Yorùbá", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "ig", name: "Igbo", nativeName: "Igbo", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "ha", name: "Hausa", nativeName: "Hausa", flag: "🇳🇬", region: "Africa", countryCode: "NG" },
  { code: "zu", name: "Zulu", nativeName: "isiZulu", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },
  { code: "xh", name: "Xhosa", nativeName: "isiXhosa", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },
  { code: "af", name: "Afrikaans", nativeName: "Afrikaans", flag: "🇿🇦", region: "Africa", countryCode: "ZA" },
  { code: "so", name: "Somali", nativeName: "Soomaali", flag: "🇸🇴", region: "Africa", countryCode: "SO" },
  { code: "om", name: "Oromo", nativeName: "Afaan Oromoo", flag: "🇪🇹", region: "Africa", countryCode: "ET" },
  { code: "ti", name: "Tigrinya", nativeName: "ትግርኛ", flag: "🇪🇷", region: "Africa", countryCode: "ER" },
  { code: "rw", name: "Kinyarwanda", nativeName: "Ikinyarwanda", flag: "🇷🇼", region: "Africa", countryCode: "RW" },
  { code: "rn", name: "Kirundi", nativeName: "Ikirundi", flag: "🇧🇮", region: "Africa", countryCode: "BI" },
  { code: "lg", name: "Luganda", nativeName: "Luganda", flag: "🇺🇬", region: "Africa", countryCode: "UG" },
  { code: "ak", name: "Akan", nativeName: "Akan", flag: "🇬🇭", region: "Africa", countryCode: "GH" },
  { code: "tw", name: "Twi", nativeName: "Twi", flag: "🇬🇭", region: "Africa", countryCode: "GH" },
  { code: "ff", name: "Fulah", nativeName: "Fulfulde", flag: "🇸🇳", region: "Africa", countryCode: "SN" },
  { code: "wo", name: "Wolof", nativeName: "Wolof", flag: "🇸🇳", region: "Africa", countryCode: "SN" },
  { code: "bm", name: "Bambara", nativeName: "Bamanankan", flag: "🇲🇱", region: "Africa", countryCode: "ML" },
  { code: "mg", name: "Malagasy", nativeName: "Malagasy", flag: "🇲🇬", region: "Africa", countryCode: "MG" },

  // ===== AMÉRIQUES (25+ langues) =====
  { code: "en-us", name: "English (US)", nativeName: "English (US)", flag: "🇺🇸", region: "Americas", countryCode: "US" },
  { code: "en-ca", name: "English (Canada)", nativeName: "English (Canada)", flag: "🇨🇦", region: "Americas", countryCode: "CA" },
  { code: "fr-ca", name: "French (Canada)", nativeName: "Français (Canada)", flag: "🇨🇦", region: "Americas", countryCode: "CA" },
  { code: "es-mx", name: "Spanish (Mexico)", nativeName: "Español (México)", flag: "🇲🇽", region: "Americas", countryCode: "MX" },
  { code: "es-ar", name: "Spanish (Argentina)", nativeName: "Español (Argentina)", flag: "🇦🇷", region: "Americas", countryCode: "AR" },
  { code: "es-co", name: "Spanish (Colombia)", nativeName: "Español (Colombia)", flag: "🇨🇴", region: "Americas", countryCode: "CO" },
  { code: "es-cl", name: "Spanish (Chile)", nativeName: "Español (Chile)", flag: "🇨🇱", region: "Americas", countryCode: "CL" },
  { code: "es-pe", name: "Spanish (Peru)", nativeName: "Español (Perú)", flag: "🇵🇪", region: "Americas", countryCode: "PE" },
  { code: "es-ve", name: "Spanish (Venezuela)", nativeName: "Español (Venezuela)", flag: "🇻🇪", region: "Americas", countryCode: "VE" },
  { code: "pt-br", name: "Portuguese (Brazil)", nativeName: "Português (Brasil)", flag: "🇧🇷", region: "Americas", countryCode: "BR" },
  { code: "qu", name: "Quechua", nativeName: "Runasimi", flag: "🇵🇪", region: "Americas", countryCode: "PE" },
  { code: "gn", name: "Guarani", nativeName: "Avañeẽ", flag: "🇵🇾", region: "Americas", countryCode: "PY" },
  { code: "ay", name: "Aymara", nativeName: "Aymar aru", flag: "🇧🇴", region: "Americas", countryCode: "BO" },
  { code: "ht", name: "Haitian Creole", nativeName: "Kreyòl Ayisyen", flag: "🇭🇹", region: "Americas", countryCode: "HT" },
  { code: "jv", name: "Javanese", nativeName: "Basa Jawa", flag: "🇮🇩", region: "Americas", countryCode: "SR" },

  // ===== OCÉANIE (10+ langues) =====
  { code: "en-au", name: "English (Australia)", nativeName: "English (Australia)", flag: "🇦🇺", region: "Oceania", countryCode: "AU" },
  { code: "en-nz", name: "English (New Zealand)", nativeName: "English (New Zealand)", flag: "🇳🇿", region: "Oceania", countryCode: "NZ" },
  { code: "mi", name: "Māori", nativeName: "Te Reo Māori", flag: "🇳🇿", region: "Oceania", countryCode: "NZ" },
  { code: "haw", name: "Hawaiian", nativeName: "ʻŌlelo Hawaiʻi", flag: "🇺🇸", region: "Oceania", countryCode: "US" },
  { code: "sm", name: "Samoan", nativeName: "Gagana Sāmoa", flag: "🇼🇸", region: "Oceania", countryCode: "WS" },
  { code: "to", name: "Tongan", nativeName: "Lea Fakatonga", flag: "🇹🇴", region: "Oceania", countryCode: "TO" },
  { code: "fj", name: "Fijian", nativeName: "Na Vosa Vakaviti", flag: "🇫🇯", region: "Oceania", countryCode: "FJ" },
  { code: "ty", name: "Tahitian", nativeName: "Reo Tahiti", flag: "🇵🇫", region: "Oceania", countryCode: "PF" },
  { code: "gil", name: "Gilbertese", nativeName: "Taetae ni Kiribati", flag: "🇰🇮", region: "Oceania", countryCode: "KI" },
  { code: "na", name: "Nauruan", nativeName: "Dorerin Naoero", flag: "🇳🇷", region: "Oceania", countryCode: "NR" }
]

export const REGIONS = ["Europe", "Asia", "MENA", "Africa", "Americas", "Oceania"]

export const getLanguagesByRegion = (region: string) => 
  WORLD_LANGUAGES.filter(lang => lang.region === region)

export const getLanguageByCode = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)

export const isRTLLanguage = (code: string) => 
  WORLD_LANGUAGES.find(lang => lang.code === code)?.rtl || false

export const getTotalLanguages = () => WORLD_LANGUAGES.length

// Statistiques par région
export const getLanguageStats = () => {
  const stats = REGIONS.map(region => ({
    region,
    count: getLanguagesByRegion(region).length,
    languages: getLanguagesByRegion(region).map(lang => lang.nativeName)
  }))
  
  return {
    total: getTotalLanguages(),
    regions: stats,
    rtlLanguages: WORLD_LANGUAGES.filter(lang => lang.rtl).length
  }
}'

# 2. Traductions enrichies mondiales
create_file "src/lib/translations/worldTranslations.ts" '// Système de traductions ultra-complet pour Math4Child
export const TRANSLATIONS = {
  fr: {
    // Navigation et interface
    title: "Math4Child - Apprendre les maths en s'\''amusant !",
    subtitle: "L'\''application révolutionnaire qui transforme l'\''apprentissage des mathématiques en aventure ludique pour les enfants de 6 à 12 ans",
    startAdventure: "Commencer l'\''Aventure",
    viewPlans: "Voir les Plans",
    signIn: "Se connecter",
    signUp: "S'\''inscrire",
    freeTrial: "Essai Gratuit",
    
    // Fonctionnalités principales
    exercises: "Exercices",
    games: "Jeux",
    dashboard: "Tableau de bord",
    pricing: "Plans",
    profile: "Profil",
    progress: "Progression",
    achievements: "Réussites",
    certificates: "Certificats",
    
    // Niveaux et opérations
    level: "Niveau",
    levels: "Niveaux",
    beginner: "Débutant",
    elementary: "Élémentaire",
    intermediate: "Intermédiaire",
    advanced: "Avancé",
    expert: "Expert",
    addition: "Addition",
    subtraction: "Soustraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixte",
    
    // Interface utilisateur
    whyMath4Child: "Pourquoi Math4Child ?",
    features: "Fonctionnalités",
    adaptiveAI: "IA Adaptative",
    multiLanguage: "195+ Langues",
    gamification: "Gamification",
    familyMode: "Mode Famille",
    parentalControl: "Contrôle Parental",
    
    // Plans et pricing
    freeWeek: "1 semaine gratuite",
    monthly: "Mensuel",
    quarterly: "Trimestriel", 
    annual: "Annuel",
    mostPopular: "Le plus populaire",
    bestValue: "Meilleure valeur",
    save: "Économisez",
    childProfiles: "profils enfant",
    unlimitedQuestions: "Questions illimitées",
    allLevels: "Tous les niveaux",
    prioritySupport: "Support prioritaire",
    
    // Messages système
    correctAnswer: "Bonne réponse !",
    wrongAnswer: "Essayez encore !",
    levelCompleted: "Niveau terminé !",
    congratulations: "Félicitations !",
    tryAgain: "Réessayer",
    nextLevel: "Niveau suivant",
    backToMenu: "Retour au menu",
    
    // Footer et contact
    developedBy: "Développé par GOTEST",
    contact: "Contact",
    support: "Support",
    privacy: "Confidentialité",
    terms: "Conditions",
    
    // Descriptions détaillées
    adaptiveAIDesc: "Notre IA s'\''adapte intelligemment au niveau de chaque enfant",
    multiLanguageDesc: "Support multilingue complet avec RTL automatique",
    gamificationDesc: "Système de récompenses pour maintenir l'\''engagement",
    familyModeDesc: "Jusqu'\''à 10 profils enfants avec suivi parental complet"
  },
  
  en: {
    // Navigation et interface
    title: "Math4Child - Learn math while having fun!",
    subtitle: "The revolutionary app that transforms mathematics learning into a fun adventure for children aged 6 to 12",
    startAdventure: "Start Adventure",
    viewPlans: "View Plans",
    signIn: "Sign In",
    signUp: "Sign Up",
    freeTrial: "Free Trial",
    
    // Fonctionnalités principales
    exercises: "Exercises",
    games: "Games",
    dashboard: "Dashboard",
    pricing: "Plans",
    profile: "Profile",
    progress: "Progress",
    achievements: "Achievements",
    certificates: "Certificates",
    
    // Niveaux et opérations
    level: "Level",
    levels: "Levels",
    beginner: "Beginner",
    elementary: "Elementary",
    intermediate: "Intermediate",
    advanced: "Advanced",
    expert: "Expert",
    addition: "Addition",
    subtraction: "Subtraction",
    multiplication: "Multiplication",
    division: "Division",
    mixed: "Mixed",
    
    // Interface utilisateur
    whyMath4Child: "Why Math4Child?",
    features: "Features",
    adaptiveAI: "Adaptive AI",
    multiLanguage: "195+ Languages",
    gamification: "Gamification",
    familyMode: "Family Mode",
    parentalControl: "Parental Control",
    
    // Plans et pricing
    freeWeek: "1 week free",
    monthly: "Monthly",
    quarterly: "Quarterly",
    annual: "Annual",
    mostPopular: "Most popular",
    bestValue: "Best value",
    save: "Save",
    childProfiles: "child profiles",
    unlimitedQuestions: "Unlimited questions",
    allLevels: "All levels",
    prioritySupport: "Priority support",
    
    // Messages système
    correctAnswer: "Correct answer!",
    wrongAnswer: "Try again!",
    levelCompleted: "Level completed!",
    congratulations: "Congratulations!",
    tryAgain: "Try again",
    nextLevel: "Next level",
    backToMenu: "Back to menu",
    
    // Footer et contact
    developedBy: "Developed by GOTEST",
    contact: "Contact",
    support: "Support",
    privacy: "Privacy",
    terms: "Terms",
    
    // Descriptions détaillées
    adaptiveAIDesc: "Our AI intelligently adapts to each child'\''s level",
    multiLanguageDesc: "Complete multilingual support with automatic RTL",
    gamificationDesc: "Reward system to maintain engagement",
    familyModeDesc: "Up to 10 child profiles with complete parental tracking"
  },
  
  ar: {
    // Navigation et interface
    title: "Math4Child - تعلم الرياضيات بالمتعة!",
    subtitle: "التطبيق الثوري الذي يحول تعلم الرياضيات إلى مغامرة ممتعة للأطفال من سن 6 إلى 12 سنة",
    startAdventure: "ابدأ المغامرة",
    viewPlans: "عرض الخطط",
    signIn: "تسجيل الدخول",
    signUp: "إنشاء حساب",
    freeTrial: "تجربة مجانية",
    
    // Fonctionnalités principales
    exercises: "التمارين",
    games: "الألعاب",
    dashboard: "لوحة التحكم",
    pricing: "الخطط",
    profile: "الملف الشخصي",
    progress: "التقدم",
    achievements: "الإنجازات",
    certificates: "الشهادات",
    
    // Niveaux et opérations
    level: "المستوى",
    levels: "المستويات",
    beginner: "مبتدئ",
    elementary: "أساسي",
    intermediate: "متوسط",
    advanced: "متقدم",
    expert: "خبير",
    addition: "الجمع",
    subtraction: "الطرح",
    multiplication: "الضرب",
    division: "القسمة",
    mixed: "مختلط",
    
    // Interface utilisateur
    whyMath4Child: "لماذا Math4Child؟",
    features: "المميزات",
    adaptiveAI: "ذكاء اصطناعي تكيفي",
    multiLanguage: "195+ لغة",
    gamification: "التلعيب",
    familyMode: "وضع العائلة",
    parentalControl: "مراقبة الوالدين",
    
    // Plans et pricing
    freeWeek: "أسبوع مجاني",
    monthly: "شهري",
    quarterly: "فصلي",
    annual: "سنوي",
    mostPopular: "الأكثر شعبية",
    bestValue: "أفضل قيمة",
    save: "وفر",
    childProfiles: "ملفات الأطفال",
    unlimitedQuestions: "أسئلة غير محدودة",
    allLevels: "جميع المستويات",
    prioritySupport: "دعم أولوية",
    
    // Messages système
    correctAnswer: "إجابة صحيحة!",
    wrongAnswer: "حاول مرة أخرى!",
    levelCompleted: "تم إكمال المستوى!",
    congratulations: "تهانينا!",
    tryAgain: "حاول مرة أخرى",
    nextLevel: "المستوى التالي",
    backToMenu: "العودة للقائمة",
    
    // Footer et contact
    developedBy: "مطور من قبل GOTEST",
    contact: "اتصل",
    support: "الدعم",
    privacy: "الخصوصية",
    terms: "الشروط",
    
    // Descriptions détaillées
    adaptiveAIDesc: "يتكيف الذكاء الاصطناعي بذكاء مع مستوى كل طفل",
    multiLanguageDesc: "دعم متعدد اللغات مع RTL التلقائي",
    gamificationDesc: "نظام مكافآت للحفاظ على المشاركة",
    familyModeDesc: "حتى 10 ملفات أطفال مع تتبع كامل للوالدين"
  },
  
  // Ajouter plus de langues...
  es: {
    title: "Math4Child - ¡Aprende matemáticas divirtiéndote!",
    subtitle: "La aplicación revolucionaria que transforma el aprendizaje de matemáticas en aventura divertida",
    startAdventure: "Comenzar Aventura",
    viewPlans: "Ver Planes",
    whyMath4Child: "¿Por qué Math4Child?",
    adaptiveAI: "IA Adaptativa",
    multiLanguage: "195+ Idiomas"
  },
  
  de: {
    title: "Math4Child - Mathe lernen mit Spaß!",
    subtitle: "Die revolutionäre App, die das Mathematiklernen in ein lustiges Abenteuer verwandelt",
    startAdventure: "Abenteuer beginnen",
    viewPlans: "Pläne ansehen",
    whyMath4Child: "Warum Math4Child?",
    adaptiveAI: "Adaptive KI",
    multiLanguage: "195+ Sprachen"
  },
  
  zh: {
    title: "Math4Child - 快乐学数学！",
    subtitle: "革命性应用程序，将数学学习转变为有趣的冒险",
    startAdventure: "开始冒险",
    viewPlans: "查看计划",
    whyMath4Child: "为什么选择Math4Child？",
    adaptiveAI: "自适应AI",
    multiLanguage: "195+种语言"
  },
  
  ja: {
    title: "Math4Child - 楽しく数学を学ぼう！",
    subtitle: "数学学習を楽しい冒険に変える革命的なアプリ",
    startAdventure: "冒険を始める",
    viewPlans: "プランを見る",
    whyMath4Child: "なぜMath4Child？",
    adaptiveAI: "適応AI",
    multiLanguage: "195+言語"
  }
}

export const getTranslation = (language: string, key: string): string => {
  const keys = key.split(".")
  let value: any = TRANSLATIONS[language as keyof typeof TRANSLATIONS] || TRANSLATIONS.fr
  
  for (const k of keys) {
    value = value?.[k]
  }
  
  return value || key
}

export const getSupportedTranslationLanguages = () => Object.keys(TRANSLATIONS)
export const getTranslationStats = () => ({
  supportedLanguages: getSupportedTranslationLanguages().length,
  totalKeys: Object.keys(TRANSLATIONS.fr).length
})'

# ===================================================================
# 📄 ÉTAPE 3: SYSTÈME DE NIVEAUX ET PROGRESSION
# ===================================================================

print_step "ÉTAPE 3: SYSTÈME DE NIVEAUX ET PROGRESSION"

# Données des 5 niveaux avec progression
create_file "src/data/levels/levelConfig.ts" '// Configuration des 5 niveaux de progression Math4Child
export interface LevelConfig {
  id: number
  name: string
  nameTranslationKey: string
  description: string
  requiredCorrectAnswers: number
  operations: MathOperation[]
  numberRange: { min: number; max: number }
  hasNegatives: boolean
  hasDecimals: boolean
  timeLimit?: number // en secondes
  minAccuracy: number // pourcentage minimum pour validation
  unlockLevel?: number // niveau requis pour débloquer
  badge: string
  color: string
  rewards: {
    points: number
    certificates: string[]
    unlocks: string[]
  }
}

export type MathOperation = "addition" | "subtraction" | "multiplication" | "division" | "mixed"

export const LEVEL_CONFIGS: LevelConfig[] = [
  {
    id: 1,
    name: "Débutant",
    nameTranslationKey: "beginner",
    description: "Premiers pas avec les nombres simples",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction"],
    numberRange: { min: 1, max: 10 },
    hasNegatives: false,
    hasDecimals: false,
    minAccuracy: 70,
    badge: "🌟",
    color: "from-green-400 to-green-600",
    rewards: {
      points: 100,
      certificates: ["first_steps"],
      unlocks: ["level_2"]
    }
  },
  {
    id: 2,
    name: "Élémentaire", 
    nameTranslationKey: "elementary",
    description: "Introduction à la multiplication avec nombres moyens",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction", "multiplication"],
    numberRange: { min: 1, max: 50 },
    hasNegatives: false,
    hasDecimals: false,
    unlockLevel: 1,
    minAccuracy: 75,
    badge: "⭐",
    color: "from-blue-400 to-blue-600",
    rewards: {
      points: 200,
      certificates: ["elementary_master"],
      unlocks: ["level_3", "mixed_operations"]
    }
  },
  {
    id: 3,
    name: "Intermédiaire",
    nameTranslationKey: "intermediate", 
    description: "Division et opérations avec nombres plus grands",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction", "multiplication", "division"],
    numberRange: { min: 1, max: 100 },
    hasNegatives: false,
    hasDecimals: true,
    unlockLevel: 2,
    timeLimit: 60,
    minAccuracy: 80,
    badge: "🏆",
    color: "from-purple-400 to-purple-600",
    rewards: {
      points: 300,
      certificates: ["intermediate_champion"],
      unlocks: ["level_4", "decimal_operations", "timer_mode"]
    }
  },
  {
    id: 4,
    name: "Avancé",
    nameTranslationKey: "advanced",
    description: "Nombres négatifs et opérations complexes",
    requiredCorrectAnswers: 100,
    operations: ["addition", "subtraction", "multiplication", "division", "mixed"],
    numberRange: { min: -100, max: 200 },
    hasNegatives: true,
    hasDecimals: true,
    unlockLevel: 3,
    timeLimit: 45,
    minAccuracy: 85,
    badge: "💎",
    color: "from-orange-400 to-red-600",
    rewards: {
      points: 500,
      certificates: ["advanced_mathematician"],
      unlocks: ["level_5", "negative_numbers", "mixed_advanced"]
    }
  },
  {
    id: 5,
    name: "Expert",
    nameTranslationKey: "expert",
    description: "Maître des mathématiques - défis ultimes",
    requiredCorrectAnswers: 100,
    operations: ["mixed"],
    numberRange: { min: -500, max: 1000 },
    hasNegatives: true,
    hasDecimals: true,
    unlockLevel: 4,
    timeLimit: 30,
    minAccuracy: 90,
    badge: "👑",
    color: "from-yellow-400 to-yellow-600",
    rewards: {
      points: 1000,
      certificates: ["math_expert", "grand_master"],
      unlocks: ["expert_challenges", "leaderboard"]
    }
  }
]

export const getLevelById = (id: number) => LEVEL_CONFIGS.find(level => level.id === id)
export const getNextLevel = (currentLevel: number) => LEVEL_CONFIGS.find(level => level.id === currentLevel + 1)
export const isLevelUnlocked = (levelId: number, completedLevels: number[]) => {
  const level = getLevelById(levelId)
  if (!level) return false
  if (levelId === 1) return true
  return level.unlockLevel ? completedLevels.includes(level.unlockLevel) : true
}

export const calculateLevelProgress = (correctAnswers: number, level: LevelConfig) => {
  return Math.min(100, (correctAnswers / level.requiredCorrectAnswers) * 100)
}

export const getTotalPointsForLevel = (level: LevelConfig) => level.rewards.points
export const getTotalRequiredAnswers = () => LEVEL_CONFIGS.reduce((sum, level) => sum + level.requiredCorrectAnswers, 0)'

# ===================================================================
# 📄 ÉTAPE 4: GÉNÉRATEUR DE QUESTIONS MATHÉMATIQUES IA
# ===================================================================

print_step "ÉTAPE 4: GÉNÉRATEUR DE QUESTIONS IA"

create_file "src/lib/math/questionGenerator.ts" '// Générateur de questions mathématiques IA adaptatif
import { LevelConfig, MathOperation } from "@/data/levels/levelConfig"

export interface MathQuestion {
  id: string
  level: number
  operation: MathOperation
  operationSymbol: string
  question: string
  expression: string
  correctAnswer: number
  options: number[]
  difficulty: "easy" | "medium" | "hard"
  points: number
  timeLimit?: number
  hint?: string
  explanation?: string
}

export interface QuestionStats {
  totalQuestions: number
  correctAnswers: number
  wrongAnswers: number
  averageTime: number
  accuracy: number
  strongOperations: MathOperation[]
  weakOperations: MathOperation[]
}

export class MathQuestionGenerator {
  private difficultyAdjustment: number = 0
  private playerStats: QuestionStats
  
  constructor() {
    this.playerStats = {
      totalQuestions: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      averageTime: 0,
      accuracy: 0,
      strongOperations: [],
      weakOperations: []
    }
  }

  generateQuestion(levelConfig: LevelConfig, preferredOperation?: MathOperation): MathQuestion {
    const operation = preferredOperation || this.selectAdaptiveOperation(levelConfig)
    const difficulty = this.calculateDifficulty()
    
    let a: number, b: number, answer: number, symbol: string
    
    // Générer les nombres selon le niveau
    const range = levelConfig.numberRange
    
    switch (operation) {
      case "addition":
        a = this.generateNumber(range, difficulty)
        b = this.generateNumber(range, difficulty)
        answer = a + b
        symbol = "+"
        break
        
      case "subtraction":
        a = this.generateNumber(range, difficulty)
        b = this.generateNumber(range, difficulty)
        // S'\''assurer que le résultat est positif si les négatifs ne sont pas autorisés
        if (!levelConfig.hasNegatives && b > a) {
          [a, b] = [b, a]
        }
        answer = a - b
        symbol = "-"
        break
        
      case "multiplication":
        a = this.generateNumber({ min: range.min, max: Math.min(range.max, 12) }, difficulty)
        b = this.generateNumber({ min: range.min, max: Math.min(range.max, 12) }, difficulty)
        answer = a * b
        symbol = "×"
        break
        
      case "division":
        // Générer d'\''abord le résultat, puis le diviseur
        answer = this.generateNumber({ min: 1, max: Math.min(range.max, 20) }, difficulty)
        b = this.generateNumber({ min: 1, max: Math.min(range.max, 12) }, difficulty)
        a = answer * b
        symbol = "÷"
        break
        
      case "mixed":
        return this.generateQuestion(levelConfig, this.getRandomOperation(levelConfig.operations))
        
      default:
        throw new Error(`Opération non supportée: ${operation}`)
    }

    const question = `${a} ${symbol} ${b} = ?`
    const expression = `${a} ${symbol} ${b}`
    const options = this.generateOptions(answer, difficulty, levelConfig.hasDecimals)
    
    return {
      id: this.generateQuestionId(),
      level: levelConfig.id,
      operation,
      operationSymbol: symbol,
      question,
      expression,
      correctAnswer: answer,
      options,
      difficulty,
      points: this.calculatePoints(levelConfig, difficulty),
      timeLimit: levelConfig.timeLimit,
      hint: this.generateHint(operation, a, b),
      explanation: this.generateExplanation(operation, a, b, answer)
    }
  }

  private generateNumber(range: { min: number; max: number }, difficulty: "easy" | "medium" | "hard"): number {
    let adjustedRange = { ...range }
    
    // Ajuster la plage selon la difficulté
    switch (difficulty) {
      case "easy":
        adjustedRange.max = Math.min(range.max, Math.floor(range.max * 0.6))
        break
      case "medium":
        adjustedRange.min = Math.floor(range.min + (range.max - range.min) * 0.3)
        adjustedRange.max = Math.floor(range.max * 0.8)
        break
      case "hard":
        adjustedRange.min = Math.floor(range.min + (range.max - range.min) * 0.5)
        break
    }
    
    return Math.floor(Math.random() * (adjustedRange.max - adjustedRange.min + 1)) + adjustedRange.min
  }

  private generateOptions(correct: number, difficulty: string, hasDecimals: boolean): number[] {
    const options = [correct]
    const variance = difficulty === "easy" ? 5 : difficulty === "medium" ? 10 : 20
    
    while (options.length < 4) {
      const offset = Math.floor(Math.random() * variance * 2) - variance
      if (offset === 0) continue
      
      const option = correct + offset
      if (!options.includes(option) && (hasDecimals || Number.isInteger(option))) {
        options.push(option)
      }
    }
    
    return options.sort(() => Math.random() - 0.5)
  }

  private selectAdaptiveOperation(levelConfig: LevelConfig): MathOperation {
    const availableOps = levelConfig.operations.filter(op => op !== "mixed")
    
    // Privilégier les opérations faibles pour améliorer les compétences
    if (this.playerStats.weakOperations.length > 0) {
      const weakOps = availableOps.filter(op => 
        this.playerStats.weakOperations.includes(op)
      )
      if (weakOps.length > 0) {
        return weakOps[Math.floor(Math.random() * weakOps.length)]
      }
    }
    
    return availableOps[Math.floor(Math.random() * availableOps.length)]
  }

  private getRandomOperation(operations: MathOperation[]): MathOperation {
    const nonMixed = operations.filter(op => op !== "mixed")
    return nonMixed[Math.floor(Math.random() * nonMixed.length)]
  }

  private calculateDifficulty(): "easy" | "medium" | "hard" {
    if (this.playerStats.accuracy >= 90) return "hard"
    if (this.playerStats.accuracy >= 75) return "medium"
    return "easy"
  }

  private calculatePoints(levelConfig: LevelConfig, difficulty: string): number {
    const basePoints = levelConfig.id * 10
    const difficultyMultiplier = difficulty === "easy" ? 1 : difficulty === "medium" ? 1.5 : 2
    return Math.floor(basePoints * difficultyMultiplier)
  }

  private generateQuestionId(): string {
    return `q_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  }

  private generateHint(operation: MathOperation, a: number, b: number): string {
    switch (operation) {
      case "addition":
        return `Conseil: Comptez en partant de ${Math.max(a, b)}`
      case "subtraction":
        return `Conseil: Comptez à rebours depuis ${a}`
      case "multiplication":
        return `Conseil: ${a} groupes de ${b}`
      case "division":
        return `Conseil: Combien de fois ${b} entre dans ${a}?`
      default:
        return "Prenez votre temps pour réfléchir!"
    }
  }

  private generateExplanation(operation: MathOperation, a: number, b: number, answer: number): string {
    switch (operation) {
      case "addition":
        return `${a} + ${b} = ${answer} car nous ajoutons ${b} à ${a}`
      case "subtraction":
        return `${a} - ${b} = ${answer} car nous retirons ${b} de ${a}`
      case "multiplication":
        return `${a} × ${b} = ${answer} car nous répétons ${a} exactement ${b} fois`
      case "division":
        return `${a} ÷ ${b} = ${answer} car ${b} fois ${answer} égale ${a}`
      default:
        return `La réponse est ${answer}`
    }
  }

  updateStats(correct: boolean, operation: MathOperation, timeSpent: number): void {
    this.playerStats.totalQuestions++
    
    if (correct) {
      this.playerStats.correctAnswers++
    } else {
      this.playerStats.wrongAnswers++
    }
    
    this.playerStats.accuracy = (this.playerStats.correctAnswers / this.playerStats.totalQuestions) * 100
    this.playerStats.averageTime = (this.playerStats.averageTime + timeSpent) / 2
    
    // Mettre à jour les opérations fortes/faibles
    this.updateOperationStrengths(operation, correct)
  }

  private updateOperationStrengths(operation: MathOperation, correct: boolean): void {
    if (correct) {
      if (!this.playerStats.strongOperations.includes(operation)) {
        this.playerStats.strongOperations.push(operation)
      }
      // Retirer des opérations faibles
      this.playerStats.weakOperations = this.playerStats.weakOperations.filter(op => op !== operation)
    } else {
      if (!this.playerStats.weakOperations.includes(operation)) {
        this.playerStats.weakOperations.push(operation)
      }
      // Retirer des opérations fortes
      this.playerStats.strongOperations = this.playerStats.strongOperations.filter(op => op !== operation)
    }
  }

  getPlayerStats(): QuestionStats {
    return { ...this.playerStats }
  }

  resetStats(): void {
    this.playerStats = {
      totalQuestions: 0,
      correctAnswers: 0,
      wrongAnswers: 0,
      averageTime: 0,
      accuracy: 0,
      strongOperations: [],
      weakOperations: []
    }
  }
}

export const mathGenerator = new MathQuestionGenerator()'

# ===================================================================
# 📄 ÉTAPE 5: SYSTÈME DE PRICING ADAPTATIF MONDIAL
# ===================================================================

print_step "ÉTAPE 5: SYSTÈME DE PRICING ADAPTATIF MONDIAL"

# Pricing adaptatif par pays avec pouvoir d'achat
create_file "src/data/pricing/adaptivePricing.ts" '// Système de pricing adaptatif selon le pouvoir d'\''achat mondial
export interface CountryPricing {
  country: string
  countryName: string
  currency: string
  symbol: string
  flag: string
  purchasingPowerIndex: number // Base 1.0 = France/Europe
  prices: {
    freeWeek: number
    monthly: number
    quarterly: number
    annual: number
  }
  discounts: {
    quarterly: number // pourcentage
    annual: number // pourcentage
    secondDevice: number // pourcentage
    thirdDevice: number // pourcentage
  }
  paymentMethods: string[]
  taxRate: number
}

export const GLOBAL_PRICING: CountryPricing[] = [
  // EUROPE - Référence (pouvoir d'\''achat 1.0)
  {
    country: "FR", countryName: "France", currency: "EUR", symbol: "€", flag: "🇫🇷",
    purchasingPowerIndex: 1.0,
    prices: { freeWeek: 0, monthly: 9.99, quarterly: 26.97, annual: 83.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "sepa"],
    taxRate: 0.20
  },
  {
    country: "DE", countryName: "Germany", currency: "EUR", symbol: "€", flag: "🇩🇪",
    purchasingPowerIndex: 1.05,
    prices: { freeWeek: 0, monthly: 10.49, quarterly: 28.32, annual: 88.12 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "sepa", "sofort"],
    taxRate: 0.19
  },
  {
    country: "GB", countryName: "United Kingdom", currency: "GBP", symbol: "£", flag: "🇬🇧",
    purchasingPowerIndex: 0.95,
    prices: { freeWeek: 0, monthly: 8.99, quarterly: 24.27, annual: 75.54 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay"],
    taxRate: 0.20
  },
  {
    country: "ES", countryName: "Spain", currency: "EUR", symbol: "€", flag: "🇪🇸",
    purchasingPowerIndex: 0.85,
    prices: { freeWeek: 0, monthly: 8.49, quarterly: 22.92, annual: 71.34 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "sepa"],
    taxRate: 0.21
  },
  {
    country: "IT", countryName: "Italy", currency: "EUR", symbol: "€", flag: "🇮🇹",
    purchasingPowerIndex: 0.90,
    prices: { freeWeek: 0, monthly: 8.99, quarterly: 24.27, annual: 75.54 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "sepa"],
    taxRate: 0.22
  },

  // AMÉRIQUES
  {
    country: "US", countryName: "United States", currency: "USD", symbol: "$", flag: "🇺🇸",
    purchasingPowerIndex: 1.10,
    prices: { freeWeek: 0, monthly: 10.99, quarterly: 29.67, annual: 92.32 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "venmo"],
    taxRate: 0.08
  },
  {
    country: "CA", countryName: "Canada", currency: "CAD", symbol: "C$", flag: "🇨🇦",
    purchasingPowerIndex: 0.95,
    prices: { freeWeek: 0, monthly: 12.99, quarterly: 35.07, annual: 109.13 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay"],
    taxRate: 0.15
  },
  {
    country: "BR", countryName: "Brazil", currency: "BRL", symbol: "R$", flag: "🇧🇷",
    purchasingPowerIndex: 0.35,
    prices: { freeWeek: 0, monthly: 17.99, quarterly: 48.57, annual: 151.13 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "pix", "boleto"],
    taxRate: 0.20
  },
  {
    country: "MX", countryName: "Mexico", currency: "MXN", symbol: "$", flag: "🇲🇽",
    purchasingPowerIndex: 0.45,
    prices: { freeWeek: 0, monthly: 99.99, quarterly: 269.97, annual: 839.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "oxxo", "spei"],
    taxRate: 0.16
  },

  // ASIE
  {
    country: "JP", countryName: "Japan", currency: "JPY", symbol: "¥", flag: "🇯🇵",
    purchasingPowerIndex: 0.85,
    prices: { freeWeek: 0, monthly: 1149, quarterly: 3102, annual: 9653 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay", "konbini"],
    taxRate: 0.10
  },
  {
    country: "CN", countryName: "China", currency: "CNY", symbol: "¥", flag: "🇨🇳",
    purchasingPowerIndex: 0.45,
    prices: { freeWeek: 0, monthly: 32.99, quarterly: 89.07, annual: 277.13 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["alipay", "wechat_pay", "unionpay"],
    taxRate: 0.13
  },
  {
    country: "IN", countryName: "India", currency: "INR", symbol: "₹", flag: "🇮🇳",
    purchasingPowerIndex: 0.25,
    prices: { freeWeek: 0, monthly: 199, quarterly: 537, annual: 1671 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["razorpay", "paytm", "upi", "netbanking"],
    taxRate: 0.18
  },
  {
    country: "KR", countryName: "South Korea", currency: "KRW", symbol: "₩", flag: "🇰🇷",
    purchasingPowerIndex: 0.75,
    prices: { freeWeek: 0, monthly: 11990, quarterly: 32373, annual: 100723 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "kakao_pay", "naver_pay"],
    taxRate: 0.10
  },

  // MOYEN-ORIENT & AFRIQUE
  {
    country: "AE", countryName: "UAE", currency: "AED", symbol: "د.إ", flag: "🇦🇪",
    purchasingPowerIndex: 1.15,
    prices: { freeWeek: 0, monthly: 42.99, quarterly: 116.07, annual: 361.13 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay"],
    taxRate: 0.05
  },
  {
    country: "SA", countryName: "Saudi Arabia", currency: "SAR", symbol: "ر.س", flag: "🇸🇦",
    purchasingPowerIndex: 0.80,
    prices: { freeWeek: 0, monthly: 29.99, quarterly: 80.97, annual: 251.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "stc_pay", "mada"],
    taxRate: 0.15
  },
  {
    country: "EG", countryName: "Egypt", currency: "EGP", symbol: "ج.م", flag: "🇪🇬",
    purchasingPowerIndex: 0.20,
    prices: { freeWeek: 0, monthly: 199.99, quarterly: 539.97, annual: 1679.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["fawry", "paypal", "vodafone_cash"],
    taxRate: 0.14
  },
  {
    country: "MA", countryName: "Morocco", currency: "MAD", symbol: "د.م", flag: "🇲🇦",
    purchasingPowerIndex: 0.30,
    prices: { freeWeek: 0, monthly: 99.99, quarterly: 269.97, annual: 839.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["paypal", "cmi", "orange_money"],
    taxRate: 0.20
  },

  // AFRIQUE SUBSAHARIENNE
  {
    country: "NG", countryName: "Nigeria", currency: "NGN", symbol: "₦", flag: "🇳🇬",
    purchasingPowerIndex: 0.15,
    prices: { freeWeek: 0, monthly: 2999, quarterly: 8097, annual: 25193 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["paystack", "flutterwave", "bank_transfer"],
    taxRate: 0.075
  },
  {
    country: "ZA", countryName: "South Africa", currency: "ZAR", symbol: "R", flag: "🇿🇦",
    purchasingPowerIndex: 0.40,
    prices: { freeWeek: 0, monthly: 149.99, quarterly: 404.97, annual: 1259.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["paypal", "ozow", "eft"],
    taxRate: 0.15
  },

  // OCÉANIE
  {
    country: "AU", countryName: "Australia", currency: "AUD", symbol: "A$", flag: "🇦🇺",
    purchasingPowerIndex: 0.90,
    prices: { freeWeek: 0, monthly: 14.99, quarterly: 40.47, annual: 125.93 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay"],
    taxRate: 0.10
  },
  {
    country: "NZ", countryName: "New Zealand", currency: "NZD", symbol: "NZ$", flag: "🇳🇿",
    purchasingPowerIndex: 0.85,
    prices: { freeWeek: 0, monthly: 15.99, quarterly: 43.17, annual: 134.33 },
    discounts: { quarterly: 10, annual: 30, secondDevice: 50, thirdDevice: 75 },
    paymentMethods: ["stripe", "paypal", "apple_pay", "google_pay"],
    taxRate: 0.15
  }
]

export const getPricingForCountry = (countryCode: string): CountryPricing => {
  return GLOBAL_PRICING.find(p => p.country === countryCode) || GLOBAL_PRICING[0]
}

export const formatPrice = (amount: number, currency: string, symbol: string): string => {
  // Monnaies sans décimales
  if (["JPY", "KRW", "VND", "IDR", "CLP", "PYG", "UGX", "RWF"].includes(currency)) {
    return `${symbol}${Math.round(amount).toLocaleString()}`
  }
  
  // Monnaies avec 3 décimales
  if (["KWD", "BHD", "OMR"].includes(currency)) {
    return `${symbol}${amount.toFixed(3)}`
  }
  
  // Monnaies standard avec 2 décimales
  return `${symbol}${amount.toFixed(2)}`
}

export const calculateDiscountedPrice = (basePrice: number, discountPercent: number): number => {
  return basePrice * (1 - discountPercent / 100)
}

export const getDevicePricingTier = (deviceCount: number): number => {
  switch (deviceCount) {
    case 1: return 0 // Prix plein
    case 2: return 50 // 50% de réduction
    case 3: return 75 // 75% de réduction
    default: return 85 // 85% de réduction pour 4+ appareils
  }
}

export const calculateTotalPrice = (pricing: CountryPricing, plan: "monthly" | "quarterly" | "annual", deviceCount: number = 1): number => {
  let basePrice = pricing.prices[plan]
  
  // Appliquer la réduction du plan (trimestriel/annuel)
  if (plan === "quarterly") {
    basePrice = calculateDiscountedPrice(pricing.prices.monthly * 3, pricing.discounts.quarterly)
  } else if (plan === "annual") {
    basePrice = calculateDiscountedPrice(pricing.prices.monthly * 12, pricing.discounts.annual)
  }
  
  // Appliquer la réduction multi-device
  if (deviceCount > 1) {
    const deviceDiscount = getDevicePricingTier(deviceCount)
    basePrice = calculateDiscountedPrice(basePrice, deviceDiscount)
  }
  
  // Ajouter les taxes
  return basePrice * (1 + pricing.taxRate)
}

export const getSavingsAmount = (pricing: CountryPricing, plan: "quarterly" | "annual"): number => {
  const monthlyTotal = pricing.prices.monthly * (plan === "quarterly" ? 3 : 12)
  const planPrice = pricing.prices[plan]
  return monthlyTotal - planPrice
}

export const getSavingsPercentage = (pricing: CountryPricing, plan: "quarterly" | "annual"): number => {
  return plan === "quarterly" ? pricing.discounts.quarterly : pricing.discounts.annual
}

// Plans d'\''abonnement avec profils
export interface SubscriptionPlan {
  id: string
  name: string
  nameKey: string
  duration: "week" | "month" | "quarter" | "year"
  profilesIncluded: number
  features: string[]
  popular?: boolean
  bestValue?: boolean
}

export const SUBSCRIPTION_PLANS: SubscriptionPlan[] = [
  {
    id: "free_week",
    name: "Découverte",
    nameKey: "freeWeek",
    duration: "week",
    profilesIncluded: 1,
    features: [
      "7 jours gratuits",
      "50 questions par jour max",
      "Niveaux 1-2 uniquement",
      "1 profil enfant",
      "Accès web uniquement"
    ]
  },
  {
    id: "monthly",
    name: "Famille",
    nameKey: "monthly",
    duration: "month", 
    profilesIncluded: 5,
    popular: true,
    features: [
      "Questions illimitées",
      "Tous les 5 niveaux",
      "5 profils enfants",
      "Toutes plateformes",
      "Suivi parental complet",
      "Support prioritaire",
      "Certificats de réussite"
    ]
  },
  {
    id: "quarterly",
    name: "Famille Plus", 
    nameKey: "quarterly",
    duration: "quarter",
    profilesIncluded: 7,
    features: [
      "Tout du plan Famille",
      "7 profils enfants", 
      "10% d'\''économie",
      "Mode hors-ligne",
      "Rapports avancés",
      "Défis exclusifs"
    ]
  },
  {
    id: "annual",
    name: "Premium",
    nameKey: "annual", 
    duration: "year",
    profilesIncluded: 10,
    bestValue: true,
    features: [
      "Tout du plan Famille Plus",
      "10 profils enfants",
      "30% d'\''économie",
      "IA coaching personnalisé",
      "Support téléphonique",
      "Accès beta features",
      "Mode tournoi"
    ]
  }
]

export const getPlanById = (planId: string) => SUBSCRIPTION_PLANS.find(plan => plan.id === planId)

export const getRecommendedPlan = (childrenCount: number): SubscriptionPlan => {
  if (childrenCount <= 1) return SUBSCRIPTION_PLANS.find(p => p.id === "monthly")!
  if (childrenCount <= 5) return SUBSCRIPTION_PLANS.find(p => p.id === "quarterly")!
  return SUBSCRIPTION_PLANS.find(p => p.id === "annual")!
}'

# ===================================================================
# 📄 ÉTAPE 6: SYSTÈME D'AUTHENTIFICATION ET PROFILS
# ===================================================================

print_step "ÉTAPE 6: SYSTÈME D'AUTHENTIFICATION ET PROFILS"

create_file "src/lib/auth/userTypes.ts" '// Types pour le système d'\''authentification et profils utilisateur
export interface User {
  id: string
  email: string
  name: string
  avatar?: string
  createdAt: Date
  lastActive: Date
  subscription: UserSubscription
  preferences: UserPreferences
  children: ChildProfile[]
  deviceLicenses: DeviceLicense[]
}

export interface ChildProfile {
  id: string
  name: string
  age: number
  avatar?: string
  createdAt: Date
  parentId: string
  currentLevel: number
  completedLevels: number[]
  stats: ChildStats
  preferences: ChildPreferences
  achievements: Achievement[]
  certificates: Certificate[]
}

export interface ChildStats {
  totalQuestions: number
  correctAnswers: number
  wrongAnswers: number
  accuracy: number
  averageTime: number
  totalTimeSpent: number // en minutes
  currentStreak: number
  bestStreak: number
  totalPoints: number
  weakOperations: string[]
  strongOperations: string[]
  progressByLevel: { [level: number]: LevelProgress }
}

export interface LevelProgress {
  level: number
  correctAnswers: number
  requiredAnswers: number
  isCompleted: boolean
  timeSpent: number
  accuracy: number
  completedAt?: Date
}

export interface Achievement {
  id: string
  type: string
  name: string
  description: string
  icon: string
  unlockedAt: Date
  progress: number
  maxProgress: number
}

export interface Certificate {
  id: string
  name: string
  description: string
  level: number
  earnedAt: Date
  childId: string
  templateUrl: string
}

export interface UserSubscription {
  id: string
  plan: string
  status: "active" | "cancelled" | "expired" | "trial"
  startDate: Date
  endDate: Date
  renewalDate?: Date
  paymentMethod: string
  amount: number
  currency: string
  country: string
}

export interface DeviceLicense {
  id: string
  deviceType: "web" | "ios" | "android"
  deviceId: string
  deviceName: string
  activatedAt: Date
  lastUsed: Date
  discountApplied: number
}

export interface UserPreferences {
  language: string
  theme: "light" | "dark" | "auto"
  notifications: {
    email: boolean
    push: boolean
    progress: boolean
    achievements: boolean
    reminders: boolean
  }
  privacy: {
    analytics: boolean
    marketing: boolean
    dataSharing: boolean
  }
}

export interface ChildPreferences {
  preferredOperations: string[]
  difficultyPreference: "adaptive" | "easy" | "medium" | "hard"
  timeLimit: boolean
  hintsEnabled: boolean
  soundEnabled: boolean
  animationsEnabled: boolean
}

// Comptes de test pour les 5 niveaux
export const TEST_ACCOUNTS = [
  {
    email: "test.niveau1@math4child.com",
    password: "Math4Child2024!",
    name: "Test Niveau 1",
    level: 1,
    description: "Compte test pour niveau débutant"
  },
  {
    email: "test.niveau2@math4child.com", 
    password: "Math4Child2024!",
    name: "Test Niveau 2",
    level: 2,
    description: "Compte test pour niveau élémentaire"
  },
  {
    email: "test.niveau3@math4child.com",
    password: "Math4Child2024!",
    name: "Test Niveau 3", 
    level: 3,
    description: "Compte test pour niveau intermédiaire"
  },
  {
    email: "test.niveau4@math4child.com",
    password: "Math4Child2024!",
    name: "Test Niveau 4",
    level: 4,
    description: "Compte test pour niveau avancé"
  },
  {
    email: "test.niveau5@math4child.com",
    password: "Math4Child2024!",
    name: "Test Niveau 5",
    level: 5,
    description: "Compte test pour niveau expert"
  },
  {
    email: "admin@math4child.com",
    password: "Admin2024!",
    name: "Administrateur",
    level: 5,
    description: "Compte administrateur avec tous les accès"
  }
]'

# ===================================================================
# 📄 ÉTAPE 7: HOOKS AVANCÉS ET COMPOSANTS UI
# ===================================================================

print_step "ÉTAPE 7: HOOKS AVANCÉS ET COMPOSANTS UI"

# Hook useLanguage corrigé et enrichi
create_file "src/hooks/useLanguage.ts" '"use client"

import { createContext, useContext, useState, useEffect, ReactNode } from "react"
import { WORLD_LANGUAGES, isRTLLanguage, getTotalLanguages } from "@/data/languages/worldLanguages"
import { getTranslation, getSupportedTranslationLanguages } from "@/lib/translations/worldTranslations"

interface LanguageContextType {
  language: string
  setLanguage: (lang: string) => void
  t: (key: string) => string
  isRTL: boolean
  availableLanguages: typeof WORLD_LANGUAGES
  currentLanguageInfo: typeof WORLD_LANGUAGES[0] | undefined
  totalLanguages: number
  supportedTranslationLanguages: string[]
  translateLanguageNames: boolean
  setTranslateLanguageNames: (translate: boolean) => void
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined)

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [language, setLanguageState] = useState("fr")
  const [isRTL, setIsRTL] = useState(false)
  const [translateLanguageNames, setTranslateLanguageNames] = useState(true)

  useEffect(() => {
    if (typeof navigator !== "undefined") {
      // Détecter la langue du navigateur
      const browserLang = navigator.language.split("-")[0]
      const supportedLang = WORLD_LANGUAGES.find(lang => 
        lang.code.startsWith(browserLang)
      )?.code || "fr"
      
      // Charger la langue sauvegardée ou utiliser celle du navigateur
      const savedLanguage = localStorage.getItem("math4child-language")
      const finalLanguage = savedLanguage || supportedLang
      
      setLanguageState(finalLanguage)
      setIsRTL(isRTLLanguage(finalLanguage))
      
      // Appliquer les changements DOM
      updateDocumentLanguage(finalLanguage)
    }
  }, [])

  const updateDocumentLanguage = (lang: string) => {
    if (typeof document !== "undefined") {
      const rtl = isRTLLanguage(lang)
      document.documentElement.dir = rtl ? "rtl" : "ltr"
      document.documentElement.lang = lang
      
      // Mettre à jour le titre de la page
      document.title = getTranslation(lang, "title")
    }
  }

  const setLanguage = (lang: string) => {
    setLanguageState(lang)
    const rtl = isRTLLanguage(lang)
    setIsRTL(rtl)
    
    updateDocumentLanguage(lang)
    
    if (typeof window !== "undefined") {
      localStorage.setItem("math4child-language", lang)
    }
  }

  const t = (key: string): string => {
    return getTranslation(language, key)
  }

  const currentLanguageInfo = WORLD_LANGUAGES.find(lang => lang.code === language)

  const contextValue: LanguageContextType = {
    language,
    setLanguage,
    t,
    isRTL,
    availableLanguages: WORLD_LANGUAGES,
    currentLanguageInfo,
    totalLanguages: getTotalLanguages(),
    supportedTranslationLanguages: getSupportedTranslationLanguages(),
    translateLanguageNames,
    setTranslateLanguageNames
  }

  return (
    <LanguageContext.Provider value={contextValue}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (context === undefined) {
    throw new Error("useLanguage must be used within a LanguageProvider")
  }
  return context
}'

# Sélecteur de langues enrichi avec recherche
create_file "src/components/language/LanguageSelector.tsx" '"use client"

import { useState, useRef, useEffect } from "react"
import { ChevronDown, Globe, Search, X } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import { getLanguagesByRegion, REGIONS } from "@/data/languages/worldLanguages"

export default function LanguageSelector() {
  const { 
    language, 
    setLanguage, 
    availableLanguages, 
    currentLanguageInfo,
    totalLanguages,
    t,
    translateLanguageNames
  } = useLanguage()
  
  const [isOpen, setIsOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedRegion, setSelectedRegion] = useState<string>("all")
  const dropdownRef = useRef<HTMLDivElement>(null)
  const searchInputRef = useRef<HTMLInputElement>(null)

  // Fermer le dropdown au clic extérieur
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
        setIsOpen(false)
        setSearchTerm("")
      }
    }
    
    document.addEventListener("mousedown", handleClickOutside)
    return () => document.removeEventListener("mousedown", handleClickOutside)
  }, [])

  // Focus sur la recherche à l'\''ouverture
  useEffect(() => {
    if (isOpen && searchInputRef.current) {
      searchInputRef.current.focus()
    }
  }, [isOpen])

  // Filtrer les langues
  const filteredLanguages = availableLanguages.filter(lang => {
    const matchesSearch = !searchTerm || 
      lang.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.nativeName.toLowerCase().includes(searchTerm.toLowerCase()) ||
      lang.code.toLowerCase().includes(searchTerm.toLowerCase())
    
    const matchesRegion = selectedRegion === "all" || lang.region === selectedRegion
    
    return matchesSearch && matchesRegion
  })

  // Grouper par région
  const languagesByRegion = selectedRegion === "all" 
    ? REGIONS.reduce((acc, region) => {
        acc[region] = filteredLanguages.filter(lang => lang.region === region)
        return acc
      }, {} as Record<string, typeof availableLanguages>)
    : { [selectedRegion]: filteredLanguages }

  const handleLanguageSelect = (langCode: string) => {
    setLanguage(langCode)
    setIsOpen(false)
    setSearchTerm("")
  }

  return (
    <div className="relative" ref={dropdownRef}>
      <button
        onClick={() => setIsOpen(!isOpen)}
        className="flex items-center gap-3 bg-white hover:bg-gray-50 border border-gray-300 rounded-xl px-4 py-3 font-medium transition-all duration-200 shadow-sm hover:shadow-md min-w-[280px] group"
      >
        <Globe className="w-5 h-5 text-blue-600" />
        <span className="text-2xl">{currentLanguageInfo?.flag}</span>
        <div className="flex-1 text-left">
          <div className="font-semibold text-gray-900">
            {translateLanguageNames ? t("currentLanguage") : currentLanguageInfo?.nativeName}
          </div>
          <div className="text-sm text-gray-500">
            {currentLanguageInfo?.name} • {currentLanguageInfo?.region}
          </div>
        </div>
        <div className="text-xs text-gray-400">
          {totalLanguages}+ langues
        </div>
        <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform group-hover:text-gray-600 ${isOpen ? "rotate-180" : ""}`} />
      </button>

      {isOpen && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-gray-200 rounded-xl shadow-2xl z-50 max-h-96 overflow-hidden">
          {/* Header avec recherche */}
          <div className="p-4 border-b border-gray-100 bg-gray-50">
            <div className="relative mb-3">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                ref={searchInputRef}
                type="text"
                placeholder="Rechercher une langue..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-8 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              {searchTerm && (
                <button
                  onClick={() => setSearchTerm("")}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-4 h-4" />
                </button>
              )}
            </div>
            
            {/* Filtres par région */}
            <div className="flex flex-wrap gap-1">
              <button
                onClick={() => setSelectedRegion("all")}
                className={`px-3 py-1 text-xs rounded-full transition-colors ${
                  selectedRegion === "all"
                    ? "bg-blue-100 text-blue-700 font-medium"
                    : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                }`}
              >
                Toutes ({totalLanguages})
              </button>
              {REGIONS.map(region => {
                const count = getLanguagesByRegion(region).length
                return (
                  <button
                    key={region}
                    onClick={() => setSelectedRegion(region)}
                    className={`px-3 py-1 text-xs rounded-full transition-colors ${
                      selectedRegion === region
                        ? "bg-blue-100 text-blue-700 font-medium"
                        : "bg-gray-100 text-gray-600 hover:bg-gray-200"
                    }`}
                  >
                    {region} ({count})
                  </button>
                )
              })}
            </div>
          </div>

          {/* Liste des langues */}
          <div className="max-h-64 overflow-y-auto">
            {Object.entries(languagesByRegion).map(([region, languages]) => (
              languages.length > 0 && (
                <div key={region}>
                  {selectedRegion === "all" && (
                    <div className="px-4 py-2 text-xs font-semibold text-gray-500 bg-gray-50 border-b border-gray-100">
                      {region} ({languages.length})
                    </div>
                  )}
                  {languages.map((lang) => (
                    <button
                      key={lang.code}
                      onClick={() => handleLanguageSelect(lang.code)}
                      className={`w-full flex items-center gap-3 px-4 py-3 hover:bg-blue-50 transition-all text-left border-b border-gray-50 last:border-b-0 ${
                        lang.code === language ? "bg-blue-100 border-r-4 border-blue-600" : ""
                      }`}
                    >
                      <span className="text-2xl">{lang.flag}</span>
                      <div className="flex-1 min-w-0">
                        <div className="font-semibold text-gray-900 truncate">
                          {lang.nativeName}
                        </div>
                        <div className="text-sm text-gray-500 truncate">
                          {lang.name} • {lang.region}
                          {lang.rtl && <span className="ml-1 text-xs bg-orange-100 text-orange-700 px-1 rounded">RTL</span>}
                        </div>
                      </div>
                      {lang.code === language && (
                        <div className="w-2 h-2 bg-blue-600 rounded-full"></div>
                      )}
                    </button>
                  ))}
                </div>
              )
            ))}
            
            {filteredLanguages.length === 0 && (
              <div className="p-8 text-center text-gray-500">
                <Globe className="w-8 h-8 mx-auto mb-2 text-gray-300" />
                <p>Aucune langue trouvée</p>
                <p className="text-xs">Essayez un autre terme de recherche</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  )
}'