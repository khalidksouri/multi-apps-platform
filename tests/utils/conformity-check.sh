#!/bin/bash

# ===============================================================
# Script de vérification conformité README.md
# Math4Child v4.2.0 - Révolution Éducative Mondiale
# ===============================================================

echo "🔍 VÉRIFICATION CONFORMITÉ README.MD - MATH4CHILD v4.2.0"
echo "=========================================================="

# Vérifier que l'application tourne
if ! curl -s http://localhost:3000 > /dev/null; then
    echo "❌ Application non accessible sur http://localhost:3000"
    echo "   Démarrez l'application avec: npm run dev"
    exit 1
fi

echo "✅ Application accessible"

# Télécharger la page d'accueil pour vérification
echo "📥 Récupération du contenu de la page d'accueil..."
PAGE_CONTENT=$(curl -s http://localhost:3000 || echo "")

if [ -z "$PAGE_CONTENT" ]; then
    echo "❌ Impossible de récupérer le contenu de la page"
    exit 1
fi

echo "📝 Analyse du contenu..."

# Variables de conformité
CONFORMITY_SCORE=0
TOTAL_CHECKS=10

# 1. Vérifier l'absence d'éléments interdits
echo ""
echo "🔒 VÉRIFICATION ÉLÉMENTS INTERDITS:"

if echo "$PAGE_CONTENT" | grep -q "GOTEST"; then
    echo "❌ CRITIQUE: 'GOTEST' trouvé dans la page (INTERDIT)"
else
    echo "✅ 'GOTEST' absent"
    ((CONFORMITY_SCORE++))
fi

if echo "$PAGE_CONTENT" | grep -q "53958712100028"; then
    echo "❌ CRITIQUE: SIRET '53958712100028' trouvé (INTERDIT)"
else
    echo "✅ SIRET absent"
    ((CONFORMITY_SCORE++))
fi

if echo "$PAGE_CONTENT" | grep -q "gotesttech@gmail.com"; then
    echo "❌ CRITIQUE: Email dev 'gotesttech@gmail.com' trouvé (INTERDIT)"
else
    echo "✅ Email développement absent"
    ((CONFORMITY_SCORE++))
fi

# 2. Vérifier la présence d'éléments obligatoires
echo ""
echo "✅ VÉRIFICATION ÉLÉMENTS OBLIGATOIRES:"

if echo "$PAGE_CONTENT" | grep -q "Math4Child"; then
    echo "✅ Marque 'Math4Child' présente"
    ((CONFORMITY_SCORE++))
else
    echo "❌ 'Math4Child' manquant"
fi

if echo "$PAGE_CONTENT" | grep -q "v4.2.0"; then
    echo "✅ Version 'v4.2.0' présente"
    ((CONFORMITY_SCORE++))
else
    echo "❌ Version 'v4.2.0' manquante"
fi

if echo "$PAGE_CONTENT" | grep -q "Révolution Éducative"; then
    echo "✅ 'Révolution Éducative' présent"
    ((CONFORMITY_SCORE++))
else
    echo "❌ 'Révolution Éducative' manquant"
fi

# 3. Vérifier les contacts autorisés
if echo "$PAGE_CONTENT" | grep -q "support@math4child.com"; then
    echo "✅ Email support autorisé présent"
    ((CONFORMITY_SCORE++))
else
    echo "⚠️  Email support manquant (recommandé)"
fi

if echo "$PAGE_CONTENT" | grep -q "math4child.com"; then
    echo "✅ Domaine officiel présent"
    ((CONFORMITY_SCORE++))
else
    echo "⚠️  Domaine officiel manquant"
fi

# 4. Vérifier les innovations
if echo "$PAGE_CONTENT" | grep -q -E "(IA Adaptative|Reconnaissance|Réalité Augmentée|Assistant Vocal)"; then
    echo "✅ Innovations détectées"
    ((CONFORMITY_SCORE++))
else
    echo "⚠️  Innovations non détectées"
fi

# 5. Vérifier le support multilingue
if echo "$PAGE_CONTENT" | grep -q -E "(200\+|multilingue|langues)"; then
    echo "✅ Support multilingue mentionné"
    ((CONFORMITY_SCORE++))
else
    echo "⚠️  Support multilingue non mentionné"
fi

# Calcul du score final
echo ""
echo "=========================================================="
echo "📊 RÉSULTAT CONFORMITÉ README.MD:"
echo "   Score: $CONFORMITY_SCORE/$TOTAL_CHECKS"

PERCENTAGE=$((CONFORMITY_SCORE * 100 / TOTAL_CHECKS))
echo "   Pourcentage: $PERCENTAGE%"

if [ $CONFORMITY_SCORE -eq $TOTAL_CHECKS ]; then
    echo "🎉 CONFORMITÉ PARFAITE - Prêt pour déploiement !"
    exit 0
elif [ $CONFORMITY_SCORE -ge 8 ]; then
    echo "✅ CONFORMITÉ EXCELLENTE - Déploiement recommandé"
    exit 0
elif [ $CONFORMITY_SCORE -ge 6 ]; then
    echo "⚠️  CONFORMITÉ ACCEPTABLE - Améliorations recommandées"
    exit 1
else
    echo "❌ CONFORMITÉ INSUFFISANTE - Corrections requises"
    exit 1
fi
