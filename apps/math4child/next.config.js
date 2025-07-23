/** @type {import('next').NextConfig} */
const path = require('path')

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
      '@': path.resolve(__dirname, 'src'),
    }
    
    // Configuration CSS améliorée
    config.module.rules.forEach((rule) => {
      if (rule.test && rule.test.toString().includes('css')) {
        rule.sideEffects = false
      }
    })
    
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ }, 
      { file: /backup/ },
      /Critical dependency/,
      /Module not found.*\.css$/,
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
            styles: {
              name: 'styles',
              test: /\.css$/,
              chunks: 'all',
              enforce: true,
            },
          },
        },
      }
    }
    
    return config
  },
  
  // Configuration expérimentale pour CSS
  experimental: {
    optimizeCss: false,
  },
}

module.exports = nextConfig
