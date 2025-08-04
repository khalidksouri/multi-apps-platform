#!/bin/bash

echo "🚀 Déploiement Vercel Math4Child Beta"
echo "===================================="

echo "📋 Instructions Vercel :"
echo ""
echo "1️⃣ Créer compte Vercel (gratuit)"
echo "   → https://vercel.com/signup"
echo ""
echo "2️⃣ Import project"
echo "   → Import Git Repository"
echo "   → Sélectionner votre repo Math4Child"
echo ""
echo "3️⃣ Configuration automatique"
echo "   → Next.js détecté automatiquement"
echo "   → Build: npm run build"
echo "   → Output: .next"
echo ""
echo "4️⃣ Variables d'environnement"
echo "   → CAPACITOR_BUILD = false"
echo ""
echo "5️⃣ Domaine (optionnel)"
echo "   → math4child-beta.vercel.app"
echo "   → ou domaine personnalisé"
echo ""

if command -v vercel >/dev/null 2>&1; then
    echo "🔧 Vercel CLI détecté"
    echo ""
    echo "   Déploiement direct :"
    echo "   → vercel login"
    echo "   → vercel --prod"
else
    echo "💡 Installation Vercel CLI :"
    echo "   → npm install -g vercel"
    echo "   → vercel login"
    echo "   → vercel --prod"
fi

echo ""
echo "⚡ Déploiement Vercel = 30 secondes"
echo "🌐 URL instantanément disponible"
