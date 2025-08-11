// =============================================================================
// 🏓 TYPES PADDLE MATH4CHILD v4.2.0
// =============================================================================
// Alternative de paiement à Stripe pour certains marchés

export interface PaddleCheckout {
  vendor_id: number;
  product_id: number;
  prices: string[];
  title: string;
  message: string;
  coupon: string;
  return_url: string;
  expires: string;
  is_popup: boolean;
  parent_url: string;
  marketing_consent: string;
  customer_email: string;
  customer_country: string;
  customer_postcode: string;
  passthrough: string;
}

export interface PaddleSubscription {
  subscription_id: number;
  plan_id: number;
  user_id: number;
  user_email: string;
  marketing_consent: boolean;
  update_url: string;
  cancel_url: string;
  state: 'active' | 'trialing' | 'past_due' | 'deleted';
  signup_date: string;
  last_payment: {
    amount: number;
    currency: string;
    date: string;
  };
  next_payment: {
    amount: number;
    currency: string;
    date: string;
  };
}

export interface PaddleProduct {
  id: number;
  name: string;
  description: string;
  base_price: number;
  sale_price?: number;
  currency: string;
  screenshots: string[];
  icon: string;
}

// Configuration Paddle pour Math4Child
export interface PaddleConfig {
  vendor_id: number;
  public_key: string;
  environment: 'sandbox' | 'production';
  products: {
    basic: number;
    premium: number;
    ultimate: number;
  };
}

export const MATH4CHILD_PADDLE_CONFIG: PaddleConfig = {
  vendor_id: 123456, // À remplacer par le vrai vendor ID
  public_key: 'pk_test_xxxxx', // À remplacer par la vraie clé
  environment: 'sandbox',
  products: {
    basic: 789101,    // Product ID pour le plan basique
    premium: 789102,  // Product ID pour le plan premium
    ultimate: 789103 // Product ID pour le plan ultimate
  }
};

// Utilitaires Paddle
export function initializePaddle(config: PaddleConfig): void {
  // Initialisation du SDK Paddle
  if (typeof window !== 'undefined') {
    // @ts-ignore - Paddle est chargé via script externe
    window.Paddle.Setup({
      vendor: config.vendor_id,
      debug: config.environment === 'sandbox'
    });
  }
}

export function openPaddleCheckout(productId: number, options?: Partial<PaddleCheckout>): void {
  if (typeof window !== 'undefined') {
    // @ts-ignore
    window.Paddle.Checkout.open({
      product: productId,
      ...options
    });
  }
}
