'use client';

import { useState } from 'react';

interface Transaction {
  id: string;
  amount: number;
  merchant: string;
  category: string;
  date: string;
  description: string;
}

export default function HomePage() {
  const [transactions, setTransactions] = useState<Transaction[]>([
    {
      id: '1',
      amount: -45.60,
      merchant: 'Carrefour',
      category: 'Alimentation',
      date: '2025-07-15',
      description: 'Courses hebdomadaires'
    },
    {
      id: '2',
      amount: -12.50,
      merchant: 'RATP',
      category: 'Transport',
      date: '2025-07-15',
      description: 'Ticket de métro'
    },
    {
      id: '3',
      amount: 2800.00,
      merchant: 'Entreprise ABC',
      category: 'Salaire',
      date: '2025-07-01',
      description: 'Salaire juillet'
    }
  ]);

  const [newTransaction, setNewTransaction] = useState({
    amount: '',
    merchant: '',
    category: 'Alimentation',
    description: ''
  });

  const categories = [
    'Alimentation',
    'Transport',
    'Logement',
    'Loisirs',
    'Santé',
    'Salaire',
    'Autre'
  ];

  const totalBalance = transactions.reduce((sum, t) => sum + t.amount, 0);
  const monthlyIncome = transactions
    .filter(t => t.amount > 0)
    .reduce((sum, t) => sum + t.amount, 0);
  const monthlyExpenses = Math.abs(transactions
    .filter(t => t.amount < 0)
    .reduce((sum, t) => sum + t.amount, 0));

  const addTransaction = () => {
    if (!newTransaction.amount || !newTransaction.merchant) return;

    const transaction: Transaction = {
      id: Date.now().toString(),
      amount: parseFloat(newTransaction.amount),
      merchant: newTransaction.merchant,
      category: newTransaction.category,
      date: new Date().toISOString().split('T')[0],
      description: newTransaction.description
    };

    setTransactions([transaction, ...transactions]);
    setNewTransaction({
      amount: '',
      merchant: '',
      category: 'Alimentation',
      description: ''
    });
  };

  const formatCurrency = (amount: number): string => {
    return new Intl.NumberFormat('fr-FR', {
      style: 'currency',
      currency: 'EUR'
    }).format(amount);
  };

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">💰 BudgetCron</h1>
        <p className="text-xl text-gray-600">Gérez votre budget intelligemment</p>
      </div>

      {/* Statistiques */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-700 mb-2">Solde Total</h3>
          <p className={`text-3xl font-bold ${totalBalance >= 0 ? 'text-green-600' : 'text-red-600'}`}>
            {formatCurrency(totalBalance)}
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-700 mb-2">Revenus du Mois</h3>
          <p className="text-3xl font-bold text-green-600">
            {formatCurrency(monthlyIncome)}
          </p>
        </div>
        
        <div className="bg-white p-6 rounded-lg shadow">
          <h3 className="text-lg font-semibold text-gray-700 mb-2">Dépenses du Mois</h3>
          <p className="text-3xl font-bold text-red-600">
            {formatCurrency(monthlyExpenses)}
          </p>
        </div>
      </div>

      {/* Formulaire d'ajout */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-6">Ajouter une Transaction</h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Montant (€)
            </label>
            <input
              type="number"
              step="0.01"
              value={newTransaction.amount}
              onChange={(e) => setNewTransaction({...newTransaction, amount: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="Ex: -25.50 ou 1500.00"
              data-testid="amount-input"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Marchand/Source
            </label>
            <input
              type="text"
              value={newTransaction.merchant}
              onChange={(e) => setNewTransaction({...newTransaction, merchant: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="Ex: Carrefour, RATP..."
              data-testid="merchant-input"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Catégorie
            </label>
            <select
              value={newTransaction.category}
              onChange={(e) => setNewTransaction({...newTransaction, category: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              data-testid="category-select"
            >
              {categories.map(cat => (
                <option key={cat} value={cat}>{cat}</option>
              ))}
            </select>
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Description (optionnel)
            </label>
            <input
              type="text"
              value={newTransaction.description}
              onChange={(e) => setNewTransaction({...newTransaction, description: e.target.value})}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
              placeholder="Description..."
              data-testid="description-input"
            />
          </div>
        </div>
        
        <button
          onClick={addTransaction}
          className="mt-4 bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700"
          data-testid="add-button"
        >
          Ajouter la Transaction
        </button>
      </div>

      {/* Liste des transactions */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold mb-6">Transactions Récentes</h2>
        
        <div className="space-y-4" data-testid="transactions-list">
          {transactions.map((transaction) => (
            <div key={transaction.id} className="flex justify-between items-center p-4 border border-gray-200 rounded-lg">
              <div className="flex-1">
                <div className="flex justify-between items-start">
                  <div>
                    <h4 className="font-medium">{transaction.merchant}</h4>
                    <p className="text-sm text-gray-600">{transaction.category}</p>
                    {transaction.description && (
                      <p className="text-sm text-gray-500">{transaction.description}</p>
                    )}
                  </div>
                  <div className="text-right">
                    <p className={`text-lg font-semibold ${
                      transaction.amount >= 0 ? 'text-green-600' : 'text-red-600'
                    }`}>
                      {formatCurrency(transaction.amount)}
                    </p>
                    <p className="text-sm text-gray-500">{transaction.date}</p>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
