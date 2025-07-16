import React from 'react';

interface CardProps {
  children: React.ReactNode;
  className?: string;
}

export const Card: React.FC<CardProps> = ({ children, className = '' }) => {
  return (
    <div className={`bg-white/95 rounded-3xl p-6 md:p-8 shadow-xl backdrop-blur-sm hover:transform hover:scale-105 transition-all duration-300 ${className}`}>
      {children}
    </div>
  );
};
