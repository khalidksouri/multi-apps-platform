#!/bin/bash

# update-enhanced-apps.sh - Script pour mettre à jour toutes les applications avec leurs versions avancées
# Ce script remplace les fichiers App.tsx avec les versions complètes et fonctionnelles

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    printf "║%-62s║\n" "$1"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}🚀 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Fonction pour mettre à jour MultiAI Search
update_multiai() {
    print_step "Mise à jour de MultiAI Search..."
    
    cd "apps/multiai"
    
    cat > src/App.tsx << 'EOF'
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
EOF
    
    cd ../..
    print_success "MultiAI Search mis à jour"
}

# Fonction pour mettre à jour AI4Kids
update_ai4kids() {
    print_step "Mise à jour de AI4Kids..."
    
    cd "apps/ai4kids"
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

// Données éducatives
const mathQuestions = [
  { question: "2 + 3 = ?", answer: 5, options: [4, 5, 6, 7] },
  { question: "7 - 4 = ?", answer: 3, options: [2, 3, 4, 5] },
  { question: "3 × 4 = ?", answer: 12, options: [10, 11, 12, 13] },
  { question: "15 ÷ 3 = ?", answer: 5, options: [4, 5, 6, 7] },
  { question: "6 + 9 = ?", answer: 15, options: [14, 15, 16, 17] },
];

const animals = [
  { name: "🦁 Lion", sound: "Roar!", fact: "Les lions peuvent courir jusqu'à 80 km/h !" },
  { name: "🐘 Éléphant", sound: "Trumpet!", fact: "Les éléphants peuvent se souvenir pendant 25 ans !" },
  { name: "🐧 Pingouin", sound: "Squawk!", fact: "Les pingouins peuvent nager jusqu'à 35 km/h !" },
  { name: "🦒 Girafe", sound: "Hum!", fact: "Les girafes ont le même nombre de vertèbres que nous !" },
  { name: "🐨 Koala", sound: "Grunt!", fact: "Les koalas dorment 20 heures par jour !" },
];

const colors = [
  { name: "Rouge", hex: "#ef4444", emoji: "🔴" },
  { name: "Bleu", hex: "#3b82f6", emoji: "🔵" },
  { name: "Vert", hex: "#10b981", emoji: "🟢" },
  { name: "Jaune", hex: "#f59e0b", emoji: "🟡" },
  { name: "Violet", hex: "#8b5cf6", emoji: "🟣" },
  { name: "Orange", hex: "#f97316", emoji: "🟠" },
];

type ActivityType = 'math' | 'animals' | 'colors' | 'home';

const App: React.FC = () => {
  const [currentActivity, setCurrentActivity] = useState<ActivityType>('home');
  const [isNative, setIsNative] = useState(false);
  const [score, setScore] = useState(0);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [showFeedback, setShowFeedback] = useState('');

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    // Charger le score
    const savedScore = localStorage.getItem('ai4kids_score');
    if (savedScore) {
      setScore(parseInt(savedScore));
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const saveScore = (newScore: number) => {
    setScore(newScore);
    localStorage.setItem('ai4kids_score', newScore.toString());
  };

  const handleMathAnswer = async (selectedAnswer: number) => {
    await triggerHaptic();
    const correct = selectedAnswer === mathQuestions[currentQuestion].answer;
    
    if (correct) {
      const newScore = score + 1;
      saveScore(newScore);
      setShowFeedback('🎉 Correct !');
      await triggerHaptic(ImpactStyle.Medium);
    } else {
      setShowFeedback('❌ Essaie encore !');
      await triggerHaptic(ImpactStyle.Heavy);
    }

    setTimeout(() => {
      setShowFeedback('');
      if (currentQuestion < mathQuestions.length - 1) {
        setCurrentQuestion(currentQuestion + 1);
      } else {
        setCurrentQuestion(0);
      }
    }, 1500);
  };

  const playAnimalSound = async (animal: typeof animals[0]) => {
    await triggerHaptic(ImpactStyle.Light);
    setShowFeedback(`${animal.name} fait : ${animal.sound}`);
    setTimeout(() => setShowFeedback(''), 2000);
  };

  const showColorInfo = async (color: typeof colors[0]) => {
    await triggerHaptic(ImpactStyle.Light);
    setShowFeedback(`${color.emoji} ${color.name}`);
    setTimeout(() => setShowFeedback(''), 2000);
  };

  const renderHomeScreen = () => (
    <div className="text-center space-y-6">
      <div className="text-8xl mb-4">🎨</div>
      <h2 className="text-3xl font-bold text-white mb-6">AI4Kids</h2>
      <p className="text-white/80 mb-8">Apprends en t'amusant !</p>
      
      <div className="grid grid-cols-1 gap-4">
        <button
          onClick={() => setCurrentActivity('math')}
          className="bg-blue-500/30 hover:bg-blue-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🧮</div>
          <div className="text-white font-bold text-lg">Mathématiques</div>
          <div className="text-white/70 text-sm">Résous des calculs amusants</div>
        </button>

        <button
          onClick={() => setCurrentActivity('animals')}
          className="bg-green-500/30 hover:bg-green-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🦁</div>
          <div className="text-white font-bold text-lg">Animaux</div>
          <div className="text-white/70 text-sm">Découvre le monde animal</div>
        </button>

        <button
          onClick={() => setCurrentActivity('colors')}
          className="bg-purple-500/30 hover:bg-purple-500/50 backdrop-blur-lg border border-white/20 rounded-2xl p-6 transition-all duration-200 active:scale-95"
        >
          <div className="text-4xl mb-2">🌈</div>
          <div className="text-white font-bold text-lg">Couleurs</div>
          <div className="text-white/70 text-sm">Apprends les couleurs</div>
        </button>
      </div>

      <div className="mt-8 bg-white/10 backdrop-blur-lg rounded-xl p-4 border border-white/20">
        <div className="text-white/70 text-sm">Score total</div>
        <div className="text-2xl font-bold text-yellow-300">{score} points</div>
      </div>
    </div>
  );

  const renderMathActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🧮</div>
      <h3 className="text-2xl font-bold text-white mb-6">Mathématiques</h3>
      
      <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-6">
        <div className="text-3xl font-bold text-white mb-6">
          {mathQuestions[currentQuestion].question}
        </div>
        
        <div className="grid grid-cols-2 gap-4">
          {mathQuestions[currentQuestion].options.map((option, index) => (
            <button
              key={index}
              onClick={() => handleMathAnswer(option)}
              className="bg-blue-500/30 hover:bg-blue-500/50 text-white font-bold py-4 px-6 rounded-xl transition-all duration-200 active:scale-95 text-xl"
            >
              {option}
            </button>
          ))}
        </div>
      </div>

      <div className="text-white/70">
        Question {currentQuestion + 1} sur {mathQuestions.length}
      </div>
      <div className="text-yellow-300 font-bold">Score: {score}</div>
    </div>
  );

  const renderAnimalsActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🦁</div>
      <h3 className="text-2xl font-bold text-white mb-6">Animaux</h3>
      
      <div className="grid grid-cols-1 gap-4 mb-6">
        {animals.map((animal, index) => (
          <div key={index} className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <button
              onClick={() => playAnimalSound(animal)}
              className="w-full text-left hover:bg-white/10 rounded-xl p-4 transition-colors"
            >
              <div className="text-4xl mb-2">{animal.name}</div>
              <div className="text-white/70 text-sm">{animal.fact}</div>
            </button>
          </div>
        ))}
      </div>
    </div>
  );

  const renderColorsActivity = () => (
    <div className="text-center">
      <button
        onClick={() => setCurrentActivity('home')}
        className="mb-6 bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>
      
      <div className="text-6xl mb-4">🌈</div>
      <h3 className="text-2xl font-bold text-white mb-6">Couleurs</h3>
      
      <div className="grid grid-cols-2 gap-4">
        {colors.map((color, index) => (
          <button
            key={index}
            onClick={() => showColorInfo(color)}
            className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 transition-all duration-200 active:scale-95 hover:bg-white/20"
            style={{ backgroundColor: `${color.hex}40` }}
          >
            <div className="text-4xl mb-2">{color.emoji}</div>
            <div className="text-white font-bold">{color.name}</div>
          </button>
        ))}
      </div>
    </div>
  );

  const renderCurrentActivity = () => {
    switch (currentActivity) {
      case 'math':
        return renderMathActivity();
      case 'animals':
        return renderAnimalsActivity();
      case 'colors':
        return renderColorsActivity();
      default:
        return renderHomeScreen();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-500 to-rose-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">🎨 AI4Kids</h1>
              <p className="text-white/80">Application Éducative</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Contenu principal */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 min-h-[500px]">
            {renderCurrentActivity()}
          </div>

          {/* Feedback */}
          {showFeedback && (
            <div className="fixed inset-0 flex items-center justify-center z-50 bg-black/50">
              <div className="bg-white rounded-2xl p-8 max-w-sm mx-4 text-center transform animate-pulse">
                <div className="text-4xl mb-4">{showFeedback.includes('🎉') ? '🎉' : showFeedback.includes('❌') ? '❌' : '🔊'}</div>
                <div className="text-2xl font-bold text-gray-800">{showFeedback}</div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default App;
EOF
    
    cd ../..
    print_success "AI4Kids mis à jour"
}

# Fonction pour mettre à jour BudgetCron (version simplifiée)
update_budgetcron() {
    print_step "Mise à jour de BudgetCron..."
    
    cd "apps/budgetcron"
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

interface Transaction {
  id: string;
  type: 'income' | 'expense';
  amount: number;
  category: string;
  description: string;
  date: string;
}

const categories = {
  income: ['💼 Salaire', '💰 Freelance', '🎁 Bonus', '📈 Investissements'],
  expense: ['🛒 Courses', '🏠 Logement', '🚗 Transport', '🍕 Restaurant', '🎮 Loisirs', '💊 Santé']
};

const App: React.FC = () => {
  const [currentView, setCurrentView] = useState<'dashboard' | 'add'>('dashboard');
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [isNative, setIsNative] = useState(false);
  
  // Formulaire
  const [amount, setAmount] = useState('');
  const [type, setType] = useState<'income' | 'expense'>('expense');
  const [category, setCategory] = useState('');
  const [description, setDescription] = useState('');

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    const savedTransactions = localStorage.getItem('budgetcron_transactions');
    if (savedTransactions) {
      setTransactions(JSON.parse(savedTransactions));
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const addTransaction = async () => {
    if (!amount || !category) {
      await triggerHaptic(ImpactStyle.Heavy);
      alert('Veuillez remplir tous les champs');
      return;
    }

    await triggerHaptic(ImpactStyle.Medium);
    
    const newTransaction: Transaction = {
      id: Date.now().toString(),
      type,
      amount: parseFloat(amount),
      category,
      description,
      date: new Date().toISOString().split('T')[0]
    };

    const updatedTransactions = [newTransaction, ...transactions];
    setTransactions(updatedTransactions);
    localStorage.setItem('budgetcron_transactions', JSON.stringify(updatedTransactions));
    
    setAmount('');
    setCategory('');
    setDescription('');
    setCurrentView('dashboard');
  };

  const getTotalIncome = () => transactions.filter(t => t.type === 'income').reduce((sum, t) => sum + t.amount, 0);
  const getTotalExpenses = () => transactions.filter(t => t.type === 'expense').reduce((sum, t) => sum + t.amount, 0);
  const getBalance = () => getTotalIncome() - getTotalExpenses();

  const renderDashboard = () => {
    const balance = getBalance();
    
    return (
      <div className="space-y-6">
        <div className="text-center">
          <h2 className="text-3xl font-bold text-white mb-6">💰 Tableau de Bord</h2>
        </div>

        <div className="grid grid-cols-1 gap-4">
          <div className="bg-green-500/30 backdrop-blur-lg rounded-2xl p-4 border border-green-400/30">
            <div className="text-green-100 text-sm">Revenus</div>
            <div className="text-2xl font-bold text-green-200">+{getTotalIncome().toFixed(2)} €</div>
          </div>

          <div className="bg-red-500/30 backdrop-blur-lg rounded-2xl p-4 border border-red-400/30">
            <div className="text-red-100 text-sm">Dépenses</div>
            <div className="text-2xl font-bold text-red-200">-{getTotalExpenses().toFixed(2)} €</div>
          </div>

          <div className={`${balance >= 0 ? 'bg-blue-500/30 border-blue-400/30' : 'bg-orange-500/30 border-orange-400/30'} backdrop-blur-lg rounded-2xl p-4`}>
            <div className={`${balance >= 0 ? 'text-blue-100' : 'text-orange-100'} text-sm`}>Solde</div>
            <div className={`text-2xl font-bold ${balance >= 0 ? 'text-blue-200' : 'text-orange-200'}`}>
              {balance >= 0 ? '+' : ''}{balance.toFixed(2)} €
            </div>
          </div>
        </div>

        <button
          onClick={() => setCurrentView('add')}
          className="w-full bg-white/20 hover:bg-white/30 backdrop-blur-lg border border-white/20 rounded-2xl p-4 transition-all duration-200 active:scale-95"
        >
          <div className="text-3xl mb-2">➕</div>
          <div className="text-white font-bold">Ajouter une transaction</div>
        </button>

        {transactions.length > 0 && (
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <h3 className="text-white font-bold mb-4">Transactions récentes</h3>
            <div className="space-y-2">
              {transactions.slice(0, 5).map(transaction => (
                <div key={transaction.id} className="flex justify-between items-center p-2 bg-white/5 rounded-lg">
                  <div className="flex-1">
                    <div className="text-white font-medium">{transaction.category}</div>
                    <div className="text-white/70 text-sm">{transaction.description}</div>
                  </div>
                  <div className={`font-bold ${transaction.type === 'income' ? 'text-green-300' : 'text-red-300'}`}>
                    {transaction.type === 'income' ? '+' : '-'}{transaction.amount.toFixed(2)} €
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    );
  };

  const renderAddTransaction = () => (
    <div className="space-y-6">
      <button
        onClick={() => setCurrentView('dashboard')}
        className="bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>

      <div className="text-center">
        <h2 className="text-2xl font-bold text-white mb-6">➕ Nouvelle Transaction</h2>
      </div>

      <div className="grid grid-cols-2 gap-2">
        <button
          onClick={() => setType('expense')}
          className={`p-4 rounded-xl border transition-all ${
            type === 'expense' 
              ? 'bg-red-500/50 border-red-400 text-white' 
              : 'bg-white/10 border-white/20 text-white/70'
          }`}
        >
          <div className="text-2xl mb-1">💸</div>
          <div className="font-bold">Dépense</div>
        </button>
        <button
          onClick={() => setType('income')}
          className={`p-4 rounded-xl border transition-all ${
            type === 'income' 
              ? 'bg-green-500/50 border-green-400 text-white' 
              : 'bg-white/10 border-white/20 text-white/70'
          }`}
        >
          <div className="text-2xl mb-1">💰</div>
          <div className="font-bold">Revenu</div>
        </button>
      </div>

      <div>
        <label className="block text-white font-medium mb-2">Montant (€)</label>
        <input
          type="number"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
          placeholder="0.00"
          className="w-full bg-white/90 rounded-xl p-4 text-gray-800 placeholder-gray-500 text-lg font-semibold text-center"
        />
      </div>

      <div>
        <label className="block text-white font-medium mb-2">Catégorie</label>
        <div className="grid grid-cols-2 gap-2">
          {categories[type].map((cat, index) => (
            <button
              key={index}
              onClick={() => setCategory(cat)}
              className={`p-3 rounded-lg border text-sm transition-all ${
                category === cat
                  ? 'bg-blue-500/50 border-blue-400 text-white'
                  : 'bg-white/10 border-white/20 text-white/70'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>
      </div>

      <div>
        <label className="block text-white font-medium mb-2">Description (optionnel)</label>
        <input
          type="text"
          value={description}
          onChange={(e) => setDescription(e.target.value)}
          placeholder="Description..."
          className="w-full bg-white/90 rounded-xl p-3 text-gray-800 placeholder-gray-500"
        />
      </div>

      <button
        onClick={addTransaction}
        className="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95"
      >
        💾 Enregistrer
      </button>
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-indigo-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">💰 BudgetCron</h1>
              <p className="text-white/80">Gestionnaire Budget</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 min-h-[500px]">
            {currentView === 'add' ? renderAddTransaction() : renderDashboard()}
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
EOF
    
    cd ../..
    print_success "BudgetCron mis à jour"
}

# Fonction pour mettre à jour UnitFlip (version simplifiée)
update_unitflip() {
    print_step "Mise à jour de UnitFlip Pro..."
    
    cd "apps/unitflip"
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

type ConversionCategory = 'length' | 'weight' | 'temperature';

const conversions = {
  length: {
    name: 'Longueur',
    icon: '📏',
    units: {
      cm: { name: 'Centimètre', symbol: 'cm', factor: 0.01 },
      m: { name: 'Mètre', symbol: 'm', factor: 1 },
      km: { name: 'Kilomètre', symbol: 'km', factor: 1000 },
      inch: { name: 'Pouce', symbol: 'in', factor: 0.0254 },
      ft: { name: 'Pied', symbol: 'ft', factor: 0.3048 }
    }
  },
  weight: {
    name: 'Poids',
    icon: '⚖️',
    units: {
      g: { name: 'Gramme', symbol: 'g', factor: 0.001 },
      kg: { name: 'Kilogramme', symbol: 'kg', factor: 1 },
      lb: { name: 'Livre', symbol: 'lb', factor: 0.453592 },
      oz: { name: 'Once', symbol: 'oz', factor: 0.0283495 }
    }
  },
  temperature: {
    name: 'Température',
    icon: '🌡️',
    units: {
      celsius: { name: 'Celsius', symbol: '°C', factor: 1 },
      fahrenheit: { name: 'Fahrenheit', symbol: '°F', factor: 1 },
      kelvin: { name: 'Kelvin', symbol: 'K', factor: 1 }
    }
  }
};

const App: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState<ConversionCategory>('length');
  const [fromUnit, setFromUnit] = useState('');
  const [toUnit, setToUnit] = useState('');
  const [inputValue, setInputValue] = useState('');
  const [result, setResult] = useState('');
  const [isNative, setIsNative] = useState(false);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    const categoryData = conversions[selectedCategory];
    const unitKeys = Object.keys(categoryData.units);
    setFromUnit(unitKeys[0]);
    setToUnit(unitKeys[1]);
  }, [selectedCategory]);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const convertTemperature = (value: number, from: string, to: string): number => {
    let celsius = value;
    if (from === 'fahrenheit') {
      celsius = (value - 32) * 5/9;
    } else if (from === 'kelvin') {
      celsius = value - 273.15;
    }

    if (to === 'fahrenheit') {
      return celsius * 9/5 + 32;
    } else if (to === 'kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  };

  const convertValue = async () => {
    if (!inputValue || !fromUnit || !toUnit) return;

    await triggerHaptic();
    const numValue = parseFloat(inputValue);
    if (isNaN(numValue)) return;

    const categoryData = conversions[selectedCategory];
    let convertedValue: number;

    if (selectedCategory === 'temperature') {
      convertedValue = convertTemperature(numValue, fromUnit, toUnit);
    } else {
      const fromFactor = categoryData.units[fromUnit].factor;
      const toFactor = categoryData.units[toUnit].factor;
      const baseValue = numValue * fromFactor;
      convertedValue = baseValue / toFactor;
    }

    const formattedResult = convertedValue.toFixed(6).replace(/\.?0+$/, '');
    setResult(formattedResult);
  };

  useEffect(() => {
    if (inputValue) {
      convertValue();
    } else {
      setResult('');
    }
  }, [inputValue, fromUnit, toUnit, selectedCategory]);

  const swapUnits = async () => {
    await triggerHaptic(ImpactStyle.Medium);
    const tempUnit = fromUnit;
    setFromUnit(toUnit);
    setToUnit(tempUnit);
  };

  const categoryData = conversions[selectedCategory];
  const unitKeys = Object.keys(categoryData.units);

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-500 to-emerald-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">🔄 UnitFlip Pro</h1>
              <p className="text-white/80">Convertisseur Universel</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
            <h3 className="text-white font-bold mb-4 text-center">Choisir une catégorie</h3>
            <div className="grid grid-cols-3 gap-2">
              {(Object.keys(conversions) as ConversionCategory[]).map(category => (
                <button
                  key={category}
                  onClick={() => setSelectedCategory(category)}
                  className={`p-3 rounded-xl transition-all ${
                    selectedCategory === category
                      ? 'bg-white/30 scale-105'
                      : 'bg-white/10 hover:bg-white/20'
                  }`}
                >
                  <div className="text-2xl mb-1">{conversions[category].icon}</div>
                  <div className="text-white text-xs font-medium">{conversions[category].name}</div>
                </button>
              ))}
            </div>
          </div>

          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
            <div className="text-center mb-4">
              <h2 className="text-xl font-bold text-white">
                {categoryData.icon} {categoryData.name}
              </h2>
            </div>

            <div className="mb-6">
              <label className="block text-white font-medium mb-2">Valeur à convertir</label>
              <input
                type="number"
                value={inputValue}
                onChange={(e) => setInputValue(e.target.value)}
                placeholder="Entrez une valeur..."
                className="w-full bg-white/90 rounded-xl p-4 text-gray-800 placeholder-gray-500 text-lg font-semibold text-center"
              />
            </div>

            <div className="mb-4">
              <label className="block text-white font-medium mb-2">De</label>
              <select
                value={fromUnit}
                onChange={(e) => setFromUnit(e.target.value)}
                className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
              >
                {unitKeys.map(key => (
                  <option key={key} value={key}>
                    {categoryData.units[key].name} ({categoryData.units[key].symbol})
                  </option>
                ))}
              </select>
            </div>

            <div className="text-center mb-4">
              <button
                onClick={swapUnits}
                className="bg-blue-500 hover:bg-blue-600 text-white p-3 rounded-full transition-all duration-200 active:scale-95"
              >
                <div className="text-xl">🔄</div>
              </button>
            </div>

            <div className="mb-6">
              <label className="block text-white font-medium mb-2">Vers</label>
              <select
                value={toUnit}
                onChange={(e) => setToUnit(e.target.value)}
                className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
              >
                {unitKeys.map(key => (
                  <option key={key} value={key}>
                    {categoryData.units[key].name} ({categoryData.units[key].symbol})
                  </option>
                ))}
              </select>
            </div>

            {result && (
              <div className="bg-green-500/30 rounded-xl p-4 text-center border border-green-400/30 mb-4">
                <div className="text-green-100 text-sm mb-1">Résultat</div>
                <div className="text-2xl font-bold text-green-200">
                  {result} {categoryData.units[toUnit].symbol}
                </div>
              </div>
            )}

            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={convertValue}
                className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 rounded-xl transition-all duration-200 active:scale-95"
              >
                🔄 Convertir
              </button>
              <button
                onClick={() => {setInputValue(''); setResult('');}}
                className="bg-red-500/80 hover:bg-red-500 text-white font-bold py-3 rounded-xl transition-all duration-200 active:scale-95"
              >
                🗑️ Effacer
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
EOF
    
    cd ../..
    print_success "UnitFlip Pro mis à jour"
}

# Fonction principale
main() {
    print_header "    🚀 MISE À JOUR DES APPLICATIONS AVANCÉES"
    echo ""
    echo "Ce script va mettre à jour toutes les applications avec leurs versions complètes :"
    echo "• 🧮 Postmath Pro : Calculatrice scientifique (déjà fonctionnelle)"
    echo "• 🔄 UnitFlip Pro : Convertisseur universel complet" 
    echo "• 💰 BudgetCron : Gestionnaire financier avec transactions"
    echo "• 🎨 AI4Kids : Application éducative interactive"
    echo "• 🤖 MultiAI Search : Plateforme de recherche multi-moteurs"
    echo ""
    
    read -p "Voulez-vous continuer avec la mise à jour ? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Mise à jour annulée"
        exit 0
    fi
    
    print_step "Arrêt des serveurs en cours..."
    pkill -f "npm run dev" 2>/dev/null || true
    pkill -f "vite" 2>/dev/null || true
    sleep 2
    
    # Vérifications préliminaires
    if [ ! -d "apps" ]; then
        print_error "Dossier 'apps' non trouvé."
        exit 1
    fi
    
    print_step "Démarrage des mises à jour..."
    echo ""
    
    # Mettre à jour chaque application
    update_multiai
    echo ""
    update_ai4kids
    echo ""
    update_budgetcron
    echo ""
    update_unitflip
    echo ""
    
    print_header "        🎉 MISE À JOUR TERMINÉE !"
    echo ""
    echo -e "${GREEN}📱 Toutes les applications ont été mises à jour :${NC}"
    echo "   🧮 Postmath Pro     - Calculatrice scientifique avancée"
    echo "   🔄 UnitFlip Pro     - Convertisseur universel"  
    echo "   💰 BudgetCron       - Gestionnaire financier"
    echo "   🎨 AI4Kids          - Application éducative interactive"
    echo "   🤖 MultiAI Search   - Recherche multi-moteurs intelligente"
    echo ""
    echo -e "${CYAN}🚀 Tester vos applications :${NC}"
    echo "   ./scripts/dev-all-apps.sh      # Démarrer toutes les apps"
    echo "   cd apps/multiai && npm run dev  # Tester MultiAI Search"
    echo ""
    echo -e "${YELLOW}✨ Nouvelles fonctionnalités :${NC}"
    echo "   ✅ Interfaces complètes et interactives"
    echo "   ✅ Fonctionnalités professionnelles"
    echo "   ✅ Sauvegarde locale des données"
    echo "   ✅ Support haptic pour mobile"
    echo "   ✅ Design moderne et responsive"
    echo ""
    
    # Proposer de redémarrer
    read -p "Voulez-vous démarrer toutes les applications maintenant ? (y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_step "Démarrage de toutes les applications..."
        echo ""
        exec ./scripts/dev-all-apps.sh
    else
        print_success "Applications mises à jour ! Utilisez ./scripts/dev-all-apps.sh pour démarrer."
    fi
}

# Exécution
main "$@"