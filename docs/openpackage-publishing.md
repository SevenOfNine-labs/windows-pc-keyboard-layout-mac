# OpenPackage Publishing

This repository can be published to the OpenPackage registry from CI.

Official OpenPackage docs:

- https://openpackage.dev/docs
- https://openpackage.dev/docs/push
- https://openpackage.dev/docs/configure

## What Gets Published

The package is defined by `openpackage.yml` and uses `root/` as the install payload.
CI publishes from a clean staging directory that contains:

- `openpackage.yml`
- generated compatibility `package.yml` (mirrored from `openpackage.yml`)
- `root/`
- `README.md`

Package naming requirement:

- Use a scoped package name in `openpackage.yml` (for example `@sevenofnine/windows-pc-keyboard-layout-mac`)
- Unscoped names can trigger interactive scope prompts, which breaks CI publish

## CI Workflow

Workflow file:

- `.github/workflows/openpackage-publish.yml`

Trigger:

- GitHub release published
- manual dispatch

The workflow does the following:

1. Installs `opkg`
2. Validates release tag version (`vX.Y.Z`) against `openpackage.yml` `version`
3. Creates a clean staging directory for publish (manifest + payload only)
4. Creates a temporary `package.yml` mirror from `openpackage.yml` for registry compatibility
5. Publishes to OpenPackage using API key auth

## Required GitHub Secret

Add this repository secret:

- `OPENPACKAGE_API_KEY`

Create the key in your OpenPackage account and save it in GitHub Secrets.

## Release Access Control (GitHub)

To ensure only `SevenOfNine-ai` can create and publish releases, configure GitHub with layered controls:

1. Repository access:
   Set all other collaborators/teams to `Read` (or remove them). Keep release-capable permissions only for `SevenOfNine-ai`.
2. Tag protection (Rulesets):
   Create a tag ruleset for `v*` tags and restrict tag creation/update/deletion so only `SevenOfNine-ai` can bypass.
3. Branch protection:
   Protect the default branch and require pull requests + `CODEOWNERS` review.
4. Environment protection:
   Use environment `release` with required reviewer `SevenOfNine-ai`.
5. Secret scope:
   Store `OPENPACKAGE_API_KEY` in the `release` environment (preferred) instead of a broad repo secret.

This repository also enforces actor validation in workflow CI, so non-authorized actors fail publish at runtime.

## Release Convention

For release-triggered publish, use GitHub tag format:

- `v1.0.3`

and make sure:

- `openpackage.yml` contains the same package version (without `v`), for example `1.0.3`

Version/tag mapping:

- GitHub release tag: `v1.0.3`
- OpenPackage version in manifest: `1.0.3`
- OpenPackage install command: `opkg install @sevenofnine/windows-pc-keyboard-layout-mac@1.0.3`

## Local Manual Publish

If you publish manually from your machine:

```bash
opkg login
opkg publish
```

or with explicit key:

```bash
opkg publish --api-key "<your-api-key>"
```

For parity with CI (recommended), publish from a clean staging directory:

```bash
STAGE_DIR="$(mktemp -d)"
cp openpackage.yml "$STAGE_DIR/openpackage.yml"
cp openpackage.yml "$STAGE_DIR/package.yml"
cp README.md "$STAGE_DIR/README.md"
cp -R root "$STAGE_DIR/root"
(cd "$STAGE_DIR" && opkg publish --api-key "<your-api-key>")
rm -rf "$STAGE_DIR"
```

## Compatibility Note

OpenPackage docs may show `opkg push` in newer CLI versions. This repository workflow supports both command styles and uses whichever is available.

If the registry returns `Invalid package.yml file`, this repo's CI now mitigates that by generating `package.yml` from `openpackage.yml` right before publish.
