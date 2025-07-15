// Logger simple sans dépendances externes
interface LogLevel {
  ERROR: 'error';
  WARN: 'warn';
  INFO: 'info';
  DEBUG: 'debug';
}

const LOG_LEVELS: LogLevel = {
  ERROR: 'error',
  WARN: 'warn',
  INFO: 'info',
  DEBUG: 'debug'
};

class SimpleLogger {
  private logLevel: string;
  
  constructor() {
    this.logLevel = process.env.LOG_LEVEL || 'info';
  }
  
  private shouldLog(level: string): boolean {
    const levels = ['error', 'warn', 'info', 'debug'];
    return levels.indexOf(level) <= levels.indexOf(this.logLevel);
  }
  
  private formatMessage(level: string, message: string, meta?: any): string {
    const timestamp = new Date().toISOString();
    const metaStr = meta ? ` ${JSON.stringify(meta)}` : '';
    return `[${timestamp}] ${level.toUpperCase()}: ${message}${metaStr}`;
  }
  
  private writeLog(level: string, message: string, meta?: any): void {
    if (!this.shouldLog(level)) return;
    
    const formattedMessage = this.formatMessage(level, message, meta);
    
    // Écrire dans la console
    console.log(formattedMessage);
    
    // Écrire dans un fichier (si possible)
    if (typeof require !== 'undefined') {
      try {
        const fs = require('fs');
        const path = require('path');
        
        const logDir = path.join(process.cwd(), 'logs');
        if (!fs.existsSync(logDir)) {
          fs.mkdirSync(logDir, { recursive: true });
        }
        
        const logFile = path.join(logDir, 'app.log');
        fs.appendFileSync(logFile, formattedMessage + '\n');
      } catch (error) {
        // Ignore les erreurs de fichier
      }
    }
  }
  
  error(message: string, meta?: any): void {
    this.writeLog(LOG_LEVELS.ERROR, message, meta);
  }
  
  warn(message: string, meta?: any): void {
    this.writeLog(LOG_LEVELS.WARN, message, meta);
  }
  
  info(message: string, meta?: any): void {
    this.writeLog(LOG_LEVELS.INFO, message, meta);
  }
  
  debug(message: string, meta?: any): void {
    this.writeLog(LOG_LEVELS.DEBUG, message, meta);
  }
}

export const logger = new SimpleLogger();

// Fonctions utilitaires
export const logError = (message: string, error?: Error, meta?: any) => {
  logger.error(message, { error: error?.message, stack: error?.stack, ...meta });
};

export const logInfo = (message: string, meta?: any) => {
  logger.info(message, meta);
};

export const logWarning = (message: string, meta?: any) => {
  logger.warn(message, meta);
};

export const logDebug = (message: string, meta?: any) => {
  logger.debug(message, meta);
};

export default logger;
