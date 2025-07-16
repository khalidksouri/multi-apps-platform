import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig(({ mode }) => ({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@shared': resolve(__dirname, 'src/shared'),
      '@mobile': resolve(__dirname, 'src/mobile'),
      '@web': resolve(__dirname, 'src/web'),
    },
  },
  build: {
    outDir: mode === 'mobile' ? 'dist' : 'dist-web',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom', 'react-router-dom'],
          capacitor: ['@capacitor/core', '@capacitor/app']
        }
      }
    }
  },
  server: {
    host: '0.0.0.0',
    port: 3000,
    hmr: {
      host: 'localhost'
    }
  },
  define: {
    __IS_MOBILE__: mode === 'mobile',
    __DEV__: mode === 'development'
  },
  optimizeDeps: {
    include: ['@capacitor/core', '@capacitor/app']
  }
}));
