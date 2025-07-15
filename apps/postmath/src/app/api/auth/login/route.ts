import { NextRequest, NextResponse } from 'next/server';
import { compare } from 'bcryptjs';
import { sign } from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';
import { LoginSchema, validateData } from '@multiapps/shared/validation';
import { logError, logInfo } from '@multiapps/shared/utils/logger';
import { corsMiddleware, securityMiddleware } from '@multiapps/shared/middleware/security';

const prisma = new PrismaClient();

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validation = validateData(LoginSchema, body);
    
    if (!validation.success) {
      return NextResponse.json({
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: 'Données invalides',
          details: validation.errors
        }
      }, { status: 400 });
    }

    const { email, password } = validation.data!;

    // Trouver l'utilisateur
    const user = await prisma.user.findUnique({
      where: { email }
    });

    if (!user) {
      return NextResponse.json({
        success: false,
        error: {
          code: 'INVALID_CREDENTIALS',
          message: 'Email ou mot de passe incorrect'
        }
      }, { status: 401 });
    }

    // Vérifier le mot de passe
    const isValidPassword = await compare(password, user.password);

    if (!isValidPassword) {
      return NextResponse.json({
        success: false,
        error: {
          code: 'INVALID_CREDENTIALS',
          message: 'Email ou mot de passe incorrect'
        }
      }, { status: 401 });
    }

    // Générer le token JWT
    const token = sign(
      { 
        userId: user.id, 
        email: user.email, 
        role: user.role 
      },
      process.env.JWT_SECRET || 'fallback-secret',
      { 
        expiresIn: process.env.JWT_EXPIRES_IN || '7d' 
      }
    );

    logInfo('Connexion réussie', { userId: user.id, email: user.email });

    const response = NextResponse.json({
      success: true,
      data: {
        token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role
        }
      }
    });

    return corsMiddleware(request) || securityMiddleware(request) || response;

  } catch (error) {
    logError('Erreur lors de la connexion', error as Error);
    
    return NextResponse.json({
      success: false,
      error: {
        code: 'LOGIN_ERROR',
        message: 'Erreur lors de la connexion'
      }
    }, { status: 500 });
  }
}

export async function OPTIONS(request: NextRequest) {
  return corsMiddleware(request);
}
