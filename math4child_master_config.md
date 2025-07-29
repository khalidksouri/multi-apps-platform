# 🧮 MATH4CHILD - CONFIGURATION MAÎTRE (État Validé)

> **Document de référence central** - Mise à jour : 29 Juillet 2025, 13:30
> 
> **⚠️ IMPORTANT** : Ce document contient l'état exact et validé de l'application Math4Child. Toute modification doit être reportée ici.

## 🔄 **POLITIQUE DE GESTION CACHE (CRITIQUE)**

> **🚨 OBLIGATOIRE** : Cette procédure DOIT être appliquée avant toute modification de fichier

### Procédure Standard de Développement
```bash
# 1. TOUJOURS nettoyer le cache avant modification
cd apps/math4child
rm -rf .next node_modules/.cache out dist .swc

# 2. Redémarrer avec nouveau port
npm run dev -- -p $(shuf -i 3000-3010 -n 1)

# 3. Navigateur : mode incognito ou force reload (Cmd+Shift+R)
```

### Script de Nettoyage Automatique
```bash
#!/bin/bash
# clear-cache.sh - À créer dans le projet
pkill -f "next dev" 2>/dev/null || true
rm -rf .next node_modules/.cache out dist .swc
NEW_PORT=$(shuf -i 3000-3010 -n 1)
echo "🚀 Redémarrage sur port $NEW_PORT"
npm run dev -- -p $NEW_PORT
```

### Validation des Changements
- ✅ Fichiers modifiés : `head -5 src/app/page.tsx`
- ✅ Serveur compile : Vérifier logs
- ✅ Navigateur mis à jour : Mode incognito + force reload
- ✅ Tests multi-navigateurs si nécessaire

---

## 🎯 **INFORMATIONS GÉNÉRALES**

### Identité Projet
- **Nom** : Math4Child
- **Société** : GOTEST (SIRET: 53958712100028)
- **Contact** : khalid_ksouri@yahoo.fr
- **ID App** : com.gotest.math4child
- **Logo** : M4C (dégradé orange-rouge)

### Objectif
Application éducative révolutionnaire pour l'apprentissage des mathématiques chez les enfants de **4 à 12 ans** (Maternelle → CM2).

## 🏗️ **ARCHITECTURE TECHNIQUE VALIDÉE**

### Technologies
- **Framework** : Next.js 14.0.4 (App Router)
- **Language** : TypeScript
- **Styling** : TailwindCSS + CSS modules
- **Tests** : Playwright
- **Mobile** : Capacitor (iOS/Android)
- **Déploiement** : Vercel (web) + App Stores

### Structure Répertoires
```
apps/math4child/
├── clear-cache.sh               🆕 AJOUTÉ - Script nettoyage cache
├── dev-safe.sh                  🆕 AJOUTÉ - Développement sécurisé
├── validate-changes.sh          🆕 AJOUTÉ - Validation modifications
├── src/
│   ├── app/
│   │   ├── layout.tsx           ✅ VALIDÉ - Navigation intégrée
│   │   ├── page.tsx             🔄 EN COURS - Mise à jour niveaux 4-12 ans
│   │   ├── exercises/page.tsx   ✅ VALIDÉ - 5 niveaux (4-12 ans)
│   │   ├── subscription/page.tsx ✅ VALIDÉ - 4 plans + Écoles
│   │   ├── dashboard/page.tsx   ✅ VALIDÉ - Statistiques complètes
│   │   └── globals.css          ✅ VALIDÉ - TailwindCSS + RTL
│   ├── components/
│   │   └── navigation/
│   │       └── Navigation.tsx   ✅ VALIDÉ - Responsive + multilingue
│   └── contexts/
│       └── LanguageContext.tsx  ✅ VALIDÉ - 6 langues + RTL
├── tests/
│   └── navigation.spec.ts       ✅ VALIDÉ - Tests Playwright
├── package.json                 ✅ VALIDÉ - Scripts complets
├── tailwind.config.js           ✅ VALIDÉ - Configuration TailwindCSS
├── playwright.config.ts         ✅ VALIDÉ - Tests automatisés
└── next.config.js               ✅ VALIDÉ - Export statique
```

## 🧭 **NAVIGATION UNIFIÉE (VALIDÉE)**

### Header Fixe
- **Logo** : M4C (orange-rouge, hover scale)
- **Titre** : "Math4Child" + badge "100k+ familles"
- **Menu Desktop** : Accueil, Exercices, Abonnement, Tableau de bord
- **Menu Mobile** : Hamburger avec même contenu
- **Langues** : Dropdown avec 6 langues + RTL

### Pages Accessibles
1. **🏠 Accueil** (`/`) - Présentation + sélecteur âge (5 niveaux)
2. **🧮 Exercices** (`/exercises`) - 5 niveaux + 4 opérations
3. **💎 Abonnement** (`/subscription`) - 4 plans tarifaires
4. **📊 Tableau de bord** (`/dashboard`) - Statistiques et suivi

### Footer
- Informations Math4Child
- Liens : Confidentialité, Conditions, Contact, Aide
- Copyright 2024 + "100k+ familles font confiance"

## 🌍 **SYSTÈME MULTILINGUE (VALIDÉ)**

### Langues Supportées
1. **🇫🇷 Français** (par défaut)
2. **🇺🇸 English**
3. **🇪🇸 Español**
4. **🇲🇦 العربية** (RTL complet)
5. **🇩🇪 Deutsch**
6. **🇮🇹 Italiano**

### Fonctionnalités
- ✅ **Persistance** : localStorage ('math4child-language')
- ✅ **RTL** : Direction automatique pour l'arabe
- ✅ **Responsive** : Dropdown adaptatif
- ✅ **Navigation** : Traductions complètes du menu

## 🎮 **SYSTÈME D'EXERCICES (VALIDÉ)**

### 5 Niveaux pour 4-12 ans (SPECIFICATION CRITIQUE)
1. **🌱 Niveau 1** (4-5 ans) - Premiers nombres (1-10)
2. **🌿 Niveau 2** (6-7 ans) - Nombres jusqu'à 20
3. **🌳 Niveau 3** (8-9 ans) - Nombres jusqu'à 100
4. **🏔️ Niveau 4** (10-11 ans) - Nombres jusqu'à 1000
5. **🚀 Niveau 5** (12+ ans) - Nombres avancés

> **⚠️ IMPORTANT** : Pas de mention "Maternelle", "Primaire", "Collège", "Lycée" - Seulement "Niveau X (âge)" dans toute l'interface

### 4 Opérations
1. **Addition** (+) - 1250 exercices
2. **Soustraction** (-) - 980 exercices
3. **Multiplication** (×) - 870 exercices
4. **Division** (÷) - 640 exercices

### Fonctionnalités
- ✅ **Générateur automatique** selon niveau/opération
- ✅ **Système de score** (10 points par bonne réponse)
- ✅ **Feedback immédiat** avec émojis
- ✅ **Progression** : pas de négatifs, divisions exactes

## 💎 **SYSTÈME D'ABONNEMENT (VALIDÉ)**

### 4 Plans Tarifaires
1. **Découverte** (0€) - 5 exercices/jour, support email
2. **Premium** (9.99€/mois) - Illimité + toutes fonctionnalités
3. **Famille** (19.99€/mois) - Jusqu'à 6 profils enfants
4. **Écoles & Associations** (49.99€/mois) - Comptes illimités + gestion classe

### Fonctionnalités
- ✅ **Toggle mensuel/annuel** avec 20% d'économie
- ✅ **Plan populaire** mis en avant (Premium)
- ✅ **Section dédiée** institutions éducatives
- ✅ **Essai gratuit** 7 jours pour plans payants

## 📊 **TABLEAU DE BORD (VALIDÉ)**

### Statistiques Principales
- **Exercices complétés** : 156
- **Réponses correctes** : 134  
- **Série actuelle** : 7 jours
- **Temps total** : 240 minutes
- **Précision globale** : 86% (graphique circulaire)
- **Niveau actuel** : Intermédiaire

### Fonctionnalités
- ✅ **Activité récente** : tableau avec dates/opérations/performances
- ✅ **Graphiques** : précision en cercle, progression visuelle
- ✅ **Couleurs adaptées** : vert (bon), orange (moyen), rouge (faible)

## 🧪 **TESTS ET QUALITÉ (VALIDÉS)**

### Tests Playwright
- **Navigation** : Liens, langues, responsive
- **Exercices** : Sélection niveaux/opérations
- **Abonnement** : Plans, toggle pricing
- **Accessibilité** : Focus, ARIA, hiérarchie titres

### Scripts Disponibles
```bash
npm run dev                    # Serveur développement
npm run dev:clean              # Développement avec cache nettoyé
npm run test:navigation        # Tests navigation
npm run test:navigation:ui     # Interface tests
./test-navigation.sh           # Test rapide
./clear-cache.sh               # Nettoyage cache
```

## 🎨 **DESIGN SYSTEM (VALIDÉ)**

### Couleurs Principales
- **Primary** : #3b82f6 (bleu)
- **Secondary** : #8b5cf6 (violet)  
- **Success** : #10b981 (vert)
- **Warning** : #f59e0b (orange)
- **Error** : #ef4444 (rouge)
- **Brand** : Dégradé orange-rouge pour logo

### Composants
- **Boutons** : .btn-primary, .btn-secondary avec hover effects
- **Cartes** : .card avec shadow et hover lift
- **Navigation** : Header fixe avec backdrop-blur
- **Responsive** : Breakpoints TailwindCSS standard

## 🔧 **CONFIGURATION TECHNIQUE**

### Package.json (Scripts Mis à Jour)
```json
{
  "scripts": {
    "dev": "next dev -p 3000",
    "dev:clean": "./clear-cache.sh",
    "dev:safe": "./dev-safe.sh",
    "build": "next build",
    "test:navigation": "playwright test tests/navigation.spec.ts",
    "test:navigation:ui": "playwright test tests/navigation.spec.ts --ui",
    "validate": "./validate-changes.sh"
  }
}
```

### Next.js Config
```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}
module.exports = nextConfig
```

### TailwindCSS Config
```javascript
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: { extend: {} },
  plugins: [],
}
```

## ⚡ **ÉTAT ACTUEL ET PROBLÈMES RÉSOLUS**

### ✅ Fonctionnalités Validées
- [x] Navigation responsive avec header fixe
- [x] Système multilingue (6 langues + RTL)
- [x] Exercices mathématiques (5 niveaux, 4 opérations)
- [x] Plans d'abonnement (4 formules)
- [x] Tableau de bord avec statistiques
- [x] Tests automatisés Playwright
- [x] Layout sans chevauchement header/footer
- [x] Politique de gestion cache intégrée

### 🔄 En Cours de Résolution
- [ ] **Page d'accueil** : Mise à jour pour afficher niveaux 4-12 ans (sans mentions scolaires)
- [ ] **Cache management** : Application de la nouvelle politique

### 🔧 Dernières Corrections Appliquées
1. **Layout Fix** : Header fixe avec `pt-20` sur main
2. **Cache Policy** : Politique de nettoyage obligatoire créée
3. **Niveaux** : Spécification claire 5 niveaux (Niv1-Niv5) pour âges 4-12 ans
4. **Scripts** : Ajout scripts de nettoyage et validation

### 🚀 Commandes de Développement (MISE À JOUR)
```bash
# NOUVELLE PROCÉDURE OBLIGATOIRE
./clear-cache.sh               # Nettoie tout et redémarre
npm run dev:clean              # Alias du script ci-dessus

# Validation des changements
./validate-changes.sh          # Vérifie que les modifs sont effectives

# Développement sécurisé
./dev-safe.sh                  # Lance en mode incognito automatiquement
```

## 📱 **STATUT FONCTIONNEL ACTUEL**

### Ce qui marche parfaitement ✅
- **Header Navigation** : Logo M4C, menu, langues
- **Pages** : Exercices, Abonnement, Dashboard accessibles et fonctionnelles
- **Responsive** : Desktop + mobile
- **Multilingue** : 6 langues avec persistance
- **Exercices** : Génération dynamique selon niveau
- **Layout** : Header fixe + footer correct

### 🔄 En attente de validation (Cache)
- **Page d'accueil** : Modifications en cours (problème cache)
- **Interface cohérente** : Mise à jour selon spécifications 4-12 ans

### URLs de test à valider ✅
- http://localhost:XXXX (Port variable après nettoyage cache)
- /exercises (Exercices - ✅ Validé)
- /subscription (Abonnement - ✅ Validé)  
- /dashboard (Tableau de bord - ✅ Validé)

---

## 🎯 **CHECKLIST DÉVELOPPEMENT (MISE À JOUR)**

### Avant toute modification (OBLIGATOIRE)
- [ ] Exécuter `./clear-cache.sh`
- [ ] Vérifier nouveau port dans les logs
- [ ] Ouvrir en mode incognito
- [ ] Valider que l'environnement est propre

### Après modification
- [ ] Exécuter `./validate-changes.sh`
- [ ] Vérifier compilation réussie
- [ ] Tester dans navigateur (force reload)
- [ ] Valider sur desktop ET mobile
- [ ] Mettre à jour ce document si besoin

### Avant déploiement
- [ ] Build successful avec cache propre
- [ ] Tests passent
- [ ] Performance optimisée
- [ ] Accessibilité validée
- [ ] Tous niveaux 4-12 ans corrects (pas de mentions scolaires)

---

## 🆕 **SCRIPTS À CRÉER DANS LE PROJET**

### 1. clear-cache.sh
```bash
#!/bin/bash
pkill -f "next dev" 2>/dev/null || true
rm -rf .next node_modules/.cache out dist .swc
NEW_PORT=$(shuf -i 3000-3010 -n 1)
echo "🚀 Redémarrage sur port $NEW_PORT"
npm run dev -- -p $NEW_PORT
```

### 2. dev-safe.sh  
```bash
#!/bin/bash
./clear-cache.sh &
sleep 3
if [[ "$OSTYPE" == "darwin"* ]]; then
    open -na "Google Chrome" --args --incognito "http://localhost:3001"
fi
```

### 3. validate-changes.sh
```bash
#!/bin/bash
echo "📅 Dernières modifications :"
ls -la src/app/page.tsx src/app/layout.tsx
echo "📄 Contenu page.tsx :"
head -3 src/app/page.tsx
```

---

**📅 Dernière mise à jour** : 29 Juillet 2025, 13:30
**👨‍💻 Statut** : 🔄 CACHE POLICY INTÉGRÉE
**🚀 Prochaine étape** : Application politique cache + validation page d'accueil
**🎯 Priorité** : Résoudre affichage page d'accueil avec niveaux 4-12 ans