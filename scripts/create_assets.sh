#!/bin/bash

set -e

echo "🖼️  Création des assets et styles..."

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"
STYLES_DIR="$AI4KIDS_APP_DIR/src/styles"
PUBLIC_DIR="$AI4KIDS_APP_DIR/public"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Créer les dossiers
mkdir -p "$STYLES_DIR"
mkdir -p "$PUBLIC_DIR"

# Créer le fichier de styles principal
echo -e "${BLUE}🎨 Création des styles CSS...${NC}"
cat > "$STYLES_DIR/ai4kids.css" << 'STYLES_EOF'
/* Styles pour le logo AI4KIDS */
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

/* Animation flottante pour le logo */
@keyframes logoFloat {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-10px);
  }
}

/* Animation pour les personnages du logo */
.ai4kids-logo svg g {
  animation: characterBounce 2s ease-in-out infinite;
}

.ai4kids-logo svg g:nth-child(2) {
  animation-delay: 0.2s;
}

.ai4kids-logo svg g:nth-child(3) {
  animation-delay: 0.4s;
}

.ai4kids-logo svg g:nth-child(4) {
  animation-delay: 0.6s;
}

.ai4kids-logo svg g:nth-child(5) {
  animation-delay: 0.8s;
}

@keyframes characterBounce {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

/* Styles pour la navigation */
.ai4kids-nav {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  backdrop-filter: blur(10px);
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
}

.ai4kids-nav .logo {
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

/* Styles pour les boutons */
.ai4kids-button {
  border: none;
  border-radius: 25px;
  color: white;
  font-size: 1.1rem;
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

/* Styles pour les cartes de fonctionnalités */
.feature-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 24px;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(10px);
  border: 2px solid rgba(255, 255, 255, 0.3);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

/* Styles pour les étoiles décoratives */
.ai4kids-stars {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
  z-index: -1;
}

.ai4kids-star {
  position: absolute;
  color: #FFD93D;
  animation: twinkle 3s ease-in-out infinite;
}

@keyframes twinkle {
  0%, 100% {
    opacity: 0.3;
    transform: scale(1);
  }
  50% {
    opacity: 1;
    transform: scale(1.2);
  }
}

/* Styles responsive */
@media (max-width: 768px) {
  .ai4kids-logo-with-text {
    width: 200px !important;
    height: 160px !important;
  }
  
  .ai4kids-button {
    font-size: 1rem;
    padding: 0.8rem 1.5rem;
  }
}
STYLES_EOF

# Créer le favicon SVG
echo -e "${BLUE}📝 Création du favicon...${NC}"
cat > "$PUBLIC_DIR/favicon.svg" << 'FAVICON_EOF'
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Fond -->
  <rect width="32" height="32" rx="8" fill="white"/>
  
  <!-- Lettre A simplifiée -->
  <path d="M12 22 L16 14 L20 22 M14 20 L18 20" stroke="#4a90e2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" fill="none"/>
  
  <!-- Personnages simplifiés -->
  <!-- Bleu (haut) -->
  <circle cx="16" cy="8" r="3" fill="#4ECDC4"/>
  <circle cx="15" cy="7" r="0.5" fill="white"/>
  <circle cx="17" cy="7" r="0.5" fill="white"/>
  
  <!-- Orange (droite) -->
  <circle cx="24" cy="16" r="3" fill="#FF8C42"/>
  <circle cx="23" cy="15" r="0.5" fill="white"/>
  <circle cx="25" cy="15" r="0.5" fill="white"/>
  
  <!-- Rose (bas) -->
  <circle cx="16" cy="24" r="3" fill="#FF6B9D"/>
  <circle cx="15" cy="23" r="0.5" fill="white"/>
  <circle cx="17" cy="23" r="0.5" fill="white"/>
  
  <!-- Vert (gauche) -->
  <circle cx="8" cy="16" r="3" fill="#95E1D3"/>
  <circle cx="7" cy="15" r="0.5" fill="white"/>
  <circle cx="9" cy="15" r="0.5" fill="white"/>
  
  <!-- Étoiles décoratives -->
  <circle cx="6" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="6" r="1" fill="#FFD93D"/>
  <circle cx="6" cy="26" r="1" fill="#FFD93D"/>
  <circle cx="26" cy="26" r="1" fill="#FFD93D"/>
</svg>
FAVICON_EOF

# Créer le manifest PWA
echo -e "${BLUE}📝 Création du manifest PWA...${NC}"
cat > "$PUBLIC_DIR/site.webmanifest" << 'MANIFEST_EOF'
{
  "name": "AI4KIDS",
  "short_name": "AI4KIDS",
  "description": "Intelligence Artificielle pour Enfants",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#4ECDC4",
  "icons": [
    {
      "src": "/favicon.svg",
      "sizes": "any",
      "type": "image/svg+xml"
    }
  ],
  "categories": ["education", "kids", "games"],
  "lang": "fr",
  "orientation": "portrait"
}
MANIFEST_EOF

echo -e "${GREEN}✅ Assets et styles créés avec succès${NC}"
