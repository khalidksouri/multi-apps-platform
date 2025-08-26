/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  distDir: 'out',
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '4.2.0',
    NEXT_PUBLIC_BUILD_TIME: new Date().toISOString(),
    NEXT_PUBLIC_BRANCH: process.env.BRANCH || process.env.HEAD || 'development',
    NEXT_PUBLIC_APP_ENV: process.env.NEXT_PUBLIC_APP_ENV || 'development',
  },
  eslint: { ignoreDuringBuilds: process.env.ESLINT_NO_DEV_ERRORS === 'true' },
  typescript: { ignoreBuildErrors: process.env.IGNORE_TS_ERRORS === 'true' },
  images: { unoptimized: true },
  compress: true,
  poweredByHeader: false,
};

console.log('🎯 Math4Child v4.2.0 - Export statique optimisé');
module.exports = nextConfig;
