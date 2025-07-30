# 🧮 Math4Child - Application Éducative Mathématiques

## 📋 Vue d'ensemble

**Math4Child** est une application éducative Next.js innovante pour l'apprentissage des mathématiques, conçue spécialement pour les enfants. L'application propose un système d'internationalisation complet avec support de **20 langues exactement**, incluant un support RTL natif pour les langues arabes.

## ✨ Fonctionnalités principales

### 🌍 Système multilingue avancé
- **20 langues supportées exactement** (selon spécifications)
- **Support RTL natif** pour l'arabe, l'hébreu et le persan
- **Persistance automatique** de la langue sélectionnée
- **Détection de la langue du navigateur**
- **Traductions complètes** de toute l'interface

### 🧮 Contenu éducatif mathématique
- **4 opérations de base** : Addition, Soustraction, Multiplication, Division
- **5 niveaux de difficulté** : Débutant, Intermédiaire, Avancé, Expert, Maître
- **Interface ludique et interactive**
- **Suivi des progrès et statistiques**

### 🔧 Architecture technique
- **Next.js 14** avec TypeScript
- **Tailwind CSS** pour le design responsive
- **Tests Playwright** pour la qualité
- **Support PWA** (Progressive Web App)
- **Performance optimisée** < 3s de chargement

## 🌍 Langues supportées (20 exactement)

### Europe/Amérique (8 langues)
- 🇫🇷 Français (fr) - *Langue principale*
- 🇺🇸 Anglais (en)
- 🇪🇸 Espagnol (es)
- 🇩🇪 Allemand (de)
- 🇮🇹 Italien (it)
- 🇵🇹 Portugais (pt)
- 🇳🇱 Néerlandais (nl)
- 🇷🇺 Russe (ru)

### Asie (6 langues)
- 🇨🇳 Chinois (zh)
- 🇯🇵 Japonais (ja)
- 🇰🇷 Coréen (ko)
- 🇮🇳 Hindi (hi)
- 🇹🇭 Thaï (th)
- 🇻🇳 Vietnamien (vi)

### MENA - Support RTL (3 langues)
- 🇸🇦 Arabe (ar) **RTL**
- 🇮🇱 Hébreu (he) **RTL**
- 🇮🇷 Persan (fa) **RTL**

### Nordique/Autres (3 langues)
- 🇸🇪 Suédois (sv)
- 🇹🇷 Turc (tr)
- 🇵🇱 Polonais (pl)

**Total : 20 langues (3 RTL + 17 LTR)**

## 🚀 Installation et démarrage

### Prérequis
- Node.js 18+
- npm ou yarn

### Installation
```bash
# Cloner le repository
git clone https://github.com/khalidksouri/multi-apps-platform.git
cd multi-apps-platform

# Installer les dépendances
npm install

# Démarrer Math4Child
cd apps/math4child
npm run dev
```

### Accès à l'application
- **URL locale** : http://localhost:3001
- **Port** : 3001 (spécifique à Math4Child)

## 🧪 Tests et qualité

### Tests Playwright
```bash
# Tests multilingues complets
npm run test

# Tests spécifiques RTL
npm run test:rtl

# Tests de performance
npm run test:perf
```

### Couverture de tests
- ✅ **Interface multilingue** - Toutes les 20 langues
- ✅ **Support RTL** - Arabe, Hébreu, Persan
- ✅ **Persistance** - Langue sauvegardée
- ✅ **Responsive** - Mobile et desktop
- ✅ **Performance** - Temps de chargement < 3s

## 📁 Structure du projet

```
apps/math4child/
├── src/
│   ├── app/
│   │   ├── layout.tsx          # Layout principal avec metadata
│   │   ├── page.tsx            # Page d'accueil multilingue
│   │   └── globals.css         # Styles avec support RTL
│   ├── hooks/
│   │   └── LanguageContext.tsx # Context React pour les langues
│   ├── types/
│   │   └── translations.ts     # Types TypeScript
│   ├── translations.ts         # Traductions des 20 langues
│   └── language-config.ts      # Configuration des langues
├── tests/
│   └── multilingual.spec.ts    # Tests Playwright
├── playwright.config.ts        # Configuration Playwright
├── package.json               # Dependencies et scripts
└── README.md                  # Documentation spécifique
```

## 🎯 Scripts disponibles

```bash
# Développement
npm run dev              # Démarrer en mode développement (port 3001)
npm run build           # Build de production
npm run start           # Démarrer en production
npm run lint            # Linter ESLint

# Tests
npm run test            # Tests Playwright
npm run test:ui         # Interface de tests Playwright
npm run type-check      # Vérification TypeScript

# Qualité
npm run analyze         # Analyse du bundle
npm run lighthouse      # Tests de performance
```

## 🔧 Configuration technique

### Environment
```bash
# .env.local
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_VERSION=2.0.0
NEXT_PUBLIC_SUPPORTED_LANGUAGES=20
NEXT_PUBLIC_RTL_SUPPORT=true
```

### TypeScript
- Configuration stricte avec types personnalisés
- Support des traductions typées
- Validation des 20 langues à la compilation

### Performance
- **First Contentful Paint** : < 1.5s
- **Time to Interactive** : < 3s
- **Cumulative Layout Shift** : < 0.1
- **Largest Contentful Paint** : < 2.5s

## 🌐 Déploiement

### Production
```bash
# Build optimisé
npm run build

# Démarrage production
npm run start
```

### Vercel (recommandé)
```bash
# Deploy automatique via GitHub
vercel --prod
```

### Docker
```bash
# Build de l'image
docker build -t math4child .

# Lancement du container
docker run -p 3001:3001 math4child
```

## 📊 Métriques et analytics

### Support des langues en temps réel
- Statistiques d'utilisation par langue
- Taux d'adoption des nouvelles langues
- Performance par région géographique

### Métriques éducatives
- Temps moyen par exercice
- Taux de réussite par niveau
- Progression des utilisateurs

## 🤝 Contribution

### Ajouter une nouvelle langue
1. Modifier `SUPPORTED_LANGUAGES` dans `language-config.ts`
2. Ajouter les traductions dans `translations.ts`
3. Tester avec Playwright
4. Mettre à jour la documentation

### Standards de code
- ESLint + Prettier configurés
- Convention de commits : `feat:`, `fix:`, `docs:`
- Tests obligatoires pour nouvelles fonctionnalités

## 📞 Support et contact

- **Développeur** : Khalid Ksouri
- **Email** : khalid_ksouri@yahoo.fr
- **GitHub** : https://github.com/khalidksouri/multi-apps-platform
- **Issues** : https://github.com/khalidksouri/multi-apps-platform/issues

## 📄 Licence

MIT License - Voir le fichier `LICENSE` pour plus de détails.

## 🎉 Roadmap

### Version 2.1 (Q2 2025)
- [ ] Mode hors ligne (PWA avancé)
- [ ] Synchronisation cloud des progrès
- [ ] Nouvelles langues : Indonésien, Bengali
- [ ] Mode collaboratif multi-joueurs

### Version 2.2 (Q3 2025)
- [ ] Intelligence artificielle pour adaptation
- [ ] Réalité augmentée pour visualisation
- [ ] API publique pour intégrations
- [ ] Analytics avancés

---

**Math4Child v2.0.0** - Application éducative de référence pour l'apprentissage des mathématiques en famille 🧮

Développé avec ❤️ par Khalid Ksouri | Support de 20 langues | RTL natif | Tests automatisés
