import React, { useState } from 'react';

function App() {
  const [selectedGame, setSelectedGame] = useState('stories');
  const [score, setScore] = useState(0);
  const [language, setLanguage] = useState('fr');

  const games = {
    stories: '📚 Histoires interactives',
    quiz: '🧠 Quiz éducatif',
    creative: '🎨 Création artistique',
    math: '🔢 Maths amusantes'
  };

  const languages = {
    fr: '🇫🇷 Français',
    en: '🇺🇸 English',
    es: '🇪🇸 Español'
  };

  const playGame = (gameKey) => {
    setSelectedGame(gameKey);
    setScore(score + 10);
    alert(`Jeu ${games[gameKey]} lancé ! +10 points`);
  };

  return (
    <div style={{ 
      padding: '20px', 
      textAlign: 'center', 
      fontFamily: 'Arial', 
      backgroundColor: '#f8f9fa',
      minHeight: '100vh'
    }}>
      <h1 style={{ color: '#495057', fontSize: '2.5rem', marginBottom: '20px' }}>
        🤖 AI4Kids
      </h1>
      <p style={{ fontSize: '1.2rem', color: '#6c757d', marginBottom: '30px' }}>
        Intelligence artificielle éducative pour enfants
      </p>
      
      <div style={{ marginBottom: '30px' }}>
        <label style={{ marginRight: '10px', fontWeight: 'bold' }}>Langue: </label>
        <select 
          value={language} 
          onChange={(e) => setLanguage(e.target.value)}
          style={{ padding: '8px', borderRadius: '5px', border: '2px solid #007bff' }}
        >
          {Object.entries(languages).map(([code, name]) => (
            <option key={code} value={code}>{name}</option>
          ))}
        </select>
      </div>

      <div style={{ 
        display: 'grid', 
        gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', 
        gap: '15px', 
        maxWidth: '800px', 
        margin: '0 auto 30px auto' 
      }}>
        {Object.entries(games).map(([key, name]) => (
          <button 
            key={key}
            onClick={() => playGame(key)}
            style={{ 
              padding: '15px', 
              backgroundColor: selectedGame === key ? '#007bff' : 'white',
              color: selectedGame === key ? 'white' : '#495057',
              border: '2px solid #007bff',
              borderRadius: '10px',
              cursor: 'pointer',
              fontSize: '16px',
              fontWeight: 'bold',
              transition: 'all 0.3s ease'
            }}
          >
            {name}
          </button>
        ))}
      </div>

      <div style={{ 
        backgroundColor: 'white', 
        padding: '20px', 
        borderRadius: '10px',
        display: 'inline-block',
        boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{ color: '#28a745', margin: '0 0 10px 0' }}>
          Score: {score} points
        </h3>
        <p style={{ margin: '0', color: '#6c757d' }}>
          Jeu sélectionné: {games[selectedGame]}
        </p>
      </div>
      
      <p style={{ marginTop: '30px', color: '#6c757d' }}>
        Port: 3004 | Status: ✅ Fonctionnel
      </p>
    </div>
  );
}

export default App;
