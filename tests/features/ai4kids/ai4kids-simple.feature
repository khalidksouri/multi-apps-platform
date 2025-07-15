@ai4kids @simple
Feature: AI4Kids - Tests Simplifiés
  Tests de base pour AI4Kids sans complexity excessive

  @smoke @critical
  Scenario: Page d'accueil AI4Kids
    Given que je suis sur l'application "AI4Kids"
    Then je vois le titre "AI4Kids"
    And la page contient "Intelligence Artificielle"
    And la page contient "Mathématiques"

  @interaction @positive
  Scenario: Interaction basique avec les jeux
    Given que je suis sur l'application "AI4Kids"
    When je clique sur "Commencer"
    Then la page contient "question"
