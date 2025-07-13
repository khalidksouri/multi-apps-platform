@multiai @ai-services @hub
Feature: MultiAI - Services IA
  En tant qu'utilisateur
  Je veux accéder aux services d'intelligence artificielle
  Afin d'utiliser différents outils IA depuis une plateforme unifiée

  Background:
    Given je suis sur la page du hub IA "http://localhost:3005"
    And la plateforme MultiAI est disponible

  @positive @smoke @display
  Scenario: Affichage du hub IA
    When la page se charge
    Then je dois voir le titre "Hub Intelligence Artificielle"
    And je dois voir le sous-titre "Accédez à tous les services IA depuis une seule plateforme"
    And l'interface doit avoir un design dark moderne

  @positive @services-list
  Scenario: Affichage des quatre services IA
    When je consulte la liste des services
    Then je dois voir exactement 4 services IA
    And je dois voir "Génération de Texte" avec l'icône "📝"
    And je dois voir "Génération d'Images" avec l'icône "🎨"
    And je dois voir "Assistant Code" avec l'icône "💻"
    And je dois voir "Synthèse Vocale" avec l'icône "🗣️"
    And je dois voir les descriptions "GPT-4, Claude, Gemini"
    And je dois voir les descriptions "DALL-E, Midjourney, Stable Diffusion"
    And je dois voir les descriptions "GitHub Copilot, CodeT5"
    And je dois voir les descriptions "ElevenLabs, Azure Speech"

  @positive @service-status
  Scenario: Vérification des statuts des services
    When je consulte les statuts des services
    Then je dois voir exactement 3 services avec le statut "Actif"
    And je dois voir exactement 1 service avec le statut "Bêta"
    And chaque service doit afficher son statut clairement

  @positive @service-selection
  Scenario: Sélection d'un service IA
    When je clique sur "Génération de Texte"
    Then je dois voir "Service sélectionné: Génération de Texte"
    And je dois voir "Configuration et paramètres du service IA..."
    And je dois voir le bouton "Configurer"
    And je dois voir le bouton "Fermer"
    And la configuration doit s'afficher

  @positive @configuration-close
  Scenario: Fermeture de la configuration
    Given j'ai sélectionné le service "Assistant Code"
    And je vois "Service sélectionné: Assistant Code"
    When je clique sur le bouton "Fermer"
    Then la configuration doit se fermer
    And je ne dois plus voir "Service sélectionné:"
    And je retourne à la vue principale

  @positive @navigation @all-services
  Scenario: Navigation entre tous les services
    When je clique successivement sur chaque service
    Then je peux sélectionner "Génération de Texte"
    And je peux sélectionner "Génération d'Images"
    And je peux sélectionner "Assistant Code"
    And je peux sélectionner "Synthèse Vocale"
    And chaque sélection affiche la configuration correspondante

  @positive @ui-effects
  Scenario: Effets visuels au survol
    When je survole une carte de service
    Then la carte doit avoir des effets de transition
    And je dois voir l'effet "hover:bg-white/20"
    And l'interaction doit être fluide

  @negative @service-unavailable
  Scenario: Tentative d'accès à un service indisponible
    Given un service est temporairement indisponible
    When je clique sur ce service
    Then je dois voir "Service temporairement indisponible"
    And le bouton "Configurer" doit être désactivé
    And je dois voir un message d'erreur approprié

  @negative @network-error
  Scenario: Erreur réseau lors du chargement
    Given la connexion réseau est interrompue
    When j'essaie de charger le hub IA
    Then je dois voir "Erreur de connexion"
    And je dois voir un bouton "Réessayer"
    And les services ne doivent pas s'afficher

  @negative @configuration-error
  Scenario: Erreur lors de la configuration d'un service
    Given j'ai sélectionné un service
    When je clique sur "Configurer"
    And une erreur se produit côté serveur
    Then je dois voir "Erreur de configuration"
    And je dois pouvoir retenter la configuration
    And l'état du service doit rester cohérent

  @edge-case @rapid-clicking
  Scenario: Clics rapides sur plusieurs services
    When je clique rapidement sur "Génération de Texte"
    And je clique immédiatement sur "Assistant Code"
    Then seul le dernier service sélectionné doit être actif
    And il ne doit pas y avoir de conflit d'affichage
    And la configuration affichée doit correspondre au dernier clic

  @edge-case @browser-compatibility
  Scenario: Compatibilité navigateur
    Given je suis sur un navigateur avec JavaScript désactivé
    When j'accède au hub IA
    Then je dois voir un message "JavaScript requis"
    And les fonctionnalités interactives ne doivent pas être disponibles

  @edge-case @small-screen
  Scenario: Affichage sur petit écran
    Given je suis sur un écran de largeur inférieure à 768px
    When j'accède au hub IA
    Then l'interface doit s'adapter à la taille d'écran
    And les cartes de services doivent rester lisibles
    And la navigation doit rester fonctionnelle

  @twisted-case @concurrent-sessions
  Scenario: Sessions concurrentes sur le même service
    Given j'ai ouvert le hub IA dans deux onglets
    When je configure un service dans le premier onglet
    And je modifie la même configuration dans le second onglet
    Then les deux onglets doivent se synchroniser
    And je ne dois pas perdre de données
    And l'état doit être cohérent entre les onglets

  @twisted-case @service-crash
  Scenario: Crash d'un service pendant l'utilisation
    Given j'ai configuré le service "Génération de Texte"
    When le service crash côté serveur
    Then je dois être notifié du problème
    And je dois pouvoir basculer vers un autre service
    And mes configurations précédentes doivent être préservées

  @twisted-case @malformed-response
  Scenario: Réponse malformée de l'API
    Given l'API retourne des données corrompues
    When je tente de charger les services
    Then l'application doit gérer l'erreur gracieusement
    And je dois voir "Erreur de données"
    And l'application ne doit pas crasher

  @performance @loading-time
  Scenario: Performance de chargement du hub
    When j'accède au hub IA
    Then la page doit se charger en moins de 2 secondes
    And tous les services doivent être visibles en moins de 3 secondes
    And les effets visuels doivent être fluides

  @accessibility @a11y
  Scenario: Accessibilité du hub IA
    Given je navigue avec un lecteur d'écran
    When j'accède au hub IA
    Then tous les éléments doivent être annoncés
    And je peux naviguer au clavier
    And les contrastes doivent respecter WCAG 2.1
    And les rôles ARIA doivent être corrects

  @security @data-protection
  Scenario: Protection des données utilisateur
    Given j'ai configuré plusieurs services
    When je ferme mon navigateur
    Then mes configurations ne doivent pas être exposées
    And les données sensibles doivent être chiffrées
    And aucune information ne doit fuiter dans les logs