import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

// Données simulées du budget
let budget = {
  income: 3000,
  expenses: [
    { category: 'Logement', amount: 1200, color: '#FF6B6B' },
    { category: 'Alimentation', amount: 400, color: '#4ECDC4' },
    { category: 'Transport', amount: 200, color: '#45B7D1' },
    { category: 'Loisirs', amount: 300, color: '#96CEB4' },
    { category: 'Divers', amount: 150, color: '#FECA57' }
  ]
};

fastify.get('/', async (request, reply) => {
  const totalExpenses = budget.expenses.reduce((sum, exp) => sum + exp.amount, 0);
  const remaining = budget.income - totalExpenses;

  return reply.type('text/html').send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BudgetCron - Gestion de Budget</title>
        <style>
            body {
                font-family: 'Segoe UI', system-ui, sans-serif;
                margin: 0;
                padding: 2rem;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: #333;
                min-height: 100vh;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                text-align: center;
            }
            .header h1 { font-size: 3rem; margin: 0; }
            .header p { font-size: 1.2rem; opacity: 0.9; margin: 0.5rem 0; }
            .content { padding: 2rem; }
            .summary {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin-bottom: 2rem;
            }
            .card {
                background: #f8f9fa;
                padding: 1.5rem;
                border-radius: 15px;
                text-align: center;
                border-left: 4px solid;
            }
            .income { border-color: #28a745; }
            .expenses { border-color: #dc3545; }
            .remaining { border-color: #17a2b8; }
            .card h3 { margin: 0 0 0.5rem 0; font-size: 1rem; color: #666; }
            .card .amount { font-size: 2rem; font-weight: bold; margin: 0; }
            .expense-list {
                background: #f8f9fa;
                border-radius: 15px;
                padding: 1.5rem;
                margin: 1rem 0;
            }
            .expense-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 1rem;
                margin: 0.5rem 0;
                background: white;
                border-radius: 10px;
                border-left: 4px solid;
                transition: transform 0.2s;
            }
            .expense-item:hover { transform: translateX(5px); }
            .add-expense {
                display: grid;
                grid-template-columns: 2fr 1fr auto;
                gap: 1rem;
                margin-top: 1rem;
                align-items: end;
            }
            input, button {
                padding: 0.75rem;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 1rem;
            }
            button {
                background: #667eea;
                color: white;
                border: none;
                cursor: pointer;
                transition: background 0.3s;
            }
            button:hover { background: #5a6fd8; }
            .chart-container {
                background: #f8f9fa;
                border-radius: 15px;
                padding: 1.5rem;
                margin: 1rem 0;
                text-align: center;
            }
            .chart {
                display: flex;
                height: 20px;
                border-radius: 10px;
                overflow: hidden;
                margin: 1rem 0;
            }
            .chart-segment {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 0.8rem;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>💰 BudgetCron</h1>
                <p>Gestionnaire de Budget Intelligent</p>
            </div>
            
            <div class="content">
                <div class="summary">
                    <div class="card income">
                        <h3>Revenus</h3>
                        <p class="amount" style="color: #28a745;">€${budget.income}</p>
                    </div>
                    <div class="card expenses">
                        <h3>Dépenses</h3>
                        <p class="amount" style="color: #dc3545;">€${totalExpenses}</p>
                    </div>
                    <div class="card remaining">
                        <h3>Reste</h3>
                        <p class="amount" style="color: ${remaining >= 0 ? '#28a745' : '#dc3545'};">€${remaining}</p>
                    </div>
                </div>

                <div class="chart-container">
                    <h3>Répartition des Dépenses</h3>
                    <div class="chart">
                        ${budget.expenses.map(exp => {
                          const percentage = (exp.amount / totalExpenses) * 100;
                          return `<div class="chart-segment" style="background: ${exp.color}; width: ${percentage}%">${exp.category}</div>`;
                        }).join('')}
                    </div>
                </div>

                <div class="expense-list">
                    <h3>Détail des Dépenses</h3>
                    ${budget.expenses.map(exp => 
                      `<div class="expense-item" style="border-color: ${exp.color}">
                        <span><strong>${exp.category}</strong></span>
                        <span style="color: ${exp.color}; font-weight: bold;">€${exp.amount}</span>
                      </div>`
                    ).join('')}
                    
                    <div class="add-expense">
                        <input type="text" id="categoryInput" placeholder="Nouvelle catégorie">
                        <input type="number" id="amountInput" placeholder="Montant">
                        <button onclick="addExpense()">Ajouter</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            async function addExpense() {
                const category = document.getElementById('categoryInput').value;
                const amount = parseFloat(document.getElementById('amountInput').value);
                
                if (!category || !amount) {
                    alert('Veuillez remplir tous les champs');
                    return;
                }

                try {
                    const response = await fetch('/api/expense', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ category, amount })
                    });

                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Erreur lors de l\\'ajout');
                    }
                } catch (error) {
                    alert('Erreur de connexion');
                }
            }

            // Mise à jour automatique toutes les minutes
            setInterval(() => {
                fetch('/api/budget').then(response => response.json()).then(data => {
                    console.log('Budget updated:', data);
                });
            }, 60000);
        </script>
    </body>
    </html>
  `);
});

fastify.get('/health', async (request, reply) => {
  return { status: 'healthy', service: 'budgetcron', timestamp: new Date().toISOString() };
});

fastify.get('/api/budget', async (request, reply) => {
  const totalExpenses = budget.expenses.reduce((sum, exp) => sum + exp.amount, 0);
  return {
    ...budget,
    totalExpenses,
    remaining: budget.income - totalExpenses,
    timestamp: new Date().toISOString()
  };
});

fastify.post('/api/expense', async (request, reply) => {
  const { category, amount } = request.body as any;
  
  if (!category || !amount) {
    return reply.code(400).send({ error: 'Catégorie et montant requis' });
  }

  const colors = ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4', '#FECA57', '#FF9F43', '#A55EEA'];
  const newExpense = {
    category,
    amount: parseFloat(amount),
    color: colors[budget.expenses.length % colors.length]
  };

  budget.expenses.push(newExpense);

  return { success: true, expense: newExpense };
});

const start = async () => {
  try {
    const port = parseInt(process.env.BUDGETCRON_PORT || '3003');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`💰 BudgetCron server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
