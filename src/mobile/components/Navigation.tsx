import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';

interface NavigationProps {
  isNative: boolean;
}

const apps = [
  { id: 'postmath', name: 'Postmath', icon: '🧮', path: '/postmath' },
  { id: 'unitflip', name: 'UnitFlip', icon: '🔄', path: '/unitflip' },
  { id: 'budgetcron', name: 'Budget', icon: '💰', path: '/budgetcron' },
  { id: 'ai4kids', name: 'AI4Kids', icon: '🎨', path: '/ai4kids' },
  { id: 'multiai', name: 'MultiAI', icon: '🤖', path: '/multiai' },
];

const Navigation: React.FC<NavigationProps> = ({ isNative }) => {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <nav className={`bg-white border-t border-gray-200 ${isNative ? 'pb-safe-bottom' : ''}`}>
      <div className="flex justify-around items-center py-2">
        {apps.map((app) => (
          <button
            key={app.id}
            onClick={() => navigate(app.path)}
            className={`flex flex-col items-center p-2 rounded-lg transition-all ${
              location.pathname === app.path
                ? 'text-indigo-600 bg-indigo-50'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            <span className="text-2xl mb-1">{app.icon}</span>
            <span className="text-xs font-medium">{app.name}</span>
          </button>
        ))}
      </div>
    </nav>
  );
};

export default Navigation;
