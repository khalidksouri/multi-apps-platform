export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

export class ShippingService {
  private carriers = [
    {
      id: 'colissimo',
      name: 'Colissimo',
      baseRate: 6.50,
      weightMultiplier: 2.0,
      deliveryTime: '2-3 jours',
      reliability: 4,
      tracking: true,
    },
    {
      id: 'chronopost',
      name: 'Chronopost',
      baseRate: 12.50,
      weightMultiplier: 3.5,
      deliveryTime: '24h',
      reliability: 5,
      tracking: true,
    },
  ];

  async calculateShipping(data: {
    departure: string;
    destination: string;
    weight: number;
    dimensions: string;
  }): Promise<ShippingCalculation> {
    await this.delay(1000);
    
    const carriers: Carrier[] = this.carriers.map((carrier) => ({
      id: carrier.id,
      name: carrier.name,
      price: carrier.baseRate + (data.weight * carrier.weightMultiplier),
      deliveryTime: carrier.deliveryTime,
      reliability: carrier.reliability,
      tracking: carrier.tracking,
    }));

    return {
      id: `calc_${Date.now()}`,
      departure: data.departure,
      destination: data.destination,
      weight: data.weight,
      dimensions: data.dimensions,
      carriers,
      createdAt: new Date(),
    };
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
