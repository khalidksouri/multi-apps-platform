"use client"

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useLanguage } from '@/hooks/useLanguage'
import { LanguageSelector } from '@/components/language/LanguageSelector'

export default function Navigation() {
  const pathname = usePathname()
  const { t } = useLanguage()

  const isActive = (path: string) => pathname === path

  return (
    <nav className="bg-white shadow-lg border-b border-gray-200">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-2">
            <span className="text-2xl font-bold">
              <span className="text-blue-600">Math4Child</span>
              <span className="text-purple-600 text-sm ml-1">v4.2.0</span>
            </span>
          </Link>

          {/* Menu principal */}
          <div className="hidden md:flex items-center space-x-6">
            <Link 
              href="/"
              className={`font-medium transition-colors ${
                isActive('/') 
                  ? 'text-blue-600 border-b-2 border-blue-600' 
                  : 'text-gray-700 hover:text-blue-600'
              }`}
            >
              🏠 {t('home')}
            </Link>
            <Link 
              href="/exercises"
              className={`font-medium transition-colors ${
                isActive('/exercises') 
                  ? 'text-blue-600 border-b-2 border-blue-600' 
                  : 'text-gray-700 hover:text-blue-600'
              }`}
            >
              🧮 {t('exercises')}
            </Link>
            <Link 
              href="/pricing"
              className={`font-medium transition-colors ${
                isActive('/pricing') 
                  ? 'text-blue-600 border-b-2 border-blue-600' 
                  : 'text-gray-700 hover:text-blue-600'
              }`}
            >
              💰 {t('pricing')}
            </Link>
            <Link 
              href="/profile"
              className={`font-medium transition-colors ${
                isActive('/profile') 
                  ? 'text-blue-600 border-b-2 border-blue-600' 
                  : 'text-gray-700 hover:text-blue-600'
              }`}
            >
              👤 {t('profile')}
            </Link>
          </div>

          {/* Sélecteur de langue avancé */}
          <LanguageSelector />
        </div>
      </div>
    </nav>
  )
}
