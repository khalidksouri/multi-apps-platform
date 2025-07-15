const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage();
  
  console.log('🔍 Debug UnitFlip...');
  await page.goto('http://localhost:3002');
  
  const title = await page.title();
  console.log(`📋 Titre: "${title}"`);
  
  const bodyText = await page.textContent('body');
  console.log(`📄 Contenu (premiers 300 caractères):`);
  console.log(`"${bodyText.substring(0, 300)}..."`);
  
  // Rechercher des mots-clés spécifiques
  const keywords = ['UnitFlip', 'Convertisseur', 'Conversion', 'Unités', 'Longueur', 'Poids'];
  keywords.forEach(keyword => {
    const found = bodyText.includes(keyword);
    console.log(`🔍 "${keyword}": ${found ? '✅ TROUVÉ' : '❌ PAS TROUVÉ'}`);
  });
  
  await browser.close();
})();
