'use client';

import { useState, useEffect } from 'react';

const unitsByCategory = {
  temperature: [
    { value: 'celsius', label: 'Celsius (°C)' },
    { value: 'fahrenheit', label: 'Fahrenheit (°F)' },
    { value: 'kelvin', label: 'Kelvin (K)' },
  ],
  length: [
    { value: 'meters', label: 'Mètres (m)' },
    { value: 'kilometers', label: 'Kilomètres (km)' },
    { value: 'centimeters', label: 'Centimètres (cm)' },
    { value: 'feet', label: 'Pieds (ft)' },
    { value: 'inches', label: 'Pouces (in)' },
  ],
  weight: [
    { value: 'kilograms', label: 'Kilogrammes (kg)' },
    { value: 'grams', label: 'Grammes (g)' },
    { value: 'pounds', label: 'Livres (lb)' },
    { value: 'ounces', label: 'Onces (oz)' },
  ],
};

export default function HomePage() {
  const [category, setCategory] = useState('temperature');
  const [fromValue, setFromValue] = useState('');
  const [toValue, setToValue] = useState('');
  const [fromUnit, setFromUnit] = useState('celsius');
  const [toUnit, setToUnit] = useState('fahrenheit');
  const [explanation, setExplanation] = useState('');

  const convertValue = () => {
    if (!fromValue || isNaN(parseFloat(fromValue))) return;

    const value = parseFloat(fromValue);
    let result = 0;
    let exp = '';

    // Conversions de température
    if (category === 'temperature') {
      if (fromUnit === 'celsius' && toUnit === 'fahrenheit') {
        result = (value * 9/5) + 32;
        exp = `${value}°C × 9/5 + 32 = ${result.toFixed(2)}°F`;
      } else if (fromUnit === 'fahrenheit' && toUnit === 'celsius') {
        result = (value - 32) * 5/9;
        exp = `(${value}°F - 32) × 5/9 = ${result.toFixed(2)}°C`;
      } else if (fromUnit === 'celsius' && toUnit === 'kelvin') {
        result = value + 273.15;
        exp = `${value}°C + 273.15 = ${result.toFixed(2)}K`;
      } else if (fromUnit === toUnit) {
        result = value;
        exp = `${value} ${fromUnit} = ${result} ${toUnit}`;
      }
    }
    
    // Conversions de longueur
    if (category === 'length') {
      if (fromUnit === 'meters' && toUnit === 'kilometers') {
        result = value / 1000;
        exp = `${value}m ÷ 1000 = ${result}km`;
      } else if (fromUnit === 'kilometers' && toUnit === 'meters') {
        result = value * 1000;
        exp = `${value}km × 1000 = ${result}m`;
      } else if (fromUnit === 'meters' && toUnit === 'centimeters') {
        result = value * 100;
        exp = `${value}m × 100 = ${result}cm`;
      } else if (fromUnit === toUnit) {
        result = value;
        exp = `${value} ${fromUnit} = ${result} ${toUnit}`;
      }
    }

    setToValue(result.toFixed(5));
    setExplanation(exp);
  };

  useEffect(() => {
    const units = unitsByCategory[category as keyof typeof unitsByCategory];
    if (units.length > 0) {
      setFromUnit(units[0].value);
      setToUnit(units[1]?.value || units[0].value);
    }
    setFromValue('');
    setToValue('');
    setExplanation('');
  }, [category]);

  useEffect(() => {
    if (fromValue) {
      convertValue();
    }
  }, [fromValue, fromUnit, toUnit]);

  const swapUnits = () => {
    setFromUnit(toUnit);
    setToUnit(fromUnit);
    setFromValue(toValue);
  };

  const units = unitsByCategory[category as keyof typeof unitsByCategory] || [];

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">UnitFlip Pro</h1>
        <p className="text-xl text-gray-600">Convertissez toutes vos unités avec précision</p>
      </div>

      {/* Sélecteur de catégorie */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-lg font-semibold mb-4">Catégories</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {Object.keys(unitsByCategory).map((cat) => (
            <button
              key={cat}
              onClick={() => setCategory(cat)}
              className={`p-4 rounded-lg border-2 transition-colors ${
                category === cat
                  ? 'border-indigo-500 bg-indigo-50 text-indigo-700'
                  : 'border-gray-200 hover:border-gray-300'
              }`}
              data-testid={`category-${cat}`}
            >
              <div className="font-medium capitalize">{cat}</div>
              <div className="text-sm text-gray-500">
                {cat === 'temperature' && '°C, °F, K'}
                {cat === 'length' && 'm, km, ft, in'}
                {cat === 'weight' && 'kg, g, lb, oz'}
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Convertisseur */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold capitalize mb-6">
          Conversion de {category}
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-end">
          {/* From Section */}
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-2">De :</label>
              <select
                value={fromUnit}
                onChange={(e) => setFromUnit(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500"
                data-testid="from-unit-selector"
              >
                {units.map((unit) => (
                  <option key={unit.value} value={unit.value}>
                    {unit.label}
                  </option>
                ))}
              </select>
            </div>
            
            <input
              type="number"
              value={fromValue}
              onChange={(e) => setFromValue(e.target.value)}
              placeholder="Entrez une valeur"
              className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 text-lg"
              data-testid="value-input"
            />
          </div>

          {/* Swap Button */}
          <div className="flex justify-center md:mb-4">
            <button
              onClick={swapUnits}
              className="p-3 rounded-full bg-indigo-100 hover:bg-indigo-200 transition-colors"
              data-testid="swap-button"
            >
              ⇄
            </button>
          </div>

          {/* To Section */}
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-2">Vers :</label>
              <select
                value={toUnit}
                onChange={(e) => setToUnit(e.target.value)}
                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500"
                data-testid="to-unit-selector"
              >
                {units.map((unit) => (
                  <option key={unit.value} value={unit.value}>
                    {unit.label}
                  </option>
                ))}
              </select>
            </div>
            
            <input
              type="text"
              value={toValue}
              readOnly
              placeholder="Résultat"
              className="w-full p-3 border border-gray-300 rounded-lg bg-gray-50 text-lg"
              data-testid="result-display"
            />
          </div>
        </div>

        {/* Explanation */}
        {explanation && (
          <div className="mt-6 p-4 bg-indigo-50 border border-indigo-200 rounded-lg">
            <h4 className="font-medium text-indigo-900 mb-2">Explication</h4>
            <p className="text-indigo-800" data-testid="explanation">{explanation}</p>
          </div>
        )}

        {/* Conversions courantes */}
        {category === 'temperature' && (
          <div className="mt-6 p-4 bg-gray-50 rounded-lg">
            <h4 className="font-medium mb-3">Conversions courantes</h4>
            <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-sm">
              <div className="text-center p-2 bg-white rounded">
                <div className="font-medium">0°C</div>
                <div className="text-gray-600">32°F</div>
              </div>
              <div className="text-center p-2 bg-white rounded">
                <div className="font-medium">100°C</div>
                <div className="text-gray-600">212°F</div>
              </div>
              <div className="text-center p-2 bg-white rounded">
                <div className="font-medium">20°C</div>
                <div className="text-gray-600">68°F</div>
              </div>
              <div className="text-center p-2 bg-white rounded">
                <div className="font-medium">37°C</div>
                <div className="text-gray-600">98.6°F</div>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
