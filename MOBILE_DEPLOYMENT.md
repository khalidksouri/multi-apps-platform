# 📱 Guide de Déploiement Mobile Math4Child (Capacitor)

## 🏗️ Architecture
**Next.js (Web) → Export Statique → Capacitor → Apps Natives**

## 🚀 Déploiement rapide

### 🌐 Web
```bash
npm run build:web
```

### 🤖 Android (première fois)
```bash
npm run cap:add:android
npm run deploy:android
```

### 🍎 iOS (première fois - macOS requis)
```bash
npm run cap:add:ios
npm run deploy:ios
```

### 🔄 Mises à jour
```bash
npm run deploy:android  # Met à jour et ouvre Android Studio
npm run deploy:ios      # Met à jour et ouvre Xcode
```

## 🛠️ Développement en temps réel
```bash
npm run dev:android     # Live reload sur émulateur Android
npm run dev:ios         # Live reload sur simulateur iOS
```

## 📱 Configuration GOTEST
- **App ID** : com.gotest.math4child
- **Nom** : Math4Child
- **SIRET** : 53958712100028
- **Contact** : khalid_ksouri@yahoo.fr

## 📋 Prérequis
- **Android** : Android Studio + SDK
- **iOS** : Xcode (macOS uniquement)
- **Node.js** : v18+

## 🔧 Résolution des problèmes

### Erreur de build
```bash
rm -rf out .next
npm run export:web
```

### Erreur Capacitor
```bash
npm run cap:sync
```

### Permissions Android
Ajoutez dans `android/app/src/main/AndroidManifest.xml` :
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

## 📱 Publication

### Google Play Store
1. `npm run deploy:android`
2. Build → Generate Signed Bundle/APK
3. Upload sur Google Play Console

### Apple App Store  
1. `npm run deploy:ios`
2. Product → Archive dans Xcode
3. Upload vers App Store Connect

## 💰 Monétisation
Stripe fonctionne sur toutes les plateformes avec la même configuration GOTEST.
