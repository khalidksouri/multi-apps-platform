# 📱 Guide de Déploiement Capacitor Corrigé

## ✅ Corrections apportées

### 1. Configuration Next.js
- ✅ AssetPrefix corrigé : `'./'` en production Capacitor
- ✅ Export statique configuré correctement
- ✅ Webpack fallbacks pour erreurs de dépendances

### 2. Configuration Capacitor  
- ✅ Fichier JSON au lieu de TypeScript (résout erreur init)
- ✅ Configuration Android/iOS optimisée
- ✅ Safe areas et keyboard handling

### 3. Scripts de build
- ✅ Variables d'environnement `CAPACITOR_BUILD=true`
- ✅ Scripts séparés pour dev/build/release
- ✅ Live reload fonctionnel

## 🚀 Déploiement rapide

### 🤖 Android
```bash
# Première fois
npm run cap:add:android

# Development avec live reload
npm run android:dev

# Build pour release
npm run android:release
```

### 🍎 iOS (macOS requis)
```bash
# Première fois  
npm run cap:add:ios

# Development avec live reload
npm run ios:dev

# Build pour release
npm run ios:release
```

## 🧪 Tests Playwright
```bash
npm run test              # Tous les tests
npm run test:mobile       # Tests mobile uniquement
npm run test:capacitor    # Tests spécifiques Capacitor
```

## 🔧 Résolution des problèmes

### Si erreur "assetPrefix must start with leading slash"
```bash
rm -rf .next out
CAPACITOR_BUILD=true npm run build:capacitor
```

### Si erreur Capacitor init
```bash
rm capacitor.config.ts  # Supprimer l'ancien fichier TS
npx cap sync
```

### Si problème de dépendances Node.js
```bash
# Passer à Node.js 20+
nvm install 20
nvm use 20
npm install
```

## 📱 Configuration GOTEST maintenue
- ✅ App ID: com.gotest.math4child  
- ✅ SIRET: 53958712100028
- ✅ Navigation native + web responsive
- ✅ PWA avec manifest.json
- ✅ Tests multi-plateforme

## 🎯 Prochaines étapes
1. `npm run android:dev` - Test Android
2. `npm run ios:dev` - Test iOS (macOS)
3. `npm run test` - Lancer les tests
4. Publication sur stores avec Capacitor
