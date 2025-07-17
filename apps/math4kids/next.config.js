/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  reactStrictMode: true,
  swcMinify: true,
  output: 'standalone',
  images: {
    unoptimized: true,
  },
  // Configuration i18n
  i18n: {
    locales: ['en', 'fr', 'es', 'de', 'ar', 'zh', 'ja', 'ko', 'hi', 'pt', 'it', 'ru', 'nl', 'pl', 'cs', 'hu', 'tr', 'th', 'vi', 'id', 'bn', 'ur', 'fa', 'he', 'sw', 'am', 'ha', 'yo', 'ig', 'zu', 'af', 'pt-BR', 'es-MX', 'fr-CA', 'qu', 'mi', 'sm'],
    defaultLocale: 'en',
    localeDetection: true,
  },
  trailingSlash: false,
  poweredByHeader: false,
  generateEtags: false,
  compress: true,
}

module.exports = nextConfig
