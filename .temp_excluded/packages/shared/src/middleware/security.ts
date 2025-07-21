import { NextRequest, NextResponse } from 'next/server';

// Configuration CORS
export const corsHeaders = {
  'Access-Control-Allow-Origin': process.env.NODE_ENV === 'production' 
    ? process.env.ALLOWED_ORIGINS || 'https://yourdomain.com'
    : '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, X-Requested-With',
  'Access-Control-Allow-Credentials': 'true',
};

// Headers de sécurité
export const securityHeaders = {
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'X-XSS-Protection': '1; mode=block',
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'camera=(), microphone=(), geolocation=()',
  ...(process.env.NODE_ENV === 'production' && {
    'Strict-Transport-Security': 'max-age=31536000; includeSubDomains; preload'
  })
};

// Middleware de sécurité principal
export function securityMiddleware(request: NextRequest) {
  const response = NextResponse.next();
  
  // Appliquer les headers de sécurité
  Object.entries(securityHeaders).forEach(([key, value]) => {
    response.headers.set(key, value);
  });
  
  return response;
}

// Middleware CORS
export function corsMiddleware(request: NextRequest) {
  // Gérer les requêtes OPTIONS (preflight)
  if (request.method === 'OPTIONS') {
    return new NextResponse(null, {
      status: 200,
      headers: corsHeaders
    });
  }
  
  const response = NextResponse.next();
  
  // Appliquer les headers CORS
  Object.entries(corsHeaders).forEach(([key, value]) => {
    response.headers.set(key, value);
  });
  
  return response;
}

// Validation des tokens JWT
export function validateJWT(token: string): { valid: boolean; payload?: any } {
  try {
    const jwt = require('jsonwebtoken');
    const payload = jwt.verify(token, process.env.JWT_SECRET || 'fallback-secret');
    return { valid: true, payload };
  } catch (error) {
    return { valid: false };
  }
}

// Middleware d'authentification
export function authMiddleware(request: NextRequest) {
  const authHeader = request.headers.get('authorization');
  
  if (!authHeader?.startsWith('Bearer ')) {
    return NextResponse.json(
      { error: 'Token d\'authentification manquant' }, 
      { status: 401 }
    );
  }
  
  const token = authHeader.substring(7);
  const { valid, payload } = validateJWT(token);
  
  if (!valid) {
    return NextResponse.json(
      { error: 'Token invalide' }, 
      { status: 401 }
    );
  }
  
  // Ajouter les informations utilisateur à la requête
  (request as any).user = payload;
  return NextResponse.next();
}

// Rate limiting simple (à améliorer avec Redis)
const requestCounts = new Map<string, { count: number; resetTime: number }>();

export function rateLimitMiddleware(request: NextRequest, maxRequests: number = 100, windowMs: number = 15 * 60 * 1000) {
  const clientIP = request.ip || request.headers.get('x-forwarded-for') || 'unknown';
  const now = Date.now();
  
  const clientData = requestCounts.get(clientIP);
  
  if (!clientData || now > clientData.resetTime) {
    // Nouveau client ou fenêtre expirée
    requestCounts.set(clientIP, { count: 1, resetTime: now + windowMs });
    return NextResponse.next();
  }
  
  if (clientData.count >= maxRequests) {
    return NextResponse.json(
      { error: 'Trop de requêtes' }, 
      { status: 429, headers: { 'Retry-After': String(Math.ceil((clientData.resetTime - now) / 1000)) } }
    );
  }
  
  clientData.count++;
  return NextResponse.next();
}
