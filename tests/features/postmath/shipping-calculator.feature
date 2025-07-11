@postmath @shipping
Feature: Calcul de frais d'expédition
  En tant qu'utilisateur
  Je veux calculer les frais d'expédition de mes colis
  Afin de comparer les offres des transporteurs

  Background:
    Given je suis sur la page de calcul d'expédition
    And l'API des transporteurs est disponible

  @positive @smoke
  Scenario: Calcul réussi avec données valides
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination  
    And je saisis "2.5" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir les résultats de calcul
    And je dois voir au moins 3 transporteurs
    And chaque transporteur doit afficher un prix et un délai

  @negative @validation
  Scenario: Échec avec champ ville de départ vide
    Given je laisse le champ ville de départ vide
    And je saisis "Lyon" comme ville de destination
    And je saisis "2.5" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir l'erreur "Ville de départ requise"
    And les résultats ne doivent pas s'afficher

  @edge-case @boundary
  Scenario Outline: Test des limites de poids
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination
    And je saisis "<poids>" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir "<resultat>"

    Examples:
      | poids | resultat                           |
      | 0.1   | les résultats de calcul           |
      | 30.0  | les résultats de calcul           |
      | 30.1  | l'erreur "Poids maximum 30kg"     |
      | 0.0   | l'erreur "Le poids doit être positif" |
