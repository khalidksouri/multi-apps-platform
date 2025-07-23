/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  images: {
    unoptimized: true,
  },
  reactStrictMode: true,
  typescript: { 
    ignoreBuildErrors: false 
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  // DÉSACTIVATION COMPLÈTE du CSS processing
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Supprimer TOUS les loaders CSS de webpack
    config.module.rules = config.module.rules.map(rule => {
      if (rule.oneOf) {
        rule.oneOf = rule.oneOf.filter(oneOfRule => {
          // Éliminer les règles qui traitent les .css
          if (oneOfRule.test && oneOfRule.test.toString().includes('css')) {
            return false
          }
          return true
        })
      }
      return rule
    })
    
    // Ajouter une règle pour ignorer complètement les .css
    config.module.rules.push({
      test: /\.css$/,
      loader: 'ignore-loader'
    })
    
    return config
  },
  
  // Expérimental pour forcer l'absence de PostCSS
  experimental: {
    // Désactiver tout processing CSS
    cssChunking: false,
  }
}

module.exports = nextConfig
