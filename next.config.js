/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  env: {
    MATH4CHILD_VERSION: '4.2.0',
    SUPPORT_EMAIL: 'support@math4child.com',
    COMMERCIAL_EMAIL: 'commercial@math4child.com',
    DOMAIN: 'www.math4child.com'
  },
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  compiler: {
    removeConsole: process.env.NODE_ENV === 'production' ? {
      exclude: ['error', 'warn']
    } : false
  },
  eslint: {
    ignoreDuringBuilds: false,
  },
  typescript: {
    ignoreBuildErrors: false,
  }
}

module.exports = nextConfig
