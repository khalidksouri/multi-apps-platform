'use client'

import { ReactNode } from 'react'
import { LanguageProvider } from '@/contexts/LanguageContext'
import Navigation from '@/components/navigation/Navigation'
import { useLanguage } from '@/contexts/LanguageContext'
import './globals.css'

function LayoutContent({ children }: { children: ReactNode }) {
  const { currentLanguage, setLanguage } = useLanguage()

  return (
    <html lang={currentLanguage}>
      <head>
        <title>Math4Child - Application Éducative</title>
        <meta name="description" content="Application révolutionnaire pour l'apprentissage des mathématiques" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </head>
      <body className="flex flex-col min-h-screen bg-gray-50">
        {/* Header fixe */}
        <Navigation 
          currentLanguage={currentLanguage}
          onLanguageChange={setLanguage}
        />
        
        {/* Contenu principal avec padding pour éviter le chevauchement */}
        <main className="flex-1 pt-20">
          {children}
        </main>
        
        {/* Footer */}
        <footer className="bg-gray-900 text-white py-8 mt-auto">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="text-center">
              <div className="flex items-center justify-center space-x-2 mb-4">
                <div className="w-8 h-8 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                  <span className="text-white text-sm font-bold">M4C</span>
                </div>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400 mb-4">
                Application éducative révolutionnaire pour l'apprentissage des mathématiques
              </p>
              <div className="flex items-center justify-center space-x-6 text-sm text-gray-400 flex-wrap">
                <span>© 2024 Math4Child</span>
                <span>•</span>
                <span>100k+ familles font confiance</span>
                <span>•</span>
                <span>Support multilingue</span>
              </div>
              
              {/* Liens supplémentaires */}
              <div className="mt-6 pt-4 border-t border-gray-700">
                <div className="flex items-center justify-center space-x-6 text-sm text-gray-400 flex-wrap">
                  <a href="/privacy" className="hover:text-white transition-colors">Confidentialité</a>
                  <a href="/terms" className="hover:text-white transition-colors">Conditions</a>
                  <a href="/contact" className="hover:text-white transition-colors">Contact</a>
                  <a href="/help" className="hover:text-white transition-colors">Aide</a>
                </div>
              </div>
            </div>
          </div>
        </footer>
      </body>
    </html>
  )
}

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <LanguageProvider>
      <LayoutContent>{children}</LayoutContent>
    </LanguageProvider>
  )
}
