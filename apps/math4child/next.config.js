/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_DOMAIN: 'www.math4child.com',
  },
}

module.exports = nextConfig
