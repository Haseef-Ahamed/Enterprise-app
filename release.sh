#!/bin/bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./release.sh vX.Y.Z"
  exit 1
fi

# Ensure repo is clean
if [ -n "$(git status --porcelain)" ]; then
  echo "❌ Working directory not clean. Commit or stash changes first."
  exit 1
fi

# Fetch latest tags
git fetch --tags

# Generate changelog
echo "📝 Generating changelog..."
git log $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD \
  --pretty=format:"- %s" > CHANGELOG.md

# Commit changelog
git add CHANGELOG.md
git commit -m "chore(release): update changelog for $VERSION" || echo "No changes to commit."

# Tag release
git tag -a "$VERSION" -m "Release $VERSION"

# Push branch + tag
git push origin main
git push origin "$VERSION"

echo "✅ Release $VERSION completed!"
