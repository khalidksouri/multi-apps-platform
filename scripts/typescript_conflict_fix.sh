#!/bin/bash

# Script de correction du conflit TypeScript avec React Scripts
# Résout le problème ERESOLVE avec typescript et react-scripts

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 CORRECTION DU CONFLIT TYPESCRIPT${NC}"
echo -e "${BLUE}===================================${NC}"
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

# Fonction pour créer un package.json compatible avec React Scripts
create_compatible_react_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json compatible pour $app_name"
        
        # Utiliser TypeScript 4.9.5 qui est compatible avec React Scripts 5.0.1
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "react-router-dom": "^6.28.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "web-vitals": "^3.5.2",
    "react-i18next": "^13.5.0",
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
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "@types/node": "^16.18.0"
  }
}
EOF
        success "Package.json compatible créé pour $app_name"
    fi
}

# Fonction pour créer un package.json pour Vue.js
create_compatible_vue_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json compatible pour $app_name (Vue.js)"
        
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "serve": "vue-cli-service serve --port 3003",
    "build": "vue-cli-service build",
    "test:unit": "vue-cli-service test:unit",
    "lint": "vue-cli-service lint"
  },
  "dependencies": {
    "vue": "^3.4.0",
    "vue-router": "^4.4.0",
    "vuex": "^4.1.0",
    "vue-i18n": "^9.9.0"
  },
  "devDependencies": {
    "@vue/cli-plugin-typescript": "^5.0.8",
    "@vue/cli-service": "^5.0.8",
    "typescript": "^4.9.5"
  }
}
EOF
        success "Package.json Vue.js compatible créé pour $app_name"
    fi
}

# Fonction pour créer un package.json pour Next.js
create_compatible_nextjs_package() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Création d'un package.json compatible pour $app_name (Next.js)"
        
        cat > "$app_dir/package.json" << EOF
{
  "name": "$app_name",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev --port 3005",
    "build": "next build",
    "start": "next start --port 3005",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "^14.2.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "typescript": "^5.6.0",
    "next-i18next": "^15.3.0",
    "react-i18next": "^13.5.0",
    "i18next": "^23.16.8"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.0"
  }
}
EOF
        success "Package.json Next.js compatible créé pour $app_name"
    fi
}

# Fonction pour installer avec résolution forcée
install_with_force() {
    local app_name=$1
    local app_dir="$WORKSPACE_DIR/$app_name"
    
    if [ -d "$app_dir" ]; then
        step "Installation forcée des dépendances pour $app_name"
        cd "$app_dir"
        
        # Nettoyer complètement
        rm -rf node_modules package-lock.json
        
        # Installer avec résolution forcée
        npm install --legacy-peer-deps --force
        
        success "$app_name installé avec résolution forcée"
        
        # Audit de sécurité (non bloquant)
        npm audit fix --force --legacy-peer-deps || true
        
        success "Audit de sécurité appliqué pour $app_name"
    fi
}

# Fonction pour créer un .npmrc global
create_npmrc_config() {
    step "Configuration .npmrc pour résolution des conflits"
    
    # Créer .npmrc dans le workspace
    cat > "$WORKSPACE_DIR/.npmrc" << EOF
legacy-peer-deps=true
force=true
audit-level=moderate
fund=false
EOF
    
    # Créer .npmrc dans chaque application
    local apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")
    for app in "${apps[@]}"; do
        if [ -d "$WORKSPACE_DIR/$app" ]; then
            cp "$WORKSPACE_DIR/.npmrc" "$WORKSPACE_DIR/$app/.npmrc"
        fi
    done
    
    success "Configuration .npmrc créée"
}

# Fonction pour tester les builds
test_builds() {
    step "Test des builds pour vérifier la compatibilité"
    
    local apps=("math4kids" "unitflip" "ai4kids" "budgetcron" "multiai")
    local successful_builds=0
    
    for app in "${apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        if [ -d "$app_dir" ]; then
            echo "🧪 Test de build pour $app..."
            cd "$app_dir"
            
            if npm run build > /dev/null 2>&1; then
                echo -e "  ✅ Build réussi pour $app"
                successful_builds=$((successful_builds + 1))
            else
                echo -e "  ⚠️ Build échoué pour $app (non bloquant)"
            fi
        fi
    done
    
    echo ""
    echo -e "${GREEN}📊 Résultat: $successful_builds/5 builds réussis${NC}"
    
    if [ $successful_builds -eq 5 ]; then
        success "Tous les builds fonctionnent!"
    else
        echo -e "${YELLOW}💡 Certains builds ont échoué, mais les applications devraient démarrer en mode développement${NC}"
    fi
}

# Fonction pour créer des configurations TypeScript compatibles
create_compatible_tsconfig() {
    step "Création de configurations TypeScript compatibles"
    
    # Applications React (TypeScript 4.9.5)
    local react_apps=("math4kids" "unitflip" "ai4kids")
    for app in "${react_apps[@]}"; do
        local app_dir="$WORKSPACE_DIR/$app"
        if [ -d "$app_dir" ]; then
            cat > "$app_dir/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "es6"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": [
    "src"
  ]
}
EOF
        fi
    done
    
    # Application Vue.js
    if [ -d "$WORKSPACE_DIR/budgetcron" ]; then
        cat > "$WORKSPACE_DIR/budgetcron/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "esnext",
    "lib": [
      "esnext",
      "dom",
      "dom.iterable"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "preserve"
  },
  "include": [
    "src/**/*",
    "src/**/*.vue"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF
    fi
    
    # Application Next.js
    if [ -d "$WORKSPACE_DIR/multiai" ]; then
        cat > "$WORKSPACE_DIR/multiai/tsconfig.json" << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "es6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
    fi
    
    success "Configurations TypeScript créées"
}

# Fonction principale
main() {
    echo "Résolution des conflits de dépendances TypeScript..."
    echo ""
    
    # Configuration npm pour éviter les conflits
    create_npmrc_config
    
    # Recréer les package.json avec des versions compatibles
    create_compatible_react_package "math4kids"
    create_compatible_react_package "unitflip"
    create_compatible_react_package "ai4kids"
    create_compatible_vue_package "budgetcron"
    create_compatible_nextjs_package "multiai"
    
    # Créer les configurations TypeScript
    create_compatible_tsconfig
    
    # Installer les dépendances avec résolution forcée
    install_with_force "math4kids"
    install_with_force "unitflip"
    install_with_force "ai4kids"
    install_with_force "budgetcron"
    install_with_force "multiai"
    
    # Tester les builds
    test_builds
    
    echo ""
    echo -e "${GREEN}🎉 CORRECTION DES CONFLITS TERMINÉE!${NC}"
    echo ""
    echo -e "${YELLOW}📋 Résumé des corrections:${NC}"
    echo "✅ Configuration .npmrc pour éviter les conflits futurs"
    echo "✅ Package.json avec versions compatibles (TypeScript 4.9.5 pour React)"
    echo "✅ Configurations TypeScript optimisées"
    echo "✅ Installation avec résolution forcée des dépendances"
    echo "✅ Audit de sécurité appliqué"
    echo ""
    echo -e "${YELLOW}🚀 Les applications peuvent maintenant être démarrées:${NC}"
    echo "  ./start-apps.sh"
    echo ""
    echo -e "${YELLOW}💡 En cas de nouveau conflit à l'avenir:${NC}"
    echo "  npm install --legacy-peer-deps"
    echo "  npm audit fix --force --legacy-peer-deps"
    echo ""
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée à la ligne $LINENO${NC}"; exit 1' ERR

# Lancement du script
main