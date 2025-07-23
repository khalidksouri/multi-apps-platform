/** @type {import('next').NextConfig} */
const nextConfig = {
  output: "export",
  trailingSlash: true,
  distDir: 'out',
  
  images: {
    unoptimized: true,
  },
  
  reactStrictMode: true,
  typescript: { 
    ignoreBuildErrors: false 
  },
  eslint: { 
    ignoreDuringBuilds: true 
  },
  
  webpack: (config) => {
    // Empêcher la résolution de TailwindCSS
    config.resolve.alias = {
      ...config.resolve.alias,
      'tailwindcss': false,
      'autoprefixer': false,
      'postcss': false,
    }
    
    config.ignoreWarnings = [
      { module: /node_modules/ },
      /postcss/,
      /tailwindcss/,
    ]
    
    return config
  },
}

module.exports = nextConfig
