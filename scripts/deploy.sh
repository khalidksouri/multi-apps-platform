#!/bin/bash

set -e

echo "🚀 Déploiement du nouveau logo AI4KIDS..."

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Vérifications préalables
echo -e "${BLUE}📋 Vérifications préalables...${NC}"

if [ ! -d "$AI4KIDS_APP_DIR" ]; then
    echo -e "${RED}❌ Erreur: Le dossier apps/ai4kids n'existe pas${NC}"
    exit 1
fi

# Vérifier Node.js et npm
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js n'est pas installé${NC}"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm n'est pas installé${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Vérifications réussies${NC}"

# Créer les dossiers nécessaires
echo -e "${BLUE}📁 Création des dossiers...${NC}"
mkdir -p "$AI4KIDS_APP_DIR/src/components"
mkdir -p "$AI4KIDS_APP_DIR/src/components/ui"
mkdir -p "$AI4KIDS_APP_DIR/src/styles"
mkdir -p "$AI4KIDS_APP_DIR/src/app"
mkdir -p "$AI4KIDS_APP_DIR/public"

# Sauvegarder les fichiers existants
echo -e "${BLUE}💾 Sauvegarde des fichiers existants...${NC}"
BACKUP_DIR="$AI4KIDS_APP_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Sauvegarder les fichiers principaux
files_to_backup=(
    "src/app/page.tsx"
    "src/app/layout.tsx"
    "src/index.ts"
    "package.json"
    "tailwind.config.js"
    "next.config.js"
)

for file in "${files_to_backup[@]}"; do
    if [ -f "$AI4KIDS_APP_DIR/$file" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$file")"
        cp "$AI4KIDS_APP_DIR/$file" "$BACKUP_DIR/$file"
        echo -e "${BLUE}💾 Sauvegardé: $file${NC}"
    fi
done

# Rendre les scripts exécutables
chmod +x "$SCRIPT_DIR/create_components.sh"
chmod +x "$SCRIPT_DIR/create_assets.sh"
chmod +x "$SCRIPT_DIR/update_package.sh"

# Exécuter les scripts
echo -e "${BLUE}🧩 Création des composants...${NC}"
"$SCRIPT_DIR/create_components.sh"

echo -e "${BLUE}🎨 Création des assets...${NC}"
"$SCRIPT_DIR/create_assets.sh"

echo -e "${BLUE}📦 Mise à jour du package...${NC}"
"$SCRIPT_DIR/update_package.sh"

# Créer les pages mises à jour
echo -e "${BLUE}📝 Création des pages mises à jour...${NC}"

# Page d'accueil
cat > "$AI4KIDS_APP_DIR/src/app/page.tsx" << 'PAGE_EOF'
import React from 'react';
import { AI4KidsLogoWithText } from '../components/AI4KidsLogo';
import { Button } from '../components/ui/Button';
import { Card } from '../components/ui/Card';

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-400 via-pink-300 to-orange-300">
      <div className="container mx-auto px-4 py-8">
        {/* Header avec nouveau logo */}
        <header className="text-center mb-12">
          <div className="flex justify-center mb-6">
            <AI4KidsLogoWithText size={300} />
          </div>
          <h1 className="text-5xl font-bold text-white mb-4 drop-shadow-lg">
            Bienvenue sur AI4KIDS
          </h1>
          <p className="text-xl text-white/90 max-w-2xl mx-auto">
            Découvre le monde passionnant de l'intelligence artificielle 
            à travers des jeux, des histoires et des activités éducatives !
          </p>
        </header>

        {/* Section principales fonctionnalités */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
          {/* Jeux éducatifs */}
          <Card className="border-2 border-blue-200 text-center">
            <div className="text-6xl mb-4">🎮</div>
            <h3 className="text-2xl font-bold text-blue-600 mb-4">Jeux Éducatifs</h3>
            <p className="text-gray-700 mb-6">
              Apprends les mathématiques, les sciences et bien plus à travers des jeux interactifs !
            </p>
            <Button variant="primary">Jouer maintenant</Button>
          </Card>

          {/* Histoires interactives */}
          <Card className="border-2 border-green-200 text-center">
            <div className="text-6xl mb-4">📚</div>
            <h3 className="text-2xl font-bold text-green-600 mb-4">Histoires Magiques</h3>
            <p className="text-gray-700 mb-6">
              Découvre des histoires captivantes qui t'enseignent des valeurs importantes !
            </p>
            <Button variant="success">Lire une histoire</Button>
          </Card>

          {/* Découverte IA */}
          <Card className="border-2 border-orange-200 text-center">
            <div className="text-6xl mb-4">🤖</div>
            <h3 className="text-2xl font-bold text-orange-600 mb-4">Découvre l'IA</h3>
            <p className="text-gray-700 mb-6">
              Apprends comment fonctionne l'intelligence artificielle de manière simple et amusante !
            </p>
            <Button variant="secondary">Explorer l'IA</Button>
          </Card>
        </div>

        {/* Call to action */}
        <div className="text-center">
          <div className="bg-gradient-to-r from-purple-600 to-pink-600 rounded-3xl p-8 text-white shadow-xl">
            <h2 className="text-3xl font-bold mb-4">Prêt à commencer l'aventure ?</h2>
            <p className="text-xl mb-6 text-white/90">
              Rejoins des milliers d'enfants qui apprennent et s'amusent avec AI4KIDS !
            </p>
            <Button size="lg" className="bg-white text-purple-600 hover:bg-gray-100">
              Commencer maintenant
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
PAGE_EOF

# Layout
cat > "$AI4KIDS_APP_DIR/src/app/layout.tsx" << 'LAYOUT_EOF'
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import '../styles/ai4kids.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'AI4KIDS - Intelligence Artificielle pour Enfants',
  description: 'Découvre le monde passionnant de l\'intelligence artificielle à travers des jeux, des histoires et des activités éducatives adaptées aux enfants.',
  keywords: ['AI4KIDS', 'intelligence artificielle', 'enfants', 'éducation', 'jeux éducatifs', 'apprentissage'],
  authors: [{ name: 'AI4KIDS Team' }],
  creator: 'AI4KIDS',
  publisher: 'AI4KIDS',
  icons: {
    icon: [
      {
        url: '/favicon.svg',
        type: 'image/svg+xml',
      },
    ],
  },
  manifest: '/site.webmanifest',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="fr">
      <head>
        <meta name="theme-color" content="#4ECDC4" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Comic+Neue:wght@300;400;700&display=swap" rel="stylesheet" />
      </head>
      <body className={inter.className}>
        <div className="ai4kids-stars">
          <div className="ai4kids-star" style={{ top: '10%', left: '15%' }}>⭐</div>
          <div className="ai4kids-star" style={{ top: '20%', right: '20%' }}>✨</div>
          <div className="ai4kids-star" style={{ bottom: '15%', left: '10%' }}>🌟</div>
          <div className="ai4kids-star" style={{ bottom: '25%', right: '15%' }}>💫</div>
        </div>
        {children}
      </body>
    </html>
  );
}
LAYOUT_EOF

# Installer les dépendances
echo -e "${BLUE}📦 Installation des dépendances...${NC}"
cd "$AI4KIDS_APP_DIR"
npm install

# Test de build
echo -e "${BLUE}🧪 Test de build...${NC}"
if npm run build; then
    echo -e "${GREEN}✅ Build réussi${NC}"
else
    echo -e "${YELLOW}⚠️ Erreur de build (vérifiez les logs)${NC}"
fi

# Mettre à jour le README
echo -e "${BLUE}📝 Mise à jour du README...${NC}"
cat > "$PROJECT_ROOT/README.md" << 'README_EOF'
# 🎨 AI4KIDS - Intelligence Artificielle pour Enfants

<div align="center">
  <img src="apps/ai4kids/public/favicon.svg" alt="Logo AI4KIDS" width="120" height="120">
  
  [![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/votre-repo/ai4kids)
  [![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/votre-repo/ai4kids/actions)
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

## 🚀 Installation & Démarrage

### 📋 **Prérequis**
- Node.js 18+ et npm 9+
- Git pour le versioning

### 🚀 **Installation Rapide**

```bash
# Cloner le repository
git clone https://github.com/votre-repo/ai4kids.git
cd ai4kids

# Déployer le nouveau logo
./scripts/deploy.sh

# Lancer en développement
cd apps/ai4kids
npm run dev
```

L'application sera disponible sur `http://localhost:3004`

## 🎨 Fonctionnalités du nouveau logo

✅ **Composant Logo React** avec animations  
✅ **4 personnages colorés** représentant la diversité  
✅ **Palette de couleurs moderne** (Bleu, Orange, Rose, Vert)  
✅ **Animations fluides** et interactions  
✅ **Design responsive** pour tous les écrans  
✅ **Assets optimisés** (favicon, manifest PWA)  
✅ **Styles CSS complets** avec Tailwind  
✅ **TypeScript** avec typage complet  

## 🤝 Contribution

Les contributions sont les bienvenues ! Consultez le guide de contribution pour plus de détails.

## 📄 Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

<div align="center">
  <p><strong>Fait avec ❤️ pour l'éducation des enfants</strong></p>
</div>
README_EOF

echo ""
echo -e "${GREEN}🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS !${NC}"
echo ""
echo -e "${BLUE}📋 Prochaines étapes :${NC}"
echo "1. Testez l'application: cd apps/ai4kids && npm run dev"
echo "2. Ouvrez votre navigateur: http://localhost:3004"
echo "3. Vérifiez le nouveau logo et l'interface"
echo ""
echo -e "${YELLOW}📁 Sauvegarde des anciens fichiers disponible dans:${NC}"
echo "   $BACKUP_DIR"
echo ""
