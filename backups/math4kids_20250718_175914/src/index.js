import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './styles.css';

// Enregistrer le Service Worker pour PWA
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((registration) => {
        console.log('SW registered: ', registration);
      })
      .catch((registrationError) => {
        console.log('SW registration failed: ', registrationError);
      });
  });
}

// Gestion des erreurs globales
window.addEventListener('error', (event) => {
  console.error('Erreur Math4Kids:', event.error);
});

// Gestion des erreurs React
window.addEventListener('unhandledrejection', (event) => {
  console.error('Promise rejetée:', event.reason);
});

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);