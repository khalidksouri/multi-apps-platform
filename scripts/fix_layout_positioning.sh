#!/bin/bash

echo "🎨 Correction du layout Header/Footer Math4Child"
echo "================================================"

# Corriger le layout principal
cat > src/app/layout.tsx << 'EOF'
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
EOF

# Mettre à jour le composant Navigation pour qu'il soit vraiment fixe
cat > src/components/navigation/Navigation.tsx << 'EOF'
'use client'

import { useState, useEffect } from 'react'
import Link from 'next/link'
import { usePathname } from 'next/navigation'

interface NavigationProps {
  currentLanguage?: string
  onLanguageChange?: (language: string) => void
}

const LANGUAGES = [
  { code: 'fr', name: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', flag: '🇪🇸' },
  { code: 'ar', name: 'العربية', flag: '🇲🇦' },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
  { code: 'it', name: 'Italiano', flag: '🇮🇹' }
]

const TRANSLATIONS = {
  fr: {
    home: 'Accueil', exercises: 'Exercices', subscription: 'Abonnement', dashboard: 'Tableau de bord',
    appTitle: 'Math4Child', appSubtitle: 'Apprendre en s\'amusant', badge: '100k+ familles', languages: 'Langues'
  },
  en: {
    home: 'Home', exercises: 'Exercises', subscription: 'Subscription', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Learn while having fun', badge: '100k+ families', languages: 'Languages'
  },
  es: {
    home: 'Inicio', exercises: 'Ejercicios', subscription: 'Suscripción', dashboard: 'Panel',
    appTitle: 'Math4Child', appSubtitle: 'Aprender divirtiéndose', badge: '100k+ familias', languages: 'Idiomas'
  },
  ar: {
    home: 'الرئيسية', exercises: 'التمارين', subscription: 'الاشتراك', dashboard: 'لوحة التحكم',
    appTitle: 'Math4Child', appSubtitle: 'التعلم مع المتعة', badge: '100k+ عائلة', languages: 'اللغات'
  },
  de: {
    home: 'Startseite', exercises: 'Übungen', subscription: 'Abonnement', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Lernen mit Spaß', badge: '100k+ Familien', languages: 'Sprachen'
  },
  it: {
    home: 'Home', exercises: 'Esercizi', subscription: 'Abbonamento', dashboard: 'Dashboard',
    appTitle: 'Math4Child', appSubtitle: 'Imparare divertendosi', badge: '100k+ famiglie', languages: 'Lingue'
  }
}

export default function Navigation({ currentLanguage = 'fr', onLanguageChange }: NavigationProps) {
  const pathname = usePathname()
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false)
  const [isLanguageDropdownOpen, setIsLanguageDropdownOpen] = useState(false)
  const [mounted, setMounted] = useState(false)

  useEffect(() => setMounted(true), [])

  const t = (key: string) => {
    return TRANSLATIONS[currentLanguage as keyof typeof TRANSLATIONS]?.[key as keyof typeof TRANSLATIONS['fr']] || 
           TRANSLATIONS['fr'][key as keyof typeof TRANSLATIONS['fr']] || key
  }

  const currentLang = LANGUAGES.find(lang => lang.code === currentLanguage) || LANGUAGES[0]
  const isRTL = currentLanguage === 'ar'

  const navigationItems = [
    { href: '/', label: t('home'), icon: '🏠' },
    { href: '/exercises', label: t('exercises'), icon: '🧮' },
    { href: '/subscription', label: t('subscription'), icon: '💎' },
    { href: '/dashboard', label: t('dashboard'), icon: '📊' }
  ]

  const isActiveRoute = (href: string) => href === '/' ? pathname === '/' : pathname.startsWith(href)

  if (!mounted) return null

  return (
    <header 
      className="fixed top-0 left-0 right-0 bg-white/95 backdrop-blur-sm shadow-lg border-b border-gray-200 z-50"
      dir={isRTL ? 'rtl' : 'ltr'}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-3">
          {/* Logo et titre */}
          <Link href="/" className="flex items-center space-x-3 hover:opacity-80 transition-opacity">
            <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg transform hover:scale-105 transition-transform">
              <span className="text-white text-lg font-bold">M4C</span>
            </div>
            <div>
              <h1 className="text-lg font-bold text-gray-900">{t('appTitle')}</h1>
              <div className="flex items-center space-x-2">
                <span className="bg-orange-100 text-orange-800 text-xs px-2 py-0.5 rounded-full font-medium">
                  {t('badge')}
                </span>
                <span className="text-green-600 text-xs font-medium hidden sm:inline">
                  {t('appSubtitle')}
                </span>
              </div>
            </div>
          </Link>

          {/* Navigation desktop */}
          <nav className="hidden md:flex items-center space-x-4">
            {navigationItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center space-x-2 px-3 py-2 rounded-lg font-medium transition-all duration-200 text-sm ${
                  isActiveRoute(item.href)
                    ? 'bg-blue-100 text-blue-700 shadow-sm'
                    : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'
                }`}
              >
                <span className="text-base">{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            ))}
          </nav>

          {/* Sélecteur de langue + Menu mobile */}
          <div className="flex items-center space-x-3">
            <div className="relative">
              <button 
                onClick={() => setIsLanguageDropdownOpen(!isLanguageDropdownOpen)} 
                className="flex items-center space-x-2 bg-gray-50 hover:bg-gray-100 px-3 py-2 rounded-lg border border-gray-200 transition-colors text-sm"
              >
                <span className="text-base">{currentLang.flag}</span>
                <span className="font-medium text-gray-700 hidden sm:inline text-xs">
                  {currentLang.name}
                </span>
                <svg className="w-3 h-3 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </button>

              {isLanguageDropdownOpen && (
                <div className="absolute right-0 mt-2 w-44 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50">
                  <div className="px-3 py-2 text-xs font-semibold text-gray-500 uppercase tracking-wide border-b border-gray-100">
                    {t('languages')}
                  </div>
                  {LANGUAGES.map((language) => (
                    <button
                      key={language.code}
                      onClick={() => { onLanguageChange?.(language.code); setIsLanguageDropdownOpen(false) }}
                      className={`w-full flex items-center space-x-3 px-3 py-2 text-left hover:bg-gray-50 transition-colors text-sm ${
                        currentLanguage === language.code ? 'bg-blue-50 text-blue-700' : 'text-gray-700'
                      }`}
                    >
                      <span className="text-base">{language.flag}</span>
                      <span className="font-medium">{language.name}</span>
                      {currentLanguage === language.code && <span className="ml-auto text-blue-500 text-xs">✓</span>}
                    </button>
                  ))}
                </div>
              )}
            </div>

            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className="md:hidden flex items-center justify-center w-8 h-8 rounded-lg bg-gray-100 hover:bg-gray-200 transition-colors"
              aria-label="Menu mobile"
            >
              <svg className="w-5 h-5 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                {isMobileMenuOpen ? (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                ) : (
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
                )}
              </svg>
            </button>
          </div>
        </div>

        {/* Menu mobile */}
        {isMobileMenuOpen && (
          <div className="md:hidden border-t border-gray-200 py-3">
            <nav className="space-y-1">
              {navigationItems.map((item) => (
                <Link
                  key={item.href}
                  href={item.href}
                  onClick={() => setIsMobileMenuOpen(false)}
                  className={`flex items-center space-x-3 px-3 py-2 rounded-lg font-medium transition-all duration-200 ${
                    isActiveRoute(item.href)
                      ? 'bg-blue-100 text-blue-700 shadow-sm'
                      : 'text-gray-600 hover:text-blue-600 hover:bg-blue-50'
                  }`}
                >
                  <span className="text-lg">{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              ))}
            </nav>
          </div>
        )}
      </div>

      {/* Overlay */}
      {(isLanguageDropdownOpen || isMobileMenuOpen) && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => { setIsLanguageDropdownOpen(false); setIsMobileMenuOpen(false) }} 
        />
      )}
    </header>
  )
}
EOF

# Mettre à jour le CSS pour améliorer le layout
cat >> src/app/globals.css << 'EOF'

/* Layout amélioré */
.fixed-header-layout {
  padding-top: 80px; /* Hauteur du header fixe */
}

/* Améliorations responsive */
@media (max-width: 768px) {
  .fixed-header-layout {
    padding-top: 70px;
  }
}

/* Smooth scrolling pour les ancres */
html {
  scroll-padding-top: 80px;
}

/* Améliorations pour le footer */
footer a:hover {
  text-decoration: underline;
}

/* Corrections pour l'espacement */
.space-x-3 > * + * {
  margin-left: 0.75rem;
}

.space-x-4 > * + * {
  margin-left: 1rem;
}

.space-x-6 > * + * {
  margin-left: 1.5rem;
}
EOF

echo "✅ Layout corrigé !"
echo "🔄 Rechargez la page pour voir les améliorations"