import { NextResponse } from 'next/server'

export async function GET() {
  return NextResponse.json({ 
    status: 'ok',
    message: 'Math4Child API is working!',
    timestamp: new Date().toISOString()
  })
}
