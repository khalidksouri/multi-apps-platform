'use client'
import { useLanguage } from '../contexts/LanguageContext'
import { useTranslation } from '../translations'
import LanguageDropdown from '../components/language/LanguageDropdown'

export default function Home() {
  const { currentLanguage } = useLanguage()
  const { t } = useTranslation(currentLanguage.code)

  return (
    <main className="container mx-auto px-4 py-8">
      <header className="flex justify-between items-center mb-8">
        <h1 className="text-3xl font-bold text-gray-800">
          {t('home.title')}
        </h1>
        <LanguageDropdown className="w-64" />
      </header>
      
      <div className="text-center py-12">
        <h2 className="text-xl text-gray-600 mb-8">
          {t('home.subtitle')}
        </h2>
        
        <div className="space-x-4">
          <button className="bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors">
            {t('home.startFree')}
          </button>
          <button className="border border-blue-600 text-blue-600 px-6 py-3 rounded-lg hover:bg-blue-50 transition-colors">
            {t('home.comparePrices')}
          </button>
        </div>
      </div>
    </main>
  )
}
