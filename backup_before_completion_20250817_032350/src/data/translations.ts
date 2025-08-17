// =============================================================================
// 🌍 TRADUCTIONS MATH4CHILD v4.2.0
// =============================================================================

export interface TranslationData {
  title: string;
  subtitle: string;
  description: string;
  features: string[]; // Array de strings
  cta: string;
  [key: string]: string | string[];
}

export interface Translations {
  [languageCode: string]: TranslationData;
}

export const translations: Translations = {
  'fr-FR': {
    title: 'Math4Child v4.2.0',
    subtitle: 'Révolution Éducative Mondiale',
    description: '6 innovations révolutionnaires jamais vues dans l\'éducation mathématique mondiale.',
    features: [
      '🧠 IA Adaptative Avancée - PREMIÈRE MONDIALE',
      '✍️ Reconnaissance Manuscrite',
      '🥽 Réalité Augmentée 3D',
      '🎙️ Assistant Vocal IA',
      '🧮 Moteur d\'Exercices Révolutionnaire',
      '🌍 Système Langues Universel'
    ],
    cta: 'Découvrir les Innovations'
  },
  'en-US': {
    title: 'Math4Child v4.2.0',
    subtitle: 'Global Educational Revolution',
    description: '6 revolutionary innovations never seen in global mathematics education.',
    features: [
      '🧠 Advanced Adaptive AI - WORLD FIRST',
      '✍️ Handwriting Recognition',
      '🥽 3D Augmented Reality',
      '🎙️ AI Voice Assistant',
      '🧮 Revolutionary Exercise Engine',
      '🌍 Universal Language System'
    ],
    cta: 'Discover Innovations'
  },
  'es-ES': {
    title: 'Math4Child v4.2.0',
    subtitle: 'Revolución Educativa Mundial',
    description: '6 innovaciones revolucionarias nunca vistas en la educación matemática mundial.',
    features: [
      '🧠 IA Adaptativa Avanzada - PRIMERA MUNDIAL',
      '✍️ Reconocimiento de Escritura',
      '🥽 Realidad Aumentada 3D',
      '🎙️ Asistente de Voz IA',
      '🧮 Motor de Ejercicios Revolucionario',
      '🌍 Sistema de Idiomas Universal'
    ],
    cta: 'Descubrir Innovaciones'
  },
  'de-DE': {
    title: 'Math4Child v4.2.0',
    subtitle: 'Globale Bildungsrevolution',
    description: '6 revolutionäre Innovationen, die noch nie in der globalen Mathematikausbildung gesehen wurden.',
    features: [
      '🧠 Fortgeschrittene Adaptive KI - WELTWEIT ERSTE',
      '✍️ Handschrifterkennung',
      '🥽 3D Erweiterte Realität',
      '🎙️ KI Sprachassistent',
      '🧮 Revolutionäre Übungsmaschine',
      '🌍 Universelles Sprachsystem'
    ],
    cta: 'Innovationen Entdecken'
  }
};

export default translations;
