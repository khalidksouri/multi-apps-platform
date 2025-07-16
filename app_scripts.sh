#!/bin/bash

# create-postmath-app.sh - Script pour créer l'application Postmath
create_postmath_app() {
    print_step "Création de l'application Postmath..."
    
    mkdir -p src/mobile/apps/postmath
    
    cat > src/mobile/apps/postmath/PostmathApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar } from '@capacitor/status-bar';
import { SplashScreen } from '@capacitor/splash-screen';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface PostmathAppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

const PostmathApp: React.FC<PostmathAppProps> = ({ isNative = false, onAppChange }) => {
  const [num1, setNum1] = useState('');
  const [num2, setNum2] = useState('');
  const [operation, setOperation] = useState<'add' | 'subtract' | 'multiply' | 'divide'>('add');
  const [result, setResult] = useState<number | null>(null);
  const [history, setHistory] = useState<string[]>([]);

  useEffect(() => {
    onAppChange?.('postmath');
    
    if (isNative && Capacitor.isNativePlatform()) {
      initializeNativeFeatures();
    }
  }, [isNative, onAppChange]);

  const initializeNativeFeatures = async () => {
    await StatusBar.setStyle({ style: 'light' });
    await StatusBar.setBackgroundColor({ color: '#667eea' });
    await SplashScreen.hide();
  };

  const calculate = async () => {
    const a = parseFloat(num1);
    const b = parseFloat(num2);

    if (isNaN(a) || isNaN(b)) {
      if (isNative && Capacitor.isNativePlatform()) {
        await Haptics.impact({ style: ImpactStyle.Medium });
      }
      alert('Veuillez entrer des nombres valides');
      return;
    }

    let calcResult: number;
    let operatorSymbol: string;

    switch (operation) {
      case 'add':
        calcResult = a + b;
        operatorSymbol = '+';
        break;
      case 'subtract':
        calcResult = a - b;
        operatorSymbol = '-';
        break;
      case 'multiply':
        calcResult = a * b;
        operatorSymbol = '×';
        break;
      case 'divide':
        if (b === 0) {
          if (isNative && Capacitor.isNativePlatform()) {
            await Haptics.impact({ style: ImpactStyle.Heavy });
          }
          alert('Division par zéro impossible');
          return;
        }
        calcResult = a / b;
        operatorSymbol = '÷';
        break;
    }

    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }

    const calculationString = `${num1} ${operatorSymbol} ${num2} = ${calcResult}`;
    setResult(calcResult);
    setHistory(prev => [calculationString, ...prev.slice(0, 4)]);
  };

  const clear = () => {
    setNum1('');
    setNum2('');
    setResult(null);
  };

  const getOperatorSymbol = () => {
    switch (operation) {
      case 'add': return '+';
      case 'subtract': return '-';
      case 'multiply': return '×';
      case 'divide': return '÷';
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-cyan-600 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">💰 BudgetCron</h1>
          <p className="text-white/80">Gestionnaire de Budget</p>
        </div>

        {/* Balance Card */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
          <div className="text-center mb-4">
            <h2 className="text-lg font-semibold text-white mb-2">Solde Total</h2>
            <p className={`text-3xl font-bold ${getBalance() >= 0 ? 'text-green-300' : 'text-red-300'}`}>
              {getBalance().toFixed(2)} €
            </p>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div className="text-center">
              <p className="text-green-300 text-xl font-semibold">+{getTotalIncome().toFixed(2)} €</p>
              <p className="text-white/70 text-sm">Revenus</p>
            </div>
            <div className="text-center">
              <p className="text-red-300 text-xl font-semibold">-{getTotalExpenses().toFixed(2)} €</p>
              <p className="text-white/70 text-sm">Dépenses</p>
            </div>
          </div>
        </div>

        {/* Add Transaction Button */}
        <button
          onClick={() => setShowAddForm(!showAddForm)}
          className="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95 mb-4"
        >
          {showAddForm ? '❌ Annuler' : '➕ Ajouter Transaction'}
        </button>

        {/* Add Transaction Form */}
        {showAddForm && (
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
            <div className="mb-4">
              <div className="grid grid-cols-2 gap-2 mb-4">
                <button
                  onClick={() => setNewTransaction({...newTransaction, type: 'income', category: categories.income[0]})}
                  className={`p-3 rounded-xl font-semibold transition-all duration-200 ${
                    newTransaction.type === 'income'
                      ? 'bg-green-500 text-white'
                      : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                >
                  💰 Revenu
                </button>
                <button
                  onClick={() => setNewTransaction({...newTransaction, type: 'expense', category: categories.expense[0]})}
                  className={`p-3 rounded-xl font-semibold transition-all duration-200 ${
                    newTransaction.type === 'expense'
                      ? 'bg-red-500 text-white'
                      : 'bg-white/20 text-white hover:bg-white/30'
                  }`}
                >
                  💸 Dépense
                </button>
              </div>

              <input
                type="number"
                value={newTransaction.amount}
                onChange={(e) => setNewTransaction({...newTransaction, amount: e.target.value})}
                placeholder="Montant"
                className="w-full bg-white/90 rounded-xl p-3 text-gray-800 placeholder-gray-500 mb-3"
              />

              <input
                type="text"
                value={newTransaction.description}
                onChange={(e) => setNewTransaction({...newTransaction, description: e.target.value})}
                placeholder="Description"
                className="w-full bg-white/90 rounded-xl p-3 text-gray-800 placeholder-gray-500 mb-3"
              />

              <select
                value={newTransaction.category}
                onChange={(e) => setNewTransaction({...newTransaction, category: e.target.value})}
                className="w-full bg-white/90 rounded-xl p-3 text-gray-800 mb-4"
              >
                {categories[newTransaction.type].map(cat => (
                  <option key={cat} value={cat}>{cat}</option>
                ))}
              </select>

              <button
                onClick={addTransaction}
                className="w-full bg-green-500 hover:bg-green-600 text-white font-bold py-3 rounded-xl transition-all duration-200 active:scale-95"
              >
                ✅ Ajouter
              </button>
            </div>
          </div>
        )}

        {/* Transactions List */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
          <h3 className="text-white font-semibold mb-4">📋 Transactions Récentes</h3>
          
          {transactions.length === 0 ? (
            <p className="text-white/60 text-center py-8">Aucune transaction</p>
          ) : (
            <div className="space-y-3 max-h-96 overflow-y-auto">
              {transactions.slice(0, 10).map((transaction) => (
                <div
                  key={transaction.id}
                  className="bg-white/10 rounded-xl p-3 flex justify-between items-center"
                >
                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-1">
                      <span className="text-white font-medium">
                        {transaction.description}
                      </span>
                      <span className={`font-bold ${
                        transaction.type === 'income' ? 'text-green-300' : 'text-red-300'
                      }`}>
                        {transaction.type === 'income' ? '+' : '-'}{transaction.amount.toFixed(2)} €
                      </span>
                    </div>
                    <div className="text-white/60 text-sm">
                      {transaction.category} • {transaction.date}
                    </div>
                  </div>
                  <button
                    onClick={() => deleteTransaction(transaction.id)}
                    className="ml-3 text-red-400 hover:text-red-300 transition-colors duration-200"
                  >
                    🗑️
                  </button>
                </div>
              ))}
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default BudgetCronApp;
EOF

    print_success "Application BudgetCron créée"
}

# create-ai4kids-app.sh - Script pour créer l'application AI4Kids
create_ai4kids_app() {
    print_step "Création de l'application AI4Kids..."
    
    mkdir -p src/mobile/apps/ai4kids
    
    cat > src/mobile/apps/ai4kids/AI4KidsApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface AI4KidsAppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

const activities = [
  {
    id: 'draw',
    name: 'Dessiner',
    icon: '🎨',
    description: 'Créer des dessins colorés',
    color: 'from-pink-500 to-rose-600'
  },
  {
    id: 'story',
    name: 'Histoire',
    icon: '📚',
    description: 'Inventer des histoires',
    color: 'from-purple-500 to-indigo-600'
  },
  {
    id: 'math',
    name: 'Maths',
    icon: '🔢',
    description: 'Apprendre en s\'amusant',
    color: 'from-blue-500 to-cyan-600'
  },
  {
    id: 'colors',
    name: 'Couleurs',
    icon: '🌈',
    description: 'Découvrir les couleurs',
    color: 'from-yellow-500 to-orange-600'
  }
];

const colors = ['🔴', '🟠', '🟡', '🟢', '🔵', '🟣', '🤍', '⚫'];
const numbers = Array.from({length: 10}, (_, i) => i);

const AI4KidsApp: React.FC<AI4KidsAppProps> = ({ isNative = false, onAppChange }) => {
  const [currentActivity, setCurrentActivity] = useState<string | null>(null);
  const [score, setScore] = useState(0);
  const [question, setQuestion] = useState<{num1: number, num2: number, answer: number} | null>(null);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [storyText, setStoryText] = useState('');
  const [currentColorIndex, setCurrentColorIndex] = useState(0);

  useEffect(() => {
    onAppChange?.('ai4kids');
  }, [onAppChange]);

  const startActivity = async (activityId: string) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    
    setCurrentActivity(activityId);
    
    if (activityId === 'math') {
      generateMathQuestion();
    }
  };

  const generateMathQuestion = () => {
    const num1 = Math.floor(Math.random() * 10) + 1;
    const num2 = Math.floor(Math.random() * 10) + 1;
    const answer = num1 + num2;
    setQuestion({ num1, num2, answer });
    setSelectedAnswer(null);
  };

  const checkMathAnswer = async (answer: number) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Medium });
    }

    setSelectedAnswer(answer);
    
    if (question && answer === question.answer) {
      setScore(score + 1);
      setTimeout(() => {
        generateMathQuestion();
      }, 1500);
    } else {
      setTimeout(() => {
        setSelectedAnswer(null);
      }, 1500);
    }
  };

  const nextColor = async () => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }
    
    setCurrentColorIndex((prev) => (prev + 1) % colors.length);
  };

  const renderActivityContent = () => {
    switch (currentActivity) {
      case 'draw':
        return (
          <div className="bg-white rounded-2xl p-6 m-4">
            <h3 className="text-2xl font-bold text-gray-800 mb-4 text-center">🎨 Zone de Dessin</h3>
            <div className="bg-gray-100 rounded-xl h-64 flex items-center justify-center mb-4">
              <p className="text-gray-500">Canvas de dessin à implémenter</p>
            </div>
            <div className="grid grid-cols-4 gap-2">
              {['🔴', '🟠', '🟡', '🟢', '🔵', '🟣', '⚫', '🤍'].map((color, index) => (
                <button
                  key={index}
                  className="p-3 bg-gray-200 rounded-xl text-2xl hover:scale-110 transition-transform"
                >
                  {color}
                </button>
              ))}
            </div>
          </div>
        );

      case 'story':
        return (
          <div className="bg-white rounded-2xl p-6 m-4">
            <h3 className="text-2xl font-bold text-gray-800 mb-4 text-center">📚 Créer une Histoire</h3>
            <textarea
              value={storyText}
              onChange={(e) => setStoryText(e.target.value)}
              placeholder="Il était une fois..."
              className="w-full h-40 p-4 border-2 border-purple-200 rounded-xl text-lg resize-none"
            />
            <button
              onClick={() => setStoryText('')}
              className="w-full mt-4 bg-purple-500 text-white font-bold py-3 rounded-xl hover:bg-purple-600 transition-colors"
            >
              🗑️ Effacer
            </button>
          </div>
        );

      case 'math':
        return (
          <div className="bg-white rounded-2xl p-6 m-4">
            <div className="text-center mb-6">
              <h3 className="text-2xl font-bold text-gray-800 mb-2">🔢 Additions Rigolotes</h3>
              <p className="text-blue-600 font-semibold">Score: {score} 🌟</p>
            </div>
            
            {question && (
              <div className="text-center mb-6">
                <p className="text-4xl font-bold text-gray-800 mb-4">
                  {question.num1} + {question.num2} = ?
                </p>
                
                <div className="grid grid-cols-2 gap-3">
                  {[...Array(4)].map((_, i) => {
                    const answer = i === 0 ? question.answer : question.answer + Math.floor(Math.random() * 6) - 3;
                    const isCorrect = answer === question.answer;
                    const isSelected = selectedAnswer === answer;
                    
                    return (
                      <button
                        key={i}
                        onClick={() => checkMathAnswer(answer)}
                        disabled={selectedAnswer !== null}
                        className={`p-4 rounded-xl text-2xl font-bold transition-all duration-200 ${
                          isSelected
                            ? isCorrect
                              ? 'bg-green-500 text-white'
                              : 'bg-red-500 text-white'
                            : 'bg-blue-100 text-blue-800 hover:bg-blue-200 active:scale-95'
                        }`}
                      >
                        {answer}
                      </button>
                    );
                  }).sort(() => Math.random() - 0.5)}
                </div>
              </div>
            )}
          </div>
        );

      case 'colors':
        return (
          <div className="bg-white rounded-2xl p-6 m-4 text-center">
            <h3 className="text-2xl font-bold text-gray-800 mb-6">🌈 Apprendre les Couleurs</h3>
            
            <div className="mb-8">
              <div className="text-8xl mb-4">{colors[currentColorIndex]}</div>
              <p className="text-2xl font-bold text-gray-800">
                {['Rouge', 'Orange', 'Jaune', 'Vert', 'Bleu', 'Violet', 'Blanc', 'Noir'][currentColorIndex]}
              </p>
            </div>
            
            <button
              onClick={nextColor}
              className="bg-rainbow-gradient text-white font-bold py-4 px-8 rounded-xl text-xl hover:scale-105 transition-transform"
              style={{
                background: 'linear-gradient(45deg, #ff6b6b, #4ecdc4, #45b7d1, #96ceb4, #feca57, #ff9ff3)'
              }}
            >
              🌈 Couleur Suivante
            </button>
          </div>
        );

      default:
        return null;
    }
  };

  if (currentActivity) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-pink-400 via-purple-400 to-indigo-400">
        <div className="p-4">
          <button
            onClick={() => setCurrentActivity(null)}
            className="bg-white/20 backdrop-blur-lg text-white font-bold py-2 px-4 rounded-xl mb-4"
          >
            ← Retour
          </button>
        </div>
        {renderActivityContent()}
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-400 via-purple-400 to-indigo-400 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-white mb-2">🎨 AI4Kids</h1>
          <p className="text-white/80 text-lg">Apprendre en s'amusant !</p>
        </div>

        {/* Activities Grid */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          {activities.map((activity) => (
            <button
              key={activity.id}
              onClick={() => startActivity(activity.id)}
              className={`bg-gradient-to-br ${activity.color} rounded-2xl p-6 text-white transform transition-all duration-200 hover:scale-105 active:scale-95 shadow-lg`}
            >
              <div className="text-4xl mb-3">{activity.icon}</div>
              <h3 className="text-xl font-bold mb-2">{activity.name}</h3>
              <p className="text-white/80 text-sm">{activity.description}</p>
            </button>
          ))}
        </div>

        {/* Fun Stats */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <h3 className="text-white font-bold text-lg mb-4 text-center">🏆 Mes Réussites</h3>
          <div className="grid grid-cols-2 gap-4 text-center">
            <div>
              <div className="text-2xl font-bold text-yellow-300">{score}</div>
              <div className="text-white/70 text-sm">Questions réussies</div>
            </div>
            <div>
              <div className="text-2xl font-bold text-green-300">🌟</div>
              <div className="text-white/70 text-sm">Super travail !</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AI4KidsApp;
EOF

    print_success "Application AI4Kids créée"
}

# create-multiai-app.sh - Script pour créer l'application MultiAI
create_multiai_app() {
    print_step "Création de l'application MultiAI..."
    
    mkdir -p src/mobile/apps/multiai
    
    cat > src/mobile/apps/multiai/MultiAIApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface MultiAIAppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

interface SearchResult {
  id: string;
  title: string;
  description: string;
  source: string;
  url: string;
}

const searchEngines = [
  { id: 'google', name: 'Google', icon: '🔍', color: 'blue' },
  { id: 'bing', name: 'Bing', icon: '🔎', color: 'orange' },
  { id: 'duckduckgo', name: 'DuckDuckGo', icon: '🦆', color: 'green' },
  { id: 'wikipedia', name: 'Wikipedia', icon: '📚', color: 'gray' }
];

const aiProviders = [
  { id: 'chatgpt', name: 'ChatGPT', icon: '🤖', color: 'green' },
  { id: 'claude', name: 'Claude', icon: '🎭', color: 'orange' },
  { id: 'gemini', name: 'Gemini', icon: '💎', color: 'blue' },
  { id: 'perplexity', name: 'Perplexity', icon: '🧠', color: 'purple' }
];

const MultiAIApp: React.FC<MultiAIAppProps> = ({ isNative = false, onAppChange }) => {
  const [query, setQuery] = useState('');
  const [selectedMode, setSelectedMode] = useState<'search' | 'ai'>('search');
  const [selectedProviders, setSelectedProviders] = useState<string[]>(['google']);
  const [isSearching, setIsSearching] = useState(false);
  const [searchHistory, setSearchHistory] = useState<string[]>([]);

  useEffect(() => {
    onAppChange?.('multiai');
    loadSearchHistory();
  }, [onAppChange]);

  const loadSearchHistory = () => {
    const saved = localStorage.getItem('multiai_search_history');
    if (saved) {
      setSearchHistory(JSON.parse(saved));
    }
  };

  const saveToHistory = (query: string) => {
    const updated = [query, ...searchHistory.filter(q => q !== query)].slice(0, 10);
    setSearchHistory(updated);
    localStorage.setItem('multiai_search_history', JSON.stringify(updated));
  };

  const toggleProvider = async (providerId: string) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }

    setSelectedProviders(prev => 
      prev.includes(providerId)
        ? prev.filter(id => id !== providerId)
        : [...prev, providerId]
    );
  };

  const performSearch = async () => {
    if (!query.trim() || selectedProviders.length === 0) {
      alert('Veuillez entrer une recherche et sélectionner au moins un moteur');
      return;
    }

    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Medium });
    }

    setIsSearching(true);
    saveToHistory(query.trim());

    // Simulation de recherche
    setTimeout(() => {
      setIsSearching(false);
      
      // Ouvrir les onglets pour chaque moteur sélectionné
      selectedProviders.forEach(providerId => {
        const providers = selectedMode === 'search' ? searchEngines : aiProviders;
        const provider = providers.find(p => p.id === providerId);
        
        if (provider) {
          let url = '';
          
          if (selectedMode === 'search') {
            switch (providerId) {
              case 'google':
                url = `https://www.google.com/search?q=${encodeURIComponent(query)}`;
                break;
              case 'bing':
                url = `https://www.bing.com/search?q=${encodeURIComponent(query)}`;
                break;
              case 'duckduckgo':
                url = `https://duckduckgo.com/?q=${encodeURIComponent(query)}`;
                break;
              case 'wikipedia':
                url = `https://en.wikipedia.org/wiki/Special:Search?search=${encodeURIComponent(query)}`;
                break;
            }
          } else {
            switch (providerId) {
              case 'chatgpt':
                url = `https://chat.openai.com/?q=${encodeURIComponent(query)}`;
                break;
              case 'claude':
                url = `https://claude.ai/chat?q=${encodeURIComponent(query)}`;
                break;
              case 'gemini':
                url = `https://gemini.google.com/chat?q=${encodeURIComponent(query)}`;
                break;
              case 'perplexity':
                url = `https://www.perplexity.ai/?q=${encodeURIComponent(query)}`;
                break;
            }
          }
          
          if (url) {
            window.open(url, '_blank');
          }
        }
      });
    }, 1000);
  };

  const clearHistory = () => {
    setSearchHistory([]);
    localStorage.removeItem('multiai_search_history');
  };

  const providers = selectedMode === 'search' ? searchEngines : aiProviders;

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-800 via-gray-900 to-black p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🤖 MultiAI</h1>
          <p className="text-gray-300">Recherche Multi-Moteurs</p>
        </div>

        {/* Mode Selection */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
          <div className="grid grid-cols-2 gap-2">
            <button
              onClick={() => setSelectedMode('search')}
              className={`p-3 rounded-xl font-semibold transition-all duration-200 ${
                selectedMode === 'search'
                  ? 'bg-blue-500 text-white'
                  : 'bg-white/20 text-white hover:bg-white/30'
              }`}
            >
              🔍 Moteurs de recherche
            </button>
            <button
              onClick={() => setSelectedMode('ai')}
              className={`p-3 rounded-xl font-semibold transition-all duration-200 ${
                selectedMode === 'ai'
                  ? 'bg-purple-500 text-white'
                  : 'bg-white/20 text-white hover:bg-white/30'
              }`}
            >
              🤖 IA
            </button>
          </div>
        </div>

        {/* Search Input */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
          <div className="flex gap-2">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder={`Rechercher avec ${selectedMode === 'search' ? 'les moteurs' : 'les IA'}...`}
              className="flex-1 bg-white/90 rounded-xl p-3 text-gray-800 placeholder-gray-500"
              onKeyPress={(e) => e.key === 'Enter' && performSearch()}
            />
            <button
              onClick={performSearch}
              disabled={isSearching}
              className="bg-blue-500 hover:bg-blue-600 text-white font-bold px-6 rounded-xl transition-all duration-200 active:scale-95 disabled:opacity-50"
            >
              {isSearching ? '⏳' : '🚀'}
            </button>
          </div>
        </div>

        {/* Providers Selection */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
          <h3 className="text-white font-semibold mb-3">
            {selectedMode === 'search' ? '🔍 Moteurs de recherche' : '🤖 Assistants IA'}
          </h3>
          <div className="grid grid-cols-2 gap-2">
            {providers.map((provider) => (
              <button
                key={provider.id}
                onClick={() => toggleProvider(provider.id)}
                className={`p-3 rounded-xl font-medium transition-all duration-200 ${
                  selectedProviders.includes(provider.id)
                    ? `bg-${provider.color}-500 text-white scale-105`
                    : 'bg-white/20 text-white hover:bg-white/30'
                }`}
              >
                <span className="text-xl mr-2">{provider.icon}</span>
                {provider.name}
              </button>
            ))}
          </div>
          
          {selectedProviders.length > 0 && (
            <div className="mt-3 text-center">
              <p className="text-green-300 text-sm">
                ✅ {selectedProviders.length} {selectedMode === 'search' ? 'moteur(s)' : 'IA'} sélectionné(s)
              </p>
            </div>
          )}
        </div>

        {/* Search History */}
        {searchHistory.length > 0 && (
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <div className="flex justify-between items-center mb-3">
              <h3 className="text-white font-semibold">📜 Historique</h3>
              <button
                onClick={clearHistory}
                className="text-red-400 hover:text-red-300 text-sm"
              >
                🗑️ Effacer
              </button>
            </div>
            
            <div className="space-y-2 max-h-40 overflow-y-auto">
              {searchHistory.slice(0, 5).map((historyQuery, index) => (
                <button
                  key={index}
                  onClick={() => setQuery(historyQuery)}
                  className="w-full text-left bg-white/10 hover:bg-white/20 rounded-lg p-2 text-white/80 text-sm transition-colors duration-200"
                >
                  {historyQuery}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default MultiAIApp;
EOF

    print_success "Application MultiAI créée"
}

# create-all-apps.sh - Script pour créer toutes les applications
create_all_apps() {
    print_step "Création de toutes les applications..."
    
    create_postmath_app
    create_unitflip_app
    create_budgetcron_app
    create_ai4kids_app
    create_multiai_app
    
    print_success "Toutes les applications ont été créées !"
}

# create-types.sh - Script pour créer les types TypeScript
create_types() {
    print_step "Création des types TypeScript..."
    
    mkdir -p src/shared/types
    
    cat > src/shared/types/index.ts << 'EOF'
export interface AppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

export interface NavigationItem {
  id: string;
  name: string;
  icon: string;
  path: string;
}

export interface Calculation {
  id: string;
  expression: string;
  result: number;
  timestamp: Date;
}

export interface ConversionCategory {
  name: string;
  icon: string;
  units: Record<string, {
    name: string;
    factor: number;
  }>;
}

export interface Transaction {
  id: string;
  type: 'income' | 'expense';
  amount: number;
  description: string;
  category: string;
  date: string;
}

export interface SearchProvider {
  id: string;
  name: string;
  icon: string;
  color: string;
}

export interface SearchResult {
  id: string;
  title: string;
  description: string;
  source: string;
  url: string;
}
EOF

    print_success "Types TypeScript créés"
}screen bg-gradient-to-br from-indigo-500 to-purple-600 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🧮 Postmath</h1>
          <p className="text-white/80">Calculatrice Avancée</p>
        </div>

        {/* Calculator */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
          {/* Input Section */}
          <div className="grid grid-cols-3 gap-4 mb-6 items-center">
            <input
              type="number"
              value={num1}
              onChange={(e) => setNum1(e.target.value)}
              placeholder="0"
              className="bg-white/90 rounded-xl p-3 text-center text-gray-800 placeholder-gray-500 text-lg font-semibold"
            />
            
            <div className="text-3xl font-bold text-white text-center">
              {getOperatorSymbol()}
            </div>
            
            <input
              type="number"
              value={num2}
              onChange={(e) => setNum2(e.target.value)}
              placeholder="0"
              className="bg-white/90 rounded-xl p-3 text-center text-gray-800 placeholder-gray-500 text-lg font-semibold"
            />
          </div>

          {/* Operation Buttons */}
          <div className="grid grid-cols-4 gap-2 mb-6">
            {(['add', 'subtract', 'multiply', 'divide'] as const).map((op) => (
              <button
                key={op}
                onClick={() => setOperation(op)}
                className={`p-4 rounded-xl font-bold text-white transition-all duration-200 ${
                  operation === op 
                    ? 'bg-green-500 scale-105 shadow-lg' 
                    : 'bg-white/20 hover:bg-white/30 active:scale-95'
                }`}
              >
                <span className="text-xl">
                  {op === 'add' ? '+' : op === 'subtract' ? '-' : 
                   op === 'multiply' ? '×' : '÷'}
                </span>
              </button>
            ))}
          </div>

          {/* Action Buttons */}
          <div className="grid grid-cols-2 gap-3 mb-6">
            <button
              onClick={calculate}
              className="bg-green-500 hover:bg-green-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95 shadow-lg"
            >
              = Calculer
            </button>
            <button
              onClick={clear}
              className="bg-red-500/80 hover:bg-red-500 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95"
            >
              🗑️ Effacer
            </button>
          </div>

          {/* Result */}
          {result !== null && (
            <div className="bg-green-500/30 rounded-xl p-4 text-center border border-green-400/30">
              <p className="text-2xl font-bold text-white">
                {num1} {getOperatorSymbol()} {num2} = <span className="text-green-200">{result}</span>
              </p>
            </div>
          )}
        </div>

        {/* History */}
        {history.length > 0 && (
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <h3 className="text-white font-semibold mb-3">📜 Historique</h3>
            <div className="space-y-2">
              {history.map((calc, index) => (
                <div 
                  key={index} 
                  className="text-white/80 text-sm bg-white/5 rounded-lg p-2"
                >
                  {calc}
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default PostmathApp;
EOF

    print_success "Application Postmath créée"
}

# create-unitflip-app.sh - Script pour créer l'application UnitFlip
create_unitflip_app() {
    print_step "Création de l'application UnitFlip..."
    
    mkdir -p src/mobile/apps/unitflip
    
    cat > src/mobile/apps/unitflip/UnitFlipApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface UnitFlipAppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

const conversions = {
  length: {
    name: 'Longueur',
    icon: '📏',
    units: {
      m: { name: 'Mètres', factor: 1 },
      cm: { name: 'Centimètres', factor: 100 },
      mm: { name: 'Millimètres', factor: 1000 },
      km: { name: 'Kilomètres', factor: 0.001 },
      ft: { name: 'Pieds', factor: 3.28084 },
      in: { name: 'Pouces', factor: 39.3701 },
    }
  },
  weight: {
    name: 'Poids',
    icon: '⚖️',
    units: {
      kg: { name: 'Kilogrammes', factor: 1 },
      g: { name: 'Grammes', factor: 1000 },
      lb: { name: 'Livres', factor: 2.20462 },
      oz: { name: 'Onces', factor: 35.274 },
    }
  },
  temperature: {
    name: 'Température',
    icon: '🌡️',
    units: {
      c: { name: 'Celsius', factor: 1 },
      f: { name: 'Fahrenheit', factor: 1 },
      k: { name: 'Kelvin', factor: 1 },
    }
  }
};

const UnitFlipApp: React.FC<UnitFlipAppProps> = ({ isNative = false, onAppChange }) => {
  const [category, setCategory] = useState<keyof typeof conversions>('length');
  const [fromUnit, setFromUnit] = useState('m');
  const [toUnit, setToUnit] = useState('cm');
  const [inputValue, setInputValue] = useState('');
  const [result, setResult] = useState<number | null>(null);

  useEffect(() => {
    onAppChange?.('unitflip');
  }, [onAppChange]);

  useEffect(() => {
    const units = Object.keys(conversions[category].units);
    setFromUnit(units[0]);
    setToUnit(units[1]);
    setResult(null);
  }, [category]);

  const convert = async () => {
    const value = parseFloat(inputValue);
    if (isNaN(value)) return;

    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }

    let convertedValue: number;

    if (category === 'temperature') {
      if (fromUnit === 'c' && toUnit === 'f') {
        convertedValue = (value * 9/5) + 32;
      } else if (fromUnit === 'f' && toUnit === 'c') {
        convertedValue = (value - 32) * 5/9;
      } else if (fromUnit === 'c' && toUnit === 'k') {
        convertedValue = value + 273.15;
      } else if (fromUnit === 'k' && toUnit === 'c') {
        convertedValue = value - 273.15;
      } else if (fromUnit === 'f' && toUnit === 'k') {
        convertedValue = ((value - 32) * 5/9) + 273.15;
      } else if (fromUnit === 'k' && toUnit === 'f') {
        convertedValue = ((value - 273.15) * 9/5) + 32;
      } else {
        convertedValue = value;
      }
    } else {
      const fromFactor = conversions[category].units[fromUnit as keyof typeof conversions[typeof category]['units']].factor;
      const toFactor = conversions[category].units[toUnit as keyof typeof conversions[typeof category]['units']].factor;
      convertedValue = (value / fromFactor) * toFactor;
    }

    setResult(convertedValue);
  };

  const swapUnits = async () => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Medium });
    }
    
    const temp = fromUnit;
    setFromUnit(toUnit);
    setToUnit(temp);
    setResult(null);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-500 to-teal-600 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🔄 UnitFlip</h1>
          <p className="text-white/80">Convertisseur d'Unités</p>
        </div>

        {/* Category Selection */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
          <h3 className="text-white font-semibold mb-3">Catégorie</h3>
          <div className="grid grid-cols-3 gap-2">
            {Object.entries(conversions).map(([key, cat]) => (
              <button
                key={key}
                onClick={() => setCategory(key as keyof typeof conversions)}
                className={`p-3 rounded-xl text-center transition-all duration-200 ${
                  category === key
                    ? 'bg-emerald-500 text-white scale-105'
                    : 'bg-white/20 text-white hover:bg-white/30'
                }`}
              >
                <div className="text-2xl mb-1">{cat.icon}</div>
                <div className="text-xs font-medium">{cat.name}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Converter */}
        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
          <div className="mb-6">
            <label className="block text-white font-semibold mb-2">Valeur à convertir</label>
            <input
              type="number"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              placeholder="Entrez une valeur"
              className="w-full bg-white/90 rounded-xl p-4 text-gray-800 placeholder-gray-500 text-lg font-semibold"
            />
          </div>

          <div className="mb-4">
            <label className="block text-white font-semibold mb-2">De</label>
            <select
              value={fromUnit}
              onChange={(e) => setFromUnit(e.target.value)}
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            >
              {Object.entries(conversions[category].units).map(([key, unit]) => (
                <option key={key} value={key}>
                  {unit.name}
                </option>
              ))}
            </select>
          </div>

          <div className="flex justify-center mb-4">
            <button
              onClick={swapUnits}
              className="bg-white/20 hover:bg-white/30 text-white p-3 rounded-full transition-all duration-200 active:scale-95"
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
              </svg>
            </button>
          </div>

          <div className="mb-6">
            <label className="block text-white font-semibold mb-2">Vers</label>
            <select
              value={toUnit}
              onChange={(e) => setToUnit(e.target.value)}
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            >
              {Object.entries(conversions[category].units).map(([key, unit]) => (
                <option key={key} value={key}>
                  {unit.name}
                </option>
              ))}
            </select>
          </div>

          <button
            onClick={convert}
            className="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95 shadow-lg"
          >
            🔄 Convertir
          </button>

          {result !== null && (
            <div className="mt-6 bg-emerald-500/30 rounded-xl p-4 text-center border border-emerald-400/30">
              <p className="text-xl font-bold text-white">
                {inputValue} {conversions[category].units[fromUnit as keyof typeof conversions[typeof category]['units']].name} = 
                <span className="text-emerald-200 block mt-2 text-2xl">
                  {result.toFixed(4)} {conversions[category].units[toUnit as keyof typeof conversions[typeof category]['units']].name}
                </span>
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default UnitFlipApp;
EOF

    print_success "Application UnitFlip créée"
}

# create-budgetcron-app.sh - Script pour créer l'application BudgetCron
create_budgetcron_app() {
    print_step "Création de l'application BudgetCron..."
    
    mkdir -p src/mobile/apps/budgetcron
    
    cat > src/mobile/apps/budgetcron/BudgetCronApp.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';

interface BudgetCronAppProps {
  isNative?: boolean;
  onAppChange?: (app: string) => void;
}

interface Transaction {
  id: string;
  type: 'income' | 'expense';
  amount: number;
  description: string;
  category: string;
  date: string;
}

const categories = {
  income: ['Salaire', 'Freelance', 'Investissements', 'Autres'],
  expense: ['Alimentation', 'Transport', 'Logement', 'Loisirs', 'Santé', 'Autres']
};

const BudgetCronApp: React.FC<BudgetCronAppProps> = ({ isNative = false, onAppChange }) => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newTransaction, setNewTransaction] = useState({
    type: 'expense' as 'income' | 'expense',
    amount: '',
    description: '',
    category: 'Alimentation'
  });

  useEffect(() => {
    onAppChange?.('budgetcron');
    loadTransactions();
  }, [onAppChange]);

  const loadTransactions = () => {
    const saved = localStorage.getItem('budgetcron_transactions');
    if (saved) {
      setTransactions(JSON.parse(saved));
    }
  };

  const saveTransactions = (transactions: Transaction[]) => {
    localStorage.setItem('budgetcron_transactions', JSON.stringify(transactions));
    setTransactions(transactions);
  };

  const addTransaction = async () => {
    if (!newTransaction.amount || !newTransaction.description) {
      alert('Veuillez remplir tous les champs');
      return;
    }

    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Light });
    }

    const transaction: Transaction = {
      id: Date.now().toString(),
      type: newTransaction.type,
      amount: parseFloat(newTransaction.amount),
      description: newTransaction.description,
      category: newTransaction.category,
      date: new Date().toISOString().split('T')[0]
    };

    const updatedTransactions = [transaction, ...transactions];
    saveTransactions(updatedTransactions);

    setNewTransaction({
      type: 'expense',
      amount: '',
      description: '',
      category: 'Alimentation'
    });
    setShowAddForm(false);
  };

  const deleteTransaction = async (id: string) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style: ImpactStyle.Medium });
    }

    const updatedTransactions = transactions.filter(t => t.id !== id);
    saveTransactions(updatedTransactions);
  };

  const getBalance = () => {
    return transactions.reduce((total, transaction) => {
      return transaction.type === 'income' 
        ? total + transaction.amount 
        : total - transaction.amount;
    }, 0);
  };

  const getTotalIncome = () => {
    return transactions
      .filter(t => t.type === 'income')
      .reduce((total, t) => total + t.amount, 0);
  };

  const getTotalExpenses = () => {
    return transactions
      .filter(t => t.type === 'expense')
      .reduce((total, t) => total + t.amount, 0);
  };

  return (
    <div className="min-h-