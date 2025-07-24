/** @type {import('next').NextConfig} */
const nextConfig = {
  // PAS de static export - mode SPA
  trailingSlash: true,
  
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
