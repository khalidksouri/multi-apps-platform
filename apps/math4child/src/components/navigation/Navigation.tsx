"use client"

import Link from "next/link"
import { Calculator, User } from "lucide-react"

export default function Navigation() {
  return (
    <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-50 shadow-sm">
      <div className="max-w-6xl mx-auto px-4">
        <div className="flex justify-between items-center h-16">
          <Link href="/" className="flex items-center space-x-3 hover:scale-105 transition-transform">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-2 rounded-xl shadow-lg">
              <Calculator className="w-7 h-7 text-white" />
            </div>
            <div>
              <span className="font-black text-2xl bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
                Math4Child
              </span>
              <div className="text-xs text-gray-500 font-medium">by GOTEST</div>
            </div>
          </Link>

          <div className="flex items-center space-x-3">
            <button className="flex items-center gap-2 px-4 py-2 text-gray-600 hover:text-blue-600 transition-colors">
              <User className="w-4 h-4" />
              <span className="text-sm font-medium">Se connecter</span>
            </button>
            <Link
              href="/pricing"
              className="bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-xl font-semibold hover:shadow-lg transform hover:scale-105 transition-all duration-200"
            >
              Essai Gratuit
            </Link>
          </div>
        </div>
      </div>
    </nav>
  )
}
