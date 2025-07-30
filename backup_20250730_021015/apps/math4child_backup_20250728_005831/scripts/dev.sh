#!/bin/bash

# Script de développement pour Math4Child
echo "🚀 Démarrage de l'environnement de développement..."

# Démarrer MongoDB si pas déjà en cours
if ! pgrep -x "mongod" > /dev/null; then
    echo "📊 Démarrage de MongoDB..."
    mongod --dbpath ./data/db &
fi

# Démarrer le backend
echo "🛠️ Démarrage du backend..."
cd backend && npm run dev &
BACKEND_PID=$!

# Attendre que le backend soit prêt
sleep 3

# Démarrer le frontend
echo "🎨 Démarrage du frontend..."
cd .. && npm run dev &
FRONTEND_PID=$!

echo "✅ Environnement prêt !"
echo "📱 Frontend: http://localhost:3000"
echo "🛠️ Backend: http://localhost:3001"
echo "📊 API Health: http://localhost:3001/health"

# Attendre les signaux pour arrêter proprement
trap "kill $BACKEND_PID $FRONTEND_PID; exit" INT TERM

wait
