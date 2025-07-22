          <motion.p 
            className="text-xl md:text-2xl text-gray-600 mb-4 max-w-4xl mx-auto"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.3, duration: 0.8 }}
          >
            {t.subtitle}
          </motion.p>
          <motion.p 
            className="text-lg text-gray-500 mb-12 max-w-3xl mx-auto"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.5, duration: 0.8 }}
          >
            {t.heroDescription}
          </motion.p>

          {/* Statistiques */}
          <motion.div 
            className="grid grid-cols-2 md:grid-cols-4 gap-6 mb-16"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7, duration: 0.8 }}
          >
            {[
              { value: '10K+', label: t.stats.students, icon: Users, color: 'from-blue-500 to-blue-700' },
              { value: '500+', label: t.stats.exercises, icon: Target, color: 'from-green-500 to-green-700' },
              { value: '20', label: t.stats.languages, icon: Globe, color: 'from-purple-500 to-purple-700' },
              { value: '98%', label: t.stats.satisfaction, icon: Heart, color: 'from-yellow-500 to-orange-500' }
            ].map((stat, index) => (
              <motion.div
                key={index}
                className="group p-6 bg-white/80 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300"
                whileHover={{ y: -8, scale: 1.02 }}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.8 + index * 0.1 }}
              >
                <div className={`text-3xl font-bold bg-gradient-to-r ${stat.color} bg-clip-text text-transparent mb-2`}>
                  {stat.value}
                </div>
                <div className="text-sm text-gray-600 flex items-center gap-2">
                  <stat.icon className="w-4 h-4" />
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </motion.div>

          {/* Sélection des Niveaux */}
          <motion.div 
            className="mb-16"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1, duration: 0.8 }}
          >
            <h2 className="text-3xl font-bold text-gray-800 mb-8">{t.game.selectLevel}</h2>
            <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
              {(['beginner', 'elementary', 'intermediate', 'advanced', 'expert'] as Level[]).map((level, index) => {
                const isUnlocked = userProgress.unlockedLevels.includes(level)
                const progress = userProgress.correctAnswers[level]
                const LevelIcon = [Brain, BookOpen, Zap, Rocket, GraduationCap][index]
                
                return (
                  <motion.div
                    key={level}
                    className={`relative p-6 rounded-2xl shadow-lg transition-all duration-300 cursor-pointer ${
                      isUnlocked 
                        ? 'bg-white/90 hover:shadow-xl' 
                        : 'bg-gray-100/50 cursor-not-allowed opacity-60'
                    }`}
                    whileHover={isUnlocked ? { y: -5, scale: 1.03 } : {}}
                    whileTap={isUnlocked ? { scale: 0.98 } : {}}
                    onClick={() => isUnlocked && setSelectedLevel(level)}
                    initial={{ opacity: 0, y: 30 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 1.2 + index * 0.1 }}
                  >
                    <div className={`p-3 rounded-xl mx-auto w-fit mb-4 ${
                      isUnlocked ? 'bg-gradient-to-r from-blue-500 to-purple-600' : 'bg-gray-400'
                    }`}>
                      {isUnlocked ? (
                        <LevelIcon className="w-8 h-8 text-white" />
                      ) : (
                        <Lock className="w-8 h-8 text-white" />
                      )}
                    </div>
                    
                    <h3 className="font-bold text-gray-800 mb-2">{t.levels[level]}</h3>
                    <div className="text-sm text-gray-600 mb-3">
                      {progress}/100 ✓
                    </div>
                    
                    {/* Barre de progression */}
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <motion.div 
                        className={`h-2 rounded-full ${
                          isUnlocked ? 'bg-gradient-to-r from-blue-500 to-purple-600' : 'bg-gray-400'
                        }`}
                        initial={{ width: 0 }}
                        animate={{ width: `${Math.min((progress / 100) * 100, 100)}%` }}
                        transition={{ delay: 1.5 + index * 0.1, duration: 1 }}
                      />
                    </div>
                  </motion.div>
                )
              })}
            </div>
          </motion.div>

          {/* Sélection des Opérations */}
          <AnimatePresence>
            {selectedLevel && (
              <motion.div 
                className="mb-16"
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                exit={{ opacity: 0, height: 0 }}
                transition={{ duration: 0.5 }}
              >
                <h2 className="text-3xl font-bold text-gray-800 mb-8">{t.game.selectOperation}</h2>
                <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                  {(['addition', 'subtraction', 'multiplication', 'division', 'mixed'] as MathOperation[]).map((operation, index) => {
                    const OperationIcon = [Plus, Minus, X, Divide, MoreHorizontal][index]
                    
                    return (
                      <motion.button
                        key={operation}
                        onClick={() => startGame(selectedLevel, operation)}
                        className="p-6 bg-white/90 backdrop-blur-lg rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300"
                        whileHover={{ y: -5, scale: 1.05 }}
                        whileTap={{ scale: 0.98 }}
                        initial={{ opacity: 0, scale: 0.8 }}
                        animate={{ opacity: 1, scale: 1 }}
                        transition={{ delay: 0.2 + index * 0.1 }}
                      >
                        <div className="p-3 bg-gradient-to-r from-green-500 to-emerald-600 rounded-xl mx-auto w-fit mb-4">
                          <OperationIcon className="w-8 h-8 text-white" />
                        </div>
                        <h3 className="font-bold text-gray-800">{t.operations[operation]}</h3>
                      </motion.button>
                    )
                  })}
                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Call to Action */}
          <motion.div 
            className="space-y-6 md:space-y-0 md:space-x-6 md:flex md:justify-center md:items-center"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.8, duration: 0.8 }}
          >
            <motion.button
              onClick={() => setCurrentView('subscribe')}
              className="group px-10 py-4 bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 text-white rounded-2xl font-bold transition-all duration-300 shadow-2xl relative overflow-hidden"
              whileHover={{ scale: 1.05, y: -2 }}
              whileTap={{ scale: 0.98 }}
            >
              <span className="relative z-10 flex items-center gap-2">
                <Crown className="w-5 h-5" />
                {subscriptionStatus.isSubscribed ? 'Gérer l\'abonnement' : 'S\'abonner maintenant'}
              </span>
            </motion.button>
            
            <motion.button 
              onClick={() => {
                if (canPlayFree()) {
                  startGame('beginner', 'addition')
                } else {
                  setCurrentView('subscribe')
                }
              }}
              className="group px-10 py-4 border-2 border-gray-300 text-gray-700 rounded-2xl font-bold hover:border-blue-400 hover:bg-blue-50 hover:text-blue-600 transition-all duration-300"
              whileHover={{ scale: 1.05, y: -2 }}
              whileTap={{ scale: 0.98 }}
            >
              <span className="flex items-center gap-2">
                <Play className="w-5 h-5" />
                {canPlayFree() ? 'Essai Gratuit' : 'Voir les Plans'}
              </span>
            </motion.button>
          </motion.div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 text-center text-gray-500 bg-white/30 backdrop-blur-sm">
        <p className="flex items-center justify-center space-x-2">
          <span>&copy; 2024 {t.appName}.</span>
          <span>Made with</span>
          <Heart className="w-4 h-4 text-red-500 animate-pulse" />
          <span>for children worldwide.</span>
        </p>
        <div className="mt-2 text-sm">
          <span>🌍 www.math4child.com</span>
        </div>
      </footer>
    </div>
  )

  // COMPOSANT VUE JEU
  function GameView() {
    if (!gameState.currentProblem) return null
    
    return (
      <div className="min-h-screen bg-gradient-to-br from-green-50 via-blue-50 to-purple-50 p-4 md:p-8">
        <div className="max-w-4xl mx-auto">
          {/* Header du jeu */}
          <div className="flex justify-between items-center mb-8">
            <motion.button 
              onClick={() => setCurrentView('home')} 
              className="flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <ArrowLeft className="w-4 h-4" />
              {t.common.back}
            </motion.button>
            
            <div className="flex gap-4 text-sm">
              <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
                <span className="font-semibold text-purple-600">
                  {t.levels[selectedLevel]} - {t.operations[selectedOperation]}
                </span>
              </div>
              <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
                <span className="font-semibold text-green-600">
                  {t.game.progress
                    .replace('{current}', userProgress.correctAnswers[selectedLevel].toString())
                    .replace('{required}', '100')}
                </span>
              </div>
              <div className="bg-white/80 backdrop-blur px-4 py-2 rounded-xl">
                <span className="font-semibold text-blue-600">
                  {t.game.streak.replace('{count}', gameState.streak.toString())} 🔥
                </span>
              </div>
            </div>
          </div>
          
          <div className="text-center">
            <motion.div 
              className="bg-white/90 backdrop-blur-lg rounded-3xl shadow-2xl p-8 md:p-12 mb-8 max-w-2xl mx-auto"
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ duration: 0.5 }}
            >
              {/* Problème mathématique */}
              <motion.div 
                className="text-5xl md:text-6xl font-bold text-gray-800 mb-8 font-mono"
                key={gameState.currentProblem.num1 + gameState.currentProblem.operation + gameState.currentProblem.num2}
                initial={{ y: -20, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ duration: 0.5 }}
              >
                {gameState.currentProblem.num1} {gameState.currentProblem.operation} {gameState.currentProblem.num2} = ?
              </motion.div>
              
              {/* Zone de feedback */}
              <AnimatePresence>
                {gameState.feedback.type && (
                  <motion.div 
                    initial={{ scale: 0, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    exit={{ scale: 0, opacity: 0 }}
                    className={`mb-6 p-4 rounded-2xl font-semibold text-lg flex items-center justify-center gap-3 ${
                      gameState.feedback.type === 'correct' 
                        ? 'bg-green-100 text-green-700 border-2 border-green-300' 
                        : 'bg-red-100 text-red-700 border-2 border-red-300'
                    }`}
                  >
                    {gameState.feedback.type === 'correct' ? (
                      <Check className="w-6 h-6" />
                    ) : (
                      <X className="w-6 h-6" />
                    )}
                    {gameState.feedback.message}
                  </motion.div>
                )}
              </AnimatePresence>
              
              {/* Input pour la réponse */}
              <div className="mb-8">
                <motion.input
                  type="text"
                  inputMode="numeric"
                  value={gameState.userAnswer}
                  onChange={(e) => setGameState(prev => ({
                    ...prev,
                    userAnswer: e.target.value.replace(/[^0-9-]/g, '')
                  }))}
                  onKeyPress={(e) => {
                    if (e.key === 'Enter' && gameState.userAnswer.trim()) {
                      validateAnswer()
                    }
                  }}
                  placeholder={t.game.placeholder}
                  className="w-full max-w-sm mx-auto text-3xl font-bold text-center p-4 border-2 border-gray-300 rounded-2xl focus:border-blue-500 focus:outline-none transition-colors bg-white"
                  disabled={gameState.feedback.type === 'correct'}
                  whileFocus={{ scale: 1.02 }}
                />
              </div>
              
              {/* Boutons d'action */}
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <motion.button
                  onClick={validateAnswer}
                  disabled={!gameState.userAnswer.trim() || gameState.feedback.type === 'correct'}
                  className={`px-8 py-4 rounded-2xl font-bold text-white transition-all duration-300 ${
                    !gameState.userAnswer.trim() || gameState.feedback.type === 'correct'
                      ? 'bg-gray-400 cursor-not-allowed'
                      : 'bg-gradient-to-r from-blue-500 to-purple-600 hover:from-purple-600 hover:to-blue-500 shadow-xl'
                  }`}
                  whileHover={gameState.userAnswer.trim() && gameState.feedback.type !== 'correct' ? { scale: 1.05 } : {}}
                  whileTap={gameState.userAnswer.trim() && gameState.feedback.type !== 'correct' ? { scale: 0.98 } : {}}
                >
                  {t.game.validate}
                </motion.button>
                
                <motion.button
                  onClick={() => {
                    const newProblem = generateProblem(selectedLevel, selectedOperation)
                    setGameState(prev => ({
                      ...prev,
                      currentProblem: newProblem,
                      userAnswer: '',
                      isAnswered: false,
                      isCorrect: null,
                      feedback: { type: null, message: '' }
                    }))
                  }}
                  className="px-8 py-4 bg-gradient-to-r from-green-500 to-green-600 text-white rounded-2xl font-bold hover:from-green-600 hover:to-green-700 transition-all duration-300 shadow-xl"
                  whileHover={{ scale: 1.05 }}
                  whileTap={{ scale: 0.98 }}
                >
                  {t.game.nextProblem}
                </motion.button>
              </div>
            </motion.div>
          </div>
        </div>
      </div>
    )
  }

  // COMPOSANT VUE ABONNEMENT
  function SubscriptionView() {
    const [selectedDevice, setSelectedDevice] = useState<DeviceType>('web')
    const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan>('quarterly')
    
    const calculatePrice = (basePrice: number, planId: SubscriptionPlan) => {
      let finalPrice = basePrice
      
      // Réductions multi-appareils simulées
      if (subscriptionStatus.devices.length === 1) {
        finalPrice = basePrice * 0.5 // 50% de réduction pour le 2ème appareil
      } else if (subscriptionStatus.devices.length >= 2) {
        finalPrice = basePrice * 0.25 // 75% de réduction pour le 3ème appareil
      }
      
      return finalPrice
    }
    
    const plans = [
      {
        id: 'free' as SubscriptionPlan,
        name: t.subscription.plans.free.name,
        price: '0€',
        duration: t.subscription.plans.free.duration,
        features: t.subscription.plans.free.features,
        color: 'gray',
        popular: false
      },
      {
        id: 'monthly' as SubscriptionPlan,
        name: t.subscription.plans.monthly.name,
        price: '9,99€',
        duration: t.subscription.plans.monthly.duration,
        features: t.subscription.plans.monthly.features,
        color: 'blue',
        popular: false
      },
      {
        id: 'quarterly' as SubscriptionPlan,
        name: t.subscription.plans.quarterly.name,
        price: '26,97€',
        originalPrice: '29,97€',
        duration: t.subscription.plans.quarterly.duration,
        features: t.subscription.plans.quarterly.features,
        color: 'purple',
        popular: true,
        badge: '10% OFF'
      },
      {
        id: 'yearly' as SubscriptionPlan,
        name: t.subscription.plans.yearly.name,
        price: '83,93€',
        originalPrice: '119,88€',
        duration: t.subscription.plans.yearly.duration,
        features: t.subscription.plans.yearly.features,
        color: 'emerald',
        popular: false,
        badge: '30% OFF'
      }
    ]
    
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-50 via-pink-50 to-blue-50 p-4 md:p-8">
        <div className="max-w-7xl mx-auto">
          {/* Header */}
          <div className="flex justify-between items-center mb-8">
            <motion.button 
              onClick={() => setCurrentView('home')} 
              className="flex items-center gap-2 px-6 py-3 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition-colors"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <ArrowLeft className="w-4 h-4" />
              {t.common.back}
            </motion.button>
            
            <div className="flex items-center gap-3 text-sm text-gray-600">
              <Shield className="w-4 h-4 text-green-600" />
              <span>100% secure payment</span>
            </div>
          </div>
          
          {/* Titre */}
          <motion.div 
            className="text-center mb-12"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
          >
            <div className="flex items-center justify-center gap-3 mb-6">
              <div className="p-3 bg-gradient-to-r from-purple-500 to-pink-600 rounded-2xl">
                <CreditCard className="w-8 h-8 text-white" />
              </div>
              <h1 className="text-4xl md:text-5xl font-bold text-gray-800">
                {t.subscription.title}
              </h1>
            </div>
            <p className="text-xl text-gray-600 mb-4">{t.subscription.subtitle}</p>
            <p className="text-sm text-gray-500">
              {t.subscription.deviceDisclaimer.replace('{device}', t.subscription.multiDevice.devices[selectedDevice])}
            </p>
          </motion.div>

          {/* Sélecteur d'appareil */}
          <motion.div 
            className="flex justify-center mb-12"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <div className="bg-white/80 backdrop-blur rounded-xl p-2 flex gap-2">
              {(['web', 'android', 'ios'] as DeviceType[]).map((device) => (
                <motion.button
                  key={device}
                  onClick={() => setSelectedDevice(device)}
                  className={`px-6 py-3 rounded-lg font-semibold transition-all duration-200 ${
                    selectedDevice === device
                      ? 'bg-blue-600 text-white shadow-lg'
                      : 'text-gray-600 hover:bg-blue-50'
                  }`}
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                >
                  {t.subscription.multiDevice.devices[device]}
                </motion.button>
              ))}
            </div>
          </motion.div>

          {/* Plans d'abonnement */}
          <motion.div 
            className="grid md:grid-cols-4 gap-6 mb-12"
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
          >
            {plans.map((plan, index) => (
              <motion.div
                key={plan.id}
                className={`bg-white/90 backdrop-blur-lg rounded-3xl shadow-xl p-6 relative transition-all duration-300 ${
                  plan.popular 
                    ? 'border-4 border-purple-500 scale-105' 
                    : 'hover:scale-102'
                }`}
                initial={{ opacity: 0, y: 30 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.5 + index * 0.1 }}
                whileHover={{ y: -5 }}
              >
                {plan.popular && (
                  <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                    <div className="bg-gradient-to-r from-purple-500 to-pink-500 text-white px-4 py-1 rounded-full text-sm font-bold flex items-center gap-1">
                      <Crown className="w-4 h-4" />
                      POPULAIRE
                    </div>
                  </div>
                )}
                
                {plan.badge && (
                  <div className="absolute -top-2 -right-2">
                    <div className="bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold">
                      {plan.badge}
                    </div>
                  </div>
                )}

                <div className="text-center">
                  <h3 className="text-xl font-bold text-gray-800 mb-4">{plan.name}</h3>
                  <div className="mb-6">
                    <span className={`text-3xl font-bold text-${plan.color}-600`}>
                      {plan.price}
                    </span>
                    {plan.originalPrice && (
                      <div className="text-sm text-gray-500 line-through">
                        {plan.originalPrice}
                      </div>
                    )}
                    <div className="text-gray-500 text-sm">{plan.duration}</div>
                  </div>
                  <ul className="text-left space-y-2 mb-6 text-sm">
                    {plan.features.map((feature: string, featureIndex: number) => (
                      <li key={featureIndex} className="flex items-center gap-2">
                        <Check className={`w-4 h-4 text-${plan.color}-500 flex-shrink-0`} />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  <motion.button 
                    className={`w-full py-3 bg-${plan.color}-600 hover:bg-${plan.color}-700 text-white rounded-xl font-semibold transition-colors`}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    {plan.id === 'free' ? t.common.start : 'S\'abonner'}
                  </motion.button>
                </div>
              </motion.div>
            ))}
          </motion.div>

          {/* Section multi-appareils */}
          <motion.div 
            className="bg-gradient-to-r from-blue-50 to-purple-50 rounded-2xl p-6 mb-8"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.8 }}
          >
            <h3 className="text-xl font-bold text-gray-800 mb-4">{t.subscription.multiDevice.title}</h3>
            <div className="grid md:grid-cols-2 gap-4">
              <div className="flex items-center gap-3 p-4 bg-white/60 rounded-xl">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <span>{t.subscription.multiDevice.secondDevice}</span>
              </div>
              <div className="flex items-center gap-3 p-4 bg-white/60 rounded-xl">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <span>{t.subscription.multiDevice.thirdDevice}</span>
              </div>
            </div>
          </motion.div>
        </div>
      </div>
    )
  }
}
EOF
    
    print_success "Application principale générée"
}

# Génération des styles globaux
generate_global_styles() {
    print_step "Génération des styles globaux..."
    
    cat > "$APP_DIR/src/styles/globals.css" << 'EOF'
@import 'tailwindcss/base';
@import 'tailwindcss/components';
@import 'tailwindcss/utilities';

/* Styles globaux Math4Child */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700;800&display=swap');

:root {
  --font-inter: 'Inter', system-ui, sans-serif;
  --font-poppins: 'Poppins', system-ui, sans-serif;
  
  /* Couleurs Math4Child */
  --math4child-primary: #3b82f6;
  --math4child-secondary: #8b5cf6;
  --math4child-success: #10b981;
  --math4child-warning: #f59e0b;
  --math4child-error: #ef4444;
  
  /* Animations personnalisées */
  --animation-bounce-slow: bounce 2s infinite;
  --animation-pulse-slow: pulse 3s infinite;
  --animation-wiggle: wiggle 1s ease-in-out infinite;
}

* {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  max-width: 100vw;
  overflow-x: hidden;
  font-family: var(--font-inter);
  scroll-behavior: smooth;
}

body {
  color: #1f2937;
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 50%, #f3e8ff 100%);
  min-height: 100vh;
}

a {
  color: inherit;
  text-decoration: none;
}

/* Support RTL */
[dir="rtl"] {
  direction: rtl;
}

[dir="rtl"] .space-x-2 > :not([hidden]) ~ :not([hidden]) {
  --tw-space-x-reverse: 1;
  margin-right: calc(0.5rem * var(--tw-space-x-reverse));
  margin-left: calc(0.5rem * calc(1 - var(--tw-space-x-reverse)));
}

/* Animations personnalisées */
@keyframes wiggle {
  0%, 100% { transform: rotate(-3deg); }
  50% { transform: rotate(3deg); }
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes celebrate {
  0% { transform: scale(1); }
  50% { transform: scale(1.2); }
  100% { transform: scale(1); }
}

@keyframes bounce-in {
  0% { transform: scale(0.3); opacity: 0; }
  50% { transform: scale(1.05); }
  70% { transform: scale(0.9); }
  100% { transform: scale(1); opacity: 1; }
}

@keyframes slide-up {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes pulse-ring {
  0% {
    transform: scale(.33);
    opacity: 1;
  }
  80%, 100% {
    transform: scale(1);
    opacity: 0;
  }
}

/* Classes utilitaires personnalisées */
.animate-wiggle {
  animation: wiggle 1s ease-in-out infinite;
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

.animate-celebrate {
  animation: celebrate 0.6s ease-out;
}

.animate-bounce-in {
  animation: bounce-in 0.6s ease-out;
}

.animate-slide-up {
  animation: slide-up 0.5s ease-out;
}

.animate-pulse-ring {
  animation: pulse-ring 1.5s cubic-bezier(0.215, 0.61, 0.355, 1) infinite;
}

/* Styles pour les composants */
.math-problem {
  font-family: 'JetBrains Mono', 'Consolas', monospace;
  font-feature-settings: 'tnum' 1;
}

.glass-effect {
  background: rgba(255, 255, 255, 0.25);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.18);
}

.gradient-text {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

/* Styles pour les inputs */
input[type="text"]:focus,
input[type="number"]:focus {
  outline: none;
  ring: 2px;
  ring-color: var(--math4child-primary);
  border-color: var(--math4child-primary);
}

/* Styles pour les boutons */
.btn-primary {
  background: linear-gradient(135deg, var(--math4child-primary) 0%, var(--math4child-secondary) 100%);
  transition: all 0.3s ease;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

.btn-success {
  background: linear-gradient(135deg, var(--math4child-success) 0%, #059669 100%);
}

.btn-warning {
  background: linear-gradient(135deg, var(--math4child-warning) 0%, #d97706 100%);
}

.btn-error {
  background: linear-gradient(135deg, var(--math4child-error) 0%, #dc2626 100%);
}

/* Styles pour les modales et overlays */
.modal-backdrop {
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(5px);
}

/* Styles pour l'accessibilité */
@media (prefers-reduced-motion: reduce) {
  *,
  ::before,
  ::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}

/* Styles pour l'impression */
@media print {
  body {
    background: white !important;
    color: black !important;
  }
  
  .no-print {
    display: none !important;
  }
}

/* Styles pour les appareils tactiles */
@media (pointer: coarse) {
  .touch-target {
    min-height: 44px;
    min-width: 44px;
  }
}

/* Styles responsives personnalisés */
@media (max-width: 640px) {
  .mobile-stack {
    flex-direction: column !important;
  }
  
  .mobile-full {
    width: 100% !important;
  }
  
  .mobile-text-center {
    text-align: center !important;
  }
}

/* Styles pour le dark mode (futur) */
@media (prefers-color-scheme: dark) {
  :root {
    /* Variables pour le mode sombre */
  }
}

/* Styles pour les toasts */
.toast-success {
  background: linear-gradient(135deg, var(--math4child-success) 0%, #059669 100%);
  color: white;
}

.toast-error {
  background: linear-gradient(135deg, var(--math4child-error) 0%, #dc2626 100%);
  color: white;
}

.toast-warning {
  background: linear-gradient(135deg, var(--math4child-warning) 0%, #d97706 100%);
  color: white;
}

/* Styles pour les barres de progression */
.progress-bar {
  background: linear-gradient(90deg, var(--math4child-primary) 0%, var(--math4child-secondary) 100%);
  transition: width 0.5s ease-in-out;
}

/* Styles pour les achievements et badges */
.achievement-badge {
  background: linear-gradient(135deg, #ffd700 0%, #ffed4e 100%);
  box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
}

/* Styles pour les effets de particules */
.particle-system {
  pointer-events: none;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1000;
}

/* Optimisations de performance */
.gpu-accelerated {
  transform: translateZ(0);
  will-change: transform;
}

/* Styles pour les loaders */
.spinner {
  border: 4px solid #f3f4f6;
  border-top: 4px solid var(--math4child-primary);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
EOF
    
    print_success "Styles globaux générés"
}

# Génération des composants utilitaires
generate_utility_components() {
    print_step "Génération des composants utilitaires..."
    
    # Layout component
    cat > "$APP_DIR/src/app/layout.tsx" << 'EOF'
import type { Metadata } from 'next'
import './globals.css'

export const metadata: Metadata = {
  title: 'Math4Child - Learn math while having fun',
  description: 'Multilingual educational platform for children aged 4 to 12. Transform math learning into an exciting adventure with 20+ supported languages.',
  keywords: 'math, education, children, multilingual, learning, games, mathematics, kids',
  authors: [{ name: 'Math4Child Team' }],
  creator: 'Math4Child Team',
  publisher: 'Math4Child',
  formatDetection: {
    email: false,
    address: false,
    telephone: false,
  },
  metadataBase: new URL('https://www.math4child.com'),
  alternates: {
    canonical: '/',
    languages: {
      'en': '/',
      'fr': '/fr',
      'es': '/es',
      'de': '/de',
      'ar': '/ar',
      'zh': '/zh',
    },
  },
  openGraph: {
    title: 'Math4Child - Learn math while having fun',
    description: 'Multilingual educational platform for children aged 4 to 12',
    url: 'https://www.math4child.com',
    siteName: 'Math4Child',
    images: [
      {
        url: '/og-image.png',
        width: 1200,
        height: 630,
        alt: 'Math4Child - Educational Math Platform',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Math4Child - Learn math while having fun',
    description: 'Multilingual educational platform for children aged 4 to 12',
    images: ['/twitter-image.png'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link rel="icon" href="/favicon.ico" />
        <link rel="apple-touch-icon" href="/apple-touch-icon.png" />
        <link rel="manifest" href="/manifest.json" />
        <meta name="theme-color" content="#3b82f6" />
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
      </head>
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}
EOF

    # Styles globaux
    cat > "$APP_DIR/src/app/globals.css" << 'EOF'
@import '../styles/globals.css';
EOF
    
    print_success "Composants utilitaires générés"
}

# Génération des fichiers de configuration supplémentaires
generate_additional_configs() {
    print_step "Génération des configurations supplémentaires..."
    
    # ESLint config
    cat > "$APP_DIR/.eslintrc.json" << 'EOF'
{
  "extends": [
    "next/core-web-vitals",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "@typescript-eslint/no-unused-vars": "error",
    "@typescript-eslint/no-explicit-any": "warn",
    "@typescript-eslint/prefer-const": "error",
    "react-hooks/exhaustive-deps": "warn",
    "no-console": "warn"
  },
  "ignorePatterns": [
    "node_modules/",
    ".next/",
    "out/",
    "build/"
  ]
}
EOF

    # Prettier config
    cat > "$APP_DIR/.prettierrc" << 'EOF'
{
  "semi": false,
  "trailingComma": "es5",
  "singleQuote": true,
  "tabWidth": 2,
  "useTabs": false,
  "printWidth": 100,
  "bracketSpacing": true,
  "arrowParens": "avoid",
  "endOfLine": "lf"
}
EOF

    # Environment files
    cat > "$APP_DIR/.env.local.example" << 'EOF'
# Math4Child Environment Variables
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_APP_VERSION=2.0.0
NEXT_PUBLIC_DOMAIN=www.math4child.com
NEXT_PUBLIC_API_URL=https://api.math4child.com

# Database (si nécessaire)
DATABASE_URL=

# External Services
STRIPE_PUBLIC_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=

# Analytics
GOOGLE_ANALYTICS_ID=
MIXPANEL_TOKEN=

# Social Auth (si nécessaire)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=

# Email (si nécessaire)
RESEND_API_KEY=
FROM_EMAIL=noreply@math4child.com

# Feature Flags
NEXT_PUBLIC_ENABLE_SUBSCRIPTIONS=true
NEXT_PUBLIC_ENABLE_SOUND=true
NEXT_PUBLIC_ENABLE_ANALYTICS=true
EOF

    # Manifest PWA
    cat > "$APP_DIR/public/manifest.json" << 'EOF'
{
  "name": "Math4Child - Learn math while having fun",
  "short_name": "Math4Child",
  "description": "Multilingual educational platform for children aged 4 to 12",
  "start_url": "/",
  "display": "standalone",
  "background_color": "#ffffff",
  "theme_color": "#3b82f6",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "/icons/icon-72x72.png",
      "sizes": "72x72",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-96x96.png",
      "sizes": "96x96",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-128x128.png",
      "sizes": "128x128",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-144x144.png",
      "sizes": "144x144",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-152x152.png",
      "sizes": "152x152",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-192x192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-384x384.png",
      "sizes": "384x384",
      "type": "image/png",
      "purpose": "maskable any"
    },
    {
      "src": "/icons/icon-512x512.png",
      "sizes": "512x512",
      "type": "image/png",
      "purpose": "maskable any"
    }
  ],
  "categories": ["education", "kids", "games", "learning"],
  "lang": "en",
  "dir": "ltr",
  "screenshots": [
    {
      "src": "/screenshots/desktop-1.png",
      "sizes": "1280x720",
      "type": "image/png",
      "platform": "wide"
    },
    {
      "src": "/screenshots/mobile-1.png",
      "sizes": "375x812",
      "type": "image/png",
      "platform": "narrow"
    }
  ]
}
EOF

    # GitIgnore
    cat > "$APP_DIR/.gitignore" << 'EOF'
# Dependencies
/node_modules
/.pnp
.pnp.js

# Testing
/coverage
/test-results
/playwright-report

# Next.js
/.next/
/out/
next-env.d.ts

# Production
/build
/dist

# Environment variables
.env
.env*.local
.env.production

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*
lerna-debug.log*

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage
*.lcov

# IDEs and editors
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# TypeScript
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# Temporary folders
tmp/
temp/
EOF
    
    print_success "Configurations supplémentaires générées"
}

# Génération du README pour l'application
generate_app_readme() {
    print_step "Génération du README de l'application..."
    
    cat > "$APP_DIR/README.md" << 'EOF'
# Math4Child - Application Éducative Multilingue 🎓

Application React/Next.js complète pour l'apprentissage des mathématiques destinée aux enfants de 4 à 12 ans.

## 🌟 Fonctionnalités

- **20+ langues supportées** avec support RTL (arabe)
- **5 niveaux progressifs** : Débutant → Expert
- **5 opérations mathématiques** : Addition, Soustraction, Multiplication, Division, Mixte
- **Système d'abonnement** avec plans multiples et réductions multi-appareils
- **Interface responsive** optimisée mobile, tablette, desktop
- **Animations fluides** avec Framer Motion
- **Sons et feedback** interactifs
- **Suivi de progression** complet avec achievements

## 🚀 Installation

```bash
# Installation des dépendances
npm install

# Développement
npm run dev

# Build production
npm run build
npm start

# Tests
npm test

# Linting
npm run lint
npm run type-check
```

## 🏗️ Architecture

```
src/
├── app/                    # App Router Next.js 14
│   ├── layout.tsx         # Layout principal
│   ├── page.tsx           # Page d'accueil
│   └── globals.css        # Styles globaux
├── components/            # Composants réutilisables
├── lib/                   # Utilitaires et helpers
├── types/                 # Définitions TypeScript
├── utils/                 # Fonctions utilitaires
├── data/                  # Données statiques
├── hooks/                 # Hooks React personnalisés
└── styles/                # Styles CSS
```

## 🌍 Support International

### Langues Supportées
- **Europe** : Français, Anglais, Espagnol, Allemand, Russe, Portugais, Italien, Polonais, Néerlandais, Suédois, Danois, Norvégien
- **Asie** : Arabe (RTL), Chinois, Japonais, Hindi, Coréen, Thaï, Vietnamien, Turc
- **Autres** : Support étendu prévu

### Support RTL
Support complet des langues de droite à gauche (arabe) avec :
- Direction automatique du texte
- Layouts adaptés
- Navigation inversée

## 🎮 Système de Jeu

### Niveaux et Difficulté
- **Débutant** : Nombres 1-10
- **Élémentaire** : Nombres 1-25  
- **Intermédiaire** : Nombres 1-50
- **Avancé** : Nombres 1-100
- **Expert** : Nombres 1-200+

### Progression
- 100 bonnes réponses pour débloquer le niveau suivant
- Système de streak avec récompenses
- Points et achievements
- Sauvegarde automatique dans localStorage

## 💳 Système d'Abonnement

### Plans Disponibles
- **Gratuit** : 50 questions sur 7 jours
- **Mensuel** : 9,99€/mois
- **Trimestriel** : 26,97€ (10% de réduction)
- **Annuel** : 83,93€ (30% de réduction)

### Multi-Appareils
- 2ème appareil : 50% de réduction
- 3ème appareil : 75% de réduction
- Synchronisation cross-platform

## 🛠️ Technologies

- **Framework** : Next.js 14 with App Router
- **Language** : TypeScript
- **Styling** : Tailwind CSS
- **Animations** : Framer Motion
- **Icons** : Lucide React
- **State** : Zustand (prêt)
- **Sounds** : Howler.js
- **Notifications** : React Hot Toast
- **Effects** : Canvas Confetti

## 🎨 Design System

### Couleurs Principales
- **Primary** : Blue (#3b82f6)
- **Secondary** : Purple (#8b5cf6)
- **Success** : Emerald (#10b981)
- **Warning** : Amber (#f59e0b)
- **Error** : Red (#ef4444)

### Typographie
- **Headers** : Poppins
- **Body** : Inter
- **Math** : JetBrains Mono

## 🔧 Configuration

### Variables d'Environnement
Copiez `.env.local.example` vers `.env.local` et configurez :

```bash
NEXT_PUBLIC_APP_NAME=Math4Child
NEXT_PUBLIC_DOMAIN=www.math4child.com
STRIPE_PUBLIC_KEY=your_stripe_key
# ... autres variables
```

### PWA
Application Progressive Web App avec :
- Manifest complet
- Icons pour toutes les tailles
- Support offline (à implémenter)

## 📱 Responsive Design

- **Mobile** : 375px+ (priorité)
- **Tablette** : 768px+
- **Desktop** : 1024px+
- **Large** : 1920px+

## ♿ Accessibilité

- Support complet du clavier
- Attributs ARIA appropriés
- Contrastes WCAG AA
- Support des lecteurs d'écran
- Respect de `prefers-reduced-motion`

## 🧪 Tests

```bash
# Tests unitaires
npm test

# Tests E2E (Playwright séparé)
cd ../tests
make test
```

## 🚀 Déploiement

### Vercel (Recommandé)
```bash
npm run build
vercel --prod
```

### Docker
```bash
docker build -t math4child-app .
docker run -p 3000:3000 math4child-app
```

### Build Statique
```bash
npm run build
npm run export
```

## 📊 Performance

### Objectifs
- **First Contentful Paint** : < 1.5s
- **Largest Contentful Paint** : < 2.5s
- **Cumulative Layout Shift** : < 0.1
- **First Input Delay** : < 100ms

### Optimisations
- Code splitting automatique Next.js
- Images optimisées avec next/image
- Fonts optimisés
- CSS-in-JS minimal
- Lazy loading des composants

## 🔒 Sécurité

- Headers de sécurité configurés
- Validation des inputs
- Protection XSS
- CSP headers
- Sanitisation des données utilisateur

## 📈 Analytics (À implémenter)

- Google Analytics 4
- Mixpanel pour les events
- Monitoring des performances
- A/B testing ready

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature
3. Commits avec convention
4. Tests passing
5. Pull request

### Conventions
- **feat**: nouvelle fonctionnalité
- **fix**: correction de bug  
- **docs**: documentation
- **style**: formatage
- **refactor**: refactoring
- **test**: tests
- **chore**: tâches de maintenance

## 📄 Licence

MIT License - voir LICENSE file

---

**Math4Child** - *Transformons l'apprentissage des mathématiques en aventure passionnante !* 🌟

🌐 **www.math4child.com** | 📧 **contact@math4child.com**
EOF
    
    print_success "README de l'application généré"
}

# Affichage des instructions finales
show_final_instructions() {
    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}║  🎉 APPLICATION MATH4CHILD GÉNÉRÉE AVEC SUCCÈS ! 🎉       ║${NC}"
    echo -e "${CYAN}║                                                            ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${GREEN}📁 APPLICATION CRÉÉE DANS : ${YELLOW}$APP_DIR${NC}"
    echo ""
    
    echo -e "${BLUE}📋 STRUCTURE COMPLÈTE GÉNÉRÉE :${NC}"
    echo -e "   ├── 📦 package.json                     # Dépendances Next.js + TypeScript"
    echo -e "   ├── ⚙️ next.config.js                   # Configuration Next.js 14"
    echo -e "   ├── 📝 tsconfig.json                    # Configuration TypeScript"
    echo -e "   ├── 🎨 tailwind.config.js               # Configuration Tailwind CSS"
    echo -e "   ├── 💄 postcss.config.js                # Configuration PostCSS"
    echo -e "   ├── 🔍 .eslintrc.json                   # Configuration ESLint"
    echo -e "   ├── ✨ .prettierrc                      # Configuration Prettier"
    echo -e "   ├── 🌍 .env.local.example               # Variables d'environnement"
    echo -e "   ├── 📖 README.md                        # Documentation complète"
    echo -e "   ├── src/"
    echo -e "   │   ├── app/"
    echo -e "   │   │   ├── layout.tsx                  # Layout principal avec métadonnées"
    echo -e "   │   │   ├── page.tsx                    # 🚀 APPLICATION PRINCIPALE COMPLÈTE"
    echo -e "   │   │   └── globals.css                 # Styles globaux"
    echo -e "   │   ├── types/index.ts                  # Types TypeScript complets"
    echo -e "   │   └── styles/globals.css              # Styles CSS avancés"
    echo -e "   └── public/"
    echo -e "       ├── manifest.json                   # PWA Manifest"
    echo -e "       └── icons/                          # Icônes PWA"
    echo ""
    
    echo -e "${GREEN}🚀 PROCHAINES ÉTAPES :${NC}"
    echo ""
    
    echo -e "${BLUE}1. Aller dans le répertoire de l'application :${NC}"
    echo -e "   ${YELLOW}cd $APP_DIR${NC}"
    echo ""
    
    echo -e "${BLUE}2. Installer les dépendances :${NC}"
    echo -e "   ${YELLOW}npm install${NC}"
    echo ""
    
    echo -e "${BLUE}3. Configurer l'environnement :${NC}"
    echo -e "   ${YELLOW}cp .env.local.example .env.local${NC}"
    echo -e "   ${YELLOW}# Éditez .env.local avec vos clés${NC}"
    echo ""
    
    echo -e "${BLUE}4. Démarrer l'application :${NC}"
    echo -e "   ${YELLOW}npm run dev${NC}"
    echo -e "   ${YELLOW}# Ouvrez http://localhost:3000${NC}"
    echo ""
    
    echo -e "${BLUE}5. Build pour production :${NC}"
    echo -e "   ${YELLOW}npm run build${NC}"
    echo -e "   ${YELLOW}npm start${NC}"
    echo ""
    
    echo -e "${GREEN}✨ FONCTIONNALITÉS INCLUSES :${NC}"
    echo -e "   ✅ Application React/Next.js 14 complète"
    echo -e "   ✅ 20+ langues avec support RTL (arabe)"
    echo -e "   ✅ 5 niveaux progressifs avec déverrouillage"
    echo -e "   ✅ 5 opérations mathématiques + générateur"
    echo -e "   ✅ Système d'abonnement avec plans multiples"
    echo -e "   ✅ Interface responsive (mobile, tablette, desktop)"
    echo -e "   ✅ Animations Framer Motion + Confetti"
    echo -e "   ✅ Sons, toasts, feedback interactifs"
    echo -e "   ✅ TypeScript + Tailwind CSS"
    echo -e "   ✅ PWA ready avec manifest"
    echo -e "   ✅ Sauvegarde localStorage"
    echo -e "   ✅ Configuration SEO complète"
    echo ""
    
    echo -e "${GREEN}🛠️ OUTILS DE DÉVELOPPEMENT :${NC}"
    echo -e "   • ${YELLOW}npm run dev${NC}           # Mode développement"
    echo -e "   • ${YELLOW}npm run build${NC}         # Build production"
    echo -e "   • ${YELLOW}npm run lint${NC}          # Linting ESLint"
    echo -e "   • ${YELLOW}npm run type-check${NC}    # Vérification TypeScript"
    echo ""
    
    echo -e "${GREEN}📚 DOCUMENTATION :${NC}"
    echo -e "   • README complet : ${CYAN}$APP_DIR/README.md${NC}"
    echo -e "   • Types TypeScript : ${CYAN}$APP_DIR/src/types/index.ts${NC}"
    echo -e "   • Configuration : ${CYAN}$APP_DIR/next.config.js${NC}"
    echo ""
    
    echo -e "${PURPLE}🎭 Math4Child Application - Prête pour www.math4child.com !${NC}"
    echo -e "${PURPLE}   Application complète avec 20+ langues • 5 niveaux • Abonnements${NC}"
    echo ""
}

# Fonction principale
main() {
    print_header
    
    echo -e "${BLUE}Ce script va générer l'APPLICATION MATH4CHILD COMPLÈTE :${NC}"
    echo ""
    echo -e "🚀 Application React/Next.js 14 avec App Router"
    echo -e "📱 Interface responsive complète (mobile, tablette, desktop)"
    echo -e "🌍 Support de 20+ langues avec RTL (arabe)"
    echo -e "🎮 Système de jeu complet avec 5 niveaux et 5 opérations"
    echo -e "💳 Système d'abonnement avec 4 plans et réductions multi-appareils"
    echo -e "✨ Animations Framer Motion + effects (confetti, sons)"
    echo -e "📊 Sauvegarde de progression + localStorage"
    echo -e "🎨 Design moderne avec Tailwind CSS"
    echo -e "⚡ PWA ready + SEO optimisé"
    echo -e "🛠️ TypeScript + ESLint + Prettier"
    echo ""
    
    read -p "Générer l'application Math4Child complète ? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Génération annulée."
        exit 0
    fi
    
    # Étapes de génération
    create_app_structure
    generate_package_json
    generate_nextjs_config
    generate_typescript_config
    generate_tailwind_config
    generate_types
    generate_main_app
    generate_global_styles
    generate_utility_components
    generate_additional_configs
    generate_app_readme
    show_final_instructions
}

# Gestion des erreurs
trap 'print_error "Une erreur est survenue. Génération interrompue."; exit 1' ERR

# Lancement du script
main "$@"#!/bin/bash

# ===================================================================
# GÉNÉRATEUR APPLICATION MATH4CHILD COMPLÈTE
# Crée l'application React/Next.js avec toutes les fonctionnalités
# ===================================================================

set -e

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  🚀 GÉNÉRATEUR APPLICATION MATH4CHILD COMPLÈTE 🚀         ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}║  📚 Application éducative multilingue (20+ langues)       ║${NC}"
    echo -e "${BLUE}║  🧮 5 niveaux • 5 opérations • Système d'abonnement       ║${NC}"
    echo -e "${BLUE}║  🌍 Web, Android, iOS • www.math4child.com                ║${NC}"
    echo -e "${BLUE}║                                                            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_step() { echo -e "${PURPLE}🔄 $1${NC}"; }

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
APP_DIR="$SCRIPT_DIR/apps/math4child"

# Créer la structure de l'application
create_app_structure() {
    print_step "Création de la structure de l'application..."
    
    mkdir -p "$APP_DIR"
    mkdir -p "$APP_DIR/src/app"
    mkdir -p "$APP_DIR/src/components"
    mkdir -p "$APP_DIR/src/lib"
    mkdir -p "$APP_DIR/src/utils"
    mkdir -p "$APP_DIR/src/data"
    mkdir -p "$APP_DIR/src/hooks"
    mkdir -p "$APP_DIR/src/styles"
    mkdir -p "$APP_DIR/public"
    mkdir -p "$APP_DIR/public/icons"
    mkdir -p "$APP_DIR/public/sounds"
    
    print_success "Structure de l'application créée"
}

# Génération du package.json
generate_package_json() {
    print_step "Génération du package.json..."
    
    cat > "$APP_DIR/package.json" << 'EOF'
{
  "name": "math4child-app",
  "version": "2.0.0",
  "description": "Math4Child.com - Application éducative multilingue pour enfants de 4 à 12 ans",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage"
  },
  "dependencies": {
    "next": "^14.2.30",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "lucide-react": "^0.263.1",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "clsx": "^2.1.0",
    "framer-motion": "^11.0.0",
    "zustand": "^4.5.0",
    "react-confetti": "^6.1.0",
    "howler": "^2.2.4",
    "react-hot-toast": "^2.4.1"
  },
  "devDependencies": {
    "@types/node": "^20.12.0",
    "@types/react": "^18.3.12",
    "@types/react-dom": "^18.3.1",
    "@types/howler": "^2.2.11",
    "typescript": "^5.4.5",
    "eslint": "^8.57.0",
    "eslint-config-next": "^14.2.30",
    "@typescript-eslint/eslint-plugin": "^7.0.0",
    "@typescript-eslint/parser": "^7.0.0",
    "prettier": "^3.2.0",
    "jest": "^29.7.0",
    "jest-environment-jsdom": "^29.7.0",
    "@testing-library/react": "^14.2.0",
    "@testing-library/jest-dom": "^6.4.0"
  },
  "keywords": [
    "math4child",
    "education",
    "mathematics",
    "children",
    "multilingual",
    "learning",
    "games",
    "nextjs",
    "react",
    "typescript"
  ],
  "author": "Math4Child Team",
  "license": "MIT",
  "homepage": "https://www.math4child.com",
  "repository": {
    "type": "git",
    "url": "https://github.com/math4child/app"
  }
}
EOF
    
    print_success "package.json généré"
}

# Configuration Next.js
generate_nextjs_config() {
    print_step "Génération de la configuration Next.js..."
    
    cat > "$APP_DIR/next.config.js" << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    appDir: true,
  },
  images: {
    domains: ['www.math4child.com'],
    formats: ['image/webp', 'image/avif'],
  },
  i18n: {
    locales: [
      'en', 'fr', 'es', 'de', 'ar', 'zh', 'ja', 'ru', 'pt', 'it',
      'hi', 'ko', 'th', 'vi', 'tr', 'pl', 'nl', 'sv', 'da', 'no'
    ],
    defaultLocale: 'en',
    localeDetection: true,
  },
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
        ],
      },
    ];
  },
  async rewrites() {
    return [
      {
        source: '/api/health',
        destination: '/api/health',
      },
    ];
  },
  webpack: (config, { isServer }) => {
    // Configuration spécifique Math4Child
    config.resolve.alias = {
      ...config.resolve.alias,
      '@': require('path').resolve(__dirname, 'src'),
    };
    
    return config;
  },
  env: {
    NEXT_PUBLIC_APP_NAME: 'Math4Child',
    NEXT_PUBLIC_APP_VERSION: '2.0.0',
    NEXT_PUBLIC_DOMAIN: 'www.math4child.com',
  },
};

module.exports = nextConfig;
EOF
    
    print_success "Configuration Next.js générée"
}

# Configuration TypeScript
generate_typescript_config() {
    print_step "Génération de la configuration TypeScript..."
    
    cat > "$APP_DIR/tsconfig.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["DOM", "DOM.Iterable", "ES2020"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "strictNullChecks": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "ESNext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/utils/*": ["./src/utils/*"],
      "@/data/*": ["./src/data/*"],
      "@/hooks/*": ["./src/hooks/*"],
      "@/styles/*": ["./src/styles/*"]
    },
    "plugins": [
      {
        "name": "next"
      }
    ]
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts"
  ],
  "exclude": [
    "node_modules",
    "tests",
    "e2e"
  ]
}
EOF
    
    print_success "Configuration TypeScript générée"
}

# Configuration Tailwind CSS
generate_tailwind_config() {
    print_step "Génération de la configuration Tailwind CSS..."
    
    cat > "$APP_DIR/tailwind.config.js" << 'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        'math4child': {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
        },
        'primary': {
          50: '#eff6ff',
          100: '#dbeafe',
          200: '#bfdbfe',
          300: '#93c5fd',
          400: '#60a5fa',
          500: '#3b82f6',
          600: '#2563eb',
          700: '#1d4ed8',
          800: '#1e40af',
          900: '#1e3a8a',
        },
        'success': {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80',
          500: '#22c55e',
          600: '#16a34a',
          700: '#15803d',
          800: '#166534',
          900: '#14532d',
        },
        'warning': {
          50: '#fffbeb',
          100: '#fef3c7',
          200: '#fde68a',
          300: '#fcd34d',
          400: '#fbbf24',
          500: '#f59e0b',
          600: '#d97706',
          700: '#b45309',
          800: '#92400e',
          900: '#78350f',
        },
        'error': {
          50: '#fef2f2',
          100: '#fee2e2',
          200: '#fecaca',
          300: '#fca5a5',
          400: '#f87171',
          500: '#ef4444',
          600: '#dc2626',
          700: '#b91c1c',
          800: '#991b1b',
          900: '#7f1d1d',
        },
      },
      fontFamily: {
        'sans': ['Inter', 'system-ui', 'sans-serif'],
        'display': ['Poppins', 'system-ui', 'sans-serif'],
        'mono': ['JetBrains Mono', 'Consolas', 'monospace'],
      },
      animation: {
        'bounce-slow': 'bounce 2s infinite',
        'pulse-slow': 'pulse 3s infinite',
        'wiggle': 'wiggle 1s ease-in-out infinite',
        'float': 'float 3s ease-in-out infinite',
        'celebrate': 'celebrate 0.6s ease-out',
      },
      keyframes: {
        wiggle: {
          '0%, 100%': { transform: 'rotate(-3deg)' },
          '50%': { transform: 'rotate(3deg)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        celebrate: {
          '0%': { transform: 'scale(1)' },
          '50%': { transform: 'scale(1.2)' },
          '100%': { transform: 'scale(1)' },
        },
      },
      screens: {
        'xs': '475px',
        '3xl': '1680px',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
EOF
    
    cat > "$APP_DIR/postcss.config.js" << 'EOF'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF
    
    print_success "Configuration Tailwind CSS générée"
}

# Génération des types TypeScript
generate_types() {
    print_step "Génération des types TypeScript..."
    
    cat > "$APP_DIR/src/types/index.ts" << 'EOF'
// ===================================================================
// TYPES MATH4CHILD - DEFINITIONS TYPESCRIPT
// Types complets pour l'application Math4Child
// ===================================================================

// Types de base
export type SupportedLanguage = 
  | 'fr' | 'en' | 'es' | 'de' | 'ar' | 'zh' | 'ja' | 'ru' | 'pt' | 'it' 
  | 'hi' | 'ko' | 'th' | 'vi' | 'tr' | 'pl' | 'nl' | 'sv' | 'da' | 'no';

export type Level = 'beginner' | 'elementary' | 'intermediate' | 'advanced' | 'expert';

export type MathOperation = 'addition' | 'subtraction' | 'multiplication' | 'division' | 'mixed';

export type ViewType = 'home' | 'game' | 'subscribe' | 'progress' | 'settings';

export type DeviceType = 'web' | 'android' | 'ios';

export type SubscriptionPlan = 'free' | 'monthly' | 'quarterly' | 'yearly';

export type DifficultyLevel = 1 | 2 | 3 | 4 | 5;

// Interfaces principales
export interface LanguageConfig {
  name: string;
  nativeName: string;
  flag: string;
  rtl?: boolean;
  continent: string;
}

export interface UserProgress {
  level: Level;
  correctAnswers: Record<Level, number>;
  unlockedLevels: Level[];
  totalQuestions: number;
  freeQuestionsUsed: number;
  streak: number;
  bestStreak: number;
  totalPoints: number;
  achievements: Achievement[];
  lastPlayDate: string;
  studyTime: number; // en minutes
}

export interface MathProblem {
  num1: number;
  num2: number;
  operation: string;
  operationType: MathOperation;
  answer: number;
  level: Level;
  difficulty: DifficultyLevel;
  timeLimit?: number;
  hints?: string[];
}

export interface GameState {
  currentProblem: MathProblem | null;
  userAnswer: string;
  isAnswered: boolean;
  isCorrect: boolean | null;
  feedback: FeedbackMessage;
  streak: number;
  points: number;
  timeRemaining: number;
  hintsUsed: number;
}

export interface FeedbackMessage {
  type: 'correct' | 'incorrect' | 'timeout' | null;
  message: string;
  encouragement?: string;
  celebration?: boolean;
}

export interface SubscriptionStatus {
  isSubscribed: boolean;
  plan: SubscriptionPlan | null;
  devices: DeviceSubscription[];
  expiresAt: string | null;
  features: string[];
  trialEndDate: string | null;
  questionsUsedToday: number;
  questionsLimit: number;
}

export interface DeviceSubscription {
  device: DeviceType;
  subscribedAt: string;
  price: number;
  discount: number;
  active: boolean;
}

export interface PricingPlan {
  id: SubscriptionPlan;
  name: string;
  price: number;
  originalPrice?: number;
  discount?: number;
  duration: string;
  popular?: boolean;
  features: string[];
  questionsLimit: number | 'unlimited';
  devicesIncluded: number;
  support: 'email' | 'priority' | 'vip';
  trialDays?: number;
}

export interface Achievement {
  id: string;
  name: string;
  description: string;
  icon: string;
  condition: AchievementCondition;
  unlockedAt?: string;
  progress: number;
  maxProgress: number;
  reward?: AchievementReward;
}

export interface AchievementCondition {
  type: 'streak' | 'correct_answers' | 'level_completion' | 'time_played' | 'perfect_score';
  target: number;
  level?: Level;
  operation?: MathOperation;
}

export interface AchievementReward {
  type: 'points' | 'unlock' | 'cosmetic';
  value: number | string;
  description: string;
}

export interface GameStatistics {
  totalGamesPlayed: number;
  totalCorrectAnswers: number;
  totalIncorrectAnswers: number;
  averageResponseTime: number;
  accuracyPercentage: number;
  favoriteOperation: MathOperation;
  preferredDifficulty: Level;
  totalStudyTime: number;
  streakRecord: number;
  pointsEarned: number;
  achievementsUnlocked: number;
  progressByLevel: Record<Level, LevelStatistics>;
  progressByOperation: Record<MathOperation, OperationStatistics>;
  dailyActivity: DailyActivity[];
}

export interface LevelStatistics {
  questionsAnswered: number;
  correctAnswers: number;
  averageTime: number;
  bestStreak: number;
  completionPercentage: number;
  unlockedAt: string;
}

export interface OperationStatistics {
  questionsAnswered: number;
  correctAnswers: number;
  averageTime: number;
  accuracyPercentage: number;
  preferredLevel: Level;
}

export interface DailyActivity {
  date: string;
  questionsAnswered: number;
  correctAnswers: number;
  studyTime: number;
  pointsEarned: number;
  streak: number;
}

export interface AppSettings {
  language: SupportedLanguage;
  soundEnabled: boolean;
  musicEnabled: boolean;
  animationsEnabled: boolean;
  theme: 'light' | 'dark' | 'auto';
  fontSize: 'small' | 'medium' | 'large';
  difficulty: 'adaptive' | 'fixed';
  notifications: NotificationSettings;
  accessibility: AccessibilitySettings;
}

export interface NotificationSettings {
  enabled: boolean;
  dailyReminder: boolean;
  reminderTime: string;
  achievementNotifications: boolean;
  progressUpdates: boolean;
}

export interface AccessibilitySettings {
  highContrast: boolean;
  largeText: boolean;
  reduceMotion: boolean;
  screenReader: boolean;
  keyboardNavigation: boolean;
}

// Types pour les traductions
export interface TranslationKeys {
  appName: string;
  title: string;
  subtitle: string;
  heroDescription: string;
  levels: Record<Level, string>;
  operations: Record<MathOperation, string>;
  game: GameTranslations;
  subscription: SubscriptionTranslations;
  features: FeaturesTranslations;
  stats: StatsTranslations;
  common: CommonTranslations;
}

export interface GameTranslations {
  selectLevel: string;
  selectOperation: string;
  progress: string;
  levelUnlocked: string;
  correctAnswer: string;
  wrongAnswer: string;
  placeholder: string;
  validate: string;
  nextProblem: string;
  backToLevels: string;
  freeQuestionsLeft: string;
  timeRemaining: string;
  streak: string;
  points: string;
  hint: string;
  giveUp: string;
}

export interface SubscriptionTranslations {
  title: string;
  subtitle: string;
  deviceDisclaimer: string;
  plans: Record<SubscriptionPlan, PlanTranslation>;
  multiDevice: MultiDeviceTranslations;
  features: Record<string, string>;
}

export interface PlanTranslation {
  name: string;
  duration: string;
  price: number;
  features: string[];
  popular?: boolean;
  discount?: number;
  originalPrice?: number;
}

export interface MultiDeviceTranslations {
  title: string;
  secondDevice: string;
  thirdDevice: string;
  devices: Record<DeviceType, string>;
}

export interface FeaturesTranslations {
  interactive: string;
  multilingual: string;
  progress: string;
  games: string;
}

export interface StatsTranslations {
  students: string;
  exercises: string;
  languages: string;
  satisfaction: string;
}

export interface CommonTranslations {
  loading: string;
  error: string;
  success: string;
  cancel: string;
  confirm: string;
  close: string;
  save: string;
  reset: string;
  back: string;
  next: string;
  previous: string;
  start: string;
  stop: string;
  pause: string;
  resume: string;
  retry: string;
}

// Types d'événements
export interface GameEvent {
  type: 'start' | 'answer' | 'complete' | 'pause' | 'resume' | 'quit';
  timestamp: number;
  data?: any;
}

export interface AnalyticsEvent {
  event: string;
  properties: Record<string, any>;
  timestamp: number;
  userId?: string;
  sessionId: string;
}

// Types d'API
export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  timestamp: number;
}

export interface UserApiData {
  id: string;
  email: string;
  username: string;
  progress: UserProgress;
  subscription: SubscriptionStatus;
  settings: AppSettings;
  statistics: GameStatistics;
  createdAt: string;
  lastActiveAt: string;
}

// Types d'erreurs
export interface AppError {
  code: string;
  message: string;
  details?: any;
  timestamp: number;
  stack?: string;
}

// Types de composants
export interface ComponentProps {
  className?: string;
  children?: React.ReactNode;
}

export interface ButtonProps extends ComponentProps {
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'error';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  disabled?: boolean;
  onClick?: () => void;
}

export interface ModalProps extends ComponentProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl';
}
EOF
    
    print_success "Types TypeScript générés"
}

# Génération de l'application principale
generate_main_app() {
    print_step "Génération de l'application principale..."
    
    cat > "$APP_DIR/src/app/page.tsx" << 'EOF'
'use client'

import React, { useState, useEffect } from 'react'
import { 
  Calculator, Trophy, Globe, ChevronDown, Users, Star, Gamepad2, Heart, 
  Zap, Target, Play, BookOpen, Settings, Check, X, ArrowLeft, CreditCard, 
  Crown, Shield, Lock, Unlock, Plus, Minus, DivideIcon as Divide, 
  MoreHorizontal, Award, Brain, Rocket, GraduationCap, Volume2, VolumeX
} from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import confetti from 'canvas-confetti'
import toast, { Toaster } from 'react-hot-toast'

// Import des types
import type {
  SupportedLanguage, Level, MathOperation, ViewType, DeviceType,
  SubscriptionPlan, UserProgress, MathProblem, GameState,
  LanguageConfig, TranslationKeys
} from '../types'

// Configuration des langues (20+ langues)
const SUPPORTED_LANGUAGES: Record<SupportedLanguage, LanguageConfig> = {
  fr: { name: 'French', nativeName: 'Français', flag: '🇫🇷', continent: 'Europe' },
  en: { name: 'English', nativeName: 'English', flag: '🇺🇸', continent: 'North America' },
  es: { name: 'Spanish', nativeName: 'Español', flag: '🇪🇸', continent: 'Europe' },
  de: { name: 'German', nativeName: 'Deutsch', flag: '🇩🇪', continent: 'Europe' },
  ar: { name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦', rtl: true, continent: 'Asia' },
  zh: { name: 'Chinese', nativeName: '中文', flag: '🇨🇳', continent: 'Asia' },
  ja: { name: 'Japanese', nativeName: '日本語', flag: '🇯🇵', continent: 'Asia' },
  ru: { name: 'Russian', nativeName: 'Русский', flag: '🇷🇺', continent: 'Europe' },
  pt: { name: 'Portuguese', nativeName: 'Português', flag: '🇵🇹', continent: 'Europe' },
  it: { name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹', continent: 'Europe' },
  hi: { name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳', continent: 'Asia' },
  ko: { name: 'Korean', nativeName: '한국어', flag: '🇰🇷', continent: 'Asia' },
  th: { name: 'Thai', nativeName: 'ไทย', flag: '🇹🇭', continent: 'Asia' },
  vi: { name: 'Vietnamese', nativeName: 'Tiếng Việt', flag: '🇻🇳', continent: 'Asia' },
  tr: { name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷', continent: 'Asia' },
  pl: { name: 'Polish', nativeName: 'Polski', flag: '🇵🇱', continent: 'Europe' },
  nl: { name: 'Dutch', nativeName: 'Nederlands', flag: '🇳🇱', continent: 'Europe' },
  sv: { name: 'Swedish', nativeName: 'Svenska', flag: '🇸🇪', continent: 'Europe' },
  da: { name: 'Danish', nativeName: 'Dansk', flag: '🇩🇰', continent: 'Europe' },
  no: { name: 'Norwegian', nativeName: 'Norsk', flag: '🇳🇴', continent: 'Europe' }
}

// Traductions complètes
const translations: Record<SupportedLanguage, TranslationKeys> = {
  fr: {
    appName: 'Math4Child',
    title: 'Math4Child - Apprendre les mathématiques en s\'amusant',
    subtitle: 'Plateforme éducative multilingue pour enfants de 4 à 12 ans',
    heroDescription: '🌟 Transformez l\'apprentissage des mathématiques en aventure passionnante !',
    
    levels: {
      beginner: 'Débutant',
      elementary: 'Élémentaire', 
      intermediate: 'Intermédiaire',
      advanced: 'Avancé',
      expert: 'Expert'
    },
    
    operations: {
      addition: 'Addition',
      subtraction: 'Soustraction',
      multiplication: 'Multiplication', 
      division: 'Division',
      mixed: 'Mixte'
    },
    
    game: {
      selectLevel: 'Choisissez votre niveau',
      selectOperation: 'Choisissez l\'opération',
      progress: 'Progrès: {current}/{required} bonnes réponses',
      levelUnlocked: 'Niveau débloqué !',
      correctAnswer: 'Bonne réponse ! +10 points',
      wrongAnswer: 'Mauvaise réponse. La bonne réponse est: {answer}',
      placeholder: 'Votre réponse...',
      validate: 'Valider',
      nextProblem: 'Problème suivant',
      backToLevels: 'Retour aux niveaux',
      freeQuestionsLeft: 'Questions gratuites restantes: {count}',
      timeRemaining: 'Temps restant: {time}s',
      streak: 'Série: {count}',
      points: 'Points: {count}',
      hint: 'Indice',
      giveUp: 'Abandonner'
    },
    
    subscription: {
      title: 'Abonnement Math4Child',
      subtitle: 'Choisissez le plan parfait pour votre enfant',
      deviceDisclaimer: 'Abonnement valable pour {device} uniquement',
      
      plans: {
        free: {
          name: 'Version Gratuite',
          duration: '7 jours - 50 questions',
          price: 0,
          features: [
            '50 questions au total',
            'Tous les niveaux limités',
            'Support par email',
            'Accès 7 jours'
          ]
        },
        monthly: {
          name: 'Mensuel',
          duration: 'par mois',
          price: 9.99,
          features: [
            'Questions illimitées',
            'Tous les niveaux débloqués',
            'Toutes les opérations',
            'Support prioritaire',
            'Statistiques détaillées'
          ]
        },
        quarterly: {
          name: 'Trimestriel',
          duration: '3 mois',
          price: 26.97,
          originalPrice: 29.97,
          discount: 10,
          popular: true,
          features: [
            'Tout du plan mensuel',
            '10% de réduction',
            'Paiement unique',
            'Support premium'
          ]
        },
        yearly: {
          name: 'Annuel',
          duration: '12 mois', 
          price: 83.93,
          originalPrice: 119.88,
          discount: 30,
          features: [
            'Tout du plan mensuel',
            '30% de réduction',
            'Paiement unique',
            'Support VIP',
            'Accès anticipé aux nouveautés'
          ]
        }
      },
      
      multiDevice: {
        title: 'Abonnements Multi-Appareils',
        secondDevice: 'Deuxième appareil: 50% de réduction',
        thirdDevice: 'Troisième appareil: 75% de réduction',
        devices: {
          web: 'Version Web',
          android: 'Android',
          ios: 'iOS'
        }
      },
      
      features: {
        unlimited: 'Questions illimitées',
        allLevels: 'Tous les niveaux',
        noAds: 'Sans publicité',
        support: 'Support prioritaire'
      }
    },
    
    features: {
      interactive: 'Apprentissage Interactif',
      multilingual: 'Support Multilingue', 
      progress: 'Suivi des Progrès',
      games: 'Jeux Éducatifs'
    },
    
    stats: { 
      students: 'Étudiants actifs', 
      exercises: 'Exercices disponibles', 
      languages: 'Langues supportées', 
      satisfaction: 'Satisfaction parents' 
    },
    
    common: {
      loading: 'Chargement...',
      error: 'Erreur',
      success: 'Succès',
      cancel: 'Annuler',
      confirm: 'Confirmer',
      close: 'Fermer',
      save: 'Sauvegarder',
      reset: 'Réinitialiser',
      back: 'Retour',
      next: 'Suivant',
      previous: 'Précédent',
      start: 'Commencer',
      stop: 'Arrêter',
      pause: 'Pause',
      resume: 'Reprendre',
      retry: 'Réessayer'
    }
  },
  
  en: {
    appName: 'Math4Child',
    title: 'Math4Child - Learn math while having fun',
    subtitle: 'Multilingual educational platform for children aged 4 to 12',
    heroDescription: '🌟 Transform math learning into an exciting adventure!',
    
    levels: {
      beginner: 'Beginner',
      elementary: 'Elementary',
      intermediate: 'Intermediate', 
      advanced: 'Advanced',
      expert: 'Expert'
    },
    
    operations: {
      addition: 'Addition',
      subtraction: 'Subtraction',
      multiplication: 'Multiplication',
      division: 'Division', 
      mixed: 'Mixed'
    },
    
    game: {
      selectLevel: 'Choose your level',
      selectOperation: 'Choose operation',
      progress: 'Progress: {current}/{required} correct answers',
      levelUnlocked: 'Level unlocked!',
      correctAnswer: 'Correct answer! +10 points',
      wrongAnswer: 'Wrong answer. The correct answer is: {answer}',
      placeholder: 'Your answer...',
      validate: 'Validate',
      nextProblem: 'Next problem',
      backToLevels: 'Back to levels',
      freeQuestionsLeft: 'Free questions remaining: {count}',
      timeRemaining: 'Time remaining: {time}s',
      streak: 'Streak: {count}',
      points: 'Points: {count}',
      hint: 'Hint',
      giveUp: 'Give up'
    },
    
    subscription: {
      title: 'Math4Child Subscription',
      subtitle: 'Choose the perfect plan for your child',
      deviceDisclaimer: 'Subscription valid for {device} only',
      
      plans: {
        free: {
          name: 'Free Version',
          duration: '7 days - 50 questions',
          price: 0,
          features: [
            '50 total questions',
            'All levels limited',
            'Email support',
            '7-day access'
          ]
        },
        monthly: {
          name: 'Monthly',
          duration: 'per month',
          price: 9.99,
          features: [
            'Unlimited questions',
            'All levels unlocked',
            'All operations',
            'Priority support',
            'Detailed statistics'
          ]
        },
        quarterly: {
          name: 'Quarterly',
          duration: '3 months',
          price: 26.97,
          originalPrice: 29.97,
          discount: 10,
          popular: true,
          features: [
            'Everything in monthly',
            '10% discount',
            'Single payment',
            'Premium support'
          ]
        },
        yearly: {
          name: 'Yearly',
          duration: '12 months',
          price: 83.93,
          originalPrice: 119.88,
          discount: 30,
          features: [
            'Everything in monthly',
            '30% discount',
            'Single payment',
            'VIP support',
            'Early access to new features'
          ]
        }
      },
      
      multiDevice: {
        title: 'Multi-Device Subscriptions',
        secondDevice: 'Second device: 50% off',
        thirdDevice: 'Third device: 75% off',
        devices: {
          web: 'Web Version',
          android: 'Android',
          ios: 'iOS'
        }
      },
      
      features: {
        unlimited: 'Unlimited questions',
        allLevels: 'All levels',
        noAds: 'Ad-free',
        support: 'Priority support'
      }
    },
    
    features: {
      interactive: 'Interactive Learning',
      multilingual: 'Multilingual Support',
      progress: 'Progress Tracking', 
      games: 'Educational Games'
    },
    
    stats: { 
      students: 'Active students', 
      exercises: 'Available exercises', 
      languages: 'Supported languages', 
      satisfaction: 'Parent satisfaction' 
    },
    
    common: {
      loading: 'Loading...',
      error: 'Error',
      success: 'Success',
      cancel: 'Cancel',
      confirm: 'Confirm',
      close: 'Close',
      save: 'Save',
      reset: 'Reset',
      back: 'Back',
      next: 'Next',
      previous: 'Previous',
      start: 'Start',
      stop: 'Stop',
      pause: 'Pause',
      resume: 'Resume',
      retry: 'Retry'
    }
  },

  // Ajout de traductions basiques pour les autres langues
  es: {
    appName: 'Math4Child',
    title: 'Math4Child - Aprende matemáticas divirtiéndote',
    subtitle: 'Plataforma educativa multilingüe para niños de 4 a 12 años',
    heroDescription: '🌟 ¡Transforma el aprendizaje de matemáticas en una aventura emocionante!',
    levels: { beginner: 'Principiante', elementary: 'Elemental', intermediate: 'Intermedio', advanced: 'Avanzado', expert: 'Experto' },
    operations: { addition: 'Suma', subtraction: 'Resta', multiplication: 'Multiplicación', division: 'División', mixed: 'Mixto' },
    // ... autres traductions simplifiées
  } as any,

  de: {
    appName: 'Math4Child', 
    title: 'Math4Child - Mathematik lernen macht Spaß',
    subtitle: 'Mehrsprachige Bildungsplattform für Kinder von 4 bis 12 Jahren',
    heroDescription: '🌟 Verwandle das Mathematiklernen in ein aufregendes Abenteuer!',
    levels: { beginner: 'Anfänger', elementary: 'Grundstufe', intermediate: 'Mittelstufe', advanced: 'Fortgeschritten', expert: 'Experte' },
    operations: { addition: 'Addition', subtraction: 'Subtraktion', multiplication: 'Multiplikation', division: 'Division', mixed: 'Gemischt' },
    // ... autres traductions simplifiées
  } as any,

  // Autres langues avec traductions basiques...
  ar: { appName: 'Math4Child', title: 'Math4Child - تعلم الرياضيات بمتعة' } as any,
  zh: { appName: 'Math4Child', title: 'Math4Child - 快乐学数学' } as any,
  ja: { appName: 'Math4Child', title: 'Math4Child - 楽しく数学を学ぼう' } as any,
  ru: { appName: 'Math4Child', title: 'Math4Child - Изучайте математику с удовольствием' } as any,
  pt: { appName: 'Math4Child', title: 'Math4Child - Aprenda matemática se divertindo' } as any,
  it: { appName: 'Math4Child', title: 'Math4Child - Impara la matematica divertendoti' } as any,
  hi: { appName: 'Math4Child', title: 'Math4Child - मज़े से गणित सीखें' } as any,
  ko: { appName: 'Math4Child', title: 'Math4Child - 재미있게 수학 배우기' } as any,
  th: { appName: 'Math4Child', title: 'Math4Child - เรียนคณิตศาสตร์อย่างสนุก' } as any,
  vi: { appName: 'Math4Child', title: 'Math4Child - Học toán vui vẻ' } as any,
  tr: { appName: 'Math4Child', title: 'Math4Child - Eğlenerek matematik öğren' } as any,
  pl: { appName: 'Math4Child', title: 'Math4Child - Ucz się matematyki z przyjemnością' } as any,
  nl: { appName: 'Math4Child', title: 'Math4Child - Leer wiskunde met plezier' } as any,
  sv: { appName: 'Math4Child', title: 'Math4Child - Lär dig matematik med glädje' } as any,
  da: { appName: 'Math4Child', title: 'Math4Child - Lær matematik med glæde' } as any,
  no: { appName: 'Math4Child', title: 'Math4Child - Lær matematikk med glede' } as any
}

export default function Math4ChildApp() {
  // État global de l'application
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('en')
  const [currentView, setCurrentView] = useState<ViewType>('home')
  const [mounted, setMounted] = useState(false)
  const [soundEnabled, setSoundEnabled] = useState(true)
  const [showLanguageDropdown, setShowLanguageDropdown] = useState(false)
  
  // État du jeu
  const [selectedLevel, setSelectedLevel] = useState<Level>('beginner')
  const [selectedOperation, setSelectedOperation] = useState<MathOperation>('addition')
  const [gameState, setGameState] = useState<GameState>({
    currentProblem: null,
    userAnswer: '',
    isAnswered: false,
    isCorrect: null,
    feedback: { type: null, message: '' },
    streak: 0,
    points: 0,
    timeRemaining: 60,
    hintsUsed: 0
  })
  
  // Progrès utilisateur
  const [userProgress, setUserProgress] = useState<UserProgress>({
    level: 'beginner',
    correctAnswers: {
      beginner: 0,
      elementary: 0, 
      intermediate: 0,
      advanced: 0,
      expert: 0
    },
    unlockedLevels: ['beginner'],
    totalQuestions: 0,
    freeQuestionsUsed: 0,
    streak: 0,
    bestStreak: 0,
    totalPoints: 0,
    achievements: [],
    lastPlayDate: new Date().toISOString(),
    studyTime: 0
  })
  
  // Abonnement
  const [subscriptionStatus, setSubscriptionStatus] = useState({
    isSubscribed: false,
    plan: null as SubscriptionPlan | null,
    devices: [] as any[],
    questionsUsedToday: 0,
    questionsLimit: 50
  })

  useEffect(() => {
    setMounted(true)
    // Charger les données depuis localStorage
    loadUserData()
  }, [])

  const loadUserData = () => {
    try {
      const savedProgress = localStorage.getItem('math4child-progress')
      if (savedProgress) {
        setUserProgress(JSON.parse(savedProgress))
      }
      
      const savedLanguage = localStorage.getItem('math4child-language')
      if (savedLanguage) {
        setCurrentLanguage(savedLanguage as SupportedLanguage)
      }
      
      const savedSound = localStorage.getItem('math4child-sound')
      if (savedSound) {
        setSoundEnabled(JSON.parse(savedSound))
      }
    } catch (error) {
      console.error('Error loading user data:', error)
    }
  }

  const saveUserData = (progress: UserProgress) => {
    setUserProgress(progress)
    localStorage.setItem('math4child-progress', JSON.stringify(progress))
  }

  const currentLangConfig = SUPPORTED_LANGUAGES[currentLanguage] || SUPPORTED_LANGUAGES['en']
  const t = translations[currentLanguage] || translations['en']
  const isRTL = currentLangConfig.rtl || false

  // Générateur de problèmes mathématiques
  const generateProblem = (level: Level, operation: MathOperation): MathProblem => {
    const difficultyRanges = {
      beginner: { min: 1, max: 10 },
      elementary: { min: 1, max: 25 },
      intermediate: { min: 1, max: 50 },
      advanced: { min: 1, max: 100 },
      expert: { min: 1, max: 200 }
    }
    
    const range = difficultyRanges[level]
    let num1 = Math.floor(Math.random() * range.max) + range.min
    let num2 = Math.floor(Math.random() * range.max) + range.min
    let selectedOp = operation
    
    if (operation === 'mixed') {
      const operations = ['addition', 'subtraction', 'multiplication', 'division']
      selectedOp = operations[Math.floor(Math.random() * operations.length)] as MathOperation
    }
    
    let answer: number
    let operationSymbol: string
    
    switch (selectedOp) {
      case 'addition':
        answer = num1 + num2
        operationSymbol = '+'
        break
      case 'subtraction':
        if (num2 > num1) [num1, num2] = [num2, num1]
        answer = num1 - num2
        operationSymbol = '-'
        break
      case 'multiplication':
        num1 = Math.floor(Math.random() * (range.max / 4)) + 1
        num2 = Math.floor(Math.random() * (range.max / 4)) + 1
        answer = num1 * num2
        operationSymbol = '×'
        break
      case 'division':
        num2 = Math.floor(Math.random() * 12) + 1
        answer = Math.floor(Math.random() * (range.max / 4)) + 1
        num1 = num2 * answer
        operationSymbol = '÷'
        break
      default:
        answer = num1 + num2
        operationSymbol = '+'
    }
    
    return { 
      num1, 
      num2, 
      operation: operationSymbol, 
      operationType: selectedOp,
      answer,
      level,
      difficulty: 1
    }
  }

  // Validation de réponse
  const validateAnswer = () => {
    if (!gameState.currentProblem) return
    
    const userNum = parseInt(gameState.userAnswer)
    if (isNaN(userNum)) return
    
    const isCorrect = userNum === gameState.currentProblem.answer
    const newProgress = { ...userProgress }
    newProgress.totalQuestions++
    newProgress.freeQuestionsUsed++
    
    if (isCorrect) {
      newProgress.correctAnswers[selectedLevel]++
      newProgress.totalPoints += 10
      newProgress.streak = (newProgress.streak || 0) + 1
      newProgress.bestStreak = Math.max(newProgress.bestStreak, newProgress.streak)
      
      // Celebration
      confetti({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.6 }
      })
      
      // Vérifier déverrouillage de niveau
      if (newProgress.correctAnswers[selectedLevel] >= 100) {
        const levels: Level[] = ['beginner', 'elementary', 'intermediate', 'advanced', 'expert']
        const currentIndex = levels.indexOf(selectedLevel)
        if (currentIndex < levels.length - 1 && !newProgress.unlockedLevels.includes(levels[currentIndex + 1])) {
          newProgress.unlockedLevels.push(levels[currentIndex + 1])
          toast.success(t.game.levelUnlocked, {
            duration: 3000,
            icon: '🎉'
          })
        }
      }
      
      setGameState(prev => ({
        ...prev,
        isCorrect: true,
        feedback: {
          type: 'correct',
          message: t.game.correctAnswer,
          celebration: true
        },
        streak: prev.streak + 1,
        points: prev.points + 10
      }))
      
      // Générer nouveau problème
      setTimeout(() => {
        const newProblem = generateProblem(selectedLevel, selectedOperation)
        setGameState(prev => ({
          ...prev,
          currentProblem: newProblem,
          userAnswer: '',
          isAnswered: false,
          isCorrect: null,
          feedback: { type: null, message: '' }
        }))
      }, 2000)
      
    } else {
      newProgress.streak = 0
      
      setGameState(prev => ({
        ...prev,
        isCorrect: false,
        feedback: {
          type: 'incorrect',
          message: t.game.wrongAnswer.replace('{answer}', gameState.currentProblem!.answer.toString())
        },
        streak: 0
      }))
    }
    
    saveUserData(newProgress)
    
    if (soundEnabled) {
      // Ici on jouerait un son selon le résultat
      // playSound(isCorrect ? 'success' : 'error')
    }
  }

  const canPlayFree = () => {
    return userProgress.freeQuestionsUsed < 50 && !subscriptionStatus.isSubscribed
  }

  const startGame = (level: Level, operation: MathOperation) => {
    if (!subscriptionStatus.isSubscribed && !canPlayFree()) {
      setCurrentView('subscribe')
      return
    }
    
    setSelectedLevel(level)
    setSelectedOperation(operation)
    const problem = generateProblem(level, operation)
    setGameState({
      currentProblem: problem,
      userAnswer: '',
      isAnswered: false,
      isCorrect: null,
      feedback: { type: null, message: '' },
      streak: userProgress.streak,
      points: userProgress.totalPoints,
      timeRemaining: 60,
      hintsUsed: 0
    })
    setCurrentView('game')
  }

  const selectLanguage = (language: SupportedLanguage) => {
    setCurrentLanguage(language)
    localStorage.setItem('math4child-language', language)
    setShowLanguageDropdown(false)
    
    // Appliquer RTL
    document.documentElement.dir = currentLangConfig.rtl ? 'rtl' : 'ltr'
    document.documentElement.lang = language
    
    toast.success(`Language changed to ${SUPPORTED_LANGUAGES[language].nativeName}`, {
      duration: 2000
    })
  }

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <motion.div
            animate={{ rotate: 360 }}
            transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
            className="w-16 h-16 border-4 border-blue-500 border-t-transparent rounded-full mx-auto mb-4"
          />
          <p className="text-lg text-gray-600">Loading Math4Child...</p>
        </div>
      </div>
    )
  }

  // Rendu conditionnel des vues
  if (currentView === 'game') {
    return <GameView />
  }
  
  if (currentView === 'subscribe') {
    return <SubscriptionView />
  }

  // VUE PRINCIPALE - HOME
  return (
    <div className={`min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 ${isRTL ? 'rtl' : 'ltr'}`} dir={isRTL ? 'rtl' : 'ltr'}>
      <Toaster position="top-right" />
      
      {/* Header */}
      <header className="p-4 flex justify-between items-center backdrop-blur-sm bg-white/30 sticky top-0 z-50">
        <motion.div 
          className="flex items-center space-x-2 group cursor-pointer"
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          <div className="p-2 bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl group-hover:from-purple-600 group-hover:to-blue-500 transition-all duration-300">
            <Calculator className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            {t.appName}
          </span>
        </motion.div>
        
        <div className="flex items-center space-x-4">
          {/* Compteur questions gratuites */}
          {!subscriptionStatus.isSubscribed && (
            <motion.div 
              className="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-xs font-semibold"
              animate={{ scale: [1, 1.05, 1] }}
              transition={{ duration: 2, repeat: Infinity }}
            >
              {t.game.freeQuestionsLeft.replace('{count}', (50 - userProgress.freeQuestionsUsed).toString())}
            </motion.div>
          )}
          
          {/* Contrôle du son */}
          <motion.button
            onClick={() => {
              setSoundEnabled(!soundEnabled)
              localStorage.setItem('math4child-sound', JSON.stringify(!soundEnabled))
            }}
            className="p-2 bg-white/20 backdrop-blur-sm rounded-lg text-white hover:bg-white/30 transition-colors"
            whileHover={{ scale: 1.1 }}
            whileTap={{ scale: 0.9 }}
          >
            {soundEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
          </motion.button>
          
          {/* Sélecteur de langues */}
          <div className="relative">
            <motion.button 
              onClick={() => setShowLanguageDropdown(!showLanguageDropdown)}
              className="appearance-none bg-white/90 backdrop-blur border border-gray-200 rounded-xl px-4 py-2 text-sm font-medium text-gray-700 hover:border-blue-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-all duration-200 cursor-pointer flex items-center space-x-2"
              whileHover={{ scale: 1.02 }}
            >
              <span>{currentLangConfig.flag}</span>
              <span>{currentLangConfig.nativeName}</span>
              <ChevronDown className={`w-4 h-4 transition-transform ${showLanguageDropdown ? 'rotate-180' : ''}`} />
            </motion.button>
            
            <AnimatePresence>
              {showLanguageDropdown && (
                <motion.div
                  initial={{ opacity: 0, y: -10 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -10 }}
                  className="absolute right-0 mt-2 bg-white rounded-xl shadow-2xl z-50 max-h-96 overflow-y-auto border"
                >
                  <div className="p-2">
                    {Object.entries(SUPPORTED_LANGUAGES).map(([code, config]) => (
                      <motion.button
                        key={code}
                        onClick={() => selectLanguage(code as SupportedLanguage)}
                        className="w-full text-left px-3 py-2 rounded-lg hover:bg-blue-50 transition-colors flex items-center space-x-3 min-w-[200px]"
                        whileHover={{ backgroundColor: '#eff6ff' }}
                      >
                        <span className="text-xl">{config.flag}</span>
                        <div>
                          <div className="font-medium text-gray-900">{config.nativeName}</div>
                          <div className="text-sm text-gray-500">{config.name}</div>
                        </div>
                        {currentLanguage === code && <Check className="w-4 h-4 text-blue-500 ml-auto" />}
                      </motion.button>
                    ))}
                  </div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </div>
      </header>

      {/* Contenu principal */}
      <main className="container mx-auto px-4 py-8">
        {/* Hero Section */}
        <div className="max-w-6xl mx-auto text-center mb-16">
          <motion.div 
            className="relative mb-8"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.8 }}
          >
            <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-6 leading-tight">
              {t.title}
            </h1>
            <motion.div 
              className="absolute -top-4 -right-4 text-4xl cursor-pointer"
              animate={{ y: [0, -10, 0] }}
              transition={{ duration: 2, repeat: Infinity }}
            >
              🎨
            </motion.div>
            <motion.div 
              className="absolute -bottom-2 -left-4 text-3xl cursor-pointer"
              animate={{ rotate: [0, 10, 0] }}
              transition={{ duration: 3, repeat: Infinity }}
            >
              ✨
            </motion.div>
          </motion.div>
          
          <motion.p 
            className="text-xl md:text-2xl text-gray-600 mb-4 max-w-