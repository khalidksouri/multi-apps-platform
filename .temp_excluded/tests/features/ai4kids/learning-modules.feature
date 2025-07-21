@ai4kids @learning @modules @education
Feature: AI4Kids - Modules d'apprentissage
  En tant qu'enfant
  Je veux découvrir l'intelligence artificielle à travers des modules ludiques
  Afin d'apprendre en m'amusant

  Background:
    Given je suis sur la page AI4Kids "http://localhost:3004"
    And la plateforme d'apprentissage est disponible

  @positive @smoke @welcome
  Scenario: Affichage de la page d'accueil
    When la page se charge
    Then je dois voir le titre "Bienvenue dans AI4Kids! 🌟"
    And je dois voir "Découvre le monde magique de l'Intelligence Artificielle"
    And l'interface doit être colorée et adaptée aux enfants

  @positive @modules-display
  Scenario Outline: Affichage des modules d'apprentissage
    When je consulte les modules disponibles
    Then je dois voir le module "<module>" avec l'emoji "<emoji>"
    And je dois voir la description "<description>"
    And je dois voir le bouton "Commencer"
    And le bouton doit être visible et activé

    Examples:
      | module                    | emoji | description                              |
      | Mon Premier Chatbot       | 🤖    | Crée ton propre assistant virtuel       |
      | Reconnaissance d'Images   | 👁️    | Apprends à l'IA à voir les images        |
      | Commandes Vocales         | 🎤    | Contrôle ton ordinateur avec ta voix     |

  @positive @module-interaction
  Scenario Outline: Interaction avec les modules
    When je clique sur "<module>"
    Then je dois voir "Tu as choisi: <module>"
    And je dois voir "Félicitations! Tu vas apprendre quelque chose d'incroyable aujourd'hui."
    And je dois voir le bouton "Suivant 🚀"
    And je dois voir le bouton "Retour"

    Examples:
      | module                    |
      | Mon Premier Chatbot       |
      | Reconnaissance d'Images   |
      | Commandes Vocales         |

  @positive @navigation-flow
  Scenario Outline: Navigation complète dans les modules
    Given j'ai sélectionné "<module>"
    And je vois "Tu as choisi: <module>"
    When je clique sur le bouton "Retour"
    Then je retourne à la vue des modules
    And je ne vois plus "Tu as choisi:"
    And le module "<module>" est à nouveau visible

    Examples:
      | module                    |
      | Mon Premier Chatbot       |
      | Reconnaissance d'Images   |
      | Commandes Vocales         |

  @positive @progression
  Scenario Outline: Progression dans l'apprentissage
    Given j'ai sélectionné "<module>"
    When je clique sur "Suivant 🚀"
    Then je dois progresser dans le module
    And je dois voir du contenu pédagogique adapté à "<niveau>"
    And je dois pouvoir continuer l'apprentissage

    Examples:
      | module                    | niveau      |
      | Mon Premier Chatbot       | débutant    |
      | Reconnaissance d'Images   | intermédiaire |
      | Commandes Vocales         | avancé      |

  @negative @error-handling
  Scenario Outline: Gestion des erreurs adaptée aux enfants
    Given "<condition_erreur>"
    When "<action>"
    Then je dois voir "<message_enfant>"
    And je dois voir un bouton "Réessayer"
    And le message doit être rassurant

    Examples:
      | condition_erreur              | action                              | message_enfant                                |
      | le serveur ne répond pas      | j'essaie de charger la page        | Oups! Quelque chose s'est mal passé         |
      | un module ne se charge pas    | je clique sur un module             | Le module n'est pas disponible pour le moment |
      | la connexion est interrompue  | j'essaie d'accéder au contenu      | Vérifie ta connexion internet                |

  @edge-case @rapid-interactions
  Scenario Outline: Tests de stabilité pour enfants
    When "<action_rapide>"
    Then "<resultat_stable>"
    And l'interface doit rester stable pour l'enfant

    Examples:
      | action_rapide                                    | resultat_stable                                   |
      | je clique rapidement sur plusieurs modules      | seul le dernier module sélectionné doit être actif |
      | je clique plusieurs fois sur le même module     | le module doit répondre normalement               |
      | j'utilise le bouton retour plusieurs fois       | la navigation doit rester cohérente               |

  @twisted-case @child-specific
  Scenario Outline: Cas spéciaux pour enfants
    Given "<situation_speciale>"
    When "<action_enfant>"
    Then "<protection_attendue>"
    And l'expérience doit rester sûre

    Examples:
      | situation_speciale                | action_enfant                    | protection_attendue                           |
      | je suis dans un module depuis longtemps | ma session expire         | je ne dois pas perdre ma progression         |
      | un module a des données corrompues | je tente de le charger        | je dois voir "Ce module sera bientôt disponible!" |
      | j'utilise l'application intensivement | je navigue rapidement     | les performances doivent rester fluides      |

  @boundary @device-compatibility
  Scenario Outline: Compatibilité avec différents appareils
    Given je suis sur "<appareil>"
    When j'interagis avec les modules
    Then "<adaptation_appareil>"
    And l'expérience doit être adaptée aux enfants

    Examples:
      | appareil              | adaptation_appareil                                |
      | une tablette 7 pouces | les boutons doivent être assez grands pour les petits doigts |
      | un smartphone         | l'interface doit s'adapter à l'écran tactile      |
      | un ordinateur portable | la navigation clavier doit être simple            |
      | une tablette en portrait | l'affichage doit s'adapter à l'orientation      |

  @performance @child-attention
  Scenario Outline: Performance adaptée à l'attention des enfants
    When "<action_performance>"
    Then "<temps_enfant>"
    And l'expérience ne doit pas frustrer l'enfant

    Examples:
      | action_performance        | temps_enfant                                    |
      | je clique sur un module   | la réponse doit être immédiate (moins d'1s)    |
      | je navigue entre pages    | chaque transition doit être instantanée        |
      | je charge du contenu      | aucun temps d'attente frustrant               |
      | j'utilise les animations  | elles doivent être fluides et engageantes      |

  @accessibility @child-a11y
  Scenario Outline: Accessibilité pour enfants avec besoins spéciaux
    Given un enfant utilise "<technologie_assistance>"
    When il navigue dans l'application
    Then "<adaptation_a11y>"
    And l'expérience doit être inclusive

    Examples:
      | technologie_assistance | adaptation_a11y                                    |
      | un lecteur d'écran     | les descriptions doivent être adaptées aux enfants |
      | navigation clavier     | les raccourcis doivent être simples               |
      | zoom important         | l'interface doit rester claire                     |
      | contraste élevé        | les couleurs doivent être vives et contrastées    |

  @safety @child-protection
  Scenario Outline: Protection et sécurité des enfants
    Given "<contexte_protection>"
    When "<action_enfant>"
    Then "<mesure_protection>"
    And l'enfant doit être protégé

    Examples:
      | contexte_protection           | action_enfant                  | mesure_protection                                |
      | un enfant utilise l'application | il interagit avec les modules | aucune donnée personnelle ne doit être collectée |
      | du contenu externe existe     | il navigue dans l'app         | la navigation externe doit être bloquée         |
      | des liens sortants apparaissent | il clique accidentellement   | les liens doivent être sécurisés                |

  @parental-control @supervision
  Scenario Outline: Contrôles parentaux et supervision
    Given les parents veulent "<type_controle>"
    When ils accèdent aux paramètres
    Then ils doivent pouvoir "<action_parentale>"
    And recevoir "<information_parentale>"

    Examples:
      | type_controle           | action_parentale                      | information_parentale        |
      | superviser l'apprentissage | voir la progression de l'enfant    | des rapports détaillés      |
      | limiter le temps          | configurer des limites d'utilisation | des notifications de temps  |
      | suivre l'activité         | consulter l'historique d'usage      | des statistiques d'activité |
      | bloquer certains contenus | définir des restrictions            | des confirmations de sécurité |