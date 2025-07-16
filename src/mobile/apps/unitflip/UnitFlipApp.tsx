import React, { useState } from 'react';

interface UnitFlipAppProps {
  isNative?: boolean;
}

const UnitFlipApp: React.FC<UnitFlipAppProps> = ({ isNative = false }) => {
  const [inputValue, setInputValue] = useState('');
  const [fromUnit, setFromUnit] = useState('meters');
  const [toUnit, setToUnit] = useState('feet');
  const [result, setResult] = useState<number | null>(null);

  const conversions = {
    meters: 1,
    feet: 3.28084,
    inches: 39.3701,
    centimeters: 100,
  };

  const convert = () => {
    const value = parseFloat(inputValue);
    if (isNaN(value)) return;

    const meters = value / conversions[fromUnit as keyof typeof conversions];
    const convertedValue = meters * conversions[toUnit as keyof typeof conversions];
    setResult(convertedValue);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-emerald-500 to-teal-600 p-4">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🔄 UnitFlip</h1>
          <p className="text-white/80">Convertisseur {isNative ? 'Mobile' : 'Web'}</p>
        </div>

        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="space-y-4 mb-6">
            <input
              type="number"
              value={inputValue}
              onChange={(e) => setInputValue(e.target.value)}
              placeholder="Valeur à convertir"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            />
            
            <div className="grid grid-cols-2 gap-4">
              <select
                value={fromUnit}
                onChange={(e) => setFromUnit(e.target.value)}
                className="bg-white/90 rounded-xl p-3 text-gray-800"
              >
                <option value="meters">Mètres</option>
                <option value="feet">Pieds</option>
                <option value="inches">Pouces</option>
                <option value="centimeters">Centimètres</option>
              </select>
              
              <select
                value={toUnit}
                onChange={(e) => setToUnit(e.target.value)}
                className="bg-white/90 rounded-xl p-3 text-gray-800"
              >
                <option value="meters">Mètres</option>
                <option value="feet">Pieds</option>
                <option value="inches">Pouces</option>
                <option value="centimeters">Centimètres</option>
              </select>
            </div>
          </div>

          <button
            onClick={convert}
            className="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-4 rounded-xl transition-all"
          >
            🔄 Convertir
          </button>

          {result !== null && (
            <div className="mt-6 bg-emerald-500/30 rounded-xl p-4 text-center">
              <p className="text-xl font-bold text-white">
                Résultat: {result.toFixed(4)}
              </p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default UnitFlipApp;
