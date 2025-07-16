#!/bin/bash

echo "🔨 Build de toutes les applications..."

apps=(postmath unitflip budgetcron ai4kids multiai)
success_count=0

for app in "${apps[@]}"; do
    if [ -d "apps/$app" ]; then
        echo ""
        echo "📱 Build de $app..."
        cd "apps/$app"
        
        # Build web
        if npm run build:web; then
            echo "✅ Build web de $app réussi"
        else
            echo "❌ Build web de $app échoué"
        fi
        
        # Build mobile
        if npm run build:mobile; then
            echo "✅ Build mobile de $app réussi"
        else
            echo "❌ Build mobile de $app échoué"
        fi
        
        # Sync Capacitor
        if npx cap sync; then
            echo "✅ Sync Capacitor de $app réussi"
            ((success_count++))
        else
            echo "❌ Sync Capacitor de $app échoué"
        fi
        
        cd ../..
    fi
done

echo ""
echo "🎉 Build terminé : $success_count/${#apps[@]} applications buildées avec succès"
