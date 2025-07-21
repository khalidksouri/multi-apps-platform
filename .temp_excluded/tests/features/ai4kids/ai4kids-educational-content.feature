@ai4kids @smoke
Feature: AI4Kids - Contenu Éducatif
  En tant qu'enfant
  Je veux interagir avec du contenu éducatif
  Afin d'apprendre en m'amusant

  Background:
    Given que je suis sur l'application AI4Kids

  @positive @critical
  Scenario: Affichage de la page d'accueil
    When je visite la page d'accueil
    Then je vois le titre "AI4Kids"
    And je vois le message "Apprends en t'amusant avec l'Intelligence Artificielle !"
    And je vois les sections de jeux éducatifs

  @math-games @positive
  Scenario: Jeu de mathématiques - Addition simple
    When je clique sur "Commencer" dans la section mathématiques
    Then je vois une question de mathématiques
    When je réponds correctement à la question
    Then je vois un message de félicitations
    And une nouvelle question apparaît

  @math-games @negative
  Scenario: Jeu de mathématiques - Réponse incorrecte
    When je clique sur "Commencer" dans la section mathématiques
    And je donne une réponse incorrecte
    Then je vois un message d'encouragement
    And je peux essayer à nouveau

  @animals @positive
  Scenario: Découverte des animaux
    When je clique sur "Découvrir" dans la section animaux
    Then je vois un fait amusant sur un animal
    And l'animal est affiché avec son emoji
    And je vois sa catégorie

  @stories @positive
  Scenario: Écouter une histoire
    When je clique sur "Raconte-moi" dans la section histoires
    Then je vois le titre d'une histoire
    And je vois le contenu de l'histoire
    And je vois la morale de l'histoire

  @ai-interaction @positive
  Scenario: Poser une question à l'IA
    When je tape "Dis-moi quelque chose sur les éléphants" dans le champ de question
    And je clique sur "Demander"
    Then je reçois une réponse de l'IA sur les éléphants
    And la réponse est adaptée aux enfants

  @hints @positive
  Scenario: Utilisation des indices en mathématiques
    When je commence un jeu de mathématiques
    And je clique sur "Indice"
    Then je vois un indice pour résoudre la question
    And l'indice m'aide à comprendre
