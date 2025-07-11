'use client';

import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { Button, Input, Card } from '@multiapps/ui';
import { ShippingCalculation, APIResponse } from '@multiapps/shared';
import { Package, MapPin, Weight, Ruler } from 'lucide-react';

interface ShippingFormData {
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
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
          <Input
            {...register('departure', { required: 'Ville de départ requise' })}
            label="Ville de départ"
            placeholder="Paris"
            leftIcon={<MapPin className="w-4 h-4" />}
            error={errors.departure?.message}
            data-testid="departure-input"
          />
          
          <Input
            {...register('destination', { required: 'Ville de destination requise' })}
            label="Ville de destination"
            placeholder="Lyon"
            leftIcon={<MapPin className="w-4 h-4" />}
            error={errors.destination?.message}
            data-testid="destination-input"
          />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Input
            {...register('weight', { 
              required: 'Poids requis',
              min: { value: 0.1, message: 'Poids minimum 0.1kg' },
              max: { value: 30, message: 'Poids maximum 30kg' }
            })}
            type="number"
            step="0.1"
            label="Poids (kg)"
            placeholder="2.5"
            leftIcon={<Weight className="w-4 h-4" />}
            error={errors.weight?.message}
            data-testid="weight-input"
          />
          
          <Input
            {...register('dimensions', { 
              required: 'Dimensions requises',
              pattern: {
                value: /^\d+x\d+x\d+$/,
                message: 'Format: LxlxH (ex: 30x20x15)'
              }
            })}
            label="Dimensions (cm)"
            placeholder="30x20x15"
            leftIcon={<Ruler className="w-4 h-4" />}
            error={errors.dimensions?.message}
            data-testid="dimensions-input"
          />
        </div>

        <div className="flex gap-4">
          <Button
            type="submit"
            loading={loading}
            icon={<Package className="w-4 h-4" />}
            data-testid="calculate-button"
          >
            {loading ? 'Calcul en cours...' : 'Calculer les frais'}
          </Button>
          
          <Button
            type="button"
            variant="secondary"
            onClick={() => {
              reset();
              setResults(null);
              setError(null);
            }}
          >
            Réinitialiser
          </Button>
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
              <Card key={carrier.id} className="p-4" data-testid={`carrier-${carrier.id}`}>
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
              </Card>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
