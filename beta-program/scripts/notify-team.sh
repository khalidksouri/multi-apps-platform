#!/bin/bash

# Notifications automatiques pour l'équipe
# À adapter selon vos outils (Slack, Discord, Teams)

WEBHOOK_URL="YOUR_WEBHOOK_URL_HERE"  # À remplacer

send_notification() {
    local message="$1"
    local emoji="$2"
    
    echo "$emoji $message"
    
    # Exemple pour Slack (décommenter et configurer)
    # curl -X POST -H 'Content-type: application/json' \
    #     --data "{\"text\":\"$emoji Beta Math4Child: $message\"}" \
    #     $WEBHOOK_URL
}

# Exemples de notifications
send_notification "Lancement du programme beta réussi !" "🚀"
send_notification "10 nouvelles candidatures reçues" "📧"
send_notification "Objectif de 50 testeurs atteint !" "🎯"
