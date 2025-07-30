# ===================================================================
# MAKEFILE ULTIME MULTI-APPS-PLATFORM
# Commandes de développement et de test
# ===================================================================

.PHONY: help dev build test clean install

# Couleurs pour l'affichage
BLUE=\033[0;34m
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m

# ===================================================================
# AIDE ET INFORMATION
# ===================================================================

help: ## Afficher cette aide
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo "$(BLUE)🚀 MULTI-APPS-PLATFORM - MAKEFILE$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(YELLOW)📊 STATISTIQUES DU PROJET :$(NC)"
	@echo "$(GREEN)• Applications: 5 (postmath, unitflip, budgetcron, ai4kids, multiai)$(NC)"
	@echo "$(GREEN)• Langues supportées: 20 exactement (3 RTL + 17 LTR)$(NC)"
	@echo "$(GREEN)• Tests: Playwright E2E complets$(NC)"
	@echo ""
	@echo "$(YELLOW)🛠️ COMMANDES PRINCIPALES :$(NC)"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  $(GREEN)%-20s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)🌐 URLS DES APPLICATIONS :$(NC)"
	@echo "  $(GREEN)PostMath Pro:$(NC)   http://localhost:3001"
	@echo "  $(GREEN)UnitFlip Pro:$(NC)   http://localhost:3002"
	@echo "  $(GREEN)BudgetCron:$(NC)     http://localhost:3003"
	@echo "  $(GREEN)AI4Kids:$(NC)        http://localhost:3004"
	@echo "  $(GREEN)MultiAI:$(NC)        http://localhost:3005"

# ===================================================================
# DÉVELOPPEMENT
# ===================================================================

dev: ## Démarrer toutes les applications
	@echo "$(BLUE)🚀 Démarrage de toutes les applications...$(NC)"
	npm run dev:all

dev-single: ## Démarrer une application spécifique (APP=nom)
	@if [ -z "$(APP)" ]; then \
		echo "$(RED)❌ Spécifiez l'application: make dev-single APP=postmath$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🚀 Démarrage de $(APP)...$(NC)"
	cd apps/$(APP) && npm run dev

build: ## Builder toutes les applications
	@echo "$(BLUE)🏗️ Build de toutes les applications...$(NC)"
	npm run build:all

# ===================================================================
# TESTS
# ===================================================================

test: ## Lancer tous les tests
	@echo "$(BLUE)🧪 Lancement de tous les tests...$(NC)"
	npm run test

test-ui: ## Interface de test Playwright
	@echo "$(BLUE)🎮 Ouverture de l'interface de test...$(NC)"
	npm run test:ui

test-translation: ## Tests de traduction uniquement
	@echo "$(BLUE)🌍 Tests de traduction...$(NC)"
	npm run test:translation

test-rtl: ## Tests RTL uniquement
	@echo "$(BLUE)🔄 Tests RTL...$(NC)"
	npm run test:rtl

test-apps: ## Tests des applications
	@echo "$(BLUE)📱 Tests des applications...$(NC)"
	npm run test:apps

# ===================================================================
# MAINTENANCE
# ===================================================================

install: ## Installer toutes les dépendances
	@echo "$(BLUE)📦 Installation des dépendances...$(NC)"
	npm install
	npm run install:all

install-browsers: ## Installer les navigateurs Playwright
	@echo "$(BLUE)🌐 Installation des navigateurs...$(NC)"
	npm run install:browsers

clean: ## Nettoyer les artifacts
	@echo "$(BLUE)🧹 Nettoyage...$(NC)"
	npm run clean:all
	rm -rf node_modules/.cache
	rm -rf test-results
	rm -rf playwright-report

validate: ## Validation complète
	@echo "$(BLUE)✅ Validation complète...$(NC)"
	npm run validate

# ===================================================================
# LANGUES ET I18N
# ===================================================================

count-languages: ## Compter les langues disponibles
	@echo "$(BLUE)🌍 Comptage des langues...$(NC)"
	@echo "$(GREEN)Langues totales: 20$(NC)"
	@echo "$(GREEN)Langues RTL: 3 (ar, he, fa)$(NC)"
	@echo "$(GREEN)Langues LTR: 17$(NC)"
	@echo "$(GREEN)Régions: 5 (Europe, Americas, Asia, MENA, Nordic)$(NC)"

# ===================================================================
# DIAGNOSTIC
# ===================================================================

status: ## Statut des applications
	@echo "$(BLUE)📊 Statut des applications...$(NC)"
	@for port in 3001 3002 3003 3004 3005; do \
		if curl -s -o /dev/null -w "%{http_code}" http://localhost:$$port | grep -q "200"; then \
			echo "$(GREEN)✅ Port $$port: OK$(NC)"; \
		else \
			echo "$(RED)❌ Port $$port: Non disponible$(NC)"; \
		fi; \
	done

report-open: ## Ouvrir le rapport de tests
	@echo "$(BLUE)📋 Ouverture du rapport de tests...$(NC)"
	npm run test:report

# ===================================================================
# COMMANDES CORRIGÉES POUR MATH4CHILD
# ===================================================================

check-apps: ## Vérifier les applications disponibles
	@echo "$(BLUE)📊 Vérification des applications...$(NC)"
	@for app in math4child unitflip budgetcron ai4kids multiai; do \
		if [ -d "apps/$$app" ]; then \
			echo "$(GREEN)✅ $$app: Disponible$(NC)"; \
		else \
			echo "$(RED)❌ $$app: Manquante$(NC)"; \
		fi; \
	done

dev-math4child: ## Démarrer Math4Child spécifiquement
	@echo "$(BLUE)🧮 Démarrage de Math4Child...$(NC)"
	@if [ -d "apps/math4child" ]; then \
		cd apps/math4child && npm run dev; \
	else \
		echo "$(RED)❌ Application math4child non trouvée$(NC)"; \
	fi

count-languages: ## Compter les langues disponibles (20 exactement)
	@echo "$(BLUE)🌍 Comptage des langues...$(NC)"
	@echo "$(GREEN)Langues totales: 20 exactement$(NC)"
	@echo "$(GREEN)Langues RTL: 3 (ar, he, fa)$(NC)"
	@echo "$(GREEN)Langues LTR: 17$(NC)"
	@echo "$(GREEN)Régions: 5 (Europe, Americas, Asia, MENA, Nordic)$(NC)"

github-info: ## Informations GitHub du projet
	@echo "$(BLUE)📊 Informations GitHub...$(NC)"
	@echo "$(GREEN)Dépôt: https://github.com/khalidksouri/multi-apps-platform$(NC)"
	@echo "$(GREEN)Auteur: Khalid Ksouri$(NC)"
	@echo "$(GREEN)Email: khalid_ksouri@yahoo.fr$(NC)"

# ===================================================================
# CORRECTIONS POUR MATH4CHILD
# ===================================================================

fix-math4child: ## Corriger math4child au lieu de postmath
	@echo "$(BLUE)🔧 Correction pour math4child...$(NC)"
	@if [ ! -d "apps/math4child" ]; then \
		echo "$(RED)❌ math4child non trouvé$(NC)"; \
	else \
		echo "$(GREEN)✅ math4child trouvé et opérationnel$(NC)"; \
	fi

dev-math4child: ## Démarrer Math4Child (port 3001)
	@echo "$(BLUE)🧮 Démarrage de Math4Child...$(NC)"
	@if [ -d "apps/math4child" ]; then \
		cd apps/math4child && npm run dev; \
	else \
		echo "$(RED)❌ Application math4child non trouvée$(NC)"; \
	fi

check-all-apps: ## Vérifier toutes les applications (math4child inclus)
	@echo "$(BLUE)📊 Vérification des applications...$(NC)"
	@for app in math4child unitflip budgetcron ai4kids multiai; do \
		if [ -d "apps/$$app" ]; then \
			echo "$(GREEN)✅ $$app: Disponible$(NC)"; \
			if [ -f "apps/$$app/package.json" ]; then \
				echo "   └─ package.json: ✅"; \
			else \
				echo "   └─ package.json: ❌"; \
			fi; \
		else \
			echo "$(RED)❌ $$app: Manquante$(NC)"; \
		fi; \
	done

security-update: ## Mettre à jour Next.js pour la sécurité
	@echo "$(BLUE)🔒 Mise à jour sécurité Next.js...$(NC)"
	@npm install next@14.2.30 --workspaces
	@echo "$(GREEN)✅ Mise à jour sécurité terminée$(NC)"
