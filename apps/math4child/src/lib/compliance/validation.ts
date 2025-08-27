// Validation conformité MATH4CHILD - Spécifications exactes
export const COMPLIANCE_VALIDATION = {
  
  // Éléments OBLIGATOIRES selon spécifications
  required_elements: [
    'www.math4child.com', // Domaine acheté
    'support@math4child.com', // Contact autorisé
    'commercial@math4child.com', // Contact autorisé
    'LE PLUS CHOISI', // Badge Premium requis
    '5 niveaux de progression', // Spécification exacte
    '100 bonnes réponses minimum', // Validation niveau
    '5 opérations mathématiques' // Spécification exacte
  ],
  
  // Éléments STRICTEMENT INTERDITS selon spécifications  
  forbidden_elements: [
    'GOTEST',
    '53958712100028', 
    'gotesttech@gmail.com',
    'Spécifications primordiales',
    'Tarification compétitive selon spécifications'
  ],
  
  // Configuration plans selon spécifications exactes
  subscription_validation: {
    basic_profiles: 1,
    standard_profiles: 2, 
    premium_profiles: 3,
    premium_badge: 'LE PLUS CHOISI',
    famille_profiles: 5,
    ultimate_profiles_min: 10, // Minimum 10, pas de maximum
    ultimate_devis: true // Devis personnalisé requis
  },
  
  // Configuration langues selon spécifications
  language_validation: {
    arabic_africa_flag: '🇲🇦', // Maroc
    arabic_middle_east_flag: '🇵🇸', // Palestine
    hebrew_excluded: true, // Interdit
    full_translation: true, // Tout traduit à chaque changement
    dropdown_scroll: true, // Barre défilement
    no_duplication: true // Pas de duplication langues
  },
  
  // Validation progression selon spécifications
  progression_validation: {
    levels: 5, // 5 niveaux exactement
    min_correct_answers: 100, // 100 minimum pour débloquer
    keep_access_previous: true, // Garder accès niveaux validés
    operations: ['addition', 'soustraction', 'division', 'multiplication', 'mixte']
  }
};

// Fonction validation conformité
export const validateCompliance = (): { valid: boolean; errors: string[] } => {
  const errors: string[] = [];
  
  // Vérifications automatiques
  // Ici implémenter les vérifications selon COMPLIANCE_VALIDATION
  
  return {
    valid: errors.length === 0,
    errors
  };
};

export default COMPLIANCE_VALIDATION;
