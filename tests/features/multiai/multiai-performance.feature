@multiai @performance
Feature: MultiAI - Performance
  En tant qu'utilisateur
  Je veux que l'application soit performante
  Afin d'avoir une expérience fluide

  @positive
  Scenario: Temps de réponse de l'IA
    Given que je suis sur l'application MultiAI
    And que j'ai sélectionné un modèle actif
    When j'envoie un message à l'IA
    Then je reçois une réponse en moins de 3 secondes
    And l'interface reste réactive

  @positive
  Scenario: Chargement initial de la page
    When je visite l'application MultiAI
    Then la page se charge en moins de 2 secondes
    And tous les modèles sont affichés rapidement
