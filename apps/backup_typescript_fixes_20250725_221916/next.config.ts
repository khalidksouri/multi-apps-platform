import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  reactStrictMode: true,
  
  // Export statique pour déploiements Capacitor
  output: process.env.CAPACITOR_BUILD ? 'export' : undefined,
  assetPrefix: process.env.CAPACITOR_BUILD ? './' : undefined,
  trailingSlash: process.env.CAPACITOR_BUILD ? true : false,
  
  // Configuration TypeScript stricte
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    ignoreDuringBuilds: false,
  },
  
  // Configuration des images pour Capacitor
  images: {
    unoptimized: process.env.CAPACITOR_BUILD ? true : false,
    domains: ['localhost', 'math4child.com'],
    formats: ['image/webp', 'image/avif'],
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
  
  // Optimisations performance
  swcMinify: true,
  poweredByHeader: false,
  compress: true,
  
  // Configuration webpack pour Capacitor
  webpack: (config, { isServer }) => {
    // Fallbacks pour environnement mobile
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
    
    // Optimisations bundle
    config.optimization = {
      ...config.optimization,
      splitChunks: {
        chunks: 'all',
        minSize: 20000,
        maxSize: 250000,
        cacheGroups: {
          vendor: {
            test: /[\\/]node_modules[\\/]/,
            name: 'vendors',
            priority: -10,
            chunks: 'all',
          },
        },
      },
    }
    
    return config
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '4.0.0',
    NEXT_PUBLIC_COMPANY: 'GOTEST',
    NEXT_PUBLIC_SIRET: '53958712100028',
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react', 'recharts'],
  },
}

export default nextConfig;
