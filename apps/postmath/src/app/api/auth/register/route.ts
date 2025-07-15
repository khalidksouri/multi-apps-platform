import { NextRequest, NextResponse } from 'next/server';
import { hash } from 'bcryptjs';
import { PrismaClient } from '@prisma/client';
import { RegisterSchema, validateData } from '@multiapps/shared/validation';
import { logError, logInfo } from '@multiapps/shared/utils/logger';
import { corsMiddleware, securityMiddleware } from '@multiapps/shared/middleware/security';

const prisma = new PrismaClient();

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validation = validateData(RegisterSchema, body);
    
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

    const { email, password, name, role } = validation.data!;

    // Vérifier si l'utilisateur existe déjà
    const existingUser = await prisma.user.findUnique({
      where: { email }
    });

    if (existingUser) {
      return NextResponse.json({
        success: false,
        error: {
          code: 'USER_EXISTS',
          message: 'Un utilisateur avec cet email existe déjà'
        }
      }, { status: 409 });
    }

    // Hasher le mot de passe
    const hashedPassword = await hash(password, parseInt(process.env.BCRYPT_ROUNDS || '12'));

    // Créer l'utilisateur
    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        name,
        role
      },
      select: {
        id: true,
        email: true,
        name: true,
        role: true,
        createdAt: true
      }
    });

    logInfo('Nouvel utilisateur créé', { userId: user.id, email: user.email });

    const response = NextResponse.json({
      success: true,
      data: {
        user,
        message: 'Utilisateur créé avec succès'
      }
    }, { status: 201 });

    return corsMiddleware(request) || securityMiddleware(request) || response;

  } catch (error) {
    logError('Erreur lors de la création d\'utilisateur', error as Error);
    
    return NextResponse.json({
      success: false,
      error: {
        code: 'REGISTRATION_ERROR',
        message: 'Erreur lors de la création du compte'
      }
    }, { status: 500 });
  }
}

export async function OPTIONS(request: NextRequest) {
  return corsMiddleware(request);
}
