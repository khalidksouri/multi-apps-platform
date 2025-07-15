import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

// Base de connaissances éducative
const educational_content = {
  animals: [
    { name: 'Lion', emoji: '🦁', fact: 'Les lions vivent en groupes appelés fiertes et peuvent rugir très fort !', category: 'mammifère' },
    { name: 'Dauphin', emoji: '🐬', fact: 'Les dauphins sont très intelligents et peuvent reconnaître leur reflet !', category: 'mammifère' },
    { name: 'Papillon', emoji: '🦋', fact: 'Les papillons goûtent avec leurs pattes et voient les couleurs ultraviolettes !', category: 'insecte' },
    { name: 'Éléphant', emoji: '🐘', fact: 'Les éléphants se souviennent de tout et peuvent pleurer de tristesse !', category: 'mammifère' },
    { name: 'Pingouin', emoji: '🐧', fact: 'Les pingouins glissent sur leur ventre pour aller plus vite !', category: 'oiseau' }
  ],
  math_games: [
    { question: 'Combien font 5 + 3 ?', answer: 8, level: 'facile', hint: 'Compte sur tes doigts !' },
    { question: 'Combien font 7 × 2 ?', answer: 14, level: 'moyen', hint: '7 + 7 = ?' },
    { question: 'Combien font 12 ÷ 3 ?', answer: 4, level: 'moyen', hint: 'Combien de groupes de 3 dans 12 ?' },
    { question: 'Combien font 15 - 8 ?', answer: 7, level: 'facile', hint: 'Enlève 8 de 15 !' },
    { question: 'Combien font 6 × 4 ?', answer: 24, level: 'difficile', hint: '6 + 6 + 6 + 6 = ?' }
  ],
  stories: [
    {
      title: 'Le Robot Curieux',
      content: 'Il était une fois un petit robot nommé Beep qui adorait apprendre. Chaque jour, il découvrait quelque chose de nouveau !',
      moral: 'La curiosité est la clé de l\'apprentissage !',
      emoji: '🤖'
    },
    {
      title: 'L\'Étoile Brillante',
      content: 'Dans le ciel, une petite étoile voulait briller plus fort. Elle apprit qu\'en aidant les autres, sa lumière devenait plus belle.',
      moral: 'Aider les autres nous rend plus heureux !',
      emoji: '⭐'
    }
  ]
};

fastify.get('/', async (request, reply) => {
  return reply.type('text/html').send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI4Kids - Intelligence Artificielle pour Enfants</title>
        <style>
            body {
                font-family: 'Comic Sans MS', cursive, sans-serif;
                margin: 0;
                padding: 1rem;
                background: linear-gradient(45deg, #ff9a9e 0%, #fecfef 50%, #fecfef 100%);
                min-height: 100vh;
                color: #333;
            }
            .container {
                max-width: 1000px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
            }
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                text-align: center;
                position: relative;
            }
            .header h1 {
                font-size: 3rem;
                margin: 0;
                animation: bounce 2s infinite;
            }
            @keyframes bounce {
                0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
                40% { transform: translateY(-10px); }
                60% { transform: translateY(-5px); }
            }
            .content {
                padding: 2rem;
                display: grid;
                gap: 2rem;
            }
            .game-section {
                background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
                padding: 2rem;
                border-radius: 20px;
                border: 3px solid #ffd700;
            }
            .game-section h2 {
                color: #ff6b6b;
                font-size: 2rem;
                margin-top: 0;
                text-align: center;
            }
            .game-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
                margin-top: 1rem;
            }
            .game-card {
                background: white;
                padding: 1.5rem;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                text-align: center;
                transition: transform 0.3s, box-shadow 0.3s;
                border: 2px solid transparent;
            }
            .game-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.15);
                border-color: #ffd700;
            }
            .emoji {
                font-size: 3rem;
                margin-bottom: 1rem;
                display: block;
            }
            button {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 1rem 2rem;
                border-radius: 25px;
                font-size: 1.1rem;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s;
                margin: 0.5rem;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }
            button:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.3);
            }
            .result {
                margin-top: 1rem;
                padding: 1rem;
                border-radius: 15px;
                min-height: 60px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                font-weight: bold;
            }
            .success { background: #d4edda; color: #155724; border: 2px solid #c3e6cb; }
            .info { background: #cce7ff; color: #004085; border: 2px solid #99d6ff; }
            .question-input {
                padding: 1rem;
                border: 2px solid #ddd;
                border-radius: 15px;
                font-size: 1.2rem;
                width: 100px;
                text-align: center;
                margin: 0 1rem;
            }
            .story-card {
                background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
                padding: 2rem;
                border-radius: 20px;
                margin: 1rem 0;
                border-left: 5px solid #ff6b6b;
            }
            .animal-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 1rem;
                margin-top: 1rem;
            }
            .animal-card {
                background: white;
                padding: 1rem;
                border-radius: 15px;
                text-align: center;
                box-shadow: 0 3px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }
            .animal-card:hover {
                transform: scale(1.05);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🤖 AI4Kids</h1>
                <p style="font-size: 1.3rem; margin: 0;">Apprends en t'amusant avec l'Intelligence Artificielle !</p>
            </div>
            
            <div class="content">
                <!-- Section Jeux de Maths -->
                <div class="game-section">
                    <h2>🧮 Jeux de Mathématiques</h2>
                    <div class="game-grid">
                        <div class="game-card">
                            <span class="emoji">🔢</span>
                            <h3>Calcul Rapide</h3>
                            <p>Résous les opérations et deviens un champion des maths !</p>
                            <button onclick="startMathGame()">Commencer</button>
                            <div id="mathQuestion" style="margin: 1rem 0; font-size: 1.5rem; font-weight: bold;"></div>
                            <div id="mathInput" style="display: none;">
                                <input type="number" id="answerInput" class="question-input" placeholder="?">
                                <button onclick="checkAnswer()">Vérifier</button>
                                <button onclick="getHint()">Indice</button>
                            </div>
                            <div id="mathResult" class="result"></div>
                        </div>
                    </div>
                </div>

                <!-- Section Animaux -->
                <div class="game-section">
                    <h2>🦁 Découvre les Animaux</h2>
                    <div class="game-grid">
                        <div class="game-card">
                            <span class="emoji">🔍</span>
                            <h3>Faits Amusants</h3>
                            <p>Découvre des choses incroyables sur les animaux !</p>
                            <button onclick="getAnimalFact()">Découvrir</button>
                            <div id="animalResult" class="result"></div>
                        </div>
                    </div>
                    <div id="animalGrid" class="animal-grid"></div>
                </div>

                <!-- Section Histoires -->
                <div class="game-section">
                    <h2>📚 Histoires Magiques</h2>
                    <div class="game-grid">
                        <div class="game-card">
                            <span class="emoji">✨</span>
                            <h3>Conte du Jour</h3>
                            <p>Écoute de belles histoires avec une morale !</p>
                            <button onclick="getStory()">Raconte-moi</button>
                            <div id="storyResult" class="result"></div>
                        </div>
                    </div>
                </div>

                <!-- Section IA Interactive -->
                <div class="game-section">
                    <h2>🎯 IA Interactive</h2>
                    <div class="game-grid">
                        <div class="game-card">
                            <span class="emoji">🤔</span>
                            <h3>Pose ta Question</h3>
                            <p>Demande-moi ce que tu veux apprendre !</p>
                            <div style="margin: 1rem 0;">
                                <input type="text" id="questionInput" placeholder="Dis-moi quelque chose sur..." 
                                       style="width: 80%; padding: 0.75rem; border-radius: 10px; border: 2px solid #ddd;">
                            </div>
                            <button onclick="askAI()">Demander</button>
                            <div id="aiResult" class="result"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let currentQuestion = null;

            async function startMathGame() {
                const response = await fetch('/api/math/question');
                const data = await response.json();
                currentQuestion = data;
                
                document.getElementById('mathQuestion').textContent = data.question;
                document.getElementById('mathInput').style.display = 'block';
                document.getElementById('answerInput').value = '';
                document.getElementById('answerInput').focus();
                document.getElementById('mathResult').textContent = '';
            }

            async function checkAnswer() {
                const userAnswer = parseInt(document.getElementById('answerInput').value);
                const resultDiv = document.getElementById('mathResult');
                
                if (userAnswer === currentQuestion.answer) {
                    resultDiv.className = 'result success';
                    resultDiv.innerHTML = '🎉 Bravo ! C\\'est la bonne réponse ! Tu es un champion !';
                    setTimeout(startMathGame, 2000);
                } else {
                    resultDiv.className = 'result info';
                    resultDiv.innerHTML = '🤔 Pas tout à fait... Essaie encore !';
                }
            }

            function getHint() {
                const resultDiv = document.getElementById('mathResult');
                resultDiv.className = 'result info';
                resultDiv.innerHTML = '💡 Indice : ' + currentQuestion.hint;
            }

            async function getAnimalFact() {
                const response = await fetch('/api/animals/fact');
                const data = await response.json();
                
                document.getElementById('animalResult').className = 'result info';
                document.getElementById('animalResult').innerHTML = 
                    \`\${data.emoji} <strong>\${data.name}</strong><br>\${data.fact}\`;
            }

            async function getStory() {
                const response = await fetch('/api/stories/random');
                const data = await response.json();
                
                document.getElementById('storyResult').className = 'result info';
                document.getElementById('storyResult').innerHTML = 
                    \`\${data.emoji} <strong>\${data.title}</strong><br><br>\${data.content}<br><br>💖 <em>\${data.moral}</em>\`;
            }

            async function askAI() {
                const question = document.getElementById('questionInput').value;
                if (!question) return;

                const response = await fetch('/api/ai/ask', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ question })
                });
                const data = await response.json();
                
                document.getElementById('aiResult').className = 'result info';
                document.getElementById('aiResult').innerHTML = '🤖 ' + data.answer;
                document.getElementById('questionInput').value = '';
            }

            // Charger les animaux au démarrage
            async function loadAnimals() {
                const response = await fetch('/api/animals/all');
                const animals = await response.json();
                
                const grid = document.getElementById('animalGrid');
                grid.innerHTML = animals.map(animal => 
                    \`<div class="animal-card">
                        <div style="font-size: 2rem;">\${animal.emoji}</div>
                        <h4>\${animal.name}</h4>
                        <small>\${animal.category}</small>
                    </div>\`
                ).join('');
            }

            // Permettre de répondre avec Entrée
            document.getElementById('answerInput')?.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') checkAnswer();
            });

            document.getElementById('questionInput')?.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') askAI();
            });

            // Charger le contenu au démarrage
            window.onload = () => {
                loadAnimals();
                startMathGame();
            };
        </script>
    </body>
    </html>
  `);
});

fastify.get('/health', async (request, reply) => {
  return { status: 'healthy', service: 'ai4kids', timestamp: new Date().toISOString() };
});

fastify.get('/api/math/question', async (request, reply) => {
  const question = educational_content.math_games[
    Math.floor(Math.random() * educational_content.math_games.length)
  ];
  return question;
});

fastify.get('/api/animals/fact', async (request, reply) => {
  const animal = educational_content.animals[
    Math.floor(Math.random() * educational_content.animals.length)
  ];
  return animal;
});

fastify.get('/api/animals/all', async (request, reply) => {
  return educational_content.animals;
});

fastify.get('/api/stories/random', async (request, reply) => {
  const story = educational_content.stories[
    Math.floor(Math.random() * educational_content.stories.length)
  ];
  return story;
});

fastify.post('/api/ai/ask', async (request, reply) => {
  const { question } = request.body as any;
  
  if (!question) {
    return reply.code(400).send({ error: 'Question requise' });
  }

  // Simuler une réponse IA simple basée sur des mots-clés
  let answer = "C'est une excellente question ! ";
  
  const lowerQuestion = question.toLowerCase();
  
  if (lowerQuestion.includes('animal')) {
    const animal = educational_content.animals[Math.floor(Math.random() * educational_content.animals.length)];
    answer += `Parlons du ${animal.name} ${animal.emoji} ! ${animal.fact}`;
  } else if (lowerQuestion.includes('math') || lowerQuestion.includes('calcul')) {
    answer += "Les mathématiques sont partout ! Elles nous aident à compter, mesurer et résoudre des problèmes. C'est comme un jeu de puzzle !";
  } else if (lowerQuestion.includes('espace') || lowerQuestion.includes('étoile')) {
    answer += "L'espace est immense ! Il y a des milliards d'étoiles et de planètes. La Terre est notre maison spéciale dans cet univers gigantesque ! 🌟";
  } else if (lowerQuestion.includes('couleur')) {
    answer += "Les couleurs sont magiques ! L'arc-en-ciel a 7 couleurs principales : rouge, orange, jaune, vert, bleu, indigo et violet ! 🌈";
  } else {
    answer += "Continue à être curieux ! C'est comme ça qu'on apprend de nouvelles choses chaque jour. Tu peux me poser d'autres questions sur les animaux, les maths, l'espace ou les couleurs !";
  }

  return { answer, timestamp: new Date().toISOString() };
});

const start = async () => {
  try {
    const port = parseInt(process.env.AI4KIDS_PORT || '3004');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`🤖 AI4Kids server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
