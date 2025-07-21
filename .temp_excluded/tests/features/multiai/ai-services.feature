@multiai @ai-services @hub
Feature: MultiAI - Services IA
  En tant qu'utilisateur
  Je veux accéder aux services d'intelligence artificielle
  Afin d'utiliser différents outils IA depuis une plateforme unifiée

  Background:
    Given je suis sur la page du hub IA "http://localhost:3005"
    And la plateforme MultiAI est disponible

  @positive @smoke @display
  Scenario: Affichage du hub IA
    When la page se charge
    Then je dois voir le titre "Hub Intelligence Artificielle"
    And je dois voir le sous-titre "Accédez à tous les services IA depuis une seule plateforme"
    And l'interface doit avoir un design dark moderne

  @positive @services-display
  Scenario Outline: Affichage des services IA avec leurs détails
    When je consulte la liste des services
    Then je dois voir le service "<service>" avec l'icône "<icone>"
    And je dois voir la description "<description>"
    And je dois voir le statut "<statut>"

    Examples:
      | service              | icone | description                        | statut |
      | Génération de Texte  | 📝    | GPT-4, Claude, Gemini             | Actif  |
      | Génération d'Images  | 🎨    | DALL-E, Midjourney, Stable Diffusion | Actif  |
      | Assistant Code       | 💻    | GitHub Copilot, CodeT5            | Actif  |
      | Synthèse Vocale      | 🗣️    | ElevenLabs, Azure Speech           | Bêta   |

  @positive @service-interaction
  Scenario Outline: Interaction avec les services IA
    When je clique sur "<service>"
    Then je dois voir "Service sélectionné: <service>"
    And je dois voir "Configuration et paramètres du service IA..."
    And je dois voir le bouton "Configurer"
    And je dois voir le bouton "Fermer"
    And la configuration doit s'afficher

    Examples:
      | service              |
      | Génération de Texte  |
      | Génération d'Images  |
      | Assistant Code       |
      | Synthèse Vocale      |

  @positive @navigation-cycle
  Scenario Outline: Navigation complète entre services
    Given j'ai sélectionné le service "<service_initial>"
    When je clique sur le bouton "Fermer"
    And je clique sur "<service_final>"
    Then je dois voir "Service sélectionné: <service_final>"
    And la configuration précédente ne doit plus être visible

    Examples:
      | service_initial      | service_final        |
      | Génération de Texte  | Assistant Code       |
      | Assistant Code       | Génération d'Images  |
      | Génération d'Images  | Synthèse Vocale      |
      | Synthèse Vocale      | Génération de Texte  |

  @negative @error-scenarios
  Scenario Outline: Gestion des erreurs par type
    Given "<condition_initiale>"
    When "<action>"
    Then je dois voir "<message_erreur>"
    And "<consequence>"

    Examples:
      | condition_initiale                      | action                        | message_erreur                        | consequence                                |
      | un service est temporairement indisponible | je clique sur ce service      | Service temporairement indisponible   | le bouton Configurer doit être désactivé  |
      | la connexion réseau est interrompue     | j'essaie de charger le hub IA | Erreur de connexion                   | les services ne doivent pas s'afficher    |
      | l'API retourne des données corrompues   | je tente de charger les services | Erreur de données                  | l'application ne doit pas crasher          |

  @edge-case @rapid-interactions
  Scenario Outline: Tests de performance et stabilité
    When "<action_rapide>"
    Then "<resultat_attendu>"
    And l'interface doit rester stable

    Examples:
      | action_rapide                                           | resultat_attendu                                    |
      | je clique rapidement sur plusieurs services            | seul le dernier service sélectionné doit être actif |
      | je survole rapidement toutes les cartes               | les effets de transition doivent être fluides       |
      | j'ouvre et ferme la configuration 10 fois rapidement  | aucun conflit d'affichage ne doit se produire       |

  @twisted-case @stress-tests
  Scenario Outline: Tests de cas extrêmes
    Given "<situation_extreme>"
    When "<action_utilisateur>"
    Then "<gestion_attendue>"
    And l'application doit rester fonctionnelle

    Examples:
      | situation_extreme                         | action_utilisateur                    | gestion_attendue                           |
      | j'ai ouvert le hub IA dans deux onglets  | je configure des services différents | les deux onglets doivent se synchroniser   |
      | un service crash côté serveur            | je tente d'y accéder                 | je dois être notifié du problème          |
      | la mémoire du navigateur est limitée      | j'utilise intensivement l'interface  | les performances doivent rester acceptables |

  @boundary @screen-sizes
  Scenario Outline: Tests de responsivité
    Given je suis sur un écran de "<taille>"
    When j'accède au hub IA
    Then "<adaptation_attendue>"
    And la navigation doit rester fonctionnelle

    Examples:
      | taille              | adaptation_attendue                               |
      | largeur 320px       | l'interface doit s'adapter aux petits écrans     |
      | largeur 768px       | l'affichage tablette doit être optimal           |
      | largeur 1024px      | l'affichage desktop doit être complet            |
      | largeur 1920px      | l'interface doit utiliser l'espace disponible    |

  @performance @timing
  Scenario Outline: Tests de performance temporelle
    When "<action_performance>"
    Then "<temps_attendu>"
    And l'expérience utilisateur doit être fluide

    Examples:
      | action_performance              | temps_attendu                               |
      | j'accède au hub IA             | la page doit se charger en moins de 2s     |
      | je clique sur un service       | la réponse doit être immédiate (<500ms)    |
      | je charge tous les services    | l'affichage complet en moins de 3s         |
      | je navigue entre services      | chaque transition en moins de 200ms        |

  @accessibility @a11y-tests
  Scenario Outline: Tests d'accessibilité par type
    Given je navigue avec "<technologie_assistance>"
    When j'utilise le hub IA
    Then "<exigence_a11y>"
    And l'expérience doit être complète

    Examples:
      | technologie_assistance | exigence_a11y                                    |
      | un lecteur d'écran     | tous les éléments doivent être annoncés         |
      | navigation clavier     | tous les éléments doivent être accessibles      |
      | zoom 200%              | l'interface doit rester lisible et fonctionnelle |
      | contraste élevé        | les couleurs doivent respecter WCAG 2.1         |

  @security @data-protection
  Scenario Outline: Tests de sécurité des données
    Given "<contexte_securite>"
    When "<action_sensible>"
    Then "<protection_attendue>"
    And aucune fuite de données ne doit se produire

    Examples:
      | contexte_securite                  | action_sensible                 | protection_attendue                        |
      | j'ai configuré plusieurs services  | je ferme mon navigateur         | mes configurations ne doivent pas être exposées |
      | des données sensibles sont stockées | je consulte les logs           | aucune information ne doit fuiter          |
      | j'utilise un réseau public        | j'accède aux services          | toutes les communications doivent être chiffrées |