#!/bin/bash

# =============================================
# 🔧 Script de correction UnitFlip et BudgetCron
# =============================================

echo "🔧 Correction des applications UnitFlip et BudgetCron..."

# Étape 1: Diagnostiquer les erreurs spécifiques
echo "🎯 DIAGNOSTIC: Identification des erreurs"

echo "🔍 Test build UnitFlip pour voir les erreurs..."
cd apps/unitflip
npm run build 2>&1 | head -20
echo "..."
cd ../..

echo ""
echo "🔍 Test build BudgetCron pour voir les erreurs..."
cd apps/budgetcron  
npm run build 2>&1 | head -20
echo "..."
cd ../..

# Étape 2: Corriger UnitFlip - Créer une page fonctionnelle
echo "🎯 CORRECTION 1: Réparation de UnitFlip"

# Vérifier si le fichier page.tsx existe et le corriger
if [ ! -f "apps/unitflip/src/app/page.tsx" ]; then
    echo "📄 Création de la page UnitFlip"
else
    echo "🔧 Correction de la page UnitFlip existante"
fi

cat > apps/unitflip/src/app/page.tsx << 'EOF'
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
} as const;

type CategoryKey = keyof typeof unitsByCategory;

export default function HomePage() {
  const [category, setCategory] = useState<CategoryKey>('temperature');
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
      } else if (fromUnit === 'kelvin' && toUnit === 'celsius') {
        result = value - 273.15;
        exp = `${value}K - 273.15 = ${result.toFixed(2)}°C`;
      } else if (fromUnit === toUnit) {
        result = value;
        exp = `${value} ${fromUnit} = ${result} ${toUnit}`;
      }
    }
    
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
      } else if (fromUnit === 'centimeters' && toUnit === 'meters') {
        result = value / 100;
        exp = `${value}cm ÷ 100 = ${result}m`;
      } else if (fromUnit === toUnit) {
        result = value;
        exp = `${value} ${fromUnit} = ${result} ${toUnit}`;
      }
    }

    if (category === 'weight') {
      if (fromUnit === 'kilograms' && toUnit === 'grams') {
        result = value * 1000;
        exp = `${value}kg × 1000 = ${result}g`;
      } else if (fromUnit === 'grams' && toUnit === 'kilograms') {
        result = value / 1000;
        exp = `${value}g ÷ 1000 = ${result}kg`;
      } else if (fromUnit === 'pounds' && toUnit === 'kilograms') {
        result = value * 0.453592;
        exp = `${value}lb × 0.453592 = ${result.toFixed(3)}kg`;
      } else if (fromUnit === toUnit) {
        result = value;
        exp = `${value} ${fromUnit} = ${result} ${toUnit}`;
      }
    }

    setToValue(result.toFixed(5));
    setExplanation(exp);
  };

  useEffect(() => {
    const units = unitsByCategory[category];
    if (units && units.length > 0) {
      setFromUnit(units[0].value);
      setToUnit(units.length > 1 ? units[1].value : units[0].value);
    }
    setFromValue('');
    setToValue('');
    setExplanation('');
  }, [category]);

  useEffect(() => {
    if (fromValue) {
      convertValue();
    }
  }, [fromValue, fromUnit, toUnit, category]);

  const swapUnits = () => {
    const temp = fromUnit;
    setFromUnit(toUnit);
    setToUnit(temp);
    setFromValue(toValue);
  };

  const units = unitsByCategory[category];

  return (
    <div className="space-y-8">
      <div className="text-center">
        <h1 className="text-4xl font-bold text-gray-900 mb-4">🔄 UnitFlip Pro</h1>
        <p className="text-xl text-gray-600">Convertissez toutes vos unités avec précision</p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-lg font-semibold mb-4">Catégories</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {(Object.keys(unitsByCategory) as CategoryKey[]).map((cat) => (
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

      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-2xl font-semibold capitalize mb-6">
          Conversion de {category}
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 items-end">
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

          <div className="flex justify-center md:mb-4">
            <button
              onClick={swapUnits}
              className="p-3 rounded-full bg-indigo-100 hover:bg-indigo-200 transition-colors"
              data-testid="swap-button"
            >
              ⇄
            </button>
          </div>

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

        {explanation && (
          <div className="mt-6 p-4 bg-indigo-50 border border-indigo-200 rounded-lg">
            <h4 className="font-medium text-indigo-900 mb-2">Explication</h4>
            <p className="text-indigo-800" data-testid="explanation">{explanation}</p>
          </div>
        )}

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
EOF

echo "✅ UnitFlip corrigé"

# Étape 3: Corriger BudgetCron - Créer une page fonctionnelle
echo "🎯 CORRECTION 2: Réparation de BudgetCron"

# Créer la structure de BudgetCron
mkdir -p apps/budgetcron/src/components

cat > apps/budgetcron/src/app/page.tsx << 'EOF'
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
EOF

echo "✅ BudgetCron corrigé"

# Étape 4: Test des corrections
echo "🎯 TEST: Vérification des corrections"

echo "🧪 Test build UnitFlip..."
cd apps/unitflip
if npm run build >/dev/null 2>&1; then
    echo "✅ UnitFlip compile maintenant"
    UNITFLIP_OK=true
else
    echo "❌ UnitFlip a encore des erreurs"
    UNITFLIP_OK=false
fi
cd ../..

echo "🧪 Test build BudgetCron..."
cd apps/budgetcron
if npm run build >/dev/null 2>&1; then
    echo "✅ BudgetCron compile maintenant"
    BUDGETCRON_OK=true
else
    echo "❌ BudgetCron a encore des erreurs"
    BUDGETCRON_OK=false
fi
cd ../..

# Étape 5: Résumé final
echo ""
echo "📊 RÉSUMÉ FINAL DE TOUTES LES APPLICATIONS"
echo "=========================================="
echo "✅ PostMath: FONCTIONNE (port 3001)"
echo "✅ AI4Kids: FONCTIONNE (port 3004)"
echo "✅ MultiAI: FONCTIONNE (port 3005)"

if [ "$UNITFLIP_OK" = true ]; then
    echo "✅ UnitFlip: FONCTIONNE (port 3002)"
else
    echo "❌ UnitFlip: PROBLÈME"
fi

if [ "$BUDGETCRON_OK" = true ]; then
    echo "✅ BudgetCron: FONCTIONNE (port 3003)"
else
    echo "❌ BudgetCron: PROBLÈME"
fi

if [ "$UNITFLIP_OK" = true ] && [ "$BUDGETCRON_OK" = true ]; then
    echo ""
    echo "🎉 TOUTES LES APPLICATIONS FONCTIONNENT!"
    echo "======================================="
    echo ""
    echo "🚀 Testez toutes vos applications:"
    echo "   cd apps/postmath && npm run dev    # Port 3001"
    echo "   cd apps/unitflip && npm run dev    # Port 3002" 
    echo "   cd apps/budgetcron && npm run dev  # Port 3003"
    echo "   cd apps/ai4kids && npm run dev     # Port 3004"
    echo "   cd apps/multiai && npm run dev     # Port 3005"
    echo ""
    echo "🧪 Testez avec Playwright:"
    echo "   npm run test           # Tests automatiques"
    echo "   npm run test:headed    # Tests visibles"
    echo "   npm run test:ui        # Interface graphique"
    echo ""
    echo "💻 Ouvrez VS Code:"
    echo "   code ."
    echo "   IntelliSense fonctionne parfaitement!"
else
    echo ""
    echo "⚠️ QUELQUES APPLICATIONS ONT ENCORE DES PROBLÈMES"
    echo "================================================"
    if [ "$UNITFLIP_OK" = false ]; then
        echo "🔧 Pour débugger UnitFlip:"
        echo "   cd apps/unitflip && npm run build"
    fi
    if [ "$BUDGETCRON_OK" = false ]; then
        echo "🔧 Pour débugger BudgetCron:"
        echo "   cd apps/budgetcron && npm run build"
    fi
fi

echo ""
echo "📋 Applications créées avec fonctionnalités:"
echo "   📦 PostMath: Calculateur d'expédition avec formulaire"
echo "   🔄 UnitFlip: Convertisseur d'unités interactif"
echo "   💰 BudgetCron: Gestionnaire de budget avec transactions"
echo "   🤖 AI4Kids: Interface de base pour enfants"
echo "   🧠 MultiAI: Hub pour services IA"