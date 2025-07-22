'use client'

import { LanguageProvider, useLanguage } from '@/contexts/LanguageContext'
import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'
import { Globe, Users, Star } from 'lucide-react'

function DemoContent() {
  const { currentLanguage, t } = useLanguage()

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600">
      {/* Header avec dropdown intégré */}
      <header className="p-6">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <span className="text-white font-bold text-lg">M4C</span>
            </div>
            <div>
              <h1 className="text-white text-xl font-bold">Math4Child</h1>
              <p className="text-white/70 text-sm">
                {t('math_learning')} • Langue: {currentLanguage.toUpperCase()}
              </p>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="hidden md:flex items-center gap-2 text-white/80 bg-white/10 px-3 py-2 rounded-lg backdrop-blur-sm">
              <Users className="w-4 h-4" />
              <span className="text-sm">{t('families_trust')}</span>
            </div>
            {/* 🌟 NOUVEAU DROPDOWN INTÉGRÉ */}
            <AdvancedLanguageDropdown />
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-6 pb-12">
        <div className="max-w-4xl mx-auto text-center">
          <div className="mb-8">
            <h2 className="text-4xl md:text-6xl font-bold text-white mb-4">
              {t('welcome')} !
            </h2>
            <p className="text-xl text-white/80 mb-8">
              🌟 Nouveau dropdown avec recherche intelligente, groupement par région et scroll visible !
            </p>
          </div>

          {/* Fonctionnalités */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Globe className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">20+ langues</div>
              <div className="text-white/80">Avec recherche intelligente</div>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Star className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">Scroll visible</div>
              <div className="text-white/80">Barre de défilement stylisée</div>
            </div>
            <div className="bg-white/10 backdrop-blur-sm rounded-xl p-6 border border-white/20">
              <Users className="w-8 h-8 text-white mx-auto mb-3" />
              <div className="text-2xl font-bold text-white mb-2">
                {currentLanguage.toUpperCase()}
              </div>
              <div className="text-white/80">Langue actuelle</div>
            </div>
          </div>

          {/* Instructions */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
            <h3 className="text-2xl font-bold text-white mb-6">
              🎮 Testez maintenant !
            </h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 text-left">
              <div className="space-y-3">
                <h4 className="font-semibold text-white text-lg">🔍 Recherche intelligente :</h4>
                <ul className="text-white/80 space-y-2">
                  <li>• Tapez "fr" → Français</li>
                  <li>• Tapez "eng" → English</li>
                  <li>• Tapez "chinese" → 中文</li>
                  <li>• Tapez "арабский" → العربية</li>
                </ul>
              </div>
              
              <div className="space-y-3">
                <h4 className="font-semibold text-white text-lg">⌨️ Navigation clavier :</h4>
                <ul className="text-white/80 space-y-2">
                  <li>• ↑↓ : Naviguer dans la liste</li>
                  <li>• Enter : Sélectionner</li>
                  <li>• Escape : Fermer</li>
                  <li>• Home/End : Premier/Dernier</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  )
}

export default function LanguageDropdownDemo() {
  return (
    <LanguageProvider>
      <DemoContent />
    </LanguageProvider>
  )
}
