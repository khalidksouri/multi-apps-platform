import React, { useState } from 'react';
import Head from 'next/head';

export default function Home() {
  const [currentLang, setCurrentLang] = useState('fr');
  const [selectedModel, setSelectedModel] = useState('GPT-4');

  const models = ['GPT-4', 'Claude', 'Gemini', 'Llama', 'Mistral'];

  return (
    <>
      <Head>
        <title>MultiAI - Plateforme Multi-IA Avancée</title>
        <meta name="description" content="Accédez à plusieurs modèles d'IA avancés" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
      </Head>

      <div className="app" data-testid="app-container">
        <div className="language-selector">
          <select value={currentLang} onChange={(e) => setCurrentLang(e.target.value)}>
            <option value="fr">🇫🇷 Français</option>
            <option value="en">🇺🇸 English</option>
            <option value="es">🇪🇸 Español</option>
          </select>
        </div>

        <div className="container">
          <h1>🤖 MultiAI</h1>
          <p>Plateforme Multi-IA Avancée</p>
          
          <div className="model-selector">
            <h3>Sélectionnez votre modèle IA:</h3>
            <div className="models-grid">
              {models.map((model) => (
                <div
                  key={model}
                  className={`model-card ${selectedModel === model ? 'selected' : ''}`}
                  onClick={() => setSelectedModel(model)}
                >
                  <h4>{model}</h4>
                  <p>Modèle IA avancé</p>
                </div>
              ))}
            </div>
          </div>

          <div className="features">
            <h3>🌟 Fonctionnalités:</h3>
            <div className="features-grid">
              <div>💬 Chat Mode</div>
              <div>🖼️ Image Mode</div>
              <div>💻 Code Mode</div>
              <div>📊 Analysis Mode</div>
            </div>
          </div>
        </div>
      </div>

      <style jsx>{`
        .app {
          min-height: 100vh;
          background: linear-gradient(135deg, #000000 0%, #1a1a2e 50%, #16213e 100%);
          color: white;
          padding: 20px;
          position: relative;
        }

        .language-selector {
          position: absolute;
          top: 20px;
          right: 20px;
          background: rgba(255, 255, 255, 0.1);
          padding: 10px;
          border-radius: 10px;
        }

        .language-selector select {
          background: rgba(255, 255, 255, 0.9);
          border: none;
          padding: 5px 10px;
          border-radius: 5px;
          cursor: pointer;
        }

        .container {
          max-width: 1200px;
          margin: 0 auto;
          text-align: center;
          padding: 2rem;
        }

        h1 {
          font-size: 4rem;
          margin-bottom: 1rem;
          background: linear-gradient(45deg, #00d4ff, #7c3aed, #ec4899);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          animation: rainbow 4s ease infinite;
        }

        @keyframes rainbow {
          0% { background-position: 0% 50%; }
          50% { background-position: 100% 50%; }
          100% { background-position: 0% 50%; }
        }

        .model-selector {
          margin: 3rem 0;
        }

        .models-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
          gap: 1.5rem;
          margin-top: 1.5rem;
        }

        .model-card {
          background: rgba(255, 255, 255, 0.1);
          backdrop-filter: blur(20px);
          border: 2px solid transparent;
          border-radius: 15px;
          padding: 1.5rem;
          cursor: pointer;
          transition: all 0.3s ease;
        }

        .model-card:hover {
          background: rgba(255, 255, 255, 0.2);
          transform: translateY(-5px);
        }

        .model-card.selected {
          border-color: #7c3aed;
          background: rgba(124, 58, 237, 0.2);
        }

        .features {
          margin: 3rem 0;
        }

        .features-grid {
          display: grid;
          grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
          gap: 1rem;
          margin-top: 1rem;
        }

        .features-grid div {
          background: rgba(255, 255, 255, 0.1);
          padding: 1rem;
          border-radius: 10px;
        }

        @media (max-width: 768px) {
          h1 {
            font-size: 2.5rem;
          }
          
          .models-grid {
            grid-template-columns: 1fr;
          }
        }
      `}</style>
    </>
  );
}
