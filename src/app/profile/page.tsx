'use client';

import { useLanguage } from '@/hooks/useLanguage';

export default function ProfilePage() {
  const { t } = useLanguage();

  const userStats = {
    name: 'Utilisateur Math4Child',
    level: 2,
    progress: 45,
    badges: [
      { id: '1', name: 'Premier pas', icon: '🏆' },
      { id: '2', name: 'Persévérant', icon: '⭐' },
    ]
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-600 via-purple-600 to-indigo-800 p-6">
      <div className="container mx-auto">
        <h1 className="text-3xl font-bold text-white mb-8 text-center">
          Profil Utilisateur
        </h1>
        
        <div className="bg-white/10 backdrop-blur-sm rounded-xl p-8 border border-white/20">
          <h2 className="text-xl font-bold text-white mb-4">{userStats.name}</h2>
          <p className="text-white/80 mb-4">{t('level')} {userStats.level}</p>
          <p className="text-white/80 mb-6">Progression: {userStats.progress}%</p>
          
          <h3 className="text-lg font-bold text-white mb-4">Badges obtenus</h3>
          <div className="flex gap-4">
            {userStats.badges.map((badge) => (
              <div key={badge.id} className="text-center">
                <div className="text-2xl mb-1">{badge.icon}</div>
                <div className="text-white/80 text-sm">{badge.name}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
