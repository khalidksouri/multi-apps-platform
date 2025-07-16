import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig(({ mode }) => ({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  build: {
    outDir: mode === 'mobile' ? 'dist' : 'dist-web',
    sourcemap: true
  },
  server: {
    host: '0.0.0.0',
    port: 3000
  }
}));
