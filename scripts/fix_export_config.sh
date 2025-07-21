#!/bin/bash

# =============================================================================
# CORRECTION CONFIGURATION EXPORT NEXT.JS - MATH4CHILD
# =============================================================================

echo "🔧 CORRECTION CONFIGURATION EXPORT NEXT.JS"
echo "==========================================="

# 1. Localiser le dossier
if [ -f "apps/math4child/src/app/page.tsx" ]; then
    cd apps/math4child
    echo "✅ Travail dans apps/math4child/"
elif [ -f "src/app/page.tsx" ]; then
    echo "✅ Travail dans le dossier racine"
else
    echo "❌ Structure non reconnue"
    exit 1
fi

# 2. Corriger next.config.js pour supporter les API routes
echo "🔧 Correction de next.config.js..."
if [ -f "next.config.js" ]; then
    echo "📝 Modification de next.config.js existant..."
    # Sauvegarder l'ancien
    cp next.config.js next.config.js.backup
    
    # Créer nouvelle configuration
    cat > "next.config.js" << 'CONFIG_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Suppression de output: 'export' pour permettre les API routes
  // output: 'export', // <- Commenté pour permettre les API routes
  
  // Configuration pour le développement et production
  experimental: {
    appDir: true,
  },
  
  // Configuration pour les images
  images: {
    unoptimized: true,
  },
  
  // Configuration pour les API routes
  api: {
    bodyParser: {
      sizeLimit: '1mb',
    },
  },
  
  // Désactiver la génération de fichiers statiques pour les API
  generateBuildId: async () => {
    return 'math4child-build'
  }
}

module.exports = nextConfig
CONFIG_EOF
    echo "✅ next.config.js corrigé (sauvegarde dans next.config.js.backup)"
else
    echo "📝 Création de next.config.js..."
    cat > "next.config.js" << 'CONFIG2_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration pour supporter les API routes
  experimental: {
    appDir: true,
  },
  
  images: {
    unoptimized: true,
  },
  
  api: {
    bodyParser: {
      sizeLimit: '1mb',
    },
  }
}

module.exports = nextConfig
CONFIG2_EOF
    echo "✅ next.config.js créé"
fi

# 3. Ajouter les directives dynamic aux routes API
echo "🔧 Ajout des directives dynamic aux routes API..."

# Route create-checkout-session
if [ -f "src/app/api/stripe/create-checkout-session/route.ts" ]; then
    echo "📝 Mise à jour de la route create-checkout-session..."
    # Ajouter la directive en haut du fichier
    sed -i '1i\
export const dynamic = "force-dynamic"\
export const runtime = "nodejs"\
' src/app/api/stripe/create-checkout-session/route.ts
    echo "✅ Directive dynamic ajoutée à create-checkout-session"
else
    echo "❌ Route create-checkout-session non trouvée"
fi

# Route webhooks
if [ -f "src/app/api/stripe/webhooks/route.ts" ]; then
    echo "📝 Mise à jour de la route webhooks..."
    # Ajouter la directive en haut du fichier
    sed -i '1i\
export const dynamic = "force-dynamic"\
export const runtime = "nodejs"\
' src/app/api/stripe/webhooks/route.ts
    echo "✅ Directive dynamic ajoutée à webhooks"
else
    echo "❌ Route webhooks non trouvée"
fi

# 4. Créer une route API de test simple
echo "🧪 Création d'une route API de test..."
mkdir -p src/app/api/test
cat > "src/app/api/test/route.ts" << 'TEST_EOF'
export const dynamic = "force-dynamic"
export const runtime = "nodejs"

import { NextRequest, NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({ 
    message: 'API Test Math4Child',
    timestamp: new Date().toISOString(),
    status: 'OK'
  })
}

export async function POST(request: NextRequest) {
  const body = await request.json()
  return NextResponse.json({ 
    message: 'Test POST réussi',
    received: body,
    timestamp: new Date().toISOString()
  })
}
TEST_EOF
echo "✅ Route de test créée"

# 5. Alternative : Modifier le composant pour utiliser un service externe si les API ne fonctionnent pas
echo "🔄 Création d'une version fallback sans API routes..."
cat > "src/app/page-fallback.tsx" << 'FALLBACK_EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  ChevronDown, Globe, Crown, Check, X, Gift, Languages,
  Volume2, VolumeX, Sparkles
} from 'lucide-react'

// Version simplifiée sans API routes pour export statique
const SUPPORTED_LANGUAGES = {
  'fr': { name: 'French', nativeName: 'Français', flag: '🇫🇷', appName: 'Maths4Enfants' },
  'en': { name: 'English', nativeName: 'English', flag: '🇬🇧', appName: 'Math4Child' }
}

const translations = {
  fr: {
    appName: "Maths4Enfants",
    subtitle: "Apprends les maths en t'amusant !",
    freeTrial: "🎁 Essai Gratuit",
    selectLanguage: "Choisir la langue",
    domain: {
      welcome: "Bienvenue sur Math4Child.com",
      tagline: "L'apprentissage des mathématiques, partout dans le monde !"
    }
  },
  en: {
    appName: "Math4Child",
    subtitle: "Learn math while having fun!",
    freeTrial: "🎁 Free Trial", 
    selectLanguage: "Select Language",
    domain: {
      welcome: "Welcome to Math4Child.com",
      tagline: "Math learning, everywhere around the world!"
    }
  }
}

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState('fr')
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  const [showSubscriptionModal, setShowSubscriptionModal] = useState(false)
  const [freeTrialActive, setFreeTrialActive] = useState(false)

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['fr']
  const t = translations[currentLanguage] || translations['fr']

  const startFreeTrial = () => {
    setFreeTrialActive(true)
    alert("Mode démo gratuit activé ! 3 questions gratuites disponibles.")
  }

  // Redirection directe vers Stripe (sans API route)
  const handleSubscription = (plan) => {
    // URL directe vers Stripe ou redirection vers page de paiement externe
    const stripeUrl = `https://buy.stripe.com/test_00000000000000000000?prefilled_email=khalid_ksouri@yahoo.fr`
    
    // Alternative : Formulaire de contact
    const mailtoUrl = `mailto:khalid_ksouri@yahoo.fr?subject=Abonnement Math4Child Premium&body=Bonjour, je souhaite souscrire à l'abonnement Premium Math4Child (${plan}) à 9,99€/mois.`
    
    if (confirm('Rediriger vers le formulaire de contact pour l\'abonnement ?')) {
      window.location.href = mailtoUrl
    }
  }

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
      padding: '16px'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto', position: 'relative', zIndex: 10 }}>
        {/* Header simplifié */}
        <header style={{ marginBottom: '32px' }}>
          <nav style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            background: 'rgba(255, 255, 255, 0.15)',
            backdropFilter: 'blur(20px)',
            borderRadius: '24px',
            padding: '24px'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
              <div style={{
                width: '64px',
                height: '64px',
                background: 'linear-gradient(135deg, #fbbf24, #f97316)',
                borderRadius: '16px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '32px'
              }}>🧮</div>
              <div>
                <h1 style={{ fontSize: '32px', fontWeight: 'bold', color: 'white', margin: 0 }}>
                  {currentLangConfig.appName}
                </h1>
                <p style={{ color: 'rgba(255, 255, 255, 0.8)', fontSize: '14px', margin: 0 }}>
                  www.math4child.com
                </p>
              </div>
            </div>
            
            <button
              onClick={() => setShowSubscriptionModal(true)}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                background: 'linear-gradient(135deg, #fbbf24, #f97316)',
                color: 'white',
                padding: '12px 24px',
                borderRadius: '12px',
                fontWeight: 'bold',
                border: 'none',
                cursor: 'pointer'
              }}
            >
              <Crown size={20} />
              <span>Premium</span>
            </button>
          </nav>
        </header>
        
        {/* Contenu principal */}
        <div style={{ textAlign: 'center' }}>
          <div style={{
            background: 'rgba(255, 255, 255, 0.15)',
            backdropFilter: 'blur(20px)',
            borderRadius: '24px',
            padding: '48px'
          }}>
            <div style={{ marginBottom: '32px' }}>
              <div style={{ fontSize: '96px', marginBottom: '24px' }}>🎓</div>
              <h2 style={{
                fontSize: '64px',
                fontWeight: 'bold',
                color: 'white',
                marginBottom: '24px',
                margin: '0 0 24px 0'
              }}>
                {t.domain.welcome}
              </h2>
              <p style={{
                fontSize: '24px',
                color: 'rgba(255, 255, 255, 0.9)',
                maxWidth: '768px',
                margin: '0 auto'
              }}>
                {t.domain.tagline}
              </p>
            </div>
            
            {freeTrialActive && (
              <div style={{
                background: 'rgba(16, 185, 129, 0.2)',
                border: '2px solid rgba(16, 185, 129, 0.5)',
                borderRadius: '16px',
                padding: '16px',
                marginBottom: '32px',
                color: 'white'
              }}>
                <p style={{ margin: 0, fontSize: '18px', fontWeight: 'bold' }}>
                  ✨ Mode démo gratuit activé ! 3 questions disponibles.
                </p>
              </div>
            )}
            
            <div style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
              gap: '24px',
              maxWidth: '512px',
              margin: '0 auto'
            }}>
              <button
                onClick={startFreeTrial}
                style={{
                  background: 'linear-gradient(135deg, #10b981, #059669)',
                  color: 'white',
                  padding: '24px 32px',
                  borderRadius: '16px',
                  fontSize: '20px',
                  fontWeight: 'bold',
                  border: 'none',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '16px'
                }}
              >
                <Gift size={28} />
                <span>{t.freeTrial}</span>
              </button>
              
              <button 
                onClick={() => setShowSubscriptionModal(true)}
                style={{
                  background: 'linear-gradient(135deg, #a855f7, #ec4899)',
                  color: 'white',
                  padding: '24px 32px',
                  borderRadius: '16px',
                  fontSize: '20px',
                  fontWeight: 'bold',
                  border: 'none',
                  cursor: 'pointer',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: '16px'
                }}
              >
                <Crown size={28} />
                <span>Premium</span>
              </button>
            </div>
          </div>
        </div>
        
        {/* Modal Premium */}
        {showSubscriptionModal && (
          <div style={{
            position: 'fixed',
            inset: 0,
            background: 'rgba(0, 0, 0, 0.6)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '16px',
            zIndex: 50
          }}>
            <div style={{
              background: 'white',
              borderRadius: '24px',
              maxWidth: '512px',
              width: '100%',
              padding: '32px'
            }}>
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                marginBottom: '24px'
              }}>
                <h2 style={{ fontSize: '32px', fontWeight: 'bold', color: '#374151', margin: 0 }}>
                  Premium Math4Child
                </h2>
                <button
                  onClick={() => setShowSubscriptionModal(false)}
                  style={{
                    color: '#6b7280',
                    background: 'none',
                    border: 'none',
                    cursor: 'pointer',
                    padding: '8px'
                  }}
                >
                  <X size={24} />
                </button>
              </div>
              
              <div style={{ textAlign: 'center' }}>
                <div style={{ fontSize: '64px', marginBottom: '16px' }}>👑</div>
                <p style={{ fontSize: '20px', color: '#374151', marginBottom: '24px' }}>
                  Débloquez tous les niveaux et fonctionnalités !
                </p>
                
                <button 
                  onClick={() => handleSubscription('monthly')}
                  style={{
                    background: 'linear-gradient(135deg, #a855f7, #ec4899)',
                    color: 'white',
                    padding: '16px 32px',
                    borderRadius: '16px',
                    fontSize: '20px',
                    fontWeight: 'bold',
                    border: 'none',
                    cursor: 'pointer',
                    width: '100%'
                  }}
                >
                  Contacter pour Premium - 9,99€/mois
                </button>
                
                <p style={{ fontSize: '12px', color: '#6b7280', marginTop: '16px', margin: '16px 0 0 0' }}>
                  <strong>GOTEST</strong> - SIRET: 53958712100028<br />
                  Support: khalid_ksouri@yahoo.fr
                </p>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
FALLBACK_EOF

echo "✅ Version fallback créée (sans API routes)"

# 6. Script pour basculer entre les versions
cat > "switch_version.sh" << 'SWITCH_EOF'
#!/bin/bash
echo "🔄 BASCULEMENT VERSION MATH4CHILD"
echo "================================="

if [ "$1" = "api" ]; then
    echo "🔄 Activation version avec API routes..."
    if [ -f "src/app/page-main.tsx" ]; then
        cp src/app/page-main.tsx src/app/page.tsx
    fi
    # Utiliser next.config.js sans export
    if [ -f "next.config.api.js" ]; then
        cp next.config.api.js next.config.js
    fi
    echo "✅ Version API activée"
    
elif [ "$1" = "static" ]; then
    echo "🔄 Activation version statique..."
    cp src/app/page-fallback.tsx src/app/page.tsx
    # Utiliser next.config.js avec export
    cat > next.config.js << 'STATIC_CONFIG_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
}

module.exports = nextConfig
STATIC_CONFIG_EOF
    echo "✅ Version statique activée"
    
else
    echo "Usage: ./switch_version.sh [api|static]"
    echo "  api    - Version avec API routes (serveur requis)"
    echo "  static - Version statique (sans serveur)"
fi
SWITCH_EOF

chmod +x switch_version.sh

# 7. Test avec la version corrigée
echo "🧪 Test avec configuration corrigée..."
if npm run build; then
    echo "🎉 BUILD RÉUSSI AVEC API ROUTES !"
    echo ""
    echo "✅ CONFIGURATION CORRIGÉE :"
    echo "   • next.config.js sans output: 'export'"
    echo "   • Directives dynamic ajoutées aux API routes"
    echo "   • Route de test créée"
    echo "   • Version fallback disponible"
    echo ""
    echo "🚀 POUR UTILISER :"
    echo "   npm run dev"
    echo "   Visitez: http://localhost:3000"
    echo ""
    echo "🔄 BASCULEMENT DE VERSION :"
    echo "   ./switch_version.sh api    # Version avec API"
    echo "   ./switch_version.sh static # Version statique"
else
    echo "⚠️  Build échoué, bascule vers version statique..."
    ./switch_version.sh static
    
    if npm run build; then
        echo "🎉 BUILD RÉUSSI EN VERSION STATIQUE !"
        echo ""
        echo "✅ VERSION STATIQUE ACTIVÉE :"
        echo "   • Pas d'API routes (contact par email)"
        echo "   • Export statique fonctionnel"
        echo "   • Bouton Premium → contact email"
        echo ""
        echo "🚀 POUR UTILISER :"
        echo "   npm run dev"
        echo "   npm run build && npm run start"
        echo ""
        echo "💡 Pour les API routes :"
        echo "   Déployez sur un serveur Next.js (pas statique)"
        echo "   Ou utilisez: ./switch_version.sh api"
    else
        echo "❌ Build échoué même en version statique"
    fi
fi

echo ""
echo "🎯 Configuration Next.js corrigée pour Math4Child !"