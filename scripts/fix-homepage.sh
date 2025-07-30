#!/bin/bash

echo "🚀 Remplacement de la page d'accueil avec les niveaux 4-12 ans"

# Remplacer la page d'accueil
cat > src/app/page.tsx << 'HOMEPAGE_EOF'
'use client'

import { useState } from 'react'
import Link from 'next/link'

export default function HomePage() {
  const [selectedAge, setSelectedAge] = useState('')

  const ageRanges = [
    { value: '4-5', label: '4-5 ans', level: 'Niveau 1', description: 'Premiers nombres' },
    { value: '6-7', label: '6-7 ans', level: 'Niveau 2', description: 'Nombres jusqu\'à 20' },
    { value: '8-9', label: '8-9 ans', level: 'Niveau 3', description: 'Nombres jusqu\'à 100' },
    { value: '10-11', label: '10-11 ans', level: 'Niveau 4', description: 'Nombres jusqu\'à 1000' },
    { value: '12+', label: '12+ ans', level: 'Niveau 5', description: 'Nombres avancés' }
  ]

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        
        {/* Hero Section */}
        <section style={{ textAlign: 'center', marginBottom: '4rem' }}>
          <div style={{
            width: '120px',
            height: '120px',
            background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
            borderRadius: '2rem',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            margin: '0 auto 2rem auto',
            boxShadow: '0 20px 40px rgba(59, 130, 246, 0.3)'
          }}>
            <span style={{ fontSize: '3rem' }}>🧮</span>
          </div>
          
          <h1 style={{
            fontSize: '3.5rem',
            fontWeight: 'bold',
            color: '#1f2937',
            marginBottom: '1.5rem'
          }}>
            Math4Child
          </h1>
          
          <p style={{
            fontSize: '1.25rem',
            color: '#6b7280',
            marginBottom: '2rem',
            maxWidth: '600px',
            margin: '0 auto 2rem auto'
          }}>
            Application éducative pour l'apprentissage des mathématiques - Enfants de 4 à 12 ans
          </p>
        </section>

        {/* Sélection d'âge */}
        <section style={{ marginBottom: '4rem' }}>
          <div style={{ textAlign: 'center', marginBottom: '2rem' }}>
            <h2 style={{ fontSize: '1.5rem', fontWeight: '600', color: '#1f2937', marginBottom: '1rem' }}>
              Sélectionnez l'âge de votre enfant :
            </h2>
            
            <select
              value={selectedAge}
              onChange={(e) => setSelectedAge(e.target.value)}
              style={{
                padding: '0.75rem 1.5rem',
                fontSize: '1.125rem',
                border: '2px solid #d1d5db',
                borderRadius: '0.5rem',
                background: 'white',
                minWidth: '200px'
              }}
            >
              <option value="">Choisir un âge...</option>
              {ageRanges.map((range) => (
                <option key={range.value} value={range.value}>
                  {range.label} - {range.level}
                </option>
              ))}
            </select>
          </div>

          {/* Boutons d'action */}
          <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
            <Link
              href="/exercises"
              style={{
                background: 'linear-gradient(135deg, #3b82f6, #8b5cf6)',
                color: 'white',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none'
              }}
            >
              🚀 Commencer gratuitement
            </Link>
            
            <Link
              href="/subscription"
              style={{
                background: 'white',
                color: '#374151',
                border: '2px solid #d1d5db',
                padding: '1rem 2rem',
                borderRadius: '0.5rem',
                fontSize: '1.125rem',
                fontWeight: '600',
                textDecoration: 'none'
              }}
            >
              💎 Voir les abonnements
            </Link>
          </div>
        </section>
      </div>
    </div>
  )
}
HOMEPAGE_EOF

# Forcer la recompilation
touch src/app/page.tsx

echo "✅ Page d'accueil corrigée avec niveaux 4-12 ans"
