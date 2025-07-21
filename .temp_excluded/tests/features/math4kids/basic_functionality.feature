# language: fr
Fonctionnalité: Fonctionnalité de base de math4kids
  En tant qu'utilisateur
  Je veux utiliser math4kids
  Pour accomplir mes tâches

  Contexte:
    Étant donné que je visite l'application math4kids sur le port 3001
    Et que l'application est chargée

  Scénario: L'application se charge correctement
    Alors je devrais voir l'interface principale
    Et tous les éléments de base devraient être visibles

  Scénario: Changement de langue
    Quand je change la langue vers "English"
    Alors l'interface devrait être en anglais
    Et l'application devrait fonctionner normalement

  Scénario: Interface responsive
    Quand je redimensionne la fenêtre en mode mobile
    Alors l'interface devrait s'adapter
    Et tous les éléments devraient rester utilisables

  Scénario: Test d'accessibilité de base
    Alors l'application devrait être accessible au clavier
    Et avoir des contrastes suffisants
    Et des labels appropriés pour les lecteurs d'écran
