/** @type {import('next').NextConfig} */
const nextConfig = {
  // PAS d'export pour éviter les erreurs de redirections/headers
  // output: 'export', // ❌ Retiré car cause des problèmes
  
  // Configuration basique
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
    // Ignorer ESLint car il n'est pas installé
    ignoreDuringBuilds: true,
  },
  
  // PAS d'experimental optimizeCss (cause l'erreur critters)
  // experimental: {
  //   optimizeCss: true, // ❌ Retiré car cause l'erreur critters
  // },
  
  // Headers de sécurité (fonctionnent sans export)
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
  
  // Redirections (fonctionnent sans export)
  async redirects() {
    return [
      {
        source: '/home',
        destination: '/',
        permanent: true,
      },
    ]
  },
  
  // Configuration webpack pour ignorer les warnings
  webpack: (config, { dev, isServer }) => {
    // Ignorer les warnings non critiques
    config.ignoreWarnings = [
      { module: /node_modules/ },
      { file: /backup/ },
    ]
    
    return config
  },
}

module.exports = nextConfig
