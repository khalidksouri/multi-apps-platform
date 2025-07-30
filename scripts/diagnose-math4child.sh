#!/bin/bash

# Script de diagnostic spécifique pour math4child

echo "🔍 DIAGNOSTIC MATH4CHILD"
echo "========================"
echo ""

echo "📊 Vérification de math4child :"
if [ -d "apps/math4child" ]; then
    echo "  ✅ Dossier apps/math4child présent"
    
    if [ -f "apps/math4child/package.json" ]; then
        echo "  ✅ package.json présent"
        
        # Vérifier Next.js
        if grep -q "next" "apps/math4child/package.json"; then
            next_version=$(grep "next" "apps/math4child/package.json" | head -1)
            echo "  └─ Next.js: $next_version"
        fi
        
        # Vérifier le port
        if grep -q "3001" "apps/math4child/package.json"; then
            echo "  ✅ Port 3001 configuré"
        else
            echo "  ⚠️ Port 3001 non configuré"
        fi
    else
        echo "  ❌ package.json manquant"
    fi
    
    if [ -d "apps/math4child/src" ]; then
        echo "  ✅ Structure src/ présente"
    else
        echo "  ❌ Structure src/ manquante"
    fi
else
    echo "  ❌ Dossier apps/math4child manquant"
fi

echo ""
echo "🌍 Configuration I18n :"
if [ -f "shared/i18n/language-config.ts" ]; then
    echo "  ✅ Configuration 20 langues présente"
else
    echo "  ❌ Configuration 20 langues manquante"
fi

echo ""
echo "🔧 Commandes disponibles :"
echo "  • make dev-math4child       # Démarrer math4child"
echo "  • make check-all-apps       # Vérifier toutes les apps"
echo "  • make security-update      # Mise à jour sécurité"
echo "  • make help                 # Aide complète"
