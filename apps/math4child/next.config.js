/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true, // IMPORTANT: Ignore ESLint pendant le build
  },
  typescript: {
    ignoreBuildErrors: true, // IMPORTANT: Ignore erreurs TypeScript pendant le build
  },
  experimental: {
    typedRoutes: false,
  },
  // Configuration pour Netlify
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
}

module.exports = nextConfig
