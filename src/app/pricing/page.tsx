'use client';

export default function PricingPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-purple-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <h1 className="text-6xl font-bold mb-6">💎 Plans d'Abonnement</h1>
          <p className="text-2xl">Révolutionnez l'apprentissage de vos enfants</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {[
            { name: 'BASIQUE', price: '9.99€', desc: 'Pour débuter' },
            { name: 'PREMIUM', price: '19.99€', desc: 'Le plus populaire', popular: true },
            { name: 'FAMILLE', price: '29.99€', desc: 'Jusqu\'à 5 enfants' },
          ].map((plan, i) => (
            <div key={i} className={`bg-white/10 rounded-2xl p-8 ${plan.popular ? 'ring-2 ring-yellow-500' : ''}`}>
              {plan.popular && (
                <div className="text-center mb-4">
                  <div className="bg-yellow-500 text-black px-4 py-1 rounded-full text-sm font-bold inline-block">
                    ⭐ LE PLUS CHOISI
                  </div>
                </div>
              )}
              <div className="text-center">
                <h3 className="text-2xl font-bold mb-2">{plan.name}</h3>
                <p className="text-gray-400 mb-4">{plan.desc}</p>
                <div className="text-4xl font-bold mb-6">{plan.price}</div>
                <button className="w-full py-3 bg-blue-600 hover:bg-blue-700 rounded font-semibold">
                  Choisir ce plan
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
