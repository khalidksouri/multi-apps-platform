#!/bin/bash
set -e
echo "🔧 Correction rapide Math4Child..."

cd apps/math4child

# Nettoyage
rm -f package-lock.json
rm -rf node_modules .next

# Package.json corrigé avec versions compatibles
cat > package.json << 'PKG'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "test": "jest --passWithNoTests"
  },
  "dependencies": {
    "next": "15.4.2",
    "react": "18.3.1",
    "react-dom": "18.3.1",
    "lucide-react": "0.469.0",
    "tailwindcss": "3.4.0"
  },
  "devDependencies": {
    "@types/node": "20.12.0",
    "@types/react": "18.3.12",
    "@types/react-dom": "18.3.1",
    "typescript": "5.4.5",
    "eslint": "8.57.0",
    "eslint-config-next": "15.4.2"
  }
}
PKG

# Installation propre
npm install

# Structure basique
mkdir -p app
cat > app/page.tsx << 'PAGE'
export default function Home() {
  return (
    <main className="p-8">
      <h1 className="text-2xl font-bold">Math4Child</h1>
      <p>Application éducative pour enfants</p>
    </main>
  )
}
PAGE

cat > app/layout.tsx << 'LAYOUT'
export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  )
}
LAYOUT

npm run build
echo "✅ Math4Child corrigé et fonctionnel!"
