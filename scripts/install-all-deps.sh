#!/bin/bash

echo "📦 Installation des dépendances pour toutes les applications..."

apps=(postmath unitflip budgetcron ai4kids multiai)
success_count=0

for app in "${apps[@]}"; do
    if [ -d "apps/$app" ]; then
        echo ""
        echo "📱 Installation pour $app..."
        cd "apps/$app"
        
        if npm install; then
            echo "✅ Installation de $app réussie"
            ((success_count++))
        else
            echo "❌ Installation de $app échouée"
        fi
        
        cd ../..
    fi
done

echo ""
echo "🎉 Installation terminée : $success_count/${#apps[@]} applications installées avec succès"
