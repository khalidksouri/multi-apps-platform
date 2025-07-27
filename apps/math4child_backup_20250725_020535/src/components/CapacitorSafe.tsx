'use client'

import { useEffect, useState } from 'react'

interface CapacitorSafeProps {
  children: React.ReactNode
  fallback?: React.ReactNode
}

export default function CapacitorSafe({ children, fallback }: CapacitorSafeProps) {
  const [isClient, setIsClient] = useState(false)
  
  useEffect(() => {
    setIsClient(true)
  }, [])
  
  if (!isClient) {
    return <>{fallback || <div>Chargement...</div>}</>
  }
  
  return <>{children}</>
}
