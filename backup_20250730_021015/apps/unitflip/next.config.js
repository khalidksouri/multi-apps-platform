/** @type {import('next').NextConfig} */
const nextConfig = {
  output: process.env.CAPACITOR_BUILD === 'true' ? 'export' : undefined,
  trailingSlash: process.env.CAPACITOR_BUILD === 'true',
  images: {
    unoptimized: process.env.CAPACITOR_BUILD === 'true'
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: false,
  },
  swcMinify: true,
  poweredByHeader: false,
  generateEtags: false,
  compress: true
};

module.exports = nextConfig;
