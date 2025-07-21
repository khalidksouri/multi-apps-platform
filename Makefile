.PHONY: help install dev test clean

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installer toutes les dépendances
	cd apps/math4child && npm install
	cd tests && npm install && npx playwright install --with-deps

dev: ## Démarrer l'application en développement
	cd apps/math4child && npm run dev

test: ## Lancer tous les tests
	cd tests && npm run test

test-headed: ## Tests avec interface graphique
	cd tests && npm run test:headed

test-ui: ## Interface Playwright UI
	cd tests && npm run test:ui

test-mobile: ## Tests mobile uniquement
	cd tests && npm run test:mobile

test-i18n: ## Tests multilingues
	cd tests && npm run test:i18n

build: ## Build application
	cd apps/math4child && npm run build

lint: ## Vérifier le code
	cd apps/math4child && npm run lint

type-check: ## Vérifier TypeScript
	cd apps/math4child && npm run type-check

clean: ## Nettoyer
	cd apps/math4child && npm run clean
	cd tests && npm run clean

setup: install ## Configuration complète
	cd apps/math4child && npx husky install
	@echo "✅ Configuration terminée !"
