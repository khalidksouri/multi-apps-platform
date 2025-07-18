# language: fr
Fonctionnalité: Jeu de Mathématiques
  En tant qu'enfant
  Je veux jouer aux mathématiques
  Pour apprendre en m'amusant

  Scénario: Démarrer un jeu
    Quand je clique sur "Commencer"
    Alors je devrais voir une question de mathématiques
    Et le score devrait être à 0

  Scénario: Répondre à une question
    Étant donné que j'ai démarré un jeu
    Quand je clique sur une réponse
    Alors je devrais voir la question suivante ou le résultat final
