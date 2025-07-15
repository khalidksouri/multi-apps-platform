@unitflip @smoke
Feature: UnitFlip - Conversions d'Unités
  En tant qu'utilisateur
  Je veux convertir des unités
  Afin d'obtenir des mesures dans différents systèmes

  Background:
    Given que je suis sur l'application UnitFlip

  @positive @critical
  Scenario: Conversion de longueur - Mètres vers Centimètres
    When je saisis "1" dans le champ valeur de longueur
    And je sélectionne "Mètre" comme unité source
    And je sélectionne "Centimètre" comme unité cible
    And je clique sur "Convertir"
    Then je vois le résultat "100 Centimètre"
    And le calcul est précis

  @positive
  Scenario: Conversion de poids - Kilogrammes vers Livres
    When je saisis "5" dans le champ valeur de poids
    And je sélectionne "Kilogramme" comme unité source
    And je sélectionne "Livre" comme unité cible
    And je clique sur "Convertir"
    Then le résultat est approximativement "11.0231 Livre"

  @positive
  Scenario: Conversion de température - Celsius vers Fahrenheit
    When je saisis "20" dans le champ valeur de température
    And je sélectionne "Celsius" comme unité source
    And je clique sur "Convertir"
    Then je vois les conversions en Celsius, Fahrenheit et Kelvin
    And la conversion Fahrenheit est "68.00°F"
    And la conversion Kelvin est "293.15K"

  @edge-case
  Scenario: Conversion avec valeur négative
    When je saisis "-10" dans le champ valeur de température
    And je sélectionne "Celsius" comme unité source
    And je clique sur "Convertir"
    Then les conversions sont calculées correctement
    And les résultats négatifs sont affichés

  @negative
  Scenario: Conversion avec valeur non numérique
    When je saisis "abc" dans le champ valeur de longueur
    And je clique sur "Convertir"
    Then je vois un message d'erreur approprié

  @twisted-case
  Scenario: Conversions multiples rapides
    When je effectue plusieurs conversions rapidement
    Then toutes les conversions sont calculées correctement
    And l'interface reste réactive
