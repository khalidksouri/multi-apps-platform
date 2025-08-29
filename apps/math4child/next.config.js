/** @type {import('next').NextConfig} */
const nextConfig = {
  // Retirer "output: export" pour permettre les API Routes
  // output: 'export', // DÉSACTIVÉ pour Stripe API
  
  experimental: {
    esmExternals: true
  },
  
  // Configuration pour le développement
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },
  
  // Optimisations
  transpilePackages: [],
  
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
      };
    }
    return config;
  },
  
  // Configuration des images si nécessaire
  images: {
    unoptimized: true
  }
};

module.exports = nextConfig;
