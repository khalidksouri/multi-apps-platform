import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

// Route principale avec page HTML
fastify.get('/', async (request, reply) => {
  return reply.type('text/html').send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Postmath - Application de Mathématiques</title>
        <style>
            body {
                font-family: 'Segoe UI', system-ui, sans-serif;
                margin: 0;
                padding: 2rem;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
            }
            .container {
                text-align: center;
                background: rgba(255, 255, 255, 0.1);
                padding: 3rem;
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                max-width: 600px;
            }
            h1 {
                font-size: 3rem;
                margin-bottom: 1rem;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
            }
            .subtitle {
                font-size: 1.2rem;
                margin-bottom: 2rem;
                opacity: 0.9;
            }
            .status {
                background: rgba(76, 175, 80, 0.2);
                padding: 1rem;
                border-radius: 10px;
                margin: 2rem 0;
                border: 1px solid rgba(76, 175, 80, 0.3);
            }
            .api-info {
                margin-top: 2rem;
                padding: 1.5rem;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 10px;
                border-left: 4px solid #4CAF50;
            }
            .endpoint {
                font-family: 'Monaco', 'Menlo', monospace;
                background: rgba(0, 0, 0, 0.2);
                padding: 0.5rem;
                border-radius: 5px;
                margin: 0.5rem 0;
                font-size: 0.9rem;
            }
            .timestamp {
                opacity: 0.7;
                font-size: 0.9rem;
                margin-top: 1rem;
            }
            .calculator {
                margin: 2rem 0;
                padding: 1.5rem;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 10px;
            }
            .calc-input {
                margin: 0.5rem;
                padding: 0.5rem;
                border: none;
                border-radius: 5px;
                background: rgba(255, 255, 255, 0.2);
                color: white;
                font-size: 1rem;
                width: 80px;
                text-align: center;
            }
            .calc-input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }
            .calc-button {
                margin: 0.5rem;
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 5px;
                background: rgba(76, 175, 80, 0.8);
                color: white;
                font-size: 1rem;
                cursor: pointer;
                transition: background 0.3s;
            }
            .calc-button:hover {
                background: rgba(76, 175, 80, 1);
            }
            .result {
                margin-top: 1rem;
                padding: 1rem;
                background: rgba(76, 175, 80, 0.2);
                border-radius: 5px;
                font-size: 1.2rem;
                min-height: 1.5rem;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🧮 Postmath</h1>
            <p class="subtitle">Application de Mathématiques Avancées</p>
            
            <div class="status">
                <h3>✅ Postmath API is running!</h3>
                <p>Service opérationnel et prêt à traiter les calculs</p>
            </div>

            <div class="calculator">
                <h4>🔢 Calculatrice Interactive</h4>
                <div>
                    <input type="number" id="num1" class="calc-input" placeholder="5" value="5">
                    <select id="operation" class="calc-input" style="width: 100px;">
                        <option value="add">+</option>
                        <option value="subtract">-</option>
                        <option value="multiply">×</option>
                        <option value="divide">÷</option>
                    </select>
                    <input type="number" id="num2" class="calc-input" placeholder="3" value="3">
                    <button onclick="calculate()" class="calc-button">Calculer</button>
                </div>
                <div id="result" class="result">Résultat : </div>
            </div>

            <div class="api-info">
                <h4>🔗 Endpoints API disponibles :</h4>
                <div class="endpoint">GET /health - Statut du service</div>
                <div class="endpoint">GET /api/calculate?operation=add&a=5&b=3</div>
                <div class="endpoint">GET /api/history - Historique des calculs</div>
            </div>

            <div class="timestamp">
                Démarré le : ${new Date().toLocaleString('fr-FR')}
            </div>
        </div>

        <script>
            async function calculate() {
                const num1 = document.getElementById('num1').value;
                const num2 = document.getElementById('num2').value;
                const operation = document.getElementById('operation').value;
                const resultDiv = document.getElementById('result');

                try {
                    const response = await fetch(\`/api/calculate?operation=\${operation}&a=\${num1}&b=\${num2}\`);
                    const data = await response.json();

                    if (response.ok) {
                        resultDiv.innerHTML = \`✅ Résultat : \${data.operands.a} \${getOperatorSymbol(operation)} \${data.operands.b} = <strong>\${data.result}</strong>\`;
                        resultDiv.style.background = 'rgba(76, 175, 80, 0.3)';
                    } else {
                        resultDiv.innerHTML = \`❌ Erreur : \${data.error}\`;
                        resultDiv.style.background = 'rgba(244, 67, 54, 0.3)';
                    }
                } catch (error) {
                    resultDiv.innerHTML = \`❌ Erreur de connexion : \${error.message}\`;
                    resultDiv.style.background = 'rgba(244, 67, 54, 0.3)';
                }
            }

            function getOperatorSymbol(op) {
                switch(op) {
                    case 'add': return '+';
                    case 'subtract': return '-';
                    case 'multiply': return '×';
                    case 'divide': return '÷';
                    default: return op;
                }
            }

            // Vérifier la santé de l'API toutes les 30 secondes
            setInterval(async () => {
                try {
                    const response = await fetch('/health');
                    const data = await response.json();
                    console.log('Health check:', data);
                } catch (error) {
                    console.error('Health check failed:', error);
                }
            }, 30000);

            // Calculer automatiquement au chargement
            window.onload = () => calculate();
        </script>
    </body>
    </html>
  `);
});

// API endpoints
fastify.get('/health', async (request, reply) => {
  return { 
    status: 'healthy', 
    service: 'postmath', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  };
});

fastify.get('/api/calculate', async (request, reply) => {
  const { operation, a, b } = request.query as any;
  
  if (!operation || a === undefined || b === undefined) {
    return reply.code(400).send({
      error: 'Paramètres manquants',
      required: ['operation', 'a', 'b'],
      example: '/api/calculate?operation=add&a=5&b=3'
    });
  }

  const numA = parseFloat(a);
  const numB = parseFloat(b);
  
  if (isNaN(numA) || isNaN(numB)) {
    return reply.code(400).send({
      error: 'Les paramètres a et b doivent être des nombres valides'
    });
  }

  let result;

  switch (operation) {
    case 'add':
      result = numA + numB;
      break;
    case 'subtract':
      result = numA - numB;
      break;
    case 'multiply':
      result = numA * numB;
      break;
    case 'divide':
      if (numB === 0) {
        return reply.code(400).send({ error: 'Division par zéro impossible' });
      }
      result = numA / numB;
      break;
    default:
      return reply.code(400).send({ 
        error: 'Opération non supportée',
        supported: ['add', 'subtract', 'multiply', 'divide']
      });
  }

  return {
    operation,
    operands: { a: numA, b: numB },
    result: Math.round(result * 100000) / 100000, // Arrondir à 5 décimales
    timestamp: new Date().toISOString()
  };
});

fastify.get('/api/history', async (request, reply) => {
  // Simuler un historique de calculs
  return {
    history: [
      { operation: 'add', operands: { a: 5, b: 3 }, result: 8, timestamp: new Date(Date.now() - 60000).toISOString() },
      { operation: 'multiply', operands: { a: 4, b: 6 }, result: 24, timestamp: new Date(Date.now() - 30000).toISOString() },
      { operation: 'divide', operands: { a: 10, b: 2 }, result: 5, timestamp: new Date().toISOString() }
    ],
    total: 3
  };
});

const start = async () => {
  try {
    const port = parseInt(process.env.POSTMATH_PORT || '3001');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`🚀 Postmath server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
