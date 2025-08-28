import Link from 'next/link'
import { BookOpen, Mail, Globe, Brain, Shield } from 'lucide-react'

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-white py-12">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          
          {/* Marque */}
          <div>
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-10 h-10 bg-gradient-to-br from-blue-500 to-purple-600 rounded-xl flex items-center justify-center">
                <BookOpen className="w-6 h-6 text-white" />
              </div>
              <div>
                <div className="font-bold text-xl">Math4Child</div>
                <div className="text-xs text-gray-400">v4.2.0</div>
              </div>
            </div>
            <p className="text-gray-300 text-sm">Révolution Éducative Mondiale</p>
          </div>

          {/* Navigation */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-blue-300">Navigation</h4>
            <ul className="space-y-2 text-sm">
              <li><Link href="/" className="text-gray-300 hover:text-white">Accueil</Link></li>
              <li><Link href="/exercises" className="text-gray-300 hover:text-white">Exercices</Link></li>
              <li><Link href="/pricing" className="text-gray-300 hover:text-white">Tarification</Link></li>
            </ul>
          </div>

          {/* Contact */}
          <div>
            <h4 className="text-lg font-semibold mb-4 text-green-300">Contact</h4>
            <ul className="space-y-2 text-sm">
              <li className="flex items-center space-x-2">
                <Mail className="w-4 h-4" />
                <span>support@math4child.com</span>
              </li>
              <li className="flex items-center space-x-2">
                <Globe className="w-4 h-4" />
                <span>www.math4child.com</span>
              </li>
            </ul>
          </div>
        </div>
        
        <div className="border-t border-gray-800 mt-8 pt-8 text-center">
          <p className="text-gray-400 text-sm">© 2025 Math4Child - Révolution éducative mondiale</p>
        </div>
      </div>
    </footer>
  )
}
