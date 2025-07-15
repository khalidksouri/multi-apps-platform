@multiai @smoke
Feature: MultiAI - Sélection de Modèles
  En tant qu'utilisateur
  Je veux sélectionner différents modèles d'IA
  Afin d'obtenir des réponses spécialisées

  Background:
    Given que je suis sur l'application MultiAI

  @positive @critical
  Scenario: Affichage des modèles disponibles
    When je visite la page d'accueil
    Then je vois le titre "MultiAI"
    And je vois 5 modèles d'IA disponibles
    And chaque modèle affiche son statut

  @positive
  Scenario: Sélection d'un modèle actif
    When je clique sur le modèle "Assistant GPT"
    Then le modèle est sélectionné visuellement
    And le chat devient actif
    And je vois le nom du modèle dans l'en-tête du chat

  @negative
  Scenario: Sélection d'un modèle en maintenance
    When je clique sur un modèle en maintenance
    Then je vois un message d'avertissement
    And le chat reste désactivé
    And je suis invité à sélectionner un autre modèle

  @chat @positive
  Scenario: Conversation avec Assistant GPT
    Given que j'ai sélectionné le modèle "Assistant GPT"
    When j'envoie le message "Bonjour, comment allez-vous ?"
    Then je reçois une réponse de l'assistant
    And la réponse est contextuelle
    And l'historique de conversation est affiché

  @chat @positive
  Scenario: Conversation avec Code Assistant
    Given que j'ai sélectionné le modèle "Code Assistant"
    When j'envoie le message "Comment créer une fonction en TypeScript ?"
    Then je reçois une réponse avec du code
    And la réponse contient des exemples de code
    And la syntaxe est correctement formatée
