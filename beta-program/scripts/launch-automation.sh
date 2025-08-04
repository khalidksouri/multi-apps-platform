#!/bin/bash

# Automation du lancement Beta Math4Child
# Exécution coordonnée sur tous les canaux

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 AUTOMATION LANCEMENT BETA MATH4CHILD${NC}"
echo "=========================================="

# Planning de publication (heure de Paris)
declare -A SCHEDULE=(
    ["09:00"]="LinkedIn + Email réseau personnel"
    ["10:00"]="Facebook groupes parents + Stories Instagram"
    ["11:00"]="Twitter/X + Email partenaires"
    ["14:00"]="Relance LinkedIn + WhatsApp contacts"
    ["16:00"]="YouTube Community + Telegram"
    ["18:00"]="Instagram posts + TikTok"
    ["20:00"]="Facebook groupes éducation + Final push"
)

echo "📅 Planning de publication coordonnée:"
for time in $(printf '%s\n' "${!SCHEDULE[@]}" | sort); do
    echo "  $time - ${SCHEDULE[$time]}"
done

echo ""
echo -e "${YELLOW}⚠️ Actions manuelles requises:${NC}"
echo "1. Copier le contenu des fichiers *-post-v2.txt"
echo "2. Adapter selon le canal (hashtags, format)"
echo "3. Publier selon le planning"
echo "4. Monitorer les réactions et candidatures"

echo ""
echo -e "${GREEN}📊 Métriques à surveiller:${NC}"
echo "• Nombre de vues/impressions"
echo "• Interactions (likes, commentaires, partages)"
echo "• Clics sur le lien beta"
echo "• Emails de candidature reçus"
echo "• Taux de conversion par canal"

echo ""
echo "🎯 Objectif J+1: 20+ candidatures"
echo "🎯 Objectif J+7: 50+ candidatures"
echo "🎯 Objectif J+14: 100+ candidatures"
