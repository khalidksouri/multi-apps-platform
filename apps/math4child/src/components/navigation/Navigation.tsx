"use client"

import Link from 'next/link'

export function Navigation() {
  return (
    <nav className="flex space-x-8">
      <Link href="/" className="text-gray-600 hover:text-blue-600">Accueil</Link>
      <Link href="/exercises" className="text-gray-600 hover:text-blue-600">Exercices</Link>
      <Link href="/profile" className="text-gray-600 hover:text-blue-600">Profil</Link>
    </nav>
  )
}
