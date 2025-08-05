#!/bin/bash
echo "📝 Configuration du commit pour la mise à jour email..."
git add .
git status
echo ""
echo "🤖 Voulez-vous commiter automatiquement ? (y/n)"
read -r response
if [[ "$response" =~ ^[Yy]$ ]]; then
    git commit -m "feat: update GOTEST contact email to gotesttech@gmail.com

- Replace khalid_ksouri@yahoo.fr with gotesttech@gmail.com across all files
- Update GOTEST configuration
- Update Stripe configuration
- Update mobile deployment documentation
- Update README and build status files"
    echo "✅ Commit créé avec succès!"
else
    echo "📝 Commit annulé. Vous pouvez commiter manuellement plus tard."
fi
