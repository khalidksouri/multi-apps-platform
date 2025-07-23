/** @type {import('next').NextConfig} */
const nextConfig = {
  // Export statique pour Netlify
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  
  // Images non optimisées pour export statique
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
  
  // FORCER L'IGNORANCE DE POSTCSS
  experimental: {
    // Désactiver PostCSS complètement
    css: false,
  },
  
  // Configuration webpack pour bypasser PostCSS
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Supprimer tous les loaders CSS qui utilisent PostCSS
    config.module.rules.forEach((rule) => {
      if (rule.test && rule.test.toString().includes('css')) {
        // Remplacer par un simple css-loader sans PostCSS
        rule.use = [
          'style-loader',
          'css-loader'
        ]
      }
    })
    
    // Ignorer les warnings et les tentatives de résolution PostCSS
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /backup/ },
      /Critical dependency/,
      /postcss/,
      /tailwindcss/,
    ]
    
    // Empêcher la résolution de TailwindCSS
    config.resolve.alias = {
      ...config.resolve.alias,
      'tailwindcss': false,
      'autoprefixer': false,
      'postcss': false,
    }
    
    return config
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_BUILD_TIME: new Date().toISOString(),
    NEXT_PUBLIC_BUILD_VERSION: '2.0.0',
  },
}

module.exports = nextConfig
