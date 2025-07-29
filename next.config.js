/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  typescript: { ignoreBuildErrors: false },
  eslint: { ignoreDuringBuilds: false },
  output: process.env.NODE_ENV === 'production' ? 'export' : undefined,
  trailingSlash: true,
  webpack: (config) => {
    config.optimization.moduleIds = 'deterministic'
    config.optimization.chunkIds = 'deterministic'
    return config
  }
}
module.exports = nextConfig
