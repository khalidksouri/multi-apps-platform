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
  Scenario: Consultation des insights IA
    When je consulte la section insights
    Then je dois voir "🧠 Insights IA"
    And je dois voir "Économie détectée"
    And je dois voir "Alerte budget"
    And je dois voir "Pattern détecté"
    And chaque insight doit être pertinent et actionnable

  @positive @budget-categories
  Scenario: Affichage des catégories de budget
    When je consulte les catégories budgétaires
    Then je dois voir la catégorie "Alimentation"
    And je dois voir la catégorie "Transport"
    And je dois voir la catégorie "Loisirs"
    And je dois voir la catégorie "Logement"
    And je dois voir "70.0% utilisé" pour l'alimentation
    And je dois voir "93.3% utilisé" pour le transport

  @positive @bank-accounts
  Scenario: Consultation des comptes bancaires
    When je consulte mes comptes bancaires
    Then je dois voir "🏦 Comptes bancaires"
    And je dois voir "Crédit Agricole" avec le solde "2 450,50 €"
    And je dois voir "BNP Paribas" avec le solde "15 000,00 €"
    And je dois voir "Revolut" avec le solde "320,75 €"
    And chaque compte doit afficher son statut de connexion

  @positive @account-status
  Scenario: Vérification des statuts de connexion bancaire
    When je vérifie les statuts des comptes
    Then je dois voir des indicateurs de statut colorés
    And je dois voir au moins un statut "actif" (point vert)
    And je dois voir au moins un statut "erreur" (point rouge)
    And les statuts doivent être mis à jour en temps réel

  @positive @account-sync
  Scenario: Synchronisation des comptes bancaires
    Given j'ai des comptes bancaires configurés
    When je clique sur le bouton "Synchroniser"
    Then la synchronisation doit démarrer
    And je dois voir un indicateur de progression
    And les soldes doivent être mis à jour après synchronisation

  @negative @sync-failure
  Scenario: Échec de synchronisation bancaire
    Given un compte bancaire est temporairement indisponible
    When je tente de synchroniser
    Then je dois voir "Erreur de synchronisation"
    And le compte en erreur doit être identifié
    And je dois pouvoir réessayer la synchronisation

  @negative @invalid-budget-data
  Scenario: Données budgétaires corrompues
    Given mes données budgétaires sont corrompues
    When j'accède au tableau de bord
    Then je dois voir "Erreur de chargement des données"
    And je dois voir un bouton "Restaurer les données"
    And l'application ne doit pas crasher

  @negative @bank-api-down
  Scenario: API bancaire indisponible
    Given l'API de ma banque est hors service
    When je tente d'accéder aux données de compte
    Then je dois voir "Service bancaire temporairement indisponible"
    And les données mises en cache doivent être affichées
    And je dois être informé de la dernière mise à jour

  @edge-case @budget-limit-exceeded
  Scenario: Dépassement de budget dans une catégorie
    Given ma catégorie "Transport" est à 93.3% d'utilisation
    When j'ajoute une dépense qui dépasse le budget
    Then je dois voir une alerte "Budget dépassé"
    And la catégorie doit s'afficher en rouge
    And je dois recevoir une recommandation d'ajustement

  @edge-case @zero-balance
  Scenario: Compte avec solde nul
    Given un de mes comptes a un solde de 0€
    When je consulte mes comptes
    Then le compte doit s'afficher avec "0,00 €"
    And il doit avoir un indicateur visuel spécial
    And je dois voir un avertissement approprié

  @edge-case @negative-balance
  Scenario: Compte avec solde négatif
    Given un compte a un découvert autorisé
    When le solde devient négatif
    Then je dois voir le solde en rouge
    And je dois voir "Découvert: -150,00 €"
    And je dois recevoir une alerte de découvert

  @twisted-case @concurrent-updates
  Scenario: Mises à jour simultanées de données
    Given je consulte mon budget sur deux appareils
    When je modifie des données sur le premier appareil
    And simultanément je modifie d'autres données sur le second
    Then les deux modifications doivent être préservées
    And les données doivent être synchronisées correctement
    And aucune donnée ne doit être perdue

  @twisted-case @ai-insight-conflict
  Scenario: Insights IA contradictoires
    Given l'IA génère des insights contradictoires
    When j'accède aux recommandations
    Then l'application doit détecter la contradiction
    And me présenter les options de manière claire
    And me permettre de choisir la stratégie appropriée

  @twisted-case @massive-transaction-load
  Scenario: Chargement d'un grand nombre de transactions
    Given j'importe 10000 transactions d'un coup
    When l'application traite les données
    Then l'interface doit rester responsive
    And les calculs doivent être corrects
    And la mémoire ne doit pas exploser

  @performance @dashboard-loading
  Scenario: Performance du tableau de bord
    When j'accède au tableau de bord
    Then toutes les métriques doivent se charger en moins de 2 secondes
    And les graphiques doivent s'afficher rapidement
    And l'interface doit rester fluide pendant les calculs

  @security @data-encryption
  Scenario: Chiffrement des données bancaires
    Given mes données bancaires sont stockées
    When je consulte mes informations
    Then toutes les données sensibles doivent être chiffrées
    And les numéros de compte doivent être masqués
    And aucune information ne doit fuiter dans les logs

  @accessibility @financial-a11y
  Scenario: Accessibilité des données financières
    Given je navigue avec un lecteur d'écran
    When j'accède aux données budgétaires
    Then tous les montants doivent être annoncés clairement
    And les statuts doivent être décrits vocalement
    And je peux naviguer au clavier dans tous les tableaux

  @integration @multi-bank
  Scenario: Intégration avec plusieurs banques
    Given j'ai des comptes dans 5 banques différentes
    When je synchronise tous mes comptes
    Then toutes les données doivent être agrégées correctement
    And le total doit être exact
    And chaque banque doit conserver ses spécificités

  @compliance @gdpr
  Scenario: Conformité RGPD
    Given je veux supprimer mes données
    When je demande la suppression de compte
    Then toutes mes données personnelles doivent être effacées
    And les données financières doivent être anonymisées
    And je dois recevoir une confirmation de suppression