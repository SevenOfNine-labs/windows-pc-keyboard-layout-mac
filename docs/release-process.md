# GitBook Deployment Process (GitHub Pages)

This repository publishes documentation from `docs/` to GitHub Pages using a GitHub Actions workflow and GitBook-compatible structure.

## Workflow File

- `.github/workflows/gitbook-pages.yml`

GitBook/Honkit structure config:

- `docs/book.json` (maps to lowercase `readme.md` and `summary.md`)

## Trigger

The workflow runs on:

- push to `main` (including merged pull requests)
- manual dispatch (`workflow_dispatch`)

## Deployment Steps

1. Update docs in `docs/`.
2. Commit changes and merge into `main`.
3. Wait for `gitbook-pages` workflow to finish.
4. Read published docs on GitHub Pages.

## OpenPackage Publish in CI

OpenPackage publishing is documented in:

- [OpenPackage Publishing](openpackage-publishing.md)

The OpenPackage workflow runs independently from docs deployment and publishes the package to the OpenPackage registry.

## One-Time Repository Setup

In GitHub repository settings:

1. Open `Settings -> Pages`
2. Set source to `GitHub Actions`
3. Open `Settings -> Environments -> github-pages`
4. Under deployment branches/tags, allow branch `main` (or configure no restriction)

If this is restricted to tags only, deployments from `main` will be rejected by environment protection.

## Build Details

The workflow:

1. checks out repository content including Git LFS assets
2. runs `git lfs pull` to ensure binary image objects are available in CI
3. enables Yarn via Corepack (`corepack enable`)
4. prepares compatibility files (`README.md`, `SUMMARY.md`) from lowercase docs filenames at CI runtime
5. builds docs from `docs/` into repository-root `_site/` using `yarn dlx honkit build docs "$PWD/_site"` with `YARN_NODE_LINKER=node-modules`
6. normalizes generated HTML image paths from `../images/` to `images/` for GitHub Pages root compatibility
7. copies shared images from `images/` into `_site/images/`
8. deploys `_site/` to GitHub Pages

Published URL (project pages):

- `https://sevenofnine-ai.github.io/windows-pc-keyboard-layout-mac/`
