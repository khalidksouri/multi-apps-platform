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
