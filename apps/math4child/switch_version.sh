#!/bin/bash
echo "🔄 BASCULEMENT VERSION MATH4CHILD"
echo "================================="

if [ "$1" = "api" ]; then
    echo "🔄 Activation version avec API routes..."
    if [ -f "src/app/page-main.tsx" ]; then
        cp src/app/page-main.tsx src/app/page.tsx
    fi
    # Utiliser next.config.js sans export
    if [ -f "next.config.api.js" ]; then
        cp next.config.api.js next.config.js
    fi
    echo "✅ Version API activée"
    
elif [ "$1" = "static" ]; then
    echo "🔄 Activation version statique..."
    cp src/app/page-fallback.tsx src/app/page.tsx
    # Utiliser next.config.js avec export
    cat > next.config.js << 'STATIC_CONFIG_EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  images: {
    unoptimized: true,
  },
  trailingSlash: true,
}

module.exports = nextConfig
STATIC_CONFIG_EOF
    echo "✅ Version statique activée"
    
else
    echo "Usage: ./switch_version.sh [api|static]"
    echo "  api    - Version avec API routes (serveur requis)"
    echo "  static - Version statique (sans serveur)"
fi
