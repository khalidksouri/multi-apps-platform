"use client"

import Link from "next/link"
import { useState } from "react"
import { Calculator, Play, Trophy, Globe, TrendingUp, Award, Users, Zap } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import LanguageSelector from "@/components/language/LanguageSelector"
import PricingModal from "@/components/pricing/PricingModal"

export default function HomePage() {
  const [showPricing, setShowPricing] = useState(false)
  const { t, language } = useLanguage()

  return (
    <div className="min-h-screen" dir={language === "ar" ? "rtl" : "ltr"}>
      {/* Hero Section */}
      <section className="relative overflow-hidden py-20 px-4 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
        <div className="relative max-w-6xl mx-auto text-center">
          {/* Logo */}
          <div className="flex justify-center mb-8">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-6 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300 float">
              <Calculator className="w-20 h-20 text-white" />
            </div>
          </div>
          
          {/* Titre */}
          <div className="mb-8">
            <h1 className="text-6xl md:text-8xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-4">
              Math4Child
            </h1>
            <p className="text-2xl md:text-3xl text-gray-700 font-semibold max-w-4xl mx-auto">
              {t("subtitle")}
            </p>
          </div>
          
          {/* Boutons d'action */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-10 py-5 rounded-2xl font-bold text-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Play className="w-6 h-6 group-hover:animate-bounce" />
              {t("startAdventure")}
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="group bg-white text-blue-600 px-10 py-5 rounded-2xl font-bold text-xl border-3 border-blue-600 hover:bg-blue-50 hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Trophy className="w-6 h-6 group-hover:animate-pulse" />
              {t("viewPlans")}
            </button>
          </div>

          {/* Sélecteur de langues */}
          <div className="mb-8">
            <div className="inline-block bg-white/80 backdrop-blur-sm rounded-2xl p-4 shadow-lg">
              <LanguageSelector />
            </div>
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités */}
      <section className="py-20 px-4 bg-white">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-5xl font-black mb-6 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              Pourquoi Math4Child ?
            </h2>
            <p className="text-xl text-gray-600 max-w-3xl mx-auto">
              Une technologie révolutionnaire qui s'adapte à chaque enfant
            </p>
          </div>
          
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            <FeatureCard
              icon={<TrendingUp className="w-12 h-12" />}
              title="IA Adaptative"
              description="S'adapte intelligemment au niveau de chaque enfant"
              color="from-green-500 to-emerald-500"
            />
            <FeatureCard
              icon={<Globe className="w-12 h-12" />}
              title="195+ Langues"
              description="Support multilingue complet avec RTL automatique"
              color="from-blue-500 to-cyan-500"
            />
            <FeatureCard
              icon={<Award className="w-12 h-12" />}
              title="5 Niveaux"
              description="Progression gamifiée du débutant à l'expert"
              color="from-purple-500 to-pink-500"
            />
            <FeatureCard
              icon={<Calculator className="w-12 h-12" />}
              title="5 Opérations"
              description="Addition, soustraction, multiplication, division, mixte"
              color="from-orange-500 to-red-500"
            />
            <FeatureCard
              icon={<Users className="w-12 h-12" />}
              title="Mode Famille"
              description="Jusqu'à 10 profils enfants avec suivi parental"
              color="from-indigo-500 to-purple-500"
            />
            <FeatureCard
              icon={<Zap className="w-12 h-12" />}
              title="Motivation"
              description="Système de récompenses pour maintenir l'engagement"
              color="from-yellow-500 to-orange-500"
            />
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-5xl font-black text-white mb-6">
            Prêt à Révolutionner l'Apprentissage ?
          </h2>
          <p className="text-2xl text-blue-100 mb-8">
            Rejoignez des milliers de familles qui font confiance à Math4Child
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center">
            <Link 
              href="/exercises"
              className="group bg-white text-blue-600 px-10 py-5 rounded-2xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300"
            >
              Essayer Gratuitement (7 jours)
            </Link>
          </div>
          
          <div className="mt-8 text-white/80 text-sm">
            🚀 www.math4child.com • Développé par GOTEST • Contact: gotesttech@gmail.com
          </div>
        </div>
      </section>

      {/* Modal de Pricing */}
      {showPricing && (
        <PricingModal onClose={() => setShowPricing(false)} />
      )}
    </div>
  )
}

// Composant de fonctionnalité
function FeatureCard({ icon, title, description, color }: {
  icon: React.ReactNode
  title: string
  description: string
  color: string
}) {
  return (
    <div className="group bg-gradient-to-br from-white to-blue-50 p-8 rounded-3xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:scale-105 border border-blue-100">
      <div className={`bg-gradient-to-r ${color} p-4 rounded-2xl w-fit mb-6 group-hover:animate-pulse`}>
        <div className="text-white">
          {icon}
        </div>
      </div>
      <h3 className="text-2xl font-bold mb-4 group-hover:text-blue-600 transition-colors">{title}</h3>
      <p className="text-gray-600 group-hover:text-gray-700 transition-colors">{description}</p>
    </div>
  )
}