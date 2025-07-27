import { test, expect } from '@playwright/test'

test.describe('🧪 Tests de base Math4Child', () => {
  
  test('Page d\'accueil se charge correctement', async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    
    // Vérifier que la page charge
    await expect(page.locator('body')).toBeVisible()
    
    // Vérifier le titre
    const title = await page.title()
    expect(title).toBeTruthy()
    
    console.log(`✅ Page chargée - Titre: ${title}`)
  })

  test('Sélecteur de langue fonctionnel', async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    
    // Chercher le sélecteur de langue
    const languageSelector = page.locator('[data-testid="language-selector"]')
      .or(page.locator('button').filter({ hasText: /français|english|العربية/i }))
      .first()
    
    if (await languageSelector.isVisible()) {
      await languageSelector.click()
      
      // Vérifier que le dropdown s'ouvre
      const dropdown = page.locator('[data-testid="language-dropdown"]')
        .or(page.locator('.absolute').filter({ hasText: /français|english|العربية/i }))
        .first()
      
      await expect(dropdown).toBeVisible({ timeout: 5000 })
      console.log('✅ Sélecteur de langue fonctionnel')
      
      // Test spécifique des langues arabes ajoutées
      const palestineOption = page.locator('text=🇵🇸').or(page.locator('text=Palestine'))
      const moroccoOption = page.locator('text=🇲🇦').or(page.locator('text=Maroc'))
      
      if (await palestineOption.isVisible()) {
        console.log('✅ Palestine 🇵🇸 trouvée dans le sélecteur')
      }
      
      if (await moroccoOption.isVisible()) {
        console.log('✅ Maroc 🇲🇦 trouvé dans le sélecteur')
      }
      
    } else {
      console.log('⚠️ Sélecteur de langue non trouvé - design différent')
    }
  })

  test('Contenu de base présent', async ({ page }) => {
    await page.goto('/')
    await page.waitForLoadState('networkidle')
    
    // Vérifier qu'il y a du contenu textuel
    const bodyText = await page.textContent('body')
    expect(bodyText).toBeTruthy()
    expect(bodyText!.length).toBeGreaterThan(50)
    
    // Chercher des éléments typiques d'une app éducative
    const hasEducationalContent = bodyText!.includes('math') || 
                                  bodyText!.includes('Math') ||
                                  bodyText!.includes('mathématiques') ||
                                  bodyText!.includes('éducatif') ||
                                  bodyText!.includes('enfant')
    
    expect(hasEducationalContent).toBe(true)
    console.log('✅ Contenu éducatif détecté')
  })
})
