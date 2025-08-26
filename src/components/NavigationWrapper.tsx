'use client';

import { useState, useEffect } from 'react';

export default function NavigationWrapper() {
  const [mounted, setMounted] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const handleNavigation = (path: string) => {
    window.location.href = path;
  };

  const toggleDropdown = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDropdownOpen(!isDropdownOpen);
  };

  const handleDropdownClick = (path: string) => {
    setIsDropdownOpen(false);
    handleNavigation(path);
  };

  if (!mounted) {
    return (
      <nav className="fixed top-0 w-full z-40 bg-white/90 backdrop-blur border-b">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center h-16">
            <div className="text-2xl font-bold text-blue-600">Math4Child</div>
            <div>Loading...</div>
          </div>
        </div>
      </nav>
    );
  }

  return (
    <>
      <nav className="fixed top-0 w-full z-50 bg-white/90 backdrop-blur border-b">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center h-16">
            <div className="flex items-center space-x-4">
              <button 
                type="button"
                onClick={() => handleNavigation('/')}
                className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent hover:scale-105 transition-transform cursor-pointer"
              >
                Math4Child
              </button>
              <div className="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                v4.2.0
              </div>
            </div>
            <div className="flex items-center space-x-6">
              <button 
                type="button"
                onClick={() => handleNavigation('/exercises')}
                className="text-gray-700 hover:text-blue-600 transition-colors cursor-pointer font-medium"
              >
                Exercices
              </button>
              <button 
                type="button"
                onClick={() => handleNavigation('/pricing')}
                className="text-gray-700 hover:text-blue-600 transition-colors cursor-pointer font-medium"
              >
                Plans
              </button>
              <div className="relative">
                <button 
                  type="button"
                  onClick={toggleDropdown}
                  className="text-gray-700 hover:text-blue-600 transition-colors cursor-pointer font-medium flex items-center"
                >
                  Plus
                  <svg className={`ml-1 h-4 w-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                  </svg>
                </button>
                {isDropdownOpen && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg border border-gray-200 z-[60]">
                    <div className="py-1">
                      <button 
                        type="button"
                        onClick={() => handleDropdownClick('/dashboard')}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        Dashboard
                      </button>
                      <button 
                        type="button"
                        onClick={() => handleDropdownClick('/profile')}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        Profil
                      </button>
                      <button 
                        type="button"
                        onClick={() => handleDropdownClick('/admin')}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                      >
                        Admin
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>
      {isDropdownOpen && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => setIsDropdownOpen(false)}
        />
      )}
    </>
  );
}
