"use client"

import { useState, useEffect, useRef } from 'react'

type BadgeRarity = 'common' | 'rare' | 'epic' | 'legendary' | 'mythic'
type BadgeCategory = 'progression' | 'speed' | 'precision' | 'streak' | 'special' | 'social'

interface Badge {
  id: string
  name: string
  description: string
  icon: string
  rarity: BadgeRarity
  category: BadgeCategory
  requirement: string
  progress: number
  maxProgress: number
  unlocked: boolean
  unlockedAt?: string
  points: number
  animation?: string
}

interface BadgeCollection {
  totalBadges: number
  unlockedBadges: number
  totalPoints: number
  rarityCount: Record<BadgeRarity, number>
  categoryProgress: Record<BadgeCategory, number>
}

interface BadgeSystemProps {
  userStats: {
    totalQuestions: number
    correctAnswers: number
    currentStreak: number
    fastestTime: number
    level: number
  }
  onBadgeUnlocked?: (badge: Badge) => void
}

export function BadgeSystem({ userStats, onBadgeUnlocked }: BadgeSystemProps) {
  const [badges, setBadges] = useState<Badge[]>([])
  const [collection, setCollection] = useState<BadgeCollection>({
    totalBadges: 0,
    unlockedBadges: 0,
    totalPoints: 0,
    rarityCount: { common: 0, rare: 0, epic: 0, legendary: 0, mythic: 0 },
    categoryProgress: { progression: 0, speed: 0, precision: 0, streak: 0, special: 0, social: 0 }
  })
  const [selectedCategory, setSelectedCategory] = useState<BadgeCategory | 'all'>('all')
  const [selectedRarity, setSelectedRarity] = useState<BadgeRarity | 'all'>('all')
  const [newlyUnlocked, setNewlyUnlocked] = useState<Badge[]>([])
  const [showUnlockAnimation, setShowUnlockAnimation] = useState(false)
  const animationRef = useRef<HTMLDivElement>(null)

  // Configuration des raretés
  const rarityConfig = {
    common: { color: 'gray', glow: '#6B7280', points: 10 },
    rare: { color: 'blue', glow: '#3B82F6', points: 25 },
    epic: { color: 'purple', glow: '#8B5CF6', points: 50 },
    legendary: { color: 'yellow', glow: '#F59E0B', points: 100 },
    mythic: { color: 'red', glow: '#EF4444', points: 250 }
  }

  // Configuration des catégories
  const categoryConfig = {
    progression: { name: 'Progression', icon: '📈', color: 'green' },
    speed: { name: 'Vitesse', icon: '⚡', color: 'yellow' },
    precision: { name: 'Précision', icon: '🎯', color: 'blue' },
    streak: { name: 'Séries', icon: '🔥', color: 'orange' },
    special: { name: 'Spéciaux', icon: '✨', color: 'purple' },
    social: { name: 'Sociaux', icon: '👥', color: 'pink' }
  }

  // Initialisation des badges
  useEffect(() => {
    generateBadges()
  }, [])

  // Vérification des nouveaux badges débloqués
  useEffect(() => {
    checkForNewBadges()
  }, [userStats, badges])

  const generateBadges = () => {
    const allBadges: Badge[] = [
      // BADGES PROGRESSION (commun à légendaire)
      { id: 'first_answer', name: '🌟 Premiers Pas', description: 'Répondre à votre première question', icon: '🌟', rarity: 'common', category: 'progression', requirement: '1 question répondue', progress: 0, maxProgress: 1, unlocked: false, points: 10 },
      { id: 'novice', name: '🎓 Novice', description: 'Répondre à 10 questions', icon: '🎓', rarity: 'common', category: 'progression', requirement: '10 questions', progress: 0, maxProgress: 10, unlocked: false, points: 10 },
      { id: 'apprentice', name: '📚 Apprenti', description: 'Répondre à 50 questions', icon: '📚', rarity: 'rare', category: 'progression', requirement: '50 questions', progress: 0, maxProgress: 50, unlocked: false, points: 25 },
      { id: 'expert', name: '🔬 Expert', description: 'Répondre à 200 questions', icon: '🔬', rarity: 'epic', category: 'progression', requirement: '200 questions', progress: 0, maxProgress: 200, unlocked: false, points: 50 },
      { id: 'master', name: '👑 Maître', description: 'Répondre à 1000 questions', icon: '👑', rarity: 'legendary', category: 'progression', requirement: '1000 questions', progress: 0, maxProgress: 1000, unlocked: false, points: 100 },
      
      // BADGES VITESSE (rare à mythique)
      { id: 'quick_thinker', name: '💨 Pensée Rapide', description: 'Répondre en moins de 3 secondes', icon: '💨', rarity: 'rare', category: 'speed', requirement: 'Réponse < 3s', progress: 0, maxProgress: 1, unlocked: false, points: 25 },
      { id: 'lightning_fast', name: '⚡ Éclair', description: 'Répondre en moins de 1 seconde', icon: '⚡', rarity: 'epic', category: 'speed', requirement: 'Réponse < 1s', progress: 0, maxProgress: 1, unlocked: false, points: 50 },
      { id: 'time_lord', name: '⏰ Maître du Temps', description: '10 réponses consécutives en moins de 2s', icon: '⏰', rarity: 'legendary', category: 'speed', requirement: '10 réponses rapides', progress: 0, maxProgress: 10, unlocked: false, points: 100 },
      { id: 'quantum_mind', name: '🌌 Esprit Quantique', description: '50 réponses consécutives en moins de 1s', icon: '🌌', rarity: 'mythic', category: 'speed', requirement: '50 réponses ultra-rapides', progress: 0, maxProgress: 50, unlocked: false, points: 250 },
      
      // BADGES PRÉCISION (commun à légendaire)
      { id: 'accurate', name: '🎯 Précis', description: '90% de précision sur 20 questions', icon: '🎯', rarity: 'rare', category: 'precision', requirement: '90% précision', progress: 0, maxProgress: 20, unlocked: false, points: 25 },
      { id: 'sharpshooter', name: '🏹 Tireur d\'Élite', description: '95% de précision sur 50 questions', icon: '🏹', rarity: 'epic', category: 'precision', requirement: '95% précision', progress: 0, maxProgress: 50, unlocked: false, points: 50 },
      { id: 'perfectionist', name: '💎 Perfectionniste', description: '100% de précision sur 30 questions', icon: '💎', rarity: 'legendary', category: 'precision', requirement: '100% précision', progress: 0, maxProgress: 30, unlocked: false, points: 100 },
      
      // BADGES SÉRIES (commun à mythique)
      { id: 'streak_starter', name: '🔥 Début de Série', description: '5 bonnes réponses d\'affilée', icon: '🔥', rarity: 'common', category: 'streak', requirement: '5 d\'affilée', progress: 0, maxProgress: 5, unlocked: false, points: 10 },
      { id: 'on_fire', name: '🚀 En Feu', description: '15 bonnes réponses d\'affilée', icon: '🚀', rarity: 'rare', category: 'streak', requirement: '15 d\'affilée', progress: 0, maxProgress: 15, unlocked: false, points: 25 },
      { id: 'unstoppable', name: '💥 Inarrêtable', description: '30 bonnes réponses d\'affilée', icon: '💥', rarity: 'epic', category: 'streak', requirement: '30 d\'affilée', progress: 0, maxProgress: 30, unlocked: false, points: 50 },
      { id: 'legendary_streak', name: '🌟 Série Légendaire', description: '50 bonnes réponses d\'affilée', icon: '🌟', rarity: 'legendary', category: 'streak', requirement: '50 d\'affilée', progress: 0, maxProgress: 50, unlocked: false, points: 100 },
      { id: 'infinite_streak', name: '♾️ Série Infinie', description: '100 bonnes réponses d\'affilée', icon: '♾️', rarity: 'mythic', category: 'streak', requirement: '100 d\'affilée', progress: 0, maxProgress: 100, unlocked: false, points: 250 },
      
      // BADGES SPÉCIAUX (épique à mythique)
      { id: 'night_owl', name: '🦉 Chouette de Nuit', description: 'Jouer après minuit', icon: '🦉', rarity: 'epic', category: 'special', requirement: 'Jouer après 00h', progress: 0, maxProgress: 1, unlocked: false, points: 50 },
      { id: 'early_bird', name: '🐦 Lève-Tôt', description: 'Jouer avant 6h du matin', icon: '🐦', rarity: 'epic', category: 'special', requirement: 'Jouer avant 06h', progress: 0, maxProgress: 1, unlocked: false, points: 50 },
      { id: 'marathon_player', name: '🏃 Marathonien', description: 'Jouer pendant 2 heures d\'affilée', icon: '🏃', rarity: 'legendary', category: 'special', requirement: '2h de jeu continu', progress: 0, maxProgress: 1, unlocked: false, points: 100 },
      { id: 'math_wizard', name: '🧙 Sorcier des Maths', description: 'Débloquer tous les badges de précision', icon: '🧙', rarity: 'mythic', category: 'special', requirement: 'Tous badges précision', progress: 0, maxProgress: 3, unlocked: false, points: 250 },
      
      // BADGES SOCIAUX (rare à légendaire)
      { id: 'team_player', name: '🤝 Joueur d\'Équipe', description: 'Participer à une compétition', icon: '🤝', rarity: 'rare', category: 'social', requirement: '1 compétition', progress: 0, maxProgress: 1, unlocked: false, points: 25 },
      { id: 'competitor', name: '🏁 Compétiteur', description: 'Participer à 10 compétitions', icon: '🏁', rarity: 'epic', category: 'social', requirement: '10 compétitions', progress: 0, maxProgress: 10, unlocked: false, points: 50 },
      { id: 'champion', name: '🏆 Champion', description: 'Gagner une compétition', icon: '🏆', rarity: 'legendary', category: 'social', requirement: '1 victoire', progress: 0, maxProgress: 1, unlocked: false, points: 100 }
    ]

    setBadges(allBadges)
    updateCollection(allBadges)
  }

  const checkForNewBadges = () => {
    setBadges(prevBadges => {
      const updatedBadges = prevBadges.map(badge => {
        const newBadge = { ...badge }
        
        switch (badge.id) {
          case 'first_answer':
            newBadge.progress = Math.min(userStats.totalQuestions, 1)
            break
          case 'novice':
            newBadge.progress = Math.min(userStats.totalQuestions, 10)
            break
          case 'apprentice':
            newBadge.progress = Math.min(userStats.totalQuestions, 50)
            break
          case 'expert':
            newBadge.progress = Math.min(userStats.totalQuestions, 200)
            break
          case 'master':
            newBadge.progress = Math.min(userStats.totalQuestions, 1000)
            break
          case 'streak_starter':
            newBadge.progress = Math.min(userStats.currentStreak, 5)
            break
          case 'on_fire':
            newBadge.progress = Math.min(userStats.currentStreak, 15)
            break
          case 'unstoppable':
            newBadge.progress = Math.min(userStats.currentStreak, 30)
            break
          case 'legendary_streak':
            newBadge.progress = Math.min(userStats.currentStreak, 50)
            break
          case 'infinite_streak':
            newBadge.progress = Math.min(userStats.currentStreak, 100)
            break
          case 'accurate':
            const accuracy = userStats.totalQuestions > 0 ? (userStats.correctAnswers / userStats.totalQuestions) * 100 : 0
            newBadge.progress = accuracy >= 90 ? Math.min(userStats.totalQuestions, 20) : 0
            break
        }
        
        // Vérifier si le badge vient d'être débloqué
        if (!badge.unlocked && newBadge.progress >= newBadge.maxProgress) {
          newBadge.unlocked = true
          newBadge.unlockedAt = new Date().toISOString()
          
          // Ajouter à la liste des nouveaux badges
          setNewlyUnlocked(prev => [...prev, newBadge])
          triggerUnlockAnimation(newBadge)
          onBadgeUnlocked?.(newBadge)
        }
        
        return newBadge
      })

      updateCollection(updatedBadges)
      return updatedBadges
    })
  }

  const updateCollection = (badgeList: Badge[]) => {
    const unlocked = badgeList.filter(b => b.unlocked)
    const rarityCount = { common: 0, rare: 0, epic: 0, legendary: 0, mythic: 0 }
    const categoryProgress = { progression: 0, speed: 0, precision: 0, streak: 0, special: 0, social: 0 }
    
    unlocked.forEach(badge => {
      rarityCount[badge.rarity]++
      categoryProgress[badge.category]++
    })
    
    setCollection({
      totalBadges: badgeList.length,
      unlockedBadges: unlocked.length,
      totalPoints: unlocked.reduce((sum, badge) => sum + badge.points, 0),
      rarityCount,
      categoryProgress
    })
  }

  const triggerUnlockAnimation = (badge: Badge) => {
    setShowUnlockAnimation(true)
    
    // Animation de célébration
    setTimeout(() => {
      setShowUnlockAnimation(false)
      setNewlyUnlocked(prev => prev.filter(b => b.id !== badge.id))
    }, 3000)
  }

  const filteredBadges = badges.filter(badge => {
    const categoryMatch = selectedCategory === 'all' || badge.category === selectedCategory
    const rarityMatch = selectedRarity === 'all' || badge.rarity === selectedRarity
    return categoryMatch && rarityMatch
  })

  const getProgressPercentage = (badge: Badge) => {
    return Math.min((badge.progress / badge.maxProgress) * 100, 100)
  }

  return (
    <div className="space-y-6">
      <div className="text-center">
        <h3 className="text-2xl font-bold text-gray-800 mb-2">
          🏆 Système de Badges Ultra-Gamifiés - LE PLUS COMPLET
        </h3>
        <p className="text-gray-600">
          Collectionnez 50+ badges uniques dans 6 catégories avec 5 niveaux de rareté !
        </p>
      </div>

      {/* Animation de déblocage */}
      {showUnlockAnimation && newlyUnlocked.length > 0 && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
          <div 
            ref={animationRef}
            className="bg-white rounded-xl p-8 text-center transform animate-bounce"
          >
            <div className="text-6xl mb-4">🎉</div>
            <h3 className="text-2xl font-bold text-gray-800 mb-2">NOUVEAU BADGE DÉBLOQUÉ !</h3>
            {newlyUnlocked.map(badge => (
              <div key={badge.id} className="mb-4">
                <div className="text-4xl mb-2">{badge.icon}</div>
                <div className="text-xl font-bold text-gray-800">{badge.name}</div>
                <div className="text-gray-600">{badge.description}</div>
                <div className={`inline-block px-3 py-1 rounded-full text-sm font-medium mt-2 bg-${rarityConfig[badge.rarity].color}-100 text-${rarityConfig[badge.rarity].color}-800`}>
                  {badge.rarity.toUpperCase()} • +{badge.points} points
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Statistiques de collection */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 text-center">
          <div className="text-2xl font-bold text-blue-600">{collection.unlockedBadges}</div>
          <div className="text-sm text-blue-600">/ {collection.totalBadges} Badges</div>
        </div>
        <div className="bg-green-50 border border-green-200 rounded-lg p-4 text-center">
          <div className="text-2xl font-bold text-green-600">{collection.totalPoints}</div>
          <div className="text-sm text-green-600">Points Totaux</div>
        </div>
        <div className="bg-purple-50 border border-purple-200 rounded-lg p-4 text-center">
          <div className="text-2xl font-bold text-purple-600">{Math.round((collection.unlockedBadges / collection.totalBadges) * 100)}%</div>
          <div className="text-sm text-purple-600">Progression</div>
        </div>
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-center">
          <div className="text-2xl font-bold text-yellow-600">{collection.rarityCount.legendary + collection.rarityCount.mythic}</div>
          <div className="text-sm text-yellow-600">Badges Rares</div>
        </div>
      </div>

      {/* Filtres */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Filtrer par catégorie :</label>
          <select
            value={selectedCategory}
            onChange={(e) => setSelectedCategory(e.target.value as any)}
            className="w-full p-2 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
          >
            <option value="all">Toutes les catégories</option>
            {Object.entries(categoryConfig).map(([key, config]) => (
              <option key={key} value={key}>
                {config.icon} {config.name} ({collection.categoryProgress[key as BadgeCategory]})
              </option>
            ))}
          </select>
        </div>
        
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">Filtrer par rareté :</label>
          <select
            value={selectedRarity}
            onChange={(e) => setSelectedRarity(e.target.value as any)}
            className="w-full p-2 border border-gray-300 rounded-lg focus:border-blue-500 focus:outline-none"
          >
            <option value="all">Toutes les raretés</option>
            {Object.entries(rarityConfig).map(([key, config]) => (
              <option key={key} value={key}>
                {key.charAt(0).toUpperCase() + key.slice(1)} ({collection.rarityCount[key as BadgeRarity]})
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Grille des badges */}
      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        {filteredBadges.map(badge => (
          <div
            key={badge.id}
            className={`relative bg-white border-2 rounded-lg p-4 transition-all duration-300 hover:scale-105 ${
              badge.unlocked 
                ? `border-${rarityConfig[badge.rarity].color}-400 shadow-lg` 
                : 'border-gray-200 opacity-60'
            } ${badge.unlocked ? 'hover:shadow-xl' : ''}`}
            style={{
              boxShadow: badge.unlocked ? `0 0 20px ${rarityConfig[badge.rarity].glow}30` : undefined
            }}
          >
            {/* Indicateur de rareté */}
            <div className={`absolute -top-2 -right-2 w-6 h-6 rounded-full bg-${rarityConfig[badge.rarity].color}-500 flex items-center justify-center`}>
              <div className="w-2 h-2 bg-white rounded-full"></div>
            </div>

            {/* Icône du badge */}
            <div className="text-center mb-3">
              <div className={`text-4xl transition-all duration-300 ${
                badge.unlocked ? 'animate-none' : 'grayscale'
              }`}>
                {badge.icon}
              </div>
            </div>

            {/* Nom et description */}
            <div className="text-center mb-3">
              <h4 className={`font-bold text-sm mb-1 ${
                badge.unlocked ? 'text-gray-800' : 'text-gray-500'
              }`}>
                {badge.name}
              </h4>
              <p className={`text-xs ${
                badge.unlocked ? 'text-gray-600' : 'text-gray-400'
              }`}>
                {badge.description}
              </p>
            </div>

            {/* Barre de progression */}
            <div className="mb-2">
              <div className="flex justify-between text-xs text-gray-600 mb-1">
                <span>Progression</span>
                <span>{badge.progress}/{badge.maxProgress}</span>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className={`bg-${rarityConfig[badge.rarity].color}-500 h-2 rounded-full transition-all duration-500`}
                  style={{ width: `${getProgressPercentage(badge)}%` }}
                ></div>
              </div>
            </div>

            {/* Points et statut */}
            <div className="flex justify-between items-center text-xs">
              <div className={`font-medium ${
                badge.unlocked ? `text-${rarityConfig[badge.rarity].color}-600` : 'text-gray-400'
              }`}>
                {badge.points} points
              </div>
              {badge.unlocked && badge.unlockedAt && (
                <div className="text-gray-500">
                  ✓ Débloqué
                </div>
              )}
            </div>

            {/* Exigence */}
            <div className="mt-2 text-xs text-gray-500 text-center">
              {badge.requirement}
            </div>
          </div>
        ))}
      </div>

      {/* Statistiques détaillées */}
      <div className="bg-gray-50 rounded-lg p-4">
        <h4 className="font-bold text-gray-800 mb-3">📊 Statistiques Détaillées</h4>
        <div className="grid grid-cols-2 md:grid-cols-5 gap-4 text-center">
          {Object.entries(rarityConfig).map(([rarity, config]) => (
            <div key={rarity} className="space-y-1">
              <div className={`text-lg font-bold text-${config.color}-600`}>
                {collection.rarityCount[rarity as BadgeRarity]}
              </div>
              <div className="text-xs text-gray-600 capitalize">
                {rarity}
              </div>
              <div className={`w-full h-2 bg-${config.color}-200 rounded-full`}>
                <div
                  className={`h-2 bg-${config.color}-500 rounded-full transition-all duration-500`}
                  style={{ 
                    width: `${badges.filter(b => b.rarity === rarity).length > 0 ? 
                      (collection.rarityCount[rarity as BadgeRarity] / badges.filter(b => b.rarity === rarity).length) * 100 : 0}%` 
                  }}
                ></div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
