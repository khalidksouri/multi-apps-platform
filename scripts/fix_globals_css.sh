#!/bin/bash

#===============================================================================
# MATH4CHILD - CORRECTION GLOBALS.CSS
# Crée le fichier globals.css manquant
#===============================================================================

echo "🎨 Création du fichier globals.css manquant..."

# Créer le fichier globals.css
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
}

html {
  scroll-behavior: smooth;
}

body {
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  line-height: 1.6;
}

/* Focus styles pour l'accessibilité */
*:focus {
  outline: 2px solid #3b82f6;
  outline-offset: 2px;
}

/* Styles pour RTL */
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

/* Animation pour les dropdowns */
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

/* Styles pour les transitions */
.transition-all {
  transition: all 0.2s ease-in-out;
}

/* Styles personnalisés pour Math4Child */
.math4child-gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.math4child-shadow {
  box-shadow: 0 10px 40px rgba(0,0,0,0.1);
}

/* Améliorations pour la navigation */
.nav-item {
  position: relative;
  overflow: hidden;
}

.nav-item::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
  transition: left 0.5s;
}

.nav-item:hover::before {
  left: 100%;
}

/* Styles pour les pages */
.page-container {
  min-height: calc(100vh - 80px);
  padding: 2rem;
}

.page-title {
  font-size: 2.5rem;
  font-weight: bold;
  color: #1f2937;
  margin-bottom: 1rem;
  text-align: center;
}

.page-subtitle {
  font-size: 1.125rem;
  color: #6b7280;
  text-align: center;
  margin-bottom: 2rem;
}

/* Styles pour les cartes */
.card {
  background: white;
  border-radius: 1rem;
  box-shadow: 0 4px 20px rgba(0,0,0,0.1);
  padding: 2rem;
  transition: transform 0.2s, box-shadow 0.2s;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
}

/* Styles pour les boutons */
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

/* Animations d'entrée */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out;
}

/* Responsive amélioré */
@media (max-width: 640px) {
  .page-title {
    font-size: 2rem;
  }
  
  .page-container {
    padding: 1rem;
  }
  
  .card {
    padding: 1.5rem;
  }
}

/* Dark mode (pour plus tard) */
@media (prefers-color-scheme: dark) {
  :root {
    --foreground-rgb: 255, 255, 255;
    --background-start-rgb: 0, 0, 0;
    --background-end-rgb: 0, 0, 0;
  }
}

/* Améliorations pour l'accessibilité */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Skip link pour l'accessibilité */
.skip-link {
  position: absolute;
  top: -40px;
  left: 6px;
  background: #000;
  color: #fff;
  padding: 8px;
  text-decoration: none;
  border-radius: 0 0 8px 8px;
}

.skip-link:focus {
  top: 0;
}
EOF

echo "✅ Fichier globals.css créé avec succès !"

# Vérifier que TailwindCSS est configuré
if [ ! -f "tailwind.config.js" ]; then
    echo "⚠️  TailwindCSS config manquante, création..."
    
    cat > tailwind.config.js << 'EOF'
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
      fontFamily: {
        sans: ['system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [],
}
EOF
    echo "✅ TailwindCSS configuré"
fi

# Vérifier que PostCSS est configuré
if [ ! -f "postcss.config.js" ]; then
    echo "⚠️  PostCSS config manquante, création..."
    
    cat > postcss.config.js << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    echo "✅ PostCSS configuré"
fi

echo ""
echo "🎉 Configuration CSS complète !"
echo "🚀 Vous pouvez maintenant relancer: npm run dev"