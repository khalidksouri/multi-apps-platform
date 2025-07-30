<template>
  <div id="app">
    <div class="container">
      <h1>💰 BUDGETCRON</h1>
      <p>Gestion de budget familial</p>
      
      <div class="budget-form">
        <div class="input-group">
          <label>Revenus mensuels:</label>
          <input v-model="income" type="number" placeholder="2000">
          <span>€</span>
        </div>
        
        <div class="input-group">
          <label>Dépenses:</label>
          <input v-model="expenses" type="number" placeholder="1500">
          <span>€</span>
        </div>
        
        <div class="result" :class="{ positive: balance > 0, negative: balance < 0 }">
          <h2>Solde: {{ balance }}€</h2>
          <p v-if="balance > 0">✅ Budget équilibré !</p>
          <p v-else>⚠️ Attention aux dépenses</p>
        </div>
      </div>
      
      <div class="tips">
        <h3>💡 Conseils:</h3>
        <ul>
          <li>🏦 Épargner 10% de vos revenus</li>
          <li>📊 Suivre vos dépenses quotidiennes</li>
          <li>🎯 Fixer des objectifs financiers</li>
        </ul>
      </div>
      
      <p class="status">✅ Application Vue.js opérationnelle sur le port 3003</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      income: 2000,
      expenses: 1500
    }
  },
  computed: {
    balance() {
      return this.income - this.expenses;
    }
  }
}
</script>

<style>
#app {
  text-align: center;
  background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: Arial, sans-serif;
  padding: 20px;
}

.container {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  width: 100%;
}

h1 {
  font-size: 3rem;
  margin-bottom: 1rem;
  color: #667eea;
}

.budget-form {
  margin: 2rem 0;
}

.input-group {
  margin: 1rem 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

input {
  font-size: 1.2rem;
  padding: 10px;
  border-radius: 10px;
  border: 2px solid #667eea;
  width: 150px;
}

.result {
  margin: 2rem 0;
  padding: 20px;
  border-radius: 15px;
  font-size: 1.5rem;
}

.result.positive {
  background: linear-gradient(45deg, #4CAF50, #8BC34A);
  color: white;
}

.result.negative {
  background: linear-gradient(45deg, #F44336, #FF9800);
  color: white;
}

.tips {
  text-align: left;
  background: rgba(102, 126, 234, 0.1);
  padding: 20px;
  border-radius: 15px;
  margin: 2rem 0;
}

.tips ul {
  list-style: none;
  padding: 0;
}

.tips li {
  padding: 5px 0;
}

.status {
  margin-top: 2rem;
  opacity: 0.7;
  font-size: 0.9rem;
}
</style>
