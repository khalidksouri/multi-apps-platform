import React from 'react';
import { Feature } from '@/types';

interface FeatureCardProps {
  feature: Feature;
  className?: string;
}

export const FeatureCard: React.FC<FeatureCardProps> = ({ feature, className = '' }) => {
  return (
    <div className={`group relative bg-white rounded-2xl p-8 shadow-lg hover:shadow-2xl transition-all duration-300 hover:-translate-y-2 border border-gray-100 ${className}`}>
      <div className={`w-16 h-16 rounded-2xl bg-gradient-to-r ${feature.gradient} flex items-center justify-center mb-6 text-white group-hover:scale-110 transition-transform duration-300`}>
        {feature.icon}
      </div>
      <h3 className="text-xl font-bold text-gray-900 mb-3">{feature.title}</h3>
      <p className="text-gray-600 mb-4">{feature.description}</p>
      {feature.stats && (
        <div className="text-sm font-semibold text-blue-600 bg-blue-50 rounded-lg px-3 py-1 inline-block">
          {feature.stats}
        </div>
      )}
    </div>
  );
};
