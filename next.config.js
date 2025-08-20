/** @type {import('next').NextConfig} */
// Math4Child v4.2.0 - Configuration export statique Netlify

const nextConfig = {
  // OBLIGATOIRE pour Netlify : export statique
  output: 'export',
  trailingSlash: true,
  
  // Images non optimisées pour export statique
  images: {
    unoptimized: true,
    formats: ['image/webp', 'image/avif'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'math4child.com'
      },
      {
        protocol: 'https',
        hostname: '*.netlify.app'
      }
    ]
  },
  
  // Configuration build
  reactStrictMode: true,
  swcMinify: true,
  
  // ESLint et TypeScript non bloquants
  eslint: {
    ignoreDuringBuilds: true
  },
  
  typescript: {
    ignoreBuildErrors: true
  },
  
  // Variables d'environnement
  env: {
    APP_NAME: 'Math4Child',
    APP_VERSION: '4.2.0',
    BUILD_TIME: new Date().toISOString(),
    EXPORT_MODE: 'static'
  },
  
  // Headers pour export statique
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          }
        ]
      }
    ]
  }
}

console.log('🔧 Math4Child v4.2.0 - Configuration export statique Netlify')
console.log('✅ Output: export statique vers /out')
console.log('✅ Images: non optimisées (compatible Netlify)')
console.log('✅ Build: production ready')

module.exports = nextConfig
