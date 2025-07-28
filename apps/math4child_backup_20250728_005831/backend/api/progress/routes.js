const express = require('express');
const auth = require('../../middleware/auth');
const router = express.Router();

router.get('/stats', auth, async (req, res) => {
  try {
    const user = req.user;
    const totalCorrect = Object.values(user.progress.correctAnswers).reduce((sum, count) => sum + count, 0);
    const accuracy = user.progress.totalQuestions > 0 ? (totalCorrect / user.progress.totalQuestions) * 100 : 0;
    
    res.json({
      totalQuestions: user.progress.totalQuestions, totalCorrect, accuracy: Math.round(accuracy),
      currentLevel: user.progress.currentLevel, unlockedLevels: user.progress.unlockedLevels,
      levelProgress: user.progress.correctAnswers,
      subscription: { type: user.subscription.type, freeQuestionsRemaining: Math.max(0, 50 - user.progress.freeQuestionsUsed) }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
