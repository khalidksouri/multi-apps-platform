// =============================================
// 📄 Fichier shipping.ts à créer dans chaque app
// =============================================

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
      maxWeight: 30,
      deliveryTime: '2-3 jours',
      reliability: 4,
      tracking: true,
    },
    {
      id: 'chronopost',
      name: 'Chronopost',
      baseRate: 12.50,
      weightMultiplier: 3.5,
      maxWeight: 30,
      deliveryTime: '24h',
      reliability: 5,
      tracking: true,
    },
    {
      id: 'dhl',
      name: 'DHL Express',
      baseRate: 18.00,
      weightMultiplier: 4.0,
      maxWeight: 30,
      deliveryTime: '24-48h',
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
    // Simulation d'un appel API
    await this.delay(1000);

    const carriers: Carrier[] = this.carriers.map((carrier) => {
      const price = this.calculatePrice(carrier, data.weight, data.departure, data.destination);
      
      return {
        id: carrier.id,
        name: carrier.name,
        price,
        deliveryTime: carrier.deliveryTime,
        reliability: carrier.reliability,
        tracking: carrier.tracking,
      };
    });

    // Tri par prix croissant
    carriers.sort((a, b) => a.price - b.price);

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

  private calculatePrice(
    carrier: any,
    weight: number,
    departure: string,
    destination: string
  ): number {
    let price = carrier.baseRate + (weight * carrier.weightMultiplier);
    
    // Majoration pour certaines destinations
    const internationalDestinations = ['londres', 'berlin', 'madrid', 'rome'];
    if (internationalDestinations.some(dest => 
      destination.toLowerCase().includes(dest)
    )) {
      price *= 1.8;
    }
    
    // Arrondi au centime
    return Math.round(price * 100) / 100;
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
