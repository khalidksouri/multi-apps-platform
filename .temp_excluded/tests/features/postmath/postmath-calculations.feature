@postmath @smoke
Feature: Postmath - Calculs Mathématiques
  En tant qu'utilisateur
  Je veux effectuer des calculs mathématiques
  Afin de résoudre des problèmes numériques

  Background:
    Given que je suis sur l'application Postmath

  @positive @critical
  Scenario: Addition simple via l'interface
    When je saisis "5" dans le premier champ
    And je sélectionne "+" comme opération
    And je saisis "3" dans le second champ
    And je clique sur "Calculer"
    Then je vois le résultat "8"
    And le calcul affiché est "5 + 3 = 8"

  @positive
  Scenario: Multiplication via l'interface
    When je saisis "4" dans le premier champ
    And je sélectionne "×" comme opération
    And je saisis "6" dans le second champ
    And je clique sur "Calculer"
    Then je vois le résultat "24"

  @positive
  Scenario: Division avec résultat décimal
    When je saisis "10" dans le premier champ
    And je sélectionne "÷" comme opération
    And je saisis "3" dans le second champ
    And je clique sur "Calculer"
    Then je vois un résultat décimal précis

  @negative @edge-case
  Scenario: Division par zéro
    When je saisis "10" dans le premier champ
    And je sélectionne "÷" comme opération
    And je saisis "0" dans le second champ
    And je clique sur "Calculer"
    Then je vois un message d'erreur "Division par zéro impossible"

  @api @positive
  Scenario: Calcul via API REST
    When j'appelle l'API "/api/calculate?operation=multiply&a=7&b=8"
    Then la réponse contient le résultat "56"
    And la réponse contient les opérandes correctes
    And le timestamp est présent

  @api @negative
  Scenario: API avec paramètres manquants
    When j'appelle l'API "/api/calculate?operation=add&a=5"
    Then je reçois une erreur 400
    And le message d'erreur mentionne les paramètres manquants
