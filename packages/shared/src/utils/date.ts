import { format, parseISO, isValid, differenceInDays, addDays, startOfDay, endOfDay } from 'date-fns';
import { fr, enUS, es, de } from 'date-fns/locale';

// =============================================
// CONFIGURATION DES LOCALES
// =============================================

const locales = {
  'fr-FR': fr,
  'en-US': enUS,
  'es-ES': es,
  'de-DE': de
};

// =============================================
// FORMATAGE DES DATES
// =============================================

export function formatDate(
  date: Date | string,
  formatStr: string = 'dd/MM/yyyy',
  locale: string = 'fr-FR'
): string {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  
  if (!isValid(dateObj)) {
    return 'Date invalide';
  }
  
  return format(dateObj, formatStr, {
    locale: locales[locale as keyof typeof locales] || fr
  });
}

export function formatDateTime(
  date: Date | string,
  locale: string = 'fr-FR'
): string {
  return formatDate(date, 'dd/MM/yyyy HH:mm', locale);
}

export function formatRelativeTime(
  date: Date | string,
  locale: string = 'fr-FR'
): string {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  const now = new Date();
  const diffDays = differenceInDays(now, dateObj);
  
  if (diffDays === 0) return 'Aujourd\'hui';
  if (diffDays === 1) return 'Hier';
  if (diffDays === -1) return 'Demain';
  if (diffDays > 0) return `Il y a ${diffDays} jour${diffDays > 1 ? 's' : ''}`;
  return `Dans ${Math.abs(diffDays)} jour${Math.abs(diffDays) > 1 ? 's' : ''}`;
}

// =============================================
// MANIPULATION DES DATES
// =============================================

export function addBusinessDays(date: Date | string, days: number): Date {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  let result = new Date(dateObj);
  
  let addedDays = 0;
  while (addedDays < days) {
    result = addDays(result, 1);
    if (result.getDay() !== 0 && result.getDay() !== 6) { // Pas weekend
      addedDays++;
    }
  }
  
  return result;
}

export function getDateRange(
  startDate: Date | string,
  endDate: Date | string
): Date[] {
  const start = typeof startDate === 'string' ? parseISO(startDate) : startDate;
  const end = typeof endDate === 'string' ? parseISO(endDate) : endDate;
  
  const dates: Date[] = [];
  let currentDate = new Date(start);
  
  while (currentDate <= end) {
    dates.push(new Date(currentDate));
    currentDate = addDays(currentDate, 1);
  }
  
  return dates;
}

export function isBusinessDay(date: Date | string): boolean {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  const dayOfWeek = dateObj.getDay();
  return dayOfWeek !== 0 && dayOfWeek !== 6; // Lundi à Vendredi
}

// =============================================
// VALIDATION DES DATES
// =============================================

export function isValidDate(date: any): boolean {
  if (date instanceof Date) {
    return isValid(date);
  }
  
  if (typeof date === 'string') {
    return isValid(parseISO(date));
  }
  
  return false;
}

export function isDateInRange(
  date: Date | string,
  startDate: Date | string,
  endDate: Date | string
): boolean {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  const start = typeof startDate === 'string' ? parseISO(startDate) : startDate;
  const end = typeof endDate === 'string' ? parseISO(endDate) : endDate;
  
  return dateObj >= start && dateObj <= end;
}

// =============================================
// UTILITAIRES TEMPORELS
// =============================================

export function getTimeZoneOffset(timeZone: string = 'Europe/Paris'): number {
  const date = new Date();
  const utc = date.getTime() + (date.getTimezoneOffset() * 60000);
  const targetTime = new Date(utc + getTimezoneOffsetMs(timeZone));
  return targetTime.getTimezoneOffset();
}

function getTimezoneOffsetMs(timeZone: string): number {
  // Simplification - en production, utilisez une librairie comme moment-timezone
  const offsets: Record<string, number> = {
    'Europe/Paris': 1 * 60 * 60 * 1000, // UTC+1
    'America/New_York': -5 * 60 * 60 * 1000, // UTC-5
    'Asia/Tokyo': 9 * 60 * 60 * 1000 // UTC+9
  };
  
  return offsets[timeZone] || 0;
}

export function convertToTimeZone(
  date: Date | string,
  timeZone: string = 'Europe/Paris'
): Date {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  
  // Utilisation d'Intl.DateTimeFormat pour la conversion
  const formatter = new Intl.DateTimeFormat('fr-FR', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });
  
  const parts = formatter.formatToParts(dateObj);
  const partObj: Record<string, string> = {};
  parts.forEach(part => {
    partObj[part.type] = part.value;
  });
  
  return new Date(
    parseInt(partObj.year),
    parseInt(partObj.month) - 1,
    parseInt(partObj.day),
    parseInt(partObj.hour),
    parseInt(partObj.minute),
    parseInt(partObj.second)
  );
}

// =============================================
// HELPERS SPÉCIALISÉS
// =============================================

export function getDaysBetween(
  startDate: Date | string,
  endDate: Date | string
): number {
  const start = typeof startDate === 'string' ? parseISO(startDate) : startDate;
  const end = typeof endDate === 'string' ? parseISO(endDate) : endDate;
  
  return Math.abs(differenceInDays(end, start));
}

export function getStartOfPeriod(
  date: Date | string,
  period: 'day' | 'week' | 'month' | 'year'
): Date {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  
  switch (period) {
    case 'day':
      return startOfDay(dateObj);
    case 'week':
      const startOfWeek = new Date(dateObj);
      startOfWeek.setDate(dateObj.getDate() - dateObj.getDay() + 1); // Lundi
      return startOfDay(startOfWeek);
    case 'month':
      return new Date(dateObj.getFullYear(), dateObj.getMonth(), 1);
    case 'year':
      return new Date(dateObj.getFullYear(), 0, 1);
    default:
      return startOfDay(dateObj);
  }
}

export function getEndOfPeriod(
  date: Date | string,
  period: 'day' | 'week' | 'month' | 'year'
): Date {
  const dateObj = typeof date === 'string' ? parseISO(date) : date;
  
  switch (period) {
    case 'day':
      return endOfDay(dateObj);
    case 'week':
      const endOfWeek = new Date(dateObj);
      endOfWeek.setDate(dateObj.getDate() - dateObj.getDay() + 7); // Dimanche
      return endOfDay(endOfWeek);
    case 'month':
      return new Date(dateObj.getFullYear(), dateObj.getMonth() + 1, 0, 23, 59, 59);
    case 'year':
      return new Date(dateObj.getFullYear(), 11, 31, 23, 59, 59);
    default:
      return endOfDay(dateObj);
  }
}

// =============================================
// CONSTANTES UTILES
// =============================================

export const DATE_FORMATS = {
  SHORT: 'dd/MM/yyyy',
  LONG: 'dd MMMM yyyy',
  TIME: 'HH:mm',
  DATETIME: 'dd/MM/yyyy HH:mm',
  ISO: 'yyyy-MM-dd',
  ISO_DATETIME: 'yyyy-MM-dd\'T\'HH:mm:ss'
} as const;

export const TIME_ZONES = {
  PARIS: 'Europe/Paris',
  LONDON: 'Europe/London',
  NEW_YORK: 'America/New_York',
  TOKYO: 'Asia/Tokyo',
  UTC: 'UTC'
} as const;