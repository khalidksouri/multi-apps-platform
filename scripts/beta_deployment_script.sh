#!/bin/bash

# =============================================================================
# DÉPLOIEMENT BETA MATH4CHILD
# Hébergement temporaire pour les testeurs beta
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}🚀 DÉPLOIEMENT BETA MATH4CHILD${NC}"
echo "==============================="
echo ""

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
step() { echo -e "${BLUE}[ÉTAPE]${NC} $1"; }

# =============================================================================
# ÉTAPE 1: BUILD PRODUCTION BETA
# =============================================================================

step "1️⃣ Build production beta Math4Child"

info "Nettoyage builds précédents..."
rm -rf .next out 2>/dev/null || true

info "Build Next.js optimisé pour beta..."
if CAPACITOR_BUILD=false npm run build 2>/dev/null; then
    log "✅ Build Next.js réussi"
else
    echo -e "${YELLOW}⚠️ Tentative build alternative...${NC}"
    if npm run build 2>/dev/null; then
        log "✅ Build alternatif réussi"
    else
        echo -e "${YELLOW}⚠️ Build manuel requis${NC}"
    fi
fi

# Vérifier build
if [ -d ".next" ]; then
    BUILD_SIZE=$(du -sh .next 2>/dev/null | cut -f1 || echo "N/A")
    info "Build généré: $BUILD_SIZE"
    log "✅ Build production prêt"
else
    echo -e "${YELLOW}⚠️ Build à faire manuellement: npm run build${NC}"
fi

# =============================================================================
# ÉTAPE 2: PRÉPARATION NETLIFY
# =============================================================================

step "2️⃣ Préparation déploiement Netlify"

# Créer netlify.toml pour Math4Child
cat > netlify.toml << 'EOF'
[build]
  publish = "out"
  command = "npm run build && npm run export"

[build.environment]
  NODE_VERSION = "18"
  NPM_VERSION = "9"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[context.production.environment]
  NEXT_PUBLIC_ENV = "production"
  CAPACITOR_BUILD = "false"

[context.deploy-preview.environment]
  NEXT_PUBLIC_ENV = "preview"

[headers]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Content-Security-Policy = "default-src 'self' 'unsafe-inline' 'unsafe-eval' https: data: blob:; img-src 'self' data: https:; font-src 'self' data: https:;"
EOF

log "✅ Configuration Netlify créée"

# Script de déploiement Netlify
cat > deploy-netlify.sh << 'EOF'
#!/bin/bash

echo "🚀 Déploiement Netlify Math4Child Beta"
echo "====================================="

# Instructions étape par étape
echo "📋 Instructions de déploiement :"
echo ""
echo "1️⃣ Créer compte Netlify (gratuit)"
echo "   → https://app.netlify.com/signup"
echo ""
echo "2️⃣ Nouveau site depuis Git"
echo "   → New site from Git"
echo "   → Connect to GitHub/GitLab"
echo ""
echo "3️⃣ Configuration build"
echo "   → Build command: npm run build && npm run export"
echo "   → Publish directory: out"
echo "   → Node version: 18"
echo ""
echo "4️⃣ Variables d'environnement"
echo "   → CAPACITOR_BUILD = false"
echo "   → NODE_VERSION = 18"
echo ""
echo "5️⃣ Domaine personnalisé (optionnel)"
echo "   → beta.math4child.com"
echo "   → ou math4child-beta.netlify.app"
echo ""

# Alternative: Déploiement direct Netlify CLI
if command -v netlify >/dev/null 2>&1; then
    echo "🔧 Netlify CLI détecté"
    echo ""
    echo "   Déploiement direct possible :"
    echo "   → netlify login"
    echo "   → netlify init"
    echo "   → netlify deploy --prod"
else
    echo "💡 Installation Netlify CLI (optionnel) :"
    echo "   → npm install -g netlify-cli"
    echo "   → netlify login"
    echo "   → netlify deploy --prod"
fi

echo ""
echo "✅ URL beta sera disponible sous quelques minutes"
echo "📧 Partager l'URL avec les beta testeurs"
EOF

chmod +x deploy-netlify.sh

log "✅ Script déploiement Netlify créé"

# =============================================================================
# ÉTAPE 3: ALTERNATIVE VERCEL
# =============================================================================

step "3️⃣ Alternative Vercel"

# Configuration Vercel
cat > vercel.json << 'EOF'
{
  "name": "math4child-beta",
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/next"
    }
  ],
  "env": {
    "CAPACITOR_BUILD": "false",
    "NEXT_PUBLIC_ENV": "production"
  },
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ]
}
EOF

# Script déploiement Vercel
cat > deploy-vercel.sh << 'EOF'
#!/bin/bash

echo "🚀 Déploiement Vercel Math4Child Beta"
echo "===================================="

echo "📋 Instructions Vercel :"
echo ""
echo "1️⃣ Créer compte Vercel (gratuit)"
echo "   → https://vercel.com/signup"
echo ""
echo "2️⃣ Import project"
echo "   → Import Git Repository"
echo "   → Sélectionner votre repo Math4Child"
echo ""
echo "3️⃣ Configuration automatique"
echo "   → Next.js détecté automatiquement"
echo "   → Build: npm run build"
echo "   → Output: .next"
echo ""
echo "4️⃣ Variables d'environnement"
echo "   → CAPACITOR_BUILD = false"
echo ""
echo "5️⃣ Domaine (optionnel)"
echo "   → math4child-beta.vercel.app"
echo "   → ou domaine personnalisé"
echo ""

if command -v vercel >/dev/null 2>&1; then
    echo "🔧 Vercel CLI détecté"
    echo ""
    echo "   Déploiement direct :"
    echo "   → vercel login"
    echo "   → vercel --prod"
else
    echo "💡 Installation Vercel CLI :"
    echo "   → npm install -g vercel"
    echo "   → vercel login"
    echo "   → vercel --prod"
fi

echo ""
echo "⚡ Déploiement Vercel = 30 secondes"
echo "🌐 URL instantanément disponible"
EOF

chmod +x deploy-vercel.sh

log "✅ Alternative Vercel configurée"

# =============================================================================
# ÉTAPE 4: LINKS BETA TESTEURS
# =============================================================================

step "4️⃣ Préparation liens beta testeurs"

# Template email avec liens
cat > beta-program/email-beta-links.md << 'EOF'
# 📧 Email Beta Testeurs - Liens d'accès

## Template Email d'Envoi

**Objet :** 🎉 Vos liens d'accès Math4Child Beta - C'est parti !

---

Bonjour [NOM_FAMILLE],

Votre accès beta Math4Child est maintenant **ACTIF** ! 🚀

## 🔗 Vos liens d'accès :

### 🌐 **Version Web** (Recommandée pour débuter)
**URL :** https://math4child-beta.netlify.app
- ✅ Fonctionne sur tous navigateurs
- ✅ Aucune installation requise
- ✅ Mise à jour automatique

### 📱 **Version Mobile** (Bientôt disponible)
- **Android :** Lien APK dans 48h
- **iOS :** TestFlight dans 48h

## 🎮 **Comment commencer :**

1. **Ouvrir le lien** dans votre navigateur
2. **Sélectionner la langue** de votre choix (195+ disponibles !)
3. **Cliquer "Essai Gratuit"** 
4. **Choisir le niveau** de votre enfant
5. **Commencer à jouer** !

## 🧪 **Votre mission beta :**

### 📅 **Semaine 1 (J1-J7) :**
- Tester les fonctionnalités principales
- Noter les bugs ou problèmes
- Essayer différentes langues
- Laisser votre enfant explorer librement

### 📋 **Questionnaire J7 :**
Nous vous enverrons un questionnaire rapide (5 min) pour recueillir vos premiers retours.

### 📅 **Semaine 2 (J8-J14) :**
- Tests plus approfondis
- Tester sur différents appareils
- Mesurer les progrès de votre enfant

### 📊 **Survey final J14 :**
Questionnaire complet (10 min) pour vos retours définitifs.

## 🆘 **Support Beta :**

- **Email :** khalid_ksouri@yahoo.fr
- **Réponse garantie :** < 24h
- **WhatsApp :** [NUMERO] (urgences uniquement)

## 🎁 **Vos avantages confirmés :**

✅ **Accès Premium gratuit** : 3 mois après le beta  
✅ **Badge Beta Tester** : Exclusif et permanent  
✅ **Réduction 50%** : Sur l'abonnement à vie  
✅ **Influence produit** : Vos suggestions seront intégrées  

## 📊 **Ce que nous analysons :**

- Temps d'utilisation et engagement
- Fonctionnalités les plus utilisées
- Difficultés rencontrées
- Suggestions d'amélioration
- Performance sur votre équipement

## 🤝 **Ensemble, créons la meilleure app éducative !**

Votre participation va permettre d'offrir à des milliers d'enfants une expérience d'apprentissage exceptionnelle.

**Merci de faire partie de l'aventure Math4Child !** 🙏

---

Cordialement,

**L'équipe Math4Child**  
GOTEST - SIRET: 53958712100028  
khalid_ksouri@yahoo.fr  

*P.S. : N'hésitez pas à partager vos captures d'écran et vidéos de votre enfant utilisant Math4Child (avec votre accord) !*
EOF

log "✅ Template email beta testeurs créé"

# =============================================================================
# ÉTAPE 5: CHECKLIST LANCEMENT BETA
# ==============================