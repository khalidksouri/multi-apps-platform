@ai4kids @accessibility @a11y
Feature: AI4Kids - Accessibilité
  En tant qu'enfant avec des besoins spéciaux
  Je veux pouvoir utiliser l'application facilement
  Afin d'accéder au contenu éducatif

  @positive @critical
  Scenario: Navigation au clavier
    Given que je suis sur l'application AI4Kids
    When je navigue avec la touche Tab
    Then tous les éléments interactifs sont accessibles
    And l'ordre de navigation est logique

  @positive
  Scenario: Contraste des couleurs
    Given que je suis sur l'application AI4Kids
    Then tous les textes ont un contraste suffisant
    And les couleurs respectent les standards d'accessibilité

  @positive
  Scenario: Textes alternatifs
    Given que je suis sur l'application AI4Kids
    Then tous les éléments visuels ont des textes alternatifs
    And les emojis sont décrits correctement
