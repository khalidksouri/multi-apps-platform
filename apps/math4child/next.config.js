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
  
  // Éviter les problèmes de prerendering
  experimental: {
    missingSuspenseWithCSRBailout: false,
  }
}

module.exports = nextConfig
