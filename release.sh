#!/bin/bash
set -e

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: ./release.sh vX.Y.Z"
  exit 1
fi

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "❌ Tag $VERSION already exists. Please use a different version."
  exit 1
fi

# Ensure repo is clean (allow for CI environment)
if [ -z "$CI" ] && [ -n "$(git status --porcelain)" ]; then
  echo "❌ Working directory not clean. Commit or stash changes first."
  exit 1
fi

# Fetch latest tags and branches
git fetch --tags --force
git fetch origin --force

# Determine current branch (handles detached HEAD in CI)
if [ -n "$GITHUB_HEAD_REF" ]; then
  CURRENT_BRANCH="$GITHUB_HEAD_REF"
elif [ -n "$GITHUB_REF_NAME" ]; then
  CURRENT_BRANCH="$GITHUB_REF_NAME"
else
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
fi

# If we're in detached HEAD state (common in CI), try to check out the branch
if [ "$CURRENT_BRANCH" = "HEAD" ]; then
  if [ -n "$GITHUB_REF_NAME" ]; then
    git checkout -b temp-release-branch
    CURRENT_BRANCH="temp-release-branch"
  else
    echo "❌ Cannot determine current branch"
    exit 1
  fi
fi

# Get the latest tag for changelog generation
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

echo "📝 Generating changelog for version $VERSION..."

# Generate changelog from commit messages since last tag
if [ -z "$LATEST_TAG" ]; then
  # First release - get all commits
  echo "# Changelog" > CHANGELOG.md
  echo "" >> CHANGELOG.md
  echo "## $VERSION" >> CHANGELOG.md
  echo "" >> CHANGELOG.md
  git log --pretty=format:"- %s (%h)" >> CHANGELOG.md
else
  # Subsequent releases - get commits since last tag
  echo "# Changelog" > CHANGELOG.md
  echo "" >> CHANGELOG.md
  echo "## $VERSION" >> CHANGELOG.md
  echo "" >> CHANGELOG.md
  git log ${LATEST_TAG}..HEAD --pretty=format:"- %s (%h)" >> CHANGELOG.md
  echo "" >> CHANGELOG.md
  # Append previous changelog entries (skip the first two lines which are headers)
  tail -n +3 CHANGELOG.md > CHANGELOG_TEMP.md
  cat CHANGELOG_TEMP.md >> CHANGELOG.md
  rm -f CHANGELOG_TEMP.md
fi

# Commit changelog
git add CHANGELOG.md
git commit -m "chore(release): update changelog for $VERSION" || echo "No changes to commit."

# Tag release (annotated tag)
git tag -a "$VERSION" -m "Release $VERSION"

echo "✅ Release $VERSION prepared on branch $CURRENT_BRANCH!"
echo "Changes will be pushed to remote..."

# #!/bin/bash
# set -e

# VERSION=$1

# if [ -z "$VERSION" ]; then
#   echo "Usage: ./release.sh vX.Y.Z"
#   exit 1
# fi

# # Ensure repo is clean (allow for CI environment)
# if [ -z "$CI" ] && [ -n "$(git status --porcelain)" ]; then
#   echo "❌ Working directory not clean. Commit or stash changes first."
#   exit 1
# fi

# # Fetch latest tags and branches
# git fetch --tags --force
# git fetch origin --force

# # Determine current branch (handles detached HEAD in CI)
# if [ -n "$GITHUB_HEAD_REF" ]; then
#   CURRENT_BRANCH="$GITHUB_HEAD_REF"
# elif [ -n "$GITHUB_REF_NAME" ]; then
#   CURRENT_BRANCH="$GITHUB_REF_NAME"
# else
#   CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
# fi

# # If we're in detached HEAD state (common in CI), try to check out the branch
# if [ "$CURRENT_BRANCH" = "HEAD" ]; then
#   if [ -n "$GITHUB_REF_NAME" ]; then
#     git checkout -b temp-release-branch
#     CURRENT_BRANCH="temp-release-branch"
#   else
#     echo "❌ Cannot determine current branch"
#     exit 1
#   fi
# fi

# # Get the latest tag for changelog generation
# LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")

# echo "📝 Generating changelog for version $VERSION..."

# # Generate changelog from commit messages since last tag
# if [ -z "$LATEST_TAG" ]; then
#   # First release - get all commits
#   git log --pretty=format:"- %s (%h)" > CHANGELOG.md
#   echo -e "# Changelog\n\n## $VERSION\n\n$(cat CHANGELOG.md)" > CHANGELOG.md
# else
#   # Subsequent releases - get commits since last tag
#   git log ${LATEST_TAG}..HEAD --pretty=format:"- %s (%h)" > CHANGELOG_NEW.md
#   echo -e "# Changelog\n\n## $VERSION\n\n$(cat CHANGELOG_NEW.md)\n\n$(tail -n +2 CHANGELOG.md)" > CHANGELOG.md
#   rm -f CHANGELOG_NEW.md
# fi

# # Commit changelog
# git add CHANGELOG.md
# git commit -m "chore(release): update changelog for $VERSION" || echo "No changes to commit."

# # Tag release (annotated tag)
# git tag -a "$VERSION" -m "Release $VERSION"

# echo "✅ Release $VERSION prepared on branch $CURRENT_BRANCH!"
# echo "Changes will be pushed to remote..."