'use client'

import React from 'react'
import { LanguageProvider } from '../../hooks/LanguageContext'
import LanguageSelector from '../../../../../shared/components/LanguageSelector'

interface I18nLayoutProps {
  children: React.ReactNode
}

export default function I18nLayout({ children }: I18nLayoutProps) {
  return (
    <LanguageProvider>
      <div className="min-h-screen">
        <header className="bg-white shadow-sm border-b">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between items-center py-4">
              <h1 className="text-xl font-semibold">Multi-Apps Platform</h1>
              <LanguageSelector showStats={true} />
            </div>
          </div>
        </header>
        <main>
          {children}
        </main>
      </div>
    </LanguageProvider>
  )
}
