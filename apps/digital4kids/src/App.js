import React, { useState } from 'react';

function App() {
  const [currentTool, setCurrentTool] = useState('drawing');
  const [color, setColor] = useState('#ff0000');
  const [creations, setCreations] = useState(0);
  const [brushSize, setBrushSize] = useState(5);

  const tools = {
    drawing: '🎨 Dessin numérique',
    coding: '💻 Codage pour enfants',
    music: '🎵 Création musicale',
    animation: '🎬 Animation'
  };

  const colors = [
    '#ff0000', '#00ff00', '#0000ff', '#ffff00', 
    '#ff00ff', '#00ffff', '#ffa500', '#800080'
  ];

  const createSomething = () => {
    setCreations(creations + 1);
    alert(`Création ${creations + 1} réalisée avec ${tools[currentTool]} !`);
  };

  return (
    <div style={{ 
      padding: '20px', 
      textAlign: 'center', 
      fontFamily: 'Arial',
      backgroundColor: '#f0f8ff',
      minHeight: '100vh'
    }}>
      <h1 style={{ color: '#2c3e50', fontSize: '2.5rem', marginBottom: '20px' }}>
        🎨 Digital4Kids
      </h1>
      <p style={{ fontSize: '1.2rem', color: '#34495e', marginBottom: '30px' }}>
        Plateforme de créativité numérique pour enfants
      </p>
      
      <div style={{ 
        display: 'grid', 
        gridTemplateColumns: 'repeat(auto-fit, minmax(150px, 1fr))', 
        gap: '10px', 
        maxWidth: '600px', 
        margin: '0 auto 30px auto' 
      }}>
        {Object.entries(tools).map(([key, name]) => (
          <button 
            key={key}
            onClick={() => setCurrentTool(key)}
            style={{ 
              padding: '12px', 
              backgroundColor: currentTool === key ? '#3498db' : 'white',
              color: currentTool === key ? 'white' : '#2c3e50',
              border: '2px solid #3498db',
              borderRadius: '8px',
              cursor: 'pointer',
              fontSize: '14px',
              fontWeight: 'bold'
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
        maxWidth: '500px',
        margin: '0 auto',
        boxShadow: '0 4px 6px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{ color: '#2c3e50', marginBottom: '15px' }}>
          Outil actuel: {tools[currentTool]}
        </h3>
        
        <div style={{ marginBottom: '15px' }}>
          <label style={{ marginRight: '10px', fontWeight: 'bold' }}>Couleur: </label>
          <input 
            type="color" 
            value={color} 
            onChange={(e) => setColor(e.target.value)}
            style={{ width: '40px', height: '30px', border: 'none', cursor: 'pointer' }}
          />
        </div>

        <div style={{ marginBottom: '15px' }}>
          <label style={{ marginRight: '10px', fontWeight: 'bold' }}>Palette: </label>
          {colors.map(c => (
            <button
              key={c}
              onClick={() => setColor(c)}
              style={{
                width: '25px',
                height: '25px',
                backgroundColor: c,
                border: color === c ? '2px solid #2c3e50' : '1px solid #ccc',
                margin: '0 3px',
                cursor: 'pointer',
                borderRadius: '50%'
              }}
            />
          ))}
        </div>

        <div style={{ marginBottom: '20px' }}>
          <label style={{ marginRight: '10px', fontWeight: 'bold' }}>Taille: </label>
          <input 
            type="range" 
            min="1" 
            max="20" 
            value={brushSize} 
            onChange={(e) => setBrushSize(e.target.value)}
            style={{ width: '150px' }}
          />
          <span style={{ marginLeft: '10px' }}>{brushSize}px</span>
        </div>

        <button 
          onClick={createSomething}
          style={{ 
            padding: '12px 25px', 
            fontSize: '16px', 
            backgroundColor: '#e74c3c', 
            color: 'white', 
            border: 'none', 
            borderRadius: '5px', 
            cursor: 'pointer',
            fontWeight: 'bold'
          }}
        >
          Créer quelque chose !
        </button>

        <div style={{ marginTop: '15px', color: '#2c3e50' }}>
          <strong>Créations réalisées: {creations}</strong>
        </div>
      </div>
      
      <p style={{ marginTop: '30px', color: '#7f8c8d' }}>
        Port: 3006 | Status: ✅ Fonctionnel
      </p>
    </div>
  );
}

export default App;
