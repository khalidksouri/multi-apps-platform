"use client"

import Link from "next/link"
import { useState, useEffect } from "react"
import { Calculator, Play, Trophy, Globe, TrendingUp, Award, Users, Zap, Star, Shield } from "lucide-react"
import { useLanguage } from "@/hooks/useLanguage"

export default function HomePage() {
  const [showPricing, setShowPricing] = useState(false)
  const [currentFeature, setCurrentFeature] = useState(0)
  const { t, language, totalLanguages } = useLanguage()

  // Animation automatique des fonctionnalités
  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentFeature((prev) => (prev + 1) % 6)
    }, 4000)
    return () => clearInterval(interval)
  }, [])

  return (
    <div className="min-h-screen" dir={language === "ar" ? "rtl" : "ltr"}>
      {/* Hero Section Ultra-Premium */}
      <section className="relative overflow-hidden py-20 px-4 bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50">
        <div className="relative max-w-7xl mx-auto">
          <div className="text-center">
            {/* Badge de lancement */}
            <div className="inline-flex items-center gap-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 py-2 rounded-full text-sm font-semibold mb-8 shadow-lg">
              <Star className="w-4 h-4" />
              Nouveau sur www.math4child.com
              <Star className="w-4 h-4" />
            </div>

            {/* Logo animé */}
            <div className="flex justify-center mb-8">
              <div className="bg-gradient-to-r from-blue-600 to-purple-600 p-8 rounded-3xl shadow-2xl transform hover:scale-110 transition-all duration-300 relative">
                <Calculator className="w-24 h-24 text-white" />
                <div className="absolute -top-2 -right-2 bg-yellow-400 text-yellow-900 px-2 py-1 rounded-full text-xs font-bold">
                  {totalLanguages}+
                </div>
              </div>
            </div>
            
            {/* Titre avec gradient animé */}
            <div className="mb-8">
              <h1 className="text-7xl md:text-9xl font-black bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
                Math4Child
              </h1>
              <p className="text-3xl md:text-4xl text-gray-700 font-semibold max-w-5xl mx-auto mb-4">
                {t("subtitle")}
              </p>
              <div className="flex flex-wrap justify-center gap-4 text-lg text-gray-600">
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
            </div>
            
            {/* Boutons CTA Premium */}
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
            <p className="text-2xl text-gray-600 max-w-4xl mx-auto mb-8">
              Une technologie révolutionnaire qui s'adapte à chaque enfant
            </p>
          </div>
          
          <div className="grid lg:grid-cols-3 gap-10">
            {[
              {
                icon: <TrendingUp className="w-16 h-16" />,
                title: t("adaptiveAI"),
                description: "IA qui analyse et adapte chaque question au niveau de l'enfant",
                color: "from-green-500 to-emerald-500"
              },
              {
                icon: <Globe className="w-16 h-16" />,
                title: `${totalLanguages}+ ${t("multiLanguage")}`,
                description: "Support de toutes les langues mondiales avec traduction automatique",
                color: "from-blue-500 to-cyan-500"
              },
              {
                icon: <Award className="w-16 h-16" />,
                title: "5 Niveaux Gamifiés",
                description: "Progression structurée avec déblocage par réussite",
                color: "from-purple-500 to-pink-500"
              }
            ].map((feature, index) => (
              <div
                key={index}
                className={`group bg-gradient-to-br from-white to-gray-50 p-10 rounded-3xl shadow-xl hover:shadow-2xl transition-all duration-500 transform hover:scale-105 ${
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
          <h2 className="text-6xl font-black text-white mb-8">
            Prêt à Révolutionner l'Apprentissage ?
          </h2>
          <p className="text-2xl text-blue-100 mb-12 max-w-3xl mx-auto">
            Rejoignez des milliers de familles qui font confiance à Math4Child
          </p>
          
          <div className="flex flex-col sm:flex-row gap-6 justify-center mb-12">
            <Link 
              href="/exercises"
              className="bg-white text-blue-600 px-12 py-6 rounded-2xl font-bold text-xl hover:bg-gray-100 transform hover:scale-105 transition-all duration-300 shadow-xl"
            >
              🎁 Essayer Gratuitement (7 jours)
            </Link>
            <button
              onClick={() => setShowPricing(true)}
              className="bg-black/20 backdrop-blur-sm text-white px-12 py-6 rounded-2xl font-bold text-xl border-2 border-white/30 hover:bg-white/10 transform hover:scale-105 transition-all duration-300"
            >
              💎 Voir Tous les Plans
            </button>
          </div>
          
          {/* Footer info */}
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

      {/* Modal de Pricing Basique */}
      {showPricing && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center p-6 border-b">
              <h2 className="text-3xl font-bold">Plans Math4Child</h2>
              <button
                onClick={() => setShowPricing(false)}
                className="p-2 hover:bg-gray-100 rounded-full"
              >
                ✕
              </button>
            </div>
            <div className="p-6">
              <div className="grid md:grid-cols-3 gap-6">
                {[
                  { name: "Gratuit", price: "0€", period: "/semaine", profiles: 1 },
                  { name: "Famille", price: "6.99€", period: "/mois", profiles: 5 },
                  { name: "Premium", price: "9.99€", period: "/mois", profiles: 10 }
                ].map((plan, index) => (
                  <div key={index} className="border-2 border-gray-200 rounded-2xl p-6 text-center hover:border-blue-500 transition-colors">
                    <h3 className="text-2xl font-bold mb-4">{plan.name}</h3>
                    <div className="text-4xl font-black text-blue-600 mb-2">{plan.price}</div>
                    <div className="text-gray-600 mb-4">{plan.period}</div>
                    <div className="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-sm font-semibold inline-block mb-6">
                      {plan.profiles} profil{plan.profiles > 1 ? "s" : ""} enfant{plan.profiles > 1 ? "s" : ""}
                    </div>
                    <button className="w-full bg-blue-600 text-white py-3 rounded-xl font-bold hover:bg-blue-700 transition-colors">
                      Choisir ce plan
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
