'use client';

import React, { useEffect, useState } from 'react';
import { Home, Calculator, BarChart3, Settings, ArrowLeft } from 'lucide-react';

// Détection Capacitor sécurisée
const getCapacitorInfo = () => {
  if (typeof window === 'undefined') return { isCapacitor: false, platform: 'web' };
  
  const capacitor = (window as any).Capacitor;
  return {
    isCapacitor: !!capacitor?.isNativePlatform?.(),
    platform: capacitor?.getPlatform?.() || 'web'
  };
};

interface NavigationProps {
  currentPage?: string;
  onNavigate?: (targetPath: string) => void;
  showBackButton?: boolean;
  onBack?: () => void;
}

const Navigation: React.FC<NavigationProps> = ({ 
  currentPage = '/', 
  onNavigate, 
  showBackButton = false, 
  onBack 
}) => {
  const [platformInfo, setPlatformInfo] = useState({ isCapacitor: false, platform: 'web' });
  
  useEffect(() => {
    setPlatformInfo(getCapacitorInfo());
  }, []);

  const handleNavigation = (targetPath: string, event?: React.MouseEvent) => {
    event?.preventDefault();
    
    if (onNavigate) {
      onNavigate(targetPath);
    } else if (typeof window !== 'undefined') {
      // Navigation fallback
      if (platformInfo.isCapacitor) {
        window.location.hash = targetPath;
      } else {
        window.location.href = targetPath;
      }
    }
  };

  const navItems = [
    { path: '/', label: 'Accueil', icon: Home, testId: 'nav-home' },
    { path: '/game', label: 'Jeu', icon: Calculator, testId: 'nav-game' },
    { path: '/stats', label: 'Stats', icon: BarChart3, testId: 'nav-stats' },
    { path: '/settings', label: 'Options', icon: Settings, testId: 'nav-settings' },
  ];

  const isActive = (itemPath: string) => currentPage === itemPath;
  
  const baseClasses = "flex flex-col items-center p-3 rounded-lg transition-all duration-200 touch-manipulation";
  const activeClasses = "text-blue-600 bg-blue-50 scale-105 shadow-sm";
  const inactiveClasses = "text-gray-600 hover:text-blue-600 hover:bg-gray-50";

  // Interface mobile native (Capacitor iOS/Android)
  if (platformInfo.isCapacitor || platformInfo.platform !== 'web') {
    return (
      <div 
        className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50"
        style={{ paddingBottom: 'env(safe-area-inset-bottom, 0px)' }}
        data-testid="mobile-navigation"
      >
        {showBackButton && (
          <div className="absolute top-4 left-4">
            <button
              onClick={onBack}
              className="p-2 rounded-full bg-white shadow-md"
              data-testid="nav-back-button"
              aria-label="Retour"
            >
              <ArrowLeft size={20} />
            </button>
          </div>
        )}
        
        <div className="flex justify-around py-2 px-4 min-h-[70px]">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.path}
                onClick={(e) => handleNavigation(item.path, e)}
                className={`${baseClasses} min-w-[60px] ${
                  isActive(item.path) ? activeClasses : inactiveClasses
                }`}
                data-testid={item.testId}
                role="tab"
                aria-selected={isActive(item.path)}
                aria-label={item.label}
              >
                <Icon size={24} className="mb-1" />
                <span className="text-xs font-medium leading-tight">{item.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  // Interface web (Next.js - desktop et mobile responsive)
  return (
    <>
      {/* Navigation desktop */}
      <nav className="bg-white shadow-lg sticky top-0 z-40 hidden md:block" data-testid="desktop-navigation">
        <div className="max-w-7xl mx-auto px-4">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center">
              {showBackButton && (
                <button
                  onClick={onBack}
                  className="mr-4 p-2 rounded-full hover:bg-gray-100"
                  data-testid="nav-back-button"
                  aria-label="Retour"
                >
                  <ArrowLeft size={20} />
                </button>
              )}
              
              <div className="flex items-center space-x-2">
                <span className="text-2xl">🧮</span>
                <span className="text-xl font-bold text-purple-600">Math4Child</span>
              </div>
            </div>
            
            <div className="flex items-center space-x-6">
              {navItems.map((item) => {
                const Icon = item.icon;
                return (
                  <button
                    key={item.path}
                    onClick={(e) => handleNavigation(item.path, e)}
                    className={`flex items-center space-x-2 px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                      isActive(item.path)
                        ? 'text-blue-600 bg-blue-50 shadow-sm'
                        : 'text-gray-700 hover:text-blue-600 hover:bg-gray-50'
                    }`}
                    data-testid={item.testId}
                    aria-label={item.label}
                  >
                    <Icon size={18} />
                    <span>{item.label}</span>
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      </nav>

      {/* Navigation mobile web */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 shadow-lg z-50" data-testid="mobile-web-navigation">
        <div className="flex justify-around py-2 px-2">
          {navItems.map((item) => {
            const Icon = item.icon;
            return (
              <button
                key={item.path}
                onClick={(e) => handleNavigation(item.path, e)}
                className={`${baseClasses} flex-1 max-w-[80px] ${
                  isActive(item.path) ? activeClasses : inactiveClasses
                }`}
                data-testid={item.testId}
                title={item.label}
                aria-label={item.label}
              >
                <Icon size={20} className="mb-1" />
                <span className="text-xs">{item.label}</span>
              </button>
            );
          })}
        </div>
      </nav>
    </>
  );
};

export default Navigation;
