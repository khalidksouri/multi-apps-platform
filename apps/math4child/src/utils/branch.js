// Utilitaire pour détecter la branche Git
export function getCurrentBranch() {
  // Essayer différentes méthodes
  
  // 1. Variables d'environnement Netlify/Vercel
  if (process.env.BRANCH_NAME) return process.env.BRANCH_NAME
  if (process.env.VERCEL_GIT_COMMIT_REF) return process.env.VERCEL_GIT_COMMIT_REF
  if (process.env.HEAD) return process.env.HEAD
  
  // 2. Variables d'environnement CI
  if (process.env.GITHUB_REF_NAME) return process.env.GITHUB_REF_NAME
  if (process.env.CI_COMMIT_REF_NAME) return process.env.CI_COMMIT_REF_NAME
  
  // 3. Git command (pour développement local)
  if (typeof window === 'undefined') {
    try {
      const { execSync } = require('child_process')
      return execSync('git branch --show-current', { 
        encoding: 'utf8',
        stdio: 'pipe'
      }).trim()
    } catch (error) {
      console.log('Cannot detect git branch:', error.message)
    }
  }
  
  // 4. Fallback
  return 'main'
}

export function getBranchEnvironment(branch) {
  switch (branch) {
    case 'main':
      return 'production'
    case 'feature/math4child':
      return 'staging'
    default:
      return 'development'
  }
}
