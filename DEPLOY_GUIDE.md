# 🚀 Guide Configuration Vercel pour math4child.com

## 1. Créer le projet Vercel

### Option A: Interface Web (Recommandée)
1. Aller sur https://vercel.com
2. Se connecter avec GitHub
3. "New Project" → Sélectionner "multi-apps-platform"  
4. **Root Directory**: `apps/math4child`
5. **Framework Preset**: Next.js (auto-détecté)
6. **Build Command**: `npm run build`  
7. **Output Directory**: `.next`
8. Deploy

### Option B: CLI
```bash
cd apps/math4child
npx vercel
# Suivre les instructions
```

## 2. Configurer le domaine personnalisé

Dans Vercel Dashboard:
1. Project Settings → Domains
2. Add `math4child.com`
3. Add `www.math4child.com`

## 3. Configuration DNS

Chez votre registraire (GoDaddy, OVH, etc.):
```
Type: A
Name: @  
Value: 76.76.19.61

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

## 4. Récupérer les identifiants pour GitHub

### Token Vercel:
1. Vercel Dashboard → Account Settings → Tokens
2. Create Token → Nom: "Math4Child GitHub Actions"
3. Copier le token

### Project ID et Org ID:
```bash
cd apps/math4child
cat .vercel/project.json
```

## 5. Configurer les secrets GitHub

Dans GitHub: Settings → Secrets and variables → Actions

Ajouter:
- `VERCEL_TOKEN`: Votre token Vercel
- `VERCEL_PROJECT_ID`: ID du projet (prj_...)  
- `VERCEL_ORG_ID`: ID organisation/team

## 6. Déployer

```bash
git add .
git commit -m "deploy: Math4Child to production"  
git push origin main
```

🎉 Math4Child sera disponible sur https://math4child.com !
