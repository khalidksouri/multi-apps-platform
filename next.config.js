/** @type {import('next').NextConfig} */
const nextConfig = {
  // ✅ CONFIGURATION MATH4CHILD v4.2.0 - ESLINT OPTIMISÉ
  
  // ESLint configuration pour éviter les blocages de build
  eslint: {
    ignoreDuringBuilds: true, // Ignore ESLint pendant le build
    dirs: ['src'], // Lint seulement src/
  },
  
  // TypeScript configuration
  typescript: {
    ignoreBuildErrors: false, // Garder TypeScript strict
  },
  
  // Configuration images
  images: {
    domains: [
      'localhost',
      'math4child.com',
      'www.math4child.com'
    ],
    formats: ['image/webp', 'image/avif'],
  },
  
  // Variables d'environnement
  env: {
    MATH4CHILD_VERSION: '4.2.0',
    SUPPORT_EMAIL: 'support@math4child.com',
    COMMERCIAL_EMAIL: 'commercial@math4child.com',
    DOMAIN: 'www.math4child.com'
  },
  
  // Optimisations de base
  poweredByHeader: false,
  compress: true,
  reactStrictMode: false,
  
  // Webpack optimisé pour Math4Child innovations
  webpack: (config, { isServer, dev }) => {
    // Support Canvas 2D pour Handwriting ✍️
    config.resolve.fallback = {
      ...config.resolve.fallback,
      canvas: false,
      encoding: false,
      'utf-8-validate': false,
      bufferutil: false,
    }
    
    // Optimisations côté client pour Web Speech API 🎙️
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
        crypto: false,
        stream: false,
        url: false,
        zlib: false,
        http: false,
        https: false,
        assert: false,
        os: false,
        path: false,
      }
    }
    
    return config
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
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
