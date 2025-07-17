import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

// Import des traductions
import fr from './locales/fr.json';
import en from './locales/en.json';
import es from './locales/es.json';
import de from './locales/de.json';
import it from './locales/it.json';
import pt from './locales/pt.json';
import ar from './locales/ar.json';
import zh from './locales/zh.json';
import ja from './locales/ja.json';
import ru from './locales/ru.json';

const resources = {
  fr: { translation: fr },
  en: { translation: en },
  es: { translation: es },
  de: { translation: de },
  it: { translation: it },
  pt: { translation: pt },
  ar: { translation: ar },
  zh: { translation: zh },
  ja: { translation: ja },
  ru: { translation: ru }
};

i18n
  .use(initReactI18next)
  .init({
    resources,
    lng: 'fr', // langue par défaut
    fallbackLng: 'en',
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;
