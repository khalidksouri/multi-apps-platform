/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  
  // Support RTL
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'ar', 'zh', 'ja', 'it', 'pt', 'fi'],
    defaultLocale: 'fr',
  },
  
  // Optimisations
  swcMinify: true,
  
  // Images
  images: {
    domains: ['localhost'],
    unoptimized: process.env.NODE_ENV === 'development'
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
  
  // Support RTL
  env: {
    RTL_SUPPORT: 'true',
    ARABIC_FONTS: 'true',
  }
}

module.exports = nextConfig
