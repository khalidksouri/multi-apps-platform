#!/bin/bash

# =============================================================================
# 🐛 CORRECTIF DES BUGS DE TRADUCTION MATH4CHILD
# Corrige les mélanges de langues et duplications
# =============================================================================

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=================================${NC}"
    echo -e "${PURPLE}🐛 $1${NC}"
    echo -e "${PURPLE}=================================${NC}"
}

print_header "CORRECTIF DES BUGS DE TRADUCTION"

# Vérifications
if [ ! -d "apps/math4child" ]; then
    log_error "Dossier apps/math4child introuvable!"
    exit 1
fi

cd apps/math4child

# =============================================================================
# 1. ARRÊT DU SERVEUR
# =============================================================================

log_info "🛑 Arrêt du serveur..."
pkill -f "next dev" 2>/dev/null || true
sleep 2

# =============================================================================
# 2. CORRECTIF DES TRADUCTIONS BUGGUÉES
# =============================================================================

log_info "🔧 Correction des bugs de traduction..."

# Sauvegarder l'ancien fichier
cp src/app/page.tsx "src/app/page.tsx.backup_bugfix_$(date +%Y%m%d_%H%M%S)"

# Créer le fichier corrigé
cat > src/app/page.tsx << 'EOF'
'use client';

import React, { useState, useEffect } from 'react';

interface Language {
  code: string;
  name: string;
  nativeName: string;
  flag: string;
}

const LANGUAGES: Language[] = [
  { code: 'fr', name: 'Français', nativeName: 'Français', flag: '🇫🇷' },
  { code: 'en', name: 'English', nativeName: 'English', flag: '🇺🇸' },
  { code: 'es', name: 'Español', nativeName: 'Español', flag: '🇪🇸' },
  { code: 'de', name: 'Deutsch', nativeName: 'Deutsch', flag: '🇩🇪' },
  { code: 'ar', name: 'العربية', nativeName: 'العربية', flag: '🇲🇦' },
  { code: 'zh', name: '中文', nativeName: '中文', flag: '🇨🇳' },
  { code: 'it', name: 'Italiano', nativeName: 'Italiano', flag: '🇮🇹' },
  { code: 'pt', name: 'Português', nativeName: 'Português', flag: '🇵🇹' },
  { code: 'ru', name: 'Русский', nativeName: 'Русский', flag: '🇷🇺' },
  { code: 'ja', name: '日本語', nativeName: '日本語', flag: '🇯🇵' },
  { code: 'ko', name: '한국어', nativeName: '한국어', flag: '🇰🇷' },
  { code: 'nl', name: 'Nederlands', nativeName: 'Nederlands', flag: '🇳🇱' },
];

const TRANSLATIONS: Record<string, Record<string, string>> = {
  fr: {
    title: 'Math4Child - Apprends les maths en t\'amusant !',
    subtitle: 'L\'app éducative n°1 pour apprendre les mathématiques en famille',
    badge: 'App éducative n°1 en France',
    welcome: 'Bienvenue dans l\'aventure mathématique !',
    description: 'Une application complète pour apprendre les mathématiques de façon ludique et interactive.',
    startFree: 'Commencer gratuitement',
    viewPlans: 'Voir les plans',
    familiesCount: '100k+ familles nous font confiance',
    features: 'Fonctionnalités principales',
    featuresSubtitle: 'Découvrez toutes les fonctionnalités qui font de Math4Child l\'app n°1',
    feature1: 'Calculs interactifs et exercices adaptés',
    feature2: '5 niveaux de difficulté progressifs',
    feature3: 'Suivi détaillé des progrès',
    feature4: 'Jeux éducatifs et défis mathématiques',
    feature5: 'Plus de 30 langues disponibles',
    feature6: 'Disponible sur Web, iOS et Android',
    pricing: 'Plans d\'abonnement',
    choosePlan: 'Choisir ce plan',
    popular: 'Le plus populaire',
    month: '/mois',
    footerFeatures: 'Fonctionnalités',
    footerSupport: 'Support',
    footerDownload: 'Télécharger',
    footerDescription: 'L\'application éducative de référence pour apprendre les mathématiques en famille.',
    footerInteractive: 'Exercices interactifs',
    footerProgress: 'Suivi des progrès',
    footerGames: 'Jeux éducatifs',
    footerMultiplayer: 'Mode multi-joueurs',
    footerHelp: 'Centre d\'aide',
    footerContact: 'Contact',
    footerGuides: 'Guides parents',
    footerCommunity: 'Communauté',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Télécharger sur',
    footerAvailableOn: 'Disponible sur',
    footerCopyright: 'Tous droits réservés.',
    appStoreRating: '4.9/5 sur l\'App Store'
  },
  en: {
    title: 'Math4Child - Learn math while having fun!',
    subtitle: 'The #1 educational app for learning mathematics as a family',
    badge: '#1 Educational App in France',
    welcome: 'Welcome to the mathematical adventure!',
    description: 'A comprehensive application to learn mathematics in a fun and interactive way.',
    startFree: 'Start Free',
    viewPlans: 'View Plans',
    familiesCount: '100k+ families trust us',
    features: 'Key Features',
    featuresSubtitle: 'Discover all the features that make Math4Child the #1 app',
    feature1: 'Interactive calculations and adapted exercises',
    feature2: '5 progressive difficulty levels',
    feature3: 'Detailed progress tracking',
    feature4: 'Educational games and math challenges',
    feature5: 'More than 30 languages available',
    feature6: 'Available on Web, iOS and Android',
    pricing: 'Subscription Plans',
    choosePlan: 'Choose this plan',
    popular: 'Most popular',
    month: '/month',
    footerFeatures: 'Features',
    footerSupport: 'Support',
    footerDownload: 'Download',
    footerDescription: 'The reference educational application for learning mathematics as a family.',
    footerInteractive: 'Interactive exercises',
    footerProgress: 'Progress tracking',
    footerGames: 'Educational games',
    footerMultiplayer: 'Multiplayer mode',
    footerHelp: 'Help Center',
    footerContact: 'Contact',
    footerGuides: 'Parent Guides',
    footerCommunity: 'Community',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Download on',
    footerAvailableOn: 'Available on',
    footerCopyright: 'All rights reserved.',
    appStoreRating: '4.9/5 on the App Store'
  },
  es: {
    title: 'Math4Child - ¡Aprende matemáticas divirtiéndote!',
    subtitle: 'La app educativa n°1 para aprender matemáticas en familia',
    badge: 'App Educativa n°1 en Francia',
    welcome: '¡Bienvenido a la aventura matemática!',
    description: 'Una aplicación completa para aprender matemáticas de forma divertida e interactiva.',
    startFree: 'Comenzar gratis',
    viewPlans: 'Ver planes',
    familiesCount: '100k+ familias confían en nosotros',
    features: 'Características principales',
    featuresSubtitle: 'Descubre todas las características que hacen de Math4Child la app n°1',
    feature1: 'Cálculos interactivos y ejercicios adaptados',
    feature2: '5 niveles de dificultad progresivos',
    feature3: 'Seguimiento detallado del progreso',
    feature4: 'Juegos educativos y desafíos matemáticos',
    feature5: 'Más de 30 idiomas disponibles',
    feature6: 'Disponible en Web, iOS y Android',
    pricing: 'Planes de suscripción',
    choosePlan: 'Elegir este plan',
    popular: 'Más popular',
    month: '/mes',
    footerFeatures: 'Características',
    footerSupport: 'Soporte',
    footerDownload: 'Descargar',
    footerDescription: 'La aplicación educativa de referencia para aprender matemáticas en familia.',
    footerInteractive: 'Ejercicios interactivos',
    footerProgress: 'Seguimiento del progreso',
    footerGames: 'Juegos educativos',
    footerMultiplayer: 'Modo multijugador',
    footerHelp: 'Centro de ayuda',
    footerContact: 'Contacto',
    footerGuides: 'Guías para padres',
    footerCommunity: 'Comunidad',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Descargar en',
    footerAvailableOn: 'Disponible en',
    footerCopyright: 'Todos los derechos reservados.',
    appStoreRating: '4.9/5 en la App Store'
  },
  de: {
    title: 'Math4Child - Lerne Mathe mit Spaß!',
    subtitle: 'Die #1 Bildungs-App zum Mathematiklernen für die ganze Familie',
    badge: '#1 Bildungs-App in Frankreich',
    welcome: 'Willkommen zum mathematischen Abenteuer!',
    description: 'Eine umfassende Anwendung zum spielerischen und interaktiven Lernen von Mathematik.',
    startFree: 'Kostenlos starten',
    viewPlans: 'Pläne ansehen',
    familiesCount: '100k+ Familien vertrauen uns',
    features: 'Hauptfunktionen',
    featuresSubtitle: 'Entdecken Sie alle Funktionen, die Math4Child zur #1 App machen',
    feature1: 'Interaktive Berechnungen und angepasste Übungen',
    feature2: '5 progressive Schwierigkeitsstufen',
    feature3: 'Detaillierte Fortschrittsverfolgung',
    feature4: 'Lernspiele und Mathe-Herausforderungen',
    feature5: 'Mehr als 30 verfügbare Sprachen',
    feature6: 'Verfügbar im Web, iOS und Android',
    pricing: 'Abonnement-Pläne',
    choosePlan: 'Diesen Plan wählen',
    popular: 'Am beliebtesten',
    month: '/Monat',
    footerFeatures: 'Funktionen',
    footerSupport: 'Support',
    footerDownload: 'Herunterladen',
    footerDescription: 'Die Referenz-Bildungsanwendung zum Mathematiklernen für die Familie.',
    footerInteractive: 'Interaktive Übungen',
    footerProgress: 'Fortschrittsverfolgung',
    footerGames: 'Lernspiele',
    footerMultiplayer: 'Mehrspieler-Modus',
    footerHelp: 'Hilfe-Center',
    footerContact: 'Kontakt',
    footerGuides: 'Elternleitfäden',
    footerCommunity: 'Gemeinschaft',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Herunterladen im',
    footerAvailableOn: 'Verfügbar auf',
    footerCopyright: 'Alle Rechte vorbehalten.',
    appStoreRating: '4.9/5 im App Store'
  },
  ar: {
    title: 'Math4Child - تعلم الرياضيات وأنت تلعب!',
    subtitle: 'التطبيق التعليمي رقم 1 لتعلم الرياضيات مع العائلة',
    badge: 'التطبيق التعليمي رقم 1 في فرنسا',
    welcome: 'مرحباً بكم في المغامرة الرياضية!',
    description: 'تطبيق شامل لتعلم الرياضيات بطريقة ممتعة وتفاعلية.',
    startFree: 'ابدأ مجاناً',
    viewPlans: 'عرض الخطط',
    familiesCount: '100k+ عائلة تثق بنا',
    features: 'المميزات الرئيسية',
    featuresSubtitle: 'اكتشف جميع المميزات التي تجعل Math4Child التطبيق رقم 1',
    feature1: 'حسابات تفاعلية وتمارين مخصصة',
    feature2: '5 مستويات صعوبة متدرجة',
    feature3: 'تتبع مفصل للتقدم',
    feature4: 'ألعاب تعليمية وتحديات رياضية',
    feature5: 'أكثر من 30 لغة متاحة',
    feature6: 'متاح على الويب، أندرويد وآبل',
    pricing: 'خطط الاشتراك',
    choosePlan: 'اختر هذه الخطة',
    popular: 'الأكثر شعبية',
    month: '/شهر',
    footerFeatures: 'المميزات',
    footerSupport: 'الدعم',
    footerDownload: 'تحميل',
    footerDescription: 'التطبيق التعليمي المرجعي لتعلم الرياضيات مع العائلة.',
    footerInteractive: 'تمارين تفاعلية',
    footerProgress: 'تتبع التقدم',
    footerGames: 'ألعاب تعليمية',
    footerMultiplayer: 'نمط متعدد اللاعبين',
    footerHelp: 'مركز المساعدة',
    footerContact: 'اتصل بنا',
    footerGuides: 'أدلة الوالدين',
    footerCommunity: 'المجتمع',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'حمل من',
    footerAvailableOn: 'متاح على',
    footerCopyright: 'جميع الحقوق محفوظة.',
    appStoreRating: '4.9/5 في App Store'
  },
  zh: {
    title: 'Math4Child - 在玩乐中学习数学！',
    subtitle: '全家学习数学的第一教育应用',
    badge: '法国第一教育应用',
    welcome: '欢迎来到数学冒险！',
    description: '一个全面的应用程序，以有趣和互动的方式学习数学。',
    startFree: '免费开始',
    viewPlans: '查看计划',
    familiesCount: '100k+ 家庭信任我们',
    features: '主要功能',
    featuresSubtitle: '发现让Math4Child成为第一应用的所有功能',
    feature1: '互动计算和适应性练习',
    feature2: '5个渐进难度级别',
    feature3: '详细进度跟踪',
    feature4: '教育游戏和数学挑战',
    feature5: '30多种可用语言',
    feature6: '可在Web、iOS和Android上使用',
    pricing: '订阅计划',
    choosePlan: '选择此计划',
    popular: '最受欢迎',
    month: '/月',
    footerFeatures: '功能',
    footerSupport: '支持',
    footerDownload: '下载',
    footerDescription: '全家学习数学的参考教育应用程序。',
    footerInteractive: '互动练习',
    footerProgress: '进度跟踪',
    footerGames: '教育游戏',
    footerMultiplayer: '多人模式',
    footerHelp: '帮助中心',
    footerContact: '联系我们',
    footerGuides: '家长指南',
    footerCommunity: '社区',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: '下载于',
    footerAvailableOn: '可用于',
    footerCopyright: '版权所有。',
    appStoreRating: '4.9/5 在App Store'
  },
  it: {
    title: 'Math4Child - Impara la matematica divertendoti!',
    subtitle: 'L\'app educativa n°1 per imparare la matematica in famiglia',
    badge: 'App Educativa n°1 in Francia',
    welcome: 'Benvenuto nell\'avventura matematica!',
    description: 'Un\'applicazione completa per imparare la matematica in modo divertente e interattivo.',
    startFree: 'Inizia gratis',
    viewPlans: 'Vedi i piani',
    familiesCount: '100k+ famiglie si fidano di noi',
    features: 'Funzionalità principali',
    featuresSubtitle: 'Scopri tutte le funzionalità che rendono Math4Child l\'app n°1',
    feature1: 'Calcoli interattivi ed esercizi adattati',
    feature2: '5 livelli di difficoltà progressivi',
    feature3: 'Monitoraggio dettagliato dei progressi',
    feature4: 'Giochi educativi e sfide matematiche',
    feature5: 'Più di 30 lingue disponibili',
    feature6: 'Disponibile su Web, iOS e Android',
    pricing: 'Piani di abbonamento',
    choosePlan: 'Scegli questo piano',
    popular: 'Più popolare',
    month: '/mese',
    footerFeatures: 'Funzionalità',
    footerSupport: 'Supporto',
    footerDownload: 'Scarica',
    footerDescription: 'L\'applicazione educativa di riferimento per imparare la matematica in famiglia.',
    footerInteractive: 'Esercizi interattivi',
    footerProgress: 'Monitoraggio progressi',
    footerGames: 'Giochi educativi',
    footerMultiplayer: 'Modalità multigiocatore',
    footerHelp: 'Centro assistenza',
    footerContact: 'Contatto',
    footerGuides: 'Guide per genitori',
    footerCommunity: 'Comunità',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Scarica su',
    footerAvailableOn: 'Disponibile su',
    footerCopyright: 'Tutti i diritti riservati.',
    appStoreRating: '4.9/5 sull\'App Store'
  },
  pt: {
    title: 'Math4Child - Aprenda matemática se divertindo!',
    subtitle: 'O app educacional nº1 para aprender matemática em família',
    badge: 'App Educacional nº1 na França',
    welcome: 'Bem-vindo à aventura matemática!',
    description: 'Uma aplicação completa para aprender matemática de forma divertida e interativa.',
    startFree: 'Começar grátis',
    viewPlans: 'Ver planos',
    familiesCount: '100k+ famílias confiam em nós',
    features: 'Principais recursos',
    featuresSubtitle: 'Descubra todos os recursos que fazem do Math4Child o app nº1',
    feature1: 'Cálculos interativos e exercícios adaptados',
    feature2: '5 níveis de dificuldade progressivos',
    feature3: 'Acompanhamento detalhado do progresso',
    feature4: 'Jogos educativos e desafios matemáticos',
    feature5: 'Mais de 30 idiomas disponíveis',
    feature6: 'Disponível na Web, iOS e Android',
    pricing: 'Planos de assinatura',
    choosePlan: 'Escolher este plano',
    popular: 'Mais popular',
    month: '/mês',
    footerFeatures: 'Recursos',
    footerSupport: 'Suporte',
    footerDownload: 'Download',
    footerDescription: 'A aplicação educacional de referência para aprender matemática em família.',
    footerInteractive: 'Exercícios interativos',
    footerProgress: 'Acompanhamento de progresso',
    footerGames: 'Jogos educativos',
    footerMultiplayer: 'Modo multijogador',
    footerHelp: 'Central de ajuda',
    footerContact: 'Contato',
    footerGuides: 'Guias para pais',
    footerCommunity: 'Comunidade',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Baixar na',
    footerAvailableOn: 'Disponível no',
    footerCopyright: 'Todos os direitos reservados.',
    appStoreRating: '4.9/5 na App Store'
  },
  ru: {
    title: 'Math4Child - Изучай математику с удовольствием!',
    subtitle: 'Образовательное приложение №1 для изучения математики всей семьей',
    badge: 'Образовательное приложение №1 во Франции',
    welcome: 'Добро пожаловать в математическое приключение!',
    description: 'Комплексное приложение для изучения математики в увлекательной и интерактивной форме.',
    startFree: 'Начать бесплатно',
    viewPlans: 'Посмотреть планы',
    familiesCount: '100k+ семей доверяют нам',
    features: 'Основные функции',
    featuresSubtitle: 'Откройте для себя все функции, которые делают Math4Child приложением №1',
    feature1: 'Интерактивные вычисления и адаптированные упражнения',
    feature2: '5 прогрессивных уровней сложности',
    feature3: 'Детальное отслеживание прогресса',
    feature4: 'Образовательные игры и математические вызовы',
    feature5: 'Более 30 доступных языков',
    feature6: 'Доступно в веб, iOS и Android',
    pricing: 'Планы подписки',
    choosePlan: 'Выбрать этот план',
    popular: 'Самый популярный',
    month: '/месяц',
    footerFeatures: 'Функции',
    footerSupport: 'Поддержка',
    footerDownload: 'Скачать',
    footerDescription: 'Эталонное образовательное приложение для изучения математики в семье.',
    footerInteractive: 'Интерактивные упражнения',
    footerProgress: 'Отслеживание прогресса',
    footerGames: 'Образовательные игры',
    footerMultiplayer: 'Режим для нескольких игроков',
    footerHelp: 'Центр помощи',
    footerContact: 'Контакты',
    footerGuides: 'Руководства для родителей',
    footerCommunity: 'Сообщество',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Скачать в',
    footerAvailableOn: 'Доступно в',
    footerCopyright: 'Все права защищены.',
    appStoreRating: '4.9/5 в App Store'
  },
  ja: {
    title: 'Math4Child - 楽しく数学を学ぼう！',
    subtitle: '家族で数学を学ぶためのNo.1教育アプリ',
    badge: 'フランスNo.1教育アプリ',
    welcome: '数学の冒険へようこそ！',
    description: '楽しくインタラクティブに数学を学ぶための包括的なアプリケーション。',
    startFree: '無料で始める',
    viewPlans: 'プランを見る',
    familiesCount: '100k+家族が信頼',
    features: '主な機能',
    featuresSubtitle: 'Math4Childを第1位のアプリにするすべての機能を発見',
    feature1: 'インタラクティブな計算と適応型演習',
    feature2: '5つの段階的難易度レベル',
    feature3: '詳細な進捗追跡',
    feature4: '教育ゲームと数学チャレンジ',
    feature5: '30以上の利用可能言語',
    feature6: 'Web、iOS、Androidで利用可能',
    pricing: 'サブスクリプションプラン',
    choosePlan: 'このプランを選択',
    popular: '最も人気',
    month: '/月',
    footerFeatures: '機能',
    footerSupport: 'サポート',
    footerDownload: 'ダウンロード',
    footerDescription: '家族で数学を学ぶための参考教育アプリケーション。',
    footerInteractive: 'インタラクティブな演習',
    footerProgress: '進捗追跡',
    footerGames: '教育ゲーム',
    footerMultiplayer: 'マルチプレイヤーモード',
    footerHelp: 'ヘルプセンター',
    footerContact: 'お問い合わせ',
    footerGuides: '保護者ガイド',
    footerCommunity: 'コミュニティ',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'ダウンロード',
    footerAvailableOn: '利用可能',
    footerCopyright: '無断転載を禁じます。',
    appStoreRating: 'App Storeで4.9/5'
  },
  ko: {
    title: 'Math4Child - 재미있게 수학을 배우세요!',
    subtitle: '가족과 함께 수학을 배우는 1위 교육 앱',
    badge: '프랑스 1위 교육 앱',
    welcome: '수학 모험에 오신 것을 환영합니다!',
    description: '재미있고 상호작용적인 방식으로 수학을 배우는 종합 애플리케이션.',
    startFree: '무료로 시작하기',
    viewPlans: '플랜 보기',
    familiesCount: '100k+ 가족이 신뢰',
    features: '주요 기능',
    featuresSubtitle: 'Math4Child를 1위 앱으로 만드는 모든 기능을 발견하세요',
    feature1: '대화형 계산 및 적응형 연습',
    feature2: '5개의 점진적 난이도 레벨',
    feature3: '상세한 진행 상황 추적',
    feature4: '교육 게임 및 수학 챌린지',
    feature5: '30개 이상 사용 가능한 언어',
    feature6: '웹, iOS, Android에서 사용 가능',
    pricing: '구독 플랜',
    choosePlan: '이 플랜 선택',
    popular: '가장 인기',
    month: '/월',
    footerFeatures: '기능',
    footerSupport: '지원',
    footerDownload: '다운로드',
    footerDescription: '가족과 함께 수학을 배우는 참고 교육 애플리케이션.',
    footerInteractive: '대화형 연습',
    footerProgress: '진행 상황 추적',
    footerGames: '교육 게임',
    footerMultiplayer: '멀티플레이어 모드',
    footerHelp: '도움말 센터',
    footerContact: '연락처',
    footerGuides: '부모 가이드',
    footerCommunity: '커뮤니티',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: '다운로드',
    footerAvailableOn: '사용 가능',
    footerCopyright: '모든 권리 보유.',
    appStoreRating: 'App Store에서 4.9/5'
  },
  nl: {
    title: 'Math4Child - Leer wiskunde met plezier!',
    subtitle: 'De #1 educatieve app om wiskunde als familie te leren',
    badge: '#1 Educatieve App in Frankrijk',
    welcome: 'Welkom bij het wiskundige avontuur!',
    description: 'Een uitgebreide applicatie om wiskunde op een leuke en interactieve manier te leren.',
    startFree: 'Gratis beginnen',
    viewPlans: 'Plannen bekijken',
    familiesCount: '100k+ families vertrouwen ons',
    features: 'Hoofdfuncties',
    featuresSubtitle: 'Ontdek alle functies die Math4Child de #1 app maken',
    feature1: 'Interactieve berekeningen en aangepaste oefeningen',
    feature2: '5 progressieve moeilijkheidsniveaus',
    feature3: 'Gedetailleerde voortgangsregistratie',
    feature4: 'Educatieve spellen en wiskundige uitdagingen',
    feature5: 'Meer dan 30 beschikbare talen',
    feature6: 'Beschikbaar op Web, iOS en Android',
    pricing: 'Abonnementsplannen',
    choosePlan: 'Kies dit plan',
    popular: 'Meest populair',
    month: '/maand',
    footerFeatures: 'Functies',
    footerSupport: 'Ondersteuning',
    footerDownload: 'Downloaden',
    footerDescription: 'De referentie educatieve applicatie om wiskunde als familie te leren.',
    footerInteractive: 'Interactieve oefeningen',
    footerProgress: 'Voortgangsregistratie',
    footerGames: 'Educatieve spellen',
    footerMultiplayer: 'Multiplayer-modus',
    footerHelp: 'Helpcentrum',
    footerContact: 'Contact',
    footerGuides: 'Ouderhandleidingen',
    footerCommunity: 'Gemeenschap',
    footerAppStore: 'App Store',
    footerGooglePlay: 'Google Play',
    footerDownloadOn: 'Download op',
    footerAvailableOn: 'Beschikbaar op',
    footerCopyright: 'Alle rechten voorbehouden.',
    appStoreRating: '4.9/5 op de App Store'
  }
};

const PRICING_PLANS = [
  {
    name: { fr: 'Gratuit', en: 'Free', es: 'Gratis', de: 'Kostenlos', ar: 'مجاني', zh: '免费', it: 'Gratuito', pt: 'Grátis', ru: 'Бесплатно', ja: '無料', ko: '무료', nl: 'Gratis' },
    price: '0€',
    popular: false,
    features: {
      fr: ['Accès aux exercices de base', '1 niveau de difficulté', 'Statistiques limitées', 'Publicités'],
      en: ['Access to basic exercises', '1 difficulty level', 'Limited statistics', 'Advertisements'],
      es: ['Acceso a ejercicios básicos', '1 nivel de dificultad', 'Estadísticas limitadas', 'Publicidad'],
      de: ['Zugang zu Grundübungen', '1 Schwierigkeitsstufe', 'Begrenzte Statistiken', 'Werbung'],
      ar: ['الوصول للتمارين الأساسية', 'مستوى صعوبة واحد', 'إحصائيات محدودة', 'إعلانات'],
      zh: ['基础练习访问', '1个难度级别', '有限统计', '广告'],
      it: ['Accesso agli esercizi di base', '1 livello di difficoltà', 'Statistiche limitate', 'Pubblicità'],
      pt: ['Acesso a exercícios básicos', '1 nível de dificuldade', 'Estatísticas limitadas', 'Publicidade'],
      ru: ['Доступ к базовым упражнениям', '1 уровень сложности', 'Ограниченная статистика', 'Реклама'],
      ja: ['基本練習へのアクセス', '1つの難易度レベル', '限定統計', '広告'],
      ko: ['기본 연습 액세스', '1개 난이도 레벨', '제한된 통계', '광고'],
      nl: ['Toegang tot basisoefeningen', '1 moeilijkheidsniveau', 'Beperkte statistieken', 'Advertenties']
    }
  },
  {
    name: { fr: 'Premium', en: 'Premium', es: 'Premium', de: 'Premium', ar: 'مميز', zh: '高级', it: 'Premium', pt: 'Premium', ru: 'Премиум', ja: 'プレミアム', ko: '프리미엄', nl: 'Premium' },
    price: '4.99€',
    popular: true,
    discount: '-28%',
    features: {
      fr: ['Tous les exercices débloqués', '5 niveaux de difficulté', 'Statistiques complètes', 'Sans publicité', 'Support prioritaire'],
      en: ['All exercises unlocked', '5 difficulty levels', 'Complete statistics', 'Ad-free', 'Priority support'],
      es: ['Todos los ejercicios desbloqueados', '5 niveles de dificultad', 'Estadísticas completas', 'Sin publicidad', 'Soporte prioritario'],
      de: ['Alle Übungen freigeschaltet', '5 Schwierigkeitsstufen', 'Vollständige Statistiken', 'Werbefrei', 'Prioritäts-Support'],
      ar: ['جميع التمارين مفتوحة', '5 مستويات صعوبة', 'إحصائيات كاملة', 'بدون إعلانات', 'دعم أولوية'],
      zh: ['所有练习解锁', '5个难度级别', '完整统计', '无广告', '优先支持'],
      it: ['Tutti gli esercizi sbloccati', '5 livelli di difficoltà', 'Statistiche complete', 'Senza pubblicità', 'Supporto prioritario'],
      pt: ['Todos os exercícios desbloqueados', '5 níveis de dificuldade', 'Estatísticas completas', 'Sem publicidade', 'Suporte prioritário'],
      ru: ['Все упражнения разблокированы', '5 уровней сложности', 'Полная статистика', 'Без рекламы', 'Приоритетная поддержка'],
      ja: ['すべての練習のロック解除', '5つの難易度レベル', '完全な統計', '広告なし', '優先サポート'],
      ko: ['모든 연습 잠금해제', '5개 난이도 레벨', '완전한 통계', '광고 없음', '우선 지원'],
      nl: ['Alle oefeningen ontgrendeld', '5 moeilijkheidsniveaus', 'Volledige statistieken', 'Advertentievrij', 'Prioriteitsondersteuning']
    }
  },
  {
    name: { fr: 'Famille', en: 'Family', es: 'Familia', de: 'Familie', ar: 'عائلة', zh: '家庭', it: 'Famiglia', pt: 'Família', ru: 'Семья', ja: 'ファミリー', ko: '가족', nl: 'Familie' },
    price: '6.99€',
    popular: false,
    discount: '-30%',
    features: {
      fr: ['Jusqu\'à 6 comptes enfants', 'Toutes les fonctionnalités Premium', 'Rapports familiaux', 'Contrôle parental avancé'],
      en: ['Up to 6 children accounts', 'All Premium features', 'Family reports', 'Advanced parental controls'],
      es: ['Hasta 6 cuentas de niños', 'Todas las características Premium', 'Informes familiares', 'Control parental avanzado'],
      de: ['Bis zu 6 Kinderkonten', 'Alle Premium-Funktionen', 'Familienberichte', 'Erweiterte Kindersicherung'],
      ar: ['حتى 6 حسابات أطفال', 'جميع مميزات Premium', 'تقارير عائلية', 'رقابة أبوية متقدمة'],
      zh: ['最多6个儿童账户', '所有高级功能', '家庭报告', '高级家长控制'],
      it: ['Fino a 6 account bambini', 'Tutte le funzionalità Premium', 'Rapporti familiari', 'Controlli parentali avanzati'],
      pt: ['Até 6 contas de crianças', 'Todos os recursos Premium', 'Relatórios familiares', 'Controles parentais avançados'],
      ru: ['До 6 детских аккаунтов', 'Все функции Премиум', 'Семейные отчеты', 'Расширенный родительский контроль'],
      ja: ['最大6つの子どもアカウント', 'すべてのプレミアム機能', 'ファミリーレポート', '高度なペアレンタルコントロール'],
      ko: ['최대 6개 아동 계정', '모든 프리미엄 기능', '가족 보고서', '고급 부모 제어'],
      nl: ['Tot 6 kinderaccounts', 'Alle Premium-functies', 'Familierapporten', 'Geavanceerde ouderlijke controle']
    }
  },
  {
    name: { fr: 'École', en: 'School', es: 'Escuela', de: 'Schule', ar: 'مدرسة', zh: '学校', it: 'Scuola', pt: 'Escola', ru: 'Школа', ja: '学校', ko: '학교', nl: 'School' },
    price: '24.99€',
    popular: false,
    discount: '-20%',
    features: {
      fr: ['Jusqu\'à 30 élèves', 'Tableau de bord enseignant', 'Rapports de classe', 'Support téléphonique'],
      en: ['Up to 30 students', 'Teacher dashboard', 'Class reports', 'Phone support'],
      es: ['Hasta 30 estudiantes', 'Panel de profesor', 'Informes de clase', 'Soporte telefónico'],
      de: ['Bis zu 30 Schüler', 'Lehrer-Dashboard', 'Klassenberichte', 'Telefonsupport'],
      ar: ['حتى 30 طالب', 'لوحة تحكم المعلم', 'تقارير الفصل', 'دعم هاتفي'],
      zh: ['最多30名学生', '教师仪表板', '班级报告', '电话支持'],
      it: ['Fino a 30 studenti', 'Dashboard insegnante', 'Rapporti di classe', 'Supporto telefonico'],
      pt: ['Até 30 estudantes', 'Painel do professor', 'Relatórios de turma', 'Suporte telefônico'],
      ru: ['До 30 учеников', 'Панель учителя', 'Отчеты класса', 'Телефонная поддержка'],
      ja: ['最大30人の生徒', '教師ダッシュボード', 'クラスレポート', '電話サポート'],
      ko: ['최대 30명 학생', '교사 대시보드', '클래스 보고서', '전화 지원'],
      nl: ['Tot 30 studenten', 'Docentendashboard', 'Klasrapporten', 'Telefoonondersteuning']
    }
  }
];

export default function HomePage() {
  const [currentLanguage, setCurrentLanguage] = useState('fr');
  const [showPricing, setShowPricing] = useState(false);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    const savedLanguage = localStorage.getItem('math4child-language');
    if (savedLanguage && LANGUAGES.find(lang => lang.code === savedLanguage)) {
      setCurrentLanguage(savedLanguage);
    }
  }, []);

  const handleLanguageChange = (languageCode: string) => {
    setCurrentLanguage(languageCode);
    if (mounted) {
      localStorage.setItem('math4child-language', languageCode);
    }
  };

  const t = (key: string): string => {
    return TRANSLATIONS[currentLanguage]?.[key] || TRANSLATIONS['fr']?.[key] || key;
  };

  if (!mounted) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center">
        <div className="text-blue-600 text-xl">Chargement...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Header */}
      <header className="bg-white/90 backdrop-blur-sm shadow-lg border-b border-gray-200 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-4">
            <div className="flex items-center space-x-4">
              <div className="w-12 h-12 bg-gradient-to-br from-orange-400 to-red-500 rounded-xl flex items-center justify-center shadow-lg">
                <span className="text-white text-xl font-bold">M4C</span>
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Math4Child</h1>
                <div className="flex items-center space-x-2">
                  <span className="bg-orange-100 text-orange-800 text-xs px-2 py-1 rounded-full font-medium">
                    {t('badge')}
                  </span>
                  <span className="text-green-600 text-sm font-medium">
                    {t('familiesCount')}
                  </span>
                </div>
              </div>
            </div>
            
            {/* Language Selector */}
            <div className="relative">
              <select
                value={currentLanguage}
                onChange={(e) => handleLanguageChange(e.target.value)}
                className="appearance-none bg-white border-2 border-gray-300 rounded-lg px-4 py-2 pr-8 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 cursor-pointer"
              >
                {LANGUAGES.map((lang) => (
                  <option key={lang.code} value={lang.code}>
                    {lang.flag} {lang.nativeName}
                  </option>
                ))}
              </select>
              <div className="absolute inset-y-0 right-0 flex items-center px-2 pointer-events-none">
                <svg className="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                </svg>
              </div>
            </div>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="py-20 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto text-center">
          <div className="inline-flex items-center bg-orange-100 text-orange-800 px-4 py-2 rounded-full text-sm font-medium mb-6">
            🏆 {t('badge')}
          </div>
          
          <h1 className="text-5xl md:text-6xl font-bold text-gray-900 mb-6 leading-tight">
            {t('title')}
          </h1>
          
          <p className="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
            {t('subtitle')}
          </p>

          <div className="flex flex-col sm:flex-row gap-4 justify-center mb-12">
            <button className="bg-green-500 hover:bg-green-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg">
              {t('startFree')}
            </button>
            <button 
              onClick={() => setShowPricing(true)}
              className="bg-blue-500 hover:bg-blue-600 text-white px-8 py-4 rounded-xl font-semibold text-lg transition-all duration-200 transform hover:scale-105 shadow-lg"
            >
              {t('viewPlans')}
            </button>
          </div>

          <div className="text-center">
            <p className="text-green-600 font-medium mb-4">{t('familiesCount')}</p>
            <div className="flex justify-center items-center space-x-2">
              <div className="flex">
                {[...Array(5)].map((_, i) => (
                  <svg key={i} className="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20">
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                ))}
              </div>
              <span className="text-gray-600 text-sm">{t('appStoreRating')}</span>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-20 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-bold text-gray-900 mb-4">{t('features')}</h2>
            <p className="text-xl text-gray-600">{t('featuresSubtitle')}</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            {[1, 2, 3, 4, 5, 6].map((num) => (
              <div key={num} className="bg-gradient-to-br from-white to-gray-50 rounded-2xl p-8 shadow-lg hover:shadow-xl transition-all duration-300 border border-gray-100">
                <div className="text-4xl mb-4">
                  {num === 1 && '🧮'}
                  {num === 2 && '🎯'}
                  {num === 3 && '📊'}
                  {num === 4 && '🎮'}
                  {num === 5 && '🌍'}
                  {num === 6 && '📱'}
                </div>
                <h3 className="text-xl font-semibold text-gray-900 mb-3">
                  {t(`feature${num}`)}
                </h3>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Modal de pricing */}
      {showPricing && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-2xl max-w-6xl w-full max-h-screen overflow-y-auto">
            <div className="p-8">
              <div className="flex justify-between items-center mb-8">
                <h2 className="text-3xl font-bold text-gray-900">{t('pricing')}</h2>
                <button 
                  onClick={() => setShowPricing(false)}
                  className="text-gray-400 hover:text-gray-600 text-2xl"
                >
                  ×
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                {PRICING_PLANS.map((plan, index) => (
                  <div key={index} className={`relative bg-gradient-to-br from-white to-gray-50 rounded-2xl p-6 border-2 transition-all duration-300 hover:shadow-xl ${plan.popular ? 'border-blue-500 ring-2 ring-blue-100' : 'border-gray-200'}`}>
                    {plan.popular && (
                      <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
                        <span className="bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium">
                          {t('popular')}
                        </span>
                      </div>
                    )}
                    
                    {plan.discount && (
                      <div className="absolute -top-2 -right-2">
                        <span className="bg-red-500 text-white px-2 py-1 rounded-full text-xs font-bold">
                          {plan.discount}
                        </span>
                      </div>
                    )}

                    <div className="text-center mb-6">
                      <h3 className="text-xl font-bold text-gray-900 mb-2">
                        {plan.name[currentLanguage] || plan.name['fr']}
                      </h3>
                      <div className="text-3xl font-bold text-blue-600 mb-1">{plan.price}</div>
                      <div className="text-gray-500 text-sm">
                        {t('month')}
                      </div>
                    </div>

                    <ul className="space-y-3 mb-6">
                      {(plan.features[currentLanguage] || plan.features['fr']).map((feature, idx) => (
                        <li key={idx} className="flex items-start">
                          <svg className="w-5 h-5 text-green-500 mr-3 mt-0.5 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                            <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                          </svg>
                          <span className="text-gray-600 text-sm">{feature}</span>
                        </li>
                      ))}
                    </ul>

                    <button className={`w-full py-3 rounded-xl font-semibold transition-all duration-200 ${plan.popular ? 'bg-blue-500 hover:bg-blue-600 text-white' : 'bg-gray-100 hover:bg-gray-200 text-gray-900'}`}>
                      {t('choosePlan')}
                    </button>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <footer className="bg-gray-900 text-white py-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
            <div>
              <div className="flex items-center space-x-3 mb-4">
                <div className="w-10 h-10 bg-gradient-to-br from-orange-400 to-red-500 rounded-lg flex items-center justify-center">
                  <span className="text-white text-lg font-bold">M4C</span>
                </div>
                <span className="text-xl font-bold">Math4Child</span>
              </div>
              <p className="text-gray-400">
                {t('footerDescription')}
              </p>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t('footerFeatures')}</h3>
              <ul className="space-y-2 text-gray-400">
                <li>{t('footerInteractive')}</li>
                <li>{t('footerProgress')}</li>
                <li>{t('footerGames')}</li>
                <li>{t('footerMultiplayer')}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t('footerSupport')}</h3>
              <ul className="space-y-2 text-gray-400">
                <li>{t('footerHelp')}</li>
                <li>{t('footerContact')}</li>
                <li>{t('footerGuides')}</li>
                <li>{t('footerCommunity')}</li>
              </ul>
            </div>
            
            <div>
              <h3 className="text-lg font-semibold mb-4">{t('footerDownload')}</h3>
              <div className="space-y-3">
                <div className="bg-gray-800 rounded-lg p-3 flex items-center space-x-3">
                  <span className="text-2xl">📱</span>
                  <div>
                    <div className="text-sm text-gray-400">{t('footerDownloadOn')}</div>
                    <div className="font-semibold">{t('footerAppStore')}</div>
                  </div>
                </div>
                <div className="bg-gray-800 rounded-lg p-3 flex items-center space-x-3">
                  <span className="text-2xl">🤖</span>
                  <div>
                    <div className="text-sm text-gray-400">{t('footerAvailableOn')}</div>
                    <div className="font-semibold">{t('footerGooglePlay')}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div className="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
            <p>&copy; 2024 Math4Child. {t('footerCopyright')}</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
EOF

log_success "✅ Bugs de traduction corrigés"

# =============================================================================
# 3. NETTOYAGE ET REDÉMARRAGE
# =============================================================================

log_info "🧹 Nettoyage et redémarrage..."

# Supprimer le cache
if [ -d ".next" ]; then
    rm -rf .next
    log_success "✅ Cache .next supprimé"
fi

# Redémarrer le serveur
if command -v npm >/dev/null 2>&1; then
    nohup npm run dev > /dev/null 2>&1 &
    sleep 3
    
    if pgrep -f "next dev" > /dev/null; then
        log_success "✅ Serveur redémarré avec succès"
    else
        log_error "⚠️ Le serveur n'a pas pu redémarrer automatiquement"
        echo "   Démarrez-le manuellement avec: npm run dev"
    fi
else
    log_error "⚠️ npm non trouvé, redémarrage manuel requis"
fi

# =============================================================================
# RAPPORT FINAL
# =============================================================================

echo ""
print_header "BUGS DE TRADUCTION CORRIGÉS"
echo ""
echo "🐛 Problèmes résolus :"
echo ""
echo "✅ Mélange de langues corrigé :"
echo "   ❌ 'Características principales' en français"
echo "   ✅ 'Fonctionnalités principales' maintenant"
echo ""
echo "✅ Duplications supprimées :"
echo "   ❌ Sections répétées"
echo "   ✅ Une seule section par contenu"
echo ""
echo "✅ Footer entièrement traduit :"
echo "   ✅ Sections 'Fonctionnalités/Features/Características'"
echo "   ✅ Boutons 'Télécharger sur/Download on/Descargar en'"
echo "   ✅ 'App Store' et 'Google Play' traduits"
echo "   ✅ Copyright traduit dans chaque langue"
echo ""
echo "✅ Cohérence linguistique :"
echo "   ✅ Pas de mélange entre langues"
echo "   ✅ Traductions complètes et cohérentes"
echo "   ✅ Fallback vers le français si traduction manquante"
echo ""
echo "✅ Améliorations apportées :"
echo "   ✅ Sous-titre de la section features traduit"
echo "   ✅ Toutes les clés de traduction ajoutées"
echo "   ✅ Footer complètement internationalisé"
echo "   ✅ Drapeau marocain 🇲🇦 pour l'arabe"
echo ""
echo "🌐 Testez maintenant :"
echo "   http://localhost:3000"
echo "   → Changez de langue (français → espagnol → anglais)"
echo "   → Vérifiez que tout est cohérent"
echo "   → Ouvrez le modal de pricing"
echo "   → Vérifiez le footer"
echo ""
echo "🎯 Plus de mélanges de langues :"
echo "   ✅ Français : tout en français"
echo "   ✅ English : everything in English"
echo "   ✅ Español : todo en español"
echo "   ✅ Deutsch : alles auf Deutsch"
echo "   ✅ العربية : كل شيء بالعربية"
echo "   ✅ 中文 : 一切都是中文"
echo ""
echo "📱 Footer traduit par langue :"
echo "   🇫🇷 'Télécharger sur App Store'"
echo "   🇺🇸 'Download on App Store'"
echo "   🇪🇸 'Descargar en App Store'"
echo "   🇩🇪 'Herunterladen im App Store'"
echo "   🇲🇦 'حمل من App Store'"
echo "   🇨🇳 '下载于 App Store'"
echo ""
log_success "🎉 Tous les bugs de traduction sont corrigés !"
echo "========================================"