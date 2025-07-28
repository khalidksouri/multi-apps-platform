/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  typescript: {
    // Permet de construire même avec des erreurs TypeScript (temporaire)
    ignoreBuildErrors: false,
  },
  eslint: {
    // Permet de construire même avec des erreurs ESLint (temporaire)
    ignoreDuringBuilds: false,
  },
  swcMinify: true,
}

module.exports = nextConfig
