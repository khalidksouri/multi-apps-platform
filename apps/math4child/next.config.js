/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  images: {
    unoptimized: true,
  },
  reactStrictMode: true,
  typescript: { 
    ignoreBuildErrors: false 
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  // Configuration pour App Router uniquement
  experimental: {
    appDir: true,
  },
  
  // DÉSACTIVER complètement CSS processing
  webpack: (config, { isServer }) => {
    // Ignorer les fichiers CSS complètement
    config.module.rules.push({
      test: /\.css$/,
      loader: 'ignore-loader'
    })
    
    return config
  }
}

module.exports = nextConfig
