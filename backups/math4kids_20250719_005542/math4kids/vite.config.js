import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3001,
    host: true,
    open: true
  },
  preview: {
    port: 3001,
    host: true
  },
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/setupTests.js',
    css: true
  },
  define: {
    global: 'globalThis',
  },
  build: {
    outDir: 'dist',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          icons: ['lucide-react']
        }
      }
    }
  },
  // Configuration optimisée pour Node.js v18
  optimizeDeps: {
    force: true,
    include: ['react', 'react-dom', 'lucide-react']
  },
  esbuild: {
    target: 'es2020'
  }
})
