import React, { useState } from 'react';
import './App.css';

function App() {
  const [count, setCount] = useState(0);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Math4Kids</h1>
        <p>Application d'apprentissage mathématique</p>
        <div className="card">
          <button onClick={() => setCount((count) => count + 1)}>
            Compteur: {count}
          </button>
        </div>
        <p className="read-the-docs">
          Cliquez sur le bouton pour commencer
        </p>
      </header>
    </div>
  );
}

export default App;
