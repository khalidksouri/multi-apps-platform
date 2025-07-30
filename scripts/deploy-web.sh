#!/bin/bash
# Déploiement Web (www.math4child.com)

echo "🌐 Déploiement Web Math4Child..."

# Vérifications préalables
if [ ! -f "package.json" ]; then
    echo "❌ package.json non trouvé"
    exit 1
fi

# Build production
echo "📦 Build production..."
npm run build

# Export statique (si nécessaire)
if [ -f "next.config.js" ] && grep -q "output.*export" next.config.js; then
    echo "📤 Export statique..."
    npm run export
fi

# Déploiement
echo "🚀 Déploiement sur Vercel..."
if command -v vercel >/dev/null 2>&1; then
    vercel --prod
    echo "✅ Déployé sur: https://www.math4child.com"
else
    echo "⚠️  Vercel CLI non installé"
    echo "💡 Installation: npm i -g vercel"
fi
