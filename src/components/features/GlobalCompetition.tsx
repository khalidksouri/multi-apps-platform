"use client"

import { useState, useEffect, useCallback } from 'react'

interface Participant {
  id: string
  name: string
  country: string
  flag: string
  score: number
  rank: number
  accuracy: number
  timeBonus: number
}

interface Competition {
  id: string
  name: string
  type: 'daily' | 'weekly' | 'monthly' | 'olympiad'
  startTime: number
  endTime: number
  participants: number
  prize: string
  difficulty: number
  isActive: boolean
}

interface CountryStats {
  country: string
  flag: string
  totalPoints: number
  averageRank: number
  participants: number
  topPlayer: string
}

interface GlobalCompetitionProps {
  userLevel: number
  onJoinCompetition?: (competitionId: string) => void
}

export function GlobalCompetition({ userLevel, onJoinCompetition }: GlobalCompetitionProps) {
  const [activeCompetitions, setActiveCompetitions] = useState<Competition[]>([])
  const [leaderboard, setLeaderboard] = useState<Participant[]>([])
  const [countryRankings, setCountryRankings] = useState<CountryStats[]>([])
  const [selectedTab, setSelectedTab] = useState<'competitions' | 'leaderboard' | 'countries'>('competitions')
  const [userRank, setUserRank] = useState<number>(0)
  const [userCountry] = useState('🇫🇷 France')
  const [isLoading, setIsLoading] = useState(true)

  // Simuler les données de compétition en temps réel
  useEffect(() => {
    generateCompetitions()
    generateLeaderboard()
    generateCountryRankings()
    
    // Mise à jour en temps réel
    const interval = setInterval(() => {
      updateRealTimeData()
    }, 5000)
    
    return () => clearInterval(interval)
  }, [])

  const generateCompetitions = () => {
    const competitions: Competition[] = [
      {
        id: 'daily_challenge',
        name: '🏆 Défi Quotidien Mondial',
        type: 'daily',
        startTime: Date.now(),
        endTime: Date.now() + 24 * 60 * 60 * 1000,
        participants: 156789,
        prize: '🥇 Badge Or + 500 points',
        difficulty: userLevel,
        isActive: true
      },
      {
        id: 'speed_tournament',
        name: '⚡ Tournoi de Vitesse',
        type: 'weekly',
        startTime: Date.now(),
        endTime: Date.now() + 7 * 24 * 60 * 60 * 1000,
        participants: 89234,
        prize: '🎖️ Trophée Vitesse',
        difficulty: userLevel + 1,
        isActive: true
      },
      {
        id: 'country_battle',
        name: '🌍 Bataille des Pays',
        type: 'weekly',
        startTime: Date.now(),
        endTime: Date.now() + 7 * 24 * 60 * 60 * 1000,
        participants: 234567,
        prize: '👑 Couronne Nationale',
        difficulty: userLevel,
        isActive: true
      },
      {
        id: 'math_olympiad',
        name: '🥇 Olympiades Math4Child',
        type: 'olympiad',
        startTime: Date.now() + 24 * 60 * 60 * 1000,
        endTime: Date.now() + 30 * 24 * 60 * 60 * 1000,
        participants: 1234567,
        prize: '🏆 Champion Mondial + 10000 points',
        difficulty: 5,
        isActive: false
      }
    ]
    
    setActiveCompetitions(competitions)
  }

  const generateLeaderboard = () => {
    const countries = ['🇺🇸', '🇨🇳', '🇮🇳', '🇧🇷', '🇫🇷', '🇩🇪', '🇯🇵', '🇬🇧', '🇰🇷', '🇨🇦']
    const names = [
      'Alex Chen', 'Sophie Martin', 'Lucas Silva', 'Emma Johnson', 'Raj Patel',
      'Marie Dubois', 'Yuki Tanaka', 'Ahmed Hassan', 'Anna Kowalski', 'Carlos Ruiz'
    ]
    
    const participants: Participant[] = names.map((name, index) => ({
      id: `player_${index}`,
      name,
      country: countries[index % countries.length],
      flag: countries[index % countries.length],
      score: Math.floor(Math.random() * 5000) + 15000 - (index * 500),
      rank: index + 1,
      accuracy: Math.floor(Math.random() * 20) + 80,
      timeBonus: Math.floor(Math.random() * 1000) + 500
    }))
    
    // Ajouter l'utilisateur
    participants.splice(Math.floor(Math.random() * 5) + 3, 0, {
      id: 'current_user',
      name: 'Toi 🌟',
      country: userCountry,
      flag: '🇫🇷',
      score: Math.floor(Math.random() * 3000) + 12000,
      rank: Math.floor(Math.random() * 5) + 4,
      accuracy: Math.floor(Math.random() * 15) + 75,
      timeBonus: Math.floor(Math.random() * 800) + 300
    })
    
    setLeaderboard(participants)
    setUserRank(participants.find(p => p.id === 'current_user')?.rank || 0)
  }

  const generateCountryRankings = () => {
    const countries: CountryStats[] = [
      { country: 'États-Unis', flag: '🇺🇸', totalPoints: 2456789, averageRank: 1245, participants: 45678, topPlayer: 'Alex Chen' },
      { country: 'Chine', flag: '🇨🇳', totalPoints: 2234567, averageRank: 1456, participants: 67890, topPlayer: 'Li Wei' },
      { country: 'Inde', flag: '🇮🇳', totalPoints: 1987654, averageRank: 1678, participants: 56789, topPlayer: 'Raj Patel' },
      { country: 'France', flag: '🇫🇷', totalPoints: 1876543, averageRank: 1234, participants: 34567, topPlayer: 'Sophie Martin' },
      { country: 'Brésil', flag: '🇧🇷', totalPoints: 1654321, averageRank: 1567, participants: 23456, topPlayer: 'Lucas Silva' },
      { country: 'Allemagne', flag: '🇩🇪', totalPoints: 1543210, averageRank: 1345, participants: 28901, topPlayer: 'Emma Mueller' },
      { country: 'Japon', flag: '🇯🇵', totalPoints: 1432109, averageRank: 1456, participants: 19876, topPlayer: 'Yuki Tanaka' },
      { country: 'Royaume-Uni', flag: '🇬🇧', totalPoints: 1321098, averageRank: 1567, participants: 21345, topPlayer: 'Emma Johnson' }
    ]
    
    setCountryRankings(countries)
    setIsLoading(false)
  }

  const updateRealTimeData = () => {
    // Simulation des mises à jour en temps réel
    setLeaderboard(prev => prev.map(participant => ({
      ...participant,
      score: participant.score + Math.floor(Math.random() * 100) - 25,
      accuracy: Math.min(100, Math.max(0, participant.accuracy + Math.floor(Math.random() * 6) - 3))
    })).sort((a, b) => b.score - a.score).map((participant, index) => ({
      ...participant,
      rank: index + 1
    })))

    setActiveCompetitions(prev => prev.map(comp => ({
      ...comp,
      participants: comp.participants + Math.floor(Math.random() * 50) - 10
    })))
  }

  const joinCompetition = (competitionId: string) => {
    const competition = activeCompetitions.find(c => c.id === competitionId)
    if (competition) {
      alert(`🎉 Vous avez rejoint: ${competition.name}!\n\nBonne chance champion!`)
      onJoinCompetition?.(competitionId)
    }
  }

  const formatTimeRemaining = (endTime: number) => {
    const remaining = endTime - Date.now()
    const hours = Math.floor(remaining / (1000 * 60 * 60))
    const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60))
    return `${hours}h ${minutes}m`
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto mb-4"></div>
          <p className="text-gray-600">🌍 Connexion au réseau mondial...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="space-y-4">
      <div className="text-center">
        <h3 className="text-lg font-bold text-gray-800 mb-2">
          🌍 Compétitions Mondiales - SYSTÈME LE PLUS AVANCÉ
        </h3>
        <p className="text-sm text-gray-600">
          Affrontez des millions de joueurs dans le monde entier !
        </p>
      </div>

      {/* Statistiques de l'utilisateur */}
      <div className="bg-gradient-to-r from-gold-50 to-yellow-50 border border-yellow-200 rounded-lg p-4">
        <div className="grid grid-cols-3 gap-4 text-center">
          <div>
            <div className="text-2xl font-bold text-yellow-700">{userRank}</div>
            <div className="text-sm text-yellow-600">Votre Rang Mondial</div>
          </div>
          <div>
            <div className="text-2xl font-bold text-blue-700">{userCountry}</div>
            <div className="text-sm text-blue-600">Votre Équipe</div>
          </div>
          <div>
            <div className="text-2xl font-bold text-green-700">2,453</div>
            <div className="text-sm text-green-600">Points Cette Semaine</div>
          </div>
        </div>
      </div>

      {/* Navigation par onglets */}
      <div className="flex bg-gray-100 rounded-lg p-1">
        {[
          { id: 'competitions', label: '🏆 Compétitions', count: activeCompetitions.length },
          { id: 'leaderboard', label: '📊 Classement', count: leaderboard.length },
          { id: 'countries', label: '🌍 Pays', count: countryRankings.length }
        ].map(tab => (
          <button
            key={tab.id}
            onClick={() => setSelectedTab(tab.id as any)}
            className={`flex-1 px-3 py-2 rounded-md font-medium transition-colors text-sm ${
              selectedTab === tab.id
                ? 'bg-white text-blue-600 shadow-sm'
                : 'text-gray-600 hover:text-gray-800'
            }`}
          >
            {tab.label} ({tab.count})
          </button>
        ))}
      </div>

      {/* Contenu des onglets */}
      {selectedTab === 'competitions' && (
        <div className="space-y-3">
          {activeCompetitions.map(competition => (
            <div key={competition.id} className="bg-white border border-gray-200 rounded-lg p-4">
              <div className="flex justify-between items-start mb-3">
                <div>
                  <h4 className="font-bold text-gray-800">{competition.name}</h4>
                  <p className="text-sm text-gray-600">
                    {competition.participants.toLocaleString()} participants
                  </p>
                </div>
                <div className="text-right">
                  <div className={`inline-block px-2 py-1 rounded-full text-xs font-medium ${
                    competition.isActive 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-yellow-100 text-yellow-800'
                  }`}>
                    {competition.isActive ? '🔴 LIVE' : '⏳ Bientôt'}
                  </div>
                  <div className="text-sm text-gray-600 mt-1">
                    {competition.isActive ? 'Finit dans: ' : 'Commence dans: '}
                    {formatTimeRemaining(competition.endTime)}
                  </div>
                </div>
              </div>
              
              <div className="mb-3">
                <div className="text-sm text-gray-600 mb-1">Prix:</div>
                <div className="font-semibold text-blue-600">{competition.prize}</div>
              </div>
              
              <div className="flex justify-between items-center">
                <div className="text-sm">
                  <span className="text-gray-600">Niveau: </span>
                  <span className="font-medium">Niveau {competition.difficulty}</span>
                </div>
                <button
                  onClick={() => joinCompetition(competition.id)}
                  disabled={!competition.isActive}
                  className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                    competition.isActive
                      ? 'bg-blue-500 hover:bg-blue-600 text-white'
                      : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                  }`}
                >
                  {competition.isActive ? '🚀 Rejoindre' : '⏰ Pas encore'}
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {selectedTab === 'leaderboard' && (
        <div className="bg-white border border-gray-200 rounded-lg overflow-hidden">
          <div className="bg-gradient-to-r from-blue-50 to-purple-50 p-3 border-b">
            <h4 className="font-bold text-gray-800">🏆 Classement Mondial - Temps Réel</h4>
          </div>
          <div className="divide-y divide-gray-100">
            {leaderboard.slice(0, 10).map(participant => (
              <div 
                key={participant.id}
                className={`p-3 flex items-center justify-between ${
                  participant.id === 'current_user' ? 'bg-yellow-50 border-l-4 border-yellow-400' : ''
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-sm ${
                    participant.rank === 1 ? 'bg-yellow-500 text-white' :
                    participant.rank === 2 ? 'bg-gray-400 text-white' :
                    participant.rank === 3 ? 'bg-orange-500 text-white' :
                    'bg-blue-100 text-blue-600'
                  }`}>
                    {participant.rank}
                  </div>
                  <div>
                    <div className="font-medium text-gray-800 flex items-center gap-2">
                      <span>{participant.flag}</span>
                      <span>{participant.name}</span>
                      {participant.id === 'current_user' && <span className="text-xs bg-yellow-200 px-2 py-1 rounded-full">TOI</span>}
                    </div>
                    <div className="text-sm text-gray-600">
                      Précision: {participant.accuracy}%
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="font-bold text-blue-600">{participant.score.toLocaleString()}</div>
                  <div className="text-xs text-gray-500">+{participant.timeBonus} bonus</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {selectedTab === 'countries' && (
        <div className="space-y-3">
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
            <h4 className="font-bold text-blue-800 mb-2">🥇 Bataille des Nations</h4>
            <p className="text-sm text-blue-700">
              Représentez la France et montez au classement mondial !
            </p>
          </div>
          
          {countryRankings.map((country, index) => (
            <div 
              key={country.country}
              className={`bg-white border border-gray-200 rounded-lg p-4 ${
                country.country === 'France' ? 'ring-2 ring-blue-400 bg-blue-50' : ''
              }`}
            >
              <div className="flex justify-between items-center">
                <div className="flex items-center gap-3">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold ${
                    index === 0 ? 'bg-yellow-500 text-white' :
                    index === 1 ? 'bg-gray-400 text-white' :
                    index === 2 ? 'bg-orange-500 text-white' :
                    'bg-gray-100 text-gray-600'
                  }`}>
                    {index + 1}
                  </div>
                  <div>
                    <div className="font-bold text-gray-800 flex items-center gap-2">
                      <span className="text-2xl">{country.flag}</span>
                      <span>{country.country}</span>
                      {country.country === 'France' && <span className="text-xs bg-blue-200 px-2 py-1 rounded-full">VOTRE ÉQUIPE</span>}
                    </div>
                    <div className="text-sm text-gray-600">
                      {country.participants.toLocaleString()} joueurs • Champion: {country.topPlayer}
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="font-bold text-green-600">{country.totalPoints.toLocaleString()}</div>
                  <div className="text-xs text-gray-500">points totaux</div>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Mise à jour en temps réel */}
      <div className="text-center">
        <div className="inline-flex items-center gap-2 bg-green-50 border border-green-200 rounded-full px-3 py-1">
          <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
          <span className="text-sm text-green-700 font-medium">Mise à jour en temps réel</span>
        </div>
      </div>
    </div>
  )
}
