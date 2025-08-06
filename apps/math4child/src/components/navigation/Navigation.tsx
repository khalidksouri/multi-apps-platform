"use client"

import Link from "next/link"
import { Calculator, Menu, X } from "lucide-react"
import { useState } from "react"
import { useLanguage } from "@/hooks/useLanguage"

export default function Navigation() {
  const [isOpen, setIsOpen] = useState(false)
  const { t } = useLanguage()

  return (
    <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-200 z-40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center h-16">
          <Link href="/" className="flex items-center gap-2 font-bold text-xl text-blue-600">
            <Calculator className="w-8 h-8" />
            Math4Child
          </Link>

          <div className="hidden md:flex items-center space-x-8">
            <Link href="/exercises" className="text-gray-700 hover:text-blue-600 font-medium">
              {t("exercises")}
            </Link>
            <Link href="/profile" className="text-gray-700 hover:text-blue-600 font-medium">
              {t("profile")}
            </Link>
            <Link href="/pricing" className="text-gray-700 hover:text-blue-600 font-medium">
              {t("pricing")}
            </Link>
          </div>

          <button
            onClick={() => setIsOpen(!isOpen)}
            className="md:hidden"
          >
            {isOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
          </button>
        </div>
      </div>

      {isOpen && (
        <div className="md:hidden bg-white border-t border-gray-200">
          <div className="px-2 pt-2 pb-3 space-y-1">
            <Link
              href="/exercises"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md"
              onClick={() => setIsOpen(false)}
            >
              {t("exercises")}
            </Link>
            <Link
              href="/profile"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md"
              onClick={() => setIsOpen(false)}
            >
              {t("profile")}
            </Link>
            <Link
              href="/pricing"
              className="block px-3 py-2 text-gray-700 hover:bg-gray-100 rounded-md"
              onClick={() => setIsOpen(false)}
            >
              {t("pricing")}
            </Link>
          </div>
        </div>
      )}
    </nav>
  )
}
