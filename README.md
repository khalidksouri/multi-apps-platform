# 🌍 Math4Child - Application Éducative Multilingue

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/username/math4child)
[![Tests](https://img.shields.io/badge/tests-passing-green.svg)](https://github.com/username/math4child/actions)
[![Langues](https://img.shields.io/badge/langues-4-orange.svg)](#langues-supportées)

> 🎮 **Application éducative révolutionnaire** pour l'apprentissage des mathématiques (4-12 ans)  
> 🌐 **4 langues supportées** avec interface RTL complète  
> 🧪 **Suite de tests exhaustive** avec Playwright et TypeScript  

## 🌐 Langues Supportées

| Langue | Code | RTL | Statut |
|--------|------|-----|--------|
| 🇫🇷 Français | `fr` | Non | ✅ |
| 🇺🇸 English | `en` | Non | ✅ |
| 🇪🇸 Español | `es` | Non | ✅ |
| 🇸🇦 العربية | `ar` | **Oui** | ✅ |

## 🚀 Installation et Démarrage

```bash
# Installation complète
make install

# Démarrage du serveur
make dev
# → http://localhost:3000

# Tests rapides
make test-quick

# Tests multilingues
make test-translation

# Interface de tests
make test-ui
```

## 🧪 Tests

### Types de Tests
- **@smoke** : Tests critiques de base
- **@translation-final** : Tests multilingues complets
- **@critical** : Tests de fonctionnalité essentiels

### Commandes de Test
```bash
make test              # Tous les tests
make test-quick        # Tests rapides (@smoke)
make test-translation  # Tests multilingues
make test-ui           # Interface graphique
```

## 📁 Structure

```
math4child/
├── src/
│   ├── app/                    # Pages Next.js
│   └── lib/translations/       # Système de traduction
├── tests/
│   ├── specs/translation/      # Tests de traduction
│   └── utils/                  # Helpers de test
├── Makefile                    # Commandes simplifiées
├── playwright.config.ts        # Configuration Playwright
└── package.json               # Dépendances
```

## 🎯 Fonctionnalités

- ✅ **Interface multilingue** avec sélecteur de langue
- ✅ **Support RTL** pour l'arabe
- ✅ **Tests Playwright** robustes avec retry
- ✅ **Design responsive** Mobile/Desktop
- ✅ **Configuration TypeScript** stricte

---

**Math4Child** - *Rendre les mathématiques amusantes pour tous les enfants du monde* 🌍📚✨
