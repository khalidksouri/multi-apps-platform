// Utilitaires pour le tracking d'événements

declare global {
  interface Window {
    gtag?: (command: string, eventName: string, properties?: Record<string, any>) => void;
  }
}

export const trackEvent = (eventName: string, properties?: Record<string, any>) => {
  if (typeof window !== 'undefined' && window.gtag) {
    window.gtag('event', eventName, properties);
  }
  
  // Log pour développement
  if (process.env.NODE_ENV === 'development') {
    // console.log('Analytics Event:', { eventName, properties });
  }
};

export const trackPlanSelection = (planId: string, period: string) => {
  trackEvent('plan_selected', {
    plan_id: planId,
    billing_period: period,
    timestamp: new Date().toISOString()
  });
};

export const trackLanguageChange = (from: string, to: string) => {
  trackEvent('language_changed', {
    from_language: from,
    to_language: to,
    timestamp: new Date().toISOString()
  });
};

export const trackModalOpen = (modalName: string) => {
  trackEvent('modal_opened', {
    modal_name: modalName,
    timestamp: new Date().toISOString()
  });
};

export const trackFeatureInteraction = (featureId: string, action: string) => {
  trackEvent('feature_interaction', {
    feature_id: featureId,
    action,
    timestamp: new Date().toISOString()
  });
};
