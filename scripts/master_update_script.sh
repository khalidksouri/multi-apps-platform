#!/bin/bash

# =============================================================================
# SCRIPT MAÎTRE - Mise à jour complète AI4KIDS avec nouveau logo
# =============================================================================

set -e

# Configuration des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration des chemins
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
AI4KIDS_DIR="$PROJECT_ROOT/apps/ai4kids"

# Bannière d'accueil
show_banner() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                               ║${NC}"
    echo -e "${CYAN}║                     🎨 AI4KIDS LOGO UPDATE SCRIPT 🎨                       ║${NC}"
    echo -e "${CYAN}║                                                                               ║${NC}"
    echo -e "${CYAN}║                        Version 2.0 - Nouveau Design                         ║${NC}"
    echo -e "${CYAN}║                                                                               ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}🚀 Ce script va mettre à jour l'application AI4KIDS avec le nouveau logo${NC}"
    echo -e "${WHITE}   et toutes les améliorations associées.${NC}"
    echo ""
}

# Fonction de logging
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    case $level in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} ${timestamp} - $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} ${timestamp} - $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} ${timestamp} - $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} ${timestamp} - $message"
            ;;
        "STEP")
            echo -e "${PURPLE}[STEP]${NC} ${timestamp} - $message"
            ;;
    esac
}

# Vérification des prérequis
check_prerequisites() {
    log "STEP" "Vérification des prérequis..."
    
    # Vérifier Node.js
    if ! command -v node &> /dev/null; then
        log "ERROR" "Node.js n'est pas installé. Veuillez l'installer depuis https://nodejs.org/"
        exit 1
    fi
    
    local node_version=$(node --version | cut -d'v' -f2)
    log "INFO" "Node.js version: $node_version"
    
    # Vérifier npm
    if ! command -v npm &> /dev/null; then
        log "ERROR" "npm n'est pas installé"
        exit 1
    fi
    
    local npm_version=$(npm --version)
    log "INFO" "npm version: $npm_version"
    
    # Vérifier Git
    if ! command -v git &> /dev/null; then
        log "WARNING" "Git n'est pas installé. Certaines fonctionnalités peuvent être limitées."
    fi
    
    # Vérifier la structure du projet
    if [ ! -d "$AI4KIDS_DIR" ]; then
        log "ERROR" "Le dossier apps/ai4kids n'existe pas. Êtes-vous dans le bon répertoire ?"
        exit 1
    fi
    
    log "SUCCESS" "Tous les prérequis sont satisfaits"
}

# Création des scripts auxiliaires
create_scripts() {
    log "STEP" "Création des scripts auxiliaires..."
    
    mkdir -p "$SCRIPTS_DIR"
    
    # Script de création des composants
    cat > "$SCRIPTS_DIR/create_components.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e
echo "🧩 Création des composants React..."
AI4KIDS_APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../apps/ai4kids"
COMPONENTS_DIR="$AI4KIDS_APP_DIR/src/components"
mkdir -p "$COMPONENTS_DIR"
mkdir -p "$COMPONENTS_DIR/ui"

# Créer AI4KidsLogo.tsx
cat > "$COMPONENTS_DIR/AI4KidsLogo.tsx" << 'COMPONENT_EOF'
import React from 'react';

interface LogoProps {
  size?: number;
  className?: string;
}

export const AI4KidsLogo: React.FC<LogoProps> = ({ size = 100, className = '' }) => {
  return (
    <div className={`ai4kids-logo ${className}`} style={{ width: size, height: size }}>
      <svg
        width={size}
        height={size}
        viewBox="0 0 300 300"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        <circle cx="150" cy="150" r="140" fill="white" stroke="#f0f0f0" strokeWidth="2"/>
        <path
          d="M120 200 L150 120 L180 200 M130 180 L170 180"
          stroke="#4a90e2"
          strokeWidth="8"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        />
        <g transform="translate(150, 80)">
          <circle cx="0" cy="0" r="20" fill="#4ECDC4"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        <g transform="translate(220, 150)">
          <circle cx="0" cy="0" r="20" fill="#FF8C42"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        <g transform="translate(150, 220)">
          <circle cx="0" cy="0" r="20" fill="#FF6B9D"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        <g transform="translate(80, 150)">
          <circle cx="0" cy="0" r="20" fill="#95E1D3"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        <g fill="#FFD93D">
          <path d="M50 100 L52 106 L58 106 L53 110 L55 116 L50 112 L45 116 L47 110 L42 106 L48 106 Z"/>
          <path d="M250 100 L252 106 L258 106 L253 110 L255 116 L250 112 L245 116 L247 110 L242 106 L248 106 Z"/>
          <path d="M50 200 L52 206 L58 206 L53 210 L55 216 L50 212 L45 216 L47 210 L42 206 L48 206 Z"/>
          <path d="M250 200 L252 206 L258 206 L253 210 L255 216 L250 212 L245 216 L247 210 L242 206 L248 206 Z"/>
        </g>
      </svg>
    </div>
  );
};

export const AI4KidsLogoWithText: React.FC<LogoProps> = ({ size = 200, className = '' }) => {
  return (
    <div className={`ai4kids-logo-with-text ${className}`} style={{ width: size, height: size * 0.8 }}>
      <AI4KidsLogo size={size * 0.6} />
      <div 
        style={{
          fontSize: size * 0.12,
          fontWeight: 'bold',
          textAlign: 'center',
          marginTop: size * 0.05,
          background: 'linear-gradient(45deg, #FF6B9D, #FF8C42, #4ECDC4, #95E1D3)',
          backgroundClip: 'text',
          WebkitBackgroundClip: 'text',
          color: 'transparent',
          fontFamily: 'Comic Sans MS, cursive, sans-serif'
        }}
      >
        AI4KIDS
      </div>
    </div>
  );
};
COMPONENT_EOF

echo "✅ Composant Logo créé"
SCRIPT_EOF

    # Script de création des assets
    cat > "$SCRIPTS_DIR/create_assets.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e
echo "🖼️ Création des assets..."
AI4KIDS_APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../apps/ai4kids"
mkdir -p "$AI4KIDS_APP_DIR/public"
mkdir -p "$AI4KIDS_APP_DIR/src/styles"

# Créer favicon.svg
cat > "$AI4KIDS_APP_DIR/public/favicon.svg" << 'FAVICON_EOF'
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <rect width="32" height="32" rx="8" fill="white"/>
  <path d="M12 22 L16 14 L20 22 M14 20 L18 20" stroke="#4a90e2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  <circle cx="16" cy="8" r="3" fill="#4ECDC4"/>
  <circle cx="15" cy="7" r="0.5" fill="white"/>
  <circle cx="17" cy="7" r="0.5" fill="white"/>
  <circle cx="24" cy="16" r="3" fill="#FF8C42"/>
  <circle cx="23" cy="15" r="0.5" fill="white"/>
  <circle cx="25" cy="15" r="0.5" fill="white"/>
  <circle cx="16" cy="24" r="3" fill="#FF6B9D"/>
  <circle cx="15" cy="23" r="0.5" fill="white"/>
  <circle cx="17" cy="23" r="0.5" fill="white"/>
  <circle cx="8" cy="16" r="3" fill="#95E1D3"/>
  <circle cx="7" cy="15" r="0.5" fill="white"/>
  <circle cx="9" cy="15" r="0.5" fill="white"/>
  <circle cx="6" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="6" cy="26" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="26" r="1" fill="#FFD93D"/>
</svg>
FAVICON_EOF

# Créer les styles CSS
cat > "$AI4KIDS_APP_DIR/src/styles/ai4kids.css" << 'CSS_EOF'
.ai4kids-logo {
  display: inline-block;
  animation: logoFloat 3s ease-in-out infinite;
}

.ai4kids-logo-with-text {
  display: flex;
  flex-direction: column;
  align-items: center;
  animation: logoFloat 3s ease-in-out infinite;
}

@keyframes logoFloat {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

.ai4kids-logo svg g {
  animation: characterBounce 2s ease-in-out infinite;
}

@keyframes characterBounce {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.1); }
}

.ai4kids-nav {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  backdrop-filter: blur(10px);
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
}

.ai4kids-button {
  border: none;
  border-radius: 25px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
  font-family: 'Comic Sans MS', cursive, sans-serif;
}

.ai4kids-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
}

@media (max-width: 768px) {
  .ai4kids-logo-with-text {
    width: 200px !important;
    height: 160px !important;
  }
}
CSS_EOF

echo "✅ Assets créés"
SCRIPT_EOF

    # Script de mise à jour du package.json
    cat > "$SCRIPTS_DIR/update_package.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e
echo "📦 Mise à jour du package.json..."
AI4KIDS_APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../apps/ai4kids"
cd "$AI4KIDS_APP_DIR"

# Sauvegarder l'ancien package.json
if [ -f "package.json" ]; then
    cp package.json package.json.backup
fi

# Mettre à jour package.json
cat > package.json << 'PACKAGE_EOF'
{
  "name": "@multiapps/ai4kids",
  "version": "2.0.0",
  "private": true,
  "description": "Intelligence Artificielle pour Enfants - Application éducative interactive",
  "scripts": {
    "dev": "next dev -p 3004",
    "build": "next build",
    "start": "next start -p 3004",
    "lint": "next lint",
    "test": "vitest",
    "test:e2e": "playwright test"
  },
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.3.3",
    "tailwindcss": "^3.3.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31"
  },
  "devDependencies": {
    "@types/node": "^20.8.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "eslint": "^8.50.0",
    "eslint-config-next": "^14.0.0",
    "prettier": "^3.0.3",
    "playwright": "^1.39.0"
  }
}
PACKAGE_EOF

echo "✅ Package.json mis à jour"
SCRIPT_EOF

    # Rendre les scripts exécutables
    chmod +x "$SCRIPTS_DIR/create_components.sh"
    chmod +x "$SCRIPTS_DIR/create_assets.sh"
    chmod +x "$SCRIPTS_DIR/update_package.sh"
    
    log "SUCCESS" "Scripts auxiliaires créés et rendus exécutables"
}

# Exécution des scripts
execute_scripts() {
    log "STEP" "Exécution des scripts de mise à jour..."
    
    # Créer une sauvegarde
    local backup_dir="$AI4KIDS_DIR/backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Sauvegarder les fichiers importants
    if [ -f "$AI4KIDS_DIR/src/app/page.tsx" ]; then
        cp "$AI4KIDS_DIR/src/app/page.tsx" "$backup_dir/" 2>/dev/null || true
    fi
    
    if [ -f "$AI4KIDS_DIR/package.json" ]; then
        cp "$AI4KIDS_DIR/package.json" "$backup_dir/" 2>/dev/null || true
    fi
    
    log "INFO" "Sauvegarde créée dans: $backup_dir"
    
    # Exécuter les scripts
    "$SCRIPTS_DIR/create_components.sh" || {
        log "ERROR" "Erreur lors de la création des composants"
        exit 1
    }
    
    "$SCRIPTS_DIR/create_assets.sh" || {
        log "ERROR" "Erreur lors de la création des assets"
        exit 1
    }
    
    "$SCRIPTS_DIR/update_package.sh" || {
        log "ERROR" "Erreur lors de la mise à jour du package.json"
        exit 1
    }
    
    log "SUCCESS" "Tous les scripts ont été exécutés avec succès"
}

# Installation des dépendances
install_dependencies() {
    log "STEP" "Installation des dépendances..."
    
    cd "$AI4KIDS_DIR"
    
    # Installation des dépendances
    npm install || {
        log "ERROR" "Erreur lors de l'installation des dépendances"
        exit 1
    }
    
    log "SUCCESS" "Dépendances installées avec succès"
}

# Test de compilation
test_build() {
    log "STEP" "Test de compilation..."
    
    cd "$AI4KIDS_DIR"
    
    # Test de build
    if npm run build 2>/dev/null; then
        log "SUCCESS" "Build réussi"
    else
        log "WARNING" "Erreur de build - vérifiez les logs"
        return 1
    fi
}

# Mise à jour du README.md
update_readme() {
    log "STEP" "Mise à jour du README.md..."
    
    cat > "$PROJECT_ROOT/README.md" << 'README_EOF'
# 🎨 AI4KIDS - Intelligence Artificielle pour Enfants

<div align="center">
  <img src="apps/ai4kids/public/favicon.svg" alt="Logo AI4KIDS" width="120" height="120">
  
  [![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/votre-repo/ai4kids)
  [![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
  [![TypeScript](https://img.shields.io/badge/TypeScript-5.3+-blue.svg)](https://www.typescriptlang.org/)
  [![React](https://img.shields.io/badge/React-18.2+-61DAFB.svg)](https://reactjs.org/)
  [![Next.js](https://img.shields.io/badge/Next.js-14+-000000.svg)](https://nextjs.org/)
</div>

## 🌟 Découvrez le nouveau AI4KIDS !

AI4KIDS est une application éducative interactive qui initie les enfants au monde fascinant de l'intelligence artificielle à travers des jeux, des histoires et des activités ludiques.

### 🎯 **Nouveau Logo & Identité Visuelle**

Notre nouvelle identité visuelle reflète l'esprit inclusif et éducatif de l'application :
- **4 personnages colorés** représentant la diversité des enfants
- **Couleurs vives et engageantes** : Bleu turquoise, Orange, Rose, Vert menthe
- **Design adapté aux enfants** avec des animations douces et interactives
- **Responsive** sur tous les supports (mobile, tablette, desktop)

## 🚀 Installation Rapide

```bash
# Cloner le repository
git clone https://github.com/votre-repo/ai4kids.git
cd ai4kids

# Exécuter le script de mise à jour
chmod +x scripts/master-update.sh
./scripts/master-update.sh

# Lancer l'application
cd apps/ai4kids
npm run dev
```

## 🎮 Fonctionnalités Principales

### 🎯 **Jeux Éducatifs**
- Mathématiques interactives
- Sciences amusantes
- Programmation pour débutants
- Logique et résolution de problèmes

### 📚 **Histoires Magiques**
- Contes éducatifs avec personnages IA
- Histoires interactives
- Leçons de vie intégrées
- Narration multilingue

### 🤖 **Découverte de l'IA**
- Concepts simplifiés pour enfants
- Exemples concrets
- Ateliers pratiques
- Éthique et responsabilité

## 🛠️ Stack Technologique

```
Frontend: Next.js 14+ + TypeScript + Tailwind CSS
Backend: Fastify + Node.js
Testing: Playwright + Vitest
Mobile: Capacitor (iOS/Android)
```

## 📱 Scripts Disponibles

```bash
npm run dev              # Développement (port 3004)
npm run build           # Build de production
npm run start           # Serveur de production
npm run test            # Tests unitaires
npm run test:e2e        # Tests end-to-end
npm run lint            # Vérification du code
```

## 🎨 Nouveau Design

Le logo AI4KIDS a été entièrement repensé :
- **Lettre A centrale** : AI + Apprentissage
- **4 personnages** : Diversité et inclusion
- **Animations fluides** : Engagement des enfants
- **Couleurs vives** : Joie et créativité

## 🌍 Internationalisation

Langues supportées :
- 🇫🇷 Français (par défaut)
- 🇬🇧 Anglais
- 🇪🇸 Espagnol
- 🇩🇪 Allemand
- 🇮🇹 Italien

## 🔒 Sécurité & Vie Privée

- Environnement sûr pour enfants
- Pas de collecte de données personnelles
- Contenu modéré et approprié
- Navigation sécurisée

## 🤝 Contribution

1. Fork le repository
2. Créer une branche feature
3. Commit vos changements
4. Push vers la branche
5. Créer une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

## 🙏 Remerciements

- Équipe de développement AI4KIDS
- Communauté des parents et enfants testeurs
- Pédagogues spécialisés

---

<div align="center">
  <p><strong>AI4KIDS</strong> - Ensemble, construisons l'avenir de l'éducation ! 🚀</p>
</div>
README_EOF

    log "SUCCESS" "README.md mis à jour avec succès"
}

# Résumé final
show_summary() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                               ║${NC}"
    echo -e "${CYAN}║                    🎉 MISE À JOUR TERMINÉE AVEC SUCCÈS ! 🎉                ║${NC}"
    echo -e "${CYAN}║                                                                               ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${GREEN}✅ Nouveau logo AI4KIDS implémenté${NC}"
    echo -e "${GREEN}✅ Composants React créés${NC}"
    echo -e "${GREEN}✅ Assets et styles générés${NC}"
    echo -e "${GREEN}✅ Package.json mis à jour${NC}"
    echo -e "${GREEN}✅ README.md actualisé${NC}"
    echo -e "${GREEN}✅ Dépendances installées${NC}"
    echo ""
    echo -e "${YELLOW}📋 Prochaines étapes :${NC}"
    echo -e "${WHITE}1. Accédez au dossier: ${CYAN}cd apps/ai4kids${NC}"
    echo -e "${WHITE}2. Lancez l'application: ${CYAN}npm run dev${NC}"
    echo -e "${WHITE}3. Ouvrez votre navigateur: ${CYAN}http://localhost:3004${NC}"
    echo ""
    echo -e "${BLUE}🔗 Liens utiles :${NC}"
    echo -e "${WHITE}• Documentation: ${CYAN}docs/README.md${NC}"
    echo -e "${WHITE}• Tests: ${CYAN}npm run test:e2e${NC}"
    echo -e "${WHITE}• Storybook: ${CYAN}npm run storybook${NC}"
    echo ""
    echo -e "${PURPLE}🎨 Nouveau design AI4KIDS prêt à l'emploi !${NC}"
}

# Gestion des erreurs
handle_error() {
    log "ERROR" "Erreur détectée à la ligne $1"
    echo ""
    echo -e "${RED}❌ La mise à jour a échoué${NC}"
    echo -e "${YELLOW}💡 Vérifiez les logs ci-dessus pour plus de détails${NC}"
    echo -e "${BLUE}🔧 Vous pouvez relancer le script après avoir corrigé les erreurs${NC}"
    exit 1
}

# Fonction principale
main() {
    show_banner
    
    # Demander confirmation
    echo -e "${YELLOW}⚠️  Ce script va modifier les fichiers du projet AI4KIDS${NC}"
    echo -e "${WHITE}   Voulez-vous continuer ? (y/N)${NC}"
    read -r response
    
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}👋 Mise à jour annulée${NC}"
        exit 0
    fi
    
    check_prerequisites
    create_scripts
    execute_scripts
    install_dependencies
    test_build
    update_readme
    show_summary
}

# Configuration du trap pour les erreurs
trap 'handle_error $LINENO' ERR

# Lancement du script principal
main "$@"