#!/bin/bash

# =============================================================================
# MATH4CHILD BETA - PHASE 3 : ACTIONS IMMÉDIATES
# Lancement coordonné du programme beta testeurs
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${PURPLE}${BOLD}🚀 MATH4CHILD BETA - PHASE 3 : LANCEMENT IMMÉDIAT${NC}"
echo "=================================================="
echo ""

# Variables
BETA_URL="https://prismatic-sherbet-986159.netlify.app"
BETA_EMAIL="gotesttech@gmail.com"
CURRENT_TIME=$(date '+%H:%M')
CURRENT_DATE=$(date '+%d/%m/%Y')

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
step() { echo -e "${BLUE}[ÉTAPE]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
urgent() { echo -e "${RED}${BOLD}[URGENT]${NC} $1"; }

echo -e "${CYAN}📅 Date du lancement : $CURRENT_DATE${NC}"
echo -e "${CYAN}🕒 Heure actuelle : $CURRENT_TIME${NC}"
echo ""

# =============================================================================
# ÉTAPE 1: VÉRIFICATION PRÉ-LANCEMENT
# =============================================================================

step "1️⃣ Vérification pré-lancement critique"

echo "🔍 Vérifications essentielles :"

# Vérifier que l'app est accessible
echo -n "  • URL Beta accessible... "
if command -v curl >/dev/null 2>&1; then
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$BETA_URL" || echo "000")
    if [[ "$HTTP_CODE" =~ ^(200|301|302)$ ]]; then
        echo -e "${GREEN}✅ OK${NC}"
    else
        echo -e "${YELLOW}⚠️ Code $HTTP_CODE - À vérifier manuellement${NC}"
        urgent "VÉRIFIEZ MAINTENANT : $BETA_URL"
    fi
else
    echo -e "${YELLOW}⚠️ curl non disponible - Vérifiez manuellement${NC}"
fi

# Vérifier les fichiers créés
echo -n "  • Fichiers de lancement... "
if [[ -f "beta-program/facebook-post-v2.txt" && -f "beta-program/instagram-post-v2.txt" ]]; then
    echo -e "${GREEN}✅ Prêts${NC}"
else
    echo -e "${RED}❌ Manquants${NC}"
    urgent "Relancez le script Phase 2 !"
fi

# Vérifier la checklist
echo -n "  • Checklist finale... "
if [[ -f "beta-program/CHECKLIST_LANCEMENT_FINAL.md" ]]; then
    echo -e "${GREEN}✅ Disponible${NC}"
else
    echo -e "${RED}❌ Manquante${NC}"
fi

echo ""

# =============================================================================
# ÉTAPE 2: AFFICHAGE DES CONTENUS PRÊTS À PUBLIER
# =============================================================================

step "2️⃣ Contenus prêts pour publication immédiate"

echo ""
echo -e "${BOLD}📘 POST FACEBOOK (Copier-coller prêt) :${NC}"
echo -e "${CYAN}========================================${NC}"
if [[ -f "beta-program/facebook-post-v2.txt" ]]; then
    cat beta-program/facebook-post-v2.txt
else
    echo -e "${RED}❌ Fichier manquant${NC}"
fi

echo ""
echo -e "${BOLD}📸 POST INSTAGRAM (Copier-coller prêt) :${NC}"
echo -e "${CYAN}==========================================${NC}"
if [[ -f "beta-program/instagram-post-v2.txt" ]]; then
    cat beta-program/instagram-post-v2.txt
else
    echo -e "${RED}❌ Fichier manquant${NC}"
fi

echo ""
echo -e "${BOLD}💼 POST LINKEDIN (Copier-coller prêt) :${NC}"
echo -e "${CYAN}========================================${NC}"
if [[ -f "beta-program/linkedin-post-v2.txt" ]]; then
    cat beta-program/linkedin-post-v2.txt
else
    echo -e "${RED}❌ Fichier manquant${NC}"
fi

echo ""

# =============================================================================
# ÉTAPE 3: SEQUENCE DE LANCEMENT GUIDÉE
# =============================================================================

step "3️⃣ Séquence de lancement guidée (MAINTENANT)"

echo ""
echo -e "${PURPLE}${BOLD}🎯 PLAN D'ACTION IMMÉDIAT - PROCHAINES 2 HEURES${NC}"
echo "================================================"

cat << EOF

⏰ ${BOLD}MAINTENANT (${CURRENT_TIME}) - DÉMARRAGE IMMÉDIAT :${NC}

1️⃣ ${BOLD}LINKEDIN (5 minutes)${NC}
   • Ouvrir LinkedIn sur votre profil
   • Copier le contenu LinkedIn ci-dessus
   • Publier avec #EdTech #BetaTest #Math4Child
   • 📌 Épingler le post sur votre profil

2️⃣ ${BOLD}EMAIL RÉSEAU PERSONNEL (10 minutes)${NC}
   • Ouvrir votre client email
   • Utiliser le template email-recrutement-vip.txt
   • Envoyer à 10-15 contacts famille/amis
   • Personnaliser chaque email avec le prénom

3️⃣ ${BOLD}FACEBOOK (5 minutes)${NC}
   • Publier sur votre page personnelle
   • Partager dans 2-3 groupes parents (avec autorisation)
   • Programmer Stories pour ce soir (18h-20h)

4️⃣ ${BOLD}INSTAGRAM (10 minutes)${NC}
   • Post principal avec le contenu préparé
   • 3-5 Stories avec behind-the-scenes
   • Programmer Reels pour plus tard dans la journée

⏰ ${BOLD}DANS 1 HEURE (+1h) - EXPANSION :${NC}

5️⃣ ${BOLD}TWITTER/X + REDDIT${NC}
   • Thread Twitter sur l'innovation EdTech
   • Post dans r/education et r/parenting (avec respect des règles)

6️⃣ ${BOLD}EMAIL PARTENAIRES PROFESSIONNELS${NC}
   • Contacts écoles/enseignants
   • Réseau professionnel EdTech

⏰ ${BOLD}CET APRÈS-MIDI (14h-18h) - BOOST :${NC}

7️⃣ ${BOLD}RELANCES ET INTERACTIONS${NC}
   • Répondre à tous les commentaires
   • Relancer sur LinkedIn avec updates
   • Messages WhatsApp contacts proches

8️⃣ ${BOLD}CONTENUS VIDÉO${NC}
   • YouTube Community post
   • TikTok si applicable
   • Stories Instagram avec démos

EOF

# =============================================================================
# ÉTAPE 4: OUTILS DE SUIVI EN TEMPS RÉEL
# =============================================================================

step "4️⃣ Activation des outils de suivi"

echo ""
echo -e "${BOLD}📊 DASHBOARD DE SUIVI :${NC}"
echo "• Ouvrir dans votre navigateur : beta-program/dashboard-suivi.html"
echo "• Actualiser toutes les 30 minutes"
echo "• Noter chaque candidature reçue"

echo ""
echo -e "${BOLD}📧 MONITORING EMAIL :${NC}"
echo "• Vérifier $BETA_EMAIL toutes les heures"
echo "• Répondre aux candidatures < 2h"
echo "• Utiliser les templates de réponse automatique"

echo ""
echo -e "${BOLD}📱 NOTIFICATIONS :${NC}"
echo "• Activer notifications email sur mobile"
echo "• Configurer alerts Google Analytics (optionnel)"
echo "• Surveiller mentions sur réseaux sociaux"

# =============================================================================
# ÉTAPE 5: MÉTRIQUES DE SUCCÈS J+1
# =============================================================================

step "5️⃣ Objectifs et métriques de succès"

cat << EOF

🎯 ${BOLD}OBJECTIFS AUJOURD'HUI (J-Day) :${NC}
▸ 10+ publications multi-canaux réalisées
▸ 500+ vues/impressions générées
▸ 50+ interactions (likes, commentaires, partages)
▸ 5+ candidatures beta reçues
▸ 100+ clics sur le lien beta

📈 ${BOLD}OBJECTIFS J+1 (Demain) :${NC}
▸ 20+ candidatures qualifiées
▸ 1000+ impressions cumulées
▸ 5+ partages organiques
▸ Première acceptation de beta testeur

🔥 ${BOLD}MILESTONE WEEK 1 :${NC}
▸ 50+ candidatures reçues
▸ 25+ familles sélectionnées
▸ Viralité sur au moins 1 plateforme
▸ Première mention presse/blog

EOF

# =============================================================================
# ÉTAPE 6: CHECKLIST RAPIDE PRÉ-PUBLICATION
# =============================================================================

step "6️⃣ Checklist finale pré-publication"

echo ""
echo -e "${BOLD}✅ CHECKLIST RAPIDE (À cocher maintenant) :${NC}"

cat << 'EOF'

🔧 TECHNIQUE :
[ ] App Math4Child fonctionne parfaitement
[ ] Email gotesttech@gmail.com accessible
[ ] Tous les contenus de posts copiés
[ ] Dashboard de suivi ouvert dans le navigateur

📱 SOCIAL MEDIA :
[ ] LinkedIn profile à jour et professionnel
[ ] Facebook profile public ou posts autorisés
[ ] Instagram business/creator account actif
[ ] Photos de profil et bio cohérentes partout

📧 EMAIL :
[ ] Templates de réponse prêts
[ ] Signature email professionnelle GOTEST
[ ] Auto-répondeur configuré (optionnel)
[ ] Carnet d'adresses à jour

📊 SUIVI :
[ ] Spreadsheet ou outil de tracking prêt
[ ] Notifications email activées
[ ] Calendrier de relances préparé
[ ] Objectifs quotidiens notés

EOF

# =============================================================================
# ÉTAPE 7: LANCEMENT IMMÉDIAT
# =============================================================================

step "7️⃣ 🚀 LANCEMENT IMMÉDIAT"

echo ""
echo -e "${PURPLE}${BOLD}🎉 VOUS ÊTES PRÊT POUR LE LANCEMENT !${NC}"
echo ""

echo -e "${GREEN}${BOLD}📋 ACTIONS À FAIRE MAINTENANT (prochaines 30 min) :${NC}"
echo ""
echo "1. 💼 Publier le post LinkedIn (contenu ci-dessus)"
echo "2. 📧 Envoyer 10 emails à votre réseau personnel"  
echo "3. 📘 Publier sur Facebook page personnelle"
echo "4. 📸 Publier sur Instagram avec hashtags"
echo "5. 📊 Ouvrir le dashboard et commencer le suivi"

echo ""
echo -e "${CYAN}🔗 LIENS ESSENTIELS :${NC}"
echo "• App Beta : $BETA_URL"
echo "• Contact : $BETA_EMAIL"
echo "• Dashboard : beta-program/dashboard-suivi.html"
echo "• Checklist : beta-program/CHECKLIST_LANCEMENT_FINAL.md"

echo ""
echo -e "${YELLOW}⚡ MOTIVATION FINALE :${NC}"
echo "Math4Child va révolutionner l'apprentissage des maths pour des millions d'enfants !"
echo "Votre lancement aujourd'hui est le premier pas vers ce succès mondial ! 🌍"

echo ""
echo -e "${GREEN}${BOLD}🚀 GO GO GO ! LANCEZ MAINTENANT ! 🚀${NC}"

# Ouvrir automatiquement le dashboard si possible
if command -v open >/dev/null 2>&1; then
    echo ""
    echo "📊 Ouverture automatique du dashboard..."
    open beta-program/dashboard-suivi.html 2>/dev/null || true
elif command -v xdg-open >/dev/null 2>&1; then
    echo ""
    echo "📊 Ouverture automatique du dashboard..."
    xdg-open beta-program/dashboard-suivi.html 2>/dev/null || true
fi

echo ""
log "PHASE 3 TERMINÉE - MATH4CHILD BETA LAUNCH IS A GO ! 🎯🚀"
echo ""