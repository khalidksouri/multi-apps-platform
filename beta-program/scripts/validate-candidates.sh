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
