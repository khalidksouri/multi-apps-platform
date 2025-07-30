import React, { useState } from 'react';

function App() {
  const [value, setValue] = useState(1);
  const [result, setResult] = useState(100);

  const convert = () => {
    setResult(value * 100);
  };

  return (
    <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial' }}>
      <h1>🔄 UnitFlip</h1>
      <p>Convertisseur d'unités</p>
      <input 
        type="number" 
        value={value} 
        onChange={(e) => setValue(e.target.value)}
        style={{ padding: '10px', margin: '10px' }}
      />
      <button onClick={convert} style={{ padding: '10px 20px' }}>
        Convertir
      </button>
      <p>Résultat: {result}</p>
      <p>Port: 3002</p>
    </div>
  );
}

export default App;
