# 🔒 Guide de Séparation - Technique vs Interface

## ❌ JAMAIS visible pour les utilisateurs :

### Informations techniques
- SIRET: 53958712100028
- Nom société: GOTEST  
- Email technique: khalid_ksouri@yahoo.fr
- Configuration interne

## ✅ Visible pour les utilisateurs :

### Interface propre
- Nom application: "Math4Child"
- Description: "Apprendre les maths en s'amusant"
- Fonctionnalités pédagogiques
- Prix: "9,99€/mois"

## 📍 Où GOTEST reste (technique uniquement) :

### Configuration backend
- `capacitor.config.json` → App ID technique
- `package.json` → Métadonnées développeur
- Variables d'environnement
- Configuration Stripe (backend)
- Tests automatisés

### Interface utilisateur (AUCUNE référence)
- `src/app/page.tsx` → Interface propre
- Modals et popups → Sans GOTEST
- Messages utilisateur → Marque "Math4Child" uniquement
- Écrans de paiement → Professional uniquement

## 🎯 Principe fondamental :

**L'utilisateur ne doit JAMAIS voir:**
- Le nom de la société technique (GOTEST)
- Le SIRET ou informations légales
- L'email technique du développeur
- La configuration interne

**L'utilisateur voit uniquement:**
- La marque "Math4Child"
- L'expérience éducative
- Les fonctionnalités premium
- Le support utilisateur professionnel

## ✅ Interface finale validée :

- ✅ Modal premium sans GOTEST
- ✅ Paiements sans références techniques  
- ✅ Support sans email développeur
- ✅ Marque "Math4Child" cohérente

**🎯 Résultat : Une application professionnelle avec une marque propre !**
