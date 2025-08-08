import Link from 'next/link'

export default function ExercisesPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-purple-50 to-pink-50 py-8">
      <div className="max-w-4xl mx-auto px-4 text-center">
        <h1 className="text-4xl font-bold text-gray-800 mb-8">
          Choisis ton niveau
        </h1>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {[1, 2, 3, 4, 5].map((level) => (
            <Link
              key={level}
              href={`/exercises/${level}`}
              className="bg-white rounded-2xl shadow-lg border-2 border-gray-200 hover:border-blue-300 hover:shadow-xl transition-all duration-300 p-6"
            >
              <div className="text-center">
                <div className="text-4xl mb-4">
                  {level === 1 ? '🎯' : level === 2 ? '🚀' : level === 3 ? '⭐' : level === 4 ? '🏆' : '👑'}
                </div>
                <h3 className="text-xl font-bold text-gray-800 mb-2">
                  Niveau {level}
                </h3>
                <p className="text-gray-600">
                  {level === 1 ? 'Découverte' : 
                   level === 2 ? 'Exploration' : 
                   level === 3 ? 'Maîtrise' : 
                   level === 4 ? 'Expert' : 'Champion'}
                </p>
                <div className="mt-4 bg-blue-500 text-white px-4 py-2 rounded-lg">
                  Commencer
                </div>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  )
}
