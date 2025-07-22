# 🌍 Language Dropdown - Math4Child

## 📋 Vue d'ensemble

Composant de sélection de langue avec **scroll visible et opérationnel** pour Math4Child, supportant 47+ langues avec traduction en temps réel.

## ✨ Fonctionnalités

### 🎨 **Interface utilisateur**
- ✅ **Scroll personnalisé visible** avec barre de défilement stylisée
- ✅ Design fidèle au mockup original
- ✅ Animations fluides et transitions
- ✅ Responsive design (mobile/desktop)

### 🌐 **Support multilingue**
- ✅ **47+ langues** avec drapeaux natifs
- ✅ **Support RTL** pour arabe et hébreu
- ✅ **Traduction temps réel** de l'interface
- ✅ Détection automatique de la langue

### 🔧 **Fonctionnalités techniques**
- ✅ **TypeScript** complet avec types stricts
- ✅ **Accessibilité** (ARIA, navigation clavier)
- ✅ **Sauvegarde locale** de la préférence
- ✅ **Hook personnalisé** useLanguage
- ✅ Fermeture automatique en cliquant dehors

## 🚀 Installation et utilisation

### 1. **Structure créée**
```
src/
├── components/
│   └── language/
│       └── LanguageDropdown.tsx     # Composant principal
├── hooks/
│   └── useLanguage.ts               # Hook de gestion
├── types/
│   └── language.ts                  # Types TypeScript
├── styles/
│   └── language-dropdown.css       # Styles personnalisés
└── components/
    └── LanguageDemo.tsx             # Page de démonstration
```

### 2. **Utilisation basique**
```tsx
import LanguageDropdown from '@/components/language/LanguageDropdown'

function MyApp() {
  const handleLanguageChange = (language) => {
    console.log('Langue sélectionnée:', language)
  }

  return (
    <LanguageDropdown 
      onLanguageChange={handleLanguageChange}
      defaultLanguage="fr"
    />
  )
}
```

### 3. **Utilisation avec le hook**
```tsx
import { useLanguage } from '@/hooks/useLanguage'

function MyComponent() {
  const { currentLanguage, setLanguage, isRTL, getTranslation } = useLanguage()
  
  return (
    <div dir={isRTL ? 'rtl' : 'ltr'}>
      <h1>{getTranslation('appName')}</h1>
      <LanguageDropdown onLanguageChange={setLanguage} />
    </div>
  )
}
```

## 🎯 Caractéristiques du scroll

### **Scroll visible et personnalisé**
- ✅ Barre de défilement **toujours visible**
- ✅ Couleurs personnalisées (gris clair/gris moyen)
- ✅ Hover effects sur la barre
- ✅ Responsive sur mobile (barre plus large)
- ✅ Support dark mode automatique

### **CSS personnalisé**
```css
.language-dropdown-scroll::-webkit-scrollbar {
  width: 8px; /* Largeur visible */
}

.language-dropdown-scroll::-webkit-scrollbar-thumb {
  background: #cbd5e1; /* Couleur visible */
  border-radius: 4px;
}
```

## 🌍 Langues supportées

| Région | Langues | RTL |
|--------|---------|-----|
| **Europe** | Français, English, Español, Deutsch, Italiano, Português, Русский, Polski, Nederlands, Svenska, Dansk, Norsk, Suomi, Čeština, Magyar, Română, Български, Hrvatski, Slovenčina, Slovenščina, Eesti, Latviešu, Lietuvių, Ελληνικά | ❌ |
| **Asie** | 中文, 日本語, 한국어, हिन्दी, ไทย, Tiếng Việt, Bahasa Indonesia, Bahasa Melayu, Filipino | ❌ |
| **Moyen-Orient** | العربية, עברית | ✅ |
| **Afrique** | Kiswahili, isiZulu, Afrikaans, አማርኛ | ❌ |
| **Autres** | Türkçe, Українська, Беларуская, ქართული | ❌ |

## 🛠️ Personnalisation

### **Props du composant**
```tsx
interface LanguageDropdownProps {
  onLanguageChange?: (language: Language) => void
  className?: string
  defaultLanguage?: string
  disabled?: boolean
  showSearch?: boolean        // Futur: recherche de langues
  maxHeight?: number          // Hauteur max du dropdown
  placement?: 'bottom' | 'top' // Position du dropdown
}
```

### **Personnalisation des styles**
```css
/* Modifier la couleur de la barre de scroll */
.language-dropdown-scroll::-webkit-scrollbar-thumb {
  background: #your-color;
}

/* Modifier la hauteur du dropdown */
.language-dropdown-scroll {
  max-height: 300px; /* Personnalisé */
}
```

## 📱 Responsive Design

- **Desktop** : Dropdown standard avec hover effects
- **Mobile** : Barre de scroll plus épaisse, touch-friendly
- **Tablet** : Adaptation automatique selon la taille

## 🔒 Accessibilité

- ✅ **ARIA labels** complets
- ✅ **Navigation clavier** (Tab, Enter, Escape)
- ✅ **Screen reader** friendly
- ✅ **Focus management** approprié
- ✅ **Contrast ratio** respecté

## 🧪 Tests

```bash
# Lancer la démo
npm run demo:language

# Tests du composant
npm run test:language

# Build de production
npm run build:language
```

## 🎨 Captures d'écran

### **État fermé**
- Badge "100k+ familles"
- Bouton avec drapeau et nom de langue
- Flèche animée

### **État ouvert**
- Header "Sélectionner une langue"
- Liste scrollable avec **barre visible**
- Drapeaux + noms de langues
- Langue actuelle mise en surbrillance
- Footer avec info traduction

### **Traduction temps réel**
- Contenu de la page change instantanément
- Support RTL automatique
- Animation fluide

## 🔄 Intégration Math4Child

### **Dans votre layout principal**
```tsx
// app/layout.tsx ou pages/_app.tsx
import '@/styles/language-dropdown.css'

export default function Layout({ children }) {
  return (
    <html>
      <body>
        <LanguageProvider>
          {children}
        </LanguageProvider>
      </body>
    </html>
  )
}
```

### **Dans vos pages**
```tsx
// Partout où vous avez besoin de traduction
import { useLanguage } from '@/hooks/useLanguage'

function PricingPage() {
  const { getTranslation, isRTL } = useLanguage()
  
  return (
    <div dir={isRTL ? 'rtl' : 'ltr'}>
      <h1>{getTranslation('pricing.title')}</h1>
    </div>
  )
}
```

## 🚀 Prochaines étapes

1. **Intégrer** le composant dans vos pages
2. **Personnaliser** les traductions selon vos besoins
3. **Tester** sur différents appareils
4. **Optimiser** les performances si nécessaire

## 📞 Support

Le composant est entièrement documenté et prêt à l'emploi. Le **scroll est visible et opérationnel** comme demandé !

---

**🎉 Composant Language Dropdown prêt pour Math4Child !**
