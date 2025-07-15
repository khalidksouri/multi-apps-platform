import { NextRequest, NextResponse } from 'next/server';
import { ShippingService } from '@/lib/shipping';
import { validateShippingData } from '@multiapps/shared/validation';
import { logError, logInfo } from '@multiapps/shared/utils/logger';
import { cache } from '@multiapps/shared/utils/cache';

export async function POST(request: NextRequest) {
  const startTime = Date.now();
  
  try {
    // Validation des données
    const body = await request.json();
    const validation = validateShippingData(body);
    
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

    const validatedData = validation.data!;
    
    // Clé de cache
    const cacheKey = cache.generateKey(
      'shipping', 
      validatedData.departure, 
      validatedData.destination, 
      validatedData.weight.toString(), 
      validatedData.dimensions
    );

    // Vérifier le cache
    const cachedResult = await cache.get(cacheKey);
    if (cachedResult) {
      logInfo('Résultat servi depuis le cache', { cacheKey });
      return NextResponse.json({
        success: true,
        data: cachedResult,
        cached: true
      });
    }

    // Calculer les frais d'expédition
    const shippingService = new ShippingService();
    const results = await shippingService.calculateShipping(validatedData);
    
    // Mettre en cache (30 minutes)
    await cache.set(cacheKey, results, 1800);
    
    const duration = Date.now() - startTime;
    logInfo('Calcul d\'expédition réussi', { 
      departure: validatedData.departure,
      destination: validatedData.destination,
      carriersCount: results.carriers.length,
      duration: `${duration}ms`
    });
    
    return NextResponse.json({
      success: true,
      data: results
    });

  } catch (error) {
    logError('Erreur lors du calcul d\'expédition', error as Error, {
      url: request.url,
      method: request.method
    });
    
    return NextResponse.json({
      success: false,
      error: {
        code: 'CALCULATION_ERROR',
        message: 'Erreur lors du calcul des frais d\'expédition'
      }
    }, { status: 500 });
  }
}

export async function OPTIONS(request: NextRequest) {
  return new NextResponse(null, {
    status: 200,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  });
}
