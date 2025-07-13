'use client';

import { useState } from 'react';

export default function HomePage() {
  const [selectedService, setSelectedService] = useState<string | null>(null);

  const aiServices = [
    {
      id: 'text-generation',
      title: 'Génération de Texte',
      description: 'GPT-4, Claude, Gemini',
      icon: '📝',
      status: 'active'
    },
    {
      id: 'image-generation', 
      title: 'Génération d\'Images',
      description: 'DALL-E, Midjourney, Stable Diffusion',
      icon: '🎨',
      status: 'active'
    },
    {
      id: 'code-assistant',
      title: 'Assistant Code',
      description: 'GitHub Copilot, CodeT5',
      icon: '💻',
      status: 'active'
    },
    {
      id: 'voice-synthesis',
      title: 'Synthèse Vocale',
      description: 'ElevenLabs, Azure Speech',
      icon: '🗣️',
      status: 'beta'
    }
  ];

  return (
    <div className="space-y-8 text-white">
      <div className="text-center">
        <h1 className="text-4xl font-bold mb-4">
          Hub Intelligence Artificielle
        </h1>
        <p className="text-xl text-gray-300">
          Accédez à tous les services IA depuis une seule plateforme
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {aiServices.map((service) => (
          <div
            key={service.id}
            className="bg-white/10 backdrop-blur-md p-6 rounded-lg border border-white/20 hover:bg-white/20 transition-all cursor-pointer"
            onClick={() => setSelectedService(service.id)}
          >
            <div className="text-center">
              <div className="text-4xl mb-3">{service.icon}</div>
              <h3 className="text-lg font-bold mb-2">{service.title}</h3>
              <p className="text-gray-300 text-sm mb-3">{service.description}</p>
              <span className={`px-2 py-1 rounded-full text-xs ${
                service.status === 'active' 
                  ? 'bg-green-500/20 text-green-300 border border-green-400/30'
                  : 'bg-yellow-500/20 text-yellow-300 border border-yellow-400/30'
              }`}>
                {service.status === 'active' ? 'Actif' : 'Bêta'}
              </span>
            </div>
          </div>
        ))}
      </div>

      {selectedService && (
        <div className="bg-white/10 backdrop-blur-md p-6 rounded-lg border border-white/20">
          <h3 className="text-2xl font-bold mb-4">
            Service sélectionné: {aiServices.find(s => s.id === selectedService)?.title}
          </h3>
          <p className="text-gray-300 mb-4">
            Configuration et paramètres du service IA...
          </p>
          <div className="flex space-x-4">
            <button className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700">
              Configurer
            </button>
            <button 
              className="bg-gray-600 text-white px-4 py-2 rounded-md hover:bg-gray-700"
              onClick={() => setSelectedService(null)}
            >
              Fermer
            </button>
          </div>
        </div>
      )}
    </div>
  );
}