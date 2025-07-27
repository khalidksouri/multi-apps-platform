.PHONY: help install test test-headed test-mobile test-i18n clean start-app

# Variables
APP_DIR := ../apps/math4child

help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $1, $2}'

install: ## Installer les dépendances et navigateurs
	npm install
	npx playwright install --with-deps

setup: install ## Configuration complète
	@echo "✅ Math4Child Tests - Configuration terminée !"

test: ## Lancer tous les tests
	npm run test

test-headed: ## Tests avec interface graphique
	npm run test:headed

test-debug: ## Tests en mode debug
	npm run test:debug

test-ui: ## Interface Playwright UI
	npm run test:ui

test-chrome: ## Tests Chrome uniquement
	npm run test:chrome

test-firefox: ## Tests Firefox uniquement
	npm run test:firefox

test-safari: ## Tests Safari uniquement
	npm run test:safari

test-mobile: ## Tests mobile uniquement
	npm run test:mobile

test-tablet: ## Tests tablette uniquement
	npm run test:tablet

test-i18n: ## Tests multilingues
	npm run test:i18n

test-performance: ## Tests de performance
	npm run test:performance

test-accessibility: ## Tests d'accessibilité
	npm run test:accessibility

test-smoke: ## Tests critiques uniquement
	npm run test:smoke

test-regression: ## Tests de régression
	npm run test:regression

test-parallel: ## Tests en parallèle
	npm run test:parallel

test-serial: ## Tests en série
	npm run test:serial

record: ## Enregistrer nouveaux tests
	npm run test:record

trace: ## Tests avec traces
	npm run test:trace

screenshot: ## Tests avec screenshots
	npm run test:screenshot

report: ## Voir le rapport de tests
	npm run test:report

report-server: ## Serveur de rapport
	npm run test:report-open

update-snapshots: ## Mettre à jour les captures
	npm run test:update-snapshots

clean: ## Nettoyer les résultats
	npm run clean

clean-all: clean ## Nettoyage complet
	npm run clean:node-modules

lint: ## Vérifier le code
	npm run lint:tests

type-check: ## Vérifier les types TypeScript
	npm run type-check

docker-test: ## Tests avec Docker
	npm run docker:test

docker-clean: ## Nettoyer Docker
	npm run docker:clean

start-app: ## Démarrer Math4Child
	cd $(APP_DIR) && npm run dev

start-app-prod: ## Démarrer Math4Child (production)
	cd $(APP_DIR) && npm run build && npm run start

ci: ## Tests pour CI/CD
	npm run test:ci

# Commandes combinées
full-test: clean install test report ## Suite complète de tests
	@echo "🎯 Suite complète de tests Math4Child terminée !"

quick-test: test-smoke ## Tests rapides
	@echo "💨 Tests rapides terminés !"

dev-test: test-headed report ## Tests en développement
	@echo "🚀 Tests de développement terminés !"
