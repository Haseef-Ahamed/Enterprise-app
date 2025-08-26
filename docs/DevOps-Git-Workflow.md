# DevOps Git Workflow - Uvexzon

## Why GitFlow?
- **Pros**: 
  - Clear separation of work (features, hotfixes, releases)
  - Stable main branch for production
  - Safe for large teams
- **Cons**:
  - Can feel heavy for small projects
  - Slower compared to trunk-based development

## Branching Strategy
- `main`: Production-ready code
- `develop`: Integration branch
- `feature/*`: New features
- `bugfix/*`: Bug fixes
- `hotfix/*`: Urgent production fixes
![alt text](branch.png)

## Pull Request (PR) Reviews
1. Developer creates PR → merge into `develop` or `main`.
2. Reviewer checks code, tests results, gives approval.
3. Merge allowed only after approval.

## Roles
- **Developer**: Works on `feature/*` or `bugfix/*` branches.
- **Reviewer**: Reviews and approves PRs.
- **Release Manager**: Creates releases, tags, and merges into `main`.
![alt text](rule_Assign.png.png)
![alt text](assign_permission.png)
![alt text](image.png)

## Release Process
- Run `./release.sh vX.Y.Z` to create a new release.
- Script generates a changelog and pushes tag.

![alt text](image-1.png)
![alt text](run_script.png)
![alt text](image-2.png)

## Push the Code spefic Branch. 
![alt text](image-3.png)
![alt text](image-4.png)

## Assign the pull request 


## CI/CD Integration
- **On Pull Request**: Run tests & linting.
- **On merge to develop**: Deploy to staging.
- **On release tag push**: Deploy to production.
