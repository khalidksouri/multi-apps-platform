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

  // DÉSACTIVER POSTCSS COMPLÈTEMENT
  experimental: {
    // Désactiver le processing CSS automatique
    css: false,
  },

  // Configuration webpack pour bypasser PostCSS
  webpack: (config, { buildId, dev, isServer, defaultLoaders, webpack }) => {
    // Trouver la règle CSS
    const cssRule = config.module.rules.find(rule => 
      rule.test && rule.test.toString().includes('css')
    );
    
    if (cssRule) {
      // Remplacer les loaders CSS par des loaders sans PostCSS
      cssRule.use = cssRule.use.map(loader => {
        if (typeof loader === 'object' && loader.loader && loader.loader.includes('postcss-loader')) {
          // Remplacer postcss-loader par un loader CSS simple
          return {
            loader: require.resolve('css-loader'),
            options: {
              importLoaders: 0,
              modules: false,
            }
          }
        }
        return loader;
      }).filter(loader => {
        // Supprimer tous les loaders PostCSS
        return !(typeof loader === 'object' && loader.loader && loader.loader.includes('postcss-loader'));
      });
    }

    // Alternative: Remplacer complètement la règle CSS
    config.module.rules = config.module.rules.map(rule => {
      if (rule.test && rule.test.toString().includes('css')) {
        return {
          test: /\.css$/,
          use: [
            isServer ? 'null-loader' : {
              loader: 'style-loader'
            },
            {
              loader: 'css-loader',
              options: {
                importLoaders: 0,
                modules: false,
              }
            }
          ]
        };
      }
      return rule;
    });

    return config;
  }
}

module.exports = nextConfig
