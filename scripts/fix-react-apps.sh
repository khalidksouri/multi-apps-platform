#!/bin/bash

# Script de diagnostic et correction pour les applications React
set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"

echo "🔧 CORRECTION DES APPLICATIONS REACT"
echo "====================================="

# Applications React avec problèmes de build
react_apps=("math4kids" "unitflip" "ai4kids")

for app in "${react_apps[@]}"; do
    app_dir="$WORKSPACE_DIR/$app"
    
    if [ -d "$app_dir" ]; then
        echo ""
        echo "🔧 Correction de $app..."
        cd "$app_dir"
        
        # Recréer package.json minimal fonctionnel
        cat > package.json << PACKAGE_EOF
{
  "name": "$app",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
PACKAGE_EOF
        
        # Nettoyer et réinstaller
        rm -rf node_modules package-lock.json
        npm install --legacy-peer-deps --no-audit
        
        echo "✅ $app corrigé"
    fi
done

echo ""
echo "🎉 Correction terminée! Les applications React devraient maintenant démarrer."
echo "💡 Testez avec: ./start-apps.sh"
