#!/bin/bash
set -e

echo "🎨 CRÉATION BELLE INTERFACE MATH4CHILD"
echo "======================================"
echo ""
echo "🎉 SUCCÈS : Netlify fonctionne maintenant !"
echo "🎯 OBJECTIF : Remplacer par une belle interface"
echo ""

cd apps/math4child

# ===== 1. BELLE PAGE MATH4CHILD =====
echo "1️⃣ Création de la belle interface Math4Child..."

cat > app/page.tsx << 'PAGEEOF'
'use client'

import { useState, useEffect } from 'react'
import { Calculator, Globe, Star, Play, Heart, Trophy } from 'lucide-react'

export default function Home() {
  const [currentLanguage, setCurrentLanguage] = useState<'fr' | 'en'>('fr')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const translations = {
    fr: {
      title: 'Math4Child',
      subtitle: 'Apprendre les mathématiques en s\'amusant !',
      startLearning: 'Commencer à apprendre',
      operations: ['Addition', 'Soustraction', 'Multiplication', 'Division'],
      levels: ['Débutant', 'Intermédiaire', 'Expert'],
      ageRange: 'Pour les enfants de 4 à 12 ans',
      features: {
        interactive: 'Exercices interactifs',
        progress: 'Suivi des progrès', 
        rewards: 'Système de récompenses',
        multilingual: 'Interface multilingue'
      }
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Learn mathematics while having fun!',
      startLearning: 'Start Learning',
      operations: ['Addition', 'Subtraction', 'Multiplication', 'Division'],
      levels: ['Beginner', 'Intermediate', 'Expert'],
      ageRange: 'For children aged 4 to 12',
      features: {
        interactive: 'Interactive exercises',
        progress: 'Progress tracking',
        rewards: 'Reward system', 
        multilingual: 'Multilingual interface'
      }
    }
  }

  const t = translations[currentLanguage]

  if (!mounted) return null

  return (
    <div className="min-h-screen" style={{
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
      fontFamily: 'system-ui, -apple-system, sans-serif'
    }}>
      {/* Header */}
      <header style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '1rem 2rem',
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(10px)'
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Calculator color="white" size={32} />
          <h1 style={{ color: 'white', fontSize: '1.5rem', margin: 0 }}>
            {t.title}
          </h1>
        </div>
        
        <button
          onClick={() => setCurrentLanguage(currentLanguage === 'fr' ? 'en' : 'fr')}
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '0.5rem',
            padding: '0.5rem 1rem',
            background: 'rgba(255, 255, 255, 0.2)',
            border: 'none',
            borderRadius: '25px',
            color: 'white',
            cursor: 'pointer',
            fontSize: '0.9rem'
          }}
        >
          <Globe size={16} />
          {currentLanguage === 'fr' ? '🇫🇷 FR' : '🇬🇧 EN'}
        </button>
      </header>

      {/* Hero Section */}
      <main style={{ padding: '2rem' }}>
        <div style={{
          maxWidth: '1200px',
          margin: '0 auto',
          textAlign: 'center'
        }}>
          <div style={{
            background: 'rgba(255, 255, 255, 0.95)',
            borderRadius: '20px',
            padding: '3rem',
            marginBottom: '2rem',
            boxShadow: '0 20px 60px rgba(0, 0, 0, 0.1)'
          }}>
            <h2 style={{
              fontSize: '3rem',
              background: 'linear-gradient(135deg, #667eea, #764ba2)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              margin: '0 0 1rem 0'
            }}>
              🧮 {t.title}
            </h2>
            
            <p style={{
              fontSize: '1.3rem',
              color: '#666',
              marginBottom: '1rem'
            }}>
              {t.subtitle}
            </p>
            
            <p style={{
              fontSize: '1rem',
              color: '#888',
              marginBottom: '2rem'
            }}>
              {t.ageRange}
            </p>

            <button style={{
              background: 'linear-gradient(135deg, #667eea, #764ba2)',
              color: 'white',
              border: 'none',
              padding: '1rem 2rem',
              fontSize: '1.1rem',
              borderRadius: '50px',
              cursor: 'pointer',
              display: 'inline-flex',
              alignItems: 'center',
              gap: '0.5rem',
              boxShadow: '0 10px 30px rgba(102, 126, 234, 0.4)',
              transition: 'transform 0.2s'
            }}
            onMouseOver={(e) => e.currentTarget.style.transform = 'scale(1.05)'}
            onMouseOut={(e) => e.currentTarget.style.transform = 'scale(1)'}
            >
              <Play size={20} />
              {t.startLearning}
            </button>
          </div>

          {/* Operations Grid */}
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
            gap: '1.5rem',
            marginBottom: '3rem'
          }}>
            {t.operations.map((operation, index) => (
              <div
                key={index}
                style={{
                  background: 'rgba(255, 255, 255, 0.9)',
                  borderRadius: '15px',
                  padding: '2rem',
                  textAlign: 'center',
                  boxShadow: '0 10px 30px rgba(0, 0, 0, 0.1)',
                  transition: 'transform 0.3s',
                  cursor: 'pointer'
                }}
                onMouseOver={(e) => e.currentTarget.style.transform = 'translateY(-5px)'}
                onMouseOut={(e) => e.currentTarget.style.transform = 'translateY(0)'}
              >
                <div style={{
                  width: '60px',
                  height: '60px',
                  background: 'linear-gradient(135deg, #667eea, #764ba2)',
                  borderRadius: '50%',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  margin: '0 auto 1rem auto'
                }}>
                  <Star color="white" size={24} />
                </div>
                <h3 style={{
                  fontSize: '1.2rem',
                  color: '#333',
                  margin: '0 0 0.5rem 0'
                }}>
                  {operation}
                </h3>
                <p style={{
                  color: '#666',
                  fontSize: '0.9rem',
                  margin: 0
                }}>
                  Exercices interactifs et amusants
                </p>
              </div>
            ))}
          </div>

          {/* Features */}
          <div style={{
            background: 'rgba(255, 255, 255, 0.9)',
            borderRadius: '20px',
            padding: '2rem',
            marginBottom: '2rem'
          }}>
            <h3 style={{
              fontSize: '1.5rem',
              color: '#333',
              marginBottom: '1.5rem'
            }}>
              ✨ Fonctionnalités
            </h3>
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
              gap: '1rem'
            }}>
              {Object.values(t.features).map((feature, index) => (
                <div key={index} style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '0.5rem',
                  padding: '0.5rem'
                }}>
                  <Heart size={16} color="#667eea" />
                  <span style={{ color: '#333' }}>{feature}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Levels */}
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))',
            gap: '1rem'
          }}>
            {t.levels.map((level, index) => (
              <div
                key={index}
                style={{
                  background: 'rgba(255, 255, 255, 0.9)',
                  borderRadius: '15px',
                  padding: '1.5rem',
                  textAlign: 'center'
                }}
              >
                <Trophy 
                  size={32} 
                  color={index === 0 ? '#cd7f32' : index === 1 ? '#c0c0c0' : '#ffd700'}
                  style={{ marginBottom: '0.5rem' }}
                />
                <h4 style={{ color: '#333', margin: '0.5rem 0' }}>
                  {level}
                </h4>
              </div>
            ))}
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer style={{
        textAlign: 'center',
        padding: '2rem',
        background: 'rgba(0, 0, 0, 0.1)',
        color: 'white',
        marginTop: '3rem'
      }}>
        <p style={{ margin: 0, opacity: 0.8 }}>
          Math4Child © 2025 - Apprendre en s'amusant
        </p>
      </footer>
    </div>
  )
}
PAGEEOF

echo "✅ Belle interface Math4Child créée"

# ===== 2. MISE À JOUR LAYOUT =====
echo "2️⃣ Amélioration du layout..."

cat > app/layout.tsx << 'LAYOUTEOF'
export const metadata = {
  title: 'Math4Child - Apprendre les Mathématiques en S\'amusant',
  description: 'Application éducative interactive pour apprendre les mathématiques. Pour enfants de 4 à 12 ans.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, calcul',
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🧮</text></svg>" />
      </head>
      <body style={{ 
        margin: 0, 
        padding: 0, 
        fontFamily: 'system-ui, -apple-system, BlinkMacSystemFont, sans-serif'
      }}>
        {children}
      </body>
    </html>
  )
}
LAYOUTEOF

echo "✅ Layout amélioré"

# ===== 3. GLOBALS CSS (INLINE DANS LAYOUT) =====
echo "3️⃣ Styles CSS optimisés..."

cat > app/globals.css << 'CSSEOF'
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  padding: 0;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
  line-height: 1.6;
}

button:hover {
  transition: all 0.2s ease;
}

@media (max-width: 768px) {
  .grid {
    grid-template-columns: 1fr !important;
  }
  
  h2 {
    font-size: 2rem !important;
  }
  
  .hero {
    padding: 2rem !important;
  }
}
CSSEOF

# Import CSS dans layout
cat > app/layout.tsx << 'LAYOUTEOF'
import './globals.css'

export const metadata = {
  title: 'Math4Child - Apprendre les Mathématiques en S\'amusant',
  description: 'Application éducative interactive pour apprendre les mathématiques. Pour enfants de 4 à 12 ans.',
  keywords: 'mathématiques, enfants, éducation, apprentissage, calcul',
  authors: [{ name: 'Math4Child Team' }],
  viewport: 'width=device-width, initial-scale=1',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🧮</text></svg>" />
      </head>
      <body>
        {children}
      </body>
    </html>
  )
}
LAYOUTEOF

echo "✅ CSS intégré"

# ===== 4. TEST BUILD =====
echo "4️⃣ Test build avec belle interface..."

rm -rf .next out node_modules package-lock.json

npm install

if npm run build; then
    echo "✅ Build belle interface réussi"
    
    if [ -d "out" ] && [ -f "out/index.html" ]; then
        echo "✅ Export statique généré"
        echo "📊 Taille de l'interface :"
        ls -lh out/index.html
    else
        echo "❌ Problème génération"
        exit 1
    fi
else
    echo "❌ Build échoué"
    exit 1
fi

cd ../../

# ===== 5. COMMIT BELLE INTERFACE =====
echo "5️⃣ Commit belle interface..."

git add .
git commit -m "🎨 Beautiful Math4Child interface with multilingual support

✨ Features:
- Gorgeous gradient design
- Interactive buttons and cards
- Multilingual FR/EN support  
- Responsive mobile design
- Smooth animations
- Modern UI/UX
- Educational content for kids 4-12

🚀 Ready for production on math4child.com"

echo ""
echo "🎨 BELLE INTERFACE CRÉÉE !"
echo "========================="
echo ""
echo "✨ Fonctionnalités :"
echo "• Interface moderne avec gradients"
echo "• Bouton changement de langue FR/EN"
echo "• Animations au survol"
echo "• Design responsive mobile"
echo "• Icônes interactives"
echo "• Contenu adapté aux enfants 4-12 ans"
echo ""
echo "🚀 PUSH ET VOIR LE RÉSULTAT :"
echo "============================"
echo ""
echo "git push origin main"
echo ""
echo "Puis dans 3-5 minutes :"
echo "👉 https://math4child.com"
echo ""
echo "🎉 Vous devriez voir une magnifique interface !"