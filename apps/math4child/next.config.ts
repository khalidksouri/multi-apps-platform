import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  reactStrictMode: true,
  
  // Export statique pour déploiements Capacitor - FIX: types stricts avec conditional
  ...(process.env.CAPACITOR_BUILD === 'true' ? {
    output: 'export' as const,
    assetPrefix: './',
    trailingSlash: true,
  } : {}),
  
  // Configuration TypeScript et ESLint stricte
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    ignoreDuringBuilds: false,
  },
  
  // Configuration des images - FIX ligne 21: conditional pour éviter undefined
  images: process.env.CAPACITOR_BUILD === 'true' ? {
    unoptimized: true,
    domains: ['localhost', 'math4child.com'],
    dangerouslyAllowSVG: false,
    formats: ['image/webp', 'image/avif'],
  } : {
    domains: ['localhost', 'math4child.com'],
    dangerouslyAllowSVG: false,
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
        ],
      },
    ];
  },
  
  // Optimisations
  swcMinify: true,
  poweredByHeader: false,
  compress: true,
  
  // Configuration webpack pour Capacitor
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      };
    }
    
    return config;
  },
  
  // Variables d'environnement
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_COMPANY: 'GOTEST',
    NEXT_PUBLIC_SIRET: '53958712100028',
  },
  
  // Configuration expérimentale
  experimental: {
    optimizePackageImports: ['lucide-react'],
  },
};

export default nextConfig;
