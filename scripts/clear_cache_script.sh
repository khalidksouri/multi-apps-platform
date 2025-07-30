#!/bin/bash

# =============================================================================
# 🧹 NETTOYAGE COMPLET DU CACHE NEXT.JS - MATH4CHILD
# Supprime tous les caches pour forcer le rechargement complet
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}"
    echo "========================================"
    echo "  $1"
    echo "========================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}🧹 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_header "NETTOYAGE COMPLET DU CACHE NEXT.JS"

TARGET_DIR="apps/math4child"

if [ ! -d "$TARGET_DIR" ]; then
    print_error "Dossier $TARGET_DIR non trouvé"
    exit 1
fi

cd "$TARGET_DIR"

# =============================================================================
# ÉTAPE 1: Arrêter le serveur de développement
# =============================================================================

print_step "Étape 1: Arrêt du serveur de développement..."

# Tuer tous les processus Next.js sur le port 3000
if lsof -ti:3000 > /dev/null 2>&1; then
    echo "🛑 Arrêt du serveur sur le port 3000..."
    lsof -ti:3000 | xargs kill -9 2>/dev/null || true
    sleep 2
    print_success "Serveur arrêté"
else
    echo "ℹ️  Aucun serveur actif sur le port 3000"
fi

# Tuer tous les processus node liés à Next.js
if pgrep -f "next" > /dev/null 2>&1; then
    echo "🛑 Arrêt de tous les processus Next.js..."
    pkill -f "next" 2>/dev/null || true
    sleep 1
    print_success "Processus Next.js arrêtés"
fi

# =============================================================================
# ÉTAPE 2: Supprimer tous les caches Next.js
# =============================================================================

print_step "Étape 2: Suppression des caches Next.js..."

# Cache Next.js principal
if [ -d ".next" ]; then
    echo "🗑️  Suppression du dossier .next..."
    rm -rf .next
    print_success "Dossier .next supprimé"
fi

# Cache de build
if [ -d "out" ]; then
    echo "🗑️  Suppression du dossier out..."
    rm -rf out
    print_success "Dossier out supprimé"
fi

# Cache TypeScript
if [ -f "*.tsbuildinfo" ]; then
    echo "🗑️  Suppression des fichiers tsbuildinfo..."
    rm -f *.tsbuildinfo
    print_success "Fichiers tsbuildinfo supprimés"
fi

if [ -f "next-env.d.ts" ]; then
    echo "🗑️  Suppression de next-env.d.ts..."
    rm -f next-env.d.ts
    print_success "next-env.d.ts supprimé"
fi

# =============================================================================
# ÉTAPE 3: Supprimer le cache npm/node_modules
# =============================================================================

print_step "Étape 3: Nettoyage des dépendances..."

# Supprimer node_modules
if [ -d "node_modules" ]; then
    echo "🗑️  Suppression de node_modules..."
    rm -rf node_modules
    print_success "node_modules supprimé"
fi

# Supprimer package-lock.json
if [ -f "package-lock.json" ]; then
    echo "🗑️  Suppression de package-lock.json..."
    rm -f package-lock.json
    print_success "package-lock.json supprimé"
fi

# Nettoyer le cache npm
echo "🧹 Nettoyage du cache npm..."
npm cache clean --force 2>/dev/null || true
print_success "Cache npm nettoyé"

# =============================================================================
# ÉTAPE 4: Supprimer les caches système et navigateur
# =============================================================================

print_step "Étape 4: Nettoyage des caches système..."

# Cache Vercel (si présent)
if [ -d ".vercel" ]; then
    echo "🗑️  Suppression du cache Vercel..."
    rm -rf .vercel
    print_success "Cache Vercel supprimé"
fi

# Cache ESLint
if [ -d ".eslintcache" ]; then
    echo "🗑️  Suppression du cache ESLint..."
    rm -rf .eslintcache
    print_success "Cache ESLint supprimé"
fi

# Fichiers temporaires
echo "🗑️  Suppression des fichiers temporaires..."
find . -name "*.log" -delete 2>/dev/null || true
find . -name ".DS_Store" -delete 2>/dev/null || true
find . -name "Thumbs.db" -delete 2>/dev/null || true
print_success "Fichiers temporaires supprimés"

# =============================================================================
# ÉTAPE 5: Réinstaller les dépendances
# =============================================================================

print_step "Étape 5: Réinstallation des dépendances..."

echo "📦 Installation des dépendances..."
npm install
print_success "Dépendances réinstallées"

# Vérifier que lucide-react est installé
if ! grep -q "lucide-react" package.json; then
    echo "📥 Installation de lucide-react..."
    npm install lucide-react
    print_success "lucide-react installé"
fi

# =============================================================================
# ÉTAPE 6: Forcer la régénération du cache
# =============================================================================

print_step "Étape 6: Régénération forcée..."

echo "🔄 Génération des types Next.js..."
npx next build --debug 2>/dev/null || true

echo "🔄 Régénération du cache de développement..."
npx next dev --turbo &
DEV_PID=$!
sleep 5
kill $DEV_PID 2>/dev/null || true
wait $DEV_PID 2>/dev/null || true

print_success "Cache régénéré"

# =============================================================================
# ÉTAPE 7: Instructions pour le navigateur
# =============================================================================

print_step "Étape 7: Instructions pour le navigateur..."

cat << 'BROWSER_INSTRUCTIONS'

🌐 NETTOYAGE DU NAVIGATEUR REQUIS :

1. **Ouvrez les Outils de développement** (F12)

2. **Clic droit sur le bouton de rechargement** et sélectionnez :
   ☑️ "Vider le cache et actualiser la page"
   ☑️ "Rechargement forcé"

3. **Ou utilisez les raccourcis clavier** :
   • Chrome/Firefox : Ctrl+Shift+R (Cmd+Shift+R sur Mac)
   • Safari : Cmd+Option+R

4. **Supprimez les données du site** :
   • Chrome : F12 > Application > Storage > Clear storage
   • Firefox : F12 > Storage > Cookies/Local Storage > Supprimer
   • Safari : Develop > Empty Caches

5. **Vérifiez le mode incognito** :
   • Testez dans une fenêtre privée pour éviter le cache

BROWSER_INSTRUCTIONS

print_warning "IMPORTANT: Nettoyez aussi le cache de votre navigateur !"

# =============================================================================
# ÉTAPE 8: Vérification finale
# =============================================================================

print_step "Étape 8: Vérification finale..."

echo "🔍 Vérification de la structure..."
if [ -f "src/app/page.tsx" ]; then
    echo "  ✅ page.tsx présent"
    # Vérifier le contenu
    if grep -q "Apprends les maths en t'amusant" src/app/page.tsx; then
        echo "  ✅ Contenu Math4Child détecté"
    else
        echo "  ⚠️  Contenu Math4Child non détecté"
    fi
else
    echo "  ❌ page.tsx manquant"
fi

if [ -f "src/app/globals.css" ]; then
    echo "  ✅ globals.css présent"
else
    echo "  ❌ globals.css manquant"
fi

if [ -f "package.json" ]; then
    echo "  ✅ package.json présent"
    if grep -q "lucide-react" package.json; then
        echo "  ✅ lucide-react installé"
    else
        echo "  ⚠️  lucide-react manquant"
    fi
else
    echo "  ❌ package.json manquant"
fi

print_header "NETTOYAGE TERMINÉ"

echo -e "${GREEN}"
echo "🎉 Nettoyage complet effectué !"
echo ""
echo "📋 Actions réalisées :"
echo "   ✅ Serveur de développement arrêté"
echo "   ✅ Cache .next supprimé"
echo "   ✅ node_modules réinstallé"
echo "   ✅ Cache npm nettoyé"
echo "   ✅ Fichiers temporaires supprimés"
echo "   ✅ Dépendances réinstallées"
echo ""
echo "🚀 Prochaines étapes :"
echo "   1. Nettoyez le cache de votre navigateur (voir instructions ci-dessus)"
echo "   2. Fermez complètement votre navigateur"
echo "   3. Relancez le serveur : npm run dev"
echo "   4. Ouvrez une nouvelle fenêtre incognito"
echo "   5. Allez sur http://localhost:3000"
echo ""
echo "🔄 Si le problème persiste :"
echo "   • Redémarrez votre terminal"
echo "   • Redémarrez VS Code"
echo "   • Redémarrez votre ordinateur"
echo -e "${NC}"

print_success "Cache complètement nettoyé ! Redémarrez maintenant le serveur."

echo ""
echo -e "${YELLOW}🔴 IMPORTANT: Lancez maintenant 'npm run dev' dans un nouveau terminal${NC}"