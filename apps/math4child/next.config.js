/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  images: {
    unoptimized: true,
  },
  reactStrictMode: false,
  typescript: { 
    ignoreBuildErrors: true
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  webpack: (config) => {
    config.module.rules.push({
      test: /\.css$/,
      loader: 'ignore-loader'
    })
    return config
  }
}

module.exports = nextConfig
