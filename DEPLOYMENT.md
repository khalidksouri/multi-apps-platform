# 🚀 Guide de Déploiement Math4Child v4.2.0

## 📋 Prérequis
- Node.js 18+
- npm 8+
- TypeScript
- Playwright (pour les tests)

## 🛠️ Installation

```bash
# Cloner le projet
git clone https://github.com/math4child/math4child.git
cd math4child

# Installer les dépendances
npm install

# Configurer l'environnement
cp .env.local.example .env.local
# Éditer .env.local avec vos clés API
```

## 🧪 Tests

```bash
# Tests complets
npm run test

# Tests avec interface
npm run test:ui

# Tests de stress
npm run test:stress

# Tests API
npm run test:api
```

## 🚀 Déploiement

### Développement
```bash
npm run dev
# Ouvre http://localhost:3000
```

### Production
```bash
npm run build
npm start
```

### Docker
```bash
docker-compose up -d
```

## ⚠️ Conformité README.md

### ❌ INTERDICTIONS ABSOLUES
- NE JAMAIS afficher "GOTEST" dans l'application
- NE JAMAIS afficher "53958712100028" (SIRET)
- NE JAMAIS afficher "gotesttech@gmail.com"
- NE JAMAIS afficher les "Spécifications primordiales"
- NE JAMAIS afficher "Tarification compétitive selon spécifications README.md"

### ✅ OBLIGATOIRE
- Seule la marque "Math4Child" visible aux utilisateurs
- Contacts: support@math4child.com et commercial@math4child.com
- Plan PREMIUM marqué "LE PLUS CHOISI"
- 200+ langues supportées
- 5 niveaux de progression (100 réponses min)
- 5 opérations mathématiques
- 6 innovations révolutionnaires
- 5 plans d'abonnement

## 📱 Applications Mobiles

### Android
```bash
npm run build:capacitor
npm run android:build
```

### iOS
```bash
npm run build:capacitor
npm run ios:build
```

## 🔧 Configuration Production

### Variables d'environnement
```bash
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_APP_VERSION=4.2.0
NEXT_PUBLIC_DOMAIN=www.math4child.com
NEXT_PUBLIC_SUPPORT_EMAIL=support@math4child.com
NEXT_PUBLIC_COMMERCIAL_EMAIL=commercial@math4child.com
```

### Base de données
- PostgreSQL pour la production
- localStorage pour le développement

### Paiements
- Stripe configuré pour tous les pays
- Tarification localisée selon README.md

## 🌍 Internationalisation
- 200+ langues supportées
- Drapeaux spécifiques: 🇲🇦 (arabe Afrique), 🇵🇸 (arabe Moyen-Orient)
- Support RTL pour l'arabe
- Traduction en temps réel

## 📊 Monitoring
- Tests automatiques sur chaque commit
- Surveillance des performances
- Logs de sécurité

## 🆘 Support
- Documentation: README.md
- Support technique: support@math4child.com
- Commercial: commercial@math4child.com
