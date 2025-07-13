@ai4kids @learning @modules @education
Feature: AI4Kids - Modules d'apprentissage
  En tant qu'enfant
  Je veux découvrir l'intelligence artificielle à travers des modules ludiques
  Afin d'apprendre en m'amusant

  Background:
    Given je suis sur la page AI4Kids "http://localhost:3004"
    And la plateforme d'apprentissage est disponible

  @positive @smoke @welcome
  Scenario: Affichage de la page d'accueil
    When la page se charge
    Then je dois voir le titre "Bienvenue dans AI4Kids! 🌟"
    And je dois voir "Découvre le monde magique de l'Intelligence Artificielle"
    And l'interface doit être colorée et adaptée aux enfants

  @positive @modules-display
  Scenario: Affichage des trois modules d'apprentissage
    When je consulte les modules disponibles
    Then je dois voir exactement 3 modules
    And je dois voir "Mon Premier Chatbot" avec l'emoji "🤖"
    And je dois voir "Reconnaissance d'Images" avec l'emoji "👁️"
    And je dois voir "Commandes Vocales" avec l'emoji "🎤"
    And je dois voir la description "Crée ton propre assistant virtuel"
    And je dois voir la description "Apprends à l'IA à voir les images"
    And je dois voir la description "Contrôle ton ordinateur avec ta voix"

  @positive @module-selection
  Scenario: Sélection d'un module d'apprentissage
    When je clique sur "Mon Premier Chatbot"
    Then je dois voir "Tu as choisi: Mon Premier Chatbot"
    And je dois voir "Félicitations! Tu vas apprendre quelque chose d'incroyable aujourd'hui."
    And je dois voir le bouton "Suivant 🚀"
    And je dois voir le bouton "Retour"

  @positive @navigation-back
  Scenario: Retour à la sélection des modules
    Given j'ai sélectionné "Reconnaissance d'Images"
    And je vois "Tu as choisi: Reconnaissance d'Images"
    When je clique sur le bouton "Retour"
    Then je retourne à la vue des modules
    And je ne vois plus "Tu as choisi:"
    And tous les modules sont à nouveau visibles

  @positive @start-buttons
  Scenario: Boutons de démarrage sur chaque module
    When je consulte chaque module
    Then chaque module doit avoir un bouton "Commencer"
    And tous les boutons "Commencer" doivent être visibles
    And tous les boutons "Commencer" doivent être activés
    And je peux cliquer sur n'importe quel bouton

  @positive @child-friendly-design
  Scenario: Design adapté aux enfants
    When j'observe l'interface
    Then je dois voir un fond coloré avec gradient
    And le titre "AI4Kids" doit être en violet
    And les emojis doivent être de grande taille (text-6xl)
    And l'ensemble doit être visuellement attrayant pour les enfants

  @positive @module-progression
  Scenario: Progression dans un module
    Given j'ai sélectionné "Mon Premier Chatbot"
    When je clique sur "Suivant 🚀"
    Then je dois progresser dans le module
    And je dois voir du contenu pédagogique
    And je dois pouvoir continuer l'apprentissage

  @negative @invalid-module-access
  Scenario: Tentative d'accès à un module inexistant
    When j'essaie d'accéder directement à un module inexistant
    Then je dois voir "Module introuvable"
    And je dois être redirigé vers la page d'accueil
    And les modules valides doivent rester affichés

  @negative @server-error
  Scenario: Erreur serveur lors du chargement
    Given le serveur ne répond pas
    When j'essaie de charger la page
    Then je dois voir "Oups! Quelque chose s'est mal passé"
    And je dois voir un message d'erreur adapté aux enfants
    And je dois voir un bouton "Réessayer"

  @negative @module-content-error
  Scenario: Erreur lors du chargement du contenu d'un module
    Given j'ai sélectionné un module
    When le contenu du module ne se charge pas
    Then je dois voir "Le module n'est pas disponible pour le moment"
    And je dois pouvoir retourner à la sélection
    And les autres modules doivent rester fonctionnels

  @edge-case @rapid-selection
  Scenario: Sélection rapide de plusieurs modules
    When je clique rapidement sur "Mon Premier Chatbot"
    And je clique immédiatement sur "Commandes Vocales"
    Then seul le dernier module sélectionné doit être actif
    And il ne doit pas y avoir de conflits d'affichage
    And l'interface doit rester stable

  @edge-case @browser-back-button
  Scenario: Utilisation du bouton retour du navigateur
    Given j'ai sélectionné un module
    And je suis dans la vue de configuration
    When j'utilise le bouton retour du navigateur
    Then je dois retourner à la vue des modules
    And l'état de l'application doit être cohérent

  @edge-case @small-touch-screen
  Scenario: Utilisation sur petite tablette tactile
    Given je suis sur une tablette de 7 pouces
    When j'interagis avec les modules
    Then les boutons doivent être assez grands pour les petits doigts
    And l'interface doit s'adapter à la taille d'écran
    And la navigation tactile doit être fluide

  @twisted-case @simultaneous-clicks
  Scenario: Clics simultanés sur plusieurs modules
    When je clique simultanément sur deux modules différents
    Then l'application doit gérer le conflit
    And un seul module doit être sélectionné
    And l'interface ne doit pas se bloquer

  @twisted-case @session-timeout
  Scenario: Expiration de session pendant l'apprentissage
    Given je suis dans un module depuis longtemps
    When ma session expire
    Then je ne dois pas perdre ma progression
    And je dois pouvoir reprendre où je me suis arrêté
    And l'expérience doit rester fluide pour l'enfant

  @twisted-case @corrupted-module-data
  Scenario: Données de module corrompues
    Given un module a des données corrompues
    When je tente de le charger
    Then l'application doit détecter l'erreur
    And je dois voir "Ce module sera bientôt disponible!"
    And les autres modules doivent continuer à fonctionner

  @accessibility @child-a11y
  Scenario: Accessibilité pour enfants avec besoins spéciaux
    Given un enfant utilise des technologies d'assistance
    When il navigue dans l'application
    Then tous les éléments doivent être accessibles
    And les descriptions doivent être adaptées aux enfants
    And la navigation au clavier doit être simple
    And les contrastes doivent être élevés

  @performance @child-patience
  Scenario: Performance adaptée à l'attention des enfants
    When je clique sur un module
    Then la réponse doit être immédiate (moins d'1 seconde)
    And les animations doivent être fluides
    And il ne doit pas y avoir de temps d'attente frustrants

  @safety @child-protection
  Scenario: Protection des données des enfants
    Given un enfant utilise l'application
    When il interagit avec les modules
    Then aucune donnée personnelle ne doit être collectée
    And aucun contenu inapproprié ne doit être affiché
    And la navigation externe doit être bloquée

  @parental-control @supervision
  Scenario: Contrôles parentaux
    Given les parents veulent superviser l'apprentissage
    When ils accèdent aux paramètres
    Then ils doivent pouvoir voir la progression de l'enfant
    And ils doivent pouvoir limiter le temps d'utilisation
    And ils doivent recevoir des rapports d'activité