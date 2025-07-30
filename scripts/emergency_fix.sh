#!/bin/bash

echo "🚨 RÉPARATION D'URGENCE - Math4Child"
echo "===================================="

# Arrêter le serveur qui pourrait tourner
echo "🛑 Arrêt du serveur..."
pkill -f "next dev" || true
sleep 2

# Nettoyer le cache Next.js
echo "🧹 Nettoyage du cache..."
rm -rf .next
rm -rf node_modules/.cache

# Créer le fichier globals.css
echo "🎨 Création de globals.css..."
mkdir -p src/app

cat > src/app/globals.css << 'CSSEOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html, body {
  max-width: 100vw;
  overflow-x: hidden;
  scroll-behavior: smooth;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  line-height: 1.6;
}

*:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Support RTL */
[dir="rtl"] {
  text-align: right;
}

[dir="rtl"] .space-x-2 > * + * {
  margin-right: 0.5rem;
  margin-left: 0;
}

[dir="rtl"] .space-x-4 > * + * {
  margin-right: 1rem;
  margin-left: 0;
}

[dir="rtl"] .space-x-6 > * + * {
  margin-right: 1.5rem;
  margin-left: 0;
}

/* Transitions */
.transition-all {
  transition: all 0.2s ease-in-out;
}

/* Animation dropdowns */
@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.dropdown-enter {
  animation: slideDown 0.2s ease-out;
}

/* Styles boutons */
.btn-primary {
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 20px rgba(59, 130, 246, 0.3);
}

.btn-secondary {
  background: white;
  color: #374151;
  border: 2px solid #d1d5db;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-secondary:hover {
  border-color: #3b82f6;
  color: #3b82f6;
}

/* Responsive */
@media (max-width: 640px) {
  .space-x-2 > * + * {
    margin-left: 0.5rem;
  }
  
  .space-x-4 > * + * {
    margin-left: 1rem;
  }
}
CSSEOF

# Vérifier que le fichier existe
if [ -f "src/app/globals.css" ]; then
    echo "✅ globals.css créé avec succès"
    echo "📏 Taille: $(wc -c < src/app/globals.css) bytes"
else
    echo "❌ Échec création globals.css"
    exit 1
fi

# Créer tailwind.config.js si manquant
if [ ! -f "tailwind.config.js" ]; then
    echo "⚙️ Création tailwind.config.js..."
    cat > tailwind.config.js << 'TAILWINDEOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'math4child': {
          50: '#eff6ff',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
        }
      },
    },
  },
  plugins: [],
}
TAILWINDEOF
    echo "✅ tailwind.config.js créé"
fi

# Créer postcss.config.js si manquant
if [ ! -f "postcss.config.js" ]; then
    echo "⚙️ Création postcss.config.js..."
    cat > postcss.config.js << 'POSTCSSEOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
POSTCSSEOF
    echo "✅ postcss.config.js créé"
fi

# Vérifier les dépendances TailwindCSS
echo "📦 Vérification des dépendances..."
if ! npm list tailwindcss >/dev/null 2>&1; then
    echo "⬇️ Installation de TailwindCSS..."
    npm install -D tailwindcss postcss autoprefixer
fi

echo ""
echo "🎉 RÉPARATION TERMINÉE !"
echo "========================"
echo ""
echo "📁 Fichiers créés :"
echo "   ✅ src/app/globals.css"
echo "   ✅ tailwind.config.js"
echo "   ✅ postcss.config.js"
echo ""
echo "🚀 Relancez maintenant :"
echo "   npm run dev"
echo ""
echo "🌐 Puis ouvrez : http://localhost:3000"