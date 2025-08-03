'use client'

import { useTranslation } from '@/hooks/useTranslation'

export default function PricingPage() {
  const { t, isRTL } = useTranslation()

  return (
    <div className={`min-h-screen bg-gradient-to-br from-purple-500 to-pink-500 ${isRTL ? 'rtl' : 'ltr'}`}>
      <div className="container mx-auto px-4 py-8">
        <header className="text-center mb-12">
          <h1 className="text-4xl font-bold text-white mb-4">
            {t('pricing')}
          </h1>
          <p className="text-xl text-white/80">
            Choisissez le plan qui convient le mieux à votre famille
          </p>
        </header>

        <main className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {/* Plan Gratuit */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
            <div className="text-center">
              <h3 className="text-2xl font-bold text-white mb-4">{t('free')}</h3>
              <div className="text-4xl font-bold text-white mb-6">0€</div>
              <ul className="text-white/80 space-y-2 mb-8">
                <li>✅ 1 profil enfant</li>
                <li>✅ Exercices de base</li>
                <li>✅ 50 questions/semaine</li>
              </ul>
              <button className="w-full bg-green-500 hover:bg-green-600 text-white py-3 rounded-lg font-semibold transition-colors">
                {t('startFree')}
              </button>
            </div>
          </div>

          {/* Plan Premium */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border-2 border-blue-400 relative">
            <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
              <span className="bg-blue-500 text-white px-4 py-2 rounded-full text-sm font-medium">
                {t('mostPopular')}
              </span>
            </div>
            <div className="text-center">
              <h3 className="text-2xl font-bold text-white mb-4">{t('premiumPlan')}</h3>
              <div className="text-4xl font-bold text-white mb-6">9,99€</div>
              <ul className="text-white/80 space-y-2 mb-8">
                <li>✅ 3 profils enfants</li>
                <li>✅ Tous les exercices</li>
                <li>✅ Questions illimitées</li>
                <li>✅ Statistiques avancées</li>
              </ul>
              <button className="w-full bg-blue-500 hover:bg-blue-600 text-white py-3 rounded-lg font-semibold transition-colors">
                {t('choosePlan')}
              </button>
            </div>
          </div>

          {/* Plan Famille */}
          <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-8 border border-white/20">
            <div className="text-center">
              <h3 className="text-2xl font-bold text-white mb-4">{t('familyPlan')}</h3>
              <div className="text-4xl font-bold text-white mb-6">19,99€</div>
              <ul className="text-white/80 space-y-2 mb-8">
                <li>✅ 6 profils enfants</li>
                <li>✅ Tableau de bord famille</li>
                <li>✅ Rapports détaillés</li>
                <li>✅ Support VIP</li>
              </ul>
              <button className="w-full bg-purple-500 hover:bg-purple-600 text-white py-3 rounded-lg font-semibold transition-colors">
                {t('choosePlan')}
              </button>
            </div>
          </div>
        </main>

        <footer className="text-center mt-12">
          <p className="text-white/60">
            Tous les plans incluent un essai gratuit de 14 jours
          </p>
        </footer>
      </div>
    </div>
  )
}
