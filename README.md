# Modsynth

An independent, self-hosted fork of [Modrinth](https://github.com/modrinth/code).

The web frontend is configured for https://modsynth.app, with its own Labrinth API at https://api.modsynth.app and S3-compatible storage at https://files.modsynth.app. It does not share Modrinth accounts or project data. The original https://mods.maxbain.es hostname is retained as a compatibility alias.

## Deployment

`compose.coolify.yaml` defines the backend services and persistent volumes. Supply its password variables through Coolify; never commit deployment secrets. `Dockerfile.coolify` builds the frontend from source, using `nginx.frontend.conf` to block external advertising scripts without changing advertising or payment application code. Payment providers and paid hosting are unconfigured.

Apply `email-bootstrap.sql` after migrations to point notification templates at this instance (including renamed upstream templates). Email uses Resend SMTP (`smtp.resend.com:587`, required STARTTLS, username `resend`) with `Modsynth <noreply@modsynth.app>`. The existing Resend key is kept in the private Coolify service configuration. Resend verified `modsynth.app` on October 19, 2026, and a test message from the new sender reached its delivered event. The Coolify scheduled task “Modsynth email queue” is enabled to process transactional notifications; its mail worker passed an SMTP connection check. Application signup and password-reset email requests were tested against the Resend test inbox. Port 465 authenticated but timed out during app delivery; port 587 with required STARTTLS resolved that failure. Social login providers require separate OAuth applications and credentials. Automated Delphi malware scanning requires a separately operated Delphi service and is not configured; project approval is manual.

After the API has applied its migrations, load `catalog-bootstrap.sql` into PostgreSQL before building the frontend. It installs loaders, categories, and their mappings without the upstream fixture’s test users or destructive truncation; game versions are synchronized by Labrinth. Clear the tag cache after seeding an already-running instance.

A fresh instance has no projects. Upstream featured collection and payout metadata are not available on this instance; the existing deployment feature flag suppresses the resulting build-state banner. All other generated metadata should be checked during builds.

Persistent data lives in the PostgreSQL, Redis, Typesense, ClickHouse, Redpanda and RustFS volumes. Back up these volumes before updates. The dedicated search worker continuously indexes project and version changes. The backend image is pinned to an upstream digest; frontend source is maintained on the `selfhost` branch.

## Licensing and attribution

Original source retains its package licenses and copyright notices. See `COPYING.md` and package-specific license files. Restricted Modrinth logos and blog material have been replaced or removed. Modsynth is not affiliated with Rinth, Inc., Mojang or Microsoft.

## Modsynth domain cutover

Recovered from the October 9, 2026 deployment conversation (`01a12108-a72c-77b2-8794-0025afe8cf31`). Coolify runs at https://maxbain.es on `162.55.27.173`. The website application is `ksg6gvtrbac7rw3ng7l6pni1`; the backend service is `1vcxdavfafv19behfcs4takj`. Source is https://github.com/maxbaines/maxmods on the `selfhost` branch. Administrator credentials remain in the private workspace credential file, never in this repository.

The October 19, 2026 cutover points `modsynth.app`, `api.modsynth.app`, and `files.modsynth.app` to `162.55.27.173`. The new domains are registered alongside the existing domains in Coolify, and the live backend uses the site/CDN/callback settings from `compose.coolify.yaml`. `email-bootstrap.sql` has been applied. HTTPS, administrator sign-in, project search, and all 10 existing download URLs were verified; old and new file URLs return matching content lengths and ETags. The old website remains an alias.

The homepage introduces Modsynth as “The place for AI Mods”. The abstract mark and brand palette use `#6750ed`, with `#a08cff` accents for dark themes; status colors remain semantic. Web and email links use the brand palette.

Keep the old API and file hosts working: existing release URLs and embedded modpack manifests use them. Database users, database names, storage access IDs, package names, and file formats retain their existing identifiers to preserve data and compatibility. Preserve all upstream license and copyright notices. The support page directs project reports to the existing report flow. A direct support/legal contact address still needs to be supplied by the operator; upstream support addresses and mailing addresses are not used for Modsynth.
