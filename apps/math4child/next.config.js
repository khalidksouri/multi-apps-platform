/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration basique sans PostCSS
  reactStrictMode: true,
  poweredByHeader: false,
  
  // Images optimisées
  images: {
    domains: ['localhost', 'math4child.netlify.app'],
    dangerouslyAllowSVG: false,
  },
  
  // TypeScript et ESLint allégés
  typescript: {
    ignoreBuildErrors: false,
  },
  
  eslint: {
    // Ignorer ESLint durant le build
    ignoreDuringBuilds: true,
  },
  
  // Configuration webpack pour ignorer PostCSS
  webpack: (config, { dev, isServer }) => {
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /backup/ },
    ]
    
    return config
  },
  
  // Headers de sécurité (sans PostCSS)
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options', 
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin',
          },
        ],
      },
    ]
  },
  
  // Redirections
  async redirects() {
    return [
      {
        source: '/home',
        destination: '/',
        permanent: true,
      },
    ]
  },
}

module.exports = nextConfig
