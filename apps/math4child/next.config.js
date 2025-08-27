/** @type {import('next').NextConfig} */

console.log('🎯 Math4Child v4.2.0 - Configuration Next.js simplifiée')

const nextConfig = {
  // Configuration de base stable
  reactStrictMode: true,
  swcMinify: true,
  
  // Export statique pour déploiement
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  
  // Configuration ESLint non-bloquante
  eslint: {
    ignoreDuringBuilds: true,
  },
  
  // Configuration TypeScript non-bloquante
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '4.2.0',
    NEXT_PUBLIC_DOMAIN: 'www.math4child.com',
    NEXT_PUBLIC_SUPPORT_EMAIL: 'support@math4child.com',
    NEXT_PUBLIC_COMMERCIAL_EMAIL: 'commercial@math4child.com',
  },
  
  // Configuration build stable
  experimental: {
    esmExternals: false,
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
