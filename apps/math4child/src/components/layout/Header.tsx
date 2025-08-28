'use client'

import Link from 'next/link'
import { useState } from 'react'
import { Menu, X, Globe, BookOpen } from 'lucide-react'

export default function Header() {
  const [isOpen, setIsOpen] = useState(false)

  return (
    <header className="bg-white shadow-sm sticky top-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          {/* Logo */}
          <Link href="/" className="flex items-center space-x-3">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
              <BookOpen className="w-6 h-6 text-white" />
            </div>
            <div>
              <div className="font-bold text-xl text-gray-900">Math4Child</div>
              <div className="text-xs text-gray-500">v4.2.0</div>
            </div>
          </Link>

          {/* Navigation Desktop */}
          <nav className="hidden md:flex space-x-8">
            <Link href="/" className="text-gray-700 hover:text-blue-600 px-3 py-2">
              Accueil
            </Link>
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 px-3 py-2">
              Exercices
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 px-3 py-2">
              Tarification
            </Link>
          </nav>

          {/* Menu mobile */}
          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden p-2"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>

        {/* Menu mobile ouvert */}
        {isOpen && (
          <div className="md:hidden py-4 border-t">
            <div className="flex flex-col space-y-2">
              <Link href="/" className="px-3 py-2 text-gray-700">Accueil</Link>
              <Link href="/exercises" className="px-3 py-2 text-gray-700">Exercices</Link>
              <Link href="/pricing" className="px-3 py-2 text-gray-700">Tarification</Link>
            </div>
          </div>
        )}
      </div>
    </header>
  )
}
