/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true },
  eslint: { ignoreDuringBuilds: true },
  typescript: { ignoreBuildErrors: true },
  env: {
    APP_NAME: 'Math4Child',
    APP_VERSION: '4.2.0',
    EXPORT_MODE: 'static'
  }
}

console.log('🎯 Math4Child v4.2.0 - Export statique configuré')
module.exports = nextConfig
