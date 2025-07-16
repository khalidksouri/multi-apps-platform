#!/bin/bash

echo "🚀 Démarrage de toutes les applications en mode développement..."

# Ports et applications
apps=(postmath unitflip budgetcron ai4kids multiai)
ports=(3001 3002 3003 3004 3005)
pids=()

# Fonction pour tuer tous les processus
cleanup() {
    echo ""
    echo "🛑 Arrêt de tous les serveurs..."
    for pid in "${pids[@]}"; do
        if kill -0 $pid 2>/dev/null; then
            kill $pid 2>/dev/null
        fi
    done
    exit 0
}

trap cleanup INT TERM

# Démarrer chaque application
for i in "${!apps[@]}"; do
    app="${apps[$i]}"
    port="${ports[$i]}"
    
    if [ -d "apps/$app" ]; then
        echo "📱 Démarrage de $app sur le port $port..."
        cd "apps/$app"
        PORT=$port npm run dev > "../$app.log" 2>&1 &
        pids+=($!)
        cd ../..
        sleep 3
        
        # Vérifier que le serveur démarre
        if curl -s "http://localhost:$port" >/dev/null 2>&1; then
            echo "✅ $app démarré avec succès sur http://localhost:$port"
        else
            echo "⚠️  $app en cours de démarrage sur http://localhost:$port"
        fi
    else
        echo "❌ Application $app non trouvée"
    fi
done

echo ""
echo "🌟 Applications démarrées :"
echo "   🧮 Postmath Pro:    http://localhost:3001"
echo "   🔄 UnitFlip Pro:    http://localhost:3002"
echo "   💰 BudgetCron:      http://localhost:3003"
echo "   🎨 AI4Kids:         http://localhost:3004"
echo "   🤖 MultiAI Search:  http://localhost:3005"
echo ""
echo "📋 Logs disponibles dans apps/[nom-app].log"
echo "🛑 Appuyez sur Ctrl+C pour arrêter tous les serveurs"
echo ""

# Attendre indéfiniment
wait
