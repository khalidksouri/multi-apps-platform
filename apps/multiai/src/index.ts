import Fastify from 'fastify';

const fastify = Fastify({ logger: true });

// Simulation de différents modèles IA
const aiModels = {
  'gpt-assistant': {
    name: 'Assistant GPT',
    description: 'Assistant conversationnel général',
    capabilities: ['questions-réponses', 'rédaction', 'analyse'],
    status: 'active',
    icon: '🤖'
  },
  'vision-ai': {
    name: 'Vision IA',
    description: 'Analyse d\'images et reconnaissance',
    capabilities: ['description-image', 'reconnaissance-objet', 'analyse-visuelle'],
    status: 'active',
    icon: '��️'
  },
  'code-assistant': {
    name: 'Assistant Code',
    description: 'Aide à la programmation',
    capabilities: ['génération-code', 'debug', 'optimisation'],
    status: 'active',
    icon: '💻'
  },
  'creative-ai': {
    name: 'IA Créative',
    description: 'Création artistique et littéraire',
    capabilities: ['écriture-créative', 'idées', 'brainstorming'],
    status: 'active',
    icon: '🎨'
  },
  'data-analyst': {
    name: 'Analyste Data',
    description: 'Analyse de données et tendances',
    capabilities: ['analyse-données', 'statistiques', 'prédictions'],
    status: 'maintenance',
    icon: '📊'
  }
};

// Historique des conversations
let conversations: any[] = [];

fastify.get('/', async (request, reply) => {
  const modelsList = Object.entries(aiModels).map(([id, model]) => `
    <div class="model-card ${model.status === 'maintenance' ? 'maintenance' : ''}" onclick="selectModel('${id}')">
      <div class="model-icon">${model.icon}</div>
      <h3>${model.name}</h3>
      <p>${model.description}</p>
      <div class="capabilities">
        ${model.capabilities.map(cap => `<span class="capability">${cap}</span>`).join('')}
      </div>
      <div class="status ${model.status}">${model.status === 'active' ? '🟢 Actif' : '🟡 Maintenance'}</div>
    </div>
  `).join('');

  return reply.type('text/html').send(`
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>MultiAI - Hub Intelligence Artificielle</title>
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
            }
            .header {
                text-align: center;
                color: white;
                margin-bottom: 3rem;
            }
            .header h1 {
                font-size: 4rem;
                font-weight: 700;
                margin-bottom: 1rem;
                background: linear-gradient(45deg, #fff, #f0f0f0);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                text-shadow: 0 4px 20px rgba(0,0,0,0.3);
            }
            .header p {
                font-size: 1.3rem;
                opacity: 0.9;
                font-weight: 300;
            }
            .dashboard {
                display: grid;
                grid-template-columns: 1fr 400px;
                gap: 2rem;
                min-height: 600px;
            }
            .models-section {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                padding: 2rem;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
            }
            .models-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 1.5rem;
                margin-top: 1.5rem;
            }
            .model-card {
                background: white;
                border: 2px solid #f0f0f0;
                border-radius: 15px;
                padding: 1.5rem;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }
            .model-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
                border-color: #667eea;
            }
            .model-card.selected {
                border-color: #667eea;
                background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
            }
            .model-card.maintenance {
                opacity: 0.7;
                border-color: #ffc107;
            }
            .model-icon {
                font-size: 3rem;
                margin-bottom: 1rem;
                text-align: center;
            }
            .model-card h3 {
                color: #333;
                margin-bottom: 0.5rem;
                font-size: 1.2rem;
                font-weight: 600;
            }
            .model-card p {
                color: #666;
                font-size: 0.9rem;
                margin-bottom: 1rem;
                line-height: 1.4;
            }
            .capabilities {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                margin-bottom: 1rem;
            }
            .capability {
                background: #f8f9fa;
                color: #495057;
                padding: 0.25rem 0.75rem;
                border-radius: 12px;
                font-size: 0.8rem;
                font-weight: 500;
            }
            .status {
                position: absolute;
                top: 1rem;
                right: 1rem;
                font-size: 0.8rem;
                font-weight: 600;
            }
            .status.active { color: #28a745; }
            .status.maintenance { color: #ffc107; }
            .chat-section {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 20px;
                padding: 0;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
                display: flex;
                flex-direction: column;
                max-height: 600px;
            }
            .chat-header {
                padding: 1.5rem;
                border-bottom: 1px solid #eee;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 20px 20px 0 0;
            }
            .chat-messages {
                flex: 1;
                padding: 1rem;
                overflow-y: auto;
                min-height: 300px;
                max-height: 400px;
            }
            .message {
                margin-bottom: 1rem;
                padding: 1rem;
                border-radius: 15px;
                max-width: 85%;
                line-height: 1.4;
            }
            .message.user {
                background: #007bff;
                color: white;
                margin-left: auto;
                border-bottom-right-radius: 5px;
            }
            .message.ai {
                background: #f8f9fa;
                color: #333;
                border-bottom-left-radius: 5px;
                border-left: 3px solid #667eea;
            }
            .chat-input {
                padding: 1rem;
                border-top: 1px solid #eee;
                display: flex;
                gap: 1rem;
                border-radius: 0 0 20px 20px;
            }
            .chat-input input {
                flex: 1;
                padding: 0.75rem;
                border: 1px solid #ddd;
                border-radius: 25px;
                font-size: 1rem;
                outline: none;
            }
            .chat-input input:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }
            .chat-input button {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 25px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s;
            }
            .chat-input button:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
            .stats {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 1rem;
                margin-bottom: 2rem;
            }
            .stat-card {
                background: rgba(255, 255, 255, 0.2);
                padding: 1.5rem;
                border-radius: 15px;
                text-align: center;
                color: white;
            }
            .stat-number {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }
            .stat-label {
                font-size: 0.9rem;
                opacity: 0.8;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>🧠 MultiAI</h1>
                <p>Hub Central d'Intelligence Artificielle - Accédez à tous vos modèles IA</p>
            </div>

            <div class="stats">
                <div class="stat-card">
                    <div class="stat-number">${Object.keys(aiModels).length}</div>
                    <div class="stat-label">Modèles IA</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${Object.values(aiModels).filter(m => m.status === 'active').length}</div>
                    <div class="stat-label">Actifs</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${conversations.length}</div>
                    <div class="stat-label">Conversations</div>
                </div>
            </div>

            <div class="dashboard">
                <div class="models-section">
                    <h2>🤖 Modèles Disponibles</h2>
                    <div class="models-grid">
                        ${modelsList}
                    </div>
                </div>

                <div class="chat-section">
                    <div class="chat-header">
                        <h3 id="selectedModel">💬 Chat MultiAI</h3>
                        <p id="modelDescription">Sélectionnez un modèle IA pour commencer</p>
                    </div>
                    <div class="chat-messages" id="chatMessages">
                        <div class="message ai">
                            🤖 Bonjour ! Je suis MultiAI, votre hub d'intelligence artificielle. 
                            Sélectionnez un modèle à gauche pour commencer une conversation spécialisée !
                        </div>
                    </div>
                    <div class="chat-input">
                        <input type="text" id="messageInput" placeholder="Tapez votre message..." disabled>
                        <button onclick="sendMessage()" disabled id="sendButton">Envoyer</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let selectedModelId = null;

            function selectModel(modelId) {
                selectedModelId = modelId;
                
                // Mettre à jour l'interface
                document.querySelectorAll('.model-card').forEach(card => {
                    card.classList.remove('selected');
                });
                document.querySelector(\`[onclick="selectModel('\${modelId}')"]\`).classList.add('selected');
                
                // Récupérer les infos du modèle
                fetch(\`/api/models/\${modelId}\`)
                    .then(response => response.json())
                    .then(model => {
                        document.getElementById('selectedModel').textContent = 
                            \`\${model.icon} \${model.name}\`;
                        document.getElementById('modelDescription').textContent = 
                            model.description;
                        
                        // Activer le chat si le modèle est actif
                        const isActive = model.status === 'active';
                        document.getElementById('messageInput').disabled = !isActive;
                        document.getElementById('sendButton').disabled = !isActive;
                        
                        if (!isActive) {
                            addMessage('ai', '⚠️ Ce modèle est actuellement en maintenance. Veuillez sélectionner un autre modèle.');
                        } else {
                            addMessage('ai', \`✨ Modèle \${model.name} activé ! Comment puis-je vous aider ?\`);
                        }
                    });
            }

            function addMessage(sender, content) {
                const messagesContainer = document.getElementById('chatMessages');
                const messageDiv = document.createElement('div');
                messageDiv.className = \`message \${sender}\`;
                messageDiv.textContent = content;
                messagesContainer.appendChild(messageDiv);
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            }

            async function sendMessage() {
                const input = document.getElementById('messageInput');
                const message = input.value.trim();
                
                if (!message || !selectedModelId) return;
                
                // Ajouter le message utilisateur
                addMessage('user', message);
                input.value = '';
                
                try {
                    // Envoyer à l'IA
                    const response = await fetch('/api/chat', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            model: selectedModelId,
                            message: message
                        })
                    });
                    
                    const data = await response.json();
                    addMessage('ai', data.response);
                    
                } catch (error) {
                    addMessage('ai', '❌ Erreur de connexion. Veuillez réessayer.');
                }
            }

            // Permettre d'envoyer avec Entrée
            document.getElementById('messageInput').addEventListener('keypress', function(e) {
                if (e.key === 'Enter' && !this.disabled) {
                    sendMessage();
                }
            });

            // Auto-select first active model
            window.onload = () => {
                const firstActiveModel = Object.keys(${JSON.stringify(aiModels)}).find(id => 
                    ${JSON.stringify(aiModels)}[id].status === 'active'
                );
                if (firstActiveModel) {
                    selectModel(firstActiveModel);
                }
            };
        </script>
    </body>
    </html>
  `);
});

fastify.get('/health', async (request, reply) => {
  return { 
    status: 'healthy', 
    service: 'multiai', 
    models: Object.keys(aiModels).length,
    active_models: Object.values(aiModels).filter(m => m.status === 'active').length,
    timestamp: new Date().toISOString() 
  };
});

fastify.get('/api/models', async (request, reply) => {
  return aiModels;
});

fastify.get('/api/models/:id', async (request, reply) => {
  const { id } = request.params as any;
  const model = aiModels[id];
  
  if (!model) {
    return reply.code(404).send({ error: 'Modèle non trouvé' });
  }
  
  return model;
});

fastify.post('/api/chat', async (request, reply) => {
  const { model, message } = request.body as any;
  
  if (!model || !message) {
    return reply.code(400).send({ error: 'Modèle et message requis' });
  }
  
  const aiModel = aiModels[model];
  if (!aiModel) {
    return reply.code(404).send({ error: 'Modèle non trouvé' });
  }
  
  if (aiModel.status !== 'active') {
    return reply.code(503).send({ error: 'Modèle en maintenance' });
  }

  // Simuler différentes réponses selon le modèle
  let response = '';
  const lowerMessage = message.toLowerCase();

  switch (model) {
    case 'gpt-assistant':
      response = `En tant qu'assistant IA, je peux vous aider avec "${message}". Voici ma réponse détaillée basée sur mes connaissances générales...`;
      break;
      
    case 'vision-ai':
      response = `🔍 Vision IA : Pour analyser "${message}", j'utiliserais mes capacités de reconnaissance visuelle. Décrivez-moi l'image ou l'élément visuel à analyser.`;
      break;
      
    case 'code-assistant':
      if (lowerMessage.includes('code') || lowerMessage.includes('programming')) {
        response = `💻 Code Assistant : Voici comment aborder "${message}" :\n\n\`\`\`\n// Exemple de code\nfunction solution() {\n  return "Code optimisé pour votre demande";\n}\n\`\`\``;
      } else {
        response = `💻 Code Assistant : Je peux vous aider avec la programmation. Posez-moi des questions sur le code, debug, ou optimisation !`;
      }
      break;
      
    case 'creative-ai':
      response = `🎨 IA Créative : "${message}" m'inspire ! Voici une idée créative : Imaginez un monde où votre concept devient réalité avec des couleurs vives et des formes innovantes...`;
      break;
      
    case 'data-analyst':
      response = `📊 Analyste Data : Pour analyser "${message}", je recommande d'examiner les tendances, patterns et corrélations. Voici mon analyse préliminaire...`;
      break;
      
    default:
      response = `Je traite votre demande "${message}" avec le modèle ${aiModel.name}.`;
  }

  // Sauvegarder la conversation
  conversations.push({
    id: conversations.length + 1,
    model,
    user_message: message,
    ai_response: response,
    timestamp: new Date().toISOString()
  });

  return { 
    response,
    model: aiModel.name,
    timestamp: new Date().toISOString()
  };
});

fastify.get('/api/conversations', async (request, reply) => {
  return {
    conversations: conversations.slice(-10), // 10 dernières conversations
    total: conversations.length
  };
});

const start = async () => {
  try {
    const port = parseInt(process.env.MULTIAI_PORT || '3005');
    await fastify.listen({ port, host: '0.0.0.0' });
    console.log(`🧠 MultiAI server running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
