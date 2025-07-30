#!/usr/bin/env node

// Générateur d'exercices mathématiques pour Math4Child - Niveaux 1-5

const levels = {
  niveau1: { range: [1, 20], operations: ['addition', 'subtraction'] },
  niveau2: { range: [1, 100], operations: ['addition', 'subtraction'] },
  niveau3: { range: [1, 100], operations: ['addition', 'subtraction', 'multiplication', 'division'] },
  niveau4: { range: [1, 1000], operations: ['addition', 'subtraction', 'multiplication', 'division'] },
  niveau5: { range: [1, 1000], operations: ['all'] }
};

function generateExercise(level, operation) {
  const config = levels[level];
  const [min, max] = config.range;
  
  const a = Math.floor(Math.random() * (max - min + 1)) + min;
  const b = Math.floor(Math.random() * (max - min + 1)) + min;
  
  switch(operation) {
    case 'addition':
      return { question: `${a} + ${b} = ?`, answer: a + b };
    case 'subtraction':
      return { question: `${Math.max(a,b)} - ${Math.min(a,b)} = ?`, answer: Math.max(a,b) - Math.min(a,b) };
    case 'multiplication':
      const smallA = Math.floor(Math.random() * 10) + 1;
      const smallB = Math.floor(Math.random() * 10) + 1;
      return { question: `${smallA} × ${smallB} = ?`, answer: smallA * smallB };
    case 'division':
      const divisor = Math.floor(Math.random() * 9) + 1;
      const quotient = Math.floor(Math.random() * 10) + 1;
      const dividend = divisor * quotient;
      return { question: `${dividend} ÷ ${divisor} = ?`, answer: quotient };
    default:
      return generateExercise(level, 'addition');
  }
}

// Générer un set d'exercices
function generateExerciseSet(level, count = 10) {
  const config = levels[level];
  if (!config) {
    console.error(`Niveau ${level} non reconnu. Niveaux disponibles: niveau1, niveau2, niveau3, niveau4, niveau5`);
    return [];
  }
  
  const exercises = [];
  
  for (let i = 0; i < count; i++) {
    const operation = config.operations[Math.floor(Math.random() * config.operations.length)];
    exercises.push({
      id: `${level}_${i + 1}`,
      ...generateExercise(level, operation),
      level,
      operation
    });
  }
  
  return exercises;
}

// Usage en ligne de commande
if (require.main === module) {
  const level = process.argv[2] || 'niveau1';
  const count = parseInt(process.argv[3]) || 10;
  
  console.log(`🎯 Génération de ${count} exercices pour le ${level.toUpperCase()}`);
  const exercises = generateExerciseSet(level, count);
  if (exercises.length > 0) {
    console.log(JSON.stringify(exercises, null, 2));
  }
}

module.exports = { generateExercise, generateExerciseSet };
