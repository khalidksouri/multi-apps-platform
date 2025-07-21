/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone',
  images: {
    domains: ['www.math4child.com'],
    unoptimized: false
  },
  webpack: (config, { isServer }) => {
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
      }
    }
    return config
  },
  experimental: {
    optimizePackageImports: ['lucide-react'],
    // Désactivation temporaire de optimizeCss car problématique avec Next.js 15
    // optimizeCss: true,
  },
  swcMinify: true,
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
  },
}

module.exports = nextConfig
