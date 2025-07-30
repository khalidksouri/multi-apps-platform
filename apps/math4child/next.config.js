/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration optimisée pour math4child
  reactStrictMode: true,
  swcMinify: true,
  
  // Support I18n
  i18n: {
    locales: ['en', 'fr', 'es', 'de', 'ar'],
    defaultLocale: 'en',
  },
  
  // Configuration des images
  images: {
    domains: ['localhost'],
    unoptimized: process.env.NODE_ENV === 'development'
  },
  
  // Variables d'environnement
  env: {
    CUSTOM_KEY: 'math4child',
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
        ],
      },
    ]
  },
}

module.exports = nextConfig
