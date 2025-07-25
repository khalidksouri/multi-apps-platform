// Export principal des fonctions i18n - FIX: éviter les conflits d'export
export * from './languages';
export { 
  detectUserLanguage, 
  detectBrowserLanguage,
  formatDate, 
  getTextDirection, 
  getCurrencySymbol 
} from './utils';
