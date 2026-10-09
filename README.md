# MaxMods

An independent, self-hosted fork of [Modrinth](https://github.com/modrinth/code).

The web frontend runs at https://mods.maxbain.es, with its own Labrinth API at https://api.mods.maxbain.es and S3-compatible storage at https://files.mods.maxbain.es. It does not share Modrinth accounts or project data.

## Deployment

`compose.coolify.yaml` defines the backend services and persistent volumes. Supply its password variables through Coolify; never commit deployment secrets. `Dockerfile.coolify` builds the frontend from source, using `nginx.frontend.conf` to block external advertising scripts without changing advertising or payment application code. Payment providers and paid hosting are unconfigured.

Email uses Resend SMTP (`smtp.resend.com:465`, TLS, username `resend`) and `noreply@hungrycampers.com`. The sender domain must pass Resend DNS verification before signup verification and password reset emails can be delivered. The Coolify scheduled task “MaxMods email queue” is installed disabled; enable it after sender DNS verification. Social login providers require separate OAuth applications and credentials. Automated Delphi malware scanning requires a separately operated Delphi service and is not configured; project approval is manual.

After the API has applied its migrations, load `catalog-bootstrap.sql` into PostgreSQL before building the frontend. It installs loaders, categories, and their mappings without the upstream fixture’s test users or destructive truncation; game versions are synchronized by Labrinth. Clear the tag cache after seeding an already-running instance.

A fresh instance has no projects. Upstream featured collection and payout metadata are not available on this instance; the existing deployment feature flag suppresses the resulting build-state banner. All other generated metadata should be checked during builds.

Persistent data lives in the PostgreSQL, Redis, Typesense, ClickHouse, Redpanda and RustFS volumes. Back up these volumes before updates. The dedicated search worker continuously indexes project and version changes. The backend image is pinned to an upstream digest; frontend source is maintained on the `selfhost` branch.

## Licensing and attribution

Original source retains its package licenses and copyright notices. See `COPYING.md` and package-specific license files. Restricted Modrinth logos and blog material have been replaced or removed. MaxMods is not affiliated with Rinth, Inc., Mojang or Microsoft.
