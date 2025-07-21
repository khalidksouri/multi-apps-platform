/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    optimizePackageImports: ['lucide-react']
  },
  compress: true,
  poweredByHeader: false,
  generateEtags: true,
  images: {
    formats: ['image/webp', 'image/avif'],
    domains: []
  },
  headers: async () => [
    {
      source: '/(.*)',
      headers: [
        {
          key: 'X-Frame-Options', 
          value: 'DENY'
        },
        {
          key: 'X-Content-Type-Options',
          value: 'nosniff' 
        },
        {
          key: 'Referrer-Policy',
          value: 'strict-origin-when-cross-origin'
        }
      ]
    }
  ]
}

module.exports = nextConfig
