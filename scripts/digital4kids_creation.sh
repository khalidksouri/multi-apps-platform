#!/bin/bash

# Script de création de Digital4Kids - Marketing Digital pour Enfants
# Application hybride React + TypeScript pour enfants de 5 à 14 ans

set -e

WORKSPACE_DIR="/Users/khalidksouri/global-multi-apps-workspace"
PROJECT_DIR="/Users/khalidksouri/Desktop/multi-apps-platform"
APP_NAME="digital4kids"
APP_PORT="3006"
APP_DIR="$WORKSPACE_DIR/$APP_NAME"

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${PURPLE}🚀 CRÉATION DE DIGITAL4KIDS${NC}"
echo -e "${PURPLE}=============================${NC}"
echo ""
echo -e "${CYAN}🎯 Application: Marketing Digital pour Enfants (5-14 ans)${NC}"
echo -e "${CYAN}📱 Port: $APP_PORT${NC}"
echo -e "${CYAN}📁 Répertoire: $APP_DIR${NC}"
echo ""

# Fonction pour créer la structure de base
create_app_structure() {
    echo -e "${YELLOW}📁 Création de la structure de l'application...${NC}"
    
    # Créer le répertoire principal
    mkdir -p "$APP_DIR"
    cd "$APP_DIR"
    
    # Nettoyer si existe déjà
    rm -rf node_modules package-lock.json .npm 2>/dev/null || true
    
    echo -e "  ✅ Structure de base créée"
}

# Fonction pour créer package.json
create_package_json() {
    echo -e "${YELLOW}📝 Création du package.json...${NC}"
    
    cat > package.json << EOF
{
  "name": "digital4kids",
  "version": "1.0.0",
  "private": true,
  "description": "Application éducative de marketing digital pour enfants de 5 à 14 ans",
  "keywords": ["marketing", "digital", "enfants", "éducation", "quiz", "e-learning"],
  "author": "Khalid Ksouri",
  "dependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "typescript": "^4.9.5",
    "react-router-dom": "^6.8.0",
    "framer-motion": "^10.16.0",
    "lucide-react": "^0.263.1",
    "react-confetti": "^6.1.0",
    "react-hot-toast": "^2.4.1"
  },
  "scripts": {
    "start": "PORT=$APP_PORT react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject",
    "dev": "npm start"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF
    
    echo -e "  ✅ package.json créé"
}

# Fonction pour créer les fichiers de configuration
create_config_files() {
    echo -e "${YELLOW}⚙️ Création des fichiers de configuration...${NC}"
    
    # .env
    cat > .env << EOF
PORT=$APP_PORT
BROWSER=none
SKIP_PREFLIGHT_CHECK=true
GENERATE_SOURCEMAP=false
REACT_APP_NAME=Digital4Kids
REACT_APP_VERSION=1.0.0
EOF
    
    # tsconfig.json
    cat > tsconfig.json << EOF
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "es6"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": [
    "src"
  ]
}
EOF
    
    echo -e "  ✅ Fichiers de configuration créés"
}

# Fonction pour créer le dossier public
create_public_folder() {
    echo -e "${YELLOW}🌐 Création du dossier public...${NC}"
    
    mkdir -p public
    
    # index.html
    cat > public/index.html << EOF
<!DOCTYPE html>
<html lang="fr">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" href="%PUBLIC_URL%/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#FF6B6B" />
    <meta name="description" content="Digital4Kids - Apprenez le marketing digital en s'amusant ! Quizz, photos, e-learning pour enfants de 5 à 14 ans." />
    <meta name="keywords" content="marketing digital, enfants, éducation, quiz, e-learning, publicité, réseaux sociaux" />
    <title>Digital4Kids - Marketing Digital pour Enfants</title>
    
    <!-- Favicon et icons -->
    <link rel="apple-touch-icon" sizes="180x180" href="%PUBLIC_URL%/apple-touch-icon.png">
    <link rel="icon" type="image/png" sizes="32x32" href="%PUBLIC_URL%/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="%PUBLIC_URL%/favicon-16x16.png">
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka+One:wght@400&family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">
  </head>
  <body>
    <noscript>Vous devez activer JavaScript pour utiliser Digital4Kids.</noscript>
    <div id="root"></div>
  </body>
</html>
EOF
    
    # manifest.json
    cat > public/manifest.json << EOF
{
  "short_name": "Digital4Kids",
  "name": "Digital4Kids - Marketing Digital pour Enfants",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    }
  ],
  "start_url": ".",
  "display": "standalone",
  "theme_color": "#FF6B6B",
  "background_color": "#FFFFFF"
}
EOF
    
    echo -e "  ✅ Dossier public créé"
}

# Fonction pour créer les composants React
create_react_components() {
    echo -e "${YELLOW}⚛️ Création des composants React...${NC}"
    
    mkdir -p src/components src/pages src/data src/types src/hooks src/utils
    
    # Types TypeScript
    cat > src/types/index.ts << EOF
export interface Quiz {
  id: string;
  title: string;
  description: string;
  category: 'social-media' | 'advertising' | 'content' | 'analytics';
  ageGroup: '5-8' | '9-12' | '13-14';
  difficulty: 'easy' | 'medium' | 'hard';
  questions: Question[];
  icon: string;
  color: string;
}

export interface Question {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  explanation: string;
  image?: string;
  points: number;
}

export interface Photo {
  id: string;
  url: string;
  title: string;
  description: string;
  category: string;
  marketingConcept: string;
  ageGroup: string;
}

export interface LearningModule {
  id: string;
  title: string;
  description: string;
  content: string;
  category: string;
  ageGroup: string;
  duration: number;
  difficulty: string;
  completed: boolean;
}

export interface UserProgress {
  totalScore: number;
  completedQuizzes: string[];
  completedModules: string[];
  currentLevel: number;
  badges: string[];
}
EOF
    
    # Données des quiz
    cat > src/data/quizzes.ts << EOF
import { Quiz } from '../types';

export const quizzes: Quiz[] = [
  {
    id: 'social-media-basics',
    title: 'Les Réseaux Sociaux',
    description: 'Découvre comment fonctionnent les réseaux sociaux !',
    category: 'social-media',
    ageGroup: '5-8',
    difficulty: 'easy',
    icon: '📱',
    color: '#FF6B6B',
    questions: [
      {
        id: 'q1',
        question: 'Quel emoji utilise-t-on pour dire "j\'aime" ?',
        options: ['❤️ Cœur rouge', '😢 Visage triste', '😡 Visage en colère', '🤔 Visage pensif'],
        correctAnswer: 0,
        explanation: 'Le cœur rouge ❤️ est le symbole universel pour dire qu\'on aime quelque chose !',
        points: 10
      },
      {
        id: 'q2',
        question: 'Où partage-t-on des photos avec ses amis ?',
        options: ['Dans un livre', 'Sur un réseau social', 'Dans sa chambre', 'À la télé'],
        correctAnswer: 1,
        explanation: 'Les réseaux sociaux permettent de partager des photos avec nos amis et notre famille !',
        points: 10
      }
    ]
  },
  {
    id: 'advertising-fun',
    title: 'La Publicité Amusante',
    description: 'Apprends comment la publicité nous parle !',
    category: 'advertising',
    ageGroup: '9-12',
    difficulty: 'medium',
    icon: '🎯',
    color: '#4ECDC4',
    questions: [
      {
        id: 'q1',
        question: 'Pourquoi les publicités utilisent des couleurs vives ?',
        options: ['Pour nous faire peur', 'Pour attirer notre attention', 'Pour nous endormir', 'Pour nous rendre tristes'],
        correctAnswer: 1,
        explanation: 'Les couleurs vives attirent notre œil et nous font remarquer la publicité !',
        points: 15
      },
      {
        id: 'q2',
        question: 'Qu\'est-ce qu\'un slogan ?',
        options: ['Une chanson', 'Une phrase qui résume une marque', 'Un dessin', 'Un jeu vidéo'],
        correctAnswer: 1,
        explanation: 'Un slogan est une phrase courte et mémorable qui représente une marque, comme "Just Do It" de Nike !',
        points: 15
      }
    ]
  },
  {
    id: 'content-creation',
    title: 'Créer du Contenu',
    description: 'Apprends à créer du contenu intéressant !',
    category: 'content',
    ageGroup: '13-14',
    difficulty: 'hard',
    icon: '🎨',
    color: '#95E1D3',
    questions: [
      {
        id: 'q1',
        question: 'Qu\'est-ce qui rend une photo Instagram populaire ?',
        options: ['Elle est floue', 'Elle raconte une histoire', 'Elle est en noir et blanc', 'Elle est prise la nuit'],
        correctAnswer: 1,
        explanation: 'Les photos qui racontent une histoire créent une connexion émotionnelle avec les gens !',
        points: 20
      }
    ]
  }
];
EOF
    
    # Logo Digital4Kids
    cat > src/components/Digital4KidsLogo.tsx << EOF
import React from 'react';

interface Digital4KidsLogoProps {
  size?: 'small' | 'medium' | 'large';
  animated?: boolean;
}

const Digital4KidsLogo: React.FC<Digital4KidsLogoProps> = ({ 
  size = 'medium', 
  animated = true 
}) => {
  const sizeClasses = {
    small: 'w-16 h-16',
    medium: 'w-24 h-24',
    large: 'w-32 h-32'
  };

  return (
    <div className={\`flex items-center space-x-3 \${animated ? 'hover:scale-105 transition-transform duration-300' : ''}\`}>
      <div className={\`\${sizeClasses[size]} relative\`}>
        <svg viewBox="0 0 100 100" className="w-full h-full">
          {/* Cercle principal avec dégradé */}
          <defs>
            <linearGradient id="digital4kids-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#FF6B6B" />
              <stop offset="25%" stopColor="#4ECDC4" />
              <stop offset="50%" stopColor="#45B7D1" />
              <stop offset="75%" stopColor="#95E1D3" />
              <stop offset="100%" stopColor="#FFA07A" />
            </linearGradient>
          </defs>
          
          {/* Fond cercle */}
          <circle 
            cx="50" 
            cy="50" 
            r="48" 
            fill="url(#digital4kids-gradient)"
            className={\`\${animated ? 'animate-pulse' : ''}\`}
          />
          
          {/* Icône Digital (écran/tablette) */}
          <rect x="25" y="30" width="50" height="35" rx="4" fill="white" opacity="0.9"/>
          <rect x="28" y="33" width="44" height="25" rx="2" fill="#333"/>
          
          {/* Écran tactile - points lumineux */}
          <circle cx="35" cy="40" r="2" fill="#FF6B6B" className={\`\${animated ? 'animate-ping' : ''}\`}/>
          <circle cx="45" cy="40" r="2" fill="#4ECDC4" className={\`\${animated ? 'animate-ping' : ''}\`} style={{animationDelay: '0.5s'}}/>
          <circle cx="55" cy="40" r="2" fill="#45B7D1" className={\`\${animated ? 'animate-ping' : ''}\`} style={{animationDelay: '1s'}}/>
          <circle cx="65" cy="40" r="2" fill="#95E1D3" className={\`\${animated ? 'animate-ping' : ''}\`} style={{animationDelay: '1.5s'}}/>
          
          {/* Graphique marketing simplifié */}
          <polyline
            points="30,50 40,45 50,48 60,42 70,47"
            fill="none"
            stroke="white"
            strokeWidth="2"
            opacity="0.8"
          />
          
          {/* Bouton home */}
          <circle cx="50" cy="62" r="3" fill="white" opacity="0.7"/>
        </svg>
      </div>
      
      <div className="flex flex-col">
        <span className="text-2xl font-bold bg-gradient-to-r from-pink-500 via-purple-500 to-blue-500 bg-clip-text text-transparent">
          Digital4Kids
        </span>
        <span className="text-sm text-gray-600 font-medium">Marketing Digital</span>
      </div>
    </div>
  );
};

export default Digital4KidsLogo;
EOF
    
    # Component principal App
    cat > src/App.tsx << EOF
import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './pages/HomePage';
import QuizPage from './pages/QuizPage';
import PhotoPage from './pages/PhotoPage';
import LearningPage from './pages/LearningPage';
import { Toaster } from 'react-hot-toast';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Toaster 
          position="top-center"
          toastOptions={{
            duration: 3000,
            style: {
              background: '#333',
              color: '#fff',
              borderRadius: '10px',
            },
          }}
        />
        
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/quiz" element={<QuizPage />} />
          <Route path="/photos" element={<PhotoPage />} />
          <Route path="/learning" element={<LearningPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
EOF
    
    echo -e "  ✅ Composants React créés"
}

# Fonction pour créer les pages
create_pages() {
    echo -e "${YELLOW}📄 Création des pages...${NC}"
    
    # Page d'accueil
    cat > src/pages/HomePage.tsx << EOF
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import Digital4KidsLogo from '../components/Digital4KidsLogo';
import { BookOpen, Image, Brain, Trophy, Star, Target } from 'lucide-react';

const HomePage: React.FC = () => {
  const navigate = useNavigate();

  const features = [
    {
      id: 'quiz',
      title: 'Quiz Interactifs',
      description: 'Teste tes connaissances en marketing digital avec des quiz amusants !',
      icon: Brain,
      color: 'from-pink-500 to-red-500',
      path: '/quiz',
      ageGroup: '5-14 ans'
    },
    {
      id: 'photos',
      title: 'Photos Marketing',
      description: 'Découvre comment les images racontent des histoires marketing !',
      icon: Image,
      color: 'from-blue-500 to-cyan-500',
      path: '/photos',
      ageGroup: '7-14 ans'
    },
    {
      id: 'learning',
      title: 'E-Learning',
      description: 'Apprends le marketing digital étape par étape !',
      icon: BookOpen,
      color: 'from-green-500 to-emerald-500',
      path: '/learning',
      ageGroup: '9-14 ans'
    }
  ];

  const stats = [
    { icon: Target, label: 'Quiz Complétés', value: '0', color: 'text-pink-500' },
    { icon: Star, label: 'Badges Gagnés', value: '0', color: 'text-yellow-500' },
    { icon: Trophy, label: 'Niveau Actuel', value: '1', color: 'text-purple-500' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100">
      {/* Header */}
      <motion.header 
        initial={{ y: -50, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="bg-white/80 backdrop-blur-md shadow-lg border-b border-white/20"
      >
        <div className="max-w-7xl mx-auto px-4 py-6">
          <div className="flex items-center justify-between">
            <Digital4KidsLogo size="large" animated={true} />
            <div className="hidden md:flex items-center space-x-6">
              {stats.map((stat, index) => (
                <div key={index} className="text-center">
                  <div className={\`flex items-center justify-center w-8 h-8 mx-auto mb-1 \${stat.color}\`}>
                    <stat.icon size={20} />
                  </div>
                  <div className="text-lg font-bold text-gray-800">{stat.value}</div>
                  <div className="text-xs text-gray-600">{stat.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </motion.header>

      {/* Hero Section */}
      <motion.section 
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="max-w-7xl mx-auto px-4 py-16 text-center"
      >
        <h1 className="text-5xl md:text-7xl font-bold mb-6 bg-gradient-to-r from-pink-600 via-purple-600 to-blue-600 bg-clip-text text-transparent">
          Bienvenue dans Digital4Kids !
        </h1>
        <p className="text-xl md:text-2xl text-gray-700 mb-8 max-w-4xl mx-auto leading-relaxed">
          🚀 Découvre le monde passionnant du marketing digital ! 
          <br />
          Apprends comment les marques communiquent, créent du contenu et touchent leur audience.
        </p>
        <div className="flex flex-wrap justify-center gap-4 text-lg">
          <span className="bg-pink-100 text-pink-800 px-4 py-2 rounded-full font-semibold">
            👶 5-8 ans : Quiz simples
          </span>
          <span className="bg-blue-100 text-blue-800 px-4 py-2 rounded-full font-semibold">
            🧒 9-12 ans : Concepts avancés
          </span>
          <span className="bg-purple-100 text-purple-800 px-4 py-2 rounded-full font-semibold">
            👦 13-14 ans : Stratégies marketing
          </span>
        </div>
      </motion.section>

      {/* Features Grid */}
      <section className="max-w-7xl mx-auto px-4 py-16">
        <div className="grid md:grid-cols-3 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={feature.id}
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.3 + index * 0.1 }}
              className="group cursor-pointer"
              onClick={() => navigate(feature.path)}
            >
              <div className="bg-white/60 backdrop-blur-md rounded-3xl p-8 h-full border border-white/20 shadow-xl hover:shadow-2xl transition-all duration-300 hover:-translate-y-2">
                <div className={\`w-16 h-16 rounded-2xl bg-gradient-to-r \${feature.color} flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300\`}>
                  <feature.icon className="text-white" size={32} />
                </div>
                
                <h3 className="text-2xl font-bold text-gray-800 mb-4">
                  {feature.title}
                </h3>
                
                <p className="text-gray-600 mb-6 leading-relaxed">
                  {feature.description}
                </p>
                
                <div className="flex items-center justify-between">
                  <span className="text-sm bg-gray-100 text-gray-700 px-3 py-1 rounded-full font-medium">
                    {feature.ageGroup}
                  </span>
                  <motion.button
                    whileHover={{ scale: 1.05 }}
                    whileTap={{ scale: 0.95 }}
                    className={\`px-6 py-2 bg-gradient-to-r \${feature.color} text-white rounded-full font-semibold hover:shadow-lg transition-all duration-300\`}
                  >
                    Commencer
                  </motion.button>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      {/* CTA Section */}
      <motion.section 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.6, delay: 0.8 }}
        className="max-w-4xl mx-auto px-4 py-16 text-center"
      >
        <div className="bg-gradient-to-r from-pink-500 via-purple-500 to-blue-500 rounded-3xl p-12 text-white">
          <h2 className="text-4xl font-bold mb-4">
            Prêt à devenir un expert en marketing digital ? 🌟
          </h2>
          <p className="text-xl mb-8 opacity-90">
            Rejoins des milliers d'enfants qui découvrent le marketing de façon ludique !
          </p>
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={() => navigate('/quiz')}
            className="bg-white text-purple-600 px-8 py-4 rounded-full font-bold text-lg hover:shadow-xl transition-all duration-300"
          >
            Commencer l'aventure ! 🚀
          </motion.button>
        </div>
      </motion.section>

      {/* Footer */}
      <footer className="bg-gray-800 text-white py-8 mt-16">
        <div className="max-w-7xl mx-auto px-4 text-center">
          <Digital4KidsLogo size="medium" animated={false} />
          <p className="mt-4 text-gray-300">
            Digital4Kids - Marketing digital ludique pour enfants © 2025
          </p>
          <p className="text-sm text-gray-400 mt-2">
            Application éducative développée avec ❤️ pour l'apprentissage
          </p>
        </div>
      </footer>
    </div>
  );
};

export default HomePage;
EOF
    
    # Page Quiz
    cat > src/pages/QuizPage.tsx << EOF
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { ArrowLeft, Trophy, Star } from 'lucide-react';
import { quizzes } from '../data/quizzes';
import toast from 'react-hot-toast';
import confetti from 'canvas-confetti';

const QuizPage: React.FC = () => {
  const navigate = useNavigate();
  const [selectedQuiz, setSelectedQuiz] = useState<string | null>(null);
  const [currentQuestion, setCurrentQuestion] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [score, setScore] = useState(0);
  const [showResult, setShowResult] = useState(false);

  const quiz = selectedQuiz ? quizzes.find(q => q.id === selectedQuiz) : null;

  const handleQuizSelect = (quizId: string) => {
    setSelectedQuiz(quizId);
    setCurrentQuestion(0);
    setScore(0);
    setShowResult(false);
    setSelectedAnswer(null);
  };

  const handleAnswerSelect = (answerIndex: number) => {
    setSelectedAnswer(answerIndex);
  };

  const handleNextQuestion = () => {
    if (selectedAnswer === null) {
      toast.error('Sélectionne une réponse !');
      return;
    }

    const question = quiz!.questions[currentQuestion];
    const isCorrect = selectedAnswer === question.correctAnswer;

    if (isCorrect) {
      setScore(score + question.points);
      toast.success('Bonne réponse ! 🎉');
    } else {
      toast.error('Pas tout à fait... 💪');
    }

    // Attendre un peu pour laisser voir la réponse
    setTimeout(() => {
      if (currentQuestion + 1 < quiz!.questions.length) {
        setCurrentQuestion(currentQuestion + 1);
        setSelectedAnswer(null);
      } else {
        setShowResult(true);
        if (score >= quiz!.questions.length * 10) {
          confetti({
            particleCount: 100,
            spread: 70,
            origin: { y: 0.6 }
          });
        }
      }
    }, 2000);
  };

  const resetQuiz = () => {
    setSelectedQuiz(null);
    setCurrentQuestion(0);
    setScore(0);
    setShowResult(false);
    setSelectedAnswer(null);
  };

  if (!selectedQuiz) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100">
        <div className="max-w-7xl mx-auto px-4 py-8">
          {/* Header */}
          <div className="flex items-center mb-8">
            <button
              onClick={() => navigate('/')}
              className="flex items-center space-x-2 text-gray-600 hover:text-gray-800 transition-colors"
            >
              <ArrowLeft size={20} />
              <span>Retour</span>
            </button>
          </div>

          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center mb-12"
          >
            <h1 className="text-5xl font-bold mb-4 bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text text-transparent">
              Quiz Marketing Digital 🧠
            </h1>
            <p className="text-xl text-gray-700">
              Choisis un quiz adapté à ton âge et teste tes connaissances !
            </p>
          </motion.div>

          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
            {quizzes.map((quiz, index) => (
              <motion.div
                key={quiz.id}
                initial={{ opacity: 0, y: 50 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
                className="bg-white/60 backdrop-blur-md rounded-2xl p-6 border border-white/20 shadow-xl hover:shadow-2xl transition-all duration-300 cursor-pointer hover:-translate-y-1"
                onClick={() => handleQuizSelect(quiz.id)}
              >
                <div 
                  className="w-16 h-16 rounded-xl flex items-center justify-center text-3xl mb-4"
                  style={{ backgroundColor: quiz.color + '20' }}
                >
                  {quiz.icon}
                </div>
                <h3 className="text-xl font-bold text-gray-800 mb-2">
                  {quiz.title}
                </h3>
                <p className="text-gray-600 mb-4">
                  {quiz.description}
                </p>
                <div className="flex items-center justify-between">
                  <span className="text-sm bg-gray-100 text-gray-700 px-3 py-1 rounded-full">
                    {quiz.ageGroup}
                  </span>
                  <span className="text-sm text-gray-500">
                    {quiz.questions.length} questions
                  </span>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    );
  }

  if (showResult) {
    const totalPoints = quiz!.questions.reduce((sum, q) => sum + q.points, 0);
    const percentage = Math.round((score / totalPoints) * 100);
    
    return (
      <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100 flex items-center justify-center">
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          className="bg-white/80 backdrop-blur-md rounded-3xl p-12 text-center max-w-md mx-4 shadow-2xl"
        >
          <Trophy className="w-20 h-20 text-yellow-500 mx-auto mb-6" />
          <h2 className="text-3xl font-bold text-gray-800 mb-4">
            Quiz Terminé ! 🎉
          </h2>
          <div className="text-6xl font-bold mb-4" style={{ color: quiz!.color }}>
            {percentage}%
          </div>
          <p className="text-lg text-gray-600 mb-6">
            Tu as obtenu {score} points sur {totalPoints} !
          </p>
          
          {percentage >= 80 && (
            <div className="mb-6">
              <Star className="w-8 h-8 text-yellow-500 mx-auto mb-2" />
              <p className="text-yellow-600 font-semibold">
                Excellent travail ! 🌟
              </p>
            </div>
          )}
          
          <div className="space-y-3">
            <button
              onClick={resetQuiz}
              className="w-full bg-gradient-to-r from-pink-500 to-purple-500 text-white py-3 rounded-xl font-semibold hover:shadow-lg transition-all"
            >
              Autre Quiz
            </button>
            <button
              onClick={() => navigate('/')}
              className="w-full bg-gray-200 text-gray-800 py-3 rounded-xl font-semibold hover:bg-gray-300 transition-all"
            >
              Retour Accueil
            </button>
          </div>
        </motion.div>
      </div>
    );
  }

  const question = quiz!.questions[currentQuestion];

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100">
      <div className="max-w-4xl mx-auto px-4 py-8">
        {/* Header avec progression */}
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={resetQuiz}
            className="flex items-center space-x-2 text-gray-600 hover:text-gray-800 transition-colors"
          >
            <ArrowLeft size={20} />
            <span>Retour</span>
          </button>
          
          <div className="text-center">
            <h2 className="text-xl font-bold text-gray-800">{quiz!.title}</h2>
            <div className="text-sm text-gray-600">
              Question {currentQuestion + 1} sur {quiz!.questions.length}
            </div>
          </div>
          
          <div className="text-right">
            <div className="text-lg font-bold" style={{ color: quiz!.color }}>
              {score} points
            </div>
          </div>
        </div>

        {/* Barre de progression */}
        <div className="w-full bg-gray-200 rounded-full h-3 mb-8">
          <div
            className="h-3 rounded-full transition-all duration-500"
            style={{ 
              width: \`\${((currentQuestion) / quiz!.questions.length) * 100}%\`,
              backgroundColor: quiz!.color
            }}
          />
        </div>

        {/* Question */}
        <motion.div
          key={currentQuestion}
          initial={{ opacity: 0, x: 50 }}
          animate={{ opacity: 1, x: 0 }}
          className="bg-white/80 backdrop-blur-md rounded-3xl p-8 mb-8 shadow-xl"
        >
          <h3 className="text-2xl font-bold text-gray-800 mb-6">
            {question.question}
          </h3>

          <div className="space-y-4">
            {question.options.map((option, index) => (
              <motion.button
                key={index}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.98 }}
                onClick={() => handleAnswerSelect(index)}
                className={\`w-full p-4 rounded-xl border-2 text-left transition-all \${
                  selectedAnswer === index
                    ? 'border-purple-500 bg-purple-50'
                    : 'border-gray-200 bg-white hover:border-gray-300'
                }\`}
              >
                <div className="flex items-center space-x-3">
                  <div className={\`w-6 h-6 rounded-full border-2 flex items-center justify-center \${
                    selectedAnswer === index
                      ? 'border-purple-500 bg-purple-500'
                      : 'border-gray-300'
                  }\`}>
                    {selectedAnswer === index && (
                      <div className="w-3 h-3 bg-white rounded-full" />
                    )}
                  </div>
                  <span className="text-lg">{option}</span>
                </div>
              </motion.button>
            ))}
          </div>

          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={handleNextQuestion}
            disabled={selectedAnswer === null}
            className={\`mt-8 w-full py-4 rounded-xl font-semibold text-white transition-all \${
              selectedAnswer !== null
                ? 'bg-gradient-to-r from-pink-500 to-purple-500 hover:shadow-lg'
                : 'bg-gray-300 cursor-not-allowed'
            }\`}
          >
            {currentQuestion + 1 === quiz!.questions.length ? 'Terminer' : 'Question suivante'}
          </motion.button>
        </motion.div>
      </div>
    </div>
  );
};

export default QuizPage;
EOF
    
    # Pages Photos et Learning (plus simples pour commencer)
    cat > src/pages/PhotoPage.tsx << EOF
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Camera } from 'lucide-react';

const PhotoPage: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="flex items-center mb-8">
          <button
            onClick={() => navigate('/')}
            className="flex items-center space-x-2 text-gray-600 hover:text-gray-800 transition-colors"
          >
            <ArrowLeft size={20} />
            <span>Retour</span>
          </button>
        </div>

        <div className="text-center">
          <Camera className="w-24 h-24 text-blue-500 mx-auto mb-6" />
          <h1 className="text-4xl font-bold mb-4 text-gray-800">
            Photos Marketing 📸
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Fonctionnalité en développement... Bientôt disponible !
          </p>
          <div className="bg-white/60 backdrop-blur-md rounded-2xl p-8 max-w-md mx-auto">
            <h3 className="text-lg font-semibold mb-4">Prochainement :</h3>
            <ul className="text-left space-y-2 text-gray-700">
              <li>• Analyse d'images publicitaires</li>
              <li>• Création de visuels marketing</li>
              <li>• Comprendre les couleurs et émotions</li>
              <li>• Galerie de photos éducatives</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PhotoPage;
EOF
    
    cat > src/pages/LearningPage.tsx << EOF
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, BookOpen } from 'lucide-react';

const LearningPage: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-50 to-blue-100">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="flex items-center mb-8">
          <button
            onClick={() => navigate('/')}
            className="flex items-center space-x-2 text-gray-600 hover:text-gray-800 transition-colors"
          >
            <ArrowLeft size={20} />
            <span>Retour</span>
          </button>
        </div>

        <div className="text-center">
          <BookOpen className="w-24 h-24 text-green-500 mx-auto mb-6" />
          <h1 className="text-4xl font-bold mb-4 text-gray-800">
            E-Learning Marketing 📚
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            Modules d'apprentissage en préparation...
          </p>
          <div className="bg-white/60 backdrop-blur-md rounded-2xl p-8 max-w-md mx-auto">
            <h3 className="text-lg font-semibold mb-4">Modules prévus :</h3>
            <ul className="text-left space-y-2 text-gray-700">
              <li>• Les bases du marketing</li>
              <li>• Réseaux sociaux pour débutants</li>
              <li>• Création de contenu</li>
              <li>• Publicité responsable</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LearningPage;
EOF
    
    echo -e "  ✅ Pages créées"
}

# Fonction pour créer les styles CSS
create_styles() {
    echo -e "${YELLOW}🎨 Création des styles CSS...${NC}"
    
    cat > src/index.css << EOF
@import url('https://fonts.googleapis.com/css2?family=Fredoka+One:wght@400&family=Nunito:wght@300;400;600;700;800&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  min-height: 100vh;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New', monospace;
}

/* Scrollbar personnalisée */
::-webkit-scrollbar {
  width: 8px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 10px;
}

::-webkit-scrollbar-thumb {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  border-radius: 10px;
}

::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(45deg, #FF5252, #26D0CE);
}

/* Animations personnalisées */
@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
}

@keyframes pulse-soft {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.7; }
}

.animate-float {
  animation: float 3s ease-in-out infinite;
}

.animate-pulse-soft {
  animation: pulse-soft 2s ease-in-out infinite;
}

/* Effet glassmorphisme */
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

.glass-white {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.3);
}

/* Transitions fluides */
.transition-all {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Focus accessibilité */
.focus\\:ring-custom:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.3);
}

/* Responsive breakpoints */
@media (max-width: 640px) {
  .container-mobile {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}
EOF
    
    cat > src/App.css << EOF
.App {
  width: 100%;
  min-height: 100vh;
}

/* Styles pour les composants */
.card-hover {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card-hover:hover {
  transform: translateY(-5px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Boutons personnalisés */
.btn-primary {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  color: white;
  font-weight: 600;
  padding: 0.75rem 2rem;
  border-radius: 2rem;
  border: none;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  display: inline-block;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
}

.btn-secondary {
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
  color: #333;
  font-weight: 600;
  padding: 0.75rem 2rem;
  border-radius: 2rem;
  border: 1px solid rgba(255, 255, 255, 0.3);
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-secondary:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
}

/* Responsive grids */
.grid-responsive {
  display: grid;
  gap: 2rem;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}

/* Text gradients */
.text-gradient {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4, #45B7D1);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.text-gradient-purple {
  background: linear-gradient(45deg, #667eea, #764ba2);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Loading animations */
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #FF6B6B;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* Quiz styles */
.quiz-option {
  transition: all 0.2s ease;
}

.quiz-option:hover {
  background-color: #f8f9fa;
  transform: scale(1.02);
}

.quiz-option.selected {
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  color: white;
}

/* Progress bar */
.progress-bar {
  height: 8px;
  background: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
  transition: width 0.3s ease;
}

/* Mobile optimizations */
@media (max-width: 768px) {
  .mobile-padding {
    padding: 1rem;
  }
  
  .mobile-text-center {
    text-align: center;
  }
  
  .mobile-hidden {
    display: none;
  }
}
EOF
    
    echo -e "  ✅ Styles CSS créés"
}

# Fonction pour créer index.tsx
create_index() {
    echo -e "${YELLOW}⚛️ Création du fichier index.tsx...${NC}"
    
    cat > src/index.tsx << EOF
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF
    
    echo -e "  ✅ index.tsx créé"
}

# Fonction pour installer les dépendances
install_dependencies() {
    echo -e "${YELLOW}📦 Installation des dépendances...${NC}"
    
    cd "$APP_DIR"
    npm install --legacy-peer-deps --silent
    
    echo -e "  ✅ Dépendances installées"
}

# Fonction pour mettre à jour les scripts de la plateforme
update_platform_scripts() {
    echo -e "${YELLOW}🔧 Mise à jour des scripts de la plateforme...${NC}"
    
    cd "$PROJECT_DIR"
    
    # Mettre à jour start-apps.sh pour inclure Digital4Kids
    if [ -f "start-apps.sh" ]; then
        # Ajouter Digital4Kids dans la liste des applications
        sed -i.bak 's/start_app "multiai" 3005 "npm run dev"/start_app "multiai" 3005 "npm run dev"\n    start_app "digital4kids" 3006 "npm start"/' start-apps.sh
        echo -e "  ✅ start-apps.sh mis à jour"
    fi
    
    # Mettre à jour status-apps.sh pour inclure Digital4Kids
    if [ -f "status-apps.sh" ]; then
        sed -i.bak 's/check_app "multiai" 3005/check_app "multiai" 3005\n    check_app "digital4kids" 3006/' status-apps.sh
        echo -e "  ✅ status-apps.sh mis à jour"
    fi
    
    echo -e "  ✅ Scripts de la plateforme mis à jour"
}

# Fonction pour créer un script de test
create_test_script() {
    echo -e "${YELLOW}🧪 Création du script de test...${NC}"
    
    cd "$APP_DIR"
    
    cat > test-digital4kids.sh << EOF
#!/bin/bash

echo "🧪 Test de Digital4Kids..."
echo ""

# Test de la compilation
echo "📝 Test de compilation..."
if npm run build >/dev/null 2>&1; then
    echo "  ✅ Compilation réussie"
else
    echo "  ❌ Erreur de compilation"
    exit 1
fi

# Test du démarrage
echo "🚀 Test de démarrage..."
timeout 10s npm start >/dev/null 2>&1 &
sleep 5

if curl -s http://localhost:$APP_PORT >/dev/null; then
    echo "  ✅ Application accessible sur le port $APP_PORT"
    pkill -f "react-scripts start" 2>/dev/null
else
    echo "  ❌ Application non accessible"
    pkill -f "react-scripts start" 2>/dev/null
    exit 1
fi

echo ""
echo "🎉 Tous les tests passent ! Digital4Kids est prêt !"
EOF
    
    chmod +x test-digital4kids.sh
    
    echo -e "  ✅ Script de test créé"
}

# Fonction principale
main() {
    echo "Création de Digital4Kids - Application de marketing digital pour enfants..."
    echo ""
    
    create_app_structure
    create_package_json
    create_config_files
    create_public_folder
    create_react_components
    create_pages
    create_styles
    create_index
    install_dependencies
    update_platform_scripts
    create_test_script
    
    echo ""
    echo -e "${GREEN}🎉 DIGITAL4KIDS CRÉÉ AVEC SUCCÈS !${NC}"
    echo ""
    echo -e "${CYAN}📋 Résumé de l'application :${NC}"
    echo "✅ Application React + TypeScript"
    echo "✅ Interface moderne avec glassmorphisme"
    echo "✅ Quiz interactifs par groupe d'âge"
    echo "✅ Navigation fluide avec React Router"
    echo "✅ Animations avec Framer Motion"
    echo "✅ Notifications avec React Hot Toast"
    echo "✅ Effets visuels avec Confetti"
    echo "✅ Design responsive"
    echo ""
    echo -e "${YELLOW}🚀 Pour démarrer Digital4Kids :${NC}"
    echo "1. cd $APP_DIR"
    echo "2. npm start"
    echo "3. Ouvrir http://localhost:$APP_PORT"
    echo ""
    echo -e "${YELLOW}🔧 Pour tester l'application :${NC}"
    echo "cd $APP_DIR && ./test-digital4kids.sh"
    echo ""
    echo -e "${YELLOW}🌐 Pour démarrer toute la plateforme :${NC}"
    echo "cd $PROJECT_DIR && ./start-apps.sh"
    echo ""
    echo -e "${PURPLE}🎯 Digital4Kids est maintenant intégré à votre plateforme multi-apps !${NC}"
    echo -e "${PURPLE}   Vous avez maintenant 6 applications : Math4Kids, UnitFlip, BudgetCron, AI4Kids, MultiAI, et Digital4Kids${NC}"
    echo ""
}

# Gestion des erreurs
trap 'echo -e "${RED}❌ Erreur détectée à la ligne $LINENO${NC}"; exit 1' ERR

# Lancement du script
main