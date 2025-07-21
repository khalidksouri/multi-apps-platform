import React, { useState } from 'react';

function App() {
  const [score, setScore] = useState(0);
  const [question, setQuestion] = useState('2 + 3 = ?');
  const [answer, setAnswer] = useState('');

  const checkAnswer = () => {
    if (answer === '5') {
      setScore(score + 1);
      setQuestion('Nouvelle question : 4 + 6 = ?');
    }
    setAnswer('');
  };

  return (
    <div style={{ padding: '20px', textAlign: 'center', fontFamily: 'Arial' }}>
      <h1>📚 Math4Kids</h1>
      <p>Application de mathématiques pour enfants</p>
      <div style={{ margin: '20px 0' }}>
        <h2>{question}</h2>
        <input 
          type="number" 
          value={answer} 
          onChange={(e) => setAnswer(e.target.value)}
          style={{ padding: '10px', fontSize: '16px' }}
        />
        <button onClick={checkAnswer} style={{ padding: '10px 20px', marginLeft: '10px' }}>
          Vérifier
        </button>
      </div>
      <p>Score: {score}</p>
      <p>Port: 3001</p>
    </div>
  );
}

export default App;
