#!/bin/bash

#===============================================================================
# MATH4CHILD - CORRECTION ET DÉMARRAGE
# Corrige tous les problèmes et démarre l'application
#===============================================================================

set -euo pipefail

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${GREEN}[${timestamp}] ℹ️  INFO: ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  WARN: ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ERROR: ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ SUCCESS: ${message}${NC}" ;;
    esac
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🔧 MATH4CHILD - CORRECTION ET DÉMARRAGE                  ║
║                      Résolution de tous les problèmes                       ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Aller au bon répertoire
go_to_project_root() {
    log_message "INFO" "📍 Recherche du répertoire du projet..."
    
    # Essayer plusieurs emplacements possibles
    local possible_paths=(
        "/Users/khalidksouri/Desktop/multi-apps-platform"
        "$(pwd)"
        "$(dirname "$(pwd)")"
        "/Users/khalidksouri/Desktop/multi-apps-platform/apps/math4child"
    )
    
    for path in "${possible_paths[@]}"; do
        if [ -d "$path" ]; then
            cd "$path"
            log_message "INFO" "Répertoire actuel: $(pwd)"
            
            # Vérifier si nous avons la structure attendue
            if [ -d "apps/math4child" ] || [ -f "package.json" ]; then
                log_message "SUCCESS" "Répertoire du projet trouvé: $path"
                return 0
            fi
        fi
    done
    
    log_message "ERROR" "Impossible de trouver le répertoire du projet"
    exit 1
}

# Nettoyer tous les processus Node.js
cleanup_processes() {
    log_message "INFO" "🧹 Nettoyage des processus Node.js..."
    
    # Tuer tous les processus Next.js
    pkill -f "next" 2>/dev/null || true
    pkill -f "node.*dev" 2>/dev/null || true
    
    # Libérer les ports 3000 et 3001
    for port in 3000 3001; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            local pid=$(lsof -Pi :$port -sTCP:LISTEN -t)
            log_message "INFO" "Libération du port $port (PID: $pid)..."
            kill -9 $pid 2>/dev/null || true
        fi
    done
    
    sleep 2
    log_message "SUCCESS" "Nettoyage terminé"
}

# Vérifier et corriger la structure du projet
fix_project_structure() {
    log_message "INFO" "🏗️ Vérification de la structure du projet..."
    
    # Si nous ne sommes pas dans apps/math4child, aller dans le répertoire racine
    if [ ! -f "package.json" ] && [ -d "apps/math4child" ]; then
        cd apps/math4child
        log_message "INFO" "Déplacement vers apps/math4child"
    fi
    
    # Si toujours pas de package.json, créer une structure basique
    if [ ! -f "package.json" ]; then
        log_message "WARN" "Package.json manquant, création d'un package.json basique..."
        
        cat > package.json << 'EOF'
{
  "name": "math4child-app",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "typescript": "5.3.3",
    "@types/node": "20.10.6",
    "@types/react": "18.2.45",
    "@types/react-dom": "18.2.18",
    "tailwindcss": "3.4.0",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.32"
  },
  "devDependencies": {
    "eslint": "8.56.0",
    "eslint-config-next": "14.0.4"
  }
}
EOF
        log_message "SUCCESS" "Package.json créé"
    fi
    
    # Corriger le port dans package.json
    if grep -q "next dev -p 3001" package.json; then
        sed -i '' 's/next dev -p 3001/next dev -p 3000/g' package.json
        log_message "SUCCESS" "Port corrigé dans package.json"
    fi
    
    # Vérifier les répertoires src
    if [ ! -d "src" ]; then
        mkdir -p src/app
        log_message "INFO" "Répertoire src créé"
    fi
    
    log_message "SUCCESS" "Structure du projet vérifiée"
}

# Créer les fichiers essentiels s'ils manquent
create_essential_files() {
    log_message "INFO" "📝 Création des fichiers essentiels..."
    
    # Layout principal
    if [ ! -f "src/app/layout.tsx" ]; then
        mkdir -p src/app
        cat > src/app/layout.tsx << 'EOF'
import { ReactNode } from 'react'

export const metadata = {
  title: 'Math4Child - Application Éducative',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="fr">
      <body style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>
        {children}
      </body>
    </html>
  )
}
EOF
        log_message "SUCCESS" "Layout créé"
    fi
    
    # Page principale
    if [ ! -f "src/app/page.tsx" ]; then
        cat > src/app/page.tsx << 'EOF'
export default function HomePage() {
  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      justifyContent: 'center',
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      color: 'white',
      textAlign: 'center',
      padding: '2rem'
    }}>
      <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
        🧮 Math4Child
      </h1>
      <p style={{ fontSize: '1.2rem', marginBottom: '2rem', maxWidth: '600px' }}>
        Application Math4Child démarrée avec succès !
      </p>
      <div style={{
        background: 'rgba(255,255,255,0.1)',
        padding: '1rem 2rem',
        borderRadius: '10px',
        backdropFilter: 'blur(10px)'
      }}>
        <p>✅ Next.js + TypeScript</p>
        <p>🚀 Port 3000 configuré</p>
        <p>📱 Interface responsive</p>
      </div>
    </div>
  )
}
EOF
        log_message "SUCCESS" "Page principale créée"
    fi
    
    # Configuration Next.js
    if [ ! -f "next.config.js" ]; then
        cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
EOF
        log_message "SUCCESS" "Configuration Next.js créée"
    fi
}

# Installer les dépendances
install_dependencies() {
    log_message "INFO" "📦 Installation des dépendances..."
    
    # Supprimer node_modules et package-lock.json s'ils existent
    rm -rf node_modules package-lock.json 2>/dev/null || true
    
    # Installation propre
    npm install
    
    log_message "SUCCESS" "Dépendances installées"
}

# Démarrer l'application
start_application() {
    log_message "INFO" "🚀 Démarrage de l'application Math4Child..."
    
    log_message "SUCCESS" "🌐 Application sera accessible sur: http://localhost:3000"
    log_message "INFO" "Appuyez sur Ctrl+C pour arrêter"
    
    # Ouvrir automatiquement le navigateur (macOS)
    sleep 3 && open http://localhost:3000 &
    
    # Démarrer Next.js
    npm run dev
}

# Fonction principale
main() {
    show_banner
    
    log_message "INFO" "🔧 Correction et démarrage de Math4Child..."
    
    go_to_project_root
    cleanup_processes
    fix_project_structure
    create_essential_files
    install_dependencies
    start_application
}

# Gestion des erreurs
trap 'log_message "ERROR" "Script interrompu"; exit 1' ERR
trap 'log_message "INFO" "Arrêt de l'\''application"; exit 0' INT

main "$@"