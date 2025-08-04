/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration pour Pages Router (pas App Router)
  output: 'export',
  trailingSlash: true,
  
  // Désactiver les optimisations
  images: {
    unoptimized: true
  },
  
  // Désactiver les vérifications
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Configuration React
  reactStrictMode: false,
  swcMinify: false,
  
  // PAS d'experimental.appDir
  experimental: {
    // Vide - on utilise Pages Router classique
  },
  
  // Configuration export
  distDir: '.next',
  generateEtags: false,
  poweredByHeader: false,
  
  // Webpack simple
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
};

module.exports = nextConfig;
