// =============================================
// 📄 tests/support/performance.ts
// =============================================
export interface PerformanceMetrics {
  pageLoadTime: number;
  domContentLoaded: number;
  firstContentfulPaint: number;
  largestContentfulPaint: number;
  cumulativeLayoutShift: number;
  totalBlockingTime: number;
}

export class PerformanceMonitor {
  private page: any;
  private metrics: PerformanceMetrics = {
    pageLoadTime: 0,
    domContentLoaded: 0,
    firstContentfulPaint: 0,
    largestContentfulPaint: 0,
    cumulativeLayoutShift: 0,
    totalBlockingTime: 0
  };

  async init(page: any): Promise<void> {
    this.page = page;
    
    // Écouter les événements de performance
    await this.page.addInitScript(() => {
      window.performanceMetrics = {
        navigationStart: performance.now(),
        measurements: []
      };
    });
  }

  async collectMetrics(): Promise<PerformanceMetrics> {
    if (!this.page) return this.metrics;

    try {
      // Collecter les métriques Core Web Vitals
      const metricsData = await this.page.evaluate(() => {
        return new Promise((resolve) => {
          // Attendre que les métriques soient disponibles
          setTimeout(() => {
            const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
            const paint = performance.getEntriesByType('paint');
            
            const fcp = paint.find(entry => entry.name === 'first-contentful-paint');
            
            resolve({
              pageLoadTime: navigation.loadEventEnd - navigation.navigationStart,
              domContentLoaded: navigation.domContentLoadedEventEnd - navigation.navigationStart,
              firstContentfulPaint: fcp ? fcp.startTime : 0,
              // LCP et CLS nécessitent des API plus avancées
              largestContentfulPaint: 0,
              cumulativeLayoutShift: 0,
              totalBlockingTime: 0
            });
          }, 1000);
        });
      });

      this.metrics = { ...this.metrics, ...metricsData };
      return this.metrics;
    } catch (error) {
      console.warn('Erreur lors de la collecte des métriques de performance:', error);
      return this.metrics;
    }
  }

  validateMetrics(thresholds?: Partial<PerformanceMetrics>): boolean {
    const defaultThresholds = {
      pageLoadTime: 5000,
      domContentLoaded: 3000,
      firstContentfulPaint: 2000,
      largestContentfulPaint: 4000,
      cumulativeLayoutShift: 0.1,
      totalBlockingTime: 300
    };

    const finalThresholds = { ...defaultThresholds, ...thresholds };
    
    return Object.entries(finalThresholds).every(([key, threshold]) => {
      const value = this.metrics[key as keyof PerformanceMetrics];
      return value <= threshold;
    });
  }

  getReport(): string {
    return JSON.stringify(this.metrics, null, 2);
  }

  async stop(): Promise<void> {
    await this.collectMetrics();
    console.log('📊 Métriques de performance:', this.getReport());
  }
}