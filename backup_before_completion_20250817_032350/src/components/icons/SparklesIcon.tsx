// Composant de remplacement pour l'icône Sparkles
export default function SparklesIcon({ className }: { className?: string }) {
  return (
    <span className={`inline-block ${className}`} style={{ fontSize: '1.5rem' }}>
      ✨
    </span>
  )
}
