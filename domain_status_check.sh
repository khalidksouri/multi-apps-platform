#!/bin/bash
echo "🔍 Diagnostic Complet - math4child.com"
echo "===================================="

echo ""
echo "1️⃣ Test DNS - Où pointe math4child.com :"
nslookup math4child.com

echo ""
echo "2️⃣ Test DNS - Où pointe www.math4child.com :"
nslookup www.math4child.com

echo ""
echo "3️⃣ Test HTTPS - Statut certificat SSL :"
curl -I https://math4child.com 2>/dev/null | head -1 || echo "❌ HTTPS non accessible"

echo ""
echo "4️⃣ Test HTTP - Redirection :"
curl -I http://math4child.com 2>/dev/null | head -3 || echo "❌ HTTP non accessible"

echo ""
echo "5️⃣ Test site Netlify backup :"
curl -I https://prismatic-sherbet-986159.netlify.app 2>/dev/null | head -1 || echo "❌ Site Netlify non accessible"

echo ""
echo "📊 RÉSULTATS :"
echo "============="

# Test simple d'accessibilité
if curl -s https://math4child.com > /dev/null 2>&1; then
    echo "✅ math4child.com accessible"
else
    echo "❌ math4child.com NON accessible - DNS en propagation"
fi

if curl -s https://prismatic-sherbet-986159.netlify.app > /dev/null 2>&1; then
    echo "✅ Site Netlify backup accessible" 
else
    echo "❌ Site Netlify backup NON accessible - Problème build"
fi

echo ""
echo "🎯 ACTIONS RECOMMANDÉES :"
echo "======================="

if curl -s https://math4child.com > /dev/null 2>&1; then
    echo "🎉 DÉPLOIEMENT RÉUSSI ! math4child.com fonctionne"
    echo "📱 Testez l'interface : https://math4child.com"
else
    if curl -s https://prismatic-sherbet-986159.netlify.app > /dev/null 2>&1; then
        echo "⏳ DNS EN PROPAGATION (normal, patience 2-24h)"
        echo "🔄 Utilisez temporairement : https://prismatic-sherbet-986159.netlify.app"
    else
        echo "🚨 PROBLÈME BUILD - Vérifier logs Netlify"
        echo "🔧 Aller sur dashboard Netlify → Deploys"
    fi
fi