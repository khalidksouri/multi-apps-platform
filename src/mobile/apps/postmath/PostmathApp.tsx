import React, { useState } from 'react';

interface PostmathAppProps {
  isNative?: boolean;
}

const PostmathApp: React.FC<PostmathAppProps> = ({ isNative = false }) => {
  const [num1, setNum1] = useState('');
  const [num2, setNum2] = useState('');
  const [operation, setOperation] = useState<'add' | 'subtract' | 'multiply' | 'divide'>('add');
  const [result, setResult] = useState<number | null>(null);

  const calculate = () => {
    const a = parseFloat(num1);
    const b = parseFloat(num2);

    if (isNaN(a) || isNaN(b)) {
      alert('Veuillez entrer des nombres valides');
      return;
    }

    let calcResult: number;
    switch (operation) {
      case 'add':
        calcResult = a + b;
        break;
      case 'subtract':
        calcResult = a - b;
        break;
      case 'multiply':
        calcResult = a * b;
        break;
      case 'divide':
        if (b === 0) {
          alert('Division par zéro impossible');
          return;
        }
        calcResult = a / b;
        break;
    }

    setResult(calcResult);
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
    <div className="min-h-screen bg-gradient-to-br from-indigo-500 to-purple-600 p-4">
      <div className="max-w-md mx-auto">
        {/* Header */}
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🧮 Postmath</h1>
          <p className="text-white/80">Calculatrice {isNative ? 'Mobile' : 'Web'}</p>
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
      </div>
    </div>
  );
};

export default PostmathApp;
