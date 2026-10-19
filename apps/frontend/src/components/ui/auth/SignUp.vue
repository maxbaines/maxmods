<template>
	<div
		class="universal-card flex w-full max-w-[27rem] flex-col gap-6 border border-solid border-surface-5 !p-6"
	>
		<div class="mx-auto text-center text-2xl font-semibold text-contrast">
			{{ formatMessage(messages.signUpWithTitle) }}
		</div>
		<section class="flex flex-col gap-2.5">
			<label for="email" hidden>{{ formatMessage(commonMessages.emailLabel) }}</label>
			<Input
				id="email"
				v-model="emailModel"
				:icon="MailIcon"
				type="email"
				autocomplete="email"
				:placeholder="formatMessage(commonMessages.emailLabel)"
				wrapper-class="w-full"
			/>

			<label for="password" hidden>{{ formatMessage(commonMessages.passwordLabel) }}</label>
			<Input
				id="password"
				v-model="passwordModel"
				:icon="KeyIcon"
				type="password"
				autocomplete="new-password"
				:placeholder="formatMessage(commonMessages.passwordLabel)"
				wrapper-class="w-full"
			/>

			<Button
				type="colored"
				color="brand"
				class="!w-full"
				:disabled="!emailModel || !passwordModel"
				@click="onContinueWithEmail()"
			>
				{{ formatMessage(messages.continueWithEmail) }} <RightArrowIcon />
			</Button>

			<p v-if="!routeQuery.launcher" class="m-0 text-center">
				<IntlFormatted :message-id="messages.legalDisclaimer">
					<template #terms-link="{ children }">
						<NuxtLink to="/legal/terms" class="text-link">
							<component :is="() => children" />
						</NuxtLink>
					</template>
					<template #privacy-policy-link="{ children }">
						<NuxtLink to="/legal/privacy" class="text-link">
							<component :is="() => children" />
						</NuxtLink>
					</template>
				</IntlFormatted>
			</p>

			<div class="mx-auto flex flex-wrap items-center justify-start gap-2 text-center">
				{{ formatMessage(messages.alreadyHaveAccountLabel) }}
				<NuxtLink
					class="mr-1 text-link"
					:to="{
						path: '/auth/sign-in',
						query: routeQuery,
					}"
				>
					{{ formatMessage(commonMessages.signInButton) }}
				</NuxtLink>
			</div>
		</section>
	</div>
</template>

<script setup lang="ts">
import { KeyIcon, MailIcon, RightArrowIcon } from '@modrinth/assets'
import {
	Button,
	commonMessages,
	defineMessages,
	Input,
	IntlFormatted,
	useVIntl,
} from '@modrinth/ui'
import type { LocationQuery } from 'vue-router'

interface Props {
	routeQuery?: LocationQuery
	onContinueWithEmail?: () => void
}

const {
	routeQuery = {},
	onContinueWithEmail = () => {},
} = defineProps<Props>()

const emailModel = defineModel<string>('email', { default: '' })
const passwordModel = defineModel<string>('password', { default: '' })
const { formatMessage } = useVIntl()

const messages = defineMessages({
	signUpWithTitle: {
		id: 'auth.sign-up.title.sign-up-with',
		defaultMessage: 'Create an Account',
	},
	legalDisclaimer: {
		id: 'auth.sign-up.legal-dislaimer',
		defaultMessage:
			"By creating an account, you agree to Modsynth's <terms-link>Terms</terms-link> and <privacy-policy-link>Privacy Policy</privacy-policy-link>.",
	},
	alreadyHaveAccountLabel: {
		id: 'auth.sign-up.sign-in-option.title',
		defaultMessage: 'Already have an account?',
	},
	continueWithEmail: {
		id: 'auth.sign-up.continue-with-email',
		defaultMessage: 'Continue with Email',
	},
})
</script>
