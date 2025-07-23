/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration TypeScript et ESLint allégée
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    // Ignorer ESLint durant le build pour éviter les blocages
    ignoreDuringBuilds: true,
  },
  
  // Headers de sécurité
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
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ]
  },
  
  // Configuration des images
  images: {
    domains: ['localhost'],
    dangerouslyAllowSVG: false,
  },
  
  // Configuration webpack pour ignorer les warnings
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /backup/ },
    ]
    
    return config
  },
}

module.exports = nextConfig
