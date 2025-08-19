/** @type {import('next').NextConfig} */

// Détecter l'environnement et la branche
const isDevelopment = process.env.NODE_ENV === 'development'
const isProduction = process.env.NODE_ENV === 'production'
const currentBranch = process.env.BRANCH_NAME || process.env.VERCEL_GIT_COMMIT_REF || 'unknown'

// Configuration selon la branche
const getBranchConfig = () => {
  console.log(`🌿 Branche détectée: ${currentBranch}`)
  console.log(`🏷️  Environnement: ${process.env.NODE_ENV}`)

  switch (currentBranch) {
    case 'main':
      return {
        environment: 'production',
        enableExperimental: false,
        enableDebug: false,
        optimizeForPerformance: true,
        enableAllFeatures: true
      }
    
    case 'feature/math4child':
      return {
        environment: 'staging',
        enableExperimental: true,
        enableDebug: true,
        optimizeForPerformance: false,
        enableAllFeatures: true
      }
    
    default:
      return {
        environment: 'development',
        enableExperimental: false,
        enableDebug: true,
        optimizeForPerformance: false,
        enableAllFeatures: false
      }
  }
}

const branchConfig = getBranchConfig()

// Configuration ESLint intelligente
const getESLintConfig = () => {
  const skipLint = process.env.SKIP_LINT === 'true'
  
  if (skipLint) {
    console.log('⚠️  ESLint désactivé via SKIP_LINT')
    return {
      ignoreDuringBuilds: true,
      dirs: []
    }
  }

  switch (currentBranch) {
    case 'main':
      return {
        ignoreDuringBuilds: false,
        dirs: ['pages', 'components', 'lib', 'utils']
      }
    
    case 'feature/math4child':
      return {
        ignoreDuringBuilds: true,
        dirs: ['pages', 'components', 'lib', 'utils']
      }
    
    default:
      return {
        ignoreDuringBuilds: true,
        dirs: ['pages', 'components']
      }
  }
}

// Configuration TypeScript
const getTypeScriptConfig = () => {
  const skipTypeCheck = process.env.SKIP_TYPE_CHECK === 'true'
  
  if (skipTypeCheck) {
    console.log('⚠️  Vérification TypeScript désactivée')
    return {
      ignoreBuildErrors: true
    }
  }

  switch (currentBranch) {
    case 'main':
      return {
        ignoreBuildErrors: false
      }
    
    default:
      return {
        ignoreBuildErrors: true
      }
  }
}

const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  
  // Configuration ESLint intelligente
  eslint: getESLintConfig(),
  
  // Configuration TypeScript intelligente
  typescript: getTypeScriptConfig(),
  
  // Configuration i18n
  i18n: {
    locales: ['fr', 'en', 'es', 'de', 'it'],
    defaultLocale: 'fr',
    localeDetection: true
  },
  
  // Fonctionnalités expérimentales
  experimental: {
    appDir: branchConfig.enableExperimental,
    serverActions: branchConfig.enableExperimental
  },
  
  // Configuration des images
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'math4child.com'
      },
      {
        protocol: 'https',
        hostname: 'www.math4child.com'
      },
      {
        protocol: 'https',
        hostname: '*.netlify.app'
      }
    ],
    formats: ['image/webp', 'image/avif']
  },
  
  // Variables d'environnement
  env: {
    BRANCH_NAME: currentBranch,
    BUILD_ENVIRONMENT: branchConfig.environment,
    ENABLE_DEBUG: branchConfig.enableDebug.toString(),
    ENABLE_EXPERIMENTAL: branchConfig.enableExperimental.toString(),
    APP_VERSION: '4.2.0',
    BUILD_TIME: new Date().toISOString()
  },
  
  // Configuration Webpack
  webpack: (config, { dev }) => {
    if (branchConfig.enableDebug && dev) {
      config.devtool = 'eval-source-map'
    }
    
    config.resolve.fallback = {
      ...config.resolve.fallback,
      fs: false,
      path: false,
      os: false
    }
    
    return config
  }
}

console.log('')
console.log('🎯 MATH4CHILD v4.2.0 - CONFIGURATION NEXT.JS')
console.log(`🌿 Branche: ${currentBranch}`)
console.log(`🏷️  Environnement: ${branchConfig.environment}`)
console.log(`🔍 ESLint: ${nextConfig.eslint.ignoreDuringBuilds ? 'Non bloquant' : 'Strict'}`)
console.log('')

module.exports = nextConfig
