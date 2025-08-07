"use client"

import { useLanguage } from "@/hooks/useLanguage"

export default function ExercicesPage() {
  const { t } = useLanguage()

  return (
    <div className="min-h-screen pt-16 bg-gray-50">
      <div className="max-w-4xl mx-auto px-4 py-8">
        <h1 className="text-4xl font-bold text-center mb-8">{t("exercises")}</h1>
        <div className="bg-white rounded-xl p-8 shadow-lg text-center">
          <h2 className="text-2xl font-semibold mb-4">Page en développement</h2>
          <p className="text-gray-600 mb-6">
            Cette page sera développée dans la Phase 2 avec :
          </p>
          <ul className="text-left max-w-md mx-auto space-y-2">
            <li>• Sélection des 5 niveaux</li>
            <li>• Sélection des 5 opérations</li>
            <li>• Générateur de questions IA</li>
            <li>• Système de progression</li>
          </ul>
        </div>
      </div>
    </div>
  )
}
