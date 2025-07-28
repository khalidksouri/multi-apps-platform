const express = require('express');
const auth = require('../../middleware/auth');
const router = express.Router();

router.get('/profile', auth, async (req, res) => {
  try {
    const user = req.user;
    res.json({
      id: user._id, email: user.email, name: user.name,
      progress: user.progress, subscription: user.subscription, preferences: user.preferences
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
