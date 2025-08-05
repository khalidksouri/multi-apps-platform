#!/bin/bash

# 🔄 Script de mise à jour email contact GOTEST
# Remplace khalid_ksouri@yahoo.fr par gotesttech@gmail.com

echo "🔄 Mise à jour de l'email de contact GOTEST..."
echo "Ancien : khalid_ksouri@yahoo.fr"
echo "Nouveau : gotesttech@gmail.com"

# Sauvegarder les fichiers modifiés
BACKUP_DIR="backup_email_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Fonction pour mettre à jour un fichier
update_file() {
    local file="$1"
    if [ -f "$file" ]; then
        echo "📝 Mise à jour: $file"
        # Sauvegarde
        cp "$file" "$BACKUP_DIR/$(basename "$file").bak"
        # Remplacement
        sed -i.tmp 's/khalid_ksouri@yahoo\.fr/gotesttech@gmail.com/g' "$file"
        rm -f "$file.tmp"
        echo "   ✅ Mis à jour"
    else
        echo "   ⚠️  Fichier non trouvé: $file"
    fi
}

# Liste des fichiers à mettre à jour
echo "🔍 Recherche des fichiers à mettre à jour..."

# 1. README.md principal
update_file "README.md"

# 2. Documentation de déploiement mobile
update_file "MOBILE_DEPLOYMENT.md"

# 3. Status de build
update_file "BUILD_STATUS.md"

# 4. Documentation finale de déploiement
update_file "FINAL_DEPLOYMENT_STATUS.md"

# 5. Configuration Stripe
update_file "src/lib/stripe.ts"

# 6. Variables d'environnement
update_file ".env.test"
update_file ".env.example"
update_file ".env.production"

# 7. Configuration Capacitor
update_file "capacitor.config.ts"

# 8. Package.json
update_file "package.json"

# 9. Tests de déploiement
update_file "tests/deployment.spec.ts"

# 10. Configuration du projet
update_file "project.config.json"

# 11. Manifeste PWA
update_file "public/manifest.json"

# 12. Configuration des tests
update_file "playwright.config.ts"

# 13. Documentation de tests
update_file "TESTING_GUIDE.md"

# 14. Fichiers de sauvegarde
find . -name "*.backup*" -type f -exec update_file {} \;

# 15. Recherche automatique dans tous les fichiers
echo "🔍 Recherche automatique dans tous les fichiers du projet..."
grep -r "khalid_ksouri@yahoo.fr" . --include="*.md" --include="*.ts" --include="*.js" --include="*.json" --include="*.tsx" --include="*.jsx" 2>/dev/null | while read -r line; do
    file=$(echo "$line" | cut -d: -f1)
    if [ -f "$file" ] && [ ! -d "$file" ]; then
        update_file "$file"
    fi
done

echo ""
echo "🎯 Résumé de la mise à jour:"
echo "📁 Sauvegarde créée dans: $BACKUP_DIR"
echo "📧 Ancien email: khalid_ksouri@yahoo.fr"
echo "📧 Nouveau email: gotesttech@gmail.com"

# Vérification finale
echo ""
echo "🔍 Vérification finale - Recherche d'occurrences restantes:"
remaining=$(grep -r "khalid_ksouri@yahoo.fr" . --include="*.md" --include="*.ts" --include="*.js" --include="*.json" --include="*.tsx" --include="*.jsx" 2>/dev/null | wc -l)

if [ "$remaining" -gt 0 ]; then
    echo "⚠️  $remaining occurrence(s) restante(s) trouvée(s):"
    grep -r "khalid_ksouri@yahoo.fr" . --include="*.md" --include="*.ts" --include="*.js" --include="*.json" --include="*.tsx" --include="*.jsx" 2>/dev/null | head -10
else
    echo "✅ Toutes les occurrences ont été mises à jour avec succès!"
fi

echo ""
echo "🚀 Mise à jour terminée!"
echo "💡 N'oubliez pas de:"
echo "   1. Vérifier les changements: git diff"
echo "   2. Tester l'application: npm run dev"
echo "   3. Commiter les modifications: git add . && git commit -m 'feat: update contact email to gotesttech@gmail.com'"

# Configuration git pour le commit
cat > update_commit.sh << 'EOF'
#!/bin/bash
echo "📝 Configuration du commit pour la mise à jour email..."
git add .
git status
echo ""
echo "🤖 Voulez-vous commiter automatiquement ? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    git commit -m "feat: update GOTEST contact email to gotesttech@gmail.com

- Replace khalid_ksouri@yahoo.fr with gotesttech@gmail.com across all files
- Update GOTEST configuration
- Update Stripe configuration
- Update mobile deployment documentation
- Update README and build status files"
    echo "✅ Commit créé avec succès!"
else
    echo "📝 Commit annulé. Vous pouvez commiter manuellement plus tard."
fi
EOF

chmod +x update_commit.sh
echo "📝 Script de commit créé: ./update_commit.sh"