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
