const express = require('express');
const ExerciseGenerator = require('../../utils/exerciseGenerator');
const auth = require('../../middleware/auth');
const router = express.Router();

router.post('/generate', auth, async (req, res) => {
  try {
    const { type, level, count = 10 } = req.body;
    const user = req.user;

    if (!user.isLevelUnlocked(level)) {
      return res.status(403).json({ error: 'Niveau non débloqué' });
    }

    if (user.subscription.type === 'free' && user.progress.freeQuestionsUsed >= 50) {
      return res.status(403).json({ error: 'Limite de questions gratuites atteinte', upgradeRequired: true });
    }

    const exercises = ExerciseGenerator.generateSession(type, level, count);
    res.json({ exercises, sessionId: Date.now(), metadata: { type, level, count: exercises.length } });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/validate', auth, async (req, res) => {
  try {
    const { exerciseData, userAnswer } = req.body;
    const user = req.user;
    
    const isCorrect = parseInt(userAnswer) === exerciseData.question.correctAnswer;
    
    user.progress.totalQuestions += 1;
    if (user.subscription.type === 'free') user.progress.freeQuestionsUsed += 1;

    if (isCorrect) {
      user.progress.correctAnswers[exerciseData.level] += 1;
      
      if (user.progress.correctAnswers[exerciseData.level] >= 100) {
        const levels = ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'];
        const currentIndex = levels.indexOf(exerciseData.level);
        if (currentIndex < levels.length - 1) {
          user.unlockLevel(levels[currentIndex + 1]);
        }
      }
    }

    await user.save();

    res.json({
      correct: isCorrect,
      correctAnswer: exerciseData.question.correctAnswer,
      explanation: exerciseData.metadata.explanation,
      progress: user.progress,
      levelProgress: {
        current: user.progress.correctAnswers[exerciseData.level],
        required: 100,
        percentage: Math.min((user.progress.correctAnswers[exerciseData.level] / 100) * 100, 100)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
