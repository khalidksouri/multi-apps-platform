import { NextRequest, NextResponse } from 'next/server';
import { ShippingService } from '@/lib/shipping';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    
    const { departure, destination, weight, dimensions } = body;
    
    if (!departure || !destination || !weight || !dimensions) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: 'MISSING_PARAMETERS',
            message: 'Paramètres manquants',
          },
        },
        { status: 400 }
      );
    }

    const shippingService = new ShippingService();
    const results = await shippingService.calculateShipping({
      departure,
      destination,
      weight: parseFloat(weight),
      dimensions,
    });
    
    return NextResponse.json({
      success: true,
      data: results,
    });
  } catch (error) {
    console.error('Shipping calculation error:', error);
    
    return NextResponse.json(
      {
        success: false,
        error: {
          code: 'CALCULATION_ERROR',
          message: 'Erreur lors du calcul des frais d\'expédition',
        },
      },
      { status: 500 }
    );
  }
}
