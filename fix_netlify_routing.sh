#!/bin/bash
set -e

echo "🔧 CORRECTION ROUTING NEXT.JS POUR NETLIFY"
echo "=========================================="
echo ""
echo "🔍 PROBLÈME IDENTIFIÉ :"
echo "• Build Netlify : ✅ PARFAIT (16 fichiers, Site is live)"
echo "• Problème : Routing Next.js App Router sur Netlify"
echo "• Solution : Ajouter netlify.toml avec redirections"
echo ""

cd apps/math4child

# ===== 1. NETLIFY.TOML AVEC REDIRECTIONS =====
echo "1️⃣ Création netlify.toml avec redirections Next.js..."

cat > netlify.toml << 'NETLIFYEOF'
[build]
  publish = ".next"
  command = "npm run build"

# Redirections pour Next.js App Router
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
  conditions = {Role = ["admin"]}

[[redirects]]
  from = "/*"
  to = "/.netlify/functions/___netlify-handler"
  status = 200

# Alternative : redirection simple vers page principale
[[redirects]]
  from = "/*"
  to = "/404.html"
  status = 404

# Headers pour Next.js
[[headers]]
  for = "/_next/static/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000, immutable"

[[headers]]
  for = "/*.js"
  [headers.values]
    Cache-Control = "public, max-age=31536000"
NETLIFYEOF

echo "✅ netlify.toml créé"

# ===== 2. ALTERNATIVE: EXPORT STATIQUE =====
echo "2️⃣ Alternative : Configuration export statique..."

cat > next.config.static.js << 'NEXTEOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  distDir: 'out'
}

module.exports = nextConfig
NEXTEOF

echo "✅ Configuration export statique préparée"

# ===== 3. PAGE 404 PERSONNALISÉE =====
echo "3️⃣ Création page 404 personnalisée..."

cat > app/not-found.tsx << 'NOTFOUNDEOF'
export default function NotFound() {
  return (
    <html>
      <body>
        <div style={{ padding: '2rem', textAlign: 'center', fontFamily: 'Arial, sans-serif' }}>
          <h1>Math4Child 🧮</h1>
          <h2>Page d'accueil</h2>
          <p>Application éducative pour enfants</p>
          <div style={{ marginTop: '2rem' }}>
            <h3>Opérations disponibles :</h3>
            <ul style={{ listStyle: 'none', padding: 0 }}>
              <li>➕ Addition</li>
              <li>➖ Soustraction</li>
              <li>✖️ Multiplication</li>
              <li>➗ Division</li>
            </ul>
          </div>
          <div style={{ marginTop: '2rem', fontSize: '0.9em', color: '#666' }}>
            <p>Math4Child - Application déployée sur Netlify</p>
          </div>
        </div>
      </body>
    </html>
  )
}
NOTFOUNDEOF

echo "✅ Page 404/not-found créée"

# ===== 4. TEST SOLUTION 1: AVEC NETLIFY.TOML =====
echo "4️⃣ Test Solution 1 : avec netlify.toml..."

git add netlify.toml app/not-found.tsx next.config.static.js
git commit -m "fix: add netlify.toml for proper Next.js routing on Netlify"

echo ""
echo "🚀 SOLUTION 1 APPLIQUÉE : NETLIFY.TOML"
echo "====================================="
echo "• netlify.toml avec redirections ajouté"
echo "• Page not-found améliorée"  
echo "• Push pour tester cette solution"
echo ""

# ===== 5. INSTRUCTIONS POUR SOLUTION 2 =====
cat << 'SOLUTION2EOF'

🔧 SOLUTION 2 (SI SOLUTION 1 NE MARCHE PAS) :
============================================

1. Remplacer next.config.js par export statique :
   cp next.config.static.js next.config.js

2. Changer Publish Directory dans Netlify :
   De : .next
   Vers : out

3. Rebuild

Commandes :
-----------
cp next.config.static.js next.config.js
git add next.config.js  
git commit -m "fix: use static export for Netlify"
git push origin main

Puis dans Netlify Dashboard :
Settings → Build & deploy → Publish directory → "out"

SOLUTION2EOF

echo ""
echo "🎯 PLAN D'ACTION :"
echo "=================="
echo ""
echo "1. 🚀 PUSH SOLUTION 1 (netlify.toml) :"
echo "   git push origin main"
echo ""
echo "2. ⏰ ATTENDRE 3 MINUTES (rebuild automatique)"
echo ""
echo "3. 🔍 TESTER https://math4child.com"
echo ""
echo "4. 🔧 SI ÇA NE MARCHE PAS → APPLIQUER SOLUTION 2"
echo ""
echo "✅ Le build Netlify fonctionne parfaitement,"
echo "   il ne reste qu'à corriger le routing !"