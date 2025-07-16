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

# Liste des applications
APPS_LIST="postmath unitflip budgetcron ai4kids multiai"

# Fonction pour sauvegarder les fichiers existants
backup_existing_files() {
    local app_name=$1
    print_step "Sauvegarde des fichiers existants pour $app_name..."
    
    cd "apps/$app_name"
    
    # Créer un dossier de sauvegarde avec timestamp
    local backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Sauvegarder App.tsx s'il existe
    if [ -f "src/App.tsx" ]; then
        cp "src/App.tsx" "$backup_dir/App.tsx.backup"
        print_success "App.tsx sauvegardé dans $backup_dir/"
    fi
    
    cd ../..
}

# Fonction pour créer l'application Postmath Pro avancée
create_enhanced_postmath() {
    print_step "Mise à jour de Postmath Pro avec calculatrice scientifique..."
    
    cd "apps/postmath"
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import { StatusBar, Style } from '@capacitor/status-bar';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

type CalculatorMode = 'basic' | 'scientific';

const App: React.FC = () => {
  const [display, setDisplay] = useState('0');
  const [previousValue, setPreviousValue] = useState<number | null>(null);
  const [operation, setOperation] = useState<string | null>(null);
  const [waitingForOperand, setWaitingForOperand] = useState(false);
  const [mode, setMode] = useState<CalculatorMode>('basic');
  const [history, setHistory] = useState<string[]>([]);
  const [memory, setMemory] = useState(0);
  const [isNative, setIsNative] = useState(false);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
      StatusBar.setBackgroundColor({ color: '#667eea' });
    }

    // Charger l'historique
    const savedHistory = localStorage.getItem('postmath_history');
    if (savedHistory) {
      setHistory(JSON.parse(savedHistory));
    }

    // Charger la mémoire
    const savedMemory = localStorage.getItem('postmath_memory');
    if (savedMemory) {
      setMemory(parseFloat(savedMemory));
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const inputNumber = async (num: string) => {
    await triggerHaptic();
    
    if (waitingForOperand) {
      setDisplay(num);
      setWaitingForOperand(false);
    } else {
      setDisplay(display === '0' ? num : display + num);
    }
  };

  const inputDot = async () => {
    await triggerHaptic();
    
    if (waitingForOperand) {
      setDisplay('0.');
      setWaitingForOperand(false);
    } else if (display.indexOf('.') === -1) {
      setDisplay(display + '.');
    }
  };

  const clear = async () => {
    await triggerHaptic(ImpactStyle.Heavy);
    setDisplay('0');
    setPreviousValue(null);
    setOperation(null);
    setWaitingForOperand(false);
  };

  const performOperation = async (nextOperation: string) => {
    await triggerHaptic();
    const inputValue = parseFloat(display);

    if (previousValue === null) {
      setPreviousValue(inputValue);
    } else if (operation) {
      const currentValue = previousValue || 0;
      const newValue = calculate(currentValue, inputValue, operation);

      // Ajouter à l'historique
      const historyEntry = `${currentValue} ${operation} ${inputValue} = ${newValue}`;
      const newHistory = [historyEntry, ...history.slice(0, 9)];
      setHistory(newHistory);
      localStorage.setItem('postmath_history', JSON.stringify(newHistory));

      setDisplay(String(newValue));
      setPreviousValue(newValue);
    }

    setWaitingForOperand(true);
    setOperation(nextOperation);
  };

  const calculate = (firstValue: number, secondValue: number, operation: string): number => {
    switch (operation) {
      case '+':
        return firstValue + secondValue;
      case '-':
        return firstValue - secondValue;
      case '×':
        return firstValue * secondValue;
      case '÷':
        return secondValue !== 0 ? firstValue / secondValue : 0;
      case '=':
        return secondValue;
      case '^':
        return Math.pow(firstValue, secondValue);
      default:
        return secondValue;
    }
  };

  const performScientificOperation = async (func: string) => {
    await triggerHaptic();
    const value = parseFloat(display);
    let result: number;

    switch (func) {
      case 'sin':
        result = Math.sin(value * Math.PI / 180);
        break;
      case 'cos':
        result = Math.cos(value * Math.PI / 180);
        break;
      case 'tan':
        result = Math.tan(value * Math.PI / 180);
        break;
      case 'log':
        result = Math.log10(value);
        break;
      case 'ln':
        result = Math.log(value);
        break;
      case 'sqrt':
        result = Math.sqrt(value);
        break;
      case '1/x':
        result = 1 / value;
        break;
      case 'x²':
        result = value * value;
        break;
      case '!':
        result = factorial(value);
        break;
      default:
        result = value;
    }

    setDisplay(String(result));
    setWaitingForOperand(true);
  };

  const factorial = (n: number): number => {
    if (n < 0) return 0;
    if (n === 0 || n === 1) return 1;
    let result = 1;
    for (let i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  };

  const addConstant = async (constant: string) => {
    await triggerHaptic();
    let value: number;
    
    switch (constant) {
      case 'π':
        value = Math.PI;
        break;
      case 'e':
        value = Math.E;
        break;
      default:
        value = 0;
    }
    
    setDisplay(String(value));
    setWaitingForOperand(true);
  };

  const memoryOperation = async (op: string) => {
    await triggerHaptic(ImpactStyle.Medium);
    const currentValue = parseFloat(display);
    
    switch (op) {
      case 'MC':
        setMemory(0);
        localStorage.setItem('postmath_memory', '0');
        break;
      case 'MR':
        setDisplay(String(memory));
        setWaitingForOperand(true);
        break;
      case 'M+':
        const newMemory = memory + currentValue;
        setMemory(newMemory);
        localStorage.setItem('postmath_memory', String(newMemory));
        break;
      case 'M-':
        const subMemory = memory - currentValue;
        setMemory(subMemory);
        localStorage.setItem('postmath_memory', String(subMemory));
        break;
    }
  };

  const renderBasicButtons = () => (
    <div className="grid grid-cols-4 gap-3">
      {/* Ligne 1 */}
      <button onClick={clear} className="bg-red-500/80 hover:bg-red-500 text-white font-bold py-4 rounded-xl">C</button>
      <button onClick={() => performOperation('÷')} className="bg-orange-500/80 hover:bg-orange-500 text-white font-bold py-4 rounded-xl">÷</button>
      <button onClick={() => performOperation('×')} className="bg-orange-500/80 hover:bg-orange-500 text-white font-bold py-4 rounded-xl">×</button>
      <button onClick={() => setDisplay(display.slice(0, -1) || '0')} className="bg-gray-500/80 hover:bg-gray-500 text-white font-bold py-4 rounded-xl">⌫</button>
      
      {/* Ligne 2 */}
      <button onClick={() => inputNumber('7')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">7</button>
      <button onClick={() => inputNumber('8')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">8</button>
      <button onClick={() => inputNumber('9')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">9</button>
      <button onClick={() => performOperation('-')} className="bg-orange-500/80 hover:bg-orange-500 text-white font-bold py-4 rounded-xl">-</button>
      
      {/* Ligne 3 */}
      <button onClick={() => inputNumber('4')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">4</button>
      <button onClick={() => inputNumber('5')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">5</button>
      <button onClick={() => inputNumber('6')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">6</button>
      <button onClick={() => performOperation('+')} className="bg-orange-500/80 hover:bg-orange-500 text-white font-bold py-4 rounded-xl">+</button>
      
      {/* Ligne 4 */}
      <button onClick={() => inputNumber('1')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">1</button>
      <button onClick={() => inputNumber('2')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">2</button>
      <button onClick={() => inputNumber('3')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">3</button>
      <button onClick={() => performOperation('=')} className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-4 rounded-xl row-span-2">=</button>
      
      {/* Ligne 5 */}
      <button onClick={() => inputNumber('0')} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl col-span-2">0</button>
      <button onClick={inputDot} className="bg-gray-700/80 hover:bg-gray-700 text-white font-bold py-4 rounded-xl">.</button>
    </div>
  );

  const renderScientificButtons = () => (
    <div className="space-y-3">
      {/* Fonctions scientifiques */}
      <div className="grid grid-cols-4 gap-2">
        <button onClick={() => performScientificOperation('sin')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">sin</button>
        <button onClick={() => performScientificOperation('cos')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">cos</button>
        <button onClick={() => performScientificOperation('tan')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">tan</button>
        <button onClick={() => performScientificOperation('log')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">log</button>
      </div>
      
      <div className="grid grid-cols-4 gap-2">
        <button onClick={() => performScientificOperation('ln')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">ln</button>
        <button onClick={() => performScientificOperation('sqrt')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">√</button>
        <button onClick={() => performScientificOperation('x²')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">x²</button>
        <button onClick={() => performOperation('^')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">x^y</button>
      </div>
      
      <div className="grid grid-cols-4 gap-2">
        <button onClick={() => addConstant('π')} className="bg-green-500/80 text-white font-bold py-2 rounded-lg text-sm">π</button>
        <button onClick={() => addConstant('e')} className="bg-green-500/80 text-white font-bold py-2 rounded-lg text-sm">e</button>
        <button onClick={() => performScientificOperation('!')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">x!</button>
        <button onClick={() => performScientificOperation('1/x')} className="bg-purple-500/80 text-white font-bold py-2 rounded-lg text-sm">1/x</button>
      </div>
      
      {/* Mémoire */}
      <div className="grid grid-cols-4 gap-2">
        <button onClick={() => memoryOperation('MC')} className="bg-blue-500/80 text-white font-bold py-2 rounded-lg text-sm">MC</button>
        <button onClick={() => memoryOperation('MR')} className="bg-blue-500/80 text-white font-bold py-2 rounded-lg text-sm">MR</button>
        <button onClick={() => memoryOperation('M+')} className="bg-blue-500/80 text-white font-bold py-2 rounded-lg text-sm">M+</button>
        <button onClick={() => memoryOperation('M-')} className="bg-blue-500/80 text-white font-bold py-2 rounded-lg text-sm">M-</button>
      </div>
      
      {renderBasicButtons()}
    </div>
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-3xl font-bold text-white mb-2">🧮 Postmath Pro</h1>
              <p className="text-white/80">Calculatrice Scientifique</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Mode Switch */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
            <div className="flex gap-2">
              <button
                onClick={() => setMode('basic')}
                className={`flex-1 py-3 rounded-xl font-bold transition-all ${
                  mode === 'basic' ? 'bg-white/30 text-white' : 'bg-white/10 text-white/70'
                }`}
              >
                📱 Basique
              </button>
              <button
                onClick={() => setMode('scientific')}
                className={`flex-1 py-3 rounded-xl font-bold transition-all ${
                  mode === 'scientific' ? 'bg-white/30 text-white' : 'bg-white/10 text-white/70'
                }`}
              >
                🔬 Scientifique
              </button>
            </div>
          </div>

          {/* Display */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
            <div className="text-right">
              {memory !== 0 && (
                <div className="text-blue-300 text-sm mb-2">M: {memory}</div>
              )}
              <div className="text-4xl font-bold text-white break-all">
                {display}
              </div>
              {operation && (
                <div className="text-orange-300 text-lg mt-2">
                  {previousValue} {operation}
                </div>
              )}
            </div>
          </div>

          {/* Calculator */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
            {mode === 'scientific' ? renderScientificButtons() : renderBasicButtons()}
          </div>

          {/* History */}
          {history.length > 0 && (
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
              <h3 className="text-white font-semibold mb-3">📜 Historique</h3>
              <div className="space-y-2 max-h-40 overflow-y-auto">
                {history.map((calc, index) => (
                  <div 
                    key={index} 
                    className="text-white/80 text-sm bg-white/5 rounded-lg p-2 hover:bg-white/10 transition-colors cursor-pointer"
                    onClick={() => {
                      const result = calc.split(' = ')[1];
                      setDisplay(result);
                      setWaitingForOperand(true);
                    }}
                  >
                    {calc}
                  </div>
                ))}
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
    print_success "Postmath Pro mis à jour avec calculatrice scientifique"
}

# Fonction pour créer l'application UnitFlip Pro avancée
create_enhanced_unitflip() {
    print_step "Mise à jour de UnitFlip Pro avec convertisseur universel..."
    
    cd "apps/unitflip"
    
    cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

type ConversionCategory = 'length' | 'weight' | 'temperature' | 'volume' | 'speed' | 'area';

interface ConversionUnit {
  name: string;
  symbol: string;
  factor: number;
}

const conversions = {
  length: {
    name: 'Longueur',
    icon: '📏',
    baseUnit: 'meter',
    units: {
      mm: { name: 'Millimètre', symbol: 'mm', factor: 0.001 },
      cm: { name: 'Centimètre', symbol: 'cm', factor: 0.01 },
      m: { name: 'Mètre', symbol: 'm', factor: 1 },
      km: { name: 'Kilomètre', symbol: 'km', factor: 1000 },
      inch: { name: 'Pouce', symbol: 'in', factor: 0.0254 },
      ft: { name: 'Pied', symbol: 'ft', factor: 0.3048 },
      yard: { name: 'Yard', symbol: 'yd', factor: 0.9144 },
      mile: { name: 'Mile', symbol: 'mi', factor: 1609.34 }
    }
  },
  weight: {
    name: 'Poids',
    icon: '⚖️',
    baseUnit: 'kg',
    units: {
      mg: { name: 'Milligramme', symbol: 'mg', factor: 0.000001 },
      g: { name: 'Gramme', symbol: 'g', factor: 0.001 },
      kg: { name: 'Kilogramme', symbol: 'kg', factor: 1 },
      lb: { name: 'Livre', symbol: 'lb', factor: 0.453592 },
      oz: { name: 'Once', symbol: 'oz', factor: 0.0283495 },
      ton: { name: 'Tonne', symbol: 't', factor: 1000 }
    }
  },
  temperature: {
    name: 'Température',
    icon: '🌡️',
    baseUnit: 'celsius',
    units: {
      celsius: { name: 'Celsius', symbol: '°C', factor: 1 },
      fahrenheit: { name: 'Fahrenheit', symbol: '°F', factor: 1 },
      kelvin: { name: 'Kelvin', symbol: 'K', factor: 1 }
    }
  },
  volume: {
    name: 'Volume',
    icon: '🥤',
    baseUnit: 'liter',
    units: {
      ml: { name: 'Millilitre', symbol: 'ml', factor: 0.001 },
      l: { name: 'Litre', symbol: 'L', factor: 1 },
      gal: { name: 'Gallon US', symbol: 'gal', factor: 3.78541 },
      qt: { name: 'Quart', symbol: 'qt', factor: 0.946353 },
      pt: { name: 'Pinte', symbol: 'pt', factor: 0.473176 },
      cup: { name: 'Tasse', symbol: 'cup', factor: 0.236588 }
    }
  },
  speed: {
    name: 'Vitesse',
    icon: '🚗',
    baseUnit: 'mps',
    units: {
      mps: { name: 'Mètre/seconde', symbol: 'm/s', factor: 1 },
      kmh: { name: 'Kilomètre/heure', symbol: 'km/h', factor: 0.277778 },
      mph: { name: 'Mile/heure', symbol: 'mph', factor: 0.44704 },
      knot: { name: 'Nœud', symbol: 'kn', factor: 0.514444 }
    }
  },
  area: {
    name: 'Surface',
    icon: '📐',
    baseUnit: 'sqm',
    units: {
      sqmm: { name: 'mm²', symbol: 'mm²', factor: 0.000001 },
      sqcm: { name: 'cm²', symbol: 'cm²', factor: 0.0001 },
      sqm: { name: 'm²', symbol: 'm²', factor: 1 },
      sqkm: { name: 'km²', symbol: 'km²', factor: 1000000 },
      sqin: { name: 'Pouce²', symbol: 'in²', factor: 0.00064516 },
      sqft: { name: 'Pied²', symbol: 'ft²', factor: 0.092903 },
      acre: { name: 'Acre', symbol: 'ac', factor: 4046.86 }
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
  const [history, setHistory] = useState<string[]>([]);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    // Set default units for selected category
    const categoryData = conversions[selectedCategory];
    const unitKeys = Object.keys(categoryData.units);
    setFromUnit(unitKeys[0]);
    setToUnit(unitKeys[1]);
    
    // Load history
    const savedHistory = localStorage.getItem('unitflip_history');
    if (savedHistory) {
      setHistory(JSON.parse(savedHistory));
    }
  }, [selectedCategory]);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const convertTemperature = (value: number, from: string, to: string): number => {
    // Convert to Celsius first
    let celsius = value;
    if (from === 'fahrenheit') {
      celsius = (value - 32) * 5/9;
    } else if (from === 'kelvin') {
      celsius = value - 273.15;
    }

    // Convert from Celsius to target
    if (to === 'fahrenheit') {
      return celsius * 9/5 + 32;
    } else if (to === 'kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  };

  const convertValue = async (value: string) => {
    if (!value || !fromUnit || !toUnit) return;

    await triggerHaptic();
    const numValue = parseFloat(value);
    if (isNaN(numValue)) return;

    const categoryData = conversions[selectedCategory];
    let convertedValue: number;

    if (selectedCategory === 'temperature') {
      convertedValue = convertTemperature(numValue, fromUnit, toUnit);
    } else {
      // Convert to base unit first, then to target unit
      const fromFactor = categoryData.units[fromUnit].factor;
      const toFactor = categoryData.units[toUnit].factor;
      const baseValue = numValue * fromFactor;
      convertedValue = baseValue / toFactor;
    }

    const formattedResult = convertedValue.toFixed(6).replace(/\.?0+$/, '');
    setResult(formattedResult);

    // Add to history
    const historyEntry = `${value} ${categoryData.units[fromUnit].symbol} = ${formattedResult} ${categoryData.units[toUnit].symbol}`;
    const newHistory = [historyEntry, ...history.slice(0, 9)];
    setHistory(newHistory);
    localStorage.setItem('unitflip_history', JSON.stringify(newHistory));
  };

  useEffect(() => {
    if (inputValue) {
      convertValue(inputValue);
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

  const clearAll = async () => {
    await triggerHaptic(ImpactStyle.Heavy);
    setInputValue('');
    setResult('');
  };

  const categoryData = conversions[selectedCategory];
  const unitKeys = Object.keys(categoryData.units);

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-500 to-emerald-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">🔄 UnitFlip Pro</h1>
              <p className="text-white/80">Convertisseur Universel</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Category Selector */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
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

          {/* Conversion Interface */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
            <div className="text-center mb-4">
              <h2 className="text-xl font-bold text-white">
                {categoryData.icon} {categoryData.name}
              </h2>
            </div>

            {/* Input Value */}
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

            {/* From Unit */}
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

            {/* Swap Button */}
            <div className="text-center mb-4">
              <button
                onClick={swapUnits}
                className="bg-blue-500 hover:bg-blue-600 text-white p-3 rounded-full transition-all duration-200 active:scale-95"
              >
                <div className="text-xl">🔄</div>
              </button>
            </div>

            {/* To Unit */}
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

            {/* Result */}
            {result && (
              <div className="bg-green-500/30 rounded-xl p-4 text-center border border-green-400/30 mb-4">
                <div className="text-green-100 text-sm mb-1">Résultat</div>
                <div className="text-2xl font-bold text-green-200">
                  {result} {categoryData.units[toUnit].symbol}
                </div>
              </div>
            )}

            {/* Action Buttons */}
            <div className="grid grid-cols-2 gap-3">
              <button
                onClick={() => convertValue(inputValue)}
                className="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 rounded-xl transition-all duration-200 active:scale-95"
              >
                🔄 Convertir
              </button>
              <button
                onClick={clearAll}
                className="bg-red-500/80 hover:bg-red-500 text-white font-bold py-3 rounded-xl transition-all duration-200 active:scale-95"
              >
                🗑️ Effacer
              </button>
            </div>
          </div>

          {/* History */}
          {history.length > 0 && (
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20 mb-4">
              <h3 className="text-white font-semibold mb-3">📜 Historique des conversions</h3>
              <div className="space-y-2 max-h-40 overflow-y-auto">
                {history.map((conversion, index) => (
                  <div 
                    key={index} 
                    className="text-white/80 text-sm bg-white/5 rounded-lg p-2 hover:bg-white/10 transition-colors"
                  >
                    {conversion}
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* Quick Conversions */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <h3 className="text-white font-semibold mb-3">⚡ Conversions rapides</h3>
            <div className="grid grid-cols-2 gap-2 text-sm">
              {selectedCategory === 'length' && (
                <>
                  <div className="text-white/70">1 m = 100 cm</div>
                  <div className="text-white/70">1 km = 1000 m</div>
                  <div className="text-white/70">1 ft = 30.48 cm</div>
                  <div className="text-white/70">1 in = 2.54 cm</div>
                </>
              )}
              {selectedCategory === 'weight' && (
                <>
                  <div className="text-white/70">1 kg = 1000 g</div>
                  <div className="text-white/70">1 lb = 453.6 g</div>
                  <div className="text-white/70">1 oz = 28.35 g</div>
                  <div className="text-white/70">1 t = 1000 kg</div>
                </>
              )}
              {selectedCategory === 'temperature' && (
                <>
                  <div className="text-white/70">0°C = 32°F</div>
                  <div className="text-white/70">100°C = 212°F</div>
                  <div className="text-white/70">0°C = 273.15K</div>
                  <div className="text-white/70">20°C = 68°F</div>
                </>
              )}
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
    print_success "UnitFlip Pro mis à jour avec convertisseur universel"
}

# Fonction pour créer l'application BudgetCron avancée
create_enhanced_budgetcron() {
    print_step "Mise à jour de BudgetCron avec gestionnaire financier..."
    
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
  income: ['💼 Salaire', '💰 Freelance', '🎁 Bonus', '📈 Investissements', '💡 Autre'],
  expense: ['🛒 Courses', '🏠 Logement', '🚗 Transport', '🍕 Restaurant', '🎮 Loisirs', '💊 Santé', '📱 Technologie', '👕 Vêtements']
};

type ViewType = 'dashboard' | 'add' | 'history' | 'stats';

const App: React.FC = () => {
  const [currentView, setCurrentView] = useState<ViewType>('dashboard');
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [isNative, setIsNative] = useState(false);
  
  // Formulaire d'ajout
  const [amount, setAmount] = useState('');
  const [type, setType] = useState<'income' | 'expense'>('expense');
  const [category, setCategory] = useState('');
  const [description, setDescription] = useState('');

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
    }

    // Charger les données depuis localStorage
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

  const saveTransactions = (newTransactions: Transaction[]) => {
    setTransactions(newTransactions);
    localStorage.setItem('budgetcron_transactions', JSON.stringify(newTransactions));
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
    saveTransactions(updatedTransactions);
    
    // Reset form
    setAmount('');
    setCategory('');
    setDescription('');
    setCurrentView('dashboard');
  };

  const deleteTransaction = async (id: string) => {
    await triggerHaptic(ImpactStyle.Heavy);
    const updatedTransactions = transactions.filter(t => t.id !== id);
    saveTransactions(updatedTransactions);
  };

  const getTotalIncome = () => {
    return transactions
      .filter(t => t.type === 'income')
      .reduce((sum, t) => sum + t.amount, 0);
  };

  const getTotalExpenses = () => {
    return transactions
      .filter(t => t.type === 'expense')
      .reduce((sum, t) => sum + t.amount, 0);
  };

  const getBalance = () => {
    return getTotalIncome() - getTotalExpenses();
  };

  const renderDashboard = () => {
    const balance = getBalance();
    const isPositive = balance >= 0;

    return (
      <div className="space-y-6">
        <div className="text-center">
          <h2 className="text-3xl font-bold text-white mb-6">💰 Tableau de Bord</h2>
        </div>

        {/* Résumé financier */}
        <div className="grid grid-cols-1 gap-4">
          <div className="bg-green-500/30 backdrop-blur-lg rounded-2xl p-4 border border-green-400/30">
            <div className="text-green-100 text-sm">Revenus</div>
            <div className="text-2xl font-bold text-green-200">+{getTotalIncome().toFixed(2)} €</div>
          </div>

          <div className="bg-red-500/30 backdrop-blur-lg rounded-2xl p-4 border border-red-400/30">
            <div className="text-red-100 text-sm">Dépenses</div>
            <div className="text-2xl font-bold text-red-200">-{getTotalExpenses().toFixed(2)} €</div>
          </div>

          <div className={`${isPositive ? 'bg-blue-500/30 border-blue-400/30' : 'bg-orange-500/30 border-orange-400/30'} backdrop-blur-lg rounded-2xl p-4`}>
            <div className={`${isPositive ? 'text-blue-100' : 'text-orange-100'} text-sm`}>Solde</div>
            <div className={`text-2xl font-bold ${isPositive ? 'text-blue-200' : 'text-orange-200'}`}>
              {isPositive ? '+' : ''}{balance.toFixed(2)} €
            </div>
          </div>
        </div>

        {/* Actions rapides */}
        <div className="grid grid-cols-2 gap-4">
          <button
            onClick={() => setCurrentView('add')}
            className="bg-white/20 hover:bg-white/30 backdrop-blur-lg border border-white/20 rounded-2xl p-4 transition-all duration-200 active:scale-95"
          >
            <div className="text-3xl mb-2">➕</div>
            <div className="text-white font-bold">Ajouter</div>
          </button>

          <button
            onClick={() => setCurrentView('history')}
            className="bg-white/20 hover:bg-white/30 backdrop-blur-lg border border-white/20 rounded-2xl p-4 transition-all duration-200 active:scale-95"
          >
            <div className="text-3xl mb-2">📋</div>
            <div className="text-white font-bold">Historique</div>
          </button>
        </div>

        {/* Transactions récentes */}
        {transactions.length > 0 && (
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
            <h3 className="text-white font-bold mb-4">Transactions récentes</h3>
            <div className="space-y-2">
              {transactions.slice(0, 3).map(transaction => (
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

      {/* Type de transaction */}
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

      {/* Montant */}
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

      {/* Catégorie */}
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

      {/* Description */}
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

      {/* Bouton d'ajout */}
      <button
        onClick={addTransaction}
        className="w-full bg-blue-500 hover:bg-blue-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95"
      >
        💾 Enregistrer la Transaction
      </button>
    </div>
  );

  const renderHistory = () => (
    <div className="space-y-6">
      <button
        onClick={() => setCurrentView('dashboard')}
        className="bg-white/20 hover:bg-white/30 text-white px-4 py-2 rounded-lg transition-colors"
      >
        ← Retour
      </button>

      <div className="text-center">
        <h2 className="text-2xl font-bold text-white mb-6">📋 Historique</h2>
      </div>

      {transactions.length === 0 ? (
        <div className="text-center text-white/70 py-8">
          <div className="text-4xl mb-4">📝</div>
          <div>Aucune transaction encore</div>
        </div>
      ) : (
        <div className="space-y-3">
          {transactions.map(transaction => (
            <div key={transaction.id} className="bg-white/10 backdrop-blur-lg rounded-xl p-4 border border-white/20">
              <div className="flex justify-between items-start mb-2">
                <div className="flex-1">
                  <div className="text-white font-bold">{transaction.category}</div>
                  <div className="text-white/70 text-sm">{transaction.description}</div>
                  <div className="text-white/50 text-xs">{transaction.date}</div>
                </div>
                <div className="text-right">
                  <div className={`font-bold text-lg ${transaction.type === 'income' ? 'text-green-300' : 'text-red-300'}`}>
                    {transaction.type === 'income' ? '+' : '-'}{transaction.amount.toFixed(2)} €
                  </div>
                  <button
                    onClick={() => deleteTransaction(transaction.id)}
                    className="text-red-400 hover:text-red-300 text-sm mt-1"
                  >
                    🗑️ Supprimer
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );

  const renderCurrentView = () => {
    switch (currentView) {
      case 'add':
        return renderAddTransaction();
      case 'history':
        return renderHistory();
      default:
        return renderDashboard();
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-indigo-600">
      <div className="p-4 pb-20">
        <div className="max-w-md mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-2xl font-bold text-white">💰 BudgetCron</h1>
              <p className="text-white/80">Gestionnaire Personnel</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Contenu principal */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 min-h-[500px]">
            {renderCurrentView()}
          </div>

          {/* Navigation en bas */}
          <div className="fixed bottom-4 left-4 right-4 max-w-md mx-auto">
            <div className="bg-white/20 backdrop-blur-lg rounded-2xl border border-white/20 p-2">
              <div className="grid grid-cols-3 gap-2">
                <button
                  onClick={() => setCurrentView('dashboard')}
                  className={`p-3 rounded-xl transition-all ${
                    currentView === 'dashboard' ? 'bg-white/30' : 'bg-transparent'
                  }`}
                >
                  <div className="text-white text-xl">🏠</div>
                  <div className="text-white text-xs">Accueil</div>
                </button>
                <button
                  onClick={() => setCurrentView('add')}
                  className={`p-3 rounded-xl transition-all ${
                    currentView === 'add' ? 'bg-white/30' : 'bg-transparent'
                  }`}
                >
                  <div className="text-white text-xl">➕</div>
                  <div className="text-white text-xs">Ajouter</div>
                </button>
                <button
                  onClick={() => setCurrentView('history')}
                  className={`p-3 rounded-xl transition-all ${
                    currentView === 'history' ? 'bg-white/30' : 'bg-transparent'
                  }`}
                >
                  <div className="text-white text-xl">📋</div>
                  <div className="text-white text-xs">Historique</div>
                </button>
              </div>
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
    print_success "BudgetCron mis à jour avec gestionnaire financier"
}

# Fonction pour créer l'application AI4Kids avancée
create_enhanced_ai4kids() {
    print_step "Mise à jour de AI4Kids avec application éducative..."
    
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
          <div className="text-4xl mb-2">