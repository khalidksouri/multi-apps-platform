import React, { useState } from 'react';

interface BudgetCronAppProps {
  isNative?: boolean;
}

const BudgetCronApp: React.FC<BudgetCronAppProps> = ({ isNative = false }) => {
  const [income, setIncome] = useState('');
  const [expenses, setExpenses] = useState('');

  const balance = parseFloat(income || '0') - parseFloat(expenses || '0');

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-500 to-cyan-600 p-4">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">💰 BudgetCron</h1>
          <p className="text-white/80">Gestionnaire {isNative ? 'Mobile' : 'Web'}</p>
        </div>

        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="space-y-4 mb-6">
            <input
              type="number"
              value={income}
              onChange={(e) => setIncome(e.target.value)}
              placeholder="Revenus"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            />
            
            <input
              type="number"
              value={expenses}
              onChange={(e) => setExpenses(e.target.value)}
              placeholder="Dépenses"
              className="w-full bg-white/90 rounded-xl p-3 text-gray-800"
            />
          </div>

          <div className="bg-blue-500/30 rounded-xl p-4 text-center">
            <p className="text-sm text-white/80 mb-1">Solde</p>
            <p className={`text-3xl font-bold ${balance >= 0 ? 'text-green-300' : 'text-red-300'}`}>
              {balance.toFixed(2)} €
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default BudgetCronApp;
