/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  output: 'export',
  trailingSlash: false,
  distDir: 'out',
  
  // Configuration ESLint non bloquante
  eslint: {
    ignoreDuringBuilds: true,
  },
  
  // Configuration TypeScript non bloquante
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Images non optimisées pour l'export statique
  images: {
    unoptimized: true
  },
  
  // Pas d'experimental features pour éviter les erreurs
  experimental: {},
  
  // Configuration webpack simple
  webpack: (config) => {
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false,
      path: false,
      os: false,
    };
    return config;
  }
}

module.exports = nextConfig
