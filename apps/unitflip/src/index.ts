import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

// Données de conversion
const conversions = {
  length: {
    meter: 1,
    kilometer: 0.001,
    centimeter: 100,
    millimeter: 1000,
    inch: 39.3701,
    foot: 3.28084,
    yard: 1.09361,
    mile: 0.000621371
  },
  weight: {
    kilogram: 1,
    gram: 1000,
    pound: 2.20462,
    ounce: 35.274,
    ton: 0.001
  },
  temperature: {
    celsius: (c: number) => ({ celsius: c, fahrenheit: c * 9/5 + 32, kelvin: c + 273.15 }),
    fahrenheit: (f: number) => ({ fahrenheit: f, celsius: (f - 32) * 5/9, kelvin: (f - 32) * 5/9 + 273.15 }),
    kelvin: (k: number) => ({ kelvin: k, celsius: k - 273.15, fahrenheit: (k - 273.15) * 9/5 + 32 })
  }
};

fastify.get('/', async (request, reply) => {
  return reply.type('text/html').send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UnitFlip - Convertisseur d'Unités</title>
        <style>
            body {
                font-family: 'Segoe UI', system-ui, sans-serif;
                margin: 0;
                padding: 2rem;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                color: white;
                min-height: 100vh;
            }
            .container {
                max-width: 800px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.1);
                padding: 2rem;
                border-radius: 20px;
                backdrop-filter: blur(10px);
            }
            h1 { font-size: 3rem; text-align: center; margin-bottom: 2rem; }
            .converter { 
                background: rgba(255, 255, 255, 0.1);
                padding: 2rem;
                border-radius: 15px;
                margin: 1rem 0;
            }
            .input-group {
                display: flex;
                gap: 1rem;
                margin: 1rem 0;
                align-items: center;
                flex-wrap: wrap;
            }
            input, select, button {
                padding: 0.75rem;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
            }
            input {
                background: rgba(255, 255, 255, 0.9);
                color: #333;
                width: 150px;
            }
            select {
                background: rgba(255, 255, 255, 0.9);
                color: #333;
                min-width: 120px;
            }
            button {
                background: rgba(76, 175, 80, 0.8);
                color: white;
                cursor: pointer;
                transition: all 0.3s;
            }
            button:hover { background: rgba(76, 175, 80, 1); }
            .result {
                margin-top: 1rem;
                padding: 1rem;
                background: rgba(76, 175, 80, 0.2);
                border-radius: 8px;
                min-height: 1.5rem;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🔄 UnitFlip</h1>
            
            <div class="converter">
                <h3>📏 Longueur</h3>
                <div class="input-group">
                    <input type="number" id="lengthValue" placeholder="1" value="1">
                    <select id="lengthFrom">
                        <option value="meter">Mètre</option>
                        <option value="kilometer">Kilomètre</option>
                        <option value="centimeter">Centimètre</option>
                        <option value="inch">Pouce</option>
                        <option value="foot">Pied</option>
                    </select>
                    <span>vers</span>
                    <select id="lengthTo">
                        <option value="centimeter">Centimètre</option>
                        <option value="meter">Mètre</option>
                        <option value="kilometer">Kilomètre</option>
                        <option value="inch">Pouce</option>
                        <option value="foot">Pied</option>
                    </select>
                    <button onclick="convertLength()">Convertir</button>
                </div>
                <div id="lengthResult" class="result">Résultat : </div>
            </div>

            <div class="converter">
                <h3>⚖️ Poids</h3>
                <div class="input-group">
                    <input type="number" id="weightValue" placeholder="1" value="1">
                    <select id="weightFrom">
                        <option value="kilogram">Kilogramme</option>
                        <option value="gram">Gramme</option>
                        <option value="pound">Livre</option>
                        <option value="ounce">Once</option>
                    </select>
                    <span>vers</span>
                    <select id="weightTo">
                        <option value="gram">Gramme</option>
                        <option value="kilogram">Kilogramme</option>
                        <option value="pound">Livre</option>
                        <option value="ounce">Once</option>
                    </select>
                    <button onclick="convertWeight()">Convertir</button>
                </div>
                <div id="weightResult" class="result">Résultat : </div>
            </div>

            <div class="converter">
                <h3>🌡️ Température</h3>
                <div class="input-group">
                    <input type="number" id="tempValue" placeholder="20" value="20">
                    <select id="tempFrom">
                        <option value="celsius">Celsius</option>
                        <option value="fahrenheit">Fahrenheit</option>
                        <option value="kelvin">Kelvin</option>
                    </select>
                    <button onclick="convertTemperature()">Convertir</button>
                </div>
                <div id="tempResult" class="result">Résultat : </div>
            </div>
        </div>

        <script>
            async function convertLength() {
                const value = document.getElementById('lengthValue').value;
                const from = document.getElementById('lengthFrom').value;
                const to = document.getElementById('lengthTo').value;
                
                const response = await fetch(\`/api/convert/length?value=\${value}&from=\${from}&to=\${to}\`);
                const data = await response.json();
                
                document.getElementById('lengthResult').innerHTML = 
                    \`✅ \${data.input.value} \${data.input.from} = <strong>\${data.result.toFixed(4)} \${data.output.to}</strong>\`;
            }

            async function convertWeight() {
                const value = document.getElementById('weightValue').value;
                const from = document.getElementById('weightFrom').value;
                const to = document.getElementById('weightTo').value;
                
                const response = await fetch(\`/api/convert/weight?value=\${value}&from=\${from}&to=\${to}\`);
                const data = await response.json();
                
                document.getElementById('weightResult').innerHTML = 
                    \`✅ \${data.input.value} \${data.input.from} = <strong>\${data.result.toFixed(4)} \${data.output.to}</strong>\`;
            }

            async function convertTemperature() {
                const value = document.getElementById('tempValue').value;
                const from = document.getElementById('tempFrom').value;
                
                const response = await fetch(\`/api/convert/temperature?value=\${value}&from=\${from}\`);
                const data = await response.json();
                
                document.getElementById('tempResult').innerHTML = 
                    \`✅ \${data.input.value}° \${data.input.from} = <strong>\${data.results.celsius.toFixed(2)}°C, \${data.results.fahrenheit.toFixed(2)}°F, \${data.results.kelvin.toFixed(2)}K</strong>\`;
            }

            // Conversions automatiques au chargement
            window.onload = () => {
                convertLength();
                convertWeight();
                convertTemperature();
            };
        </script>
    </body>
    </html>
  `);
});

fastify.get('/health', async (request, reply) => {
  return { status: 'healthy', service: 'unitflip', timestamp: new Date().toISOString() };
});

fastify.get('/api/convert/length', async (request, reply) => {
  const { value, from, to } = request.query as any;
  const val = parseFloat(value);
  
  if (isNaN(val) || !conversions.length[from] || !conversions.length[to]) {
    return reply.code(400).send({ error: 'Paramètres invalides' });
  }

  const meters = val / conversions.length[from];
  const result = meters * conversions.length[to];

  return {
    input: { value: val, from },
    output: { to },
    result,
    timestamp: new Date().toISOString()
  };
});

fastify.get('/api/convert/weight', async (request, reply) => {
  const { value, from, to } = request.query as any;
  const val = parseFloat(value);
  
  if (isNaN(val) || !conversions.weight[from] || !conversions.weight[to]) {
    return reply.code(400).send({ error: 'Paramètres invalides' });
  }

  const kilograms = val / conversions.weight[from];
  const result = kilograms * conversions.weight[to];

  return {
    input: { value: val, from },
    output: { to },
    result,
    timestamp: new Date().toISOString()
  };
});

fastify.get('/api/convert/temperature', async (request, reply) => {
  const { value, from } = request.query as any;
  const val = parseFloat(value);
  
  if (isNaN(val) || !conversions.temperature[from]) {
    return reply.code(400).send({ error: 'Paramètres invalides' });
  }

  const results = conversions.temperature[from](val);

  return {
    input: { value: val, from },
    results,
    timestamp: new Date().toISOString()
  };
});

const start = async () => {
  try {
    const port = parseInt(process.env.UNITFLIP_PORT || '3002');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`🔄 UnitFlip server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
