@postmath @shipping
Feature: Calcul de frais d'expédition
  En tant qu'utilisateur
  Je veux calculer les frais d'expédition de mes colis
  Afin de comparer les offres des transporteurs et choisir la meilleure option

  Background:
    Given je suis sur la page de calcul d'expédition
    And l'API des transporteurs est disponible

  @positive @smoke @critical
  Scenario: Calcul réussi avec données valides
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination  
    And je saisis "2.5" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir les résultats de calcul
    And je dois voir au moins 3 transporteurs
    And chaque transporteur doit afficher un prix valide
    And chaque transporteur doit afficher un délai de livraison
    And les résultats doivent être triés par prix croissant

  @positive @comparison
  Scenario: Comparaison des prix entre transporteurs
    Given je saisis "Paris" comme ville de départ
    And je saisis "Marseille" comme ville de destination
    And je saisis "5.0" comme poids en kg
    And je saisis "40x30x20" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir au moins 2 transporteurs différents
    And les prix doivent être différents entre les transporteurs
    And je peux sélectionner un transporteur
    
  @negative @validation @required-fields
  Scenario Outline: Validation des champs obligatoires
    Given je saisis "<depart>" comme ville de départ
    And je saisis "<destination>" comme ville de destination
    And je saisis "<poids>" comme poids en kg
    And je saisis "<dimensions>" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir l'erreur "<message_erreur>"
    And les résultats ne doivent pas s'afficher

    Examples:
      | depart | destination | poids | dimensions | message_erreur                    |
      |        | Lyon        | 2.5   | 30x20x15   | Ville de départ requise          |
      | Paris  |             | 2.5   | 30x20x15   | Ville de destination requise     |
      | Paris  | Lyon        |       | 30x20x15   | Poids requis                     |
      | Paris  | Lyon        | 2.5   |            | Dimensions requises              |

  @negative @validation @format
  Scenario Outline: Validation du format des données
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination
    And je saisis "<poids>" comme poids en kg
    And je saisis "<dimensions>" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir l'erreur "<message_erreur>"

    Examples:
      | poids | dimensions | message_erreur                           |
      | abc   | 30x20x15   | Le poids doit être un nombre            |
      | -2.5  | 30x20x15   | Le poids doit être positif              |
      | 2.5   | invalide   | Format dimensions invalide (LxlxH en cm)|
      | 2.5   | 30x20      | Toutes les dimensions sont requises     |

  @edge-case @boundary @weight-limits
  Scenario Outline: Test des limites de poids
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination
    And je saisis "<poids>" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir "<resultat>"

    Examples:
      | poids | resultat                              |
      | 0.1   | les résultats de calcul              |
      | 0.5   | les résultats de calcul              |
      | 29.9  | les résultats de calcul              |
      | 30.0  | les résultats de calcul              |
      | 30.1  | l'erreur "Poids maximum dépassé (30kg max)" |
      | 50.0  | l'erreur "Poids maximum dépassé (30kg max)" |

  @edge-case @boundary @dimension-limits
  Scenario Outline: Test des limites de dimensions
    Given je saisis "Paris" comme ville de départ
    And je saisis "Lyon" comme ville de destination
    And je saisis "2.5" comme poids en kg
    And je saisis "<dimensions>" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir "<resultat>"

    Examples:
      | dimensions | resultat                                    |
      | 1x1x1      | les résultats de calcul                    |
      | 100x80x60  | les résultats de calcul                    |
      | 101x80x60  | l'erreur "Dimension maximale dépassée"     |
      | 100x81x60  | l'erreur "Dimension maximale dépassée"     |
      | 100x80x61  | l'erreur "Dimension maximale dépassée"     |

  @error-handling @api
  Scenario: Gestion des erreurs API
    Given l'API des transporteurs retourne une erreur
    And je saisis des données valides
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir l'erreur "Service temporairement indisponible"
    And je dois voir un message de retry
    And le bouton "Réessayer" doit être visible

  @performance @timeout
  Scenario: Timeout de l'API
    Given l'API des transporteurs est lente (plus de 30 secondes)
    And je saisis des données valides  
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir un indicateur de chargement
    And après 30 secondes je dois voir l'erreur "Timeout - Veuillez réessayer"

  @accessibility @a11y
  Scenario: Accessibilité du formulaire
    Given je suis sur la page de calcul d'expédition
    When je navigue avec le clavier uniquement
    Then tous les champs doivent être accessibles via Tab
    And les messages d'erreur doivent être annoncés par les lecteurs d'écran
    And les labels doivent être correctement associés aux champs

  @mobile @responsive
  Scenario: Utilisation sur mobile
    Given je suis sur un appareil mobile
    And je suis sur la page de calcul d'expédition
    When je saisis des données valides
    And je clique sur le bouton "Calculer les frais"
    Then l'interface doit s'adapter à la taille d'écran
    And les résultats doivent être lisibles
    And l'interaction tactile doit être fluide