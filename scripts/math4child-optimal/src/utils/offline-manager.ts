// =============================================================================
// 📴 GESTIONNAIRE HORS-LIGNE COMPLET MATH4CHILD
// =============================================================================

import { useState, useEffect, useCallback } from 'react'

export interface OfflineData {
  questions: any[]
  progress: any[]
  userSettings: any
  lastSync: number
}

export interface NetworkStatus {
  isOnline: boolean
  isSlowConnection: boolean
  effectiveType: string
  downlink: number
  rtt: number
}

export class OfflineManager {
  private static instance: OfflineManager
  private db: IDBDatabase | null = null
  private syncQueue: any[] = []
  
  static getInstance(): OfflineManager {
    if (!this.instance) {
      this.instance = new OfflineManager()
    }
    return this.instance
  }
  
  async initialize(): Promise<void> {
    await this.initializeDB()
    this.setupSyncOnReconnect()
  }
  
  private async initializeDB(): Promise<void> {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open('Math4ChildOffline', 1)
      
      request.onerror = () => reject(request.error)
      request.onsuccess = () => {
        this.db = request.result
        resolve()
      }
      
      request.onupgradeneeded = (event) => {
        const db = (event.target as IDBOpenDBRequest).result
        
        // Store questions
        if (!db.objectStoreNames.contains('questions')) {
          const questionsStore = db.createObjectStore('questions', { keyPath: 'id' })
          questionsStore.createIndex('level', 'level')
          questionsStore.createIndex('operation', 'operation')
        }
        
        // Store progression
        if (!db.objectStoreNames.contains('progress')) {
          const progressStore = db.createObjectStore('progress', { keyPath: 'id' })
          progressStore.createIndex('timestamp', 'timestamp')
          progressStore.createIndex('synced', 'synced')
        }
        
        // Store paramètres
        if (!db.objectStoreNames.contains('settings')) {
          db.createObjectStore('settings', { keyPath: 'key' })
        }
      }
    })
  }
  
  async saveOffline(storeName: string, data: any): Promise<void> {
    if (!this.db) await this.initialize()
    
    const transaction = this.db!.transaction([storeName], 'readwrite')
    const store = transaction.objectStore(storeName)
    
    const dataWithMeta = {
      ...data,
      savedAt: Date.now(),
      synced: false
    }
    
    store.put(dataWithMeta)
    
    return new Promise((resolve, reject) => {
      transaction.oncomplete = () => resolve()
      transaction.onerror = () => reject(transaction.error)
    })
  }
  
  async getOfflineData(storeName: string, query?: any): Promise<any[]> {
    if (!this.db) await this.initialize()
    
    const transaction = this.db!.transaction([storeName], 'readonly')
    const store = transaction.objectStore(storeName)
    
    return new Promise((resolve, reject) => {
      const request = query ? store.getAll(query) : store.getAll()
      
      request.onsuccess = () => resolve(request.result)
      request.onerror = () => reject(request.error)
    })
  }
  
  async syncWhenOnline(): Promise<void> {
    if (!navigator.onLine) {
      console.log('📴 [OFFLINE] Pas de connexion, sync différée')
      return
    }
    
    const unsyncedProgress = await this.getUnsyncedData('progress')
    
    for (const item of unsyncedProgress) {
      try {
        await this.syncItem(item)
        await this.markAsSynced('progress', item.id)
        console.log('✅ [SYNC] Item synchronisé:', item.id)
      } catch (error) {
        console.error('❌ [SYNC] Échec sync:', item.id, error)
      }
    }
  }
  
  private async getUnsyncedData(storeName: string): Promise<any[]> {
    const transaction = this.db!.transaction([storeName], 'readonly')
    const store = transaction.objectStore(storeName)
    const index = store.index('synced')
    
    return new Promise((resolve, reject) => {
      const request = index.getAll(false)
      request.onsuccess = () => resolve(request.result)
      request.onerror = () => reject(request.error)
    })
  }
  
  private async syncItem(item: any): Promise<void> {
    const response = await fetch('/api/sync', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(item)
    })
    
    if (!response.ok) {
      throw new Error(`Sync failed: ${response.status}`)
    }
  }
  
  private async markAsSynced(storeName: string, id: string): Promise<void> {
    const transaction = this.db!.transaction([storeName], 'readwrite')
    const store = transaction.objectStore(storeName)
    
    const getRequest = store.get(id)
    
    return new Promise((resolve, reject) => {
      getRequest.onsuccess = () => {
        const data = getRequest.result
        if (data) {
          data.synced = true
          data.syncedAt = Date.now()
          
          const putRequest = store.put(data)
          putRequest.onsuccess = () => resolve()
          putRequest.onerror = () => reject(putRequest.error)
        } else {
          resolve()
        }
      }
      getRequest.onerror = () => reject(getRequest.error)
    })
  }
  
  private setupSyncOnReconnect(): void {
    window.addEventListener('online', () => {
      console.log('🌐 [ONLINE] Connexion rétablie, synchronisation...')
      this.syncWhenOnline()
    })
  }
}

// Hook React pour mode hors-ligne
export function useOfflineCapabilities() {
  const [isOnline, setIsOnline] = useState(navigator.onLine)
  const [networkStatus, setNetworkStatus] = useState<NetworkStatus>({
    isOnline: navigator.onLine,
    isSlowConnection: false,
    effectiveType: 'unknown',
    downlink: 0,
    rtt: 0
  })
  const [offlineManager] = useState(() => OfflineManager.getInstance())
  
  useEffect(() => {
    const updateOnlineStatus = () => {
      setIsOnline(navigator.onLine)
      updateNetworkStatus()
    }
    
    const updateNetworkStatus = () => {
      const connection = (navigator as any).connection
      if (connection) {
        const status: NetworkStatus = {
          isOnline: navigator.onLine,
          isSlowConnection: connection.effectiveType === '2g' || connection.downlink < 1,
          effectiveType: connection.effectiveType || 'unknown',
          downlink: connection.downlink || 0,
          rtt: connection.rtt || 0
        }
        setNetworkStatus(status)
      }
    }
    
    window.addEventListener('online', updateOnlineStatus)
    window.addEventListener('offline', updateOnlineStatus)
    
    if ((navigator as any).connection) {
      (navigator as any).connection.addEventListener('change', updateNetworkStatus)
    }
    
    // Initialiser le gestionnaire hors-ligne
    offlineManager.initialize()
    
    // Status initial
    updateNetworkStatus()
    
    return () => {
      window.removeEventListener('online', updateOnlineStatus)
      window.removeEventListener('offline', updateOnlineStatus)
      if ((navigator as any).connection) {
        (navigator as any).connection.removeEventListener('change', updateNetworkStatus)
      }
    }
  }, [offlineManager])
  
  const saveOffline = useCallback(async (storeName: string, data: any) => {
    return offlineManager.saveOffline(storeName, data)
  }, [offlineManager])
  
  const getOfflineData = useCallback(async (storeName: string, query?: any) => {
    return offlineManager.getOfflineData(storeName, query)
  }, [offlineManager])
  
  const syncWhenOnline = useCallback(async () => {
    return offlineManager.syncWhenOnline()
  }, [offlineManager])
  
  return {
    isOnline,
    networkStatus,
    saveOffline,
    getOfflineData,
    syncWhenOnline
  }
}

export default OfflineManager
