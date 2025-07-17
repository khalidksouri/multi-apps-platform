# 🚀 Scripts de Gestion Multi-Apps Platform

## 📋 Scripts disponibles

### 🚀 `./start-apps.sh`
Démarre toutes les applications du multi-apps-platform
- Vérifie les prérequis (Node.js, npm, workspace)
- Démarre les 5 applications sur leurs ports respectifs
- Gère les conflits de ports
- Affiche les URLs d'accès

### 🛑 `./stop-apps.sh`
Arrête toutes les applications en cours
- Arrêt propre via fichiers PID
- Nettoyage des ports occupés
- Suppression des fichiers temporaires
- Vérification de l'arrêt complet

### 📊 `./status-apps.sh`
Affiche le statut détaillé de toutes les applications
- État des processus
- Utilisation des ports
- Test de connectivité HTTP
- Vérification des dépendances
- Analyse des logs

## 🌐 Applications et Ports

| Application | Port | URL | Technology |
|-------------|------|-----|------------|
| Math4Kids   | 3001 | http://localhost:3001 | React + TypeScript |
| UnitFlip    | 3002 | http://localhost:3002 | React + TypeScript |
| BudgetCron  | 3003 | http://localhost:3003 | Vue.js + TypeScript |
| AI4Kids     | 3004 | http://localhost:3004 | React + TypeScript |
| MultiAI     | 3005 | http://localhost:3005 | Next.js + TypeScript |

## 📝 Logs et Diagnostic

### Localisation des logs
```bash
/Users/khalidksouri/global-multi-apps-workspace/logs/
├── startup.log          # Log global de démarrage
├── math4kids.log        # Logs de Math4Kids
├── unitflip.log         # Logs de UnitFlip
├── budgetcron.log       # Logs de BudgetCron
├── ai4kids.log          # Logs de AI4Kids
├── multiai.log          # Logs de MultiAI
├── math4kids.pid        # PID de Math4Kids
├── unitflip.pid         # PID de UnitFlip
├── budgetcron.pid       # PID de BudgetCron
├── ai4kids.pid          # PID de AI4Kids
└── multiai.pid          # PID de MultiAI
```

### Diagnostic des problèmes
```bash
# Voir les logs en temps réel
tail -f /Users/khalidksouri/global-multi-apps-workspace/logs/math4kids.log

# Vérifier tous les logs d'erreurs
grep -i error /Users/khalidksouri/global-multi-apps-workspace/logs/*.log

# Voir les processus Node.js actifs
ps aux | grep node

# Vérifier les ports utilisés
lsof -i :3001-3005
```

## 🔧 Résolution de Problèmes

### Port déjà utilisé
```bash
# Identifier le processus sur un port
lsof -ti:3001

# Arrêter le processus
kill -9 $(lsof -ti:3001)
```

### Application ne démarre pas
```bash
# Vérifier les dépendances
cd /Users/khalidksouri/global-multi-apps-workspace/math4kids
npm install

# Tester le démarrage manuel
npm start
```

### Nettoyage complet
```bash
# Arrêt brutal de tous les processus
./stop-apps.sh

# Nettoyage des ports
for port in 3001 3002 3003 3004 3005; do
  kill -9 $(lsof -ti:$port) 2>/dev/null || true
done

# Redémarrage propre
./start-apps.sh
```

## 📚 Workflow Recommandé

### Développement quotidien
```bash
# 1. Vérifier le statut
./status-apps.sh

# 2. Démarrer si nécessaire
./start-apps.sh

# 3. Développer...

# 4. Arrêter en fin de journée
./stop-apps.sh
```

### En cas de problème
```bash
# 1. Statut détaillé
./status-apps.sh

# 2. Arrêt complet
./stop-apps.sh

# 3. Vérification des logs
ls -la /Users/khalidksouri/global-multi-apps-workspace/logs/

# 4. Redémarrage
./start-apps.sh
```

## ⚡ Tips & Astuces

### Raccourcis utiles
```bash
# Alias recommandés pour ~/.zshrc ou ~/.bashrc
alias mstart='./start-apps.sh'
alias mstop='./stop-apps.sh'
alias mstatus='./status-apps.sh'

# Variables d'environnement utiles
export MULTI_APPS_WORKSPACE="/Users/khalidksouri/global-multi-apps-workspace"
export MULTI_APPS_LOGS="$MULTI_APPS_WORKSPACE/logs"
```

### Surveillance automatique
```bash
# Surveiller tous les logs
watch -n 2 './status-apps.sh | tail -n 20'

# Alerte si une app s'arrête
while true; do
  if ! ./status-apps.sh | grep -q "5/5"; then
    echo "⚠️ Une application s'est arrêtée!"
  fi
  sleep 30
done
```

## 🆘 Support

En cas de problème persistant :
1. Vérifiez les logs dans `/Users/khalidksouri/global-multi-apps-workspace/logs/`
2. Exécutez `./status-apps.sh` pour un diagnostic complet
3. Consultez la documentation des frameworks (React, Vue.js, Next.js)
4. Vérifiez que Node.js et npm sont à jour

---
*Dernière mise à jour: $(date)*
