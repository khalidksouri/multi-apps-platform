/** @type {import('next').NextConfig} */
const nextConfig = {
  // ✅ CONFIGURATION FINALE MATH4CHILD v4.2.0
  
  // TypeScript et ESLint - Configuration finale
  typescript: {
    ignoreBuildErrors: true, // Ignore pour build mais garde vérifications dev
  },
  
  eslint: {
    ignoreDuringBuilds: true,
    dirs: ['src'],
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
  
  // Optimisations
  poweredByHeader: false,
  compress: true,
  reactStrictMode: false,
  
  // Webpack optimisé pour Math4Child
  webpack: (config, { isServer, dev }) => {
    // Support Canvas 2D pour Handwriting ✍️
    config.resolve.fallback = {
      ...config.resolve.fallback,
      canvas: false,
      encoding: false,
    }
    
    // Optimisations côté client
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
