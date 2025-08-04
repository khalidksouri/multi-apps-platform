#!/bin/bash

PORT=${1:-3001}
URL="http://localhost:$PORT"

echo "🔍 VALIDATION DES CHANGEMENTS"
echo "=============================="

echo "📅 Dernières modifications :"
ls -la src/app/page.tsx src/app/layout.tsx

echo ""
echo "📄 Contenu page.tsx (premières lignes) :"
head -5 src/app/page.tsx

echo ""
echo "📄 Contenu layout.tsx (premières lignes) :"
head -5 src/app/layout.tsx

echo ""
echo "✅ Validation terminée"
echo "🌐 Tester maintenant : $URL"
