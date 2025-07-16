import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { Capacitor } from '@capacitor/core';
import { App as CapacitorApp } from '@capacitor/app';

import Navigation from './mobile/components/Navigation';
import LoadingScreen from './mobile/components/LoadingScreen';
import PostmathApp from './mobile/apps/postmath/PostmathApp';
import UnitFlipApp from './mobile/apps/unitflip/UnitFlipApp';
import BudgetCronApp from './mobile/apps/budgetcron/BudgetCronApp';
import AI4KidsApp from './mobile/apps/ai4kids/AI4KidsApp';
import MultiAIApp from './mobile/apps/multiai/MultiAIApp';

const App: React.FC = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [isNative, setIsNative] = useState(false);

  useEffect(() => {
    const initialize = async () => {
      setIsNative(Capacitor.isNativePlatform());
      
      if (Capacitor.isNativePlatform()) {
        CapacitorApp.addListener('backButton', ({ canGoBack }) => {
          if (!canGoBack) {
            CapacitorApp.exitApp();
          } else {
            window.history.back();
          }
        });
      }

      setIsLoading(false);
    };

    initialize();
  }, []);

  if (isLoading) {
    return <LoadingScreen />;
  }

  return (
    <Router>
      <div className={`flex flex-col h-screen ${isNative ? 'pt-safe-top' : ''}`}>
        <main className="flex-1">
          <Routes>
            <Route path="/" element={<Navigate to="/postmath" replace />} />
            <Route path="/postmath" element={<PostmathApp isNative={isNative} />} />
            <Route path="/unitflip" element={<UnitFlipApp isNative={isNative} />} />
            <Route path="/budgetcron" element={<BudgetCronApp isNative={isNative} />} />
            <Route path="/ai4kids" element={<AI4KidsApp isNative={isNative} />} />
            <Route path="/multiai" element={<MultiAIApp isNative={isNative} />} />
          </Routes>
        </main>
        <Navigation isNative={isNative} />
      </div>
    </Router>
  );
};

export default App;
