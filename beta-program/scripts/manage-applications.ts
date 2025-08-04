#!/usr/bin/env ts-node

/**
 * Système de gestion des candidatures Beta Math4Child
 * Développé pour GOTEST - Compatible TypeScript
 */

interface BetaApplication {
  id: string;
  dateReceived: Date;
  familyName: string;
  email: string;
  childAge: number;
  childGrade: string;
  equipment: 'Android' | 'iOS' | 'Web' | 'Multiple';
  source: 'Facebook' | 'Instagram' | 'LinkedIn' | 'Email' | 'Direct';
  motivation: string;
  status: 'pending' | 'accepted' | 'rejected' | 'waitlist';
  notes?: string;
  acceptedDate?: Date;
  testingStartDate?: Date;
  feedbackReceived?: {
    day7: boolean;
    day14: boolean;
  };
}

class BetaApplicationManager {
  private applications: BetaApplication[] = [];
  private readonly MAX_BETA_TESTERS = 50;
  private readonly TARGET_APPLICATIONS = 100;

  constructor() {
    this.loadApplications();
  }

  // Ajout d'une nouvelle candidature
  addApplication(applicationData: Omit<BetaApplication, 'id' | 'dateReceived' | 'status'>): string {
    const newApplication: BetaApplication = {
      id: this.generateId(),
      dateReceived: new Date(),
      status: 'pending',
      ...applicationData
    };

    this.applications.push(newApplication);
    this.saveApplications();
    this.sendAutoReply(newApplication);
    
    console.log(`✅ Nouvelle candidature ajoutée: ${newApplication.familyName} (${newApplication.email})`);
    return newApplication.id;
  }

  // Validation et acceptation d'une candidature
  acceptApplication(applicationId: string, notes?: string): boolean {
    const application = this.applications.find(app => app.id === applicationId);
    if (!application) return false;

    const acceptedCount = this.applications.filter(app => app.status === 'accepted').length;
    if (acceptedCount >= this.MAX_BETA_TESTERS) {
      console.warn(`⚠️ Limite de ${this.MAX_BETA_TESTERS} beta testeurs atteinte`);
      return false;
    }

    application.status = 'accepted';
    application.acceptedDate = new Date();
    application.notes = notes;

    this.saveApplications();
    this.sendAcceptanceEmail(application);
    
    console.log(`✅ Candidature acceptée: ${application.familyName}`);
    return true;
  }

  // Génération du rapport quotidien
  generateDailyReport(): void {
    const today = new Date().toISOString().split('T')[0];
    const todayApplications = this.applications.filter(
      app => app.dateReceived.toISOString().split('T')[0] === today
    );

    const stats = {
      totalApplications: this.applications.length,
      todayApplications: todayApplications.length,
      accepted: this.applications.filter(app => app.status === 'accepted').length,
      pending: this.applications.filter(app => app.status === 'pending').length,
      waitlist: this.applications.filter(app => app.status === 'waitlist').length,
      rejected: this.applications.filter(app => app.status === 'rejected').length,
      progressToTarget: (this.applications.length / this.TARGET_APPLICATIONS * 100).toFixed(1),
      progressToMax: (this.applications.filter(app => app.status === 'accepted').length / this.MAX_BETA_TESTERS * 100).toFixed(1)
    };

    console.log('\n📊 RAPPORT QUOTIDIEN BETA MATH4CHILD');
    console.log('=====================================');
    console.log(`📅 Date: ${today}`);
    console.log(`📧 Nouvelles candidatures aujourd'hui: ${stats.todayApplications}`);
    console.log(`📈 Total candidatures: ${stats.totalApplications} / ${this.TARGET_APPLICATIONS} (${stats.progressToTarget}%)`);
    console.log(`✅ Acceptées: ${stats.accepted} / ${this.MAX_BETA_TESTERS} (${stats.progressToMax}%)`);
    console.log(`⏳ En attente: ${stats.pending}`);
    console.log(`📋 Liste d'attente: ${stats.waitlist}`);
    console.log(`❌ Refusées: ${stats.rejected}`);
    
    this.analyzeSourcePerformance();
    this.generateRecommendations();
  }

  // Analyse des sources de candidatures
  private analyzeSourcePerformance(): void {
    const sourceStats = this.applications.reduce((acc, app) => {
      acc[app.source] = (acc[app.source] || 0) + 1;
      return acc;
    }, {} as Record<string, number>);

    console.log('\n📊 Performance par source:');
    Object.entries(sourceStats)
      .sort(([,a], [,b]) => b - a)
      .forEach(([source, count]) => {
        console.log(`  ${source}: ${count} candidatures`);
      });
  }

  // Génération d'ID unique
  private generateId(): string {
    return `BETA_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  // Sauvegarde des données
  private saveApplications(): void {
    // En production, sauvegarder dans une base de données
    console.log('💾 Données sauvegardées');
  }

  // Chargement des données
  private loadApplications(): void {
    // En production, charger depuis une base de données
    console.log('📂 Données chargées');
  }

  // Email automatique de confirmation
  private sendAutoReply(application: BetaApplication): void {
    const autoReplyTemplate = `
Objet: ✅ Candidature Beta Math4Child reçue - ${application.familyName}

Bonjour ${application.familyName},

Merci pour votre candidature au programme beta Math4Child !

📧 Votre candidature a été reçue et est en cours de traitement.
🕒 Délai de réponse : 24-48h maximum
📋 Numéro de candidature : ${application.id}

Notre équipe examine votre profil et vous contactera très prochainement.

Cordialement,
L'équipe Math4Child - GOTEST
gotesttech@gmail.com
    `;
    
    console.log(`📧 Email de confirmation envoyé à ${application.email}`);
  }

  // Email d'acceptation
  private sendAcceptanceEmail(application: BetaApplication): void {
    console.log(`🎉 Email d'acceptation envoyé à ${application.email}`);
  }

  // Recommandations intelligentes
  private generateRecommendations(): void {
    const acceptanceRate = this.applications.filter(app => app.status === 'accepted').length / this.applications.length;
    
    console.log('\n🎯 Recommandations:');
    
    if (acceptanceRate < 0.3) {
      console.log('  • Critères d\'acceptation peut-être trop stricts');
    }
    
    if (this.applications.length < this.TARGET_APPLICATIONS * 0.5) {
      console.log('  • Intensifier les efforts de recrutement');
      console.log('  • Cibler nouveaux canaux (YouTube, TikTok)');
    }
    
    const avgAge = this.applications.reduce((sum, app) => sum + app.childAge, 0) / this.applications.length;
    console.log(`  • Âge moyen des enfants: ${avgAge.toFixed(1)} ans`);
  }
}

// Utilisation
if (require.main === module) {
  const manager = new BetaApplicationManager();
  
  // Exemple d'ajout de candidature
  manager.addApplication({
    familyName: 'Famille Martin',
    email: 'martin@example.com',
    childAge: 8,
    childGrade: 'CE2',
    equipment: 'Multiple',
    source: 'Facebook',
    motivation: 'Mon enfant adore les maths et les jeux sur tablette'
  });
  
  // Génération du rapport
  manager.generateDailyReport();
}

export default BetaApplicationManager;
