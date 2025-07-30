import { useState } from 'react';

export default function Home() {
  const [selectedAI, setSelectedAI] = useState('ChatGPT');
  const [prompt, setPrompt] = useState('');
  
  const aiOptions = [
    { name: 'ChatGPT', icon: '🤖', color: '#10a37f' },
    { name: 'Claude', icon: '🧠', color: '#db7c26' },
    { name: 'Gemini', icon: '✨', color: '#4285f4' },
    { name: 'Mistral', icon: '🌪️', color: '#f97316' }
  ];

  return (
    <div style={{
      minHeight: '100vh',
      background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      padding: '20px',
      fontFamily: 'Arial, sans-serif'
    }}>
      <div style={{
        background: 'rgba(255, 255, 255, 0.1)',
        backdropFilter: 'blur(20px)',
        borderRadius: '20px',
        padding: '40px',
        border: '1px solid rgba(255, 255, 255, 0.2)',
        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)',
        maxWidth: '800px',
        width: '100%',
        color: 'white',
        textAlign: 'center'
      }}>
        <h1 style={{ fontSize: '3rem', marginBottom: '1rem' }}>
          🤖 MULTIAI
        </h1>
        <p style={{ fontSize: '1.2rem', marginBottom: '2rem' }}>
          Interface unifiée pour tous les AIs
        </p>
        
        <div style={{ marginBottom: '2rem' }}>
          <h3>Choisir votre AI:</h3>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))',
            gap: '15px',
            margin: '1rem 0'
          }}>
            {aiOptions.map((ai) => (
              <button
                key={ai.name}
                onClick={() => setSelectedAI(ai.name)}
                style={{
                  background: selectedAI === ai.name ? ai.color : 'rgba(255, 255, 255, 0.1)',
                  border: '1px solid rgba(255, 255, 255, 0.3)',
                  borderRadius: '15px',
                  padding: '15px',
                  color: 'white',
                  cursor: 'pointer',
                  fontSize: '1rem',
                  transition: 'all 0.3s ease'
                }}
              >
                <div style={{ fontSize: '2rem' }}>{ai.icon}</div>
                {ai.name}
              </button>
            ))}
          </div>
        </div>
        
        <div style={{ marginBottom: '2rem' }}>
          <textarea
            value={prompt}
            onChange={(e) => setPrompt(e.target.value)}
            placeholder={`Écrivez votre prompt pour ${selectedAI}...`}
            style={{
              width: '100%',
              height: '120px',
              padding: '15px',
              borderRadius: '10px',
              border: '1px solid rgba(255, 255, 255, 0.3)',
              background: 'rgba(255, 255, 255, 0.1)',
              color: 'white',
              fontSize: '1rem',
              resize: 'vertical'
            }}
          />
        </div>
        
        <button style={{
          background: 'linear-gradient(45deg, #FF6B6B, #4ECDC4)',
          border: 'none',
          borderRadius: '25px',
          color: 'white',
          padding: '15px 30px',
          fontSize: '1.2rem',
          cursor: 'pointer',
          marginBottom: '2rem'
        }}>
          🚀 Envoyer à {selectedAI}
        </button>
        
        <div style={{
          background: 'rgba(255, 255, 255, 0.05)',
          padding: '20px',
          borderRadius: '10px',
          marginBottom: '2rem'
        }}>
          <h4>✨ Fonctionnalités:</h4>
          <div style={{ display: 'flex', justifyContent: 'space-around', flexWrap: 'wrap' }}>
            <span>💬 Chat unifié</span>
            <span>🔄 Comparaison de réponses</span>
            <span>📊 Analyse de performance</span>
            <span>💾 Historique</span>
          </div>
        </div>
        
        <p style={{ opacity: 0.8, fontSize: '0.9rem' }}>
          ✅ Application Next.js opérationnelle sur le port 3005
        </p>
      </div>
    </div>
  );
}
