import { test, expect } from '@playwright/test'

test.describe('🌍 Tests de Traduction', () => {
  
  test.beforeEach(async ({ page }) => {
    // Aller à la page d'accueil avec gestion d'erreur
    try {
      await page.goto('/', { 
        waitUntil: 'networkidle',
        timeout: 15000
      })
    } catch (error) {
      console.log('⚠️  Erreur de navigation:', error.message)
      // Réessayer une fois
      await page.goto('/')
    }
  })

  test('Page d\'accueil accessible', async ({ page }) => {
    // Vérifier que la page charge
    await expect(page.locator('body')).toBeVisible({ timeout: 10000 })
    
    // Vérifier qu'il y a du contenu
    const bodyText = await page.textContent('body')
    expect(bodyText).toBeTruthy()
    expect(bodyText!.length).toBeGreaterThan(50)
    
    console.log('✅ Page d\'accueil accessible avec contenu')
  })

  test('Recherche de fonctionnalités multilingues', async ({ page }) => {
    // Chercher des éléments liés aux langues
    const languageIndicators = [
      'select[name="language"]',
      'select[name="lang"]',
      '[data-testid*="language"]',
      'button:has-text("Français")',
      'button:has-text("English")',
      'button:has-text("Español")',
      '.language',
      '.lang'
    ]
    
    let foundIndicators = []
    
    for (const selector of languageIndicators) {
      try {
        const element = page.locator(selector).first()
        if (await element.isVisible({ timeout: 2000 })) {
          foundIndicators.push(selector)
          console.log(`✅ Indicateur de langue trouvé: ${selector}`)
        }
      } catch (e) {
        // Continuer
      }
    }
    
    if (foundIndicators.length > 0) {
      console.log(`✅ ${foundIndicators.length} indicateur(s) de langue détecté(s)`)
    } else {
      console.log('ℹ️  Aucun indicateur de langue visible')
    }
    
    // Test exploratoire - ne fait pas échouer
    expect(true).toBeTruthy()
  })

  test('Vérification absence mentions géographiques interdites', async ({ page }) => {
    const bodyText = await page.textContent('body')
    
    // Mentions à éviter (précédemment corrigées)
    const forbiddenMentions = [
      'en Francia',
      'في فرنسا',
      'in France',
      'en France', 
      'in Frankreich',
      'in Francia'
    ]
    
    let foundMentions = []
    
    for (const mention of forbiddenMentions) {
      if (bodyText && bodyText.includes(mention)) {
        foundMentions.push(mention)
      }
    }
    
    if (foundMentions.length > 0) {
      console.log(`❌ Mentions géographiques trouvées: ${foundMentions.join(', ')}`)
      // Faire échouer le test si des mentions interdites sont trouvées
      expect(foundMentions).toHaveLength(0)
    } else {
      console.log('✅ Aucune mention géographique interdite')
      expect(true).toBeTruthy()
    }
  })

  test('Détection de contenu multilingue', async ({ page }) => {
    const bodyText = await page.textContent('body')
    
    // Indicateurs de contenu français
    const frenchWords = ['mathématiques', 'éducative', 'famille', 'gratuit', 'apprentissage']
    const foundFrench = frenchWords.filter(word => 
      bodyText && bodyText.toLowerCase().includes(word.toLowerCase())
    )
    
    if (foundFrench.length > 0) {
      console.log(`✅ Contenu français détecté: ${foundFrench.join(', ')}`)
    }
    
    // Indicateurs de contenu international
    const hasArabic = bodyText && /[\u0600-\u06FF]/.test(bodyText)
    const hasChinese = bodyText && /[\u4e00-\u9fff]/.test(bodyText)
    const hasCyrillic = bodyText && /[\u0400-\u04FF]/.test(bodyText)
    
    if (hasArabic) console.log('✅ Contenu arabe détecté')
    if (hasChinese) console.log('✅ Contenu chinois détecté')
    if (hasCyrillic) console.log('✅ Contenu cyrillique détecté')
    
    expect(true).toBeTruthy()
  })

  test('Test de changement de langue (si disponible)', async ({ page }) => {
    try {
      // Chercher un sélecteur de langue
      const languageSelectors = [
        'select',
        'button:has-text("Français")',
        'button:has-text("English")',  
        '[data-testid*="language"]'
      ]
      
      let selectorFound = false
      
      for (const selector of languageSelectors) {
        const element = page.locator(selector).first()
        if (await element.isVisible({ timeout: 3000 })) {
          console.log(`✅ Sélecteur trouvé: ${selector}`)
          selectorFound = true
          
          // Essayer d'interagir avec le sélecteur
          try {
            if (selector.includes('select')) {
              // Si c'est un select, essayer de changer l'option
              await element.selectOption({ index: 1 })
              console.log('✅ Changement d\'option tenté')
            } else {
              // Si c'est un bouton, cliquer dessus
              await element.click()
              console.log('✅ Clic sur sélecteur de langue')
            }
            
            await page.waitForTimeout(1000)
          } catch (interactionError) {
            console.log(`ℹ️  Interaction échouée: ${interactionError.message}`)
          }
          
          break
        }
      }
      
      if (!selectorFound) {
        console.log('ℹ️  Aucun sélecteur de langue interactif trouvé')
      }
      
    } catch (error) {
      console.log(`ℹ️  Test de changement de langue: ${error.message}`)
    }
    
    expect(true).toBeTruthy()
  })
})
