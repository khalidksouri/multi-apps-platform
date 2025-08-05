/** @type {import('next').NextConfig} */
const nextConfig = {
  // Export statique pour Netlify
  output: 'export',
  trailingSlash: true,
  images: {
    unoptimized: true
  },
  
  // Build optimisé pour production
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  reactStrictMode: false,
  swcMinify: true,
  
  // Variables d'environnement intégrées
  env: {
    SITE_URL: 'https://www.math4child.com',
    COMPANY: 'GOTEST',
    CONTACT: 'gotesttech@gmail.com',
    SIRET: '53958712100028'
  },
  
  // SEO et performance
  poweredByHeader: false,
  compress: true,
  
  // Headers additionnels
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
