@unitflip @conversion @units @calculator
Feature: UnitFlip - Conversion d'unités
  En tant qu'utilisateur
  Je veux convertir des unités de mesure
  Afin d'obtenir des équivalences précises entre différents systèmes

  Background:
    Given je suis sur l'application UnitFlip "http://localhost:3002"
    And le convertisseur d'unités est disponible

  @positive @smoke @temperature
  Scenario: Conversion de température Celsius vers Fahrenheit
    Given je suis sur la catégorie "température"
    When je saisis "0" dans le champ de valeur
    Then je dois voir le résultat "32.00000"
    And je dois voir l'explication "0°C × 9/5 + 32 = 32.00°F"
    And la conversion doit être instantanée

  @positive @unit-swap
  Scenario: Échange des unités de conversion
    Given je suis sur la catégorie "température"
    And j'ai saisi "100" comme valeur
    When je clique sur le bouton d'échange
    Then l'unité source doit devenir "fahrenheit"
    And l'unité cible doit devenir "celsius"
    And la valeur doit être recalculée automatiquement

  @positive @category-switching
  Scenario: Basculement entre catégories d'unités
    Given la catégorie "température" est sélectionnée par défaut
    And elle doit avoir la bordure "border-indigo-500"
    When je clique sur la catégorie "longueur"
    Then la catégorie "longueur" doit être sélectionnée
    And elle doit avoir la bordure "border-indigo-500"
    And l'unité source doit être "meters"
    And l'unité cible doit être "kilometers"

  @positive @common-conversions
  Scenario: Affichage des conversions courantes pour la température
    Given je suis sur la catégorie "température"
    When je consulte les conversions courantes
    Then je dois voir "0°C" avec son équivalent "32°F"
    And je dois voir "100°C" avec son équivalent "212°F"
    And toutes les conversions courantes doivent être exactes

  @positive @precision @decimal-values
  Scenario: Conversion avec valeurs décimales
    Given je suis sur la catégorie "température"
    When je saisis "36.5" comme valeur
    Then le résultat doit afficher la précision appropriée
    And je dois voir l'explication détaillée du calcul
    And la conversion doit être mathématiquement correcte

  @negative @invalid-input
  Scenario: Saisie de valeur invalide
    Given je suis sur n'importe quelle catégorie
    When je saisis "abc" dans le champ de valeur
    Then je dois voir "Valeur invalide"
    And le résultat ne doit pas s'afficher
    And je dois être invité à saisir un nombre valide

  @negative @empty-input
  Scenario: Champ de valeur vide
    Given j'ai un champ de valeur
    When je laisse le champ vide
    Then aucun résultat ne doit s'afficher
    And aucune erreur ne doit être affichée
    And l'interface doit rester propre

  @negative @extreme-values
  Scenario: Valeurs extrêmes hors limites
    Given je suis sur la catégorie "température"
    When je saisis "999999999999" comme valeur
    Then je dois voir "Valeur hors limites"
    And l'application ne doit pas crasher
    And je dois être informé des limites acceptées

  @edge-case @zero-value
  Scenario: Conversion avec la valeur zéro
    Given je suis sur différentes catégories
    When je saisis "0" comme valeur
    Then la conversion doit fonctionner correctement
    And le résultat doit être exact pour chaque unité
    And aucune division par zéro ne doit se produire

  @edge-case @negative-values
  Scenario: Conversion avec valeurs négatives
    Given je suis sur la catégorie "température"
    When je saisis "-40" comme valeur
    Then je dois voir le résultat correct "-40.00000"
    And je dois voir que -40°C = -40°F
    And les valeurs négatives doivent être gérées correctement

  @edge-case @very-small-numbers
  Scenario: Conversion de très petits nombres
    Given je suis sur la catégorie "longueur"
    When je saisis "0.000001" comme valeur
    Then la conversion doit maintenir la précision
    And l'affichage doit utiliser la notation scientifique si nécessaire
    And aucune perte de précision ne doit se produire

  @twisted-case @rapid-category-switching
  Scenario: Changement rapide de catégories
    When je clique rapidement sur plusieurs catégories
    And je saisis des valeurs pendant les changements
    Then l'application doit rester stable
    And chaque conversion doit utiliser les bonnes unités
    And il ne doit pas y avoir de mélange d'unités

  @twisted-case @simultaneous-inputs
  Scenario: Saisies simultanées dans plusieurs onglets
    Given j'ai ouvert UnitFlip dans deux onglets
    When je saisis des valeurs différentes dans chaque onglet
    Then chaque onglet doit fonctionner indépendamment
    And les conversions doivent être correctes dans les deux
    And aucune interférence ne doit se produire

  @twisted-case @memory-leak
  Scenario: Test de fuite mémoire avec conversions répétées
    When j'effectue 1000 conversions consécutives
    And je change de catégorie 100 fois
    Then l'application doit rester responsive
    And la mémoire ne doit pas augmenter de façon excessive
    And les performances doivent rester constantes

  @boundary @temperature-limits
  Scenario Outline: Test des limites de température
    Given je suis sur la catégorie "température"
    When je saisis "<temperature>" comme valeur
    Then je dois voir "<resultat>"

    Examples:
      | temperature | resultat                    |
      | -273.15     | -459.67000                 |
      | -274        | Température sous zéro absolu|
      | 1000        | 1832.00000                 |
      | 10000       | Valeur extrême             |

  @boundary @length-precision
  Scenario Outline: Test de précision pour les longueurs
    Given je suis sur la catégorie "longueur"
    When je convertis "<valeur>" "<unite_source>" vers "<unite_cible>"
    Then le résultat doit être "<resultat_attendu>"

    Examples:
      | valeur | unite_source | unite_cible | resultat_attendu |
      | 1      | meters       | kilometers  | 0.001           |
      | 1000   | meters       | kilometers  | 1.000           |
      | 1      | kilometers   | meters      | 1000.000        |
      | 0.5    | meters       | centimeters | 50.000          |

  @performance @conversion-speed
  Scenario: Performance des conversions
    When je saisis une valeur
    Then la conversion doit s'afficher en moins de 100ms
    And l'interface doit rester fluide
    And aucun délai ne doit être perceptible

  @accessibility @calculator-a11y
  Scenario: Accessibilité du convertisseur
    Given je navigue avec un lecteur d'écran
    When j'utilise le convertisseur
    Then tous les champs doivent être étiquetés
    And les résultats doivent être annoncés
    And je peux naviguer au clavier
    And les unités doivent être clairement identifiées

  @mobile @touch-interface
  Scenario: Utilisation sur interface tactile
    Given je suis sur un appareil mobile
    When j'utilise le convertisseur
    Then le clavier numérique doit apparaître pour la saisie
    And les boutons doivent être assez grands pour le tactile
    And l'interface doit s'adapter à l'orientation

  @localization @international
  Scenario: Support des formats internationaux
    Given je suis dans une locale différente
    When j'utilise des séparateurs décimaux locaux
    Then l'application doit accepter "," et "."
    And l'affichage doit respecter la locale
    And les unités doivent être traduites si applicable

  @formula @mathematical-accuracy
  Scenario: Vérification de l'exactitude mathématique
    Given je connais les formules de conversion
    When j'effectue des conversions
    Then tous les calculs doivent être mathématiquement exacts
    And les arrondis doivent suivre les règles IEEE
    And aucune erreur de précision flottante ne doit apparaître