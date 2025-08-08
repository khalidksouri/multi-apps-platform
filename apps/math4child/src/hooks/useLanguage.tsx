"use client"

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { LocalDatabase } from '@/lib/database/localStorage';

type SupportedLanguage = 'fr' | 'en' | 'es' | 'de' | 'it' | 'pt' | 'ru' | 'ar' | 'zh' | 'ja' | 'ko' | 'hi';

const translations: Record<SupportedLanguage, Record<string, string>> = {
  fr: {
    appTitle: "Math4Child",
    heroTitle: "Apprends les maths en t'amusant !",
    chooseLevel: "Choisis ton niveau",
    chooseOperation: "Choisis ton opération",
    startFree: "Commencer gratuitement",
    viewPlans: "Voir les plans",
    searchLanguage: "Rechercher une langue...",
    selectLanguage: "Sélectionner une langue",
    exercise: "Exercice",
    validate: "Valider",
    correct: "Correct !",
    incorrect: "Incorrect",
    nextExercise: "Question suivante",
    back: "Retour",
    locked: "Verrouillé",
    completed: "Terminé",
    goodAnswers: "bonnes réponses"
  },
  en: {
    appTitle: "Math4Child",
    heroTitle: "Learn math while having fun!",
    chooseLevel: "Choose your level",
    chooseOperation: "Choose your operation",
    startFree: "Start for free",
    viewPlans: "View plans",
    searchLanguage: "Search language...",
    selectLanguage: "Select language",
    exercise: "Exercise",
    validate: "Validate",
    correct: "Correct!",
    incorrect: "Incorrect",
    nextExercise: "Next question",
    back: "Back",
    locked: "Locked",
    completed: "Completed",
    goodAnswers: "correct answers"
  },
  es: {
    appTitle: "Math4Child",
    heroTitle: "¡Aprende matemáticas divirtiéndote!",
    chooseLevel: "Elige tu nivel",
    chooseOperation: "Elige tu operación",
    startFree: "Comenzar gratis",
    viewPlans: "Ver planes",
    searchLanguage: "Buscar idioma...",
    selectLanguage: "Seleccionar idioma",
    exercise: "Ejercicio",
    validate: "Validar",
    correct: "¡Correcto!",
    incorrect: "Incorrecto",
    nextExercise: "Siguiente pregunta",
    back: "Atrás",
    locked: "Bloqueado",
    completed: "Completado",
    goodAnswers: "respuestas correctas"
  },
  de: {
    appTitle: "Math4Child",
    heroTitle: "Lerne Mathe mit Spaß!",
    chooseLevel: "Wähle dein Level",
    chooseOperation: "Wähle deine Operation",
    startFree: "Kostenlos starten",
    viewPlans: "Pläne anzeigen",
    searchLanguage: "Sprache suchen...",
    selectLanguage: "Sprache wählen",
    exercise: "Übung",
    validate: "Bestätigen",
    correct: "Richtig!",
    incorrect: "Falsch",
    nextExercise: "Nächste Frage",
    back: "Zurück",
    locked: "Gesperrt",
    completed: "Abgeschlossen",
    goodAnswers: "richtige Antworten"
  },
  it: {
    appTitle: "Math4Child",
    heroTitle: "Impara la matematica divertendoti!",
    chooseLevel: "Scegli il tuo livello",
    chooseOperation: "Scegli la tua operazione",
    startFree: "Inizia gratis",
    viewPlans: "Vedi i piani",
    searchLanguage: "Cerca lingua...",
    selectLanguage: "Seleziona lingua",
    exercise: "Esercizio",
    validate: "Convalida",
    correct: "Corretto!",
    incorrect: "Scorretto",
    nextExercise: "Prossima domanda",
    back: "Indietro",
    locked: "Bloccato",
    completed: "Completato",
    goodAnswers: "risposte corrette"
  },
  pt: {
    appTitle: "Math4Child",
    heroTitle: "Aprende matemática se divertindo!",
    chooseLevel: "Escolha seu nível",
    chooseOperation: "Escolha sua operação",
    startFree: "Começar grátis",
    viewPlans: "Ver planos",
    searchLanguage: "Pesquisar idioma...",
    selectLanguage: "Selecionar idioma",
    exercise: "Exercício",
    validate: "Validar",
    correct: "Correto!",
    incorrect: "Incorreto",
    nextExercise: "Próxima pergunta",
    back: "Voltar",
    locked: "Bloqueado",
    completed: "Completado",
    goodAnswers: "respostas corretas"
  },
  ru: {
    appTitle: "Math4Child",
    heroTitle: "Изучай математику с удовольствием!",
    chooseLevel: "Выберите уровень",
    chooseOperation: "Выберите операцию",
    startFree: "Начать бесплатно",
    viewPlans: "Посмотреть планы",
    searchLanguage: "Поиск языка...",
    selectLanguage: "Выбрать язык",
    exercise: "Упражнение",
    validate: "Подтвердить",
    correct: "Правильно!",
    incorrect: "Неправильно",
    nextExercise: "Следующий вопрос",
    back: "Назад",
    locked: "Заблокировано",
    completed: "Завершено",
    goodAnswers: "правильных ответов"
  },
  ar: {
    appTitle: "Math4Child",
    heroTitle: "تعلم الرياضيات بمتعة!",
    chooseLevel: "اختر مستواك",
    chooseOperation: "اختر عمليتك",
    startFree: "ابدأ مجاناً",
    viewPlans: "عرض الخطط",
    searchLanguage: "البحث عن لغة...",
    selectLanguage: "اختيار اللغة",
    exercise: "تمرين",
    validate: "تأكيد",
    correct: "صحيح!",
    incorrect: "خطأ",
    nextExercise: "السؤال التالي",
    back: "رجوع",
    locked: "مقفل",
    completed: "مكتمل",
    goodAnswers: "إجابات صحيحة"
  },
  zh: {
    appTitle: "Math4Child",
    heroTitle: "快乐学数学！",
    chooseLevel: "选择你的级别",
    chooseOperation: "选择你的运算",
    startFree: "免费开始",
    viewPlans: "查看计划",
    searchLanguage: "搜索语言...",
    selectLanguage: "选择语言",
    exercise: "练习",
    validate: "验证",
    correct: "正确！",
    incorrect: "错误",
    nextExercise: "下一题",
    back: "返回",
    locked: "锁定",
    completed: "完成",
    goodAnswers: "正确答案"
  },
  ja: {
    appTitle: "Math4Child",
    heroTitle: "楽しく数学を学ぼう！",
    chooseLevel: "レベルを選択",
    chooseOperation: "演算を選択",
    startFree: "無料で始める",
    viewPlans: "プランを見る",
    searchLanguage: "言語を検索...",
    selectLanguage: "言語を選択",
    exercise: "練習",
    validate: "確認",
    correct: "正解！",
    incorrect: "不正解",
    nextExercise: "次の問題",
    back: "戻る",
    locked: "ロック済み",
    completed: "完了",
    goodAnswers: "正解数"
  },
  ko: {
    appTitle: "Math4Child",
    heroTitle: "재미있게 수학을 배우자!",
    chooseLevel: "레벨 선택",
    chooseOperation: "연산 선택",
    startFree: "무료로 시작",
    viewPlans: "플랜 보기",
    searchLanguage: "언어 검색...",
    selectLanguage: "언어 선택",
    exercise: "연습",
    validate: "확인",
    correct: "정답!",
    incorrect: "오답",
    nextExercise: "다음 문제",
    back: "뒤로",
    locked: "잠금",
    completed: "완료",
    goodAnswers: "정답 수"
  },
  hi: {
    appTitle: "Math4Child",
    heroTitle: "मज़े से गणित सीखें!",
    chooseLevel: "अपना स्तर चुनें",
    chooseOperation: "अपना ऑपरेशन चुनें",
    startFree: "मुफ्त में शुरू करें",
    viewPlans: "योजनाएं देखें",
    searchLanguage: "भाषा खोजें...",
    selectLanguage: "भाषा चुनें",
    exercise: "अभ्यास",
    validate: "सत्यापित करें",
    correct: "सही!",
    incorrect: "गलत",
    nextExercise: "अगला प्रश्न",
    back: "वापस",
    locked: "लॉक",
    completed: "पूर्ण",
    goodAnswers: "सही उत्तर"
  }
};

interface LanguageContextType {
  currentLanguage: SupportedLanguage;
  setLanguage: (lang: SupportedLanguage) => void;
  t: (key: string) => string;
  isRTL: boolean;
  loadingStates: {
    changing: boolean;
  };
}

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export function LanguageProvider({ children }: { children: ReactNode }) {
  const [currentLanguage, setCurrentLanguage] = useState<SupportedLanguage>('fr');
  const [loadingStates, setLoadingStates] = useState({
    changing: false
  });

  useEffect(() => {
    let user = LocalDatabase.getUser();
    
    if (!user) {
      user = LocalDatabase.initDemoUser();
    }
    
    if (user.profile.language) {
      setCurrentLanguage(user.profile.language as SupportedLanguage);
    }
  }, []);

  const setLanguage = (lang: SupportedLanguage) => {
    setLoadingStates({ changing: true });
    
    setTimeout(() => {
      setCurrentLanguage(lang);
      
      const user = LocalDatabase.getUser();
      if (user) {
        user.profile.language = lang;
        LocalDatabase.saveUser(user);
      }
      
      setLoadingStates({ changing: false });
    }, 300);
  };

  const t = (key: string): string => {
    return translations[currentLanguage]?.[key] || translations.fr[key] || key;
  };

  const isRTL = currentLanguage === 'ar';

  return (
    <LanguageContext.Provider value={{
      currentLanguage,
      setLanguage,
      t,
      isRTL,
      loadingStates
    }}>
      {children}
    </LanguageContext.Provider>
  );
}

export function useLanguage() {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
}
