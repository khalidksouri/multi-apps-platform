/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  reactStrictMode: true,
  experimental: {
    typedRoutes: false,
  },
  // Optimisations pour Netlify
  compress: true,
  poweredByHeader: false,
  generateEtags: false,
}

module.exports = nextConfig
