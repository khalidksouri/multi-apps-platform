const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  console.log('🔍 Debug UnitFlip détaillé...');
  await page.goto('http://localhost:3002');
  await page.waitForLoadState('networkidle');
  
  const title = await page.title();
  console.log(`📋 Titre: "${title}"`);
  
  // Obtenir TOUT le texte de la page
  const bodyText = await page.textContent('body');
  console.log(`📄 Contenu complet de la page:`);
  console.log(`"${bodyText}"`);
  
  // Rechercher le mot "Conversion" spécifiquement
  const hasConversion = bodyText.includes('Conversion');
  console.log(`🔍 "Conversion" trouvé: ${hasConversion}`);
  
  if (hasConversion) {
    // Trouver l'index du mot
    const index = bodyText.indexOf('Conversion');
    console.log(`📍 Position de "Conversion": ${index}`);
    console.log(`📝 Contexte: "${bodyText.substring(index-20, index+20)}"`);
  }
  
  // Vérifier si c'est peut-être dans le titre ou ailleurs
  console.log(`🔍 Titre contient "Conversion": ${title.includes('Conversion')}`);
  
  await browser.close();
})();
