'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';

interface ShippingForm {
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
}

export default function HomePage() {
  const [results, setResults] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  
  const { register, handleSubmit, formState: { errors } } = useForm<ShippingForm>();

  const onSubmit = async (data: ShippingForm) => {
    setLoading(true);
    
    setTimeout(() => {
      const mockResults = {
        carriers: [
          { id: 'colissimo', name: 'Colissimo', price: 6.50, deliveryTime: '2-3 jours' },
          { id: 'chronopost', name: 'Chronopost', price: 12.50, deliveryTime: '24h' },
          { id: 'dhl', name: 'DHL Express', price: 18.00, deliveryTime: '24-48h' },
        ]
      };
      setResults(mockResults);
      setLoading(false);
    }, 2000);
  };

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Calculateur d'Expédition</h1>
        <p className="text-gray-600 mt-2">
          Calculez et comparez les frais d'expédition de vos colis
        </p>
      </div>

      <div className="bg-white p-6 rounded-lg shadow">
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Ville de départ
              </label>
              <input
                {...register('departure', { required: 'Ville de départ requise' })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
                placeholder="Paris"
                data-testid="departure-input"
              />
              {errors.departure && (
                <p className="text-red-600 text-sm mt-1">{errors.departure.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Ville de destination
              </label>
              <input
                {...register('destination', { required: 'Ville de destination requise' })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
                placeholder="Lyon"
                data-testid="destination-input"
              />
              {errors.destination && (
                <p className="text-red-600 text-sm mt-1">{errors.destination.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Poids (kg)
              </label>
              <input
                {...register('weight', { 
                  required: 'Poids requis',
                  min: { value: 0.1, message: 'Poids minimum 0.1kg' },
                  max: { value: 30, message: 'Poids maximum 30kg' }
                })}
                type="number"
                step="0.1"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
                placeholder="2.5"
                data-testid="weight-input"
              />
              {errors.weight && (
                <p className="text-red-600 text-sm mt-1">{errors.weight.message}</p>
              )}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Dimensions (cm)
              </label>
              <input
                {...register('dimensions', { 
                  required: 'Dimensions requises',
                  pattern: {
                    value: /^\d+x\d+x\d+$/,
                    message: 'Format: LxlxH (ex: 30x20x15)'
                  }
                })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500"
                placeholder="30x20x15"
                data-testid="dimensions-input"
              />
              {errors.dimensions && (
                <p className="text-red-600 text-sm mt-1">{errors.dimensions.message}</p>
              )}
            </div>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-blue-600 text-white py-3 px-4 rounded-md hover:bg-blue-700 disabled:opacity-50 transition-colors"
            data-testid="calculate-button"
          >
            {loading ? 'Calcul en cours...' : 'Calculer les frais'}
          </button>
        </form>
      </div>

      {results && (
        <div className="bg-white p-6 rounded-lg shadow" data-testid="results-container">
          <h3 className="text-lg font-semibold mb-4">Résultats du calcul</h3>
          <div className="space-y-3">
            {results.carriers.map((carrier: any) => (
              <div 
                key={carrier.id} 
                className="flex justify-between items-center p-4 border border-gray-200 rounded-lg hover:border-blue-300 transition-colors"
                data-testid={`carrier-${carrier.id}`}
              >
                <div>
                  <h4 className="font-medium text-gray-900" data-testid="carrier-name">
                    {carrier.name}
                  </h4>
                  <p className="text-sm text-gray-600" data-testid="delivery-time">
                    Livraison: {carrier.deliveryTime}
                  </p>
                  <div className="flex items-center mt-1">
                    <span className="text-xs text-gray-500">Fiabilité: </span>
                    <div className="ml-1 flex">
                      {Array.from({ length: 5 }).map((_, i) => (
                        <span key={i} className="text-xs text-yellow-400">★</span>
                      ))}
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-2xl font-bold text-blue-600" data-testid="carrier-price">
                    {carrier.price.toFixed(2)}€
                  </p>
                  <p className="text-xs text-green-600">Suivi inclus</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
