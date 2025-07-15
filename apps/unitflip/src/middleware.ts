import { NextRequest } from 'next/server';
import { securityMiddleware, corsMiddleware, rateLimitMiddleware } from '@multiapps/shared/middleware/security';

export function middleware(request: NextRequest) {
  // Appliquer le rate limiting
  const rateLimitResponse = rateLimitMiddleware(request);
  if (rateLimitResponse.status === 429) {
    return rateLimitResponse;
  }
  
  // Appliquer CORS
  const corsResponse = corsMiddleware(request);
  if (corsResponse) {
    return corsResponse;
  }
  
  // Appliquer la sécurité
  return securityMiddleware(request);
}

export const config = {
  matcher: [
    '/api/:path*',
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
};
