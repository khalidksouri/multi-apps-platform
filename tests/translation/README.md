# 🌐 Tests de Traduction - Math4Child

Ce dossier contient tous les tests automatisés pour détecter les erreurs de traduction.

## 🚀 Utilisation rapide

```bash
# Lancer tous les tests de traduction
npm run test:translation

# Lancer avec interface graphique
npm run test:translation:ui

# Surveillant temps réel
npm run watch:translations

# Voir les rapports
npm run test:translation:report
```

## 📁 Structure

- `specs/` - Tests Playwright
- `utils/` - Utilitaires partagés
- `config/` - Configurations
- `reporters/` - Rapporteurs personnalisés

## 🔍 Erreurs détectées

- ✅ Textes français dans interfaces non-françaises
- ✅ Boutons non traduits
- ✅ Modales avec contenu incorrect
- ✅ Textes manquants ou vides

## 📊 Rapports

Les rapports sont générés dans `test-results/translation/` et `playwright-report/translation/`
