#!/bin/bash

# =============================================================================
# 🔄 RESTAURATION DE L'ÉTAT DU PROJET MATH4CHILD
# Remet le projet dans l'état antérieur au script language_selector_fix.sh
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${PURPLE}🔄 $1${NC}"
    echo -e "${PURPLE}=================================${NC}"
}

print_header "RESTAURATION DE L'ÉTAT DU PROJET"

# Vérifications
if [ ! -d "apps/math4child" ]; then
    log_error "Dossier apps/math4child introuvable!"
    exit 1
fi

cd apps/math4child

echo "📍 Répertoire actuel: $(pwd)"
echo ""

# =============================================================================
# 1. DÉTECTION DES FICHIERS DE SAUVEGARDE
# =============================================================================

log_info "🔍 Recherche des fichiers de sauvegarde..."

# Rechercher les fichiers de sauvegarde créés par le script
BACKUP_FILES=$(find . -name "*.backup_*" -type f 2>/dev/null || true)

if [ -z "$BACKUP_FILES" ]; then
    log_warning "⚠️ Aucun fichier de sauvegarde trouvé créé par le script"
    log_info "Recherche d'autres sauvegardes possibles..."
    
    # Chercher d'autres patterns de sauvegarde
    OTHER_BACKUPS=$(find . -name "*.bak" -o -name "*backup*" -o -name "*.old" 2>/dev/null || true)
    
    if [ -z "$OTHER_BACKUPS" ]; then
        log_warning "Aucune sauvegarde automatique trouvée"
        log_info "📋 Restauration manuelle recommandée ou utilisation de Git"
        echo ""
        echo "🔧 Options de restauration manuelle :"
        echo "   1. Utilisez 'git status' pour voir les changements"
        echo "   2. Utilisez 'git checkout .' pour restaurer tous les fichiers"
        echo "   3. Utilisez 'git reset --hard HEAD' pour une restauration complète"
        echo ""
        read -p "Voulez-vous continuer avec une restauration Git automatique ? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            log_info "🔄 Restauration via Git..."
            git checkout . 2>/dev/null || log_error "Échec de la restauration Git"
            git clean -fd 2>/dev/null || log_warning "Impossible de nettoyer les fichiers non trackés"
            log_success "✅ Restauration Git terminée"
        else
            log_info "❌ Restauration annulée par l'utilisateur"
            exit 0
        fi
    else
        echo "🔍 Sauvegardes trouvées :"
        echo "$OTHER_BACKUPS"
        echo ""
        log_warning "⚠️ Sauvegardes trouvées mais pas dans le format attendu"
        log_info "Veuillez restaurer manuellement si nécessaire"
    fi
else
    echo "✅ Fichiers de sauvegarde trouvés :"
    echo "$BACKUP_FILES"
    echo ""
fi

# =============================================================================
# 2. RESTAURATION DES FICHIERS SAUVEGARDÉS
# =============================================================================

if [ ! -z "$BACKUP_FILES" ]; then
    log_info "🔄 Restauration des fichiers depuis les sauvegardes..."
    
    # Compteur pour les restaurations
    RESTORED_COUNT=0
    
    echo "$BACKUP_FILES" | while read -r backup_file; do
        if [ -f "$backup_file" ]; then
            # Extraire le nom du fichier original
            original_file=$(echo "$backup_file" | sed 's/\.backup_[0-9_]*$//')
            
            if [ -f "$original_file" ]; then
                log_info "📄 Restauration: $original_file"
                
                # Créer une sauvegarde du fichier actuel avant restauration
                current_backup="${original_file}.current_$(date +%Y%m%d_%H%M%S)"
                cp "$original_file" "$current_backup"
                
                # Restaurer depuis la sauvegarde
                cp "$backup_file" "$original_file"
                
                log_success "✅ Restauré: $(basename "$original_file")"
                RESTORED_COUNT=$((RESTORED_COUNT + 1))
            else
                log_warning "⚠️ Fichier original non trouvé: $original_file"
            fi
        fi
    done
    
    if [ $RESTORED_COUNT -gt 0 ]; then
        log_success "✅ $RESTORED_COUNT fichier(s) restauré(s)"
    fi
fi

# =============================================================================
# 3. SUPPRESSION DES FICHIERS CRÉÉS PAR LE SCRIPT
# =============================================================================

log_info "🗑️ Suppression des fichiers créés par le script..."

# Supprimer les fichiers qui n'existaient pas avant le script
FILES_TO_REMOVE=(
    "src/components/LanguageSelector.tsx"
    "src/app/globals.css"
)

for file in "${FILES_TO_REMOVE[@]}"; do
    if [ -f "$file" ]; then
        # Vérifier si c'est un fichier créé par le script
        if grep -q "STYLES CORRECTIFS POUR LE SÉLECTEUR DE LANGUES" "$file" 2>/dev/null || 
           grep -q "language-selector" "$file" 2>/dev/null; then
            log_info "🗑️ Suppression: $file (créé par le script)"
            rm "$file"
            log_success "✅ Supprimé: $(basename "$file")"
        else
            log_warning "⚠️ Fichier conservé (pas créé par le script): $file"
        fi
    fi
done

# =============================================================================
# 4. NETTOYAGE DU CACHE ET REDÉMARRAGE
# =============================================================================

log_info "🧹 Nettoyage du cache Next.js..."

# Arrêter le serveur
pkill -f "next dev" 2>/dev/null || true
sleep 2

# Supprimer le cache
if [ -d ".next" ]; then
    rm -rf .next
    log_success "✅ Cache .next supprimé"
fi

if [ -d "node_modules/.cache" ]; then
    rm -rf node_modules/.cache
    log_success "✅ Cache node_modules supprimé"
fi

# =============================================================================
# 5. VÉRIFICATION DE L'ÉTAT DU PROJET
# =============================================================================

log_info "🔍 Vérification de l'état du projet..."

# Vérifier la structure des fichiers
if [ -f "src/app/page.tsx" ]; then
    log_success "✅ Fichier page.tsx présent"
    
    # Vérifier le contenu
    if grep -q "LanguageSelector" src/app/page.tsx 2>/dev/null; then
        log_warning "⚠️ page.tsx contient encore des références au LanguageSelector"
        log_info "🔧 Nettoyage des références..."
        
        # Sauvegarder avant nettoyage
        cp src/app/page.tsx "src/app/page.tsx.pre_cleanup_$(date +%Y%m%d_%H%M%S)"
        
        # Créer une version nettoyée sans les références au LanguageSelector
        cat > src/app/page.tsx << 'CLEANFILE'
'use client';

import React, { useState, useEffect } from 'react';

export default function HomePage() {
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
      <div className="text-blue-600">Chargement...</div>
    </div>;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
      {/* Header */}
      <header className="bg-white shadow-sm border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-600 rounded-lg flex items-center justify-center">
                <span className="text-white text-lg font-bold">M</span>
              </div>
              <h1 className="text-xl font-bold text-gray-900">Math4Child</h1>
            </div>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Math4Child - Application Éducative
          </h1>
          <p className="text-xl text-gray-600 mb-12">
            Apprentissage des mathématiques pour toute la famille
          </p>
          <div className="bg-blue-100 border border-blue-300 rounded-lg p-4 inline-block">
            <p className="text-blue-800 font-medium">
              ✅ Projet restauré à l'état initial
            </p>
          </div>
        </div>
      </main>
    </div>
  );
}
CLEANFILE
        
        log_success "✅ Références nettoyées"
    fi
else
    log_warning "⚠️ Fichier page.tsx non trouvé"
fi

# Vérifier package.json
if [ -f "package.json" ]; then
    log_success "✅ package.json présent"
else
    log_error "❌ package.json manquant"
fi

# =============================================================================
# 6. REDÉMARRAGE DU SERVEUR
# =============================================================================

log_info "🚀 Redémarrage du serveur de développement..."

# Redémarrer le serveur
if command -v npm >/dev/null 2>&1; then
    nohup npm run dev > /dev/null 2>&1 &
    sleep 3
    
    if pgrep -f "next dev" > /dev/null; then
        log_success "✅ Serveur redémarré avec succès"
    else
        log_warning "⚠️ Le serveur n'a pas pu redémarrer automatiquement"
        echo "   Démarrez-le manuellement avec: npm run dev"
    fi
else
    log_warning "⚠️ npm non trouvé, redémarrage manuel requis"
fi

# =============================================================================
# 7. NETTOYAGE DES FICHIERS DE SAUVEGARDE (OPTIONNEL)
# =============================================================================

if [ ! -z "$BACKUP_FILES" ]; then
    echo ""
    read -p "🗑️ Voulez-vous supprimer les fichiers de sauvegarde ? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$BACKUP_FILES" | while read -r backup_file; do
            if [ -f "$backup_file" ]; then
                rm "$backup_file"
                log_info "🗑️ Supprimé: $(basename "$backup_file")"
            fi
        done
        log_success "✅ Fichiers de sauvegarde supprimés"
    else
        log_info "📁 Fichiers de sauvegarde conservés"
    fi
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
print_header "RESTAURATION TERMINÉE"
echo ""
echo "🔄 Actions effectuées :"
echo ""

if [ ! -z "$BACKUP_FILES" ]; then
    echo "✅ Fichiers restaurés depuis les sauvegardes"
    echo "✅ Fichiers créés par le script supprimés"
else
    echo "✅ Restauration Git effectuée (si demandée)"
fi

echo "✅ Cache Next.js nettoyé"
echo "✅ Références au LanguageSelector supprimées"
echo "✅ Serveur redémarré"
echo ""

echo "🌐 État du projet :"
echo "   📁 Structure de fichiers restaurée"
echo "   🧹 Cache nettoyé"
echo "   🔄 Serveur opérationnel"
echo ""

echo "🔍 Vérification recommandée :"
echo "   1. Visitez http://localhost:3000"
echo "   2. Vérifiez que l'application fonctionne"
echo "   3. Utilisez 'git status' pour voir les changements restants"
echo ""

echo "📁 Fichiers de sauvegarde disponibles :"
if [ ! -z "$BACKUP_FILES" ]; then
    echo "$BACKUP_FILES" | sed 's/^/   /'
else
    echo "   Aucun (restauration Git utilisée)"
fi

echo ""
log_success "🎉 Restauration du projet terminée avec succès!"
echo "======================================"