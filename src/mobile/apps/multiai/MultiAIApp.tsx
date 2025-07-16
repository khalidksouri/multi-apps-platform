import React, { useState } from 'react';

interface MultiAIAppProps {
  isNative?: boolean;
}

const MultiAIApp: React.FC<MultiAIAppProps> = ({ isNative = false }) => {
  const [query, setQuery] = useState('');

  const search = () => {
    if (query.trim()) {
      window.open(`https://www.google.com/search?q=${encodeURIComponent(query)}`, '_blank');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-800 via-gray-900 to-black p-4">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🤖 MultiAI</h1>
          <p className="text-white/80">Recherche {isNative ? 'Mobile' : 'Web'}</p>
        </div>

        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="space-y-4">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Que voulez-vous rechercher ?"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
              onKeyPress={(e) => e.key === 'Enter' && search()}
            />
            
            <button
              onClick={search}
              className="w-full bg-purple-500 hover:bg-purple-600 text-white font-bold py-4 rounded-xl transition-all"
            >
              🔍 Rechercher
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default MultiAIApp;
