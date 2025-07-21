#!/bin/bash

# =============================================================================
# CORRECTION DU BOUTON PREMIUM - MATH4CHILD
# =============================================================================

echo "🔧 CORRECTION DU BOUTON PREMIUM"
echo "==============================="

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

# 2. Correction du modal Premium avec email GOTEST et debug
echo "🔧 Correction du modal Premium..."
# Trouver et remplacer la section du modal dans page.tsx
if grep -q "contact@math4child.com" src/app/page.tsx; then
    echo "📧 Correction de l'email de support..."
    sed -i 's/contact@math4child.com/khalid_ksouri@yahoo.fr/g' src/app/page.tsx
    echo "✅ Email corrigé vers khalid_ksouri@yahoo.fr"
fi

# 3. Ajouter du debug à la fonction handleSubscription
echo "🐛 Ajout du debug à la fonction handleSubscription..."
cat > temp_debug_function.js << 'DEBUG_EOF'
  const handleSubscription = async (plan) => {
    console.log('🚀 DEBUT handleSubscription avec plan:', plan)
    
    try {
      console.log('📡 Envoi de la requête à /api/stripe/create-checkout-session')
      
      const requestBody = {
        plan: plan,
        customerEmail: 'khalid_ksouri@yahoo.fr'
      }
      
      console.log('📤 Corps de la requête:', requestBody)
      
      const response = await fetch('/api/stripe/create-checkout-session', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestBody),
      })
      
      console.log('📨 Statut de la réponse:', response.status)
      console.log('📨 Headers de la réponse:', response.headers)
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`)
      }
      
      const session = await response.json()
      console.log('📦 Réponse JSON reçue:', session)
      
      if (session.url) {
        console.log('✅ URL de redirection trouvée:', session.url)
        alert('Redirection vers Stripe...')
        window.location.href = session.url
      } else if (session.error) {
        console.error('❌ Erreur dans la réponse:', session.error)
        alert('Erreur Stripe: ' + session.error + '\nDétails: ' + (session.details || 'Aucun détail'))
      } else {
        console.error('❌ Réponse inattendue:', session)
        alert('Réponse inattendue du serveur: ' + JSON.stringify(session))
      }
    } catch (error) {
      console.error('💥 Erreur complète:', error)
      console.error('Stack trace:', error.stack)
      alert('Erreur lors de la création de la session de paiement:\n' + error.message + '\n\nVérifiez la console pour plus de détails.')
    }
  }
DEBUG_EOF

# Remplacer la fonction handleSubscription dans page.tsx
if grep -q "const handleSubscription" src/app/page.tsx; then
    echo "🔄 Remplacement de la fonction handleSubscription..."
    # Utilisation d'une approche plus simple avec sed
    python3 - << 'PYTHON_EOF'
import re

# Lire le fichier
with open('src/app/page.tsx', 'r') as f:
    content = f.read()

# Lire la nouvelle fonction
with open('temp_debug_function.js', 'r') as f:
    new_function = f.read()

# Remplacer l'ancienne fonction par la nouvelle
pattern = r'const handleSubscription = async \(plan\) => \{[^}]*\}(?:\s*\})*'
replacement = new_function.strip()

# Utiliser une regex plus spécifique pour trouver la fonction complète
pattern = r'const handleSubscription = async \(plan\) => \{(?:[^{}]|\{[^{}]*\})*\}'
content = re.sub(pattern, replacement, content, flags=re.DOTALL)

# Écrire le fichier modifié
with open('src/app/page.tsx', 'w') as f:
    f.write(content)
PYTHON_EOF
    
    rm temp_debug_function.js
    echo "✅ Fonction handleSubscription mise à jour avec debug"
else
    echo "❌ Fonction handleSubscription non trouvée"
fi

# 4. Tester que l'API route existe
echo "🧪 Test de l'API route Stripe..."
if [ -f "src/app/api/stripe/create-checkout-session/route.ts" ]; then
    echo "✅ Route API existe"
    # Tester si la route est bien formée
    if grep -q "export async function POST" src/app/api/stripe/create-checkout-session/route.ts; then
        echo "✅ Route POST trouvée"
    else
        echo "❌ Route POST manquante - recréation..."
        mkdir -p src/app/api/stripe/create-checkout-session
        cat > "src/app/api/stripe/create-checkout-session/route.ts" << 'ROUTE_EOF'
import { NextRequest, NextResponse } from 'next/server'

export async function POST(request: NextRequest) {
  try {
    const { plan, customerEmail } = await request.json()
    
    console.log('🔐 API appelée avec:', { plan, customerEmail })
    
    // Simulation de Stripe en mode développement
    if (!process.env.STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY === 'sk_test_placeholder') {
      console.log('🧪 MODE DÉVELOPPEMENT - Simulation Stripe')
      
      // Simuler une réponse Stripe
      const mockSession = {
        url: 'https://checkout.stripe.com/pay/mock-session-id',
        sessionId: 'cs_mock_' + Date.now()
      }
      
      console.log('✅ Session simulée créée:', mockSession)
      return NextResponse.json(mockSession)
    }
    
    // Code Stripe réel ici quand configuré
    return NextResponse.json({
      error: 'Configuration Stripe manquante',
      details: 'Remplacez les clés dans .env.local'
    }, { status: 500 })
    
  } catch (error) {
    console.error('❌ Erreur API:', error)
    return NextResponse.json({
      error: 'Erreur serveur',
      details: error.message
    }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({ 
    message: 'API Stripe Math4Child fonctionnelle',
    timestamp: new Date().toISOString(),
    status: 'OK',
    mode: process.env.NODE_ENV
  })
}
ROUTE_EOF
        echo "✅ Route API recréée avec mode simulation"
    fi
else
    echo "❌ Route API manquante - création..."
    mkdir -p src/app/api/stripe/create-checkout-session
    cat > "src/app/api/stripe/create-checkout-session/route.ts" << 'ROUTE2_EOF'
import { NextRequest, NextResponse } from 'next/server'

export async function POST(request: NextRequest) {
  try {
    const { plan, customerEmail } = await request.json()
    
    console.log('🔐 API appelée avec:', { plan, customerEmail })
    
    // Mode simulation pour développement
    console.log('🧪 MODE DÉVELOPPEMENT - Simulation Stripe')
    
    const mockSession = {
      url: 'https://checkout.stripe.com/pay/mock-session-id',
      sessionId: 'cs_mock_' + Date.now()
    }
    
    console.log('✅ Session simulée créée:', mockSession)
    return NextResponse.json(mockSession)
    
  } catch (error) {
    console.error('❌ Erreur API:', error)
    return NextResponse.json({
      error: 'Erreur serveur',
      details: error.message
    }, { status: 500 })
  }
}

export async function GET() {
  return NextResponse.json({ 
    message: 'API Stripe Math4Child active',
    status: 'OK'
  })
}
ROUTE2_EOF
    echo "✅ Route API créée"
fi

# 5. Test de build
echo "🧪 Test de l'application..."
if npm run build; then
    echo "🎉 BUILD RÉUSSI !"
    echo ""
    echo "✅ CORRECTIONS APPLIQUÉES :"
    echo "   • Email support corrigé → khalid_ksouri@yahoo.fr"
    echo "   • Debug ajouté au bouton Premium"
    echo "   • Route API vérifiée/créée"
    echo "   • Mode simulation pour développement"
    echo ""
    echo "🚀 POUR TESTER :"
    echo "   npm run dev"
    echo "   Visitez: http://localhost:3000"
    echo "   1. Cliquez sur Premium"
    echo "   2. Ouvrez la Console Développeur (F12)"
    echo "   3. Cliquez sur 'Commencer Premium'"
    echo "   4. Regardez les logs dans la console"
    echo ""
    echo "🔍 DIAGNOSTIC :"
    echo "   • Si vous voyez les logs → JavaScript fonctionne"
    echo "   • Si erreur 404 → problème de route API"
    echo "   • Si erreur 500 → problème côté serveur"
    echo "   • Si pas de logs → problème JavaScript"
    echo ""
    echo "💡 EN MODE DÉVELOPPEMENT :"
    echo "   • L'API simule Stripe (pas de vrai paiement)"
    echo "   • Pour la production, configurez les vraies clés Stripe"
else
    echo "❌ Build échoué - vérifiez les erreurs ci-dessus"
fi

echo ""
echo "🎯 Le bouton Premium devrait maintenant afficher des informations de debug détaillées !"