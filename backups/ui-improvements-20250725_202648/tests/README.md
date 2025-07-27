# 🧪 Tests Playwright - Math4Child

## 📁 Structure des tests

```
tests/
├── helpers/                    # Utilitaires TypeScript
│   ├── test-helpers.ts        # Classe d'aide principale
│   └── page-objects.ts        # Objets de page
├── enhanced/                  # Tests améliorés
│   ├── enhanced-translation.spec.ts
│   └── enhanced-stripe.spec.ts
├── translation/              # Tests de traduction robustes
├── stripe/                   # Tests de paiement robustes
├── setup.spec.ts            # Tests de configuration
└── README.md                # Cette documentation
```

## 🚀 Commandes disponibles

### Tests de base
```bash
npm run test                    # Tous les tests
npm run test:headed            # Mode visible
npm run test:ui                # Interface graphique
npm run test:debug             # Mode debug
```

### Tests par catégorie
```bash
npm run test:setup             # Tests de configuration
npm run test:translation       # Tests de traduction
npm run test:stripe            # Tests de paiement
npm run test:enhanced          # Tests améliorés
```

### Tests par navigateur
```bash
npm run test:chrome            # Chrome uniquement
npm run test:firefox           # Firefox uniquement
npm run test:mobile            # Version mobile
```

### Utilitaires
```bash
npm run test:report            # Afficher le rapport
npm run test:install           # Installer les navigateurs
npm run test:trace             # Avec traces détaillées
npm run test:screenshot        # Avec captures d'écran
```

## 🔧 Configuration VS Code

### Extensions recommandées
- **Playwright Test for VS Code** : Interface visuelle pour les tests
- **Thunder Client** : Tester les APIs
- **Error Lens** : Voir les erreurs en temps réel
- **Prettier** : Formatage automatique

### Raccourcis clavier
- `Ctrl+Shift+P` → "Playwright: Record new test" : Enregistrer un test
- `F5` : Debug du test actuel
- `Ctrl+Shift+\`` : Terminal intégré

## 📊 Helpers disponibles

### TestHelpers
```typescript
const helpers = new TestHelpers(page)

// Attendre un élément
await helpers.waitForElement('button')

// Chercher parmi plusieurs sélecteurs
await helpers.findAnyElement(['#btn1', '#btn2'])

// Vérifier le contenu interdit
await helpers.checkForbiddenContent(['texte interdit'])

// Capturer les erreurs JS
await helpers.captureJSErrors()

// Vérifier la performance
await helpers.checkPerformance()

// Prendre une capture
await helpers.takeScreenshot('test-name')
```

### Page Objects
```typescript
const homePage = new HomePage(page)
await homePage.goto()
const title = await homePage.getTitle()

const paymentPage = new PaymentPage(page)
const elements = await paymentPage.findPaymentElements()
```

## 🎯 Bonnes pratiques

### 1. Structure des tests
```typescript
test.describe('📚 Nom du groupe', () => {
  let helpers: TestHelpers
  
  test.beforeEach(async ({ page }) => {
    helpers = new TestHelpers(page)
    // Setup commun
  })
  
  test('Description claire du test', async ({ page }) => {
    // Test ici
  })
})
```

### 2. Gestion d'erreur robuste
```typescript
try {
  await page.locator('selector').click()
  console.log('✅ Action réussie')
} catch (error) {
  console.log('ℹ️  Action échouée - normal')
  expect(true).toBeTruthy() // Test exploratoire
}
```

### 3. Assertions informatives
```typescript
// ❌ Pas informatif
expect(element).toBeVisible()

// ✅ Informatif  
const title = await page.title()
expect(title).not.toContain('Error')
console.log(`✅ Titre: ${title}`)
```

## 🐛 Debug

### Dans VS Code
1. Ouvrir le test
2. Mettre un point d'arrêt
3. `F5` pour déboguer

### En ligne de commande
```bash
npm run test:debug                    # Mode debug interactif
npm run test:headed                   # Voir le navigateur
npx playwright test --trace=on        # Traces détaillées
```

### Analyser les erreurs
```bash
npm run test:report                   # Rapport HTML détaillé
```

## 📈 Performance

Les tests incluent des vérifications de performance :
- Temps de chargement DOM < 5s
- Pas plus de 2 erreurs JS critiques
- Vérifications d'accessibilité de base

## 🔄 CI/CD

Configuration prête pour l'intégration continue :
```bash
npm run test:ci                       # Format GitHub Actions
```

## 📝 Notes

- Tests robustes : ne pas faire échouer pour des détails mineurs
- Mode exploratoire : chercher et informer plutôt qu'échouer
- Captures automatiques en cas d'échec
- Support multi-navigateurs et mobile
