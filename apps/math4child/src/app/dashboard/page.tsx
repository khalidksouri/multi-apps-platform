'use client'

import { useState } from 'react'

export default function DashboardPage() {
  const [selectedPeriod, setSelectedPeriod] = useState('week')

  // Données de démonstration
  const stats = {
    totalExercises: 156,
    correctAnswers: 134,
    currentStreak: 7,
    totalTime: 240,
    accuracy: 86,
    level: 'Intermédiaire'
  }

  const recentActivities = [
    { date: '2024-01-15', operation: 'Addition', exercises: 12, accuracy: 92, time: 15 },
    { date: '2024-01-14', operation: 'Soustraction', exercises: 8, accuracy: 88, time: 12 },
    { date: '2024-01-13', operation: 'Multiplication', exercises: 10, accuracy: 85, time: 18 },
    { date: '2024-01-12', operation: 'Division', exercises: 6, accuracy: 83, time: 22 }
  ]

  return (
    <div style={{ 
      minHeight: '100vh', 
      background: 'linear-gradient(135deg, #eff6ff 0%, #f3e8ff 100%)',
      padding: '2rem'
    }}>
      <div style={{ maxWidth: '1200px', margin: '0 auto' }}>
        {/* Header */}
        <div style={{ marginBottom: '3rem' }}>
          <h1 style={{ 
            fontSize: '2.5rem', 
            fontWeight: 'bold', 
            color: '#1f2937', 
            marginBottom: '0.5rem' 
          }}>
            📊 Tableau de bord
          </h1>
          <p style={{ fontSize: '1.125rem', color: '#6b7280' }}>
            Suivez vos progrès et vos performances
          </p>
        </div>

        {/* Statistiques principales */}
        <section style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))', 
          gap: '1.5rem',
          marginBottom: '3rem'
        }}>
          {[
            { title: 'Exercices complétés', value: stats.totalExercises, icon: '📝', color: '#3b82f6' },
            { title: 'Réponses correctes', value: stats.correctAnswers, icon: '✅', color: '#10b981' },
            { title: 'Série actuelle', value: `${stats.currentStreak} jours`, icon: '🔥', color: '#f59e0b' },
            { title: 'Temps total', value: `${stats.totalTime} min`, icon: '⏱️', color: '#8b5cf6' }
          ].map((stat, index) => (
            <div key={index} style={{
              background: 'white',
              borderRadius: '1rem',
              padding: '2rem',
              boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
              textAlign: 'center',
              border: `3px solid ${stat.color}20`
            }}>
              <div style={{ fontSize: '2.5rem', marginBottom: '0.75rem' }}>{stat.icon}</div>
              <div style={{ fontSize: '2rem', fontWeight: 'bold', color: stat.color, marginBottom: '0.5rem' }}>
                {stat.value}
              </div>
              <div style={{ color: '#6b7280', fontSize: '0.875rem' }}>{stat.title}</div>
            </div>
          ))}
        </section>

        {/* Précision et niveau */}
        <section style={{ 
          display: 'grid', 
          gridTemplateColumns: 'repeat(auto-fit, minmax(300px, 1fr))', 
          gap: '2rem',
          marginBottom: '3rem'
        }}>
          {/* Précision */}
          <div style={{
            background: 'white',
            borderRadius: '1rem',
            padding: '2rem',
            boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
            textAlign: 'center'
          }}>
            <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
              🎯 Précision globale
            </h3>
            <div style={{
              width: '120px',
              height: '120px',
              borderRadius: '50%',
              background: `conic-gradient(#10b981 0% ${stats.accuracy}%, #e5e7eb ${stats.accuracy}% 100%)`,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              margin: '0 auto',
              position: 'relative'
            }}>
              <div style={{
                width: '90px',
                height: '90px',
                borderRadius: '50%',
                background: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1.5rem',
                fontWeight: 'bold',
                color: '#10b981'
              }}>
                {stats.accuracy}%
              </div>
            </div>
          </div>

          {/* Niveau actuel */}
          <div style={{
            background: 'white',
            borderRadius: '1rem',
            padding: '2rem',
            boxShadow: '0 4px 20px rgba(0,0,0,0.1)',
            textAlign: 'center'
          }}>
            <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
              🏆 Niveau actuel
            </h3>
            <div style={{ fontSize: '3rem', marginBottom: '1rem' }}>🌳</div>
            <div style={{ fontSize: '1.5rem', fontWeight: 'bold', color: '#8b5cf6', marginBottom: '0.5rem' }}>
              {stats.level}
            </div>
            <div style={{ color: '#6b7280', fontSize: '0.875rem' }}>
              Continuez comme ça !
            </div>
          </div>
        </section>

        {/* Activité récente */}
        <section style={{
          background: 'white',
          borderRadius: '1rem',
          padding: '2rem',
          boxShadow: '0 4px 20px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{ fontSize: '1.25rem', fontWeight: '600', color: '#1f2937', marginBottom: '1.5rem' }}>
            📈 Activité récente
          </h3>
          
          <div style={{ overflowX: 'auto' }}>
            <table style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead>
                <tr style={{ borderBottom: '2px solid #f3f4f6' }}>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Date</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Opération</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Exercices</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Précision</th>
                  <th style={{ padding: '0.75rem', textAlign: 'left', color: '#6b7280', fontSize: '0.875rem' }}>Temps</th>
                </tr>
              </thead>
              <tbody>
                {recentActivities.map((activity, index) => (
                  <tr key={index} style={{ borderBottom: '1px solid #f3f4f6' }}>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151' }}>
                      {new Date(activity.date).toLocaleDateString('fr-FR')}
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151' }}>
                      <span style={{
                        background: activity.operation === 'Addition' ? '#dcfce7' :
                                   activity.operation === 'Soustraction' ? '#dbeafe' :
                                   activity.operation === 'Multiplication' ? '#f3e8ff' : '#fef2f2',
                        color: activity.operation === 'Addition' ? '#166534' :
                               activity.operation === 'Soustraction' ? '#1e40af' :
                               activity.operation === 'Multiplication' ? '#7c3aed' : '#dc2626',
                        padding: '0.25rem 0.75rem',
                        borderRadius: '1rem',
                        fontSize: '0.875rem',
                        fontWeight: '500'
                      }}>
                        {activity.operation}
                      </span>
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#374151', fontWeight: '500' }}>
                      {activity.exercises}
                    </td>
                    <td style={{ padding: '1rem 0.75rem' }}>
                      <span style={{
                        color: activity.accuracy >= 90 ? '#166534' : activity.accuracy >= 80 ? '#f59e0b' : '#dc2626',
                        fontWeight: '600'
                      }}>
                        {activity.accuracy}%
                      </span>
                    </td>
                    <td style={{ padding: '1rem 0.75rem', color: '#6b7280' }}>
                      {activity.time} min
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </div>
  )
}
