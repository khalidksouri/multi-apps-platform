import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

interface SearchEngine {
  name: string;
  icon: string;
  baseUrl: string;
  description: string;
  category: 'web' | 'academic' | 'media' | 'code' | 'ai';
}

const searchEngines: SearchEngine[] = [
  // Web General
  { name: 'Google', icon: '🔍', baseUrl: 'https://www.google.com/search?q=', description: 'Recherche web générale', category: 'web' },
  { name: 'Bing', icon: '🟦', baseUrl: 'https://www.bing.com/search?q=', description: 'Moteur Microsoft', category: 'web' },
  { name: 'DuckDuckGo', icon: '🦆', baseUrl: 'https://duckduckgo.com/?q=', description: 'Recherche privée', category: 'web' },
  
  // Académique
  { name: 'Scholar', icon: '🎓', baseUrl: 'https://scholar.google.com/scholar?q=', description: 'Articles académiques', category: 'academic' },
  { name: 'PubMed', icon: '🧬', baseUrl: 'https://pubmed.ncbi.nlm.nih.gov/?term=', description: 'Publications médicales', category: 'academic' },
  
  // Média
  { name: 'YouTube', icon: '📺', baseUrl: 'https://www.youtube.com/results?search_query=', description: 'Vidéos et tutoriels', category: 'media' },
  { name: 'Wikipedia', icon: '📖', baseUrl: 'https://en.wikipedia.org/wiki/Special:Search?search=', description: 'Encyclopédie libre', category: 'media' },
  { name: 'Reddit', icon: '👥', baseUrl: 'https://www.reddit.com/search/?q=', description: 'Discussions communautaires', category: 'media' },
  
  // Code
  { name: 'GitHub', icon: '💻', baseUrl: 'https://github.com/search?q=', description: 'Code et repositories', category: 'code' },
  { name: 'Stack Overflow', icon: '📚', baseUrl: 'https://stackoverflow.com/search?q=', description: 'Questions programmation', category: 'code' },
  
  // IA
  { name: 'ChatGPT', icon: '🤖', baseUrl: 'https://chat.openai.com/?q=', description: 'Assistant IA conversationnel', category: 'ai' },
  { name: 'Claude', icon: '🎭', baseUrl: 'https://claude.ai/?q=', description: 'Assistant IA Anthropic', category: 'ai' }
];

const categories = {
  web: { name: 'Web', icon: '🌐', color: 'blue' },
  academic: { name: 'Académique', icon: '🎓', color: 'purple' },
  media: { name: 'Média', icon: '📱', color: 'pink' },
  code: { name: 'Code', icon: '💻', color: 'green' },
  ai: { name: 'IA', icon: '🤖', color: 'orange' }
};

const App: React.FC = () => {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedEngines, setSelectedEngines] = useState<string[]>(['Google', 'Wikipedia', 'YouTube']);
  const [selectedCategory, setSelectedCategory] = useState<keyof typeof categories | 'all'>('all');
  const [searchHistory, setSearchHistory] = useState<string[]>([]);
  const [isNative, setIsNative] = useState(false);
  const [isSearching, setIsSearching] = useState(false);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    // Load search history
    const savedHistory = localStorage.getItem('multiai_history');
    if (savedHistory) {
      setSearchHistory(JSON.parse(savedHistory));
    }

    // Load selected engines
    const savedEngines = localStorage.getItem('multiai_engines');
    if (savedEngines) {
      setSelectedEngines(JSON.parse(savedEngines));
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const toggleEngine = async (engineName: string) => {
    await triggerHaptic();
    const newSelection = selectedEngines.includes(engineName)
      ? selectedEngines.filter(e => e !== engineName)
      : [...selectedEngines, engineName];
    
    setSelectedEngines(newSelection);
    localStorage.setItem('multiai_engines', JSON.stringify(newSelection));
  };

  const performSearch = async () => {
    if (!searchQuery.trim()) {
      await triggerHaptic(ImpactStyle.Heavy);
      return;
    }

    await triggerHaptic(ImpactStyle.Medium);
    setIsSearching(true);

    // Add to history
    const newHistory = [searchQuery, ...searchHistory.filter(h => h !== searchQuery)].slice(0, 10);
    setSearchHistory(newHistory);
    localStorage.setItem('multiai_history', JSON.stringify(newHistory));

    // Open search in selected engines
    const enginesToSearch = searchEngines.filter(engine => selectedEngines.includes(engine.name));
    
    if (enginesToSearch.length === 0) {
      alert('Veuillez sélectionner au moins un moteur de recherche');
      setIsSearching(false);
      return;
    }

    const encodedQuery = encodeURIComponent(searchQuery);
    
    // Simulate search delay
    setTimeout(() => {
      enginesToSearch.forEach((engine, index) => {
        setTimeout(() => {
          const searchUrl = engine.baseUrl + encodedQuery;
          if (Capacitor.isNativePlatform()) {
            // On mobile, open in system browser
            window.open(searchUrl, '_system');
          } else {
            // On web, open in new tab
            window.open(searchUrl, '_blank');
          }
        }, index * 500); // Stagger opening to avoid overwhelming
      });
      
      setIsSearching(false);
    }, 1000);
  };

  const quickSearch = async (query: string) => {
    await triggerHaptic();
    setSearchQuery(query);
  };

  const getFilteredEngines = () => {
    if (selectedCategory === 'all') return searchEngines;
    return searchEngines.filter(engine => engine.category === selectedCategory);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-600 to-slate-700">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">🤖 MultiAI Search</h1>
              <p className="text-white/80">Recherche multi-moteurs intelligente</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
            <div className="text-center mb-6">
              <h2 className="text-3xl font-bold text-white mb-2">🤖 MultiAI Search</h2>
              <p className="text-white/80">Recherche simultanée sur plusieurs moteurs</p>
            </div>

            {/* Search Input */}
            <div className="bg-white/90 rounded-2xl p-4 mb-6">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  onKeyPress={(e) => e.key === 'Enter' && performSearch()}
                  placeholder="Que voulez-vous rechercher ?"
                  className="flex-1 bg-transparent text-gray-800 placeholder-gray-500 text-lg outline-none"
                />
                <button
                  onClick={performSearch}
                  disabled={isSearching}
                  className={`px-6 py-2 rounded-xl font-bold transition-all ${
                    isSearching 
                      ? 'bg-gray-400 text-gray-200' 
                      : 'bg-blue-500 hover:bg-blue-600 text-white active:scale-95'
                  }`}
                >
                  {isSearching ? '⏳' : '🔍'}
                </button>
              </div>
            </div>

            {/* Quick Searches */}
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-6">
              <h3 className="text-white font-bold mb-3">⚡ Recherches rapides</h3>
              <div className="grid grid-cols-2 gap-2">
                {['React hooks', 'Machine learning', 'Climate change', 'JavaScript tutorial'].map((query, index) => (
                  <button
                    key={index}
                    onClick={() => quickSearch(query)}
                    className="bg-white/10 hover:bg-white/20 text-white text-sm p-3 rounded-lg transition-colors text-left"
                  >
                    {query}
                  </button>
                ))}
              </div>
            </div>

            {/* Category Filter */}
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-6">
              <h3 className="text-white font-bold mb-3">📂 Catégories</h3>
              <div className="grid grid-cols-3 gap-2">
                <button
                  onClick={() => setSelectedCategory('all')}
                  className={`p-3 rounded-xl transition-all ${
                    selectedCategory === 'all' ? 'bg-white/30' : 'bg-white/10 hover:bg-white/20'
                  }`}
                >
                  <div className="text-white text-lg">🌟</div>
                  <div className="text-white text-xs">Tout</div>
                </button>
                {Object.entries(categories).map(([key, cat]) => (
                  <button
                    key={key}
                    onClick={() => setSelectedCategory(key as keyof typeof categories)}
                    className={`p-3 rounded-xl transition-all ${
                      selectedCategory === key ? 'bg-white/30' : 'bg-white/10 hover:bg-white/20'
                    }`}
                  >
                    <div className="text-white text-lg">{cat.icon}</div>
                    <div className="text-white text-xs">{cat.name}</div>
                  </button>
                ))}
              </div>
            </div>

            {/* Engine Selection */}
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
              <h3 className="text-white font-bold mb-3">
                🔧 Moteurs sélectionnés ({selectedEngines.length})
              </h3>
              <div className="grid grid-cols-1 gap-2 max-h-60 overflow-y-auto">
                {getFilteredEngines().map(engine => (
                  <button
                    key={engine.name}
                    onClick={() => toggleEngine(engine.name)}
                    className={`p-3 rounded-lg border transition-all text-left ${
                      selectedEngines.includes(engine.name)
                        ? 'bg-blue-500/30 border-blue-400'
                        : 'bg-white/5 border-white/20 hover:bg-white/10'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <span className="text-2xl">{engine.icon}</span>
                      <div className="flex-1">
                        <div className="text-white font-medium">{engine.name}</div>
                        <div className="text-white/70 text-sm">{engine.description}</div>
                      </div>
                      <div className={`w-6 h-6 rounded-full border-2 ${
                        selectedEngines.includes(engine.name)
                          ? 'bg-blue-500 border-blue-500'
                          : 'border-white/30'
                      }`}>
                        {selectedEngines.includes(engine.name) && (
                          <div className="text-white text-center text-sm">✓</div>
                        )}
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            </div>

            {/* Search History */}
            {searchHistory.length > 0 && (
              <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mt-6">
                <h3 className="text-white font-bold mb-3">📜 Historique</h3>
                <div className="space-y-2">
                  {searchHistory.slice(0, 5).map((query, index) => (
                    <button
                      key={index}
                      onClick={() => quickSearch(query)}
                      className="w-full bg-white/5 hover:bg-white/10 text-white text-sm p-2 rounded-lg transition-colors text-left"
                    >
                      🔍 {query}
                    </button>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
