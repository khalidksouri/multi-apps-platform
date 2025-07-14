// =============================================
// 📄 tests/support/test-data.ts
// =============================================
import * as fs from 'fs';
import * as path from 'path';

export interface TestUser {
  username: string;
  email: string;
  password: string;
  role: string;
}

export interface TestData {
  users: TestUser[];
  budgetData: any;
  shippingData: any;
  conversionData: any;
}

export class TestDataManager {
  private data: TestData;
  private fixturesPath: string;

  constructor() {
    this.fixturesPath = path.join(process.cwd(), 'tests', 'fixtures');
    this.data = this.loadTestData();
  }

  private loadTestData(): TestData {
    try {
      const usersData = this.loadJsonFile('users.json');
      const budgetData = this.loadJsonFile('budget-data.json');
      const shippingData = this.loadJsonFile('shipping-data.json');
      const conversionData = this.loadJsonFile('conversion-data.json');

      return {
        users: usersData,
        budgetData,
        shippingData,
        conversionData
      };
    } catch (error) {
      console.warn('Impossible de charger les données de test, utilisation des données par défaut');
      return this.getDefaultData();
    }
  }

  private loadJsonFile(filename: string): any {
    const filePath = path.join(this.fixturesPath, filename);
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf8');
      return JSON.parse(content);
    }
    return {};
  }

  private getDefaultData(): TestData {
    return {
      users: [
        {
          username: 'testuser',
          email: 'test@example.com',
          password: 'Test123!',
          role: 'user'
        }
      ],
      budgetData: {
        totalBudget: 2500,
        spent: 1850,
        remaining: 650,
        categories: [
          { name: 'Alimentation', budget: 500, spent: 350 },
          { name: 'Transport', budget: 300, spent: 280 },
          { name: 'Loisirs', budget: 200, spent: 90 },
          { name: 'Logement', budget: 1000, spent: 850 }
        ]
      },
      shippingData: {
        carriers: [
          { name: 'Colissimo', basePrice: 5.50 },
          { name: 'Chronopost', basePrice: 8.90 },
          { name: 'UPS', basePrice: 12.00 }
        ]
      },
      conversionData: {
        temperature: [
          { celsius: 0, fahrenheit: 32 },
          { celsius: 100, fahrenheit: 212 }
        ],
        length: [
          { meters: 1, kilometers: 0.001 },
          { meters: 1000, kilometers: 1 }
        ]
      }
    };
  }

  getUser(role: string = 'user'): TestUser {
    return this.data.users.find(user => user.role === role) || this.data.users[0];
  }

  getBudgetData(): any {
    return this.data.budgetData;
  }

  getShippingData(): any {
    return this.data.shippingData;
  }

  getConversionData(): any {
    return this.data.conversionData;
  }

  generateRandomData(type: string): any {
    switch (type) {
      case 'weight':
        return (Math.random() * 30).toFixed(1);
      case 'dimensions':
        const l = Math.floor(Math.random() * 100) + 10;
        const w = Math.floor(Math.random() * 80) + 10;
        const h = Math.floor(Math.random() * 60) + 10;
        return `${l}x${w}x${h}`;
      case 'city':
        const cities = ['Paris', 'Lyon', 'Marseille', 'Toulouse', 'Nice', 'Nantes'];
        return cities[Math.floor(Math.random() * cities.length)];
      default:
        return null;
    }
  }
}