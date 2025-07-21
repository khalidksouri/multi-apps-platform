@unitflip @conversion @units @calculator
Feature: UnitFlip - Conversion d'unités
  En tant qu'utilisateur
  Je veux convertir des unités de mesure
  Afin d'obtenir des équivalences précises entre différents systèmes

  Background:
    Given je suis sur l'application UnitFlip "http://localhost:3002"
    And le convertisseur d'unités est disponible

  @positive @smoke @basic-conversions
  Scenario Outline: Conversions de base par catégorie
    Given je suis sur la catégorie "<categorie>"
    When je saisis "<valeur>" dans le champ de valeur
    Then je dois voir le résultat "<resultat>"
    And je dois voir l'explication "<explication>"
    And la conversion doit être instantanée

    Examples:
      | categorie   | valeur | resultat    | explication                    |
      | température | 0      | 32.00000    | 0°C × 9/5 + 32 = 32.00°F     |
      | température | 100    | 212.00000   | 100°C × 9/5 + 32 = 212.00°F  |
      | longueur    | 1      | 0.001       | 1 m = 0.001 km                |
      | longueur    | 1000   | 1.000       | 1000 m = 1.000 km             |

  @positive @unit-operations
  Scenario Outline: Opérations sur les unités
    Given je suis sur la catégorie "<categorie>"
    And j'ai saisi "<valeur_initiale>" comme valeur
    When je clique sur "<operation>"
    Then "<resultat_operation>"
    And la valeur doit être recalculée automatiquement

    Examples:
      | categorie   | valeur_initiale | operation        | resultat_operation                              |
      | température | 100             | bouton d'échange | l'unité source doit devenir fahrenheit         |
      | longueur    | 50              | bouton d'échange | l'unité source doit devenir kilometers         |
      | température | 36.5            | bouton reset     | la valeur doit revenir à 0                     |

  @positive @category-switching
  Scenario Outline: Basculement entre catégories avec états
    Given la catégorie "<categorie_initiale>" est sélectionnée
    And elle doit avoir la bordure "border-indigo-500"
    When je clique sur la catégorie "<categorie_finale>"
    Then la catégorie "<categorie_finale>" doit être sélectionnée
    And l'unité source doit être "<unite_source>"
    And l'unité cible doit être "<unite_cible>"

    Examples:
      | categorie_initiale | categorie_finale | unite_source | unite_cible |
      | température        | longueur         | meters       | kilometers  |
      | longueur           | poids            | kilograms    | pounds      |
      | poids              | température      | celsius      | fahrenheit  |

  @positive @precision-tests
  Scenario Outline: Tests de précision avec valeurs décimales
    Given je suis sur la catégorie "<categorie>"
    When je saisis "<valeur_decimale>" comme valeur
    Then le résultat doit afficher la précision appropriée
    And je dois voir l'explication détaillée du calcul
    And la conversion doit être mathématiquement correcte selon "<precision>"

    Examples:
      | categorie   | valeur_decimale | precision   |
      | température | 36.5            | 2 décimales |
      | longueur    | 0.000001        | 6 décimales |
      | poids       | 2.125           | 3 décimales |
      | volume      | 1.5             | 1 décimale  |

  @negative @invalid-inputs
  Scenario Outline: Gestion des saisies invalides
    Given je suis sur n'importe quelle catégorie
    When je saisis "<saisie_invalide>" dans le champ de valeur
    Then je dois voir "<message_erreur>"
    And le résultat ne doit pas s'afficher
    And "<comportement_attendu>"

    Examples:
      | saisie_invalide | message_erreur    | comportement_attendu                    |
      | abc             | Valeur invalide   | je dois être invité à saisir un nombre |
      | 12abc           | Valeur invalide   | seule la partie numérique doit être considérée |
      | vide            | aucune erreur     | l'interface doit rester propre          |
      | @@##            | Valeur invalide   | le champ doit être vidé automatiquement |

  @edge-case @extreme-values
  Scenario Outline: Test avec valeurs extrêmes
    Given je suis sur la catégorie "<categorie>"
    When je saisis "<valeur_extreme>" comme valeur
    Then je dois voir "<gestion_extreme>"
    And l'application ne doit pas crasher

    Examples:
      | categorie   | valeur_extreme    | gestion_extreme                     |
      | température | 999999999999      | Valeur hors limites                 |
      | température | -999999999999     | Valeur hors limites                 |
      | longueur    | 0.000000000001    | notation scientifique si nécessaire |
      | température | 0                 | conversion normale                  |

  @edge-case @special-values
  Scenario Outline: Test avec valeurs spéciales
    Given je suis sur la catégorie "<categorie>"
    When je saisis "<valeur_speciale>" comme valeur
    Then "<gestion_speciale>"
    And aucune erreur mathématique ne doit se produire

    Examples:
      | categorie   | valeur_speciale | gestion_speciale                                |
      | température | -40             | je dois voir que -40°C = -40°F                 |
      | température | -273.15         | je dois voir la conversion du zéro absolu      |
      | longueur    | 0               | la conversion doit fonctionner normalement      |
      | poids       | 0.001           | la précision doit être maintenue               |

  @twisted-case @stress-operations
  Scenario Outline: Tests de stress et stabilité
    When "<action_stress>"
    Then "<resultat_stabilite>"
    And l'application doit rester stable

    Examples:
      | action_stress                                  | resultat_stabilite                              |
      | je clique rapidement sur plusieurs catégories | chaque conversion doit utiliser les bonnes unités |
      | j'effectue 1000 conversions consécutives     | les performances doivent rester constantes      |
      | je change de catégorie 100 fois               | la mémoire ne doit pas augmenter excessivement  |
      | j'ouvre UnitFlip dans deux onglets            | chaque onglet doit fonctionner indépendamment   |

  @boundary @temperature-limits
  Scenario Outline: Tests des limites physiques de température
    Given je suis sur la catégorie "température"
    When je saisis "<temperature>" comme valeur
    Then je dois voir "<resultat_limite>"

    Examples:
      | temperature | resultat_limite                     |
      | -273.15     | -459.67000                          |
      | -274        | Température sous zéro absolu        |
      | 1000        | 1832.00000                          |
      | 10000       | Valeur extrême                      |
      | -300        | Température physiquement impossible |

  @boundary @precision-limits
  Scenario Outline: Tests de précision par unité
    Given je suis sur la catégorie "<categorie>"
    When je convertis "<valeur>" "<unite_source>" vers "<unite_cible>"
    Then le résultat doit être "<resultat_attendu>" avec "<precision>"

    Examples:
      | categorie | valeur | unite_source | unite_cible  | resultat_attendu | precision    |
      | longueur  | 1      | meters       | kilometers   | 0.001           | 3 décimales  |
      | longueur  | 1000   | meters       | kilometers   | 1.000           | 3 décimales  |
      | longueur  | 1      | kilometers   | meters       | 1000.000        | 3 décimales  |
      | longueur  | 0.5    | meters       | centimeters  | 50.000          | 3 décimales  |

  @performance @conversion-speed
  Scenario Outline: Tests de performance par type d'opération
    When "<operation_performance>"
    Then "<exigence_temps>"
    And l'interface doit rester fluide

    Examples:
      | operation_performance              | exigence_temps                           |
      | je saisis une valeur              | la conversion doit s'afficher en <100ms  |
      | je change de catégorie            | le changement doit être instantané       |
      | je clique sur le bouton d'échange | l'échange doit être immédiat             |
      | je navigue entre les unités       | aucun délai ne doit être perceptible     |

  @accessibility @calculator-a11y
  Scenario Outline: Tests d'accessibilité par technologie
    Given je navigue avec "<technologie_a11y>"
    When j'utilise le convertisseur
    Then "<exigence_accessibilite>"
    And l'expérience doit être complète

    Examples:
      | technologie_a11y | exigence_accessibilite                        |
      | lecteur d'écran  | tous les champs et résultats doivent être annoncés |
      | navigation clavier | tous les éléments doivent être accessibles    |
      | zoom 200%        | l'interface doit rester fonctionnelle         |
      | contraste élevé  | les unités doivent être clairement identifiées |

  @mobile @device-compatibility
  Scenario Outline: Tests de compatibilité mobile
    Given je suis sur "<appareil_mobile>"
    When j'utilise le convertisseur
    Then "<adaptation_mobile>"
    And l'interface doit s'adapter à l'orientation

    Examples:
      | appareil_mobile | adaptation_mobile                                      |
      | smartphone      | le clavier numérique doit apparaître pour la saisie   |
      | tablette        | les boutons doivent être assez grands pour le tactile |
      | écran tactile   | les gestes de swipe doivent fonctionner               |

  @localization @international-support
  Scenario Outline: Support des formats internationaux
    Given je suis dans la locale "<locale>"
    When j'utilise des séparateurs décimaux "<separateur>"
    Then l'application doit accepter la saisie
    And l'affichage doit respecter "<format_attendu>"

    Examples:
      | locale | separateur | format_attendu     |
      | FR     | ,          | format français    |
      | US     | .          | format américain   |
      | DE     | ,          | format allemand    |
      | UK     | .          | format britannique |

  @formula @mathematical-accuracy
  Scenario Outline: Vérification de l'exactitude mathématique
    Given je connais la formule "<formule>"
    When j'effectue la conversion "<conversion>"
    Then le calcul doit être mathématiquement exact
    And les arrondis doivent suivre les règles IEEE
    And aucune erreur de précision flottante ne doit apparaître selon "<tolerance>"

    Examples:
      | formule              | conversion        | tolerance       |
      | C = (F-32) × 5/9     | 32°F vers °C     | 0.00001         |
      | F = C × 9/5 + 32     | 0°C vers °F      | 0.00001         |
      | km = m / 1000        | 1000m vers km    | 0.000001        |
      | m = km × 1000        | 1km vers m       | 0.001           |

  @advanced-conversions @scientific-units
  Scenario Outline: Conversions d'unités scientifiques avancées
    Given je suis sur la catégorie "<categorie_scientifique>"
    When je convertis "<valeur_entree>" "<unite_source>" vers "<unite_cible>"
    Then le résultat doit être "<valeur_attendue>" avec notation "<notation>"

    Examples:
      | categorie_scientifique | valeur_entree | unite_source | unite_cible | valeur_attendue | notation      |
      | énergie               | 1             | joule        | calorie     | 0.239           | décimale      |
      | pression              | 1             | bar          | pascal      | 100000          | scientifique  |
      | fréquence             | 1             | hertz        | kilohertz   | 0.001           | décimale      |
      | vitesse               | 100           | km/h         | m/s         | 27.778          | décimale      |

  @batch-conversion @bulk-processing
  Scenario Outline: Conversion en lot et traitement groupé
    Given j'ai une liste de "<nb_valeurs>" valeurs à convertir
    When je lance une conversion en lot de "<unite_source>" vers "<unite_cible>"
    Then toutes les conversions doivent être traitées en "<temps_max>"
    And le taux d'erreur doit être inférieur à "<seuil_erreur>"

    Examples:
      | nb_valeurs | unite_source | unite_cible | temps_max | seuil_erreur |
      | 10         | celsius      | fahrenheit  | 1s        | 0%           |
      | 100        | meters       | feet        | 5s        | 0.1%         |
      | 1000       | kilograms    | pounds      | 30s       | 0.01%        |
      | 10000      | liters       | gallons     | 120s      | 0.001%       |

  @custom-units @user-defined
  Scenario Outline: Unités personnalisées définies par l'utilisateur
    Given l'utilisateur définit une unité personnalisée "<unite_custom>"
    When il configure la formule de conversion "<formule_custom>"
    Then l'unité doit être disponible dans la catégorie "<categorie>"
    And les conversions doivent utiliser "<precision_custom>"

    Examples:
      | unite_custom | formule_custom        | categorie | precision_custom |
      | smoots       | 1 smoot = 1.7018m     | longueur  | 4 décimales      |
      | barils       | 1 baril = 159L        | volume    | 2 décimales      |
      | knots        | 1 knot = 1.852 km/h   | vitesse   | 3 décimales      |
      | calories     | 1 cal = 4.184 J       | énergie   | 6 décimales      |

  @historical-units @legacy-support
  Scenario Outline: Support des unités historiques et héritées
    Given je veux convertir des unités "<type_historique>"
    When j'utilise l'unité "<unite_ancienne>" vers "<unite_moderne>"
    Then la conversion doit inclure "<contexte_historique>"
    And afficher "<precision_historique>"

    Examples:
      | type_historique | unite_ancienne | unite_moderne | contexte_historique | precision_historique |
      | longueur        | lieue          | kilomètre     | France ancienne     | 2 décimales          |
      | poids           | livre          | kilogramme    | système impérial    | 3 décimales          |
      | volume          | pinte          | litre         | mesures anciennes   | 4 décimales          |
      | surface         | arpent         | hectare       | cadastre historique | 5 décimales          |

  @api-integration @external-rates
  Scenario Outline: Intégration avec APIs externes pour taux dynamiques
    Given l'API "<api_externe>" fournit des taux de change
    When je convertis "<devise_source>" vers "<devise_cible>"
    Then le taux doit être mis à jour toutes les "<frequence_maj>"
    And la conversion doit inclure "<metadonnees>"

    Examples:
      | api_externe    | devise_source | devise_cible | frequence_maj | metadonnees              |
      | ECB            | EUR           | USD          | 1 heure       | timestamp + source       |
      | CryptoCompare  | BTC           | EUR          | 5 minutes     | volatilité + volume      |
      | Bank of England| GBP           | EUR          | 1 jour        | taux officiel + date     |
      | Bank of Japan  | JPY           | USD          | 4 heures      | session marché + spread  |