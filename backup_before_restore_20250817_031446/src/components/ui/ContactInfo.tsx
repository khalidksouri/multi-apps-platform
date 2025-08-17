import React from 'react'

export default function ContactInfo() {
  return (
    <div className="bg-blue-50 p-6 rounded-lg border border-blue-200 my-8">
      <h3 className="text-lg font-semibold text-gray-800 mb-4 text-center">
        💬 Support & Contact
      </h3>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-center">
        <div className="bg-white p-4 rounded shadow-sm">
          <div className="text-blue-600 font-medium mb-1">Support Technique</div>
          <a href="mailto:support@math4child.com" className="text-blue-700 font-semibold">
            support@math4child.com
          </a>
        </div>
        <div className="bg-white p-4 rounded shadow-sm">
          <div className="text-purple-600 font-medium mb-1">Commercial</div>
          <a href="mailto:commercial@math4child.com" className="text-purple-700 font-semibold">
            commercial@math4child.com
          </a>
        </div>
      </div>
      <div className="text-center mt-4 text-sm text-gray-600">
        🌐 www.math4child.com - 200+ Langues 🇲🇦🇵🇸
      </div>
    </div>
  )
}
