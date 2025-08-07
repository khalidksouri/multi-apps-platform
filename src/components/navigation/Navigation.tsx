"use client"
import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { LanguageSelector } from '@/components/language/LanguageSelector'

export default function Navigation() {
  const pathname = usePathname()
  
  const navItems = [
    { href: '/', label: 'Accueil' },
    { href: '/exercises', label: 'Exercices' },
    { href: '/profile', label: 'Profil' },
    { href: '/pricing', label: 'Plans' }
  ]
  
  return (
    <nav className="bg-white shadow-sm border-b">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <Link href="/" className="flex items-center space-x-2">
            <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl flex items-center justify-center">
              <span className="text-white font-bold text-lg">📚</span>
            </div>
            <span className="font-bold text-xl text-gray-800">Math4Child</span>
          </Link>
          
          <div className="hidden md:flex items-center space-x-8">
            {navItems.map((item) => (
              <Link
                key={item.href}
                href={item.href}
                className={`px-3 py-2 rounded-md text-sm font-medium transition-colors ${
                  pathname === item.href
                    ? 'bg-blue-100 text-blue-700'
                    : 'text-gray-700 hover:text-blue-600 hover:bg-gray-100'
                }`}
              >
                {item.label}
              </Link>
            ))}
          </div>
          
          <LanguageSelector />
        </div>
      </div>
    </nav>
  )
}
