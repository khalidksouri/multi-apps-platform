@postmath @shipping
Feature: Calcul de frais d'expédition
  En tant qu'utilisateur
  Je veux calculer les frais d'expédition de mes colis
  Afin de comparer les offres des transporteurs et choisir la meilleure option

  Background:
    Given je suis sur la page de calcul d'expédition
    And l'API des transporteurs est disponible

  @positive @smoke @successful-calculation
  Scenario Outline: Calculs réussis avec différents jeux de données
    Given je saisis "<depart>" comme ville de départ
    And je saisis "<destination>" comme ville de destination  
    And je saisis "<poids>" comme poids en kg
    And je saisis "<dimensions>" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir les résultats de calcul
    And je dois voir au moins "<nb_transporteurs>" transporteurs
    And chaque transporteur doit afficher un prix valide
    And chaque transporteur doit afficher un délai de livraison
    And les résultats doivent être triés par prix croissant

    Examples:
      | depart    | destination | poids | dimensions | nb_transporteurs |
      | Paris     | Lyon        | 2.5   | 30x20x15   | 3                |
      | Marseille | Lille       | 1.0   | 20x15x10   | 3                |
      | Toulouse  | Nancy       | 5.0   | 40x30x25   | 3                |
      | Bordeaux  | Strasbourg  | 0.5   | 15x10x8    | 2                |

  @positive @comparison
  Scenario Outline: Comparaison entre différentes destinations
    Given je saisis "Paris" comme ville de départ
    And je saisis "<destination>" comme ville de destination
    And je saisis "<poids>" comme poids en kg
    And je saisis "<dimensions>" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir au moins 2 transporteurs différents
    And les prix doivent être différents entre les transporteurs
    And je peux sélectionner un transporteur

    Examples:
      | destination | poids | dimensions |
      | Marseille   | 5.0   | 40x30x20   |
      | Lyon        | 3.0   | 35x25x15   |
      | Lille       | 2.0   | 25x20x12   |
      | Toulouse    | 4.5   | 38x28x18   |

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

  @negative @validation @format-errors
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
      | 2.5   | axbxc      | Les dimensions doivent être numériques  |

  @edge-case @boundary @weight-limits
  Scenario Outline: Tests des limites de poids
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
  Scenario Outline: Tests des limites de dimensions
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

  @negative @api-errors
  Scenario Outline: Gestion des erreurs API par type
    Given "<condition_api>"
    And je saisis des données valides
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir l'erreur "<message_api>"
    And je dois voir "<action_disponible>"

    Examples:
      | condition_api                               | message_api                           | action_disponible      |
      | l'API des transporteurs retourne une erreur | Service temporairement indisponible   | un bouton Réessayer    |
      | l'API des transporteurs est lente (>30s)   | Timeout - Veuillez réessayer          | un indicateur de chargement |
      | l'API retourne des données corrompues      | Erreur de traitement des données      | un message de retry    |

  @twisted-case @stress-scenarios
  Scenario Outline: Tests de stress et cas complexes
    When "<action_stress>"
    Then "<gestion_stress>"
    And l'application doit rester stable

    Examples:
      | action_stress                                   | gestion_stress                                  |
      | je clique 10 fois rapidement sur Calculer      | seule la dernière requête doit être traitée    |
      | je modifie les données pendant le calcul       | le calcul doit être annulé et relancé          |
      | j'ouvre le calculateur dans 3 onglets          | chaque onglet doit fonctionner indépendamment  |

  @boundary @extreme-destinations
  Scenario Outline: Tests avec destinations exotiques
    Given je saisis "Paris" comme ville de départ
    And je saisis "<destination_speciale>" comme ville de destination
    And je saisis "2.5" comme poids en kg
    And je saisis "30x20x15" comme dimensions en cm
    When je clique sur le bouton "Calculer les frais"
    Then je dois voir "<resultat_special>"

    Examples:
      | destination_speciale | resultat_special                        |
      | Outre-mer (DOM-TOM)  | les résultats avec tarifs spéciaux     |
      | Corse                | les résultats avec contraintes îles    |
      | Monaco               | les résultats standard                  |
      | Ville inexistante    | l'erreur "Destination non reconnue"    |

  @performance @response-time
  Scenario Outline: Tests de performance par volume
    Given j'ai "<volume_donnees>" transporteurs disponibles
    When je lance un calcul avec des données valides
    Then la réponse doit arriver en "<temps_max>"
    And l'interface doit rester responsive

    Examples:
      | volume_donnees | temps_max |
      | 3 transporteurs | 2 secondes |
      | 10 transporteurs | 5 secondes |
      | 20 transporteurs | 10 secondes |

  @accessibility @shipping-a11y
  Scenario Outline: Tests d'accessibilité du formulaire
    Given je navigue avec "<technologie_assistance>"
    When je remplis le formulaire de calcul
    Then "<exigence_a11y>"
    And l'expérience doit être complète

    Examples:
      | technologie_assistance | exigence_a11y                                    |
      | lecteur d'écran       | tous les champs doivent être correctement étiquetés |
      | navigation clavier    | tous les champs doivent être accessibles via Tab |
      | zoom 200%             | le formulaire doit rester utilisable            |
      | contraste élevé       | les messages d'erreur doivent être visibles     |

  @mobile @responsive-design
  Scenario Outline: Tests responsive sur différents appareils
    Given je suis sur "<appareil>"
    And je suis sur la page de calcul d'expédition
    When je saisis des données valides
    And je clique sur le bouton "Calculer les frais"
    Then "<adaptation_appareil>"
    And l'interaction tactile doit être fluide

    Examples:
      | appareil            | adaptation_appareil                               |
      | smartphone portrait | l'interface doit s'adapter à l'écran étroit      |
      | tablette landscape  | les résultats doivent être lisibles              |
      | écran large         | l'utilisation de l'espace doit être optimisée    |

  @security @data-validation
  Scenario Outline: Tests de sécurité et validation
    When j'essaie d'injecter "<tentative_injection>"
    Then l'application doit "<protection>"
    And aucune faille de sécurité ne doit être exploitée

    Examples:
      | tentative_injection        | protection                          |
      | <script>alert('xss')</script> | échapper le contenu HTML           |
      | '; DROP TABLE users; --    | valider strictement les entrées    |
      | ../../../etc/passwd        | bloquer les tentatives de path traversal |

  @advanced-shipping @multi-package
  Scenario Outline: Gestion des expéditions multi-colis
    Given je veux expédier "<nb_colis>" colis
    When je saisis les détails "<details_colis>"
    And je calcule les frais groupés
    Then je dois voir "<options_groupage>"
    And les tarifs doivent inclure "<remises_volume>"

    Examples:
      | nb_colis | details_colis                    | options_groupage      | remises_volume    |
      | 2        | 2kg+1kg, 30x20x15+25x15x10     | groupage possible     | remise 5%         |
      | 5        | 1kg chacun, dimensions variées  | groupage recommandé   | remise 12%        |
      | 10       | poids total 15kg                | groupage obligatoire  | remise 20%        |

  @insurance @protection-options
  Scenario Outline: Options d'assurance et protection
    Given j'expédie un colis d'une valeur de "<valeur_declaree>"
    When je sélectionne l'assurance "<type_assurance>"
    Then le coût additionnel doit être de "<cout_assurance>"
    And la couverture doit inclure "<garanties>"

    Examples:
      | valeur_declaree | type_assurance | cout_assurance | garanties                    |
      | 100€            | standard       | 2.50€          | vol + casse                  |
      | 500€            | renforcée      | 8.75€          | vol + casse + retard         |
      | 1000€           | premium        | 15.00€         | couverture complète          |
      | 50€             | aucune         | 0€             | responsabilité transporteur  |

  @tracking @delivery-monitoring
  Scenario Outline: Suivi et monitoring des livraisons
    Given j'ai expédié un colis avec le transporteur "<transporteur>"
    When je demande le suivi avec le numéro "<numero_suivi>"
    Then je dois voir les étapes "<etapes_livraison>"
    And recevoir des notifications "<type_notifications>"

    Examples:
      | transporteur | numero_suivi | etapes_livraison           | type_notifications    |
      | Colissimo    | 6A12345678   | pris en charge → transit → livré | SMS + email          |
      | Chronopost   | XD987654321  | collecté → tri → livraison | push + SMS           |
      | UPS          | 1Z999AA1     | origin scan → delivery     | email uniquement     |

  @carbon-footprint @eco-shipping
  Scenario Outline: Calcul empreinte carbone et options écologiques
    Given je calcule les frais pour "<trajet>"
    When j'active l'affichage empreinte carbone
    Then je dois voir "<emission_co2>" pour chaque transporteur
    And avoir accès aux options "<transport_eco>"

    Examples:
      | trajet           | emission_co2  | transport_eco              |
      | Paris → Lyon     | 0.8kg CO2     | livraison vélo électrique  |
      | Paris → Marseille| 1.2kg CO2     | transport ferroviaire      |
      | Paris → Londres  | 2.5kg CO2     | compensation carbone       |

  @api-integration @carrier-apis
  Scenario Outline: Intégration avec APIs des transporteurs
    Given l'API du transporteur "<transporteur>" est configurée
    When je teste l'intégration avec "<version_api>"
    Then la réponse doit respecter le format "<format_reponse>"
    And inclure les champs obligatoires "<champs_requis>"

    Examples:
      | transporteur | version_api | format_reponse | champs_requis                    |
      | La Poste     | v2.1        | JSON           | prix, delai, service_code        |
      | DPD          | v1.5        | XML            | cost, delivery_date, reference   |
      | FedEx        | v18         | JSON           | rate, transit_time, service_type |
      | DHL          | v3.0        | JSON           | amount, lead_time, product_code  |

  @dynamic-pricing @surge-pricing
  Scenario Outline: Tarification dynamique et pics de demande
    Given nous sommes en période de "<periode_speciale>"
    When je calcule les frais pour "<destination>"
    Then les tarifs doivent inclure "<ajustement_prix>"
    And afficher "<justification>"

    Examples:
      | periode_speciale | destination | ajustement_prix | justification              |
      | Black Friday     | nationale   | +15%            | forte demande              |
      | Noël             | Europe      | +25%            | surcharge saisonnière      |
      | grève transport  | Paris       | +40%            | capacité réduite           |
      | période normale  | toutes      | tarif standard  | conditions normales        |