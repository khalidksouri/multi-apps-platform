# ===================================================================
# 🚀 MAKEFILE MATH4CHILD CORRIGÉ
# Commandes sans options Playwright invalides
# ===================================================================

# Variables
NODE_VERSION := 18
APP_NAME := Math4Child
VERSION := 2.0.0
BASE_URL := http://localhost:3000

# Couleurs
RESET := \033[0m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
PURPLE := \033[35m
CYAN := \033[36m
BOLD := \033[1m

# Messages utilitaires
define print_header
	@echo "$(CYAN)$(BOLD)=========================================$(RESET)"
	@echo "$(CYAN)$(BOLD)🧪 $(1)$(RESET)"
	@echo "$(CYAN)$(BOLD)=========================================$(RESET)"
endef

define print_success
	@echo "$(GREEN)✅ $(1)$(RESET)"
endef

define print_info
	@echo "$(BLUE)ℹ️  $(1)$(RESET)"
endef

# ===================================================================
# 🎯 COMMANDES PRINCIPALES
# ===================================================================

.PHONY: help
help: ## 📋 Afficher l'aide
	$(call print_header,MATH4CHILD - COMMANDES DISPONIBLES)
	@echo "$(BOLD)🎯 COMMANDES PRINCIPALES:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)📖 EXEMPLES:$(RESET)"
	@echo "  $(GREEN)make install$(RESET)        # Installation complète"
	@echo "  $(GREEN)make dev$(RESET)            # Serveur de développement" 
	@echo "  $(GREEN)make test$(RESET)           # Tests complets"
	@echo "  $(GREEN)make test-quick$(RESET)     # Tests rapides"

.DEFAULT_GOAL := help

# ===================================================================
# 🛠️ INSTALLATION
# ===================================================================

.PHONY: install
install: ## 🚀 Installation complète
	$(call print_header,INSTALLATION MATH4CHILD)
	$(call print_info,Installation des dépendances...)
	npm ci --prefer-offline --no-audit
	$(call print_info,Installation de Playwright...)
	npx playwright install --with-deps
	$(call print_success,Installation terminée!)

.PHONY: setup
setup: install ## 🔧 Configuration initiale
	$(call print_info,Création des répertoires...)
	@mkdir -p test-results playwright-report
	$(call print_success,Configuration terminée!)

# ===================================================================
# 🏃‍♂️ DÉVELOPPEMENT
# ===================================================================

.PHONY: dev
dev: ## 🚀 Serveur de développement
	$(call print_header,SERVEUR DE DÉVELOPPEMENT)
	$(call print_info,Démarrage sur $(BASE_URL)...)
	npm run dev

.PHONY: build
build: ## 🏗️ Build de production
	$(call print_header,BUILD DE PRODUCTION)
	npm run build
	$(call print_success,Build terminé!)

# ===================================================================
# 🧪 TESTS - COMMANDES CORRIGÉES
# ===================================================================

.PHONY: test
test: ## 🧪 Tous les tests
	$(call print_header,TESTS COMPLETS)
	npx playwright test

.PHONY: test-quick
test-quick: ## ⚡ Tests rapides (smoke)
	$(call print_header,TESTS RAPIDES)
	npx playwright test --project=smoke

.PHONY: test-ui
test-ui: ## 🖥️ Interface graphique
	$(call print_header,INTERFACE PLAYWRIGHT UI)
	npx playwright test --ui

.PHONY: test-debug
test-debug: ## 🐛 Mode debug
	$(call print_header,MODE DEBUG)
	npx playwright test --debug

.PHONY: test-headed
test-headed: ## 👁️ Tests avec interface visible
	$(call print_header,TESTS AVEC INTERFACE)
	npx playwright test --headed

# ===================================================================
# 🌍 TESTS MULTILINGUES
# ===================================================================

.PHONY: test-translation
test-translation: ## 🌍 Tests de traduction
	$(call print_header,TESTS MULTILINGUES)
	npx playwright test --project=translation

.PHONY: test-rtl
test-rtl: ## 🔄 Tests RTL (arabe)
	$(call print_header,TESTS RTL)
	npx playwright test --grep "@translation.*ar"

# ===================================================================
# 📱 TESTS PAR APPAREIL
# ===================================================================

.PHONY: test-mobile
test-mobile: ## 📱 Tests mobile
	$(call print_header,TESTS MOBILE)
	npx playwright test --project=mobile

.PHONY: test-desktop
test-desktop: ## 🖥️ Tests desktop
	$(call print_header,TESTS DESKTOP)
	npx playwright test --project=desktop

# ===================================================================
# 🌐 TESTS PAR NAVIGATEUR
# ===================================================================

.PHONY: test-chrome
test-chrome: ## 🌐 Tests Chrome
	npx playwright test --project=chromium

.PHONY: test-firefox
test-firefox: ## 🔥 Tests Firefox
	npx playwright test --project=firefox

# ===================================================================
# 📊 RAPPORTS
# ===================================================================

.PHONY: report
report: ## 📊 Ouvrir le rapport
	$(call print_header,RAPPORT DES TESTS)
	npx playwright show-report

.PHONY: test-report
test-report: test report ## 🧪 Tests + rapport
	$(call print_success,Tests et rapport générés!)

# ===================================================================
# 🧹 MAINTENANCE
# ===================================================================

.PHONY: clean
clean: ## 🧹 Nettoyage
	$(call print_header,NETTOYAGE)
	@rm -rf test-results/*.tmp playwright-report/*.tmp
	$(call print_success,Nettoyage terminé!)

.PHONY: clean-all
clean-all: ## 🗑️ Nettoyage complet
	$(call print_header,NETTOYAGE COMPLET)
	@rm -rf node_modules test-results playwright-report .next
	$(call print_success,Nettoyage complet terminé!)

# ===================================================================
# 🔧 UTILITAIRES
# ===================================================================

.PHONY: status
status: ## 📊 Statut du projet
	$(call print_header,STATUT DU PROJET)
	@echo "$(BOLD)Node.js:$(RESET) $$(node --version)"
	@echo "$(BOLD)npm:$(RESET) v$$(npm --version)"
	@echo "$(BOLD)Playwright:$(RESET) $$(npx playwright --version 2>/dev/null || echo 'Non installé')"

.PHONY: validate
validate: ## ✅ Validation complète
	$(call print_header,VALIDATION COMPLÈTE)
	@make test-quick
	$(call print_success,Validation réussie!)

# ===================================================================
# 🎯 RACCOURCIS
# ===================================================================

.PHONY: t
t: test-quick ## ⚡ Alias test-quick

.PHONY: tt
tt: test ## 🧪 Alias test complet

.PHONY: d
d: dev ## 🚀 Alias dev

.PHONY: i
i: install ## 🛠️ Alias install

.PHONY: c
c: clean ## 🧹 Alias clean

# Message d'information
$(info 🌟 Math4Child v$(VERSION) - Makefile chargé)

# ===================================================================
# 🌍 COMMANDES RTL SPÉCIFIQUES
# ===================================================================

.PHONY: test-rtl-pricing
test-rtl-pricing: ## 🇸🇦 Tests RTL pricing uniquement
	$(call print_header,TESTS RTL PRICING)
	npx playwright test tests/specs/rtl/pricing-rtl.spec.ts

.PHONY: test-rtl-all
test-rtl-all: ## 🌍 Tous les tests RTL
	$(call print_header,TOUS LES TESTS RTL)
	npx playwright test tests/specs/rtl/

.PHONY: dev-rtl
dev-rtl: ## 🌍 Serveur avec langue arabe par défaut
	$(call print_header,SERVEUR RTL)
	$(call print_info,Démarrage avec langue arabe...)
	NEXT_PUBLIC_DEFAULT_LANG=ar npm run dev

.PHONY: build-rtl
build-rtl: ## 🏗️ Build avec support RTL optimisé
	$(call print_header,BUILD RTL)
	$(call print_info,Build avec optimisations RTL...)
	npm run build

.PHONY: validate-rtl
validate-rtl: ## ✅ Validation complète RTL
	$(call print_header,VALIDATION RTL)
	@make test-rtl-pricing
	@make test-translation
	$(call print_success,Validation RTL réussie!)

# Message pour les commandes RTL
$(info 🌍 Commandes RTL ajoutées au Makefile)
