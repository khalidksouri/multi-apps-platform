const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true, lowercase: true },
  password: { type: String, required: true, minlength: 6 },
  name: { type: String, required: true },
  subscription: {
    type: { type: String, enum: ['free', 'monthly', 'quarterly', 'yearly'], default: 'free' },
    startDate: Date,
    endDate: Date,
    devices: [{ type: String, enum: ['web', 'android', 'ios'] }],
    stripeCustomerId: String,
    stripeSubscriptionId: String
  },
  progress: {
    currentLevel: { type: String, enum: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'], default: 'beginner' },
    correctAnswers: {
      beginner: { type: Number, default: 0 },
      elementary: { type: Number, default: 0 },
      intermediate: { type: Number, default: 0 },
      advanced: { type: Number, default: 0 },
      expert: { type: Number, default: 0 }
    },
    unlockedLevels: [{ type: String, enum: ['beginner', 'elementary', 'intermediate', 'advanced', 'expert'] }],
    totalQuestions: { type: Number, default: 0 },
    freeQuestionsUsed: { type: Number, default: 0 }
  },
  preferences: {
    language: { type: String, default: 'fr' },
    timezone: String,
    notifications: { type: Boolean, default: true }
  }
}, { timestamps: true });

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 12);
  next();
});

userSchema.methods.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

userSchema.methods.isLevelUnlocked = function(level) {
  return this.progress.unlockedLevels.includes(level);
};

userSchema.methods.unlockLevel = function(level) {
  if (!this.progress.unlockedLevels.includes(level)) {
    this.progress.unlockedLevels.push(level);
  }
};

module.exports = mongoose.model('User', userSchema);
