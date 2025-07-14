// =============================================
// 📄 apps/budgetcron/src/components/forms/ShippingCalculator.tsx - Corrigé
// =============================================
'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';

interface ShippingFormData {
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
}

interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

interface APIResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
}

export function ShippingCalculator() {
  const [results, setResults] = useState<ShippingCalculation | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const {
    register,
    handleSubmit,
    formState: { errors },
    reset,
  } = useForm<ShippingFormData>();

  const onSubmit = async (data: ShippingFormData) => {
    setLoading(true);
    setError(null);

    try {
      const response = await fetch('/api/shipping/calculate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      const result: APIResponse<ShippingCalculation> = await response.json();

      if (result.success && result.data) {
        setResults(result.data);
      } else {
        setError(result.error?.message || 'Erreur lors du calcul');
      }
    } catch (err) {
      setError('Erreur de connexion');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="space-y-6">
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
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
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

        <div className="flex gap-4">
          <button
            type="submit"
            disabled={loading}
            className="bg-blue-600 text-white px-4 py-2 rounded-md hover:bg-blue-700 disabled:opacity-50"
            data-testid="calculate-button"
          >
            {loading ? 'Calcul en cours...' : 'Calculer les frais'}
          </button>
          
          <button
            type="button"
            className="bg-gray-200 text-gray-900 px-4 py-2 rounded-md hover:bg-gray-300"
            onClick={() => {
              reset();
              setResults(null);
              setError(null);
            }}
          >
            Réinitialiser
          </button>
        </div>
      </form>

      {error && (
        <div className="p-4 bg-red-50 border border-red-200 rounded-md" data-testid="error-message">
          <p className="text-red-800">{error}</p>
        </div>
      )}

      {results && (
        <div className="space-y-4" data-testid="results-container">
          <h3 className="text-lg font-semibold">Résultats du calcul</h3>
          
          <div className="grid gap-4">
            {results.carriers.map((carrier) => (
              <div key={carrier.id} className="bg-white p-4 border border-gray-200 rounded-lg" data-testid={`carrier-${carrier.id}`}>
                <div className="flex justify-between items-center">
                  <div>
                    <h4 className="font-medium" data-testid="carrier-name">{carrier.name}</h4>
                    <p className="text-sm text-gray-600" data-testid="delivery-time">
                      Livraison: {carrier.deliveryTime}
                    </p>
                    <div className="flex items-center mt-1">
                      <span className="text-xs text-gray-500">Fiabilité: </span>
                      <div className="ml-1 flex">
                        {Array.from({ length: 5 }).map((_, i) => (
                          <span
                            key={i}
                            className={`text-xs ${
                              i < carrier.reliability ? 'text-yellow-400' : 'text-gray-300'
                            }`}
                          >
                            ★
                          </span>
                        ))}
                      </div>
                    </div>
                  </div>
                  
                  <div className="text-right">
                    <p className="text-2xl font-bold text-blue-600" data-testid="carrier-price">
                      {carrier.price.toFixed(2)}€
                    </p>
                    {carrier.tracking && (
                      <p className="text-xs text-green-600">Suivi inclus</p>
                    )}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}