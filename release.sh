#!/bin/bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./release.sh vX.Y.Z"
  exit 1
fi

# Generate changelog
echo "Generating changelog..."
git log $(git describe --tags --abbrev=0 2>/dev/null || echo "")..HEAD --pretty=format:"- %s" > CHANGELOG.md

# Commit changelog
git add CHANGELOG.md
git commit -m "Update changelog for $VERSION" || echo "No changes to commit."

# Tag release
git tag -a "$VERSION" -m "Release $VERSION"
git push origin main --tags

echo "✅ Release $VERSION completed!"
