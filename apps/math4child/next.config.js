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
  
  // Configuration webpack optimisée SANS TailwindCSS
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Resolver pour les paths @/*
    config.resolve.alias = {
      ...config.resolve.alias,
      '@': path.resolve(__dirname, 'src'),
    }
    
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ }, 
      { file: /backup/ },
      /Critical dependency/,
    ]
    
    return config
  },
}

module.exports = nextConfig
