"use client"

import Link from "next/link"
import { Calculator, Menu, X, Home, BookOpen, User, CreditCard } from "lucide-react"
import { useState } from "react"
import { useLanguage } from "@/hooks/useLanguage"
import LanguageSelector from "@/components/language/LanguageSelector"

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false)
  const { language, setLanguage, t, isRTL } = useLanguage()

  const handleLanguageChange = (newLanguage: string) => {
    setLanguage(newLanguage)
    setIsOpen(false) // Fermer menu mobile après changement langue
  }

  const navigationLinks = [
    { href: "/", label: t('navigation.home'), icon: Home },
    { href: "/exercises", label: t('navigation.exercises'), icon: BookOpen },
    { href: "/profile", label: t('navigation.profile'), icon: User },
    { href: "/pricing", label: t('navigation.pricing'), icon: CreditCard },
  ]

  return (
    <nav className={`fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 ${
      isRTL ? 'rtl' : 'ltr'
    }`}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          
          {/* Logo */}
          <Link 
            href="/" 
            className="flex items-center gap-2 font-bold text-xl text-blue-600 hover:text-blue-700 transition-colors"
          >
            <Calculator className="w-8 h-8" />
            <span>Math4Child</span>
          </Link>

          {/* Navigation Desktop */}
          <div className="hidden md:flex items-center space-x-6">
            {navigationLinks.map((link) => {
              const Icon = link.icon
              return (
                <Link
                  key={link.href}
                  href={link.href}
                  className="flex items-center gap-2 text-gray-700 hover:text-blue-600 font-medium transition-colors px-3 py-2 rounded-lg hover:bg-blue-50"
                >
                  <Icon className="w-4 h-4" />
                  <span>{link.label}</span>
                </Link>
              )
            })}
            
            {/* Sélecteur de langues desktop */}
            <LanguageSelector 
              currentLanguage={language}
              onLanguageChange={handleLanguageChange}
            />
          </div>

          {/* Menu Mobile - Bouton hamburger */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
            aria-label="Toggle menu"
          >
            {isOpen ? (
              <X className="w-6 h-6 text-gray-600" />
            ) : (
              <Menu className="w-6 h-6 text-gray-600" />
            )}
          </button>
        </div>
      </div>

      {/* Menu Mobile Dropdown */}
      {isOpen && (
        <div className="md:hidden bg-white border-t border-gray-200 shadow-lg">
          <div className="px-4 pt-2 pb-3 space-y-1">
            
            {/* Navigation mobile */}
            {navigationLinks.map((link) => {
              const Icon = link.icon
              return (
                <Link
                  key={link.href}
                  href={link.href}
                  className="flex items-center gap-3 px-3 py-3 text-gray-700 hover:bg-gray-100 rounded-md font-medium transition-colors"
                  onClick={() => setIsOpen(false)}
                >
                  <Icon className="w-5 h-5 text-gray-500" />
                  <span>{link.label}</span>
                </Link>
              )
            })}
            
            {/* Divider */}
            <div className="border-t border-gray-200 my-2"></div>
            
            {/* Sélecteur langues mobile */}
            <div className="px-3 py-2">
              <div className="text-sm font-medium text-gray-700 mb-2 flex items-center gap-2">
                <span>🌍</span>
                <span>Langue / Language</span>
              </div>
              <LanguageSelector 
                currentLanguage={language}
                onLanguageChange={handleLanguageChange}
                className="w-full"
              />
            </div>
          </div>
        </div>
      )}
    </nav>
  )
}
