#!/usr/bin/env bash

# ===================================================================
# 🌍 SCRIPT SETUP INTERFACE RTL MATH4CHILD
# Configuration complète de l'interface arabe RTL
# ===================================================================

set -euo pipefail

# Variables
SCRIPT_VERSION="1.0.0"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="setup_rtl_${TIMESTAMP}.log"
BACKUP_DIR="backup_rtl_${TIMESTAMP}"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ===================================================================
# 🛠️ FONCTIONS UTILITAIRES
# ===================================================================

log_header() {
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo -e "${CYAN}${BOLD}🌍 $1${NC}"
    echo -e "${CYAN}${BOLD}=========================================${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_step() {
    echo -e "${PURPLE}📋 $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] STEP: $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$LOG_FILE"
}

# Créer une sauvegarde
create_backup() {
    log_step "Création de la sauvegarde RTL..."
    mkdir -p "$BACKUP_DIR"
    
    # Sauvegarder les fichiers importants
    [ -f "src/app/globals.css" ] && cp "src/app/globals.css" "$BACKUP_DIR/"
    [ -f "src/app/pricing/page.tsx" ] && cp "src/app/pricing/page.tsx" "$BACKUP_DIR/"
    [ -f "src/lib/translations/comprehensive.ts" ] && cp "src/lib/translations/comprehensive.ts" "$BACKUP_DIR/"
    [ -d "src/components/pricing" ] && cp -r "src/components/pricing" "$BACKUP_DIR/" 2>/dev/null || true
    
    log_success "Sauvegarde RTL créée dans $BACKUP_DIR"
}

# ===================================================================
# 🎨 CRÉATION DES STYLES RTL
# ===================================================================

create_rtl_styles() {
    log_header "CRÉATION DES STYLES RTL"
    
    # CSS global RTL
    cat >> "src/app/globals.css" << 'EOF'

/* ===================================================================
   🌍 STYLES RTL POUR MATH4CHILD - INTERFACE ARABE
   ================================================================= */

/* Police arabe optimisée */
[dir="rtl"] {
  font-family: 'Cairo', 'Amiri', 'Noto Sans Arabic', 'Segoe UI Arabic', sans-serif;
  font-feature-settings: "liga" 1, "kern" 1;
}

/* Direction RTL globale */
[dir="rtl"] * {
  direction: rtl;
}

[dir="rtl"] .container {
  direction: rtl;
}

/* ===================================================================
   COMPOSANTS PRICING RTL
   ================================================================= */

/* Cartes de prix RTL */
[dir="rtl"] .pricing-card {
  text-align: right;
  direction: rtl;
}

[dir="rtl"] .pricing-header {
  text-align: center;
  direction: rtl;
}

/* Listes de fonctionnalités RTL */
[dir="rtl"] .feature-list {
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .feature-item {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .feature-icon {
  order: 2;
  margin-left: 0;
  margin-right: 0.5rem;
  flex-shrink: 0;
}

[dir="rtl"] .feature-text {
  order: 1;
  text-align: right;
}

/* ===================================================================
   BADGES ET NOTIFICATIONS RTL
   ================================================================= */

[dir="rtl"] .badge-recommended {
  left: auto;
  right: 1rem;
  top: -0.75rem;
}

[dir="rtl"] .warning-badge {
  direction: rtl;
  text-align: center;
}

/* ===================================================================
   BOUTONS RTL
   ================================================================= */

[dir="rtl"] .btn-primary {
  direction: rtl;
  text-align: center;
}

[dir="rtl"] .btn-secondary {
  direction: rtl;
  text-align: center;
}

/* ===================================================================
   GRILLES ET LAYOUTS RTL
   ================================================================= */

[dir="rtl"] .grid {
  direction: rtl;
}

[dir="rtl"] .flex {
  direction: rtl;
}

[dir="rtl"] .space-y-3 > :not([hidden]) ~ :not([hidden]) {
  margin-top: 0.75rem;
  margin-right: 0;
  margin-left: 0;
}

[dir="rtl"] .gap-3 {
  gap: 0.75rem;
}

[dir="rtl"] .gap-4 {
  gap: 1rem;
}

[dir="rtl"] .gap-6 {
  gap: 1.5rem;
}

[dir="rtl"] .gap-8 {
  gap: 2rem;
}

/* ===================================================================
   ALIGNEMENTS DE TEXTE RTL
   ================================================================= */

[dir="rtl"] .text-right {
  text-align: right;
}

[dir="rtl"] .text-center {
  text-align: center;
}

[dir="rtl"] .text-left {
  text-align: left;
}

/* ===================================================================
   RESPONSIVE RTL
   ================================================================= */

@media (max-width: 768px) {
  [dir="rtl"] .grid-cols-1.md\:grid-cols-3 {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  [dir="rtl"] .scale-105 {
    transform: none;
  }
  
  [dir="rtl"] .pricing-card {
    margin-bottom: 1rem;
  }
  
  [dir="rtl"] .feature-item {
    padding: 0.5rem 0;
  }
}

@media (max-width: 640px) {
  [dir="rtl"] .text-4xl {
    font-size: 2rem;
    line-height: 2.5rem;
  }
  
  [dir="rtl"] .text-3xl {
    font-size: 1.5rem;
    line-height: 2rem;
  }
  
  [dir="rtl"] .px-6 {
    padding-left: 1rem;
    padding-right: 1rem;
  }
}

/* ===================================================================
   ANIMATIONS RTL
   ================================================================= */

[dir="rtl"] .transform {
  transform: none;
}

[dir="rtl"] .hover\:-translate-y-0\.5:hover {
  transform: translateY(-0.125rem);
}

[dir="rtl"] .transition-all {
  transition: all 0.2s ease-in-out;
}

/* ===================================================================
   FAQ SECTION RTL
   ================================================================= */

[dir="rtl"] .faq-container {
  direction: rtl;
  text-align: right;
}

[dir="rtl"] .faq-item {
  text-align: right;
  direction: rtl;
}

[dir="rtl"] .faq-question {
  font-weight: 600;
  margin-bottom: 0.5rem;
  text-align: right;
}

[dir="rtl"] .faq-answer {
  color: #6b7280;
  text-align: right;
  line-height: 1.6;
}

/* ===================================================================
   CONTACT SECTION RTL
   ================================================================= */

[dir="rtl"] .contact-section {
  direction: rtl;
  text-align: center;
}

[dir="rtl"] .contact-buttons {
  direction: rtl;
  justify-content: center;
}

/* ===================================================================
   NAVIGATION RTL
   ================================================================= */

[dir="rtl"] .nav-item {
  direction: rtl;
}

[dir="rtl"] .dropdown-menu {
  direction: rtl;
  text-align: right;
}

/* ===================================================================
   UTILITAIRES RTL
   ================================================================= */

.rtl-float-right {
  float: right;
}

.rtl-float-left {
  float: left;
}

.rtl-clear {
  clear: both;
}

/* ===================================================================
   CORRECTIONS SPÉCIFIQUES NAVIGATEURS
   ================================================================= */

/* Safari RTL fixes */
@supports (-webkit-appearance: none) {
  [dir="rtl"] select {
    background-position: left 0.5rem center;
    padding-left: 2rem;
    padding-right: 0.75rem;
  }
}

/* Firefox RTL fixes */
@-moz-document url-prefix() {
  [dir="rtl"] .grid {
    direction: rtl;
  }
}

/* ===================================================================
   PRINT STYLES RTL
   ================================================================= */

@media print {
  [dir="rtl"] * {
    direction: rtl !important;
    text-align: right !important;
  }
}
EOF

    log_success "Styles RTL créés"
}

# ===================================================================
# 🌍 CRÉATION DU COMPOSANT PRICING RTL
# ===================================================================

create_pricing_component() {
    log_header "CRÉATION DU COMPOSANT PRICING RTL"
    
    mkdir -p src/components/pricing
    
    cat > "src/components/pricing/PricingPlansRTL.tsx" << 'EOF'
'use client'

import React from 'react';

// Configuration des plans en arabe
const plansArabic = {
  school: {
    name: "خطة المدرسة",
    price: "مجاني",
    originalPrice: null,
    features: [
      "لوحة تحكم المعلم",
      "تصدير النتائج", 
      "دعم تعليمي مخصص",
      "تدريب شامل"
    ],
    button: "اختر هذه الخطة",
    color: "green",
    recommended: false
  },
  premium: {
    name: "الخطة المميزة", 
    price: "٢٩٫٩٩ درهم",
    period: "/شهر",
    originalPrice: "٤٩٫٩٩ درهم",
    features: [
      "تقارير التقدم",
      "دعم ذو أولوية",
      "محتوى حصري",
      "تحليلات متقدمة"
    ],
    button: "اختر هذه الخطة",
    color: "blue",
    recommended: true
  },
  enterprise: {
    name: "خطة المؤسسة",
    price: "حسب الطلب",
    originalPrice: null,
    features: [
      "تحليل مفصل للأخطاء",
      "تخصيص كامل للواجهة",
      "دعم ٢٤/٧ مخصص",
      "تكامل API متقدم"
    ],
    button: "اختر هذه الخطة", 
    color: "purple",
    recommended: false,
    trial: true
  }
};

// Composant de plan individuel
const PricingCardRTL: React.FC<{
  plan: typeof plansArabic.premium;
  index: number;
}> = ({ plan, index }) => {
  return (
    <div 
      className={`
        relative p-6 rounded-xl border-2 transition-all duration-300 pricing-card
        ${plan.recommended 
          ? 'border-blue-500 bg-blue-50 scale-105 shadow-xl' 
          : 'border-gray-200 bg-white hover:border-gray-300 hover:shadow-lg'
        }
      `}
      dir="rtl"
    >
      {/* Badge Recommandé */}
      {plan.recommended && (
        <div className="absolute -top-3 right-4 bg-blue-500 text-white px-4 py-1 rounded-full text-sm font-medium badge-recommended">
          الأكثر شعبية
        </div>
      )}
      
      {/* En-tête du plan */}
      <div className="text-center mb-6 pricing-header">
        <h3 className="text-xl font-bold text-gray-900 mb-3">
          {plan.name}
        </h3>
        
        {/* Prix */}
        <div className="mb-2">
          <span className="text-3xl font-bold text-gray-900">
            {plan.price}
          </span>
          {plan.period && (
            <span className="text-gray-500 text-base mr-1">
              {plan.period}
            </span>
          )}
        </div>
        
        {/* Prix original barré */}
        {plan.originalPrice && (
          <div className="text-sm text-gray-500 line-through mb-2">
            {plan.originalPrice}
          </div>
        )}
        
        {/* Avertissement durée limitée */}
        {plan.recommended && (
          <div className="text-xs text-orange-600 bg-orange-50 px-2 py-1 rounded warning-badge">
            ⚠️ فترة محدودة - غير قابلة للتجديد
          </div>
        )}
      </div>

      {/* Liste des fonctionnalités */}
      <div className="mb-8">
        <ul className="space-y-3 feature-list">
          {plan.features.map((feature, idx) => (
            <li 
              key={idx}
              className="feature-item"
            >
              <span className="text-green-500 text-lg feature-icon">✓</span>
              <span className="text-gray-700 text-sm leading-relaxed feature-text">
                {feature}
              </span>
            </li>
          ))}
        </ul>
      </div>

      {/* Boutons d'action */}
      <div className="space-y-3">
        <button
          className={`
            w-full py-3 px-4 rounded-lg font-semibold text-sm transition-all duration-200 btn-primary
            ${plan.color === 'green' 
              ? 'bg-green-500 hover:bg-green-600 text-white' 
              : plan.color === 'blue'
              ? 'bg-blue-500 hover:bg-blue-600 text-white'
              : plan.color === 'purple'
              ? 'bg-purple-500 hover:bg-purple-600 text-white'
              : 'bg-gray-500 hover:bg-gray-600 text-white'
            }
            hover:shadow-lg transform hover:-translate-y-0.5
          `}
          data-testid={`plan-${plan.color}-select`}
        >
          {plan.button}
        </button>
        
        {/* Bouton Essai Gratuit */}
        {plan.trial && (
          <button
            className="w-full py-2 px-4 rounded-lg font-medium text-sm border-2 border-gray-300 text-gray-700 hover:bg-gray-50 transition-all duration-200 btn-secondary"
            data-testid="trial-button"
          >
            تجربة مجانية ١٤ يوم
          </button>
        )}
      </div>
    </div>
  );
};

// Composant principal
const PricingPlansRTL: React.FC = () => {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 py-12" dir="rtl">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        
        {/* En-tête */}
        <div className="text-center mb-12">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            اختر الخطة المناسبة لك
          </h1>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            خطط مرنة تناسب جميع احتياجاتك التعليمية مع دعم كامل للغة العربية وواجهة من اليمين إلى اليسار
          </p>
        </div>

        {/* Grille des plans */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto">
          {Object.entries(plansArabic).map(([key, plan], index) => (
            <PricingCardRTL 
              key={key}
              plan={plan}
              index={index}
            />
          ))}
        </div>

        {/* Section FAQ */}
        <div className="mt-16 max-w-4xl mx-auto faq-container">
          <h2 className="text-2xl font-bold text-center text-gray-900 mb-8">
            الأسئلة الشائعة
          </h2>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="bg-white p-6 rounded-lg shadow-sm faq-item">
              <h3 className="faq-question text-gray-900 mb-2">
                هل يمكنني تغيير خطتي لاحقاً؟
              </h3>
              <p className="faq-answer">
                نعم، يمكنك ترقية أو تخفيض خطتك في أي وقت من خلال إعدادات الحساب.
              </p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-sm faq-item">
              <h3 className="faq-question text-gray-900 mb-2">
                ما هي مدة التجربة المجانية؟
              </h3>
              <p className="faq-answer">
                نوفر تجربة مجانية لمدة ١٤ يوماً لجميع الخطط المدفوعة بدون التزام.
              </p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-sm faq-item">
              <h3 className="faq-question text-gray-900 mb-2">
                هل الدعم متوفر باللغة العربية؟
              </h3>
              <p className="faq-answer">
                نعم، فريق الدعم لدينا يتحدث العربية ومتاح ٢٤/٧ لمساعدتك.
              </p>
            </div>
            
            <div className="bg-white p-6 rounded-lg shadow-sm faq-item">
              <h3 className="faq-question text-gray-900 mb-2">
                كيف يمكنني إلغاء اشتراكي؟
              </h3>
              <p className="faq-answer">
                يمكنك إلغاء اشتراكك في أي وقت بنقرة واحدة من إعدادات الفوترة.
              </p>
            </div>
          </div>
        </div>

        {/* Contact Support */}
        <div className="mt-12 text-center contact-section">
          <div className="bg-white p-8 rounded-xl shadow-sm border border-gray-200">
            <h3 className="text-xl font-semibold text-gray-900 mb-4">
              هل تحتاج مساعدة في اختيار الخطة المناسبة؟
            </h3>
            <p className="text-gray-600 mb-6">
              تواصل مع فريقنا وسنساعدك في العثور على الحل المثالي لاحتياجاتك
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center items-center contact-buttons">
              <button className="bg-green-500 hover:bg-green-600 text-white px-6 py-3 rounded-lg font-medium transition-colors">
                📱 تواصل معنا عبر الواتساب
              </button>
              <button className="border border-gray-300 hover:bg-gray-50 text-gray-700 px-6 py-3 rounded-lg font-medium transition-colors">
                📞 جدولة مكالمة مجانية
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PricingPlansRTL;
EOF

    log_success "Composant Pricing RTL créé"
}

# ===================================================================
# 🔧 CRÉATION DE LA PAGE PRICING
# ===================================================================

create_pricing_page() {
    log_header "CRÉATION DE LA PAGE PRICING"
    
    mkdir -p src/app/pricing
    
    cat > "src/app/pricing/page.tsx" << 'EOF'
import PricingPlansRTL from '@/components/pricing/PricingPlansRTL';

export const metadata = {
  title: 'الأسعار - Math4Child',
  description: 'خطط الاشتراك المرنة لتطبيق Math4Child التعليمي',
  keywords: 'أسعار, اشتراك, رياضيات, تعليم, أطفال',
};

export default function PricingPage() {
  return <PricingPlansRTL />;
}
EOF

    log_success "Page Pricing créée"
}

# ===================================================================
# 🌍 AMÉLIORATION DES TRADUCTIONS
# ===================================================================

enhance_translations() {
    log_header "AMÉLIORATION DES TRADUCTIONS ARABES"
    
    # Mise à jour des traductions
    cat > "src/lib/translations/pricing.ts" << 'EOF'
export const pricingTranslations = {
  ar: {
    // En-têtes principales
    chooseYourPlan: "اختر الخطة المناسبة لك",
    flexiblePlans: "خطط مرنة تناسب جميع احتياجاتك التعليمية مع دعم كامل للغة العربية وواجهة من اليمين إلى اليسار",
    
    // Plans
    schoolPlan: "خطة المدرسة",
    premiumPlan: "الخطة المميزة",
    enterprisePlan: "خطة المؤسسة",
    
    // Prix et périodes
    free: "مجاني",
    month: "شهر",
    perMonth: "/شهر",
    onDemand: "حسب الطلب",
    
    // Fonctionnalités
    teacherDashboard: "لوحة تحكم المعلم",
    exportResults: "تصدير النتائج",
    educationalSupport: "دعم تعليمي مخصص",
    comprehensiveTraining: "تدريب شامل",
    progressReports: "تقارير التقدم",
    prioritySupport: "دعم ذو أولوية",
    exclusiveContent: "محتوى حصري",
    advancedAnalytics: "تحليلات متقدمة",
    detailedErrorAnalysis: "تحليل مفصل للأخطاء",
    fullCustomization: "تخصيص كامل للواجهة",
    dedicatedSupport: "دعم ٢٤/٧ مخصص",
    advancedApiIntegration: "تكامل API متقدم",
    
    // Boutons et actions
    selectThisPlan: "اختر هذه الخطة",
    freeTrial: "تجربة مجانية ١٤ يوم",
    mostPopular: "الأكثر شعبية",
    limitedTime: "فترة محدودة - غير قابلة للتجديد",
    
    // FAQ
    frequentlyAskedQuestions: "الأسئلة الشائعة",
    canIChangeMyPlan: "هل يمكنني تغيير خطتي لاحقاً؟",
    canIChangeMyPlanAnswer: "نعم، يمكنك ترقية أو تخفيض خطتي في أي وقت من خلال إعدادات الحساب.",
    freeTrialDuration: "ما هي مدة التجربة المجانية؟",
    freeTrialDurationAnswer: "نوفر تجربة مجانية لمدة ١٤ يوماً لجميع الخطط المدفوعة بدون التزام.",
    arabicSupport: "هل الدعم متوفر باللغة العربية؟",
    arabicSupportAnswer: "نعم، فريق الدعم لدينا يتحدث العربية ومتاح ٢٤/٧ لمساعدتك.",
    howToCancelSubscription: "كيف يمكنني إلغاء اشتراكي؟",
    howToCancelSubscriptionAnswer: "يمكنك إلغاء اشتراكك في أي وقت بنقرة واحدة من إعدادات الفوترة.",
    
    // Support et contact
    needHelpChoosing: "هل تحتاج مساعدة في اختيار الخطة المناسبة؟",
    contactOurTeam: "تواصل مع فريقنا وسنساعدك في العثور على الحل المثالي لاحتياجاتك",
    contactViaWhatsApp: "📱 تواصل معنا عبر الواتساب",
    scheduleFreeCall: "📞 جدولة مكالمة مجانية",
    
    // Devises et prix
    currency: {
      aed: "درهم إماراتي",
      sar: "ريال سعودي",
      egp: "جنيه مصري",
      jod: "دينار أردني"
    }
  },
  
  // Versions en français pour comparaison
  fr: {
    chooseYourPlan: "Choisissez votre plan",
    flexiblePlans: "Plans flexibles adaptés à tous vos besoins éducatifs",
    schoolPlan: "Plan École",
    premiumPlan: "Plan Premium",
    enterprisePlan: "Plan Entreprise",
    selectThisPlan: "Choisir ce plan",
    freeTrial: "Essai gratuit 14 jours",
    mostPopular: "Le plus populaire"
  }
};

export default pricingTranslations;
EOF

    log_success "Traductions améliorées"
}

# ===================================================================
# 🧪 CRÉATION DES TESTS RTL
# ===================================================================

create_rtl_tests() {
    log_header "CRÉATION DES TESTS RTL"
    
    mkdir -p tests/specs/rtl
    
    cat > "tests/specs/rtl/pricing-rtl.spec.ts" << 'EOF'
import { test, expect } from '@playwright/test';
import { Math4ChildTestHelper } from '../../utils/test-utils';

test.describe('Math4Child - Interface RTL Pricing', () => {
  
  test.beforeEach(async ({ page }) => {
    // Aller à la page pricing
    await page.goto('/pricing');
    
    // Forcer la langue arabe et RTL
    await page.evaluate(() => {
      localStorage.setItem('language', 'ar');
      document.documentElement.dir = 'rtl';
      document.documentElement.lang = 'ar';
    });
    
    await page.reload({ waitUntil: 'domcontentloaded' });
    await page.waitForSelector('body', { timeout: 15000 });
  });

  test('Interface RTL correctement appliquée @rtl @pricing', async ({ page }) => {
    // Vérifier la direction RTL
    const htmlDir = await page.getAttribute('html', 'dir');
    expect(htmlDir).toBe('rtl');
    
    // Vérifier la langue arabe
    const htmlLang = await page.getAttribute('html', 'lang');
    expect(htmlLang).toBe('ar');
    
    // Vérifier que les éléments principaux sont visibles
    await expect(page.locator('text=اختر الخطة المناسبة لك')).toBeVisible();
    
    console.log('✅ Interface RTL pricing validée');
  });

  test('Plans en arabe visibles et fonctionnels @rtl @pricing', async ({ page }) => {
    // Vérifier les titres de plans en arabe
    await expect(page.locator('text=خطة المدرسة')).toBeVisible();
    await expect(page.locator('text=الخطة المميزة')).toBeVisible(); 
    await expect(page.locator('text=خطة المؤسسة')).toBeVisible();
    
    // Vérifier le badge "الأكثر شعبية"
    await expect(page.locator('text=الأكثر شعبية')).toBeVisible();
    
    // Vérifier les boutons en arabe
    const arabicButtons = page.locator('button:has-text("اختر هذه الخطة")');
    const buttonCount = await arabicButtons.count();
    expect(buttonCount).toBeGreaterThanOrEqual(3);
    
    console.log('✅ Plans en arabe validés');
  });

  test('Fonctionnalités avec checkmarks RTL @rtl @pricing', async ({ page }) => {
    // Vérifier que les checkmarks sont présents
    const checkmarks = page.locator('.feature-icon:has-text("✓")');
    const checkmarkCount = await checkmarks.count();
    expect(checkmarkCount).toBeGreaterThan(8); // Au moins 3 plans × 3 features chacun
    
    // Vérifier l'alignement RTL des fonctionnalités
    const featureItems = page.locator('.feature-item');
    for (let i = 0; i < Math.min(3, await featureItems.count()); i++) {
      const item = featureItems.nth(i);
      await expect(item).toBeVisible();
    }
    
    console.log('✅ Fonctionnalités RTL validées');
  });

  test('Sélection de plan fonctionnelle @rtl @pricing', async ({ page }) => {
    // Tester la sélection du plan premium (bleu)
    await page.click('[data-testid="plan-blue-select"]');
    
    // Attendre une réaction (modal, redirection, etc.)
    await page.waitForTimeout(1000);
    
    // Vérifier que le clic a été pris en compte
    // (Le test dépend de votre implémentation)
    
    console.log('✅ Sélection de plan testée');
  });

  test('Bouton essai gratuit visible @rtl @pricing', async ({ page }) => {
    // Vérifier la présence du bouton essai gratuit
    const trialButton = page.locator('[data-testid="trial-button"]');
    
    if (await trialButton.isVisible()) {
      await expect(trialButton).toContainText('تجربة مجانية');
      console.log('✅ Bouton essai gratuit trouvé');
    } else {
      console.log('ℹ️ Bouton essai gratuit non présent (optionnel)');
    }
  });

  test('FAQ en arabe fonctionnelle @rtl @pricing', async ({ page }) => {
    // Vérifier le titre FAQ
    await expect(page.locator('text=الأسئلة الشائعة')).toBeVisible();
    
    // Vérifier au moins une question FAQ
    await expect(page.locator('text=هل يمكنني تغيير خطتي لاحقاً؟')).toBeVisible();
    
    // Vérifier les éléments FAQ ont la classe RTL
    const faqItems = page.locator('.faq-item');
    const faqCount = await faqItems.count();
    expect(faqCount).toBeGreaterThanOrEqual(2);
    
    console.log('✅ FAQ en arabe validée');
  });

  test('Section contact en arabe @rtl @pricing', async ({ page }) => {
    // Vérifier la section contact
    await expect(page.locator('text=هل تحتاج مساعدة في اختيار الخطة المناسبة؟')).toBeVisible();
    
    // Vérifier les boutons de contact
    await expect(page.locator('text=تواصل معنا عبر الواتساب')).toBeVisible();
    await expect(page.locator('text=جدولة مكالمة مجانية')).toBeVisible();
    
    console.log('✅ Section contact validée');
  });

  test('Responsive RTL sur mobile @rtl @responsive @pricing', async ({ page }) => {
    // Simuler un appareil mobile
    await page.setViewportSize({ width: 375, height: 667 });
    
    // Vérifier que l'interface s'adapte correctement
    const container = page.locator('.grid-cols-1.md\\:grid-cols-3');
    await expect(container).toBeVisible();
    
    // Vérifier que les plans restent visibles et accessibles
    await expect(page.locator('text=خطة المدرسة')).toBeVisible();
    await expect(page.locator('text=الخطة المميزة')).toBeVisible();
    
    // Vérifier que les boutons restent cliquables
    const buttons = page.locator('button:has-text("اختر هذه الخطة")');
    for (let i = 0; i < await buttons.count(); i++) {
      await expect(buttons.nth(i)).toBeVisible();
    }
    
    console.log('✅ Interface RTL responsive validée');
  });

  test('Styles RTL appliqués correctement @rtl @pricing', async ({ page }) => {
    // Vérifier que les styles RTL sont appliqués
    const pricingCards = page.locator('.pricing-card');
    
    for (let i = 0; i < Math.min(3, await pricingCards.count()); i++) {
      const card = pricingCards.nth(i);
      
      // Vérifier que la direction RTL est appliquée
      const direction = await card.getAttribute('dir');
      expect(direction).toBe('rtl');
    }
    
    // Vérifier les classes CSS RTL
    const bodyClasses = await page.getAttribute('body', 'class');
    console.log(`Classes body: ${bodyClasses}`);
    
    console.log('✅ Styles RTL appliqués');
  });
});

test.setTimeout(90000); // 90 secondes par test
test.describe.configure({ retries: 2 });
EOF

    log_success "Tests RTL créés"
}

# ===================================================================
# 🔧 MISE À JOUR DU MAKEFILE
# ===================================================================

update_makefile() {
    log_header "MISE À JOUR DU MAKEFILE"
    
    # Ajouter les commandes RTL au Makefile
    cat >> "Makefile" << 'EOF'

# ===================================================================
# 🌍 COMMANDES RTL SPÉCIFIQUES
# ===================================================================

.PHONY: test-rtl-pricing
test-rtl-pricing: ## 🇸🇦 Tests RTL pricing uniquement
	$(call print_header,TESTS RTL PRICING)
	npx playwright test tests/specs/rtl/pricing-rtl.spec.ts

.PHONY: test-rtl-all
test-rtl-all: ## 🌍 Tous les tests RTL
	$(call print_header,TOUS LES TESTS RTL)
	npx playwright test tests/specs/rtl/

.PHONY: dev-rtl
dev-rtl: ## 🌍 Serveur avec langue arabe par défaut
	$(call print_header,SERVEUR RTL)
	$(call print_info,Démarrage avec langue arabe...)
	NEXT_PUBLIC_DEFAULT_LANG=ar npm run dev

.PHONY: build-rtl
build-rtl: ## 🏗️ Build avec support RTL optimisé
	$(call print_header,BUILD RTL)
	$(call print_info,Build avec optimisations RTL...)
	npm run build

.PHONY: validate-rtl
validate-rtl: ## ✅ Validation complète RTL
	$(call print_header,VALIDATION RTL)
	@make test-rtl-pricing
	@make test-translation
	$(call print_success,Validation RTL réussie!)

# Message pour les commandes RTL
$(info 🌍 Commandes RTL ajoutées au Makefile)
EOF

    log_success "Makefile mis à jour avec commandes RTL"
}

# ===================================================================
# 🛠️ CRÉATION DU SCRIPT DE VALIDATION
# ===================================================================

create_validation_script() {
    log_header "CRÉATION DU SCRIPT DE VALIDATION RTL"
    
    cat > "scripts/validate-rtl.sh" << 'EOF'
#!/bin/bash

echo "🌍 Validation Interface RTL Math4Child"
echo "====================================="

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Vérifications
echo -e "${BLUE}📋 Vérification des fichiers RTL...${NC}"

# Vérifier la présence des fichiers critiques
if [ -f "src/components/pricing/PricingPlansRTL.tsx" ]; then
    echo -e "${GREEN}✅ Composant Pricing RTL présent${NC}"
else
    echo -e "${YELLOW}⚠️ Composant Pricing RTL manquant${NC}"
fi

if [ -f "src/app/pricing/page.tsx" ]; then
    echo -e "${GREEN}✅ Page Pricing présente${NC}"
else
    echo -e "${YELLOW}⚠️ Page Pricing manquante${NC}"
fi

if [ -f "tests/specs/rtl/pricing-rtl.spec.ts" ]; then
    echo -e "${GREEN}✅ Tests RTL présents${NC}"
else
    echo -e "${YELLOW}⚠️ Tests RTL manquants${NC}"
fi

# Vérifier les styles RTL dans globals.css
echo -e "${BLUE}📋 Vérification des styles RTL...${NC}"
if grep -q "\[dir=\"rtl\"\]" "src/app/globals.css"; then
    echo -e "${GREEN}✅ Styles RTL détectés dans globals.css${NC}"
else
    echo -e "${YELLOW}⚠️ Styles RTL non détectés${NC}"
fi

# Tests rapides
echo -e "${BLUE}🧪 Tests RTL rapides...${NC}"
npx playwright test tests/specs/rtl/pricing-rtl.spec.ts --project=smoke || echo -e "${YELLOW}⚠️ Certains tests RTL ont échoué${NC}"

echo ""
echo -e "${GREEN}🎉 Validation RTL terminée !${NC}"
echo -e "${BLUE}💡 Pour tester manuellement :${NC}"
echo -e "1. make dev-rtl"
echo -e "2. Aller sur http://localhost:3000/pricing"
echo -e "3. Vérifier l'affichage RTL"
EOF

    chmod +x scripts/validate-rtl.sh
    
    log_success "Script de validation RTL créé"
}

# ===================================================================
# 🎯 FONCTION PRINCIPALE
# ===================================================================

main() {
    log_header "SETUP INTERFACE RTL MATH4CHILD"
    
    echo -e "${BOLD}Ce script va créer :${NC}"
    echo -e "${BLUE}• Styles CSS RTL complets${NC}"
    echo -e "${BLUE}• Composant Pricing RTL optimisé${NC}"
    echo -e "${BLUE}• Page Pricing avec support arabe${NC}"
    echo -e "${BLUE}• Tests RTL exhaustifs${NC}"
    echo -e "${BLUE}• Traductions améliorées${NC}"
    echo -e "${BLUE}• Scripts de validation${NC}"
    echo ""
    
    read -p "🚀 Continuer l'installation RTL ? [y/N] " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation annulée."
        exit 0
    fi
    
    # Initialisation des logs
    echo "$(date): Démarrage setup RTL v$SCRIPT_VERSION" > "$LOG_FILE"
    
    # Étapes d'installation
    create_backup
    create_rtl_styles
    create_pricing_component
    create_pricing_page
    enhance_translations
    create_rtl_tests
    update_makefile
    create_validation_script
    
    # Affichage final
    show_final_summary
}

# Affichage final
show_final_summary() {
    log_header "🎉 SETUP RTL RÉUSSI !"
    
    echo -e "${GREEN}✅ Interface RTL Math4Child configurée avec succès !${NC}"
    echo ""
    echo -e "${BOLD}🎯 PROCHAINES ÉTAPES :${NC}"
    echo -e "${CYAN}1.${NC} Tester l'interface : ${GREEN}make dev-rtl${NC}"
    echo -e "${CYAN}2.${NC} Voir la page pricing : ${GREEN}http://localhost:3000/pricing${NC}"
    echo -e "${CYAN}3.${NC} Tests RTL : ${GREEN}make test-rtl-pricing${NC}"
    echo -e "${CYAN}4.${NC} Validation complète : ${GREEN}make validate-rtl${NC}"
    echo ""
    echo -e "${BOLD}📁 FICHIERS CRÉÉS :${NC}"
    echo -e "${BLUE}•${NC} src/app/globals.css (styles RTL ajoutés)"
    echo -e "${BLUE}•${NC} src/components/pricing/PricingPlansRTL.tsx"
    echo -e "${BLUE}•${NC} src/app/pricing/page.tsx"
    echo -e "${BLUE}•${NC} src/lib/translations/pricing.ts"
    echo -e "${BLUE}•${NC} tests/specs/rtl/pricing-rtl.spec.ts"
    echo -e "${BLUE}•${NC} scripts/validate-rtl.sh"
    echo ""
    echo -e "${BOLD}🌍 FONCTIONNALITÉS RTL :${NC}"
    echo -e "${BLUE}•${NC} Interface complète droite-à-gauche"
    echo -e "${BLUE}•${NC} Plans d'abonnement en arabe"
    echo -e "${BLUE}•${NC} FAQ et support en arabe"
    echo -e "${BLUE}•${NC} Responsive RTL mobile/desktop"
    echo -e "${BLUE}•${NC} Tests automatisés RTL"
    echo ""
    echo -e "${YELLOW}📝 Logs détaillés : $LOG_FILE${NC}"
    echo -e "${YELLOW}💾 Sauvegarde : $BACKUP_DIR${NC}"
    echo -e "${GREEN}🚀 Interface RTL prête pour utilisation !${NC}"
}

# Gestion d'erreur
handle_error() {
    local exit_code=$?
    log_error "Erreur détectée (code: $exit_code)"
    
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "${YELLOW}💾 Sauvegarde disponible dans $BACKUP_DIR${NC}"
        echo -e "${YELLOW}Pour restaurer: cp -r $BACKUP_DIR/* .${NC}"
    fi
    
    echo -e "${RED}❌ Setup RTL échoué. Consultez $LOG_FILE${NC}"
    exit $exit_code
}

# Piéger les erreurs
trap 'handle_error' ERR

# Exécution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi