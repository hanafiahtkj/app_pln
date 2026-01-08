<script setup>
import { computed } from 'vue'

const props = defineProps({
    modelValue: String,
    label: String,
    error: String,
    placeholder: {
        type: String,
        default: 'Pilih File'
    }
})

const emit = defineEmits(['update:modelValue'])

const fileName = computed(() => {
    if (!props.modelValue) return ''
    // Mengambil nama file dari URL
    return props.modelValue.split('/').pop()
})

const openFileManager = () => {
    const route_prefix = '/filemanager'
    window.open(route_prefix + '?type=Files', 'FileManager', 'width=900,height=600')

    window.SetUrl = items => {
        const file = Array.isArray(items) ? items[0] : items
        emit('update:modelValue', file.url)
    }
}

// Fitur Baru: Melihat File
const viewFile = () => {
    if (props.modelValue) {
        window.open(props.modelValue, '_blank')
    }
}

const clearFile = () => {
    emit('update:modelValue', null)
}
</script>

<template>
    <div class="relative flex flex-col w-full group">
        <label
            v-if="label"
            class="absolute -top-2 left-3 px-1 bg-[var(--color-surface)] text-xs font-semibold tracking-wider transition-colors z-10"
            :class="[
                error ? 'text-red-500' : 'text-[var(--color-text-muted)] group-hover:text-sky-500'
            ]">
            {{ label }}
        </label>

        <div
            @click="openFileManager"
            class="relative flex items-center justify-between rounded-lg border-2 border-dashed transition-all cursor-pointer bg-transparent"
            :class="[
                modelValue
                    ? 'border-sky-500 bg-sky-50/10 dark:bg-sky-900/10'
                    : 'border-gray-300 dark:border-gray-600 hover:border-sky-400',
                error ? 'border-red-500 shadow-sm shadow-red-100' : ''
            ]"
            style="min-height: 36px; padding: 5px 12px">
            <div class="flex items-center gap-3 min-w-0">
                <div
                    class="flex h-5 w-5 flex-shrink-0 items-center justify-center rounded-full transition-colors"
                    :class="
                        modelValue
                            ? 'bg-sky-500 text-white'
                            : 'bg-gray-100 dark:bg-gray-800 text-gray-400'
                    ">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            v-if="!modelValue"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2.5"
                            d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12" />
                        <path
                            v-else
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2.5"
                            d="M5 13l4 4L19 7" />
                    </svg>
                </div>

                <div class="min-w-0">
                    <p
                        class="text-[13px] font-medium truncate"
                        :class="
                            modelValue
                                ? 'text-sky-700 dark:text-sky-300'
                                : 'text-gray-400 dark:text-gray-500'
                        ">
                        {{ modelValue ? fileName : placeholder }}
                    </p>
                </div>
            </div>

            <div class="flex items-center gap-1">
                <template v-if="modelValue">
                    <button
                        type="button"
                        @click.stop="viewFile"
                        title="Lihat File"
                        class="p-1 text-gray-400 hover:text-sky-500 hover:bg-sky-50 dark:hover:bg-sky-900/30 rounded-md transition-all">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                    </button>

                    <button
                        type="button"
                        @click.stop="clearFile"
                        title="Hapus"
                        class="p-1 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/30 rounded-md transition-all">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </template>

                <span
                    v-else
                    class="text-[10px] font-bold uppercase tracking-widest text-gray-300 group-hover:text-sky-400 mr-1">
                    Pilih
                </span>
            </div>
        </div>

        <p v-if="error" class="text-[10px] text-red-500 mt-1 pl-1">
            {{ error }}
        </p>
    </div>
</template>
