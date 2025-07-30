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
