const express = require('express');
const auth = require('../../middleware/auth');
const router = express.Router();

router.post('/create-checkout', auth, async (req, res) => {
  try {
    const { planId, device } = req.body;
    const mockCheckoutUrl = `https://checkout.stripe.com/mock/${planId}`;
    res.json({ success: true, provider: 'stripe', checkoutUrl: mockCheckoutUrl, sessionId: `mock_session_${Date.now()}` });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
