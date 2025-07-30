#!/bin/bash

#===============================================================================
# MATH4CHILD - RÉCUPÉRATION D'URGENCE
# Répare et relance l'application Math4Child
#===============================================================================

set -euo pipefail

# Couleurs
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_message() {
    local level=$1
    shift
    local message="$*"
    echo -e "${GREEN}[$(date '+%H:%M:%S')] ✅ $level: ${message}${NC}"
}

show_banner() {
    echo -e "${BLUE}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🚨 MATH4CHILD - RÉCUPÉRATION D'URGENCE                   ║
║                       Réparation complète de l'application                  ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Nettoyer tous les processus
cleanup_all() {
    log_message "INFO" "🧹 Nettoyage complet..."
    
    # Tuer tous les processus Node.js
    pkill -f "node" 2>/dev/null || true
    pkill -f "next" 2>/dev/null || true
    
    # Libérer tous les ports
    for port in {3000..3010}; do
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            local pid=$(lsof -Pi :$port -sTCP:LISTEN -t)
            kill -9 $pid 2>/dev/null || true
        fi
    done
    
    sleep 3
    log_message "SUCCESS" "Nettoyage terminé"
}

# Reconstruire le projet depuis zéro
rebuild_project() {
    log_message "INFO" "🏗️ Reconstruction complète du projet..."
    
    # Aller au répertoire de base
    cd /Users/khalidksouri/Desktop/multi-apps-platform
    
    # Nettoyer et recréer la structure
    rm -rf apps/math4child 2>/dev/null || true
    mkdir -p apps/math4child/src/app/subscription
    mkdir -p apps/math4child/src/components/layout
    
    cd apps/math4child
    
    # Package.json complet
    cat > package.json << 'EOF'
{
  "name": "math4child-app",
  "version": "4.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev -p 3000",
    "build": "next build",
    "start": "next start -p 3000",
    "lint": "next lint"
  },
  "dependencies": {
    "next": "14.0.4",
    "react": "18.2.0",
    "react-dom": "18.2.0",
    "typescript": "5.3.3",
    "@types/node": "20.10.6",
    "@types/react": "18.2.45",
    "@types/react-dom": "18.2.18",
    "tailwindcss": "3.4.0",
    "autoprefixer": "10.4.16",
    "postcss": "8.4.32",
    "clsx": "2.0.0"
  },
  "devDependencies": {
    "eslint": "8.56.0",
    "eslint-config-next": "14.0.4"
  }
}
EOF
    
    # Configuration Next.js
    cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
}

module.exports = nextConfig
EOF
    
    # Configuration TypeScript
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "ES6"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
EOF
    
    # Layout principal
    cat > src/app/layout.tsx << 'EOF'
import { ReactNode } from 'react'

export const metadata = {
  title: 'Math4Child - Application Éducative',
  description: 'Application révolutionnaire pour l\'apprentissage des mathématiques',
}

export default function RootLayout({
  children,
}: {
  children: ReactNode
}) {
  return (
    <html lang="fr">
      <body style={{ margin: 0, fontFamily: 'system-ui, sans-serif' }}>
        <header style={{
          background: 'white',
          boxShadow: '0 2px 10px rgba(0,0,0,0.1)',
          padding: '1rem 2rem',
          borderBottom: '4px solid #3b82f6'
        }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
              <div style={{
                width: '40px',
                height: '40px',
                background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                borderRadius: '8px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                color: 'white',
                fontWeight: 'bold'
              }}>
                M4C
              </div>
              <div>
                <h1 style={{ margin: 0, fontSize: '1.5rem', color: '#1f2937' }}>Math4Child</h1>
                <p style={{ margin: 0, fontSize: '0.75rem', color: '#6b7280' }}>Apprendre en s'amusant</p>
              </div>
            </div>
            
            <nav style={{ display: 'flex', gap: '2rem' }}>
              <a href="/exercises" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                🧮 Exercices
              </a>
              <a href="/subscription" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                💎 Abonnement
              </a>
              <a href="/dashboard" style={{ color: '#374151', textDecoration: 'none', fontWeight: '500' }}>
                📊 Tableau de bord
              </a>
            </nav>
            
            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
              <span style={{
                background: '#f3f4f6',
                color: '#374151',
                padding: '0.25rem 0.75rem',
                borderRadius: '1rem',
                fontSize: '0.75rem',
                fontWeight: '500'
              }}>
                Gratuit
              </span>
              <select style={{ padding: '0.25rem 0.5rem', borderRadius: '0.375rem', border: '1px solid #d1d5db' }}>
                <option value="fr">🇫🇷 FR</option>
                <option value="en">🇺🇸 EN</option>
                <option value="es">🇪🇸 ES</option>
                <option value="ar">🇲🇦 AR</option>
              </select>
            </div>
          </div>
        </header>
        
        <main style={{ minHeight: 'calc(100vh - 140px)' }}>
          {children}
        </main>
        
        <footer style={{
          background: '#1f2937',
          color: 'white',
          padding: '2rem',
          textAlign: 'center'
        }}>
          <p>© 2024 Math4Child. Application éducative révolutionnaire.</p>
        </footer>
      </body>
    </html>
  )
}
EOF
    
    # Page d'accueil
    cat > src/app/page.tsx << 'EOF'
'use client'

import { useState } from 'react'

export default function HomePage() {
  const [selectedAge, setSelectedAge] = useState('')

  return (
    <div style={{ background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)', minHeight: '100vh' }}>
      {/* Hero Section */}
      <section style={{ padding: '5rem 2rem', textAlign: 'center' }}>
        <div style={{ maxWidth: '1024px', margin: '0 auto' }}>
          <h1 style={{
            fontSize: '3.5rem',
            fontWeight: 'bold',
            color: '#1f2937',
            marginBottom: '1.5rem',
            background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent'
          }}>
            🧮 Math4Child
          </h1>
          <p style={{
            fontSize: '1.25rem',
            color: '#6b7280',
            marginBottom: '2rem',
            maxWidth: '600px',
            margin: '0 auto 2rem auto'
          }}>
            L'application éducative révolutionnaire qui rend l'apprentissage 
            des mathématiques amusant et accessible pour tous les enfants.
          </p>
          
          <div style={{ marginBottom: '2rem' }}>
            <label style={{ display: 'block', fontSize: '1.125rem', fontWeight: '500', color: '#374151', marginBottom: '1rem' }}>
              Sélectionnez l'âge de votre enfant :
            </label>
            <select
              value={selectedAge}
              onChange={(e) => setSelectedAge(e.target.value)}
              style={{
                padding: '0.75rem 1.5rem',
                fontSize: '1.125rem',
                border: '2px solid #d1d5db',
                borderRadius: '0.5rem',
                background: 'white'
              }}
            >
              <option value="">Choisir un âge...</option>
              <option value="4-6">4-6 ans (Maternelle)</option>
              <option value="7-10">7-10 ans (Primaire)</option>
              <option value="11-14">11-14 ans (Collège)</option>
              <option value="15-18">15-18 ans (Lycée)</option>
            </select>
          </div>

          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <a
              href="/exercises"
              style={{
                background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                color: 'white',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none',
                display: 'inline-block',
                transition: 'transform 0.2s'
              }}
              onMouseOver={(e) => e.target.style.transform = 'scale(1.05)'}
              onMouseOut={(e) => e.target.style.transform = 'scale(1)'}
            >
              🚀 Commencer gratuitement
            </a>
            <a
              href="/subscription"
              style={{
                background: 'white',
                color: '#374151',
                border: '2px solid #d1d5db',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none',
                display: 'inline-block',
                transition: 'all 0.2s'
              }}
              onMouseOver={(e) => { e.target.style.borderColor = '#3b82f6'; e.target.style.color = '#3b82f6' }}
              onMouseOut={(e) => { e.target.style.borderColor = '#d1d5db'; e.target.style.color = '#374151' }}
            >
              💎 Voir les abonnements
            </a>
          </div>
        </div>
      </section>

      {/* Fonctionnalités */}
      <section style={{ padding: '4rem 2rem', background: 'white' }}>
        <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
          <h2 style={{ fontSize: '2rem', fontWeight: 'bold', textAlign: 'center', color: '#1f2937', marginBottom: '3rem' }}>
            ✨ Fonctionnalités principales
          </h2>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', gap: '2rem' }}>
            {[
              { icon: '🧮', title: 'Exercices Adaptés', desc: 'Plus de 10 000 exercices personnalisés' },
              { icon: '🎯', title: 'Suivi Personnalisé', desc: 'IA qui s\'adapte au rythme de l\'enfant' },
              { icon: '🏆', title: 'Gamification', desc: 'Points, badges et défis motivants' },
              { icon: '🌍', title: 'Multilingue', desc: 'Interface en 14 langues' }
            ].map((feature, index) => (
              <div key={index} style={{
                textAlign: 'center',
                padding: '2rem',
                background: 'white',
                borderRadius: '1rem',
                boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
                border: '1px solid #f3f4f6'
              }}>
                <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>{feature.icon}</div>
                <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '0.5rem' }}>
                  {feature.title}
                </h3>
                <p style={{ color: '#6b7280' }}>{feature.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Final */}
      <section style={{
        padding: '4rem 2rem',
        background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
        color: 'white',
        textAlign: 'center'
      }}>
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <h2 style={{ fontSize: '2.5rem', fontWeight: 'bold', marginBottom: '1rem' }}>
            🎯 Prêt à commencer ?
          </h2>
          <p style={{ fontSize: '1.25rem', marginBottom: '2rem', opacity: 0.9 }}>
            Rejoignez plus de 50 000 familles qui font confiance à Math4Child
          </p>
          <a
            href="/exercises"
            style={{
              background: 'white',
              color: '#3b82f6',
              padding: '1rem 2rem',
              borderRadius: '0.5rem',
              fontSize: '1.125rem',
              fontWeight: '600',
              textDecoration: 'none',
              display: 'inline-block',
              boxShadow: '0 4px 20px rgba(0,0,0,0.2)'
            }}
          >
            🚀 Commencer maintenant
          </a>
        </div>
      </section>
    </div>
  )
}
EOF
    
    log_message "SUCCESS" "Projet reconstruit"
}

# Installer et démarrer
install_and_start() {
    log_message "INFO" "📦 Installation des dépendances..."
    
    # Installation propre
    npm install --legacy-peer-deps
    
    log_message "INFO" "🚀 Démarrage de l'application..."
    
    # Ouvrir le navigateur
    sleep 3 && open http://localhost:3000 &
    
    log_message "SUCCESS" "🌐 Application accessible sur: http://localhost:3000"
    
    # Démarrer
    npm run dev
}

# Fonction principale
main() {
    show_banner
    
    cleanup_all
    rebuild_project
    install_and_start
}

main "$@"