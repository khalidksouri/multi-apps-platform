import { NextResponse } from 'next/server';

export async function GET() {
  return NextResponse.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    app: 'ai4kids',
    version: process.env.npm_package_version || '1.0.0',
  });
}
