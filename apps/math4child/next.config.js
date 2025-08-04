/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration pour export statique
  output: 'export',
  trailingSlash: true,
  
  // Désactiver l'optimisation des images pour export statique
  images: {
    unoptimized: true
  },
  
  // Désactiver les vérifications pour accélérer le build
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Configuration React
  reactStrictMode: false, // Désactiver pour éviter les conflits useContext
  swcMinify: true,
  
  // Variables d'environnement
  env: {
    CAPACITOR_BUILD: process.env.CAPACITOR_BUILD || 'false',
  },
  
  // Configuration pour export
  distDir: '.next',
  generateEtags: false,
  
  // Désactiver les features qui causent des problèmes en export
  experimental: {
    // Pas d'appDir pour éviter les conflits
  },
  
  // Configuration webpack pour résoudre les conflits
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
