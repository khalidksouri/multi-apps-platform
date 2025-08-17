/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      // Animations personnalisées pour le dropdown
      keyframes: {
        'fade-in': {
          from: { opacity: '0' },
          to: { opacity: '1' },
        },
        'slide-in-from-top': {
          from: { transform: 'translateY(-8px)' },
          to: { transform: 'translateY(0)' },
        },
      },
      animation: {
        'fade-in': 'fade-in 200ms ease-out',
        'slide-in-from-top': 'slide-in-from-top 200ms ease-out',
      },
      // Z-index personnalisés
      zIndex: {
        '60': '60',
        '70': '70',
        '80': '80',
        '90': '90',
        '100': '100',
      },
      // Backdrop blur
      backdropBlur: {
        xs: '2px',
      },
      // Couleurs personnalisées Math4Child
      colors: {
        'math4child': {
          50: '#eff6ff',
          100: '#dbeafe',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        }
      }
    },
  },
  plugins: [
    // Plugin pour les scrollbars personnalisées
    function({ addUtilities }) {
      const newUtilities = {
        '.scrollbar-thin': {
          'scrollbar-width': 'thin',
        },
        '.scrollbar-thumb-gray-300::-webkit-scrollbar-thumb': {
          'background-color': '#d1d5db',
          'border-radius': '6px',
        },
        '.scrollbar-track-gray-100::-webkit-scrollbar-track': {
          'background-color': '#f3f4f6',
        },
        '.scrollbar-thin::-webkit-scrollbar': {
          width: '6px',
        },
      }
      addUtilities(newUtilities)
    }
  ],
}
