#!/bin/bash

echo "🤖 Ouverture d'Android Studio pour toutes les applications..."

apps=(postmath unitflip budgetcron ai4kids multiai)

for app in "${apps[@]}"; do
    if [ -d "apps/$app/android" ]; then
        echo "📱 Ouverture d'Android Studio pour $app..."
        cd "apps/$app"
        npm run android &
        cd ../..
        sleep 3
    else
        echo "❌ Projet Android non trouvé pour $app"
    fi
done

echo "✅ Tous les projets Android ouverts dans Android Studio"
