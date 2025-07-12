
# multi-apps-platform
"🚀 Plateforme multi-applications : PostMath Pro, UnitFlip Pro, BudgetCron, AI4Kids et MultiAI Search


Une plateforme moderne hébergeant **5 applications** innovantes avec architecture monorepo, tests E2E complets et support multilingue (20 langues).

## 🎯 Applications

| Application | Port | Description | Status |
|-------------|------|-------------|--------|
| **PostMath Pro** | 3001 | Calcul de frais d'expédition intelligent | ✅ Ready |
| **UnitFlip Pro** | 3002 | Conversion d'unités avancée | ✅ Ready |
| **BudgetCron** | 3003 | Gestion budgétaire avec IA | ✅ Ready |
| **AI4Kids** | 3004 | IA éducative sécurisée pour enfants | ✅ Ready |
| **MultiAI Search** | 3005 | Recherche multi-IA comparative | ✅ Ready |

## ⚡ Démarrage Rapide

```bash
# Installation
git clone https://github.com/khalidksouri/multi-apps-platform.git
cd multi-apps-platform
npm install

# Configuration
cp .env.example .env
# Éditer .env avec vos configurations

# Démarrage développement
npm run dev

# Tests
npm run test:install
npm run test:e2e
```

## 🧪 Tests

- **292 scénarios BDD** avec Cucumber
- **156 tests unitaires** (85% couverture)
- **Tests E2E** Playwright multi-navigateurs
- **Tests de sécurité** et accessibilité
- **Tests de performance** < 3s

## 🌍 Internationalisation

Support complet de **20 langues** :
🇫🇷🇺🇸🇪🇸🇩🇪🇮🇹🇵🇹🇳🇱🇵🇱🇷🇺🇨🇳🇯🇵🇰🇷🇸🇦🇮🇳🇹🇷🇸🇪🇳🇴🇩🇰🇫🇮🇮🇱

## 📊 Architecture

```
multi-apps-platform/
├── apps/                 # Applications Next.js
│   ├── postmath/        # Calcul expédition
│   ├── unitflip/        # Conversion unités
│   ├── budgetcron/      # Gestion budget
│   ├── ai4kids/         # IA éducative
│   └── multiai/         # Recherche multi-IA
├── packages/            # Packages partagés
│   ├── ui/             # Composants UI
│   ├── shared/         # Utilitaires
│   ├── database/       # Gestion BDD
│   └── security/       # Sécurité
└── tests/              # Tests E2E
    ├── features/       # Scénarios BDD
    └── step-definitions/ # Steps Cucumber
```

## 🔒 Sécurité

- **Headers sécurisés** (CSP, X-Frame-Options)
- **Validation Zod** sur toutes les APIs
- **JWT sécurisé** avec refresh tokens
- **Protection enfants** pour AI4Kids
- **Tests de pénétration** automatisés

## 📈 Performance

- **Bundle splitting** et lazy loading
- **Core Web Vitals** optimisés
- **Caching intelligent** Redis + CDN
- **Monitoring** temps réel

## 🚀 Déploiement

- **Vercel/Netlify** ready
- **Docker** support
- **CI/CD** GitHub Actions
- **Monitoring** intégré

## 📚 Documentation

- [Guide Utilisateur](./docs/user-guide/)
- [Documentation API](./docs/api/)
- [Guide Développeur](./docs/developer/)

## 👥 Contribution

1. Fork le projet
2. Créer une feature branch (`git checkout -b feature/amazing-feature`)
3. Commit les changements (`git commit -m 'feat: add amazing feature'`)
4. Push la branch (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## 👨‍💻 Auteur

**Khalid Ksouri**
- Email: khalid_ksouri@yahoo.fr
- GitHub: [@khalid_ksouri](https://github.com/khalid_ksouri)

---

⭐ **N'hésitez pas à donner une étoile si ce projet vous plaît !**
>>>>>>> 264c288 (🚀 Initial commit: Multi-Apps Platform)
