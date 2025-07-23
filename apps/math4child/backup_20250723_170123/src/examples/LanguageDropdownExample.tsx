'use client'

import { LanguageProvider } from '@/contexts/LanguageContext'
import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'

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
            
            <AdvancedLanguageDropdown />
          </header>
          
          <main className="text-white text-center">
            <h2 className="text-4xl font-bold mb-4">
              Dropdown de langues avancé
            </h2>
            <p className="text-xl text-white/80 mb-8">
              Testez la recherche, navigation clavier et scroll optimisé !
            </p>
          </main>
        </div>
      </div>
    </LanguageProvider>
  )
}
