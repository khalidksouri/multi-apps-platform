#!/bin/bash

# =============================================================================
# CORRECTIF CAPACITOR MATH4CHILD - ERREUR DE COMPILATION
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║      🔧 CORRECTIF CAPACITOR - ERREUR COMPILATION        ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérifier si on est dans le bon répertoire
if [ ! -f "package.json" ]; then
    print_error "Aucun package.json trouvé. Êtes-vous dans le bon répertoire ?"
    exit 1
fi

print_info "Diagnostic du problème Capacitor..."

# Vérifier l'existence du fichier capacitor.config.ts problématique
if [ -f "apps/math4kids/capacitor.config.ts" ]; then
    print_warning "Fichier capacitor.config.ts trouvé dans apps/math4kids/"
    print_info "Contenu du fichier :"
    head -10 "apps/math4kids/capacitor.config.ts"
    
    # Solution 1: Supprimer le fichier capacitor.config.ts s'il n'est pas nécessaire
    print_info "Solution 1: Suppression du fichier capacitor.config.ts non nécessaire"
    read -p "Voulez-vous supprimer le fichier capacitor.config.ts ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "apps/math4kids/capacitor.config.ts"
        print_success "Fichier capacitor.config.ts supprimé"
    else
        print_info "Solution 2: Installation des dépendances Capacitor"
        
        # Installer Capacitor pour éviter l'erreur
        print_info "Installation de Capacitor..."
        npm install @capacitor/core @capacitor/cli --save-dev
        npm install @capacitor/android @capacitor/ios --save
        
        # Corriger le fichier capacitor.config.ts avec la bonne configuration
        print_info "Correction du fichier capacitor.config.ts..."
        cat > "apps/math4kids/capacitor.config.ts" << 'EOF'
import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.gotest.math4child',
  appName: 'Math4Child',
  webDir: 'out',
  server: {
    androidScheme: 'https'
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 3000,
      launchAutoHide: true,
      backgroundColor: "#7c3aed",
      androidSplashResourceName: "splash",
      androidScaleType: "CENTER_CROP",
      showSpinner: true,
      androidSpinnerStyle: "large",
      iosSpinnerStyle: "small",
      spinnerColor: "#ffffff"
    }
  }
};

export default config;
EOF
        print_success "Fichier capacitor.config.ts corrigé avec configuration GOTEST"
    fi
elif [ -f "capacitor.config.ts" ]; then
    print_warning "Fichier capacitor.config.ts trouvé dans la racine"
    # Même traitement pour le fichier racine
    print_info "Solution: Suppression ou correction du fichier racine"
    read -p "Voulez-vous supprimer le fichier capacitor.config.ts de la racine ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm "capacitor.config.ts"
        print_success "Fichier capacitor.config.ts supprimé de la racine"
    fi
else
    print_info "Aucun fichier capacitor.config.ts trouvé"
fi

# Vérifier et corriger le tsconfig.json pour exclure les fichiers Capacitor si nécessaire
print_info "Mise à jour du tsconfig.json pour exclure Capacitor si nécessaire..."
if [ -f "tsconfig.json" ]; then
    # Créer un tsconfig.json qui exclut capacitor si il cause des problèmes
    node -e "
    const fs = require('fs');
    try {
      const tsconfig = JSON.parse(fs.readFileSync('tsconfig.json', 'utf8'));
      if (!tsconfig.exclude) tsconfig.exclude = [];
      if (!tsconfig.exclude.includes('capacitor.config.ts')) {
        tsconfig.exclude.push('capacitor.config.ts');
      }
      if (!tsconfig.exclude.includes('apps/*/capacitor.config.ts')) {
        tsconfig.exclude.push('apps/*/capacitor.config.ts');
      }
      fs.writeFileSync('tsconfig.json', JSON.stringify(tsconfig, null, 2));
      console.log('✅ tsconfig.json mis à jour');
    } catch (error) {
      console.log('⚠️ Erreur mise à jour tsconfig:', error.message);
    }
    "
fi

# Nettoyer le cache Next.js
print_info "Nettoyage du cache Next.js..."
rm -rf .next
rm -rf apps/math4kids/.next 2>/dev/null || true

# Réinstaller les dépendances proprement
print_info "Réinstallation propre des dépendances..."
npm install

# Test de build
print_info "Test de compilation..."
if npm run build; then
    print_success "🎉 BUILD RÉUSSI ! Problème Capacitor résolu !"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║               ✅ PROBLÈME RÉSOLU !                       ║${NC}"
    echo -e "${GREEN}║          Math4Child compile maintenant !                ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    print_info "🚀 Application prête :"
    echo -e "${YELLOW}npm run dev${NC}"
    echo -e "${YELLOW}Visitez: http://localhost:3000${NC}"
    echo ""
    
    print_info "📱 Pour les apps mobiles (optionnel) :"
    echo -e "${YELLOW}npm install @capacitor/core @capacitor/cli${NC}"
    echo -e "${YELLOW}npx cap init${NC}"
    echo -e "${YELLOW}npx cap add android${NC}"
    echo -e "${YELLOW}npx cap add ios${NC}"
    
else
    print_error "Compilation encore en échec"
    print_info "Diagnostic supplémentaire..."
    
    # Vérifier s'il y a d'autres fichiers problématiques
    print_info "Recherche de fichiers TypeScript problématiques..."
    find . -name "*.ts" -o -name "*.tsx" | grep -E "(capacitor|ionic)" || print_info "Aucun autre fichier Capacitor trouvé"
    
    print_info "Vérification des imports problématiques..."
    grep -r "@capacitor" . --include="*.ts" --include="*.tsx" 2>/dev/null || print_info "Aucun import @capacitor trouvé"
    
    print_warning "Solutions supplémentaires :"
    echo -e "${YELLOW}1. Vérifiez les erreurs ci-dessus${NC}"
    echo -e "${YELLOW}2. Essayez: npm run dev (mode développement)${NC}"
    echo -e "${YELLOW}3. Vérifiez le fichier apps/math4kids/tsconfig.json${NC}"
    echo -e "${YELLOW}4. Supprimez manuellement tous les fichiers capacitor.config.ts${NC}"
fi

print_success "Script de correction Capacitor terminé"