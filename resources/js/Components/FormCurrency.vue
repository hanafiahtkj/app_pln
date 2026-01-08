<script setup>
import { computed } from 'vue'
import { useCurrencyInput } from 'vue-currency-input'

const props = defineProps({
    modelValue: {
        type: [Number, null],
        default: null
    },
    label: {
        type: String,
        required: true
    },
    id: {
        type: String,
        default: null
    },
    required: {
        type: Boolean,
        default: false
    },
    error: {
        type: String,
        default: ''
    },
    placeholder: {
        type: String,
        default: null
    },
    disabled: {
        type: Boolean,
        default: false
    },
    help: {
        type: String,
        default: null
    },
    // Opsi tambahan untuk kustomisasi mata uang
    options: {
        type: Object,
        default: () => ({
            currency: 'IDR',
            currencyDisplay: 'hidden', // Kita sembunyikan karena pakai prefix manual
            hideCurrencySymbolOnFocus: true,
            hideGroupingSeparatorOnFocus: false,
            precision: 0,
            valueRange: { min: 0 }
        })
    }
})

const emit = defineEmits(['update:modelValue'])

// Integrasi vue-currency-input
const { inputRef } = useCurrencyInput(props.options)

const inputPlaceholder = computed(() => props.placeholder || props.label)
const inputId = computed(() => props.id || props.label.toLowerCase().replace(/\s+/g, '-'))

const inputClass = computed(
    () =>
        `w-full peer border rounded-lg text-sm transition-colors duration-200 placeholder-transparent pl-10 pr-3 py-2
    ${
        props.disabled
            ? 'cursor-not-allowed bg-[var(--color-surface-muted)] text-[var(--color-text-muted)] border-[var(--color-border)]'
            : props.error
            ? 'bg-[var(--color-surface)] text-[var(--color-text)] caret-red-500 border-red-500/50 focus:border-red-500 focus:ring-1 focus:ring-red-500/20'
            : 'bg-[var(--color-surface)] text-[var(--color-text)] caret-[var(--color-text)] border-[var(--color-border)] hover:border-[var(--color-border-strong)] focus:border-blue-500 focus:ring-1 focus:ring-blue-500/20'
    }`
)
</script>

<template>
    <div>
        <label :for="inputId" class="relative block">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none z-10">
                <span class="text-sm font-medium text-[var(--color-text-muted)]">Rp</span>
            </div>

            <input
                :id="inputId"
                ref="inputRef"
                type="text"
                :required="required"
                :disabled="disabled"
                :class="inputClass"
                :placeholder="inputPlaceholder"
                :aria-invalid="!!error"
                :aria-describedby="error ? `${inputId}-error` : undefined" />

            <span
                class="pointer-events-none absolute start-10 top-0 -translate-y-1/2 bg-[var(--color-surface)] px-1 text-xs font-medium text-[var(--color-text-muted)] transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:text-sm peer-focus:top-0 peer-focus:text-xs peer-focus:start-2.5">
                {{ label }}{{ required ? ' *' : '' }}
            </span>
        </label>

        <p v-if="error" :id="`${inputId}-error`" role="alert" class="mt-1 text-red-600 text-xs">
            {{ error }}
        </p>
        <p v-if="help && !error" class="mt-1 text-[var(--color-text-muted)] text-xs">
            {{ help }}
        </p>
    </div>
</template>
