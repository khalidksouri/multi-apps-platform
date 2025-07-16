import React from 'react';

interface AI4KidsAppProps {
  isNative?: boolean;
}

const AI4KidsApp: React.FC<AI4KidsAppProps> = ({ isNative = false }) => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-400 via-purple-400 to-indigo-400 p-4">
      <div className="max-w-md mx-auto">
        <div className="text-center mb-6">
          <h1 className="text-4xl font-bold text-white mb-2">🎨 AI4Kids</h1>
          <p className="text-white/80">Apprentissage {isNative ? 'Mobile' : 'Web'}</p>
        </div>

        <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
          <div className="text-center">
            <div className="text-6xl mb-4">🌟</div>
            <h3 className="text-xl font-bold text-white mb-2">Bientôt disponible !</h3>
            <p className="text-white/80">Application d'apprentissage pour enfants</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AI4KidsApp;
