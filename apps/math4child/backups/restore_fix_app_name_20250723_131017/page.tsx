'use client'

import { LanguageProvider, useLanguage } from '@/contexts/LanguageContext'
import AdvancedLanguageDropdown from '@/components/language/LanguageDropdown'
import { useEffect } from 'react'

function PageContent() {
  const { t, currentLanguage, isRTL } = useLanguage()

  useEffect(() => {
    console.log('🔥 PAGE AVEC RTL MONTÉE !')
    console.log('🌍 Langue actuelle:', currentLanguage)
    console.log('📱 RTL activé:', isRTL)
  }, [currentLanguage, isRTL])

  const handleSubscriptionClick = (plan: string) => {
    console.log('🔥 Clic sur abonnement:', plan)
    alert(`Clic sur le plan: ${plan}`)
  }

  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600 ${isRTL ? 'text-right' : 'text-left'}`}>
      {/* Header avec dropdown intégré */}
      <header className="p-6">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <div className={`flex items-center gap-3 ${isRTL ? 'flex-row-reverse' : ''}`}>
            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center backdrop-blur-sm">
              <span className="text-white font-bold text-lg">M4C</span>
            </div>
            <div>
              <h1 className="text-white text-xl font-bold">{t('app_name')}</h1>
              <p className="text-white/70 text-sm">{t('website')} • {t('world_leader')}</p>
            </div>
          </div>
          
          <div className={`flex items-center gap-4 ${isRTL ? 'flex-row-reverse' : ''}`}>
            <div className={`hidden md:flex items-center gap-2 text-white/80 bg-white/10 px-3 py-2 rounded-lg backdrop-blur-sm ${isRTL ? 'flex-row-reverse' : ''}`}>
              <span className="text-sm">👥 {t('families_trust')}</span>
            </div>
            
            <AdvancedLanguageDropdown />
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="px-6 pb-12">
        <div className="max-w-4xl mx-auto text-center">
          
          {/* Badge */}
          <div className={`inline-flex items-center gap-2 bg-green-100 text-green-800 px-4 py-2 rounded-full mb-6 ${isRTL ? 'flex-row-reverse' : ''}`}>
            <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
            📱 {t('app_educative')}
          </div>

          {/* Titre principal */}
          <h2 className="text-4xl md:text-6xl font-bold text-white mb-6 bg-gradient-to-r from-white to-purple-200 bg-clip-text text-transparent">
            {t('main_title')}
          </h2>

          <p className="text-2xl text-white mb-4">
            {t('main_subtitle')}
          </p>

          <p className="text-xl text-green-300 mb-12">
            {t('join_families')}
          </p>

          {/* Boutons d'action avec support RTL */}
          <div className={`flex gap-6 justify-center mb-16 ${isRTL ? 'flex-row-reverse' : ''}`}>
            <button 
              onClick={() => handleSubscriptionClick('gratuit')}
              className={`bg-green-500 hover:bg-green-600 transition-colors duration-200 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}
            >
              🎁 {t('start_free')} 
              <span className="bg-green-400 text-green-900 px-2 py-1 rounded text-sm font-bold">{t('trial_14d')}</span>
            </button>
            
            <button 
              onClick={() => handleSubscriptionClick('compare')}
              className="bg-purple-500 hover:bg-purple-600 transition-colors duration-200 text-white px-8 py-4 rounded-xl font-semibold text-lg shadow-lg"
            >
              📊 {t('compare_prices')}
            </button>
          </div>

          {/* Plans d'abonnement avec support RTL */}
          <div className="grid grid-cols-1 md:grid-cols-4 gap-6 max-w-6xl mx-auto">
            
            {/* Plan Gratuit */}
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
              <h3 className="text-white text-xl font-bold mb-4">{t('plan_free')}</h3>
              <ul className="text-white/80 space-y-2 mb-6">
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('community_support')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('offline_limited')}
                </li>
              </ul>
              <button 
                onClick={() => handleSubscriptionClick('gratuit')}
                className="w-full bg-gray-500 hover:bg-gray-600 text-white py-3 rounded-lg font-semibold transition-colors duration-200"
              >
                {t('start_free_btn')}
              </button>
            </div>

            {/* Plan 14j */}
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
              <h3 className="text-white text-xl font-bold mb-4">{t('plan_trial_14')}</h3>
              <ul className="text-white/80 space-y-2 mb-6">
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('unlimited_questions')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('complete_levels')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('child_profiles_5')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('languages_30_complete')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('offline_total')}
                </li>
              </ul>
              <button 
                onClick={() => handleSubscriptionClick('14j-trial')}
                className="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg font-semibold transition-colors duration-200"
              >
                {t('free_trial_14')}
              </button>
            </div>

            {/* Plan 7j */}
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
              <h3 className="text-white text-xl font-bold mb-4">{t('plan_trial_7')}</h3>
              <ul className="text-white/80 space-y-2 mb-6">
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('unlimited_questions')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('complete_levels')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('child_profiles_2')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('languages_30')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('offline_mode')}
                </li>
              </ul>
              <button 
                onClick={() => handleSubscriptionClick('7j-trial')}
                className="w-full bg-purple-500 hover:bg-purple-600 text-white py-3 rounded-lg font-semibold transition-colors duration-200"
              >
                {t('free_trial_7')}
              </button>
            </div>

            {/* Plan Famille */}
            <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
              <h3 className="text-white text-xl font-bold mb-4">{t('plan_family')}</h3>
              <ul className="text-white/80 space-y-2 mb-6">
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('family_plan_all')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('student_profiles_30')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('teacher_dashboard')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('homework_assignment')}
                </li>
                <li className={`flex items-center gap-2 ${isRTL ? 'flex-row-reverse' : ''}`}>
                  <span className="text-green-400">✓</span> {t('detailed_reports')}
                </li>
              </ul>
              <button 
                onClick={() => handleSubscriptionClick('30j-trial')}
                className="w-full bg-green-500 hover:bg-green-600 text-white py-3 rounded-lg font-semibold transition-colors duration-200"
              >
                {t('free_trial_30')}
              </button>
            </div>
          </div>

          {/* Debug info */}
          <div className="mt-12 bg-black/20 rounded-lg p-4 text-white/80 text-sm">
            <p>🔥 Debug: Langue actuelle = {currentLanguage}</p>
            <p>📱 RTL activé = {isRTL ? 'OUI' : 'NON'}</p>
            <p>🌍 Direction de la page = {isRTL ? 'Droite vers Gauche' : 'Gauche vers Droite'}</p>
          </div>
        </div>
      </main>
    </div>
  )
}

export default function HomePage() {
  return (
    <LanguageProvider>
      <PageContent />
    </LanguageProvider>
  )
}
