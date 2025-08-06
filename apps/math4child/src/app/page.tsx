"use client"

import Link from "next/link"
import { useState, useEffect } from "react"
import { Calculator, Play, Trophy, Globe, TrendingUp, Award, Users, Zap } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"
import LanguageSelector from "@/components/language/LanguageSelector"
import PricingModal from "@/components/pricing/PricingModal"

export default function HomePage() {
  const [showPricing, setShowPricing] = useState(false)
  const [currentFeature, setCurrentFeature] = useState(0)
  const { t, language, totalLanguages } = useLanguage()

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentFeature((prev) => (prev + 1) % 6)
    }, 4000)
    return () => clearInterval(interval)
  }, [])

  return (
    <div className="min-h-screen" dir={language === "ar" ? "rtl" : "ltr"}>
      {/* Hero Section */}
      <section className="relative overflow-hidden py-20 px-4 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
        <div className="max-w-7xl mx-auto text-center">
          {/* Logo animé */}
          <div className="flex justify-center mb-8">
            <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-8 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300 float">
              <Calculator className="w-24 h-24 text-white" />
            </div>
          </div>
          
          {/* Titre */}
          <h1 className="text-7xl md:text-9xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
            Math4Child
          </h1>
          <p className="text-3xl md:text-4xl text-gray-700 font-semibold max-w-5xl mx-auto mb-8">
            {t("subtitle")}
          </p>
          
          {/* Stats */}
          <div className="flex flex-wrap justify-center gap-4 text-lg text-gray-600 mb-12">
            <div className="flex items-center gap-2">
              <Globe className="w-5 h-5 text-blue-600" />
              <span>{totalLanguages}+ langues</span>
            </div>
            <div className="flex items-center gap-2">
              <Users className="w-5 h-5 text-green-600" />
              <span>5 niveaux de progression</span>
            </div>
            <div className="flex items-center gap-2">
              <TrendingUp className="w-5 h-5 text-purple-600" />
              <span>IA adaptative</span>
            </div>
          </div>
          
          {/* Boutons CTA */}
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-12 py-6 rounded-2xl font-bold text-xl hover:shadow-2xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Play className="w-6 h-6 group-hover:animate-bounce" />
              <span>{t("startAdventure")}</span>
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="group bg-white text-blue-600 px-12 py-6 rounded-2xl font-bold text-xl border-3 border-blue-600 hover:bg-blue-50 hover:shadow-xl transform hover:scale-105 transition-all duration-300 flex items-center justify-center gap-3"
            >
              <Trophy className="w-6 h-6 group-hover:animate-pulse" />
              <span>{t("viewPlans")}</span>
            </button>
          </div>

          {/* Sélecteur de langues */}
          <div className="mb-12">
            <div className="inline-block bg-white/90 backdrop-blur-sm rounded-2xl p-6 shadow-xl border border-white/20">
              <div className="text-sm text-gray-600 mb-4 font-medium">
                🌍 Choisissez votre langue parmi {totalLanguages}+ disponibles
              </div>
              <LanguageSelector />
            </div>
          </div>

          {/* Statistiques */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
            {[
              { number: totalLanguages + "+", label: "Langues", icon: "🌍" },
              { number: "5", label: "Niveaux", icon: "🎯" },
              { number: "100%", label: "Gratuit 7j", icon: "🎁" },
              { number: "24/7", label: "Support", icon: "🤝" }
            ].map((stat, index) => (
              <div key={index} className="bg-white/80 backdrop-blur-sm rounded-xl p-4 shadow-lg border border-white/20">
                <div className="text-2xl mb-2">{stat.icon}</div>
                <div className="text-3xl font-black text-gray-900 mb-1">{stat.number}</div>
                <div className="text-sm text-gray-600 font-medium">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Section Fonctionnalités */}
      <section className="py-20 px-4 bg-white">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-20">
            <h2 className="text-6xl font-black mb-8 bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
              {t("whyMath4Child")}
            </h2>
            <p className="text-2xl text-gray-600 max-w-4xl mx-auto">
              Une technologie révolutionnaire qui s adapte à chaque enfant
            </p>
          </div>
          
          <div className="grid lg:grid-cols-3 gap-10">
            {[
              {
                icon: <TrendingUp className="w-16 h-16" />,
                title: t("adaptiveAI"),
                description: "Notre IA analyse 50+ paramètres pour adapter chaque question",
                color: "from-green-500 to-emerald-500"
              },
              {
                icon: <Globe className="w-16 h-16" />,
                title: `${totalLanguages}+ ${t("multiLanguage")}`,
                description: "Support natif de toutes les langues mondiales avec RTL",
                color: "from-blue-500 to-cyan-500"
              },
              {
                icon: <Award className="w-16 h-16" />,
                title: "5 Niveaux Gamifiés",
                description: "Progression structurée avec 100 réponses requises par niveau",
                color: "from-purple-500 to-pink-500"
              },
              {
                icon: <Calculator className="w-16 h-16" />,
                title: "5 Opérations Complètes",
                description: "Addition, soustraction, multiplication, division + mode mixte",
                color: "from-orange-500 to-red-500"
              },
              {
                icon: <Users className="w-16 h-16" />,
                title: "Mode Famille Premium",
                description: "Jusqu à 10 profils enfants avec suivi parental temps réel",
                color: "from-indigo-500 to-purple-500"
              },
              {
                icon: <Zap className="w-16 h-16" />,
                title: "Motivation Intelligente",
                description: "Système de récompenses optimisé pour maintenir l engagement",
                color: "from-yellow-500 to-orange-500"
              }
            ].map((feature, index) => (
              <div
                key={index}
                className={`group bg-gradient-to-br from-white to-gray-50 p-10 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 border border-gray-100 ${
                  currentFeature === index ? "ring-4 ring-blue-300 scale-105" : ""
                }`}
              >
                <div className={`bg-gradient-to-r ${feature.color} p-6 rounded-2xl w-fit mb-8 group-hover:animate-pulse`}>
                  <div className="text-white">
                    {feature.icon}
                  </div>
                </div>
                <h3 className="text-3xl font-bold mb-6 group-hover:text-blue-600 transition-colors">{feature.title}</h3>
                <p className="text-gray-600 text-lg leading-relaxed">{feature.description}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-20 px-4 bg-gradient-to-br from-blue-600 via-purple-600 to-pink-600">
        <div className="max-w-5xl mx-auto text-center">
          <h2 className="text-6xl font-black text-white mb-8 leading-tight">
            Prêt à Révolutionner l Apprentissage ?
          </h2>
          <p className="text-2xl text-blue-100 mb-12 max-w-3xl mx-auto">
            Rejoignez des milliers de familles qui transforment l éducation mathématique
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="group bg-white text-blue-600 px-12 py-6 rounded-2xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300 shadow-xl"
            >
              🎁 Essayer Gratuitement (7 jours)
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="group bg-black/20 backdrop-blur-sm text-white px-12 py-6 rounded-2xl font-bold text-xl border-2 border-white/30 hover:bg-white/10 transform hover:scale-105 transition-all duration-300"
            >
              💎 Voir Tous les Plans
            </button>
          </div>
          
          <div className="mt-12 pt-8 border-t border-white/20 text-white/70 text-sm">
            <p className="mb-2">
              🚀 <strong>www.math4child.com</strong> • Développé avec ❤️ par <strong>GOTEST</strong>
            </p>
            <p>
              📧 Contact: gotesttech@gmail.com • 🏢 SIRET: 53958712100028
            </p>
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
