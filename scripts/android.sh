#!/bin/bash
echo "🤖 Préparation Android..."
npm run build:mobile
npx cap sync android
npx cap open android
