'use client';

import { useState } from 'react';

export default function HomePage() {
  const [selectedInsight, setSelectedInsight] = useState(null);

  const budgetData = {
    totalBudget: 2500,
    spent: 1850,
    remaining: 650,
    categories: [
      { name: 'Alimentation', budget: 600, spent: 420, color: 'bg-blue-500' },
      { name: 'Transport', budget: 300, spent: 280, color: 'bg-green-500' },
      { name: 'Loisirs', budget: 200, spent: 150, color: 'bg-purple-500' },
      { name: 'Logement', budget: 1200, spent: 1200, color: 'bg-red-500' },
    ],
  };

  const insights = [
    {
      id: 1,
      type: 'savings_opportunity',
      title: 'Économie détectée',
      description: 'Vous pourriez économiser 85€/mois en cuisinant 2 fois plus par semaine.',
      confidence: 87,
      color: 'text-green-600 bg-green-50',
    },
    {
      id: 2,
      type: 'budget_alert',
      title: 'Alerte budget',
      description: 'Votre budget transport atteint 93%. Surveillez vos dépenses.',
      confidence: 95,
      color: 'text-orange-600 bg-orange-50',
    },
    {
      id: 3,
      type: 'spending_pattern',
      title: 'Pattern détecté',
      description: 'Vos achats weekend sont 40% plus élevés que la moyenne.',
      confidence: 78,
      color: 'text-blue-600 bg-blue-50',
    },
  ];

  const spentPercentage = (budgetData.spent / budgetData.totalBudget) * 100;

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Tableau de bord</h1>
        <p className="text-gray-600">Aperçu de vos finances</p>
      </div>

      {/* Vue d'ensemble du budget */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Budget total</p>
              <p className="text-2xl font-bold">{budgetData.totalBudget}€</p>
            </div>
            <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
              🎯
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Dépensé</p>
              <p className="text-2xl font-bold text-red-600">{budgetData.spent}€</p>
              <p className="text-xs text-gray-500">{spentPercentage.toFixed(1)}% du budget</p>
            </div>
            <div className="w-8 h-8 bg-red-100 rounded-full flex items-center justify-center">
              📊
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Restant</p>
              <p className="text-2xl font-bold text-green-600">{budgetData.remaining}€</p>
              <p className="text-xs text-gray-500">
                {((budgetData.remaining / budgetData.totalBudget) * 100).toFixed(1)}% restant
              </p>
            </div>
            <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
              💰
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm font-medium text-gray-600">Alertes</p>
              <p className="text-2xl font-bold text-orange-600">2</p>
              <p className="text-xs text-gray-500">Budgets dépassés</p>
            </div>
            <div className="w-8 h-8 bg-orange-100 rounded-full flex items-center justify-center">
              ⚠️
            </div>
          </div>
        </div>
      </div>

      {/* Progression par catégorie */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h3 className="text-lg font-semibold mb-4">Progression par catégorie</h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {budgetData.categories.map((category) => {
            const percentage = (category.spent / category.budget) * 100;
            const isOverBudget = percentage > 100;
            
            return (
              <div key={category.name} className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="font-medium">{category.name}</span>
                  <span className={isOverBudget ? 'text-red-600' : 'text-gray-600'}>
                    {category.spent}€ / {category.budget}€
                  </span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div
                    className={`h-2 rounded-full ${
                      isOverBudget ? 'bg-red-500' : category.color
                    }`}
                    style={{ width: `${Math.min(percentage, 100)}%` }}
                  />
                </div>
                <div className="text-xs text-gray-500">
                  {percentage.toFixed(1)}% utilisé
                </div>
              </div>
            );
          })}
        </div>
      </div>

      {/* Insights IA */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h3 className="text-lg font-semibold mb-4 flex items-center">
          🧠 Insights IA
        </h3>
        <div className="space-y-4">
          {insights.map((insight) => (
            <div
              key={insight.id}
              className={`p-4 rounded-lg border ${insight.color}`}
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <h4 className="font-medium mb-1">{insight.title}</h4>
                  <p className="text-sm mb-2">{insight.description}</p>
                  <div className="flex items-center justify-between">
                    <span className="text-xs">Confiance: {insight.confidence}%</span>
                    <button className="text-xs bg-white px-2 py-1 rounded border hover:bg-gray-50">
                      Voir détails
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Comptes bancaires */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h3 className="text-lg font-semibold mb-4 flex items-center justify-between">
          🏦 Comptes bancaires
          <button className="text-sm bg-green-600 text-white px-3 py-1 rounded hover:bg-green-700">
            + Synchroniser
          </button>
        </h3>
        <div className="space-y-3">
          {[
            { name: 'Crédit Agricole', type: 'Compte courant', balance: 2450.50, status: 'active' },
            { name: 'BNP Paribas', type: 'Livret A', balance: 15000.00, status: 'active' },
            { name: 'Revolut', type: 'Compte courant', balance: 320.75, status: 'error' },
          ].map((bank, index) => (
            <div key={index} className="p-3 border rounded-lg hover:shadow-sm transition-shadow">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center space-x-2">
                  <h4 className="font-medium text-gray-900">{bank.name}</h4>
                  <span className={`w-2 h-2 rounded-full ${
                    bank.status === 'active' ? 'bg-green-500' : 'bg-red-500'
                  }`}></span>
                </div>
                <span className="text-lg font-semibold">
                  {bank.balance.toLocaleString('fr-FR', { style: 'currency', currency: 'EUR' })}
                </span>
              </div>
              <div className="flex items-center justify-between text-sm text-gray-600">
                <span>{bank.type}</span>
                <span>Sync: {new Date().toLocaleDateString('fr-FR')}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
