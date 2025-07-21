@budgetcron @smoke
Feature: BudgetCron - Gestion de Budget
  En tant qu'utilisateur
  Je veux gérer mon budget
  Afin de contrôler mes finances

  Background:
    Given que je suis sur l'application BudgetCron

  @positive @critical
  Scenario: Affichage du tableau de bord
    When je visite la page d'accueil
    Then je vois le titre "BudgetCron"
    And je vois mes revenus actuels
    And je vois le total de mes dépenses
    And je vois le montant restant
    And je vois la répartition des dépenses

  @positive
  Scenario: Ajout d'une nouvelle dépense
    When je remplis le champ "Nouvelle catégorie" avec "Transport"
    And je remplis le champ "Montant" avec "150"
    And je clique sur "Ajouter"
    Then la nouvelle dépense apparaît dans la liste
    And le total des dépenses est mis à jour
    And le montant restant est recalculé

  @edge-case
  Scenario: Ajout d'une dépense avec montant zéro
    When je remplis le champ "Nouvelle catégorie" avec "Test"
    And je remplis le champ "Montant" avec "0"
    And je clique sur "Ajouter"
    Then je vois un message d'erreur approprié

  @negative
  Scenario: Ajout d'une dépense sans catégorie
    When je laisse le champ "Nouvelle catégorie" vide
    And je remplis le champ "Montant" avec "100"
    And je clique sur "Ajouter"
    Then je vois un message demandant de remplir tous les champs

  @visual @positive
  Scenario: Graphique de répartition des dépenses
    Given que j'ai des dépenses dans différentes catégories
    Then je vois un graphique de répartition
    And chaque catégorie a une couleur différente
    And les pourcentages sont corrects
