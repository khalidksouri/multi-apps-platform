# 🌍 Tests de Traduction Math4Child

## Vue d'ensemble

Système de tests complet pour valider les traductions multilingues de Math4Child avec fonctionnalité de recherche de langues.

## Fonctionnalités

### 🔍 Recherche de langues
- Recherche par début de nom (Fra → Français)
- Recherche par code langue (fr → Français)
- Navigation clavier complète
- Support caractères spéciaux

### 🧪 Tests stricts
- Validation de toutes les langues
- Tests des modaux traduits
- Vérification RTL
- Tests de persistance

## Utilisation

```bash
# Tous les tests de traduction
npm run test:translation

# Tests de recherche uniquement
npm run test:translation:search

# Script complet avec rapport
npm run test:translation:all

# Voir le rapport
npm run translation:report
```

## Structure

```
tests/translation/
├── translation-strict.spec.ts    # Tests principaux
├── language-search.spec.ts       # Tests de recherche
└── modal-translation.spec.ts     # Tests des modaux

src/components/language/
└── LanguageDropdown.tsx          # Composant avec recherche
```

## Langues testées

- Français (fr) 🇫🇷
- English (en) 🇺🇸  
- Español (es) 🇪🇸
- Deutsch (de) 🇩🇪
- العربية (ar) 🇸🇦 (RTL)
- 中文 (zh) 🇨🇳
- 日本語 (ja) 🇯🇵

## Recherche avancée

Le dropdown supporte:
- Recherche instantanée par saisie
- Navigation ↑↓ + Enter
- Tri par pertinence
- Effacement rapide (X)
- Focus automatique
- Support RTL complet
