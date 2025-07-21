// ===================================================================
// FIXTURES PLAYWRIGHT POUR MATH4CHILD
// Fixtures personnalisées et helpers
// ===================================================================

import { test as base } from '@playwright/test';
import { Math4ChildTestHelper } from './test-utils';
import { TEST_DATA } from './test-data';

type Math4ChildFixtures = {
  math4childApp: Math4ChildTestHelper;
  newUser: Math4ChildTestHelper;
  experiencedUser: Math4ChildTestHelper;
  freeUserAtLimit: Math4ChildTestHelper;
};

export const test = base.extend<Math4ChildFixtures>({
  // Fixture de base pour l'application
  math4childApp: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un nouvel utilisateur
  newUser: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.newUser);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un utilisateur expérimenté
  experiencedUser: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.intermediateUser);
    await helper.navigateToApp();
    await use(helper);
  },

  // Fixture pour un utilisateur ayant atteint la limite gratuite
  freeUserAtLimit: async ({ page }, use) => {
    const helper = new Math4ChildTestHelper(page);
    await helper.clearUserData();
    await helper.setUserProgress(TEST_DATA.progressions.freeUserLimitReached);
    await helper.navigateToApp();
    await use(helper);
  }
});

export { expect } from '@playwright/test';
