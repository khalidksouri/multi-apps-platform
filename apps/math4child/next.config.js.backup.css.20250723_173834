/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration pour export statique (Netlify)
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  
  // Configuration des images pour export statique
  images: {
    unoptimized: true,
    domains: ['localhost'],
    dangerouslyAllowSVG: false,
  },
  
  // Configuration TypeScript et ESLint
  reactStrictMode: true,
  typescript: { 
    ignoreBuildErrors: false 
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  // Configuration webpack optimisée
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Resolver pour les paths @/*
    config.resolve.alias = {
      ...config.resolve.alias,
      '@': require('path').resolve(__dirname, 'src'),
    }
    
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ }, 
      { file: /backup/ },
      /Critical dependency/,
    ]
    
    // Optimisations pour la production
    if (!dev && !isServer) {
      config.optimization = {
        ...config.optimization,
        splitChunks: {
          chunks: 'all',
          cacheGroups: {
            vendor: {
              test: /[\\/]node_modules[\\/]/,
              name: 'vendors',
              chunks: 'all',
            },
          },
        },
      }
    }
    
    return config
  },
  
  // Variables d'environnement publiques
  env: {
    NEXT_PUBLIC_BUILD_TIME: new Date().toISOString(),
    NEXT_PUBLIC_BUILD_VERSION: '2.0.0',
  },
}

module.exports = nextConfig
