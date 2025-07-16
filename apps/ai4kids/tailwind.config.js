/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'ai4kids': {
          blue: '#4ECDC4',
          orange: '#FF8C42',
          pink: '#FF6B9D',
          green: '#95E1D3',
          yellow: '#FFD93D',
          purple: '#667eea',
        },
      },
      fontFamily: {
        'comic': ['Comic Neue', 'Comic Sans MS', 'cursive'],
        'sans': ['Comic Neue', 'system-ui', 'sans-serif'],
      },
      animation: {
        'float': 'float 3s ease-in-out infinite',
      },
      keyframes: {
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
      },
    },
  },
  plugins: [],
}
