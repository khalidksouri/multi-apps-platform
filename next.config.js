/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  trailingSlash: true,
  distDir: 'out',
  images: { unoptimized: true },
  eslint: { ignoreDuringBuilds: true },
  typescript: { ignoreBuildErrors: true },
  // Variables d'environnement pour détection branche
  env: {
    NEXT_PUBLIC_APP_VERSION: '4.2.0',
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
  },
};

module.exports = nextConfig;
