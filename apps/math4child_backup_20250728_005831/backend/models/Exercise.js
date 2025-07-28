const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['addition', 'subtraction', 'multiplication', 'division', 'mixed'],
    required: true
  },
  level: {
    type: String,
    enum: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'],
    required: true
  },
  question: {
    num1: { type: Number, required: true },
    num2: { type: Number, required: true },
    operator: { type: String, required: true },
    correctAnswer: { type: Number, required: true }
  },
  difficulty: {
    type: Number,
    min: 1,
    max: 10,
    required: true
  },
  metadata: {
    estimatedTime: Number, // en secondes
    hints: [String],
    explanation: String
  }
}, {
  timestamps: true
});

// Index pour améliorer les performances
exerciseSchema.index({ type: 1, level: 1, difficulty: 1 });

module.exports = mongoose.model('Exercise', exerciseSchema);
