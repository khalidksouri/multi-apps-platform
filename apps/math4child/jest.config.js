const nextJest = require('next/jest')

const createJestConfig = nextJest({
  dir: './',
})

const customJestConfig = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
  moduleNameMapping: {
    '^@/(.*)# ===================================================================
# 6. PAGES D'EXERCICES DYNAMIQUES
# ===================================================================

print_status "6. Création des pages d'exercices dynamiques"

# Page de sélection de niveaux
cat > src/app/exercises/page.tsx << 'EOF'
import { LevelSelector } from '@/components/exercises/LevelSelector';

export default function ExercisesPage() {
  return <LevelSelector />;
}
