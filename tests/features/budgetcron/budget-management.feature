@budgetcron @budget @finance @management
Feature: BudgetCron - Gestion budgétaire
  En tant qu'utilisateur
  Je veux gérer mon budget et mes finances
  Afin de contrôler mes dépenses et optimiser mes économies

  Background:
    Given je suis sur l'application BudgetCron "http://localhost:3003"
    And je suis connecté à mon compte
    And mes données financières sont synchronisées

  @positive @smoke @dashboard
  Scenario: Affichage du tableau de bord principal
    When j'accède au tableau de bord
    Then je dois voir le titre "Tableau de bord"
    And je dois voir le budget total de "2500€"
    And je dois voir le montant dépensé de "1850€"
    And je dois voir le montant restant de "650€"
    And toutes les métriques doivent être à jour

  @positive @ai-insights
  Scenario Outline: Consultation des insights IA par type
    When je consulte la section insights
    Then je dois voir "🧠 Insights IA"
    And je dois voir l'insight "<type_insight>"
    And l'insight doit être "<caracteristique>"

    Examples:
      | type_insight     | caracteristique      |
      | Économie détectée | pertinent           |
      | Alerte budget    | actionnable         |
      | Pattern détecté  | informatif          |

  @positive @budget-categories
  Scenario Outline: Affichage des catégories budgétaires
    When je consulte les catégories budgétaires
    Then je dois voir la catégorie "<categorie>"
    And je dois voir "<pourcentage>" pour cette catégorie
    And l'affichage doit correspondre au niveau d'utilisation

    Examples:
      | categorie    | pourcentage       |
      | Alimentation | 70.0% utilisé     |
      | Transport    | 93.3% utilisé     |
      | Loisirs      | 45.0% utilisé     |
      | Logement     | 85.0% utilisé     |

  @positive @bank-accounts
  Scenario Outline: Consultation des comptes bancaires
    When je consulte mes comptes bancaires
    Then je dois voir "🏦 Comptes bancaires"
    And je dois voir la banque "<banque>" avec le solde "<solde>"
    And je dois voir le statut de connexion "<statut>"

    Examples:
      | banque          | solde          | statut |
      | Crédit Agricole | 2 450,50 €     | actif  |
      | BNP Paribas     | 15 000,00 €    | actif  |
      | Revolut         | 320,75 €       | erreur |

  @positive @account-operations
  Scenario Outline: Opérations sur les comptes bancaires
    Given j'ai des comptes bancaires configurés
    When je clique sur "<operation>"
    Then "<action_attendue>"
    And "<resultat_operation>"

    Examples:
      | operation     | action_attendue                      | resultat_operation                           |
      | Synchroniser  | la synchronisation doit démarrer     | les soldes doivent être mis à jour          |
      | Actualiser    | les données doivent se rafraîchir    | l'horodatage doit être mis à jour           |
      | Détails       | les informations détaillées s'affichent | l'historique des transactions apparaît    |

  @negative @error-scenarios
  Scenario Outline: Gestion des erreurs financières
    Given "<condition_erreur>"
    When "<action_declenchante>"
    Then je dois voir "<message_erreur>"
    And "<action_corrective>"

    Examples:
      | condition_erreur                      | action_declenchante                | message_erreur                           | action_corrective                        |
      | un compte bancaire est indisponible   | je tente de synchroniser          | Erreur de synchronisation                | je dois pouvoir réessayer               |
      | mes données budgétaires sont corrompues | j'accède au tableau de bord      | Erreur de chargement des données         | je dois voir un bouton Restaurer        |
      | l'API de ma banque est hors service   | j'accède aux données de compte    | Service bancaire temporairement indisponible | les données en cache doivent s'afficher |

  @edge-case @budget-limits
  Scenario Outline: Tests des limites budgétaires
    Given ma catégorie "<categorie>" est à "<utilisation>" d'utilisation
    When j'ajoute une dépense de "<montant>"
    Then je dois voir "<alerte>"
    And la catégorie doit s'afficher en "<couleur>"

    Examples:
      | categorie  | utilisation | montant | alerte              | couleur |
      | Transport  | 93.3%       | 50€     | Budget dépassé      | rouge   |
      | Loisirs    | 45.0%       | 100€    | Attention budget    | orange  |
      | Alimentation | 70.0%     | 200€    | Budget largement dépassé | rouge |

  @edge-case @account-balances
  Scenario Outline: Gestion des soldes de compte particuliers
    Given un de mes comptes a un solde de "<solde>"
    When je consulte mes comptes
    Then le compte doit s'afficher avec "<affichage>"
    And je dois voir "<indicateur>"

    Examples:
      | solde    | affichage      | indicateur              |
      | 0€       | 0,00 €         | indicateur spécial      |
      | -150€    | Découvert: -150,00 € | alerte de découvert |
      | 1.50€    | 1,50 €         | solde faible            |

  @twisted-case @concurrent-operations
  Scenario Outline: Tests de concurrence et stress
    Given "<situation_complexe>"
    When "<action_simultanee>"
    Then "<gestion_attendue>"
    And les données doivent rester cohérentes

    Examples:
      | situation_complexe                    | action_simultanee                          | gestion_attendue                           |
      | je consulte mon budget sur deux appareils | je modifie des données simultanément     | les modifications doivent être préservées  |
      | l'IA génère des insights contradictoires | j'accède aux recommandations              | les options doivent être présentées clairement |
      | j'importe 10000 transactions         | l'application traite les données          | l'interface doit rester responsive         |

  @boundary @transaction-volumes
  Scenario Outline: Tests avec différents volumes de données
    Given j'ai "<volume>" transactions
    When j'accède aux données financières
    Then l'application doit traiter les données en "<temps>"
    And la performance doit être "<qualite>"

    Examples:
      | volume  | temps        | qualite      |
      | 100     | moins de 1s  | excellente   |
      | 1000    | moins de 3s  | bonne        |
      | 10000   | moins de 10s | acceptable   |
      | 50000   | moins de 30s | limite       |

  @performance @dashboard-metrics
  Scenario Outline: Performance du tableau de bord par métrique
    When j'accède à "<section>"
    Then "<element>" doit se charger en "<temps>"
    And l'interface doit rester fluide

    Examples:
      | section          | element           | temps        |
      | tableau de bord  | métriques principales | moins de 2s  |
      | graphiques       | tous les graphiques   | moins de 3s  |
      | insights IA      | recommandations       | moins de 5s  |
      | comptes bancaires | soldes actuels       | moins de 1s  |

  @security @data-protection
  Scenario Outline: Tests de sécurité par type de donnée
    Given mes données "<type_donnees>" sont stockées
    When je consulte mes informations
    Then "<protection_appliquee>"
    And aucune fuite ne doit se produire

    Examples:
      | type_donnees      | protection_appliquee                        |
      | bancaires         | toutes les données doivent être chiffrées  |
      | numéros de compte | les numéros doivent être masqués           |
      | transactions      | l'accès doit être contrôlé                 |
      | personnelles      | le stockage doit être sécurisé             |

  @accessibility @financial-a11y
  Scenario Outline: Accessibilité des données financières
    Given je navigue avec "<technologie>"
    When j'accède aux données budgétaires
    Then "<exigence_a11y>"
    And l'expérience doit être complète

    Examples:
      | technologie       | exigence_a11y                                 |
      | lecteur d'écran   | tous les montants doivent être annoncés clairement |
      | navigation clavier | tous les tableaux doivent être navigables    |
      | zoom 200%         | l'interface doit rester fonctionnelle        |
      | contraste élevé   | les couleurs doivent être distinguables      |

  @integration @multi-bank
  Scenario Outline: Intégration avec plusieurs institutions financières
    Given j'ai des comptes dans "<nombre>" banques différentes
    When je synchronise tous mes comptes
    Then toutes les données doivent être agrégées correctement
    And le total doit correspondre à "<precision>"

    Examples:
      | nombre | precision    |
      | 2      | centimes     |
      | 3      | centimes     |
      | 5      | centimes     |
      | 10     | euros        |

  @compliance @gdpr-scenarios
  Scenario Outline: Conformité RGPD par type de demande
    Given je veux exercer mon droit "<droit_gdpr>"
    When je fais la demande appropriée
    Then "<action_gdpr>" doit être effectuée
    And je dois recevoir "<confirmation>"

    Examples:
      | droit_gdpr           | action_gdpr                              | confirmation                    |
      | suppression          | toutes mes données doivent être effacées | confirmation de suppression     |
      | portabilité          | mes données doivent être exportées      | fichier de données personnelles |
      | rectification        | mes données doivent être corrigées      | confirmation de modification    |
      | accès                | mes données doivent être fournies       | rapport complet des données     |

  @automation @smart-categorization
  Scenario Outline: Catégorisation automatique intelligente
    Given une transaction de "<montant>" chez "<marchand>"
    When l'IA analyse la transaction
    Then elle doit la catégoriser en "<categorie_attendue>"
    And proposer "<action_intelligente>" avec un niveau de confiance "<confiance>"

    Examples:
      | montant | marchand          | categorie_attendue | action_intelligente        | confiance |
      | 45.60€  | Carrefour         | Alimentation       | aucune action requise      | 95%       |
      | 85.00€  | Station Essence   | Transport          | alerte budget approché     | 90%       |
      | 120.00€ | Restaurant        | Loisirs            | suggestion d'économie      | 85%       |
      | 1200.00€| Agence Immobilière| Logement           | vérification recommandée   | 70%       |

  @predictive @budget-forecasting
  Scenario Outline: Prédictions budgétaires intelligentes
    Given mes dépenses historiques de "<periode>"
    When j'active les prédictions pour "<mois_futur>"
    Then l'IA doit prédire "<prediction_depenses>"
    And me proposer "<recommandation_action>"

    Examples:
      | periode    | mois_futur | prediction_depenses | recommandation_action           |
      | 6 mois     | janvier    | dépassement 15%     | réduire loisirs de 100€         |
      | 12 mois    | février    | économies possibles | optimiser abonnements (-50€)   |
      | 3 mois     | mars       | budget équilibré    | maintenir habitudes actuelles  |
      | 24 mois    | avril      | inflation impact    | ajuster budget alimentation     |

  @advanced-analytics @spending-patterns
  Scenario Outline: Analyse avancée des patterns de dépenses
    Given mes transactions sur "<duree_analyse>"
    When je demande une analyse de patterns
    Then l'IA doit identifier "<pattern_detecte>"
    And suggérer "<optimisation>"

    Examples:
      | duree_analyse | pattern_detecte              | optimisation                    |
      | 3 mois        | pic de dépenses le vendredi  | planifier sorties en semaine   |
      | 6 mois        | abonnements non utilisés     | résiliation de 3 services      |
      | 12 mois       | achats impulsifs en ligne    | délai réflexion de 24h         |
      | 24 mois       | saisonnalité des dépenses    | épargne préventive été/hiver   |

  @real-time @alerts-system
  Scenario Outline: Système d'alertes en temps réel
    Given j'ai configuré des alertes pour "<type_alerte>"
    When "<declencheur>" se produit
    Then je dois recevoir une notification "<canal_notification>"
    And l'action proposée doit être "<action_recommandee>"

    Examples:
      | type_alerte        | declencheur              | canal_notification | action_recommandee         |
      | dépassement budget | dépense > seuil          | push + email       | bloquer carte temporairement |
      | transaction suspecte| montant inhabituel       | SMS + push         | confirmer transaction      |
      | opportunité épargne | solde élevé              | push               | virement épargne auto      |
      | échéance approche  | prélèvement dans 3j      | email              | vérifier solde suffisant   |

  @data-export @reporting
  Scenario Outline: Export de données et rapports personnalisés
    Given je veux exporter mes données "<type_donnees>"
    When je sélectionne la période "<periode>" et le format "<format>"
    Then l'export doit contenir "<contenu_inclus>"
    And respecter le format "<specifications_format>"

    Examples:
      | type_donnees   | periode    | format | contenu_inclus              | specifications_format  |
      | transactions   | 1 an       | CSV    | toutes transactions         | UTF-8, séparateur ;    |
      | budget         | 6 mois     | PDF    | graphiques + tableaux       | A4, couleur            |
      | comptes        | 3 mois     | Excel  | soldes + mouvements         | format XLSX standard   |
      | analytique     | 2 ans      | JSON   | données pour outils BI      | structure normalisée   |