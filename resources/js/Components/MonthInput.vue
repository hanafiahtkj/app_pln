<script setup>
import { ref, onMounted, watch, computed, onBeforeUnmount } from 'vue'
import flatpickr from 'flatpickr'
import 'flatpickr/dist/flatpickr.css'
import monthSelectPlugin from 'flatpickr/dist/plugins/monthSelect/index.js'
import 'flatpickr/dist/plugins/monthSelect/style.css'

const props = defineProps({
    modelValue: {
        type: String,
        default: ''
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
    disabled: {
        type: Boolean,
        default: false
    },
    help: {
        type: String,
        default: null
    }
})

const emit = defineEmits(['update:modelValue'])

const inputId = computed(() => props.id || props.label.toLowerCase().replace(/\s+/g, '-'))
const inputRef = ref(null)
const displayValue = ref('') // Teks yang dilihat user (misal: Januari 2026)
let fp = null

// Styling Tailwind yang konsisten dengan BaseInput Anda
const inputClass = computed(() => {
    return `w-full peer border rounded-lg text-sm transition-colors duration-200 px-3 py-2.5 outline-none block bg-[var(--color-surface)]
    ${
        props.disabled
            ? 'cursor-not-allowed opacity-60 border-[var(--color-border)]'
            : props.error
              ? 'text-[var(--color-text)] border-red-500 focus:border-red-500 focus:ring-1 focus:ring-red-500/20'
              : 'text-[var(--color-text)] border-[var(--color-border)] hover:border-[var(--color-border-strong)] focus:border-blue-500 focus:ring-1 focus:ring-blue-500/20'
    }`
})

onMounted(() => {
    fp = flatpickr(inputRef.value, {
        disableMobile: 'true',
        // Menggunakan plugin monthSelect untuk membatasi pilihan hanya bulan & tahun
        plugins: [
            new monthSelectPlugin({
                shorthand: true,
                dateFormat: 'Y-m-01', // Format yang dikirim ke v-model (database friendly)
                altFormat: 'F Y' // Format yang ditampilkan ke user
            })
        ],
        onChange: (selectedDates, dateStr, instance) => {
            emit('update:modelValue', dateStr)
            // Update teks tampilan secara manual saat user memilih
            if (selectedDates.length > 0) {
                displayValue.value = instance.formatDate(selectedDates[0], 'F Y')
            }
        }
    })

    // Sinkronisasi awal jika ada nilai saat komponen dimuat (Penting untuk mode EDIT)
    if (props.modelValue) {
        fp.setDate(props.modelValue, false)
        if (fp.selectedDates[0]) {
            displayValue.value = fp.formatDate(fp.selectedDates[0], 'F Y')
        }
    }
})

// Memantau perubahan modelValue dari luar (misal: data dari database tiba)
watch(
    () => props.modelValue,
    newVal => {
        if (fp) {
            if (newVal) {
                fp.setDate(newVal, false)
                if (fp.selectedDates[0]) {
                    displayValue.value = fp.formatDate(fp.selectedDates[0], 'F Y')
                }
            } else {
                displayValue.value = ''
                fp.clear()
            }
        }
    },
    { immediate: true }
)

onBeforeUnmount(() => {
    if (fp) fp.destroy()
})
</script>

<template>
    <div class="month-picker-wrapper w-full">
        <label :for="inputId" class="relative block cursor-pointer">
            <input
                :id="inputId"
                ref="inputRef"
                type="text"
                readonly
                :value="displayValue"
                :class="inputClass"
                placeholder=" "
                :disabled="disabled"
                class="cursor-pointer" />

            <span
                class="pointer-events-none absolute start-2.5 top-0 -translate-y-1/2 bg-[var(--color-surface)] px-1 text-xs font-medium text-[var(--color-text-muted)] transition-all peer-placeholder-shown:top-1/2 peer-placeholder-shown:text-sm peer-focus:top-0 peer-focus:text-xs z-10">
                {{ label }}{{ required ? ' *' : '' }}
            </span>
        </label>

        <p v-if="error" class="mt-1 text-red-600 text-xs">
            {{ error }}
        </p>

        <p v-if="help && !error" class="mt-1 text-[var(--color-text-muted)] text-xs">
            {{ help }}
        </p>
    </div>
</template>

<style>
/* Kostumisasi tampilan kalender agar serasi dengan UI Anda */
.flatpickr-calendar.monthSelect-theme-light {
    z-index: 9999 !important;
    background: var(--color-surface, #fff);
    border: 1px solid var(--color-border, #e5e7eb);
    box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
}

.flatpickr-monthSelect-month {
    border-radius: 6px !important;
}

.flatpickr-monthSelect-month.selected {
    background: #3b82f6 !important; /* Warna biru primer */
    color: white !important;
}

.flatpickr-monthSelect-month:hover {
    background: var(--color-surface-muted, #f3f4f6) !important;
}
</style>
