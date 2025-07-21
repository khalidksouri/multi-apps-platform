/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration optimisée pour Netlify
  trailingSlash: true,
  
  // Désactiver l'optimisation d'images pour Netlify
  images: {
    unoptimized: true
  },
  
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  
  // Pas d'export statique - laisser Netlify gérer
  // output: 'export' ← SUPPRIMÉ (causait le 404)
}

module.exports = nextConfig
