/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    unoptimized: true
  },
  poweredByHeader: false,
  experimental: {
    optimizePackageImports: ['lucide-react']
  }
}

module.exports = nextConfig
