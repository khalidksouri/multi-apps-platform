/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuration de build optimisée pour Netlify
  output: 'export',
  
  // Désactiver les optimisations d'images pour l'export statique
  images: {
    unoptimized: true
  },
  
  // Configuration du trailing slash
  trailingSlash: true,
  
  // Désactiver le serveur X-Powered-By
  poweredByHeader: false,
  
  // Configuration des en-têtes de sécurité
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'strict-origin-when-cross-origin'
          }
        ]
      }
    ]
  },
  
  // Configuration TypeScript moins stricte pour le build
  typescript: {
    ignoreBuildErrors: false,
    tsconfigPath: './tsconfig.json'
  },
  
  // Configuration ESLint
  eslint: {
    ignoreDuringBuilds: false,
    dirs: ['src', 'pages', 'components', 'lib', 'utils']
  },
  
  // Experimental features pour Next.js 14
  experimental: {
    // Optimisations modernes
    optimizeCss: true,
    optimizePackageImports: ['lucide-react'],
  },
  
  // Gestion des redirections
  async redirects() {
    return [
      {
        source: '/home',
        destination: '/',
        permanent: true,
      },
    ]
  }
}

module.exports = nextConfig
