/** @type {import('next').NextConfig} */
const nextConfig = {
  // Retour au static export pour SPA
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  
  // Images non optimisées
  images: {
    unoptimized: true,
  },
  
  // Configuration simplifiée
  reactStrictMode: false,
  swcMinify: false,
  
  typescript: { 
    ignoreBuildErrors: true
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  // Désactiver CSS processing
  webpack: (config) => {
    config.module.rules.push({
      test: /\.css$/,
      loader: 'ignore-loader'
    })
    return config
  }
}

module.exports = nextConfig
