/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration minimale pour export statique
  output: 'export',
  trailingSlash: true,
  
  // Désactiver toutes les optimisations problématiques
  images: {
    unoptimized: true,
    loader: 'custom',
    loaderFile: './imageLoader.js'
  },
  
  // Désactiver les vérifications
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  
  // Configuration React minimale
  reactStrictMode: false,
  swcMinify: false, // Désactiver SWC qui peut causer des conflits
  
  // Désactiver styled-jsx complètement
  compiler: {
    styledComponents: false,
  },
  
  // Configuration export
  distDir: '.next',
  generateEtags: false,
  poweredByHeader: false,
  
  // Webpack configuration pour éviter styled-jsx
  webpack: (config, { dev, isServer }) => {
    // Exclure styled-jsx complètement
    config.externals = config.externals || [];
    if (!isServer) {
      config.externals.push('styled-jsx');
    }
    
    // Fallbacks
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false,
      net: false,
      tls: false,
      crypto: false,
    };
    
    return config;
  },
};

module.exports = nextConfig;
