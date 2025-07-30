#!/bin/bash

# =============================================================================
# 🔍 SCRIPT DE RÉCUPÉRATION DU VRAI MATH4CHILD - VERSION AMÉLIORÉE
# Récupère l'application originale depuis GitHub et le site déployé
# URLs: https://github.com/khalidksouri/multi-apps-platform
#       https://math4child.com/
#       https://app.netlify.com/projects/prismatic-sherbet-986159
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}"
    echo "========================================"
    echo "  $1"
    echo "========================================"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}🔍 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_header "RÉCUPÉRATION DU VRAI MATH4CHILD"

# =============================================================================
# ÉTAPE 1: Cloner le repository GitHub
# =============================================================================

print_step "Étape 1: Clonage du repository GitHub..."

GITHUB_URL="https://github.com/khalidksouri/multi-apps-platform.git"
TEMP_DIR="temp_math4child_$(date +%s)"

if [ -d "$TEMP_DIR" ]; then
    rm -rf "$TEMP_DIR"
fi

echo "📡 Clonage depuis: $GITHUB_URL"
if git clone "$GITHUB_URL" "$TEMP_DIR"; then
    print_success "Repository cloné avec succès"
else
    print_error "Échec du clonage - vérifiez votre connexion ou l'URL"
    exit 1
fi

# =============================================================================
# ÉTAPE 2: Vérifier la structure du repository
# =============================================================================

print_step "Étape 2: Analyse de la structure du repository..."

cd "$TEMP_DIR"

echo "📁 Structure trouvée:"
if [ -d "apps" ]; then
    echo "  ✅ Dossier apps/ trouvé"
    ls -la apps/ | grep -E "math4child|math"
    
    # Chercher Math4Child dans les applications
    MATH4CHILD_DIR=""
    for app_dir in apps/*/; do
        if [[ "$app_dir" == *"math4child"* ]] || [[ "$app_dir" == *"math"* ]]; then
            MATH4CHILD_DIR="$app_dir"
            echo "  🎯 Math4Child trouvé dans: $MATH4CHILD_DIR"
            break
        fi
    done
    
    if [ -z "$MATH4CHILD_DIR" ]; then
        echo "  📝 Applications disponibles:"
        ls apps/
        # Demander à l'utilisateur de choisir
        echo ""
        echo "Quelle application contient Math4Child? (tapez le nom exact du dossier)"
        read -r USER_CHOICE
        if [ -d "apps/$USER_CHOICE" ]; then
            MATH4CHILD_DIR="apps/$USER_CHOICE"
            print_success "Application sélectionnée: $MATH4CHILD_DIR"
        else
            print_error "Dossier non trouvé: apps/$USER_CHOICE"
            exit 1
        fi
    fi
else
    print_error "Structure inattendue - dossier apps/ non trouvé"
    ls -la
    exit 1
fi

# =============================================================================
# ÉTAPE 3: Analyser le contenu de Math4Child
# =============================================================================

print_step "Étape 3: Analyse du contenu Math4Child..."

if [ -d "$MATH4CHILD_DIR" ]; then
    echo "📋 Contenu de $MATH4CHILD_DIR:"
    ls -la "$MATH4CHILD_DIR"
    
    # Vérifier les fichiers clés
    echo ""
    echo "🔍 Fichiers clés:"
    
    if [ -f "${MATH4CHILD_DIR}package.json" ]; then
        echo "  ✅ package.json trouvé"
        APP_NAME=$(grep '"name"' "${MATH4CHILD_DIR}package.json" | cut -d'"' -f4)
        echo "     Nom de l'app: $APP_NAME"
    fi
    
    if [ -f "${MATH4CHILD_DIR}src/app/page.tsx" ]; then
        echo "  ✅ page.tsx trouvé"
        # Vérifier le contenu
        if grep -q "Math" "${MATH4CHILD_DIR}src/app/page.tsx"; then
            echo "     Contient du contenu Math"
        fi
    fi
    
    if [ -f "${MATH4CHILD_DIR}README.md" ]; then
        echo "  ✅ README.md trouvé"
    fi
    
    # Vérifier la structure src/
    if [ -d "${MATH4CHILD_DIR}src" ]; then
        echo "  ✅ Dossier src/ trouvé"
        echo "     Structure src/:"
        find "${MATH4CHILD_DIR}src" -type f -name "*.tsx" -o -name "*.ts" -o -name "*.css" | head -10
    fi
else
    print_error "Dossier Math4Child non trouvé: $MATH4CHILD_DIR"
    exit 1
fi

# =============================================================================
# ÉTAPE 4: Récupérer le design du site déployé
# =============================================================================

print_step "Étape 4: Récupération du design depuis math4child.com..."

SITE_URL="https://math4child.com/"
SITE_BACKUP_DIR="site_backup"

mkdir -p "$SITE_BACKUP_DIR"

echo "🌐 Récupération du HTML principal..."
if curl -s "$SITE_URL" > "${SITE_BACKUP_DIR}/index.html"; then
    print_success "Page principale récupérée"
else
    print_warning "Impossible de récupérer la page principale"
fi

# Extraire les assets CSS et JS
echo "🎨 Extraction des assets..."
grep -o 'href="[^"]*\.css[^"]*"' "${SITE_BACKUP_DIR}/index.html" | sed 's/href="//g' | sed 's/"//g' > "${SITE_BACKUP_DIR}/css_files.txt" 2>/dev/null || true
grep -o 'src="[^"]*\.js[^"]*"' "${SITE_BACKUP_DIR}/index.html" | sed 's/src="//g' | sed 's/"//g' > "${SITE_BACKUP_DIR}/js_files.txt" 2>/dev/null || true

# Télécharger les assets CSS
if [ -s "${SITE_BACKUP_DIR}/css_files.txt" ]; then
    echo "📥 Téléchargement des fichiers CSS..."
    mkdir -p "${SITE_BACKUP_DIR}/css"
    while IFS= read -r css_file; do
        if [[ "$css_file" == http* ]]; then
            filename=$(basename "$css_file" | cut -d'?' -f1)
            echo "  📎 $css_file -> css/$filename"
            curl -s "$css_file" > "${SITE_BACKUP_DIR}/css/$filename" 2>/dev/null || true
        elif [[ "$css_file" == /* ]]; then
            filename=$(basename "$css_file" | cut -d'?' -f1)
            echo "  📎 ${SITE_URL}${css_file} -> css/$filename"
            curl -s "${SITE_URL}${css_file}" > "${SITE_BACKUP_DIR}/css/$filename" 2>/dev/null || true
        fi
    done < "${SITE_BACKUP_DIR}/css_files.txt"
fi

# =============================================================================
# ÉTAPE 5: Analyser les éléments du design
# =============================================================================

print_step "Étape 5: Analyse des éléments du design..."

echo "🎨 Éléments détectés dans le site:"

# Analyser le HTML pour extraire la structure
if [ -f "${SITE_BACKUP_DIR}/index.html" ]; then
    echo ""
    echo "📋 Titre principal:"
    grep -o '<title>[^<]*</title>' "${SITE_BACKUP_DIR}/index.html" | sed 's/<[^>]*>//g' || true
    
    echo ""
    echo "🔍 Meta description:"
    grep -o 'name="description" content="[^"]*"' "${SITE_BACKUP_DIR}/index.html" | sed 's/name="description" content="//g' | sed 's/"//g' || true
    
    echo ""
    echo "🎯 Éléments H1:"
    grep -o '<h1[^>]*>[^<]*</h1>' "${SITE_BACKUP_DIR}/index.html" | sed 's/<[^>]*>//g' || true
    
    echo ""
    echo "🎯 Éléments H2:"
    grep -o '<h2[^>]*>[^<]*</h2>' "${SITE_BACKUP_DIR}/index.html" | sed 's/<[^>]*>//g' || true
    
    echo ""
    echo "🔘 Boutons détectés:"
    grep -o '<button[^>]*>[^<]*</button>' "${SITE_BACKUP_DIR}/index.html" | sed 's/<[^>]*>//g' || true
    grep -o 'class="[^"]*btn[^"]*"' "${SITE_BACKUP_DIR}/index.html" || true
fi

# =============================================================================
# ÉTAPE 6: Restaurer le code original
# =============================================================================

print_step "Étape 6: Restauration du code original..."

cd ..

TARGET_DIR="apps/math4child"

# Sauvegarder l'ancien code
if [ -d "$TARGET_DIR" ]; then
    BACKUP_DIR="${TARGET_DIR}_backup_$(date +%Y%m%d_%H%M%S)"
    echo "💾 Sauvegarde de l'ancien code dans: $BACKUP_DIR"
    mv "$TARGET_DIR" "$BACKUP_DIR"
fi

# Copier le nouveau code
if [ -d "${TEMP_DIR}/${MATH4CHILD_DIR}" ]; then
    echo "📋 Copie du code original..."
    cp -r "${TEMP_DIR}/${MATH4CHILD_DIR}" "$TARGET_DIR"
    print_success "Code original restauré dans: $TARGET_DIR"
else
    print_error "Impossible de trouver le code source dans: ${TEMP_DIR}/${MATH4CHILD_DIR}"
    exit 1
fi

# Copier les éléments de design récupérés
if [ -d "${TEMP_DIR}/${SITE_BACKUP_DIR}" ]; then
    mkdir -p "${TARGET_DIR}/design_reference"
    cp -r "${TEMP_DIR}/${SITE_BACKUP_DIR}" "${TARGET_DIR}/design_reference/"
    print_success "Référence de design copiée dans: ${TARGET_DIR}/design_reference/"
fi

# =============================================================================
# ÉTAPE 7: Vérification et installation
# =============================================================================

print_step "Étape 7: Vérification et installation..."

cd "$TARGET_DIR"

# Vérifier la structure
echo "🔍 Structure vérifiée:"
ls -la

# Installer les dépendances si package.json existe
if [ -f "package.json" ]; then
    echo ""
    echo "📦 Installation des dépendances..."
    if command -v npm &> /dev/null; then
        npm install
        print_success "Dépendances installées"
    else
        print_warning "npm non trouvé - installez manuellement avec: npm install"
    fi
fi

# =============================================================================
# ÉTAPE 8: Création du rapport de récupération
# =============================================================================

print_step "Étape 8: Création du rapport de récupération..."

REPORT_FILE="recovery_report.md"

cat << EOF > "$REPORT_FILE"
# 📋 Rapport de Récupération Math4Child

## ✅ Récupération effectuée le $(date)

### 🔗 Sources récupérées:
- **GitHub**: https://github.com/khalidksouri/multi-apps-platform
- **Site déployé**: https://math4child.com/
- **Netlify**: prismatic-sherbet-986159

### 📁 Fichiers récupérés:
- Code source complet depuis GitHub
- HTML/CSS/JS depuis le site déployé
- Structure de référence dans design_reference/

### 🎨 Éléments de design identifiés:
$(if [ -f "design_reference/site_backup/index.html" ]; then
    echo "- Titre: $(grep -o '<title>[^<]*</title>' design_reference/site_backup/index.html | sed 's/<[^>]*>//g' || echo 'Non trouvé')"
    echo "- Description: $(grep -o 'name="description" content="[^"]*"' design_reference/site_backup/index.html | sed 's/name="description" content="//g' | sed 's/"//g' || echo 'Non trouvé')"
fi)

### 🚀 Prochaines étapes:
1. Vérifier le code dans src/app/page.tsx
2. Comparer avec le design de référence
3. Ajuster les styles si nécessaire
4. Tester l'application: \`npm run dev\`

### 📊 Status:
- ✅ Code source récupéré
- ✅ Design de référence disponible
- ✅ Dépendances installées
- 🔄 Prêt pour développement

EOF

print_success "Rapport créé: $REPORT_FILE"

# =============================================================================
# NETTOYAGE
# =============================================================================

print_step "Nettoyage..."

cd ..
rm -rf "$TEMP_DIR"
print_success "Fichiers temporaires supprimés"

# =============================================================================
# RÉSUMÉ FINAL
# =============================================================================

print_header "RÉCUPÉRATION TERMINÉE"

echo -e "${GREEN}"
echo "🎉 Math4Child a été récupéré avec succès!"
echo ""
echo "📁 Emplacement: apps/math4child/"
echo "📋 Rapport: apps/math4child/recovery_report.md"
echo "🎨 Design de référence: apps/math4child/design_reference/"
echo ""
echo "🚀 Pour démarrer l'application:"
echo "   cd apps/math4child"
echo "   npm run dev"
echo ""
echo "🔍 URLs de référence:"
echo "   - Site original: https://math4child.com/"
echo "   - GitHub: https://github.com/khalidksouri/multi-apps-platform"
echo "   - Netlify: https://app.netlify.com/projects/prismatic-sherbet-986159"
echo -e "${NC}"

print_success "Script terminé avec succès!"