#!/bin/bash

echo "🧪 TESTS RAPIDES MATH4KIDS"
echo "=========================="

echo "🔢 Validation mathématique..."
npm run test:math
if [ $? -ne 0 ]; then
    echo "❌ Échec validation mathématique"
    exit 1
fi

echo "🧪 Tests unitaires..."
npm run test:run
if [ $? -ne 0 ]; then
    echo "❌ Échec tests unitaires"
    exit 1
fi

echo "🎉 TOUS LES TESTS RAPIDES RÉUSSIS !"
