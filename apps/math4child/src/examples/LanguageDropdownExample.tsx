'use client'

import { LanguageProvider } from '@/contexts/LanguageContext'
import LanguageDropdown from '@/components/language/LanguageDropdown'

export default function LanguageDropdownExample() {
  return (
    <LanguageProvider>
      <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600 p-8">
        <div className="max-w-4xl mx-auto">
          <header className="flex justify-between items-center mb-8">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 bg-white/20 rounded-lg flex items-center justify-center">
                <span className="text-white font-bold">M4C</span>
              </div>
              <h1 className="text-white text-xl font-bold">Math4Child</h1>
            </div>
            
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 text-white/80">
                <span className="text-sm">👥 100k+ familles</span>
              </div>
              <LanguageDropdown />
            </div>
          </header>
          
          <main className="text-white text-center">
            <h2 className="text-4xl font-bold mb-4">
              Apprentissage des mathématiques en famille
            </h2>
            <p className="text-xl text-white/80 mb-8">
              L'app éducative préférée des familles du monde entier
            </p>
            
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 max-w-md mx-auto">
              <p className="text-white/90">
                Testez le dropdown de langues ci-dessus ! 
                Il devrait maintenant s'afficher correctement 
                au-dessus de tous les autres éléments.
              </p>
            </div>
          </main>
        </div>
      </div>
    </LanguageProvider>
  )
}
