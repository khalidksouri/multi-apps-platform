/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  eslint: {
    ignoreDuringBuilds: true, // Éviter blocage ESLint
  },
  typescript: {
    ignoreBuildErrors: false, // Garder TypeScript
  },
  experimental: {
    typedRoutes: false,
  },
}

module.exports = nextConfig
