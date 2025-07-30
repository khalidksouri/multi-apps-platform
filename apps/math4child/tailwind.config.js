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
        'math-blue': '#3B82F6',
        'math-purple': '#8B5CF6',
        'math-green': '#10B981',
      },
      fontFamily: {
        'math': ['Comic Neue', 'cursive'],
      },
    },
  },
  plugins: [],
}
