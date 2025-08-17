// Utilitaire simple pour Math4Child
export type ClassValue = string | number | boolean | undefined | null;

export function cn(...inputs: ClassValue[]): string {
  return inputs
    .filter(Boolean)
    .join(' ')
    .trim();
}

// Fonction clsx simple pour remplacer la dépendance manquante
export function clsx(...inputs: ClassValue[]): string {
  return cn(...inputs);
}
