/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration pour Netlify
  trailingSlash: true,
  images: {
    unoptimized: true,
    domains: []
  },
  
  // Optimisations
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  
  // Export statique pour Netlify
  output: 'export',
  distDir: '.next',
  
  // Configuration pour éviter les erreurs hydration
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production'
  },
  
  // Variables d'environnement publiques
  env: {
    NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL || 'https://math4child.com',
    NEXT_PUBLIC_APP_NAME: 'Math4Child'
  }
}

module.exports = nextConfig
