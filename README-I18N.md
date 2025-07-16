# 🌍 Système d'Internationalisation Universel

## 📋 Vue d'ensemble

Ce système d'internationalisation a été automatiquement configuré pour vos 5 applications Next.js indépendantes :

- **PostMath Pro** (port 3001) - Calculateur d'expédition
- **UnitFlip Pro** (port 3002) - Convertisseur d'unités  
- **BudgetCron** (port 3003) - Gestion budgétaire avec IA
- **AI4Kids** (port 3004) - Plateforme d'apprentissage IA
- **MultiAI** (port 3005) - Hub IA avec authentification

## ✨ Fonctionnalités

### 🌐 Support multilingue complet
- **30+ langues** de tous les continents
- **Détection automatique** de la langue du navigateur
- **Persistance garantie** - La langue reste active lors de la navigation
- **Synchronisation inter-onglets** - Changement global sur tous les onglets

### 🔄 Langues supportées
- **Europe**: Anglais, Français, Espagnol, Allemand, Italien, Portugais, Russe, Néerlandais, Polonais, Tchèque, Hongrois, etc.
- **Asie**: Chinois, Japonais, Coréen, Hindi, Thaï, Vietnamien, Indonésien, Bengali, Turc, etc.
- **Moyen-Orient/Afrique**: Arabe, Hébreu, Persan, Swahili, Amharique, Hausa, Yoruba, Igbo, Zulu, etc.
- **Amériques**: Portugais brésilien, Espagnol mexicain, Français canadien, Quechua, etc.
- **Océanie**: Maori, Hawaiien, Samoan, Tongan, etc.

### 📱 Support RTL/LTR
- **RTL automatique** pour l'arabe, l'hébreu, le persan, l'ourdou
- **Interface adaptée** selon la direction de lecture
- **Positionnement intelligent** des éléments UI

## 🚀 Démarrage rapide

### 1. Installation des dépendances
```bash
./install-all-dependencies.sh
```

### 2. Démarrage de toutes les applications
```bash
./start-all-apps.sh
```

### 3. Accès aux applications
- PostMath Pro: http://localhost:3001
- UnitFlip Pro: http://localhost:3002
- BudgetCron: http://localhost:3003
- AI4Kids: http://localhost:3004
- MultiAI: http://localhost:3005

## 📁 Structure du projet

```
apps/
├── postmath/
│   ├── src/
│   │   ├── hooks/useUniversalI18n.ts      # Hook I18n universel
│   │   ├── components/I18nLayout.tsx      # Layout avec I18n
│   │   ├── translations/index.ts          # Traductions spécifiques
│   │   └── app/
│   │       ├── layout.tsx                 # Layout principal
│   │       ├── page.tsx                   # Page d'accueil
│   │       └── globals.css                # Styles globaux
│   ├── package.json
│   ├── tsconfig.json
│   ├── next.config.js
│   └── tailwind.config.js
├── unitflip/
│   └── [même structure]
├── budgetcron/
│   └── [même structure]
├── ai4kids/
│   └── [même structure]
└── multiai/
    └── [même structure]
```

## 🛠️ Utilisation

### Dans vos composants
```typescript
import { useTranslation } from '@/hooks/useUniversalI18n';
import { translations } from '@/translations';

export default function MyComponent() {
  const { t, currentLanguage } = useTranslation(translations);
  
  return (
    <div>
      <h1>{t('appName')}</h1>
      <p>{t('appDescription')}</p>
      <span>{currentLanguage.flag} {currentLanguage.nativeName}</span>
    </div>
  );
}
```

### Sélecteur de langue
```typescript
import { LanguageSelector } from '@/hooks/useUniversalI18n';

export default function Header() {
  return (
    <header>
      <LanguageSelector 
        className="my-custom-class"
        onChange={(language) => {
          console.log('Langue changée:', language.nativeName);
        }}
      />
    </header>
  );
}
```

## 🔧 Configuration

### Ajouter une nouvelle traduction
1. Ouvrez `apps/[app]/src/translations/index.ts`
2. Ajoutez votre clé dans chaque langue :
```typescript
export const translations = {
  en: {
    myNewKey: "My new text in English"
  },
  fr: {
    myNewKey: "Mon nouveau texte en français"
  },
  // ... autres langues
};
```

### Ajouter une nouvelle langue
1. Modifiez `SUPPORTED_LANGUAGES` dans `useUniversalI18n.ts`
2. Ajoutez les traductions dans `translations/index.ts`

## 🧪 Tests avec Playwright

```typescript
// Dans vos tests Playwright
test('Test changement de langue', async ({ page }) => {
  await page.goto('http://localhost:3001');
  
  // Changer la langue
  await page.evaluate(() => {
    localStorage.setItem('universal_app_language', 'fr');
  });
  
  await page.reload();
  
  // Vérifier que la langue a changé
  await expect(page.locator('h1')).toContainText('PostMath Pro');
});
```

## 📊 Fonctionnalités avancées

### Persistance automatique
- La langue est sauvegardée dans `localStorage`
- Restauration automatique au rechargement
- Synchronisation entre tous les onglets

### Détection intelligente
- Détection de la langue du navigateur
- Fallback vers l'anglais si langue non supportée
- Respect des préférences utilisateur

### Performance
- Chargement lazy des traductions
- Cache en mémoire
- Optimisations pour les gros volumes

## 🔧 Maintenance

### Ajouter une nouvelle application
1. Créez le dossier `apps/nouvelle-app`
2. Copiez la structure depuis une app existante
3. Modifiez les traductions spécifiques
4. Ajoutez le port dans `start-all-apps.sh`

### Mettre à jour les traductions
- Utilisez `npm run i18n:extract` pour extraire les clés
- Utilisez `npm run i18n:validate` pour valider

## 🐛 Dépannage

### Problème: La langue ne persiste pas
**Solution**: Vérifiez que localStorage est accessible et que les événements sont bien écoutés.

### Problème: RTL ne fonctionne pas
**Solution**: Vérifiez que les styles CSS RTL sont bien appliqués dans globals.css.

### Problème: Traductions manquantes
**Solution**: Ajoutez les clés manquantes dans le fichier translations/index.ts.

## 📞 Support

Pour toute question ou problème :
1. Vérifiez ce README
2. Consultez les logs dans la console
3. Testez avec une langue différente

---

**Version**: 1.0.0  
**Créé par**: Script d'installation automatique  
**Date**: $(date)
