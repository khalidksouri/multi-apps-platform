# 🌐 Guide de Configuration Domaine Math4Child

## Étapes à Suivre

### 1. Acheter le Domaine
- Aller sur OVH, Gandi, ou Namecheap
- Acheter: `math4child.com`

### 2. Configuration DNS
Chez votre registraire, configurer :
```
Type: CNAME
Name: www
Value: prismatic-sherbet-986159.netlify.app

Type: A
Name: @
Value: 75.2.60.5
```

### 3. Configuration Netlify
1. Aller sur: https://app.netlify.com/sites/prismatic-sherbet-986159
2. Domain settings → Add custom domain
3. Ajouter: `www.math4child.com`
4. Ajouter: `math4child.com`

### 4. Validation
- Attendre 5-30 minutes pour la propagation DNS
- SSL automatique via Let's Encrypt
- Tester: https://www.math4child.com

## Support
📧 gotesttech@gmail.com
🏢 GOTEST (SIRET: 53958712100028)
