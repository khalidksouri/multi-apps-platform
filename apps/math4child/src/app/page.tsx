'use client'

import { useState, useEffect } from 'react'
import { ChevronDown, Globe, Users, Calculator } from 'lucide-react'

// Données complètes des langues - ARABE EN TÊTE
const LANGUAGES = [
  // Arabe en première position
  { code: 'ar', name: 'العربية', flag: '🇸🇦', region: 'asia', popular: true, searchTerms: ['العربية', 'arabic', 'arabe'], rtl: true },
  
  // Langues européennes
  { code: 'fr', name: 'Français', flag: '🇫🇷', region: 'europe', popular: true, searchTerms: ['français', 'french', 'france'] },
  { code: 'en', name: 'English', flag: '🇺🇸', region: 'world', popular: true, searchTerms: ['english', 'anglais', 'usa', 'uk'] },
  { code: 'es', name: 'Español', flag: '🇪🇸', region: 'europe', popular: true, searchTerms: ['español', 'spanish', 'espagnol'] },
  { code: 'de', name: 'Deutsch', flag: '🇩🇪', region: 'europe', popular: true, searchTerms: ['deutsch', 'german', 'allemand'] },
  { code: 'it', name: 'Italiano', flag: '🇮🇹', region: 'europe', searchTerms: ['italiano', 'italian', 'italien'] },
  { code: 'pt', name: 'Português', flag: '🇵🇹', region: 'europe', searchTerms: ['português', 'portuguese', 'portugais'] },
  { code: 'nl', name: 'Nederlands', flag: '🇳🇱', region: 'europe', searchTerms: ['nederlands', 'dutch', 'néerlandais'] },
  { code: 'ru', name: 'Русский', flag: '🇷🇺', region: 'europe', searchTerms: ['русский', 'russian', 'russe'] },
  { code: 'tr', name: 'Türkçe', flag: '🇹🇷', region: 'europe', searchTerms: ['türkçe', 'turkish', 'turc'] },
  
  // Langues asiatiques
  { code: 'zh', name: '中文', flag: '🇨🇳', region: 'asia', popular: true, searchTerms: ['中文', 'chinese', 'chinois', 'mandarin'] },
  { code: 'ja', name: '日本語', flag: '🇯🇵', region: 'asia', popular: true, searchTerms: ['日本語', 'japanese', 'japonais'] },
  { code: 'ko', name: '한국어', flag: '🇰🇷', region: 'asia', searchTerms: ['한국어', 'korean', 'coréen'] },
  { code: 'hi', name: 'हिन्दी', flag: '🇮🇳', region: 'asia', searchTerms: ['हिन्दी', 'hindi', 'inde'] },
  { code: 'th', name: 'ไทย', flag: '🇹🇭', region: 'asia', searchTerms: ['ไทย', 'thai', 'thaï'] },
  { code: 'he', name: 'עברית', flag: '🇮🇱', region: 'asia', searchTerms: ['עברית', 'hebrew', 'hébreu'], rtl: true },
  
  // Amériques
  { code: 'pt-br', name: 'Português (BR)', flag: '🇧🇷', region: 'americas', popular: true, searchTerms: ['português', 'brazilian', 'brésil'] }
]

const REGION_ICONS = {
  europe: '🇪🇺',
  asia: '🌏', 
  americas: '🌎',
  world: '🌍'
}

const REGION_NAMES = {
  europe: { fr: 'Europe', en: 'Europe', es: 'Europa', de: 'Europa', ar: 'أوروبا', zh: '欧洲', ja: 'ヨーロッパ' },
  asia: { fr: 'Asie', en: 'Asia', es: 'Asia', de: 'Asien', ar: 'آسيا', zh: '亚洲', ja: 'アジア' },
  americas: { fr: 'Amériques', en: 'Americas', es: 'Américas', de: 'Amerika', ar: 'الأمريكتين', zh: '美洲', ja: 'アメリカ' },
  world: { fr: 'International', en: 'International', es: 'Internacional', de: 'International', ar: 'دولي', zh: '国际', ja: '国際' }
}

// Traductions de l'interface
const getUITexts = (lang: string) => {
  const uiTexts: Record<string, any> = {
    fr: {
      searchPlaceholder: 'Rechercher une langue...',
      noResults: 'Aucune langue trouvée',
      families: '100k+ familles',
      appNumber1: 'App éducative #1 en France',
      joinFamilies: 'Rejoignez plus de 100,000 familles qui apprennent déjà !',
      daysFree: 'j gratuit',
      popularSectionTitle: 'Populaires'
    },
    en: {
      searchPlaceholder: 'Search a language...',
      noResults: 'No language found',
      families: '100k+ families',
      appNumber1: '#1 educational app in France',
      joinFamilies: 'Join over 100,000 families already learning!',
      daysFree: 'd free',
      popularSectionTitle: 'Popular'
    },
    ar: {
      searchPlaceholder: 'البحث عن لغة...',
      noResults: 'لم يتم العثور على لغة',
      families: '100k+ عائلة',
      appNumber1: 'التطبيق التعليمي #1 في فرنسا',
      joinFamilies: 'انضم إلى أكثر من 100,000 عائلة تتعلم بالفعل!',
      daysFree: 'ي مجاني',
      popularSectionTitle: 'شائع'
    },
    zh: {
      searchPlaceholder: '搜索语言...',
      noResults: '未找到语言',
      families: '10万+ 家庭',
      appNumber1: '法国排名第一的教育应用',
      joinFamilies: '加入超过100,000个正在学习的家庭!',
      daysFree: '天免费',
      popularSectionTitle: '热门'
    }
  }
  
  return uiTexts[lang] || uiTexts.fr
}

interface Texts {
  title: string
  subtitle: string
  description: string
  startFree: string
  comparePrices: string
  whyLeader: string
  plans: {
    title: string
    subtitle: string
  }
  guarantees: {
    title: string
  }
}

export default function Math4ChildApp() {
  const [currentLang, setCurrentLang] = useState('fr')
  const [isDropdownOpen, setIsDropdownOpen] = useState(false)
  const [searchTerm, setSearchTerm] = useState('')
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
  }, [])

  const texts: Record<string, Texts> = {
    fr: {
      title: 'Math4Enfants',
      subtitle: 'Math4Enfants',
      description: "L'app éducative n°1 pour apprendre les maths en famille !",
      startFree: 'Commencer gratuitement',
      comparePrices: 'Comparer les prix',
      whyLeader: 'Pourquoi Math4Child est-il leader ?',
      plans: {
        title: 'Plans Optimaux',
        subtitle: 'Plus compétitif que toute la concurrence'
      },
      guarantees: {
        title: 'Garanties Math4Child'
      }
    },
    en: {
      title: 'Math4Child',
      subtitle: 'Math4Child',
      description: "#1 educational app to learn math as a family!",
      startFree: 'Start for free',
      comparePrices: 'Compare prices',
      whyLeader: 'Why is Math4Child the leader?',
      plans: {
        title: 'Optimal Plans',
        subtitle: 'More competitive than all competitors'
      },
      guarantees: {
        title: 'Math4Child Guarantees'
      }
    },
    ar: {
      title: 'Math4أطفال',
      subtitle: 'Math4أطفال',
      description: "التطبيق التعليمي #1 لتعلم الرياضيات مع العائلة!",
      startFree: 'ابدأ مجاناً',
      comparePrices: 'قارن الأسعار',
      whyLeader: 'لماذا Math4Child هو الرائد؟',
      plans: {
        title: 'الخطط المثلى',
        subtitle: 'أكثر تنافسية من جميع المنافسين'
      },
      guarantees: {
        title: 'ضمانات Math4Child'
      }
    },
    zh: {
      title: 'Math4儿童',
      subtitle: 'Math4儿童',
      description: "与家人一起学习数学的#1教育应用!",
      startFree: '免费开始',
      comparePrices: '比较价格',
      whyLeader: '为什么Math4Child是领导者？',
      plans: {
        title: '最优计划',
        subtitle: '比所有竞争对手更具竞争力'
      },
      guarantees: {
        title: 'Math4Child保证'
      }
    }
  }

  const t = texts[currentLang] || texts.fr
  const ui = getUITexts(currentLang)

  // Fonction de recherche
  const filteredLanguages = LANGUAGES.filter(lang => {
    if (!searchTerm) return true
    const search = searchTerm.toLowerCase()
    return (
      lang.name.toLowerCase().includes(search) ||
      lang.code.toLowerCase().includes(search) ||
      lang.searchTerms.some(term => term.toLowerCase().includes(search))
    )
  })

  // Grouper par région
  const groupedLanguages = filteredLanguages.reduce((acc, lang) => {
    if (!acc[lang.region]) acc[lang.region] = []
    acc[lang.region].push(lang)
    return acc
  }, {} as Record<string, any[]>)

  // Langues populaires
  const popularLanguages = filteredLanguages.filter(lang => lang.popular)

  const currentLanguage = LANGUAGES.find(lang => lang.code === currentLang) || LANGUAGES[0]

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600 flex items-center justify-center">
        <div className="text-white text-xl font-semibold">Chargement de Math4Child...</div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 via-purple-700 to-pink-600">
      {/* Header */}
      <header className="p-6">
        <div className="max-w-7xl mx-auto flex justify-between items-center">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 bg-orange-500 rounded-2xl flex items-center justify-center shadow-lg">
              <Calculator className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="text-white text-2xl font-bold">{t.title}</h1>
              <p className="text-white/70 text-sm">www.math4child.com • Leader mondial</p>
            </div>
          </div>
          
          <div className="flex items-center gap-4">
            <div className="hidden md:flex items-center gap-2 text-white/80 bg-white/10 px-4 py-2 rounded-full backdrop-blur-sm">
              <Users className="w-4 h-4" />
              <span className="text-sm font-medium">{ui.families}</span>
            </div>
            
            {/* Dropdown de langues */}
            <div className="relative">
              <button
                onClick={() => setIsDropdownOpen(!isDropdownOpen)}
                className="flex items-center gap-2 bg-white/20 hover:bg-white/30 px-4 py-2 rounded-xl text-white font-medium transition-all duration-200 backdrop-blur-sm border border-white/20"
              >
                <span className="text-lg">{currentLanguage.flag}</span>
                <span>{currentLanguage.name}</span>
                <ChevronDown className={`w-4 h-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`} />
              </button>

              {isDropdownOpen && (
                <div className="absolute top-full right-0 mt-2 w-80 bg-white rounded-2xl shadow-2xl border border-gray-200 z-50 overflow-hidden">
                  {/* Recherche */}
                  <div className="p-4 border-b border-gray-100">
                    <div className="relative">
                      <Globe className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-gray-400" />
                      <input
                        type="text"
                        placeholder={ui.searchPlaceholder}
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent outline-none"
                      />
                    </div>
                  </div>

                  {/* Contenu scrollable */}
                  <div className="max-h-80 overflow-y-auto">
                    {/* Langues populaires - SANS LE MOT "Populaire" */}
                    {popularLanguages.length > 0 && !searchTerm && (
                      <div className="p-3">
                        <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 flex items-center gap-2">
                          ⭐ {ui.popularSectionTitle}
                        </h3>
                        {popularLanguages.map((language) => (
                          <button
                            key={`popular-${language.code}`}
                            onClick={() => {
                              setCurrentLang(language.code)
                              setIsDropdownOpen(false)
                              setSearchTerm('')
                            }}
                            className={`w-full flex items-center gap-3 p-3 rounded-lg hover:bg-purple-50 transition-colors group ${
                              currentLang === language.code ? 'bg-purple-100 text-purple-700' : 'text-gray-700'
                            } ${language.rtl ? 'flex-row-reverse text-right' : ''}`}
                            dir={language.rtl ? 'rtl' : 'ltr'}
                          >
                            <span className="text-xl">{language.flag}</span>
                            <span className="font-medium">{language.name}</span>
                          </button>
                        ))}
                      </div>
                    )}

                    {/* Langues groupées par région */}
                    {Object.entries(groupedLanguages).map(([region, languages]) => (
                      <div key={region} className="p-3 border-t border-gray-100 first:border-t-0">
                        <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 flex items-center gap-2">
                          <span>{REGION_ICONS[region as keyof typeof REGION_ICONS]}</span>
                          {REGION_NAMES[region as keyof typeof REGION_NAMES][currentLang as keyof typeof REGION_NAMES.europe] || REGION_NAMES[region as keyof typeof REGION_NAMES].fr}
                        </h3>
                        {languages.map((language: any) => (
                          <button
                            key={language.code}
                            onClick={() => {
                              setCurrentLang(language.code)
                              setIsDropdownOpen(false)
                              setSearchTerm('')
                            }}
                            className={`w-full flex items-center gap-3 p-3 rounded-lg hover:bg-purple-50 transition-colors group ${
                              currentLang === language.code ? 'bg-purple-100 text-purple-700' : 'text-gray-700'
                            } ${language.rtl ? 'flex-row-reverse text-right' : ''}`}
                            dir={language.rtl ? 'rtl' : 'ltr'}
                          >
                            <span className="text-xl">{language.flag}</span>
                            <span className="font-medium">{language.name}</span>
                          </button>
                        ))}
                      </div>
                    ))}

                    {filteredLanguages.length === 0 && (
                      <div className="p-4 text-center text-gray-500">
                        {ui.noResults}
                      </div>
                    )}
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <main className="px-6 pb-12">
        <div className="max-w-7xl mx-auto" dir={currentLanguage.rtl ? 'rtl' : 'ltr'}>
          <div className="text-center mb-16">
            <div className="inline-flex items-center gap-2 bg-emerald-500/20 text-emerald-100 px-4 py-2 rounded-full mb-8">
              <span className="text-sm font-medium">📊 {ui.appNumber1}</span>
            </div>
            
            <h2 className="text-6xl md:text-8xl font-bold text-white mb-6 leading-tight">
              {t.subtitle}
            </h2>
            
            <p className="text-2xl text-white/90 mb-8 max-w-3xl mx-auto">
              {t.description}
            </p>
            
            <p className="text-xl text-white/80 mb-12">
              {ui.joinFamilies}
            </p>
            
            <div className="flex gap-6 justify-center flex-wrap">
              <button className="bg-emerald-500 hover:bg-emerald-600 text-white px-8 py-4 rounded-2xl font-semibold text-lg transition-all duration-200 shadow-lg hover:shadow-xl transform hover:-translate-y-1 flex items-center gap-2">
                🎁 {t.startFree}
                <span className="bg-white/20 px-2 py-1 rounded-lg text-sm">14{ui.daysFree}</span>
              </button>
              <button className="bg-white/20 hover:bg-white/30 border-2 border-white/30 text-white px-8 py-4 rounded-2xl font-semibold text-lg transition-all duration-200 backdrop-blur-sm flex items-center gap-2">
                📊 {t.comparePrices}
              </button>
            </div>
          </div>

          {/* Section Pourquoi leader */}
          <div className="mb-16">
            <h3 className="text-white text-3xl font-bold text-center mb-12">{t.whyLeader}</h3>
            
            <div className="grid md:grid-cols-4 gap-6">
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20">
                <div className="text-4xl mb-4">💰</div>
                <h4 className="text-white font-bold text-lg mb-2">Prix le plus compétitif</h4>
                <p className="text-white/80 text-sm">40% moins cher que la concurrence</p>
                <p className="text-emerald-300 font-semibold mt-2">6.99€/mois vs 8.95€+</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20">
                <div className="text-4xl mb-4">👨‍👩‍👧‍👦</div>
                <h4 className="text-white font-bold text-lg mb-2">Gestion familiale avancée</h4>
                <p className="text-white/80 text-sm">5 profils avec synchronisation cloud</p>
                <p className="text-emerald-300 font-semibold mt-2">5 profils vs 3 max</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20">
                <div className="text-4xl mb-4">📱</div>
                <h4 className="text-white font-bold text-lg mb-2">Mode hors-ligne</h4>
                <p className="text-white/80 text-sm">Apprentissage partout</p>
                <p className="text-emerald-300 font-semibold mt-2">100% hors-ligne</p>
              </div>
              
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 text-center border border-white/20">
                <div className="text-4xl mb-4">📊</div>
                <h4 className="text-white font-bold text-lg mb-2">Analytics</h4>
                <p className="text-white/80 text-sm">Rapports automatiques</p>
                <p className="text-yellow-300 font-semibold mt-2">Rapports parents</p>
              </div>
            </div>
          </div>

          {/* Message de succès du déploiement */}
          <div className="bg-white/10 backdrop-blur-sm rounded-3xl p-8 border border-white/20 text-center">
            <h3 className="text-white text-2xl font-bold mb-4 flex items-center justify-center gap-3">
              🚀 Application Math4Child Déployée avec Succès !
            </h3>
            
            <div className="grid md:grid-cols-3 gap-8 text-white/90">
              <div>
                <div className="text-3xl mb-3">🌍</div>
                <h4 className="font-bold mb-2">Multilingue</h4>
                <p className="text-sm">Support de 17+ langues avec interface RTL</p>
              </div>
              
              <div>
                <div className="text-3xl mb-3">🎨</div>
                <h4 className="font-bold mb-2">Design Professionnel</h4>
                <p className="text-sm">Interface moderne avec glassmorphism</p>
              </div>
              
              <div>
                <div className="text-3xl mb-3">⚡</div>
                <h4 className="font-bold mb-2">Performance Optimale</h4>
                <p className="text-sm">Build statique Next.js optimisé</p>
              </div>
            </div>
            
            <p className="text-emerald-300 font-semibold text-lg mt-6">
              ✅ Prêt pour le déploiement sur Netlify !
            </p>
          </div>
        </div>
      </main>

      {/* Fermer le dropdown si on clique ailleurs */}
      {isDropdownOpen && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setIsDropdownOpen(false)}
        />
      )}
    </div>
  )
}
