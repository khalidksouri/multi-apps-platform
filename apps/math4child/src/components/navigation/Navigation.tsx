"use client"

import Link from "next/link"
import { Calculator, Menu, X } from "lucide-react"
import { useState } from "react"

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center gap-2 font-bold text-xl text-blue-600">
            <Calculator className="w-8 h-8" />
            Math4Child
          </Link>

          {/* Navigation Desktop */}
          <div className="hidden md:flex items-center space-x-8">
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Exercices
            </Link>
            <Link href="/profile" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Profil
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 font-medium transition-colors">
              Plans
            </Link>
            
            {/* Sélecteur de langues simple */}
            <div className="flex items-center gap-2">
              <span className="text-lg">🇫🇷</span>
              <select className="bg-gray-50 border border-gray-200 rounded-lg px-2 py-1 text-sm">
                <option value="fr">🇫🇷 Français</option>
                <option value="en">🇺🇸 English</option>
                <option value="ar">🇲🇦 العربية</option>
              </select>
            </div>
          </div>

          {/* Menu Mobile */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {/* Menu Mobile Dropdown */}
      {isOpen && (
        <div className="md:hidden bg-white border-t border-gray-200">
          <div className="px-4 pt-2 pb-3 space-y-1">
            <Link
              href="/exercises"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md font-medium"
              onClick={() => setIsOpen(false)}
            >
              Exercices
            </Link>
            <Link
              href="/profile"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md font-medium"
              onClick={() => setIsOpen(false)}
            >
              Profil
            </Link>
            <Link
              href="/pricing"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md font-medium"
              onClick={() => setIsOpen(false)}
            >
              Plans
            </Link>
          </div>
        </div>
      )}
    </nav>
  )
}
