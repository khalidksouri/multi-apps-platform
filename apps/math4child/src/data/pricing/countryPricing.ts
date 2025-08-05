// Prix adaptatifs par pays selon le pouvoir d'achat
export interface CountryPricing {
  country: string
  currency: string
  symbol: string
  monthly: number
  quarterly: number
  annual: number
  purchasingPower: number
}

export const COUNTRY_PRICING: CountryPricing[] = [
  { country: "FR", currency: "EUR", symbol: "€", monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: "US", currency: "USD", symbol: "$", monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: "GB", currency: "GBP", symbol: "£", monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 1.0 },
  { country: "DE", currency: "EUR", symbol: "€", monthly: 9.99, quarterly: 26.97, annual: 83.93, purchasingPower: 1.0 },
  { country: "ES", currency: "EUR", symbol: "€", monthly: 8.99, quarterly: 24.27, annual: 75.54, purchasingPower: 0.9 },
  { country: "JP", currency: "JPY", symbol: "¥", monthly: 1099, quarterly: 2967, annual: 9232, purchasingPower: 0.9 },
  { country: "CN", currency: "CNY", symbol: "¥", monthly: 59.99, quarterly: 161.97, annual: 503.93, purchasingPower: 0.5 },
  { country: "IN", currency: "INR", symbol: "₹", monthly: 499, quarterly: 1347, annual: 4193, purchasingPower: 0.25 }
]

export const getPricingForCountry = (countryCode: string): CountryPricing => {
  return COUNTRY_PRICING.find(p => p.country === countryCode) || COUNTRY_PRICING[0]
}

export const formatPrice = (amount: number, currency: string, symbol: string): string => {
  if (currency === "JPY" || currency === "KRW" || currency === "VND" || currency === "IDR") {
    return `${symbol}${Math.round(amount).toLocaleString()}`
  }
  return `${symbol}${amount.toFixed(2)}`
}
