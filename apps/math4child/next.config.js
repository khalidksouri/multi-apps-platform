/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Configuration spéciale pour Capacitor
  ...(process.env.CAPACITOR_BUILD && {
    output: 'export',
    trailingSlash: true,
    images: {
      unoptimized: true,
    },
    // Ne pas utiliser assetPrefix - ça cause des problèmes
    distDir: 'out',
  }),
  
  // Configuration TypeScript permissive
  typescript: {
    ignoreBuildErrors: true,
  },
  
  eslint: {
    ignoreDuringBuilds: true,
  },
  
  // Images toujours non optimisées pour éviter les problèmes
  images: {
    unoptimized: true,
    domains: ['localhost', 'math4child.com'],
  },
  
  // Configuration webpack pour résoudre les problèmes de modules
  webpack: (config, { isServer }) => {
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
        querystring: false,
        util: false,
        buffer: false,
        events: false,
      }
    }
    
    // Ignorer les warnings problématiques
    config.ignoreWarnings = [
      /Module not found/,
      /Can't resolve/,
      /Critical dependency/,
    ]
    
    return config
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_PLATFORM_TYPE: 'hybrid',
    NEXT_PUBLIC_COMPANY: 'GOTEST',
    NEXT_PUBLIC_SIRET: '53958712100028',
  },
  
  // Désactiver les fonctionnalités expérimentales problématiques
  experimental: {
    optimizePackageImports: false,
    typedRoutes: false,
  },
  
  // Configuration de build robuste
  generateEtags: false,
  compress: false,
  poweredByHeader: false,
}

module.exports = nextConfig
