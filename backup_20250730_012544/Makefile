.PHONY: help install dev build test test-quick test-ui test-translation clean

help: ## Afficher l'aide
	@echo "🚀 Math4Child - Commandes disponibles:"
	@echo "  make install          # Installation complète"
	@echo "  make dev              # Serveur de développement"
	@echo "  make build            # Build de production"
	@echo "  make test             # Tests complets"
	@echo "  make test-quick       # Tests rapides (@smoke)"
	@echo "  make test-ui          # Interface graphique des tests"
	@echo "  make test-translation # Tests multilingues"
	@echo "  make clean            # Nettoyage"

install: ## Installation complète
	@echo "🔧 Installation des dépendances..."
	npm ci
	npx playwright install --with-deps
	@echo "✅ Installation terminée!"

dev: ## Serveur de développement
	@echo "🚀 Démarrage du serveur sur http://localhost:3000"
	npm run dev

build: ## Build de production
	@echo "🏗️ Build de production..."
	npm run build

test: ## Tests complets
	@echo "🧪 Exécution de tous les tests..."
	npx playwright test

test-quick: ## Tests rapides
	@echo "⚡ Tests rapides..."
	npx playwright test --grep "@smoke"

test-ui: ## Interface graphique des tests
	@echo "🖥️ Interface graphique Playwright..."
	npx playwright test --ui

test-translation: ## Tests multilingues
	@echo "🌍 Tests de traduction..."
	npx playwright test --grep "@translation-final"

clean: ## Nettoyage
	@echo "🧹 Nettoyage..."
	rm -rf node_modules/.cache .next test-results
	@echo "✅ Nettoyage terminé!"
