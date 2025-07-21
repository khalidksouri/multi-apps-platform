@smoke
Feature: Tests de Smoke - Vérification rapide
  En tant qu'utilisateur
  Je veux m'assurer que toutes les applications démarrent
  Afin de vérifier la disponibilité du système

  @postmath @critical
  Scenario: Postmath - Page d'accueil disponible
    Given que je suis sur l'application "Postmath"
    Then je vois le titre "Postmath"
    And je vois le message "Postmath API is running"

  @ai4kids @critical  
  Scenario: AI4Kids - Page d'accueil disponible
    Given que je suis sur l'application "AI4Kids"
    Then je vois le titre "AI4Kids"
    And je vois le message "Apprends en t'amusant"
