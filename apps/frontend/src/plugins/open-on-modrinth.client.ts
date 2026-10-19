import { moderationSettings } from '@modrinth/moderation'

import {
	notifyCopied,
	useModerationKeybinds,
	useModerationSettings,
} from '~/composables/moderation.ts'

function getAlternativeOrigin(hostname: string | null | undefined): string | null {
	const trimmed = hostname?.trim()
	if (!trimmed) {
		return null
	}

	try {
		const url = trimmed.includes('://') ? new URL(trimmed) : new URL(`http://${trimmed}`)
		if (url.protocol !== 'http:' && url.protocol !== 'https:') {
			return null
		}
		return url.origin
	} catch {
		return null
	}
}

export default defineNuxtPlugin(() => {
	const config = useRuntimeConfig()
	const keybinds = useModerationKeybinds()
	const settings = useModerationSettings()

	window.addEventListener('keydown', (event) => {
		if (event.repeat) {
			return
		}

		const pathAndSearch = `${window.location.pathname}${window.location.search}`
		const alternativeOrigin = getAlternativeOrigin(
			settings.value.get(moderationSettings.General.AlternativeHostname),
		)

		keybinds.value.handle(event, {
			scope: 'global',
			officialUrl: `${config.public.siteUrl}${pathAndSearch}`,
			alternativeUrl: alternativeOrigin ? `${alternativeOrigin}${pathAndSearch}` : '',
			notifyCopied,
		})
	})
})
