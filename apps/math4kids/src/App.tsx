import React, { useState, useEffect } from 'react';
import { Capacitor } from '@capacitor/core';
import { Haptics, ImpactStyle } from '@capacitor/haptics';
import { StatusBar, Style } from '@capacitor/status-bar';
import LanguageSelector from './components/LanguageSelector';
import { t } from './i18n';

const App: React.FC = () => {
  const [num1, setNum1] = useState('');
  const [num2, setNum2] = useState('');
  const [operation, setOperation] = useState<'add' | 'subtract' | 'multiply' | 'divide'>('add');
  const [result, setResult] = useState<number | null>(null);
  const [history, setHistory] = useState<string[]>([]);
  const [isNative, setIsNative] = useState(false);

  useEffect(() => {
    setIsNative(Capacitor.isNativePlatform());
    
    if (Capacitor.isNativePlatform()) {
      StatusBar.setStyle({ style: Style.Light });
      StatusBar.setBackgroundColor({ color: '#667eea' });
    }
  }, []);

  const triggerHaptic = async (style: ImpactStyle = ImpactStyle.Light) => {
    if (isNative && Capacitor.isNativePlatform()) {
      await Haptics.impact({ style });
    }
  };

  const calculate = async () => {
    const a = parseFloat(num1);
    const b = parseFloat(num2);

    if (isNaN(a) || isNaN(b)) {
      await triggerHaptic(ImpactStyle.Heavy);
      alert(t('enterValidNumbers'));
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
          await triggerHaptic(ImpactStyle.Heavy);
          alert(t('divisionByZero'));
          return;
        }
        calcResult = a / b;
        operatorSymbol = '÷';
        break;
    }

    await triggerHaptic(ImpactStyle.Light);
    const calculationString = `${num1} ${operatorSymbol} ${num2} = ${calcResult}`;
    setResult(calcResult);
    setHistory(prev => [calculationString, ...prev.slice(0, 9)]);
  };

  const clear = async () => {
    await triggerHaptic(ImpactStyle.Medium);
    setNum1('');
    setNum2('');
    setResult(null);
  };

  const setOperationWithHaptic = async (op: typeof operation) => {
    await triggerHaptic(ImpactStyle.Light);
    setOperation(op);
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
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-purple-600">
      <div className="p-4">
        <div className="max-w-md mx-auto">
          {/* Header avec sélecteur de langue */}
          <div className="flex justify-between items-center mb-6">
            <div className="text-center flex-1">
              <h1 className="text-4xl font-bold text-white mb-2">🧮 Postmath Pro</h1>
              <p className="text-white/80">Calculatrice Avancée</p>
            </div>
            <LanguageSelector className="ml-4" />
          </div>

          {/* Calculatrice */}
          <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20 mb-4">
            <div className="grid grid-cols-3 gap-4 mb-6 items-center">
              <input
                type="number"
                value={num1}
                onChange={(e) => setNum1(e.target.value)}
                placeholder={t('placeholders.firstNumber')}
                className="bg-white/90 rounded-xl p-3 text-center text-gray-800 placeholder-gray-500 text-lg font-semibold"
              />
              
              <div className="text-3xl font-bold text-white text-center">
                {getOperatorSymbol()}
              </div>
              
              <input
                type="number"
                value={num2}
                onChange={(e) => setNum2(e.target.value)}
                placeholder={t('placeholders.secondNumber')}
                className="bg-white/90 rounded-xl p-3 text-center text-gray-800 placeholder-gray-500 text-lg font-semibold"
              />
            </div>

            <div className="grid grid-cols-4 gap-2 mb-6">
              {(['add', 'subtract', 'multiply', 'divide'] as const).map((op) => (
                <button
                  key={op}
                  onClick={() => setOperationWithHaptic(op)}
                  className={`p-4 rounded-xl font-bold text-white transition-all duration-200 ${
                    operation === op 
                      ? 'bg-green-500 scale-105 shadow-lg' 
                      : 'bg-white/20 hover:bg-white/30 active:scale-95'
                  }`}
                  title={t(`operations.${op}`)}
                >
                  <span className="text-xl">
                    {op === 'add' ? '+' : op === 'subtract' ? '-' : 
                     op === 'multiply' ? '×' : '÷'}
                  </span>
                </button>
              ))}
            </div>

            <div className="grid grid-cols-2 gap-3 mb-6">
              <button
                onClick={calculate}
                className="bg-green-500 hover:bg-green-600 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95 shadow-lg"
              >
                = {t('calculate')}
              </button>
              <button
                onClick={clear}
                className="bg-red-500/80 hover:bg-red-500 text-white font-bold py-4 rounded-xl transition-all duration-200 active:scale-95"
              >
                🗑️ {t('clear')}
              </button>
            </div>

            {result !== null && (
              <div className="bg-green-500/30 rounded-xl p-4 text-center border border-green-400/30 animate-pulse">
                <p className="text-2xl font-bold text-white">
                  {num1} {getOperatorSymbol()} {num2} = <span className="text-green-200">{result}</span>
                </p>
              </div>
            )}
          </div>

          {/* Historique */}
          {history.length > 0 && (
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-4 border border-white/20">
              <h3 className="text-white font-semibold mb-3">📜 {t('history')}</h3>
              <div className="space-y-2 max-h-40 overflow-y-auto">
                {history.map((calc, index) => (
                  <div 
                    key={index} 
                    className="text-white/80 text-sm bg-white/5 rounded-lg p-2 hover:bg-white/10 transition-colors"
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
