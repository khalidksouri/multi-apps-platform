/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  distDir: 'out',
  
  // Variables d'environnement selon branche
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '4.2.0',
    NEXT_PUBLIC_BUILD_TIME: new Date().toISOString(),
    
    // Injection automatique branche et environnement
    NEXT_PUBLIC_BRANCH: process.env.BRANCH || process.env.HEAD || 'development',
    NEXT_PUBLIC_APP_ENV: process.env.NEXT_PUBLIC_APP_ENV || 'development',
    NEXT_PUBLIC_NETLIFY_CONTEXT: process.env.CONTEXT || 'development',
    
    // URLs API selon environnement
    NEXT_PUBLIC_API_URL: process.env.NEXT_PUBLIC_APP_ENV === 'production' 
      ? 'https://api.math4child.com'
      : process.env.NEXT_PUBLIC_APP_ENV === 'staging'
      ? 'https://api-staging.math4child.com'
      : process.env.NEXT_PUBLIC_APP_ENV === 'preview'
      ? 'https://api-preview.math4child.com'
      : 'http://localhost:3001/api'
  },
  
  // Configuration ESLint pour build production
  eslint: {
    ignoreDuringBuilds: process.env.ESLINT_NO_DEV_ERRORS === 'true',
    dirs: ['src']
  },
  
  // TypeScript configuration
  typescript: {
    ignoreBuildErrors: process.env.NODE_ENV === 'production' && process.env.IGNORE_TS_ERRORS === 'true'
  },
  
  // Optimisations production
  compress: true,
  poweredByHeader: false,
  
  // Images optimization
  images: {
    unoptimized: true // Pour export statique
  },
  
  // Headers sécurité
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
            key: 'X-XSS-Protection',
            value: '1; mode=block'
          }
        ]
      }
    ];
  },
  
  // Redirections
  async redirects() {
    return [
      {
        source: '/',
        destination: '/exercises',
        permanent: false
      }
    ];
  }
};

module.exports = nextConfig;
