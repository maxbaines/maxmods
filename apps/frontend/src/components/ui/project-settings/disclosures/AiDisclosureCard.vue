<script setup lang="ts">
import { SparklesIcon } from '@modrinth/assets'
import {
	Checkbox,
	commonMessages,
	defineMessages,
	disclosureAiUsageMessages,
	IntlFormatted,
	normalizeChildren,
	SettingsFormGroup,
	Textarea,
	useVIntl,
} from '@modrinth/ui'

import DisclosureToggleCard from './DisclosureToggleCard.vue'
import type { AiDisclosure, AiUsage, DisclosureCardMetaProps, DisclosureLockStatus } from './types'

const model = defineModel<AiDisclosure>({ required: true })

const props = defineProps<DisclosureCardMetaProps>()

const emit = defineEmits<{
	setLockStatus: [status: DisclosureLockStatus]
}>()

const { formatMessage } = useVIntl()

const AI_USES: AiUsage[] = ['code', 'assets', 'text']

const messages = defineMessages({
	title: {
		id: 'project.settings.disclosures.ai.title',
		defaultMessage: 'Contains AI-generated content',
	},
	description: {
		id: 'project.settings.disclosures.ai.modsynth-description',
		defaultMessage: `Required for every published project on Modsynth. Your core code, functionality, or playable assets must be primarily or entirely AI-generated.`,
	},
	description2: {
		id: 'project.settings.disclosures.ai.modsynth-description.2',
		defaultMessage: `Select every applicable type of AI-generated content. In your project description, explain what AI generated, name the tools or models where known, and describe significant human contributions.`,
	},
	stillUnsure: {
		id: 'project.settings.disclosures.ai.modsynth-rules',
		defaultMessage:
			"See section 6 of <rules>Modsynth's Content Rules</rules> for eligibility and disclosure requirements.",
	},
	typesDescription: {
		id: 'project.settings.disclosures.ai.types-description',
		defaultMessage: 'What types of content have been generated with AI?',
	},
	notePlaceholder: {
		id: 'project.settings.disclosures.ai.modsynth-note-placeholder',
		defaultMessage:
			'e.g. AI generated the core mod code and textures; I reviewed, tested, and fixed compatibility issues.',
	},
})

function hasUse(use: AiUsage): boolean {
	return model.value.uses.includes(use)
}

function setUse(use: AiUsage, enabled: boolean) {
	if (enabled) {
		if (!model.value.uses.includes(use)) {
			model.value.uses = [...model.value.uses, use]
		}
		return
	}
	model.value.uses = model.value.uses.filter((entry) => entry !== use)
}
</script>

<template>
	<DisclosureToggleCard
		v-bind="props"
		v-model="model.enabled"
		:icon="SparklesIcon"
		:title="formatMessage(messages.title)"
		:description="formatMessage(messages.description)"
		info-link="/legal/rules#generative-ai"
		@set-lock-status="emit('setLockStatus', $event)"
	>
		<p>
			{{ formatMessage(messages.description2) }}
		</p>
		<p class="text-secondary">
			<IntlFormatted :message-id="messages.stillUnsure">
				<template #rules="{ children }">
					<nuxt-link
						to="/legal/rules#generative-ai"
						target="_blank"
						class="smart-clickable:allow-pointer-events underline hover:text-primary"
					>
						<component :is="() => normalizeChildren(children)" />
					</nuxt-link>
				</template>
			</IntlFormatted>
		</p>
		<template #expanded>
			<SettingsFormGroup :title="formatMessage(messages.typesDescription)">
				<div class="flex flex-col gap-2">
					<Checkbox
						v-for="use in AI_USES"
						:key="use"
						:model-value="hasUse(use)"
						:disabled="disabled"
						@update:model-value="(enabled) => setUse(use, enabled)"
					>
						{{ formatMessage(disclosureAiUsageMessages[use]) }}
					</Checkbox>
				</div>
			</SettingsFormGroup>
			<SettingsFormGroup
				:title="formatMessage(commonMessages.explanationLabel)"
				title-for="ai-disclosure-note"
				optional
			>
				<Textarea
					id="ai-disclosure-note"
					v-model="model.note"
					:rows="3"
					class="max-w-[40rem]"
					:disabled="disabled"
					:placeholder="formatMessage(messages.notePlaceholder)"
				/>
			</SettingsFormGroup>
		</template>
	</DisclosureToggleCard>
</template>
