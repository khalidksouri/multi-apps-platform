/** @type {import('next').NextConfig} */
const nextConfig = {
  // ✅ Configuration pour Math4Child v4.2.0
  // ✅ SANS experimental.appDir (obsolète dans Next.js 14)
  // ✅ SANS conflit i18n + export
  
  // Variables d'environnement pour Math4Child
  env: {
    MATH4CHILD_VERSION: '4.2.0',
    SUPPORT_EMAIL: 'support@math4child.com',
    COMMERCIAL_EMAIL: 'commercial@math4child.com',
    DOMAIN: 'www.math4child.com'
  },
  
  // Configuration des images optimisée pour Math4Child
  images: {
    domains: ['www.math4child.com', 'localhost'],
    formats: ['image/webp', 'image/avif'],
    deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048],
    imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    minimumCacheTTL: 60,
    unoptimized: false, // Optimisation activée
  },
  
  // Optimisations pour les performances
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
  
  // Configuration pour les 6 innovations révolutionnaires
  experimental: {
    // ✅ Uniquement les configurations modernes pour Next.js 14
    optimizePackageImports: ['lucide-react'],
    // ❌ PAS d'appDir (obsolète)
  },
  
  // Optimisations du build pour Math4Child
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production' ? {
      exclude: ['error', 'warn']
    } : false,
  },
  
  // Headers de sécurité pour production
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
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
          {
            key: 'Permissions-Policy',
            value: 'camera=(), microphone=(), geolocation=()',
          },
        ],
      },
    ]
  },
  
  // Redirections pour Math4Child
  async redirects() {
    return [
      {
        source: '/login',
        destination: '/auth',
        permanent: false,
      },
      {
        source: '/register',
        destination: '/auth',
        permanent: false,
      },
      {
        source: '/home',
        destination: '/',
        permanent: true,
      },
    ]
  },
  
  // Configuration webpack pour optimisations Math4Child
  webpack: (config, { buildId, dev, isServer, defaultLoaders, nextRuntime }) => {
    // Optimisations pour Math4Child
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      }
    }
    
    // Optimisation des bundles
    config.optimization = {
      ...config.optimization,
      splitChunks: {
        chunks: 'all',
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: 'vendors',
            chunks: 'all',
          },
          common: {
            name: 'common',
            chunks: 'all',
            minChunks: 2,
            enforce: true,
          },
        },
      },
    }
    
    return config
  },
  
  // Configuration TypeScript
  typescript: {
    ignoreBuildErrors: false,
  },
  
  // Configuration ESLint
  eslint: {
    ignoreDuringBuilds: false,
  },
}

module.exports = nextConfig
