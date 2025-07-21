# 🔧 Guide de Dépannage - Math4Child

## ❌ Problèmes Courants

### 1. Erreur Tailwind PostCSS
**Erreur** : `tailwindcss directly as a PostCSS plugin`

**Solution** :
```bash
npm install --save-dev @tailwindcss/postcss
```

### 2. Option Next.js dépréciée
**Erreur** : `Unrecognized key(s) in object: 'appDir'`

**Solution** : Mise à jour `next.config.js` (déjà corrigé)

### 3. Scripts manquants
**Erreur** : `Missing script: "test"`

**Solution** : Relancer le script de correction

### 4. Structure projet
**Problème** : Dossier `apps/math4child/`

**Solution** : Le script détecte automatiquement la structure

## ✅ Commandes de Validation

```bash
# Test build
npm run build

# Test développement
npm run dev

# Test Playwright
npm run test

# Build Capacitor
npm run build:capacitor
```

## 🚀 Status après corrections :

- ✅ Tailwind CSS configuré correctement
- ✅ Next.js 15 compatible
- ✅ PostCSS plugin mis à jour
- ✅ Scripts tests ajoutés
- ✅ Configuration Capacitor maintenue
- ✅ Structure projet organisée

## 📱 Déploiement toujours possible :

```bash
npm run android:build  # Android
npm run ios:build      # iOS
```

**Math4Child reste prêt pour la production !**
