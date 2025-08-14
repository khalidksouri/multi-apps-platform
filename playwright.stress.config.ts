import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/stress',
  timeout: 60000,
  retries: 0,
  workers: 5,
  use: {
    baseURL: 'http://localhost:3000',
  },
});
