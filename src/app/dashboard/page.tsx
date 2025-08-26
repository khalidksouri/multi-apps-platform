'use client';

export default function DashboardPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-900 to-indigo-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">📊 Dashboard Parental</h1>
          <p className="text-2xl">Suivez les progrès de vos enfants</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
          {[
            { emoji: '👥', value: '3', label: 'Enfants actifs' },
            { emoji: '🎯', value: '247', label: 'Exercices réussis' },
            { emoji: '⏱️', value: '1h 30m', label: 'Temps aujourd\'hui' },
            { emoji: '🏆', value: '92%', label: 'Taux de réussite' }
          ].map((stat, i) => (
            <div key={i} className="bg-white/10 rounded-2xl p-6 text-center">
              <div className="text-4xl mb-2">{stat.emoji}</div>
              <div className="text-2xl font-bold mb-1">{stat.value}</div>
              <div className="text-gray-400 text-sm">{stat.label}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
