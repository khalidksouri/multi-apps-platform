#!/bin/bash

# =============================================================================
# PHASE 2 - LANCEMENT BETA MATH4CHILD
# Recrutement et tests utilisateurs
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${PURPLE}👥 PHASE 2 - LANCEMENT BETA MATH4CHILD${NC}"
echo "========================================"
echo -e "${GREEN}Phase 1 TERMINÉE ✅ | Focus: 100% Math4Child${NC}"
echo ""

log() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }
step() { echo -e "${BLUE}[ÉTAPE]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# =============================================================================
# ÉTAPE 1: VALIDATION PHASE 1 TERMINÉE
# =============================================================================

step "1️⃣ Validation Phase 1 Math4Child terminée"

# Vérifier tests Math4Child purs
PURE_TESTS=$(grep -r "Math4Child" tests/ 2>/dev/null | wc -l)
OLD_TESTS=$(grep -r "postmath\|unitflip\|budgetcron\|ai4kids\|multiai" tests/ 2>/dev/null | wc -l || echo "0")

if [ $PURE_TESTS -gt 0 ] && [ $OLD_TESTS -eq 0 ]; then
    log "✅ Phase 1 validée - Tests 100% Math4Child"
else
    warn "⚠️ Phase 1 partielle mais Math4Child prioritaire"
fi

# Vérifier builds
BUILD_STATUS="❌"
if [ -d ".next" ] || [ -d "out" ]; then
    BUILD_STATUS="✅"
    log "✅ Builds Math4Child disponibles"
fi

info "Status technique: Build $BUILD_STATUS | Tests: $PURE_TESTS Math4Child"

# =============================================================================
# ÉTAPE 2: PRÉPARATION RECRUTEMENT BETA
# =============================================================================

step "2️⃣ Préparation recrutement beta testeurs"

# Créer dossier beta
mkdir -p beta-program
mkdir -p beta-program/assets
mkdir -p beta-program/scripts

info "Structure beta program Math4Child créée"

# Formulaire de candidature beta
cat > beta-program/formulaire-beta.md << 'EOF'
# 👥 Programme Beta Math4Child - Formulaire de Candidature

## 🎯 Nous recherchons 50-100 familles pour tester Math4Child !

### Informations Parent/Tuteur
- **Nom/Prénom** : ________________
- **Email** : ____________________
- **Téléphone** : _________________
- **Ville/Pays** : ________________

### Informations Enfant(s)
- **Âge enfant(s)** : ______________
- **Niveau scolaire** : ____________
- **Nombre d'enfants** : ___________

### Équipement Technique
- **Smartphone** : Android / iOS / Les deux
- **Tablette** : Oui / Non - Marque : _______
- **Ordinateur** : Oui / Non
- **Connexion Internet** : Fibre / ADSL / 4G

### Engagement Beta (2 semaines)
- **Temps disponible/semaine** : _____ heures
- **Période préférée** : Semaine / Weekend / Les deux
- **Feedback détaillé** : Oui / Non

### Motivation
**Pourquoi voulez-vous tester Math4Child ?** (1-2 phrases)
_________________________________________________

### Langues d'intérêt
- **Langue principale** : ____________
- **Autres langues** : ______________
- **Intérêt RTL** (Arabe/Hébreu) : Oui / Non

---

## 🎁 Avantages Beta Testeur

✅ **Accès Premium gratuit** 3 mois  
✅ **Contact direct** équipe développement  
✅ **Badge Beta Tester** exclusif  
✅ **50% réduction** abonnement à vie  
✅ **Influence** sur le produit final  

**📧 Envoyez ce formulaire à : khalid_ksouri@yahoo.fr**
**📱 Ou via notre site : www.math4child.com/beta**

*Programme limité à 100 familles - Premier arrivé, premier servi !*
EOF

log "✅ Formulaire de candidature beta créé"

# Script de validation candidats
cat > beta-program/scripts/validate-candidates.sh << 'EOF'
#!/bin/bash

# Script de validation candidats beta Math4Child

echo "📋 Validation Candidats Beta Math4Child"
echo "======================================="

# Critères de sélection
echo "🎯 Critères de sélection :"
echo "  ✅ Enfant âgé 6-12 ans (CP-CM2)"
echo "  ✅ Équipement compatible (Android/iOS)"
echo "  ✅ Engagement 2 semaines minimum"
echo "  ✅ Feedback constructif attendu"
echo "  ✅ Diversité géographique"
echo ""

# Template email d'acceptation
cat << 'EMAIL' > beta-acceptance-template.txt
Objet: 🎉 Félicitations ! Vous êtes sélectionné(e) pour le Beta Math4Child !

Bonjour [NOM],

Excellente nouvelle ! Votre famille a été sélectionnée pour participer au programme beta Math4Child ! 🎉

📱 **Votre accès beta :**
- Lien de téléchargement : [LIEN_BETA]
- Code d'accès Premium : [CODE_PREMIUM]
- Durée : 2 semaines de test + 3 mois gratuits

🧪 **Programme de test :**
- **Semaine 1** : Découverte et premiers tests
- **Semaine 2** : Tests approfondis et feedback
- **Questionnaire intermédiaire** : Jour 7
- **Survey final** : Jour 14

📞 **Support dédié :**
- Email : khalid_ksouri@yahoo.fr
- Réponse < 24h garantie
- Contact direct équipe GOTEST

🎁 **Vos avantages :**
- Badge "Beta Tester Math4Child" exclusif
- 50% réduction abonnement à vie
- Influence directe sur le produit final
- Accès aux nouvelles fonctionnalités en avant-première

📋 **Prochaines étapes :**
1. Installer Math4Child via le lien
2. Créer votre profil avec le code Premium
3. Commencer les tests avec votre enfant
4. Nous envoyer vos premiers retours dans 3 jours

Merci de faire partie de l'aventure Math4Child ! Votre feedback sera précieux pour créer LA meilleure app éducative pour nos enfants ! 🚀📱

Cordialement,
L'équipe Math4Child - GOTEST
SIRET: 53958712100028
EMAIL

echo "✅ Template email d'acceptation créé"
EOF

chmod +x beta-program/scripts/validate-candidates.sh

# Questionnaire intermédiaire (J7)
cat > beta-program/questionnaire-j7.md << 'EOF'
# 📊 Questionnaire Intermédiaire Beta Math4Child (Jour 7)

## Informations Générales
- **Nom famille** : ________________
- **Date début test** : ____________

## 🛠️ Installation et Configuration
1. **L'installation s'est-elle bien passée ?**
   - [ ] Très facile
   - [ ] Facile  
   - [ ] Moyen
   - [ ] Difficile
   - [ ] Très difficile

2. **Avez-vous rencontré des bugs ou problèmes ?**
   - [ ] Aucun
   - [ ] Bugs mineurs
   - [ ] Bugs gênants
   - [ ] Bugs bloquants
   
   **Si oui, décrivez** : _________________________

## 👶 Expérience Enfant
3. **Votre enfant aime-t-il l'interface Math4Child ?**
   - [ ] Adore (5/5)
   - [ ] Aime beaucoup (4/5)
   - [ ] Aime (3/5)
   - [ ] N'aime pas trop (2/5)
   - [ ] N'aime pas (1/5)

4. **Les exercices sont-ils adaptés au niveau de votre enfant ?**
   - [ ] Parfaitement adaptés
   - [ ] Plutôt adaptés
   - [ ] Moyennement adaptés
   - [ ] Trop faciles
   - [ ] Trop difficiles

5. **Temps d'utilisation quotidien moyen ?**
   - [ ] < 10 minutes
   - [ ] 10-20 minutes
   - [ ] 20-30 minutes
   - [ ] 30-45 minutes
   - [ ] > 45 minutes

## 🌍 Fonctionnalités
6. **Avez-vous testé les langues alternatives ?**
   - [ ] Oui - Lesquelles : ____________
   - [ ] Non

7. **Si RTL (Arabe/Hébreu), l'interface fonctionne-t-elle bien ?**
   - [ ] Parfaitement
   - [ ] Bien
   - [ ] Correctement
   - [ ] Problèmes mineurs
   - [ ] Problèmes majeurs
   - [ ] Non testé

## 📱 Technique
8. **Performance de l'application ?**
   - [ ] Très rapide
   - [ ] Rapide
   - [ ] Correcte
   - [ ] Lente
   - [ ] Très lente

9. **Plateforme principale d'utilisation ?**
   - [ ] Android smartphone
   - [ ] Android tablette
   - [ ] iPhone
   - [ ] iPad
   - [ ] Ordinateur (web)

## 💡 Suggestions
10. **Quelle fonctionnalité manque le plus ?**
    _________________________________________

11. **Qu'est-ce qui vous plaît le plus ?**
    _________________________________________

12. **Qu'est-ce qui vous déplaît le plus ?**
    _________________________________________

---
**📧 Retour à : khalid_ksouri@yahoo.fr**
**⏰ Merci de nous retourner ce questionnaire avant J10**
EOF

# Survey final (J14)
cat > beta-program/survey-final.md << 'EOF'
# 🎯 Survey Final Beta Math4Child (Jour 14)

## Net Promoter Score
**Sur une échelle de 0 à 10, recommanderiez-vous Math4Child à d'autres parents ?**

0 - 1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 - 10

**Pourquoi cette note ?** _________________________

## 💰 Pricing
**Quel prix serait acceptable pour l'abonnement Premium Math4Child ?**
- [ ] 4.99€/mois
- [ ] 6.99€/mois  
- [ ] 9.99€/mois
- [ ] 12.99€/mois
- [ ] 14.99€/mois
- [ ] > 15€/mois

## 🌟 Satisfaction Globale
**Note globale Math4Child (1-5 étoiles) :**
⭐ ⭐ ⭐ ⭐ ⭐

**Meilleure fonctionnalité :**
_________________________________

**Pire aspect à améliorer :**
_________________________________

## 📈 Utilisation
**Votre enfant a-t-il progressé en mathématiques ?**
- [ ] Nettement
- [ ] Un peu
- [ ] Pas vraiment
- [ ] Pas du tout
- [ ] Trop tôt pour dire

**Continuerez-vous à utiliser Math4Child ?**
- [ ] Certainement
- [ ] Probablement
- [ ] Peut-être
- [ ] Probablement pas
- [ ] Certainement pas

## 🌍 Langues
**Langues testées et satisfaction :**
- Français : ⭐⭐⭐⭐⭐
- Anglais : ⭐⭐⭐⭐⭐
- Autre : _______ : ⭐⭐⭐⭐⭐

## 📢 Témoignage
**Accepteriez-vous que votre témoignage soit publié ?**
- [ ] Oui, avec nom et photo
- [ ] Oui, anonyme seulement
- [ ] Non

**Votre témoignage (optionnel) :**
_________________________________________
_________________________________________

## 💌 Message équipe
**Un message pour l'équipe Math4Child ?**
_________________________________________

---
**🎁 Merci pour votre participation !**
**Votre réduction 50% à vie sera activée sous 48h**
EOF

log "✅ Questionnaires beta J7 et J14 créés"

# =============================================================================
# ÉTAPE 3: CANAUX DE RECRUTEMENT
# =============================================================================

step "3️⃣ Stratégie de recrutement multi-canaux"

# Plan de communication
cat > beta-program/plan-communication.md << 'EOF'
# 📢 Plan de Communication Beta Math4Child

## 🎯 Objectif : 50-100 familles en 2 semaines

### 📱 Réseaux Sociaux Parents (30 testeurs)

#### Facebook
- **Groupes parents d'élèves** : Posts dans groupes locaux
- **Pages parentalité** : Partenariats influenceurs
- **Ads ciblées** : Parents 25-45 ans + enfants 6-12 ans

#### Instagram  
- **#educationenfant** : Posts organiques
- **Stories** : Démonstrations Math4Child
- **Reels** : Témoignages rapides

#### LinkedIn
- **Réseau GOTEST** : Posts professionnels
- **Groupes parents** : Partage expertise éducative

### 🏫 Partenaires Éducatifs (15 testeurs)

#### Associations parents d'élèves
- **Email direct** : Présentation programme
- **Réunions** : Démonstrations live
- **Newsletters** : Annonces programme

#### Centres de loisirs
- **Partenariats** : Tests pendant activités
- **Formations** : Éducateurs testeurs

#### Professeurs particuliers maths
- **Réseau** : Recommandations clients
- **Outils pédagogiques** : Tests en cours

### 💻 Community Tech (10 testeurs)

#### ProductHunt
- **Teaser** : "Math4Child arrive bientôt"
- **Beta access** : Early adopters

#### Reddit
- **r/education** : Posts expertise
- **r/parenting** : Discussions communauté

#### Discord éducation
- **Serveurs spécialisés** : Annonces

### 👨‍👩‍👧‍👦 Réseau Personnel (5 testeurs)
- **Famille/amis** : Premier cercle
- **Collègues parents** : Bouche à oreille
- **Contacts professionnels** : Réseau GOTEST

## 📅 Timeline Recrutement

### Semaine 1 : Lancement
- **J1** : Posts réseaux sociaux
- **J2** : Contact partenaires éducatifs  
- **J3** : Community tech outreach
- **J4** : Relance + ajustements
- **J5** : Première sélection (20 familles)

### Semaine 2 : Finalisation
- **J8** : Derniers recrutements
- **J9** : Sélection finale (50+ familles)
- **J10** : Envoi invitations
- **J11** : Setup technique testeurs
- **J12** : Lancement officiel beta

## 📊 KPIs Recrutement
- **100+ candidatures** reçues
- **50+ familles** sélectionnées
- **Mix Android/iOS** représentatif
- **5+ pays** différents
- **Engagement** 2 semaines confirmé
EOF

# Script de lancement réseaux sociaux
cat > beta-program/scripts/social-launch.sh << 'EOF'
#!/bin/bash

echo "📱 Lancement Communication Beta Math4Child"
echo "========================================="

# Messages pré-rédigés
echo "📝 Messages pour réseaux sociaux :"
echo ""

echo "🔹 FACEBOOK :"
cat << 'FB'
🎉 RECHERCHE FAMILLES BETA TESTEURS ! 

👨‍👩‍👧‍👦 Votre enfant (6-12 ans) aime les maths ? Testez Math4Child GRATUITEMENT !

✨ Nous développons THE app éducative révolutionnaire :
🌍 195+ langues (y compris arabe, chinois...)
🎮 Jeu adaptatif par niveau
📊 Suivi progression détaillé
💰 Paiements sécurisés

🎁 AVANTAGES BETA TESTEUR :
• 3 mois Premium GRATUIT
• Contact direct développeurs
• 50% réduction à vie
• Badge exclusif "Beta Tester"

📧 Candidature : khalid_ksouri@yahoo.fr
⏰ 50 places seulement !

#Math4Child #EducationEnfant #BetaTest #Mathématiques #AppEducative
FB

echo ""
echo "🔹 INSTAGRAM :"
cat << 'IG'
🚀 Math4Child recherche 50 familles beta testeuses ! 

👶 Enfant 6-12 ans ?
📱 Smartphone/tablette ?
⏰ 15min/jour pendant 2 semaines ?

🎁 En échange :
✅ App Premium gratuite 3 mois
✅ Contact direct équipe développement  
✅ Badge Beta Tester exclusif
✅ 50% réduction à vie

L'app qui révolutionne l'apprentissage des maths ! 🧮✨

📧 khalid_ksouri@yahoo.fr
🔗 www.math4child.com/beta

#BetaTest #Math4Child #EducationDigitale #ParentsInfluenceurs
IG

echo ""
echo "🔹 LINKEDIN :"
cat << 'LI'
🎯 OPPORTUNITÉ BETA TEST - Math4Child

En tant que dirigeant GOTEST, je recherche 50 familles pour tester notre application éducative révolutionnaire.

📊 MATH4CHILD EN CHIFFRES :
• 195+ langues supportées
• Architecture Next.js + Capacitor
• Support RTL complet
• Stripe intégration sécurisée
• Tests Playwright complets

👨‍👩‍👧‍👦 PROFIL RECHERCHÉ :
• Parents enfants 6-12 ans
• Sensibles innovation éducative
• Équipement mobile compatible
• Feedback constructif

🎁 CONTREPARTIE :
• Accès Premium 3 mois gratuit
• Contact direct équipe technique
• Influence produit final
• Réduction commerciale

Intéressé(e) ? Message privé ou khalid_ksouri@yahoo.fr

#EdTech #Innovation #BetaTest #GOTEST #EducationDigitale
LI

echo ""
echo "✅ Messages réseaux sociaux prêts !"
echo "📅 À programmer sur 2 semaines"
EOF

chmod +x beta-program/scripts/social-launch.sh

log "✅ Plan de communication et scripts sociaux créés"

# =============================================================================
# ÉTAPE 4: OUTILS DE SUIVI BETA
# =============================================================================

step "4️⃣ Outils de suivi programme beta"

# Tableau de bord testeurs
cat > beta-program/dashboard-testeurs.md << 'EOF'
# 📊 Dashboard Beta Testeurs Math4Child

## 📋 Suivi Candidatures
| Nom | Email | Enfant(s) | Équipement | Status | Date |
|-----|-------|-----------|------------|--------|------|
| Exemple Famille | test@example.com | 8 ans | Android | Accepté | 04/08 |
| ... | ... | ... | ... | ... | ... |

## 📈 Métriques Temps Réel
- **Candidatures reçues** : ___/100
- **Familles sélectionnées** : ___/50
- **Taux d'acceptation** : ___%
- **Mix plateforme** : Android ___% / iOS ___%
- **Pays représentés** : ___

## 🧪 Progression Tests
- **Installations réussies** : ___/50
- **Tests actifs J1-7** : ___/50
- **Questionnaire J7 reçu** : ___/50
- **Tests actifs J8-14** : ___/50
- **Survey final reçu** : ___/50

## 🐛 Bugs Remontés
| Bug | Sévérité | Plateforme | Reporter | Status |
|-----|----------|------------|----------|--------|
| ... | ... | ... | ... | ... |

## 💡 Suggestions Collectées
- **Fonctionnalités demandées** : ___
- **Améliorations UX** : ___
- **Problèmes techniques** : ___

## 📊 Satisfaction Moyenne
- **NPS Score** : ___/10
- **App Rating** : ___/5
- **Recommendation** : ___%
- **Retention intention** : ___%
EOF

# Script de monitoring quotidien
cat > beta-program/scripts/daily-monitoring.sh << 'EOF'
#!/bin/bash

echo "📊 Monitoring Quotidien Beta Math4Child"
echo "======================================"
echo "Date: $(date '+%d/%m/%Y %H:%M')"
echo ""

# Vérifications quotidiennes
echo "🔍 Vérifications quotidiennes :"
echo "  □ Emails candidatures lus"
echo "  □ Nouveaux testeurs intégrés"
echo "  □ Support technique fourni"
echo "  □ Bugs critiques traités"
echo "  □ Feedback collecté"
echo "  □ Métriques mises à jour"
echo ""

# Rappels actions
echo "⏰ Actions du jour :"
echo "  • Répondre emails < 24h"
echo "  • Relancer testeurs inactifs"
echo "  • Mettre à jour dashboard"
echo "  • Préparer rapport hebdomadaire"
echo ""

# KPIs à suivre
echo "📈 KPIs à vérifier :"
echo "  • Nombre candidatures reçues"
echo "  • Taux conversion candidature → testeur"
echo "  • Engagement quotidien testeurs"
echo "  • Bugs nouveaux remontés"
echo "  • Satisfaction moyenne"
echo ""

echo "✅ Monitoring terminé"
EOF

chmod +x beta-program/scripts/daily-monitoring.sh

log "✅ Outils de suivi et monitoring créés"

# =============================================================================
# ÉTAPE 5: RAPPORT PHASE 2 PRÉPARATION
# =============================================================================

step "5️⃣ Rapport préparation Phase 2"

echo ""
echo -e "${PURPLE}📊 PHASE 2 BETA - PRÉPARATION TERMINÉE${NC}"
echo "========================================="

echo -e "${BLUE}🎯 Objectifs Phase 2 :${NC}"
echo "  • 50-100 familles beta testeuses"
echo "  • 2 semaines tests intensifs"
echo "  • Feedback qualitatif complet"
echo "  • Optimisations UX critiques"
echo "  • Validation pricing"
echo ""

echo -e "${BLUE}📁 Livrables créés :${NC}"
echo "  ✅ Formulaire candidature beta"
echo "  ✅ Scripts validation candidats"
echo "  ✅ Questionnaires J7 et J14"
echo "  ✅ Plan communication multi-canaux"
echo "  ✅ Messages réseaux sociaux prêts"
echo "  ✅ Dashboard suivi testeurs"
echo "  ✅ Scripts monitoring quotidien"
echo ""

echo -e "${BLUE}📅 Timeline Phase 2 :${NC}"
echo "  • Semaine 1-2 : Recrutement 50+ familles"
echo "  • Semaine 3-4 : Tests beta intensifs"
echo "  • Semaine 5 : Analyse feedback + optimisations"
echo "  • Semaine 6 : Préparation Phase 3 (lancement)"
echo ""

echo -e "${BLUE}📱 Canaux de recrutement :${NC}"
echo "  • Réseaux sociaux parents (Facebook, Instagram)"
echo "  • Partenaires éducatifs (écoles, centres)"
echo "  • Community tech (ProductHunt, Reddit)"
echo "  • Réseau personnel GOTEST"
echo ""

echo -e "${BLUE}🎁 Incitations beta testeurs :${NC}"
echo "  • 3 mois Premium gratuit"
echo "  • Contact direct équipe développement"
echo "  • Badge Beta Tester exclusif"
echo "  • 50% réduction abonnement à vie"
echo "  • Influence sur produit final"
echo ""

echo -e "${GREEN}🚀 PHASE 2 PRÊTE À LANCER !${NC}"
echo ""

echo -e "${CYAN}📋 Actions immédiates :${NC}"
echo "  1. Lancer communication réseaux sociaux"
echo "  2. Contacter partenaires éducatifs"
echo "  3. Préparer beta build Math4Child"
echo "  4. Configurer système candidatures"
echo "  5. Planifier calendrier 2 semaines"
echo ""

echo -e "${CYAN}📧 Contact Programme Beta :${NC}"
echo "  Email : khalid_ksouri@yahoo.fr"
echo "  Web : www.math4child.com/beta"
echo "  Support : < 24h garanti"
echo ""

log "Phase 2 Beta Math4Child prête ! Let's find amazing families ! 👨‍👩‍👧‍👦✨"