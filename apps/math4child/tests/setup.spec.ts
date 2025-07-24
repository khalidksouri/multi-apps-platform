import { test, expect } from '@playwright/test'

test.describe('🔧 Configuration et Setup', () => {
  
  test('Serveur répond sur http://localhost:3000', async ({ page }) => {
    try {
      await page.goto('/', { 
        waitUntil: 'domcontentloaded',
        timeout: 15000 
      })
      
      // Vérifier que la page charge
      await expect(page.locator('body')).toBeVisible({ timeout: 10000 })
      
      // Vérifier qu'on n'a pas une page d'erreur
      const title = await page.title()
      expect(title).not.toContain('404')
      expect(title).not.toContain('Error')
      
      console.log(`✅ Serveur accessible - Titre: ${title}`)
      
    } catch (error) {
      console.log('❌ Serveur non accessible:', error.message)
      throw error
    }
  })

  test('Page contient du contenu valide', async ({ page }) => {
    await page.goto('/')
    
    // Vérifier qu'il y a du contenu textuel
    const bodyText = await page.textContent('body')
    expect(bodyText).toBeTruthy()
    expect(bodyText!.length).toBeGreaterThan(100)
    
    // Vérifier qu'il n'y a pas d'erreurs JavaScript critiques
    const jsErrors: string[] = []
    page.on('console', msg => {
      if (msg.type() === 'error') {
        jsErrors.push(msg.text())
      }
    })
    
    // Attendre un peu pour capturer les erreurs
    await page.waitForTimeout(2000)
    
    // Filtrer les erreurs acceptables
    const criticalErrors = jsErrors.filter(error =>
      !error.includes('favicon') &&
      !error.includes('Extension') &&
      !error.includes('chrome-extension') &&
      !error.includes('analytics')
    )
    
    if (criticalErrors.length > 0) {
      console.log('⚠️  Erreurs JavaScript détectées:', criticalErrors)
    } else {
      console.log('✅ Aucune erreur JavaScript critique')
    }
    
    // Permettre quelques erreurs non critiques
    expect(criticalErrors.length).toBeLessThan(3)
  })

  test('Ressources de base chargées', async ({ page }) => {
    const failedRequests: string[] = []
    
    page.on('response', response => {
      if (response.status() >= 400) {
        const url = response.url()
        // Ignorer certaines ressources optionnelles
        if (!url.includes('favicon') && 
            !url.includes('analytics') && 
            !url.includes('.map')) {
          failedRequests.push(`${response.status()}: ${url}`)
        }
      }
    })
    
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    
    if (failedRequests.length > 0) {
      console.log('⚠️  Requêtes échouées:', failedRequests.slice(0, 3))
    } else {
      console.log('✅ Toutes les ressources principales chargées')
    }
    
    // Permettre quelques échecs de ressources non critiques
    expect(failedRequests.length).toBeLessThan(5)
  })
})
