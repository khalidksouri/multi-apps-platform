/** @type {import('next').NextConfig} */
const nextConfig = {
  // Mode strict React 18
  reactStrictMode: true,
  
  // Support experimental
  experimental: {
    // Disable strict mode for faster builds during development
    typedRoutes: false,
  },
  
  // Configuration TypeScript
  typescript: {
    // Ignore type errors during build (temporary)
    ignoreBuildErrors: false,
  },
  
  // Configuration ESLint
  eslint: {
    // Ignore ESLint errors during build
    ignoreDuringBuilds: false,
  },
  
  // Configuration pour les images
  images: {
    domains: ['localhost'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '**',
      },
    ],
  },
  
  // Variables d'environnement publiques
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
  
  // Configuration webpack personnalisée
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Ignore certains warnings
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /node_modules/ },
    ]
    
    return config
  },
}

module.exports = nextConfig
