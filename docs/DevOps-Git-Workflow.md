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
<<<<<<< HEAD
![alt text](image-1.png)

=======
![alt text](branch.png)
>>>>>>> a4a894c206bec2111f7f1b5ada344bd265e0e772

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
- **Assign the merge the source code from devevlop to main branch.**
- **then add the title to identify the reviwer, why the request reaised for approval**
- **Select the who is the review the code and documentation**
![alt text](image-5.png)

## How to Approval this Pull request from reviewer site
![alt text](image-6.png)

![alt text](image-7.png)

**Check the Files and give the review**

![alt text](image-8.png)

![alt text](image-9.png)

**Approved by reviewer so we can merge the all document**
![alt text](image-10.png)

![alt text](image-11.png)

![alt text](image-12.png)

**Verify the Merge is perfectly worked**
![alt text](image-13.png)


## CI/CD Integration
- **On Pull Request**: Run tests & linting.
- **On merge to develop**: Deploy to staging.
- **On release tag push**: Deploy to production.

<<<<<<< HEAD


[def]: image.png
=======
![alt text](image-14.png)

![alt text](image-15.png)

![alt text](image-16.png)

![alt text](image-17.png)

HI Good Evening... Everyone



>>>>>>> a4a894c206bec2111f7f1b5ada344bd265e0e772
