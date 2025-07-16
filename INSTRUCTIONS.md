# 🚀 Instructions d'utilisation des scripts AI4KIDS

## 📋 Scripts disponibles

### 1. Script de mise à jour rapide
```bash
./scripts/update_logo.sh
```
**Utilisation:** Déploiement rapide et automatique du nouveau logo

### 2. Script de déploiement maître
```bash
./scripts/deploy_master.sh
```
**Utilisation:** Interface interactive complète avec menu d'options

### 3. Scripts individuels
```bash
./scripts/create_components.sh    # Composants React uniquement
./scripts/create_assets.sh        # Assets et styles uniquement
./scripts/update_package.sh       # Configuration uniquement
```

## 🎯 Workflow recommandé

1. **Vérification préalable**
   ```bash
   node --version    # Vérifier Node.js >= 18
   npm --version     # Vérifier npm >= 9
   ```

2. **Sauvegarde (optionnel)**
   ```bash
   git add .
   git commit -m "Sauvegarde avant mise à jour logo"
   ```

3. **Déploiement**
   ```bash
   ./scripts/update_logo.sh
   ```

4. **Test**
   ```bash
   cd apps/ai4kids
   npm run dev
   ```

5. **Validation**
   - Ouvrir http://localhost:3004
   - Vérifier le nouveau logo
   - Tester la responsivité

## 🔧 Résolution de problèmes

### Erreur de permissions
```bash
chmod +x scripts/*.sh
```

### Erreur de dépendances
```bash
cd apps/ai4kids
rm -rf node_modules package-lock.json
npm install
```

### Rollback en cas de problème
```bash
./scripts/deploy_master.sh
# Choisir option 8 (Rollback)
```

## 📊 Fichiers générés

- **Composants:** `src/components/AI4KidsLogo.tsx`, `src/components/Header.tsx`
- **Styles:** `src/styles/ai4kids.css`
- **Assets:** `public/favicon.svg`, `public/site.webmanifest`
- **Config:** `package.json`, `tsconfig.json`, `tailwind.config.js`
- **Documentation:** `README.md` mis à jour

## 🆘 Support

En cas de problème, consultez les logs dans `scripts/deployment_*.log`
