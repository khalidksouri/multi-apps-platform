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
        <circle cx="150" cy="150" r="140" fill="white" stroke="#f0f0f0" strokeWidth="2"/>
        <path
          d="M120 200 L150 120 L180 200 M130 180 L170 180"
          stroke="#4a90e2"
          strokeWidth="8"
          strokeLinecap="round"
          strokeLinejoin="round"
          fill="none"
        />
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
