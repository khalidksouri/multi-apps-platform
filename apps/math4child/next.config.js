/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration ultra basique
  reactStrictMode: true,
  poweredByHeader: false,
  
  // Images basiques
  images: {
    domains: ['localhost'],
    dangerouslyAllowSVG: false,
  },
  
  // TypeScript minimal
  typescript: {
    ignoreBuildErrors: false,
  },
  
  // PAS d'ESLint
  eslint: {
    ignoreDuringBuilds: true,
  },
  
  // Configuration webpack qui FORCE l'ignorance de PostCSS
  webpack: (config, { dev, isServer }) => {
    // Ignorer tous les warnings CSS
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /backup/ },
      /tailwind/,
      /postcss/,
      /autoprefixer/,
    ]
    
    // Modifier la config CSS pour éviter PostCSS
    config.module.rules.forEach((rule) => {
      if (rule.test && rule.test.toString().includes('css')) {
        if (rule.oneOf) {
          rule.oneOf.forEach((oneOfRule) => {
            if (oneOfRule.use && Array.isArray(oneOfRule.use)) {
              oneOfRule.use = oneOfRule.use.filter((use) => {
                if (typeof use === 'object' && use.loader) {
                  // Garder seulement css-loader, pas postcss-loader
                  return !use.loader.includes('postcss-loader')
                }
                return true
              })
            }
          })
        }
      }
    })
    
    return config
  },
  
  // Headers de sécurité simples
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options', 
            value: 'nosniff',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
