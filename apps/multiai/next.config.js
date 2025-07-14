/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  transpilePackages: ['@multiapps/shared', '@multiapps/ui']
}

module.exports = nextConfig