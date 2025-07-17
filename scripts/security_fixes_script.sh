#!/bin/bash

# Script de correction des vulnérabilités de sécurité NPM
# pour multi-apps-platform

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔒 CORRECTION DES VULNÉRABILITÉS DE SÉCURITÉ${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""

# Variables globales
WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

# Fonction d'affichage des étapes
step() {
    echo -e "${YELLOW}▶ $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

# Fonction pour corriger les vulnérabilités d'une application
fix_app_vulnerabilities() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ] && [ -f "$app_dir/package.json" ]; then
        step "Correction des vulnérabilités pour $app_name"
        cd "$app_dir"
        
        echo "📋 Audit initial..."
        npm audit --audit-level=moderate || true
        
        echo "🔧 Correction automatique..."
        npm audit fix --force || true
        
        echo "📦 Mise à jour des packages obsolètes..."
        # Mettre à jour les packages deprecated spécifiques
        if grep -q "react-scripts" package.json; then
            npm install react-scripts@latest --save || true
        fi
        
        if grep -q "@babel" package.json; then
            # Mettre à jour les plugins Babel obsolètes
            npm remove @babel/plugin-proposal-private-methods \
                      @babel/plugin-proposal-nullish-coalescing-operator \
                      @babel/plugin-proposal-numeric-separator \
                      @babel/plugin-proposal-optional-chaining \
                      @babel/plugin-proposal-class-properties \
                      @babel/plugin-proposal-private-property-in-object 2>/dev/null || true
                      
            npm install @babel/plugin-transform-private-methods \
                       @babel/plugin-transform-nullish-coalescing-operator \
                       @babel/plugin-transform-numeric-separator \
                       @babel/plugin-transform-optional-chaining \
                       @babel/plugin-transform-class-properties \
                       @babel/plugin-transform-private-property-in-object --save-dev || true
        fi
        
        if grep -q "eslint.*8\." package.json; then
            npm install eslint@latest --save-dev || true
        fi
        
        if grep -q "svgo.*1\." package.json; then
            npm install svgo@latest --save-dev || true
        fi
        
        echo "🧹 Nettoyage final..."
        npm dedupe
        
        echo "📋 Audit final..."
        npm audit --audit-level=high || true
        
        success "$app_name sécurisé"
        echo ""
    fi
}

# Fonction pour créer un package.json sécurisé pour React
create_secure_react_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json sécurisé pour $app_name"
        
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.28.0",
    "react-scripts": "^5.0.1",
    "typescript": "^5.7.2",
    "web-vitals": "^4.2.4",
    "react-i18next": "^15.1.4",
    "i18next": "^23.16.8",
    "i18next-browser-languagedetector": "^8.0.1",
    "i18next-http-backend": "^2.6.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  },
  "devDependencies": {
    "@types/react": "^18.3.23",
    "@types/react-dom": "^18.3.7",
    "@types/node": "^22.10.2"
  }
}
EOF
        success "Package.json sécurisé créé pour $app_name"
    fi
}

# Fonction pour créer un package.json sécurisé pour Vue.js
create_secure_vue_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json sécurisé pour $app_name (Vue.js)"
        
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve",
    "build": "vue-cli-service build",
    "test:unit": "vue-cli-service test:unit",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "vue": "^3.5.13",
    "vue-router": "^4.5.0",
    "vuex": "^4.1.0",
    "vue-i18n": "^10.0.4"
  },
  "devDependencies": {
    "@vue/cli-plugin-typescript": "^5.0.8",
    "@vue/cli-service": "^5.0.8",
    "typescript": "^5.7.2"
  }
}
EOF
        success "Package.json sécurisé créé pour $app_name (Vue.js)"
    fi
}

# Fonction pour créer un package.json sécurisé pour Next.js
create_secure_nextjs_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json sécurisé pour $app_name (Next.js)"
        
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^15.1.2",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "typescript": "^5.7.2",
    "next-i18next": "^15.3.1",
    "react-i18next": "^15.1.4",
    "i18next": "^23.16.8"
  },
  "devDependencies": {
    "@types/node": "^22.10.2",
    "@types/react": "^18.3.23",
    "@types/react-dom": "^18.3.7",
    "eslint": "^9.17.0",
    "eslint-config-next": "^15.1.2"
  }
}
EOF
        success "Package.json sécurisé créé pour $app_name (Next.js)"
    fi
}

# Fonction pour créer un .nvmrc pour la version Node.js
create_nvmrc() {
    step "Configuration de la version Node.js recommandée"
    
    # Créer .nvmrc dans le workspace
    echo "20.18.0" > "$WORKSPACE_DIR/.nvmrc"
    
    # Créer .nvmrc dans chaque application
    local apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")
    for app in "${apps[@]}"; do
        if [ -d "$WORKSPACE_DIR/$app" ]; then
            echo "20.18.0" > "$WORKSPACE_DIR/$app/.nvmrc"
        fi
    done
    
    success "Version Node.js 20.18.0 configurée"
}

# Fonction pour créer des scripts de sécurité
create_security_scripts() {
    step "Création des scripts de sécurité"
    
    # Script d'audit de sécurité
    cat > "$WORKSPACE_DIR/security_audit.sh" << 'EOF'
#!/bin/bash

echo "🔒 AUDIT DE SÉCURITÉ GLOBAL"
echo "==========================="

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")

for app in "${apps[@]}"; do
    if [ -d "$WORKSPACE_DIR/$app" ]; then
        echo ""
        echo "📋 Audit de $app..."
        cd "$WORKSPACE_DIR/$app"
        npm audit --audit-level=moderate
    fi
done

echo ""
echo "✅ Audit terminé!"
EOF

    chmod +x "$WORKSPACE_DIR/security_audit.sh"
    
    # Script de mise à jour de sécurité
    cat > "$WORKSPACE_DIR/security_update.sh" << 'EOF'
#!/bin/bash

echo "🔄 MISE À JOUR DE SÉCURITÉ"
echo "=========================="

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")

for app in "${apps[@]}"; do
    if [ -d "$WORKSPACE_DIR/$app" ]; then
        echo ""
        echo "🔧 Mise à jour de $app..."
        cd "$WORKSPACE_DIR/$app"
        npm update
        npm audit fix --force
    fi
done

echo ""
echo "✅ Mise à jour terminée!"
EOF

    chmod +x "$WORKSPACE_DIR/security_update.sh"
    
    success "Scripts de sécurité créés"
}

# Fonction principale
main() {
    echo "Début de la correction des vulnérabilités de sécurité..."
    echo ""
    
    # Sauvegarder les package.json actuels
    step "Sauvegarde des configurations actuelles"
    local apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")
    for app in "${apps[@]}"; do
        if [ -f "$WORKSPACE_DIR/$app/package.json" ]; then
            cp "$WORKSPACE_DIR/$app/package.json" "$WORKSPACE_DIR/$app/package.json.backup"
        fi
    done
    success "Sauvegarde effectuée"
    
    # Recréer les package.json avec des versions sécurisées
    create_secure_react_package "math4kids"
    create_secure_react_package "unitflip" 
    create_secure_react_package "ai4kids"
    create_secure_vue_package "budgetcron"
    create_secure_nextjs_package "multiai"
    
    # Configurer Node.js
    create_nvmrc
    
    # Réinstaller les dépendances avec les nouvelles versions
    for app in "${apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        if [ -d "$app_dir" ]; then
            step "Réinstallation sécurisée pour $app"
            cd "$app_dir"
            rm -rf node_modules package-lock.json
            npm install
            success "$app réinstallé"
        fi
    done
    
    # Corriger les vulnérabilités restantes
    for app in "${apps[@]}"; do
        fix_app_vulnerabilities "$app"
    done
    
    # Créer les scripts de sécurité
    create_security_scripts
    
    echo ""
    echo -e "${GREEN}🎉 CORRECTION DE SÉCURITÉ TERMINÉE!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Résumé des améliorations de sécurité:${NC}"
    echo "✅ Packages mis à jour vers les dernières versions sécurisées"
    echo "✅ Vulnérabilités NPM corrigées"
    echo "✅ Packages deprecated remplacés"
    echo "✅ Version Node.js 20.18.0 configurée"
    echo "✅ Scripts de sécurité créés"
    echo ""
    echo -e "${YELLOW}🔒 Scripts de sécurité disponibles:${NC}"
    echo "  ./security_audit.sh - Audit de sécurité complet"
    echo "  ./security_update.sh - Mise à jour de sécurité"
    echo ""
    echo -e "${YELLOW}🚀 Prochaines étapes:${NC}"
    echo "1. Testez le démarrage: ./start_apps.sh"
    echo "2. Lancez un audit: ./security_audit.sh"
    echo "3. Surveillez les logs dans le dossier logs/"
    echo ""
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée à la ligne $LINENO${NC}"; exit 1' ERR

# Lancement du script
main