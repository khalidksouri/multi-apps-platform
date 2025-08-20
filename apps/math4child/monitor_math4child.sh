#!/bin/bash
# Script monitoring Math4Child v4.2.0 - Monorepo

# URLs à surveiller
URLS=(
    "https://math4child.netlify.app"
    "https://math4child.com"  # Si configuré
)

echo "🔍 MONITORING MATH4CHILD v4.2.0"
echo "=============================="

for url in "${URLS[@]}"; do
    echo -n "Vérification $url ... "
    
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
    
    if [ "$STATUS" = "200" ]; then
        echo "✅ OK (Status: $STATUS)"
    else
        echo "❌ PROBLÈME (Status: $STATUS)"
    fi
done

echo ""
echo "📊 Monitoring terminé - $(date)"
