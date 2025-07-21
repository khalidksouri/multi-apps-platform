// Cache simple en mémoire (fallback si Redis non disponible)
interface CacheItem {
  value: any;
  expiry: number;
}

class SimpleCache {
  private cache: Map<string, CacheItem> = new Map();
  private cleanupInterval: NodeJS.Timer;
  
  constructor() {
    // Nettoyer le cache toutes les 5 minutes
    this.cleanupInterval = setInterval(() => {
      this.cleanup();
    }, 5 * 60 * 1000);
  }
  
  private cleanup(): void {
    const now = Date.now();
    // Correction: utiliser Array.from pour éviter l'erreur de downlevelIteration
    const entries = Array.from(this.cache.entries());
    for (let i = 0; i < entries.length; i++) {
      const [key, item] = entries[i];
      if (now > item.expiry) {
        this.cache.delete(key);
      }
    }
  }
  
  async get<T>(key: string): Promise<T | null> {
    const item = this.cache.get(key);
    if (!item) return null;
    
    if (Date.now() > item.expiry) {
      this.cache.delete(key);
      return null;
    }
    
    return item.value;
  }
  
  async set(key: string, value: any, ttlSeconds: number = 3600): Promise<void> {
    const expiry = Date.now() + (ttlSeconds * 1000);
    this.cache.set(key, { value, expiry });
  }
  
  async del(key: string): Promise<void> {
    this.cache.delete(key);
  }
  
  async flush(): Promise<void> {
    this.cache.clear();
  }
  
  generateKey(prefix: string, ...parts: string[]): string {
    return `${prefix}:${parts.join(':')}`;
  }
  
  async getOrSet<T>(
    key: string, 
    fetchFn: () => Promise<T>, 
    ttlSeconds: number = 3600
  ): Promise<T> {
    const cached = await this.get<T>(key);
    if (cached) return cached;
    
    const fresh = await fetchFn();
    await this.set(key, fresh, ttlSeconds);
    return fresh;
  }
}

export const cache = new SimpleCache();
export default cache;
