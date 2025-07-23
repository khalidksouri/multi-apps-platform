/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  images: {
    unoptimized: true
  },  reactStrictMode: true,
  typescript: { ignoreBuildErrors: false },
  eslint: { ignoreDuringBuilds: true },
  
  async headers() {
    return [{
      source: '/(.*)',
      headers: [
        { key: 'X-Frame-Options', value: 'DENY' },
        { key: 'X-Content-Type-Options', value: 'nosniff' },
        { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' }
      ]
    }]
  },
  
  images: { domains: ['localhost'], dangerouslyAllowSVG: false },
  
  webpack: (config) => {
    config.ignoreWarnings = [{ module: /node_modules/ }, { file: /backup/ }]
    return config
  }
}

module.exports = nextConfig
