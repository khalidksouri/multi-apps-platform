'use client'

import React, { useState, useEffect } from 'react'
import { 
  Calculator, Trophy, Globe, ChevronDown, Users, Star, 
  Play, BookOpen, Check, ArrowLeft, Crown, Volume2, VolumeX
} from 'lucide-react'

export default function Math4ChildApp() {
  const [currentLanguage, setCurrentLanguage] = useState('en')
  const [currentView, setCurrentView] = useState('home')
  const [mounted, setMounted] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const languages = {
    'en': { name: 'English', flag: '🇺🇸' },
    'fr': { name: 'Français', flag: '🇫🇷' },
    'es': { name: 'Español', flag: '🇪🇸' },
    'de': { name: 'Deutsch', flag: '🇩🇪' },
    'ar': { name: 'العربية', flag: '🇸🇦' },
    'zh': { name: '中文', flag: '🇨🇳' }
  }

  const translations = {
    en: {
      title: 'Math4Child - Learn math while having fun',
      subtitle: 'Multilingual educational platform for children aged 4 to 12',
      levels: ['Beginner', 'Elementary', 'Intermediate', 'Advanced', 'Expert'],
      operations: ['Addition', 'Subtraction', 'Multiplication', 'Division', 'Mixed']
    },
    fr: {
      title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
      subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
      levels: ['Débutant', 'Élémentaire', 'Intermédiaire', 'Avancé', 'Expert'],
      operations: ['Addition', 'Soustraction', 'Multiplication', 'Division', 'Mixte']
    }
  }

  const t = translations[currentLanguage] || translations['en']

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full mx-auto mb-4 animate-spin" />
          <p className="text-lg text-gray-600">Loading Math4Child...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
      {/* Header */}
      <header className="p-4 flex justify-between items-center backdrop-blur-sm bg-white/30 sticky top-0 z-50">
        <div className="flex items-center space-x-2">
          <div className="p-2 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl">
            <Calculator className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Math4Child
          </span>
        </div>
        
        <div className="flex items-center space-x-4">
          <div className="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold">
            Free questions remaining: 45
          </div>
          
          <button
            onClick={() => setSoundEnabled(!soundEnabled)}
            className="p-2 bg-white/20 backdrop-blur-sm rounded-lg text-white hover:bg-white/30 transition-colors"
          >
            {soundEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
          </button>
          
          <div className="relative">
            <button 
              onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
              className="bg-white/90 backdrop-blur border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 hover:border-blue-300 transition-all duration-200 cursor-pointer flex items-center space-x-2"
            >
              <span>{languages[currentLanguage]?.flag}</span>
              <span>{languages[currentLanguage]?.name}</span>
              <ChevronDown className={`w-4 h-4 transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
            </button>
            
            {showLanguageDropdown && (
              <div className="absolute right-0 mt-2 bg-white rounded-xl shadow-2xl z-50 border">
                <div className="p-2">
                  {Object.entries(languages).map(([code, config]) => (
                    <button
                      key={code}
                      onClick={() => {
                        setCurrentLanguage(code)
                        setShowLanguageDropdown(false)
                      }}
                      className="w-full text-left px-3 py-2 rounded-lg hover:bg-blue-50 transition-colors flex items-center space-x-3 min-w-[200px]"
                    >
                      <span className="text-xl">{config.flag}</span>
                      <div>
                        <div className="font-medium text-gray-900">{config.name}</div>
                      </div>
                      {currentLanguage === code && <Check className="w-4 h-4 text-blue-500 ml-auto" />}
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-6xl mx-auto text-center mb-16">
          <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
            {t.title}
          </h1>
          
          <p className="text-xl md:text-2xl text-gray-600 mb-12 max-w-4xl mx-auto">
            {t.subtitle}
          </p>

          {/* Statistics */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16">
            {[
              { value: '10K+', label: 'Active students', icon: Users },
              { value: '500+', label: 'Available exercises', icon: BookOpen },
              { value: '20', label: 'Supported languages', icon: Globe },
              { value: '98%', label: 'Parent satisfaction', icon: Star }
            ].map((stat, index) => (
              <div key={index} className="p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300">
                <div className="text-3xl font-bold text-blue-600 mb-2">{stat.value}</div>
                <div className="text-sm text-gray-600 flex items-center gap-2">
                  <stat.icon className="w-4 h-4" />
                  {stat.label}
                </div>
              </div>
            ))}
          </div>

          {/* Levels */}
          <div className="mb-16">
            <h2 className="text-3xl font-bold text-gray-800 mb-8">Choose your level</h2>
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              {t.levels.map((level, index) => (
                <div
                  key={index}
                  className="p-6 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 cursor-pointer"
                >
                  <div className="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl mx-auto w-fit mb-4">
                    <Trophy className="w-8 h-8 text-white" />
                  </div>
                  <h3 className="font-bold text-gray-800 mb-2">{level}</h3>
                  <div className="text-sm text-gray-600 mb-3">0/100 ✓</div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="h-2 rounded-full bg-gradient-to-r from-blue-500 to-purple-600" style={{width: '0%'}} />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Call to Action */}
          <div className="space-y-6 md:space-y-0 md:space-x-6 md:flex md:justify-center md:items-center">
            <button className="group px-10 py-4 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white rounded-2xl font-bold transition-all duration-300 shadow-2xl">
              <span className="flex items-center gap-2">
                <Crown className="w-5 h-5" />
                Subscribe Now
              </span>
            </button>
            
            <button className="group px-10 py-4 border-2 border-gray-300 text-gray-700 rounded-2xl font-bold hover:border-blue-400 hover:bg-blue-50 hover:text-blue-600 transition-all duration-300">
              <span className="flex items-center gap-2">
                <Play className="w-5 h-5" />
                Free Trial
              </span>
            </button>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 text-center text-gray-500 bg-white/30 backdrop-blur-sm">
        <p>© 2024 Math4Child. Made with ❤️ for children worldwide.</p>
        <div className="mt-2 text-sm">
          <span>🌍 www.math4child.com</span>
        </div>
      </footer>
    </div>
  )
}
