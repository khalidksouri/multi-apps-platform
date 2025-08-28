import { NextRequest } from 'next/server'

export async function POST(request: NextRequest) {
  try {
    const { planId } = await request.json()
    
    // Simulation checkout pour demo
    return Response.json({ 
      success: true,
      sessionId: 'demo_session_' + Date.now(),
      url: '/success?session_id=demo_' + planId
    })
  } catch (error) {
    return Response.json({ error: 'Erreur demo' }, { status: 500 })
  }
}
