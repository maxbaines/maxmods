-- Point notification rendering at this instance; no messages are sent by this script.
BEGIN;
UPDATE notifications_templates
SET body_fetch_url = regexp_replace(body_fetch_url,
    '^https://modrinth.com/(email/|_internal/templates/email/)',
    'https://mods.maxbain.es/_internal/templates/email/'),
    subject_line = replace(subject_line, 'Modrinth', 'MaxMods'),
    plaintext_fallback = replace(plaintext_fallback, 'Modrinth', 'MaxMods');
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/auth-provider-added', '/auth-method-added') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/auth-provider-added';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/auth-provider-removed', '/auth-method-removed') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/auth-provider-removed';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/two-factor-enabled', '/two-factor-added') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/two-factor-enabled';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/report-updated', '/report-status-updated') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/report-updated';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/project-approved', '/project-status-approved') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/project-approved';
UPDATE notifications_templates SET body_fetch_url = replace(body_fetch_url, '/project-ownership-transferred', '/project-transferred') WHERE body_fetch_url = 'https://mods.maxbain.es/_internal/templates/email/project-ownership-transferred';
COMMIT;
