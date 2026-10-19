-- Point notification rendering at this instance; no messages are sent by this script.
BEGIN;
UPDATE notifications_templates
SET body_fetch_url = regexp_replace(body_fetch_url,
    '^https://(modrinth\.com|mods\.maxbain\.es|modsynth\.app)/(email/|_internal/templates/email/)',
    'https://modsynth.app/_internal/templates/email/'),
    subject_line = replace(replace(subject_line, 'Modrinth', 'Modsynth'), 'MaxMods', 'Modsynth'),
    plaintext_fallback = replace(replace(plaintext_fallback, 'Modrinth', 'Modsynth'), 'MaxMods', 'Modsynth');
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/auth-provider-added', '/auth-method-added') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/auth-provider-added';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/auth-provider-removed', '/auth-method-removed') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/auth-provider-removed';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/two-factor-enabled', '/two-factor-added') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/two-factor-enabled';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/report-updated', '/report-status-updated') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/report-updated';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/project-approved', '/project-status-approved') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/project-approved';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/project-ownership-transferred', '/project-transferred') WHERE body_fetch_url = 'https://modsynth.app/_internal/templates/email/project-ownership-transferred';
COMMIT;
