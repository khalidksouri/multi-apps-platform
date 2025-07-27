/** @type {import('tailwindcss').Config} */
module.exports = {
  // Config VIDE - on utilise pas TailwindCSS mais Next.js l'exige !
  content: [
    // Aucun fichier - on ne veut PAS que TailwindCSS process nos fichiers
  ],
  theme: {
    extend: {},
  },
  plugins: [],
  // Désactiver tous les styles de base de Tailwind
  corePlugins: {
    preflight: false, // Pas de reset CSS
  }
}
