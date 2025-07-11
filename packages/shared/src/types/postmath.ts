export interface ShippingCalculation {
  id: string;
  departure: string;
  destination: string;
  weight: number;
  dimensions: string;
  carriers: Carrier[];
  createdAt: Date;
}

export interface Carrier {
  id: string;
  name: string;
  price: number;
  deliveryTime: string;
  reliability: number;
  tracking: boolean;
}

export interface TrackingInfo {
  trackingNumber: string;
  status: TrackingStatus;
  currentLocation?: string;
  estimatedDelivery?: Date;
  history: TrackingEvent[];
}

export type TrackingStatus = 'pending' | 'in_transit' | 'delivered' | 'returned' | 'lost';

export interface TrackingEvent {
  date: Date;
  location: string;
  description: string;
  status: TrackingStatus;
}
