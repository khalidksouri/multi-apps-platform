# 🚀 AI4KIDS - Guide de développement

## 📱 Application hybride Next.js + Capacitor

### 🎯 Fonctionnalités
- **Logo AI4KIDS** avec 4 personnages colorés animés
- **Interface responsive** adaptée à tous les écrans
- **Support hybride** : Web, Android, iOS
- **Feedback haptique** sur mobile
- **Animations fluides** et interactions

### 🛠️ Commandes de développement

#### Web
```bash
npm run dev        # Serveur de développement
npm run build      # Build de production
npm run start      # Serveur de production
```

#### Mobile
```bash
npm run android    # Ouvrir sur Android
npm run ios        # Ouvrir sur iOS
npx cap sync       # Synchroniser avec Capacitor
```

#### Scripts personnalisés
```bash
./scripts/dev.sh     # Lancement rapide
./scripts/build.sh   # Build rapide
./scripts/mobile.sh  # Préparation mobile
```

### 🎨 Structure du projet
```
src/
├── app/
│   ├── globals.css     # Styles globaux
│   ├── layout.tsx      # Layout principal
│   └── page.tsx        # Page d'accueil
├── components/
│   ├── AI4KidsLogo.tsx # Logo principal
│   └── ui/
│       ├── Button.tsx  # Boutons avec haptique
│       └── Card.tsx    # Cartes de contenu
├── hooks/
│   └── useCapacitor.ts # Hook Capacitor
└── middleware.ts       # Middleware Next.js
```

### 🎮 Fonctionnalités spéciales
- **Détection automatique** de la plateforme
- **Feedback haptique** sur les boutons mobiles
- **Splash screen** personnalisé
- **StatusBar** avec couleurs AI4KIDS
- **PWA ready** pour installation

### 🌐 URLs
- **Développement** : http://localhost:3004
- **Production** : Selon votre déploiement

### 📱 Test sur mobile
1. Connectez votre appareil
2. Lancez `npm run android` ou `npm run ios`
3. L'application s'ouvrira dans l'émulateur/appareil

### 🎨 Personnalisation
- **Couleurs** : Voir `tailwind.config.js`
- **Animations** : Voir `globals.css`
- **Logo** : Modifier `AI4KidsLogo.tsx`

### 🔧 Dépannage
- **Build fail** : Vérifiez TypeScript avec `npm run lint`
- **Mobile issues** : Lancez `npx cap sync`
- **Styles** : Vérifiez Tailwind CSS
