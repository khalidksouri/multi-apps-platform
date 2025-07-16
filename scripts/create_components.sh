#!/bin/bash

set -e

echo "🧩 Création des composants React..."

# Configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."
AI4KIDS_APP_DIR="$PROJECT_ROOT/apps/ai4kids"
COMPONENTS_DIR="$AI4KIDS_APP_DIR/src/components"

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Créer les dossiers
mkdir -p "$COMPONENTS_DIR"
mkdir -p "$COMPONENTS_DIR/ui"

# Créer le composant Logo
echo -e "${BLUE}📝 Création du composant Logo...${NC}"
cat > "$COMPONENTS_DIR/AI4KidsLogo.tsx" << 'LOGO_EOF'
import React from 'react';

interface LogoProps {
  size?: number;
  className?: string;
}

export const AI4KidsLogo: React.FC<LogoProps> = ({ size = 100, className = '' }) => {
  return (
    <div className={`ai4kids-logo ${className}`} style={{ width: size, height: size }}>
      <svg
        width={size}
        height={size}
        viewBox="0 0 300 300"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        {/* Fond du logo */}
        <circle cx="150" cy="150" r="140" fill="white" stroke="#f0f0f0" strokeWidth="2"/>
        
        {/* Lettre A centrale */}
        <path
          d="M120 200 L150 120 L180 200 M130 180 L170 180"
          stroke="#4a90e2"
          strokeWidth="8"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        />
        
        {/* Personnage bleu (haut) */}
        <g transform="translate(150, 80)">
          <circle cx="0" cy="0" r="20" fill="#4ECDC4"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#4ECDC4" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage orange (droite) */}
        <g transform="translate(220, 150)">
          <circle cx="0" cy="0" r="20" fill="#FF8C42"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF8C42" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage rose (bas) */}
        <g transform="translate(150, 220)">
          <circle cx="0" cy="0" r="20" fill="#FF6B9D"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#FF6B9D" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Personnage vert (gauche) */}
        <g transform="translate(80, 150)">
          <circle cx="0" cy="0" r="20" fill="#95E1D3"/>
          <circle cx="-8" cy="-5" r="3" fill="white"/>
          <circle cx="8" cy="-5" r="3" fill="white"/>
          <circle cx="-8" cy="-5" r="1.5" fill="black"/>
          <circle cx="8" cy="-5" r="1.5" fill="black"/>
          <ellipse cx="0" cy="5" rx="8" ry="4" fill="white"/>
          <path d="M-20 15 Q-15 25 -10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
          <path d="M20 15 Q15 25 10 15" stroke="#95E1D3" strokeWidth="4" strokeLinecap="round" fill="none"/>
        </g>
        
        {/* Étoiles décoratives */}
        <g fill="#FFD93D">
          <path d="M50 100 L52 106 L58 106 L53 110 L55 116 L50 112 L45 116 L47 110 L42 106 L48 106 Z"/>
          <path d="M250 100 L252 106 L258 106 L253 110 L255 116 L250 112 L245 116 L247 110 L242 106 L248 106 Z"/>
          <path d="M50 200 L52 206 L58 206 L53 210 L55 216 L50 212 L45 216 L47 210 L42 206 L48 206 Z"/>
          <path d="M250 200 L252 206 L258 206 L253 210 L255 216 L250 212 L245 216 L247 210 L242 206 L248 206 Z"/>
        </g>
      </svg>
    </div>
  );
};

// Version du logo avec texte
export const AI4KidsLogoWithText: React.FC<LogoProps> = ({ size = 200, className = '' }) => {
  return (
    <div className={`ai4kids-logo-with-text ${className}`} style={{ width: size, height: size * 0.8 }}>
      <AI4KidsLogo size={size * 0.6} />
      <div 
        style={{
          fontSize: size * 0.12,
          fontWeight: 'bold',
          textAlign: 'center',
          marginTop: size * 0.05,
          background: 'linear-gradient(45deg, #FF6B9D, #FF8C42, #4ECDC4, #95E1D3)',
          backgroundClip: 'text',
          WebkitBackgroundClip: 'text',
          color: 'transparent',
          fontFamily: 'Comic Sans MS, cursive, sans-serif'
        }}
      >
        AI4KIDS
      </div>
    </div>
  );
};
LOGO_EOF

# Créer le composant Header
echo -e "${BLUE}📝 Création du composant Header...${NC}"
cat > "$COMPONENTS_DIR/Header.tsx" << 'HEADER_EOF'
import React, { useState } from 'react';
import { AI4KidsLogo } from './AI4KidsLogo';

interface HeaderProps {
  onNavigate?: (section: string) => void;
}

export const Header: React.FC<HeaderProps> = ({ onNavigate }) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const navItems = [
    { id: 'home', label: 'Accueil', icon: '🏠' },
    { id: 'games', label: 'Jeux', icon: '🎮' },
    { id: 'stories', label: 'Histoires', icon: '📚' },
    { id: 'learn', label: 'Apprendre', icon: '🧠' },
    { id: 'about', label: 'À propos', icon: '❓' },
  ];

  return (
    <header className="ai4kids-nav sticky top-0 z-50 shadow-lg">
      <div className="container mx-auto px-4 py-3">
        <div className="flex items-center justify-between">
          {/* Logo et nom */}
          <div className="flex items-center space-x-3">
            <AI4KidsLogo size={60} className="logo" />
            <div className="text-white">
              <h1 className="text-2xl font-bold leading-tight">AI4KIDS</h1>
              <p className="text-sm text-white/80">Intelligence Artificielle pour Enfants</p>
            </div>
          </div>

          {/* Navigation desktop */}
          <nav className="hidden md:flex items-center space-x-1">
            {navItems.map((item) => (
              <button
                key={item.id}
                onClick={() => onNavigate?.(item.id)}
                className="flex items-center space-x-2 px-4 py-2 rounded-full text-white hover:bg-white/10 transition-all duration-300 font-medium"
              >
                <span className="text-lg">{item.icon}</span>
                <span>{item.label}</span>
              </button>
            ))}
          </nav>

          {/* Bouton menu mobile */}
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="md:hidden p-2 rounded-lg text-white hover:bg-white/10 transition-all duration-300"
          >
            <div className="w-6 h-6 flex flex-col justify-center items-center">
              <span className={`block w-5 h-0.5 bg-white transform transition-all duration-300 ${isMenuOpen ? 'rotate-45 translate-y-1' : ''}`}></span>
              <span className={`block w-5 h-0.5 bg-white mt-1 transition-all duration-300 ${isMenuOpen ? 'opacity-0' : ''}`}></span>
              <span className={`block w-5 h-0.5 bg-white mt-1 transform transition-all duration-300 ${isMenuOpen ? '-rotate-45 -translate-y-1' : ''}`}></span>
            </div>
          </button>
        </div>

        {/* Menu mobile */}
        {isMenuOpen && (
          <div className="md:hidden mt-4 pb-4 border-t border-white/10">
            <nav className="flex flex-col space-y-2 pt-4">
              {navItems.map((item) => (
                <button
                  key={item.id}
                  onClick={() => {
                    onNavigate?.(item.id);
                    setIsMenuOpen(false);
                  }}
                  className="flex items-center space-x-3 px-4 py-3 rounded-lg text-white hover:bg-white/10 transition-all duration-300 font-medium text-left"
                >
                  <span className="text-xl">{item.icon}</span>
                  <span>{item.label}</span>
                </button>
              ))}
            </nav>
          </div>
        )}
      </div>
    </header>
  );
};
HEADER_EOF

# Créer les composants UI
echo -e "${BLUE}📝 Création des composants UI...${NC}"
cat > "$COMPONENTS_DIR/ui/Button.tsx" << 'BUTTON_EOF'
import React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'success' | 'warning';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  size = 'md',
  children,
  className = '',
  ...props
}) => {
  const baseClasses = 'ai4kids-button font-bold rounded-full transition-all duration-300 cursor-pointer';
  
  const variantClasses = {
    primary: 'bg-gradient-to-r from-blue-500 to-purple-600 text-white',
    secondary: 'bg-gradient-to-r from-orange-500 to-red-600 text-white',
    success: 'bg-gradient-to-r from-green-500 to-teal-600 text-white',
    warning: 'bg-gradient-to-r from-yellow-500 to-orange-600 text-white',
  };
  
  const sizeClasses = {
    sm: 'px-4 py-2 text-sm',
    md: 'px-8 py-3 text-base',
    lg: 'px-12 py-4 text-lg',
  };

  return (
    <button
      className={`${baseClasses} ${variantClasses[variant]} ${sizeClasses[size]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};
BUTTON_EOF

cat > "$COMPONENTS_DIR/ui/Card.tsx" << 'CARD_EOF'
import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
  hover?: boolean;
}

export const Card: React.FC<CardProps> = ({ children, className = '', hover = true }) => {
  const baseClasses = 'bg-white/95 rounded-3xl p-8 shadow-xl backdrop-blur-sm';
  const hoverClasses = hover ? 'hover:transform hover:scale-105 transition-all duration-300' : '';
  
  return (
    <div className={`${baseClasses} ${hoverClasses} ${className}`}>
      {children}
    </div>
  );
};
CARD_EOF

echo -e "${GREEN}✅ Composants créés avec succès${NC}"
