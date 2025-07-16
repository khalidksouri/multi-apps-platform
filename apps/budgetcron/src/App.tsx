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
