"use client"

import Navigation from "@/components/navigation/Navigation"
import { useLanguage } from "@/hooks/useLanguage"

export default function ProfilePage() {
  const { isRTL } = useLanguage()
  
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`}>
      <Navigation />
      
      <div className="max-w-4xl mx-auto px-4 py-8">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-800 mb-4">
            👤 Profil Utilisateur
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Gérez vos informations et votre progression
          </p>
          
          <div className="bg-white rounded-xl p-8 shadow-lg">
            <div className="text-6xl mb-4">🚧</div>
            <h2 className="text-2xl font-bold text-gray-800 mb-4">
              Page en construction
            </h2>
            <p className="text-gray-600">
              Cette page sera bientôt disponible avec la gestion complète des profils utilisateurs.
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
