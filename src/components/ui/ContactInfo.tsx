import React from 'react'
import { Mail, Globe, MessageCircle } from 'lucide-react'

export default function ContactInfo({ className = "" }: { className?: string }) {
  return (
    <div className={`bg-gradient-to-r from-blue-50 to-purple-50 p-8 rounded-2xl border border-blue-200 ${className}`}>
      <div className="text-center">
        <h3 className="text-2xl font-bold text-gray-800 mb-6 flex items-center justify-center">
          <MessageCircle className="w-6 h-6 mr-2 text-blue-600" />
          Support & Contact Math4Child
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div className="bg-white p-6 rounded-xl shadow-sm border border-blue-100">
            <Mail className="w-8 h-8 text-blue-600 mx-auto mb-3" />
            <div className="text-blue-600 font-medium mb-2">Support Technique</div>
            <a 
              href="mailto:support@math4child.com"
              className="text-blue-700 hover:text-blue-800 font-semibold text-lg transition-colors block"
            >
              support@math4child.com
            </a>
            <p className="text-sm text-blue-600 mt-2">Aide 24/7 pour toutes vos questions</p>
          </div>
          <div className="bg-white p-6 rounded-xl shadow-sm border border-purple-100">
            <Mail className="w-8 h-8 text-purple-600 mx-auto mb-3" />
            <div className="text-purple-600 font-medium mb-2">Équipe Commerciale</div>
            <a 
              href="mailto:commercial@math4child.com"
              className="text-purple-700 hover:text-purple-800 font-semibold text-lg transition-colors block"
            >
              commercial@math4child.com
            </a>
            <p className="text-sm text-purple-600 mt-2">Plans entreprise et partenariats</p>
          </div>
        </div>
        <div className="flex items-center justify-center space-x-2 text-gray-600">
          <Globe className="w-5 h-5" />
          <span className="font-medium text-lg">www.math4child.com</span>
          <span className="text-sm">• 200+ Langues supportées 🇲🇦🇵🇸</span>
        </div>
      </div>
    </div>
  )
}
