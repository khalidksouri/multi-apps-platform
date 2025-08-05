'use client'

import { useEffect } from 'react'
import Script from 'next/script'

declare global {
  interface Window {
    gtag: (...args: any[]) => void
    dataLayer: any[]
  }
}

interface GoogleAnalyticsProps {
  measurementId: string
}

export default function GoogleAnalytics({ measurementId }: GoogleAnalyticsProps) {
  useEffect(() => {
    // Track page views
    const handleRouteChange = () => {
      if (typeof window.gtag !== 'undefined') {
        window.gtag('config', measurementId, {
          page_location: window.location.href,
          page_title: document.title,
        })
      }
    }

    // Track initial page view
    handleRouteChange()

    // Listen for route changes
    window.addEventListener('popstate', handleRouteChange)
    
    return () => {
      window.removeEventListener('popstate', handleRouteChange)
    }
  }, [measurementId])

  return (
    <>
      <Script
        src={`https://www.googletagmanager.com/gtag/js?id=${measurementId}`}
        strategy="afterInteractive"
      />
      <Script id="google-analytics" strategy="afterInteractive">
        {`
          window.dataLayer = window.dataLayer || [];
          function gtag(){dataLayer.push(arguments);}
          gtag('js', new Date());
          gtag('config', '${measurementId}', {
            send_page_view: false,
            custom_map: {
              'custom_dimension_1': 'user_language',
              'custom_dimension_2': 'subscription_plan',
              'custom_dimension_3': 'math_level'
            }
          });
          
          // Track Math4Child specific events
          window.trackMathEvent = function(action, category, label, value) {
            gtag('event', action, {
              event_category: category || 'Math4Child',
              event_label: label,
              value: value,
              custom_parameter_1: 'GOTEST'
            });
          };
          
          // Track subscription events
          window.trackSubscription = function(plan, value) {
            gtag('event', 'purchase', {
              transaction_id: Date.now().toString(),
              value: value,
              currency: 'EUR',
              items: [{
                item_id: plan,
                item_name: 'Math4Child ' + plan,
                category: 'Subscription',
                quantity: 1,
                price: value
              }]
            });
          };
        `}
      </Script>
    </>
  )
}

// Hook pour tracking facile
export function useAnalytics() {
  const trackEvent = (action: string, category?: string, label?: string, value?: number) => {
    if (typeof window !== 'undefined' && window.trackMathEvent) {
      window.trackMathEvent(action, category, label, value)
    }
  }

  const trackSubscription = (plan: string, value: number) => {
    if (typeof window !== 'undefined' && window.trackSubscription) {
      window.trackSubscription(plan, value)
    }
  }

  return { trackEvent, trackSubscription }
}
