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
  // Pas de configuration PostCSS
  experimental: {
    // Désactiver tout processing CSS automatique
    forceSwcTransforms: false,
  }
}

module.exports = nextConfig
