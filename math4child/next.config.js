/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  env: {
    MATH4CHILD_VERSION: '4.2.0',
    SUPPORT_EMAIL: 'support@math4child.com',
    COMMERCIAL_EMAIL: 'commercial@math4child.com',
    DOMAIN: 'www.math4child.com'
  }
}

module.exports = nextConfig
