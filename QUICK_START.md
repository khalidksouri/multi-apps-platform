# 🚀 Quick Start - Système de Traduction

## Installation terminée ! 🎉

### Prochaines étapes:

1. **Intégrer dans votre layout** :
```tsx
import { LanguageProvider } from '../src/contexts/LanguageContext'
import LanguageDropdown from '../src/components/language/LanguageDropdown'

export default function Layout({ children }) {
  return (
    <LanguageProvider>
      <header>
        <LanguageDropdown />
      </header>
      {children}
    </LanguageProvider>
  )
}
```

2. **Tester localement** :
```bash
npm run test:translation:quick
```

3. **Déployer** :
```bash
git add .
git commit -m "feat: add translation system"
git push origin main
```

### Liens utiles:
- 🌐 Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159
- 🧪 Tests: `npm run test:translation`
- 🏥 Santé: `./scripts/health-check.sh`
