#!/bin/bash

# =============================================================================
# FIX AUTHENTIFICATION GIT - MATH4CHILD BETA
# Résolution des problèmes de credentials GitHub
# =============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}🔧 FIX AUTHENTIFICATION GIT${NC}"
echo "============================="
echo ""

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
urgent() { echo -e "${RED}${BOLD}[URGENT]${NC} $1"; }

# =============================================================================
# SOLUTION 1: VÉRIFICATION DU REPOSITORY GITHUB
# =============================================================================

echo -e "${BLUE}🔍 SOLUTION 1: Vérifier que le repository GitHub existe${NC}"
echo ""

urgent "IMPORTANT: Assurez-vous d'avoir créé le repository GitHub !"
echo ""
echo "1. Aller sur https://github.com/new"
echo "2. Repository name: math4child-beta"
echo "3. Description: Math4Child Beta - Educational app for kids 6-12"
echo "4. Public repository"
echo "5. Ne PAS cocher 'Add a README file'"
echo "6. Cliquer 'Create repository'"
echo ""
echo "Repository URL finale: https://github.com/khalidksouri/math4child-beta"
echo ""

# =============================================================================
# SOLUTION 2: UTILISER HTTPS AVEC TOKEN
# =============================================================================

echo -e "${BLUE}🔑 SOLUTION 2: Authentification via Token GitHub${NC}"
echo ""

info "GitHub ne supporte plus les mots de passe. Il faut un Personal Access Token."
echo ""
echo "ÉTAPES POUR CRÉER UN TOKEN:"
echo "1. Aller sur https://github.com/settings/tokens"
echo "2. Cliquer 'Generate new token' > 'Generate new token (classic)'"
echo "3. Note: 'Math4Child Beta Deploy'"
echo "4. Expiration: '90 days'"
echo "5. Scopes: cocher 'repo' (tous les sous-éléments)"
echo "6. Cliquer 'Generate token'"
echo "7. COPIER le token (commence par ghp_...)"
echo ""

echo -e "${YELLOW}COMMANDES POUR UTILISER LE TOKEN:${NC}"
cat << 'EOF'

# Supprimer l'ancien remote
git remote remove origin

# Ajouter remote avec format token
git remote add origin https://ghp_VOTRE_TOKEN@github.com/khalidksouri/math4child-beta.git

# Ou utiliser le format username:token
git remote add origin https://khalidksouri:ghp_VOTRE_TOKEN@github.com/khalidksouri/math4child-beta.git

# Push avec le nouveau remote
git push -u origin main

EOF

# =============================================================================
# SOLUTION 3: CONFIGURATION SSH (Alternative)
# =============================================================================

echo -e "${BLUE}🔐 SOLUTION 3: Utiliser SSH (Alternative)${NC}"
echo ""

info "Si vous préférez SSH (plus sécurisé):"
echo ""
echo "1. Vérifier si vous avez déjà une clé SSH:"
echo "   ls -la ~/.ssh"
echo ""
echo "2. Si pas de clé, en créer une:"
echo "   ssh-keygen -t ed25519 -C 'gotesttech@gmail.com'"
echo "   (Appuyer Entrée pour accepter le fichier par défaut)"
echo "   (Optionnel: entrer une passphrase)"
echo ""
echo "3. Ajouter la clé à ssh-agent:"
echo "   eval \"\$(ssh-agent -s)\""
echo "   ssh-add ~/.ssh/id_ed25519"
echo ""
echo "4. Copier la clé publique:"
echo "   cat ~/.ssh/id_ed25519.pub"
echo ""
echo "5. Ajouter la clé sur GitHub:"
echo "   - Aller sur https://github.com/settings/keys"
echo "   - Cliquer 'New SSH key'"
echo "   - Title: 'MacBook Pro Math4Child'"
echo "   - Coller la clé publique"
echo "   - Cliquer 'Add SSH key'"
echo ""
echo "6. Changer le remote pour SSH:"
echo "   git remote set-url origin git@github.com:khalidksouri/math4child-beta.git"
echo ""
echo "7. Tester et push:"
echo "   ssh -T git@github.com"
echo "   git push -u origin main"

# =============================================================================
# SOLUTION 4: MÉTHODE RAPIDE GITHUB CLI
# =============================================================================

echo ""
echo -e "${BLUE}⚡ SOLUTION 4: GitHub CLI (Méthode rapide)${NC}"
echo ""

info "Installation et utilisation de GitHub CLI:"
echo ""
echo "1. Installer GitHub CLI:"
echo "   brew install gh"
echo ""
echo "2. Login:"
echo "   gh auth login"
echo "   (Choisir GitHub.com > HTTPS > Y > Login with web browser)"
echo ""
echo "3. Créer et push en une commande:"
echo "   gh repo create math4child-beta --public --source=. --remote=origin --push"

# =============================================================================
# SOLUTION 5: DIAGNOSTIC RÉSEAU
# =============================================================================

echo ""
echo -e "${BLUE}🌐 SOLUTION 5: Diagnostic réseau${NC}"
echo ""

info "Test de connectivité GitHub:"
echo ""

# Test ping GitHub
echo "Test connectivité GitHub:"
if ping -c 3 github.com > /dev/null 2>&1; then
    log "✅ Connectivité GitHub OK"
else
    warning "⚠️ Problème de connectivité réseau"
fi

# Test DNS
echo ""
echo "Test résolution DNS:"
nslookup github.com > /dev/null 2>&1 && log "✅ DNS OK" || warning "⚠️ Problème DNS"

# Test HTTPS
echo ""
echo "Test HTTPS GitHub:"
curl -I https://github.com > /dev/null 2>&1 && log "✅ HTTPS OK" || warning "⚠️ Problème HTTPS"

# =============================================================================
# INSTRUCTIONS FINALES
# =============================================================================

echo ""
echo -e "${YELLOW}${BOLD}📋 CHECKLIST DE RÉSOLUTION:${NC}"
echo ""

cat << 'EOF'
□ 1. Repository GitHub créé (https://github.com/khalidksouri/math4child-beta)
□ 2. Token GitHub généré (https://github.com/settings/tokens)
□ 3. Remote mis à jour avec token
□ 4. Push réussi

COMMANDES À EXÉCUTER DANS L'ORDRE:

# 1. Supprimer ancien remote
git remote remove origin

# 2. Créer token sur GitHub (voir instructions ci-dessus)

# 3. Ajouter remote avec token (remplacer VOTRE_TOKEN)
git remote add origin https://khalidksouri:ghp_VOTRE_TOKEN@github.com/khalidksouri/math4child-beta.git

# 4. Push
git push -u origin main

EOF

echo ""
echo -e "${GREEN}${BOLD}🎯 RÉSULTAT ATTENDU:${NC}"
echo "✅ Code poussé vers GitHub"
echo "✅ Repository math4child-beta visible sur GitHub"
echo "✅ Prêt pour connexion Netlify"
echo ""

echo -e "${CYAN}🚀 APRÈS LE PUSH RÉUSSI:${NC}"
echo "1. Aller sur https://app.netlify.com"
echo "2. New site from Git"
echo "3. Connecter le repository math4child-beta"
echo "4. Deploy automatique !"
echo ""

urgent "⚡ CHOISISSEZ LA SOLUTION QUI VOUS CONVIENT LE MIEUX !"
echo ""

# =============================================================================
# ALTERNATIVE: DRAG & DROP NETLIFY
# =============================================================================

echo -e "${BLUE}🎯 SOLUTION ALTERNATIVE: Deploy direct Netlify${NC}"
echo ""

info "Si GitHub pose toujours problème, deploy direct possible:"
echo ""
echo "1. Aller sur https://app.netlify.com"
echo "2. Glisser-déposer le dossier 'out' directement"
echo "3. Site déployé immédiatement !"
echo ""
echo "Dossier à deployer: $(pwd)/out"
echo ""

if [[ -d "out" ]]; then
    echo "✅ Dossier 'out' trouvé et prêt pour deploy"
    echo "📁 Contenu:"
    ls -la out/
else
    warning "⚠️ Dossier 'out' manquant - Run 'npm run build' d'abord"
fi

echo ""
log "Toutes les solutions sont prêtes ! Choisissez celle qui vous convient."