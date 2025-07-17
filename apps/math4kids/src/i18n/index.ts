// Système de traduction simplifié sans dépendances externes

interface Translations {
  [key: string]: {
    [key: string]: string | { [key: string]: string };
  };
}

const translations: Translations = {
  en: {
    appName: "Application",
    appDescription: "Description",
    calculate: "Calculate",
    clear: "Clear",
    history: "History",
    result: "Result",
    enterValidNumbers: "Please enter valid numbers",
    divisionByZero: "Division by zero is not possible",
    convert: "Convert",
    from: "From",
    to: "To",
    enterValue: "Enter value to convert",
    income: "Income",
    expenses: "Expenses",
    balance: "Balance",
    addTransaction: "Add Transaction",
    learn: "Learn",
    play: "Play",
    explore: "Explore",
    search: "Search",
    query: "Search query",
    results: "Results",
    operations: {
      add: "Add",
      subtract: "Subtract",
      multiply: "Multiply",
      divide: "Divide"
    },
    placeholders: {
      firstNumber: "First number",
      secondNumber: "Second number"
    },
    categories: {
      length: "Length",
      weight: "Weight",
      temperature: "Temperature"
    }
  },
  fr: {
    appName: "Application",
    appDescription: "Description",
    calculate: "Calculer",
    clear: "Effacer",
    history: "Historique",
    result: "Résultat",
    enterValidNumbers: "Veuillez entrer des nombres valides",
    divisionByZero: "Division par zéro impossible",
    convert: "Convertir",
    from: "De",
    to: "Vers",
    enterValue: "Entrez la valeur à convertir",
    income: "Revenus",
    expenses: "Dépenses",
    balance: "Solde",
    addTransaction: "Ajouter Transaction",
    learn: "Apprendre",
    play: "Jouer",
    explore: "Explorer",
    search: "Rechercher",
    query: "Requête de recherche",
    results: "Résultats",
    operations: {
      add: "Addition",
      subtract: "Soustraction",
      multiply: "Multiplication",
      divide: "Division"
    },
    placeholders: {
      firstNumber: "Premier nombre",
      secondNumber: "Second nombre"
    },
    categories: {
      length: "Longueur",
      weight: "Poids",
      temperature: "Température"
    }
  }
};

let currentLanguage = 'en';

export const t = (key: string): string => {
  const keys = key.split('.');
  let value: any = translations[currentLanguage];
  
  for (const k of keys) {
    value = value?.[k];
  }
  
  return value || key;
};

export const useTranslation = () => {
  return { t };
};

export const changeLanguage = (lng: string) => {
  if (translations[lng]) {
    currentLanguage = lng;
    localStorage.setItem('language', lng);
  }
};

// Initialiser la langue depuis localStorage
const savedLanguage = localStorage.getItem('language');
if (savedLanguage && translations[savedLanguage]) {
  currentLanguage = savedLanguage;
}
