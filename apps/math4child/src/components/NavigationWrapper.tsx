'use client';

import { useState, useEffect } from 'react';

export default function NavigationWrapper() {
  const [mounted, setMounted] = useState(false);
  const [isDropdownOpen, setIsDropdownOpen] = useState(false);
  const [isLanguageOpen, setIsLanguageOpen] = useState(false);
  const [currentLanguage, setCurrentLanguage] = useState('fr');

  const languages = [
    { code: 'fr', name: 'Français', flag: '🇫🇷' },
    { code: 'en', name: 'English', flag: '🇺🇸' },
    { code: 'es', name: 'Español', flag: '🇪🇸' },
    { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
    { code: 'ar', name: 'العربية', flag: '🇲🇦' },
    { code: 'ar-ps', name: 'العربية', flag: '🇵🇸' }
  ];

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
    setIsLanguageOpen(false);
  };

  const toggleLanguage = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setIsLanguageOpen(!isLanguageOpen);
    setIsDropdownOpen(false);
  };

  const getCurrentLanguage = () => {
    return languages.find(lang => lang.code === currentLanguage) || languages[0];
  };

  if (!mounted) {
    return (
      <nav className="fixed top-0 w-full z-40 bg-white/90 backdrop-blur border-b">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center h-16">
            <div className="text-2xl font-bold text-blue-600">Math4Child</div>
            <div>Chargement...</div>
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
                className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent hover:scale-105 transition-transform"
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
                className="text-gray-700 hover:text-blue-600 transition-colors font-medium"
              >
                Exercices
              </button>
              
              <button 
                type="button"
                onClick={() => handleNavigation('/pricing')}
                className="text-gray-700 hover:text-blue-600 transition-colors font-medium"
              >
                Plans
              </button>
              
              {/* Language Dropdown */}
              <div className="relative">
                <button 
                  type="button"
                  onClick={toggleLanguage}
                  className="flex items-center space-x-2 text-gray-700 hover:text-blue-600 transition-colors font-medium bg-gray-50 hover:bg-gray-100 px-3 py-2 rounded-lg"
                >
                  <span className="text-lg">{getCurrentLanguage().flag}</span>
                  <span className="hidden md:inline">{getCurrentLanguage().name}</span>
                  <svg className={`w-4 h-4 transition-transform ${isLanguageOpen ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                  </svg>
                </button>
                {isLanguageOpen && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg border z-[70]">
                    <div className="py-1">
                      {languages.map((lang) => (
                        <button 
                          key={lang.code}
                          type="button"
                          onClick={() => {
                            setCurrentLanguage(lang.code);
                            setIsLanguageOpen(false);
                          }}
                          className={`flex items-center space-x-3 w-full text-left px-4 py-2 text-sm hover:bg-gray-100 ${
                            currentLanguage === lang.code ? 'bg-blue-50 text-blue-600' : 'text-gray-700'
                          }`}
                        >
                          <span>{lang.flag}</span>
                          <span>{lang.name}</span>
                        </button>
                      ))}
                    </div>
                  </div>
                )}
              </div>
              
              {/* Menu Dropdown */}
              <div className="relative">
                <button 
                  type="button"
                  onClick={toggleDropdown}
                  className="text-gray-700 hover:text-blue-600 transition-colors font-medium flex items-center"
                >
                  Plus
                  <svg className={`ml-1 h-4 w-4 transition-transform ${isDropdownOpen ? 'rotate-180' : ''}`} fill="currentColor" viewBox="0 0 20 20">
                    <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                  </svg>
                </button>
                {isDropdownOpen && (
                  <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg border z-[60]">
                    <div className="py-1">
                      <button 
                        type="button"
                        onClick={() => {
                          setIsDropdownOpen(false);
                          handleNavigation('/dashboard');
                        }}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        📊 Dashboard
                      </button>
                      <button 
                        type="button"
                        onClick={() => {
                          setIsDropdownOpen(false);
                          handleNavigation('/profile');
                        }}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        👤 Profil
                      </button>
                      <button 
                        type="button"
                        onClick={() => {
                          setIsDropdownOpen(false);
                          handleNavigation('/admin');
                        }}
                        className="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
                      >
                        ⚙️ Admin
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>
      
      {/* Overlay */}
      {(isDropdownOpen || isLanguageOpen) && (
        <div 
          className="fixed inset-0 z-40" 
          onClick={() => {
            setIsDropdownOpen(false);
            setIsLanguageOpen(false);
          }}
        />
      )}
    </>
  );
}
