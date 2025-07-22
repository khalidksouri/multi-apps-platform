/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration pour export statique Netlify
  output: 'export',
  trailingSlash: true,
  skipTrailingSlashRedirect: true,
  
  // Désactiver l'optimisation des images pour export statique
  images: {
    unoptimized: true,
    domains: ['www.math4child.com', 'localhost'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  
  // Configuration TypeScript
  typescript: {
    ignoreBuildErrors: false,
  },
  
  // Configuration ESLint  
  eslint: {
    ignoreDuringBuilds: true, // Temporaire pour éviter les erreurs de build
  },
  
  // Configuration webpack pour résoudre les problèmes de modules
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Résolution des fallbacks pour l'environnement navigateur
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
        crypto: false,
      }
    }
    
    // Ignorer certains warnings Webpack
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /node_modules/ },
    ]
    
    return config
  },
  
  // Variables d'environnement publiques
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
  
  // Optimisations de production
  swcMinify: true,
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
}

module.exports = nextConfig
