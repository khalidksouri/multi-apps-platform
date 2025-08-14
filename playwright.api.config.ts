import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/api',
  timeout: 30000,
  retries: 1,
  use: {
    baseURL: 'http://localhost:3000/api',
  },
});
