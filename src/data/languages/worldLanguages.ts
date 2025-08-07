import { languages, Language } from '../languages'

export const WORLD_LANGUAGES = languages

export function getAllRegions() {
  return [
    { id: 'europe', name: 'Europe', languages: languages.filter(l => ['fr', 'en', 'es', 'de', 'it', 'pt', 'ru'].includes(l.code)) },
    { id: 'asia', name: 'Asie', languages: languages.filter(l => ['zh', 'ja', 'ko', 'hi', 'ar'].includes(l.code)) }
  ]
}

export { languages as default }
