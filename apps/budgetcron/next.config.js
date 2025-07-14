/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  experimental: {
    appDir: true
  },
  transpilePackages: ['@multiapps/shared', '@multiapps/ui']
}

module.exports = nextConfig
