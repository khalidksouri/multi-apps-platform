@smoke @all-apps
Feature: Smoke Test - Toutes les Applications
  Vérification rapide que toutes les applications démarrent correctement

  @postmath @critical
  Scenario: Postmath - Application de calcul disponible
    Given que je suis sur l'application "Postmath"
    Then je vois le titre "Postmath"
    And je vois le message "Postmath API is running"
    And la page contient "Calculatrice"

  @unitflip @critical
  Scenario: UnitFlip - Convertisseur disponible
    Given que je suis sur l'application "UnitFlip"
    Then je vois le titre "UnitFlip"
    And la page contient "UnitFlip"
    And la page contient "Longueur"

  @budgetcron @critical
  Scenario: BudgetCron - Gestionnaire de budget disponible
    Given que je suis sur l'application "BudgetCron"
    Then je vois le titre "BudgetCron"
    And la page contient "Budget"
    And la page contient "Revenus"

  @ai4kids @critical
  Scenario: AI4Kids - Application éducative disponible
    Given que je suis sur l'application "AI4Kids"
    Then je vois le titre "AI4Kids"
    And je vois le message "Apprends en t'amusant"
    And la page contient "Mathématiques"

  @multiai @critical
  Scenario: MultiAI - Hub IA disponible
    Given que je suis sur l'application "MultiAI"
    Then je vois le titre "MultiAI"
    And la page contient "Intelligence Artificielle"
    And la page contient "Modèles"
