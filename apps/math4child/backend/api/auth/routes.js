const express = require('express');
const jwt = require('jsonwebtoken');
const User = require('../../models/User');
const router = express.Router();

router.post('/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;
    
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'Utilisateur déjà existant' });
    }

    const user = new User({
      email, password, name,
      progress: { unlockedLevels: ['beginner'] }
    });
    await user.save();

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });
    
    res.status(201).json({
      token,
      user: { id: user._id, email: user.email, name: user.name, progress: user.progress }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    
    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ error: 'Identifiants invalides' });
    }

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET || 'secret_key', { expiresIn: '7d' });
    
    res.json({
      token,
      user: { id: user._id, email: user.email, name: user.name, progress: user.progress, subscription: user.subscription }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
