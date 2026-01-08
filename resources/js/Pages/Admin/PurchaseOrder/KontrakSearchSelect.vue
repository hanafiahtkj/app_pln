<template>
    <div class="relative w-full">
        <div
            class="flex items-center rounded-lg border transition-all duration-200"
            :class="[
                error ? 'border-red-500' : 'border-gray-300 dark:border-gray-600',
                disabled
                    ? 'bg-gray-100 dark:bg-gray-700/50 cursor-not-allowed opacity-75'
                    : 'bg-white dark:bg-gray-800 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:border-indigo-500'
            ]">
            <div
                class="flex-1 p-2 text-sm text-gray-700 dark:text-gray-300 min-h-[35px]"
                :class="[disabled ? 'cursor-not-allowed' : 'cursor-pointer']"
                @click="!disabled && (showModal = true)">
                <span v-if="!selectedKontrak" class="text-gray-400">
                    {{ placeholder }}
                </span>
                <div v-else class="space-y-0.5 font-medium text-gray-900 dark:text-gray-100">
                    <div>
                        PRK:
                        {{ selectedKontrak.lakdan?.rendan?.enjiniring?.paket?.prk?.prk || '-' }} |
                        Kontrak: {{ selectedKontrak.nomor_perjanjian }}
                    </div>
                </div>
            </div>

            <div class="flex items-center border-l border-gray-300 dark:border-gray-600">
                <button
                    v-if="selectedKontrak && !disabled"
                    @click="clearSelection"
                    type="button"
                    title="Hapus Pilihan"
                    class="p-2 text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>

                <button
                    @click="!disabled && (showModal = true)"
                    :disabled="disabled"
                    type="button"
                    title="Buka Pilihan Kontrak"
                    class="p-2 transition-colors"
                    :class="[
                        disabled
                            ? 'text-gray-400 cursor-not-allowed'
                            : 'text-indigo-600 hover:bg-indigo-50 dark:hover:bg-indigo-900/20'
                    ]">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M19 9l-7 7-7-7" />
                    </svg>
                </button>
            </div>
        </div>

        <p v-if="error" class="mt-1 text-xs text-red-600 dark:text-red-400">{{ error }}</p>

        <Modal :show="showModal" @close="showModal = false" size="5xl">
            <template #title>Pilih Data Kontrak Terkait</template>

            <template #default>
                <div class="space-y-4">
                    <input
                        type="text"
                        v-model="searchQuery"
                        placeholder="Cari Nomor Perjanjian, PRK, atau Vendor..."
                        class="block w-full p-2.5 rounded-lg border-gray-300 dark:border-gray-600 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-indigo-500 focus:border-indigo-500" />

                    <div
                        class="overflow-x-auto max-h-96 border border-gray-200 dark:border-gray-700 rounded-lg shadow-sm">
                        <table
                            class="min-w-full divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                            <thead>
                                <tr
                                    class="bg-gray-100 dark:bg-gray-700 text-left text-xs font-semibold text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                                    <th class="px-4 py-3">No Perjanjian</th>
                                    <th class="px-4 py-3">Nilai Kontrak</th>
                                    <th class="px-4 py-3">Vendor</th>
                                    <th class="px-4 py-3">PRK Terkait</th>
                                    <th class="px-4 py-3 text-right">Aksi</th>
                                </tr>
                            </thead>
                            <tbody
                                class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                                <tr
                                    v-for="kontrak in filteredKontraks"
                                    :key="kontrak.id"
                                    @click="handleSelect(kontrak)"
                                    class="group cursor-pointer transition-colors hover:bg-indigo-50/70 dark:hover:bg-indigo-900/30">
                                    <td
                                        class="px-4 py-3 font-semibold text-gray-900 dark:text-gray-100 whitespace-nowrap">
                                        {{ kontrak.nomor_perjanjian || '-' }}
                                    </td>
                                    <td
                                        class="px-4 py-3 text-gray-600 dark:text-gray-300 whitespace-nowrap">
                                        Rp
                                        {{
                                            kontrak.nilai_kontrak
                                                ? kontrak.nilai_kontrak.toLocaleString('id-ID')
                                                : '0'
                                        }}
                                    </td>
                                    <td
                                        class="px-4 py-3 text-gray-600 dark:text-gray-300 whitespace-nowrap">
                                        {{ kontrak.vendor?.nama || '-' }}
                                    </td>
                                    <td
                                        class="px-4 py-3 text-gray-600 dark:text-gray-300 max-w-xs truncate">
                                        {{
                                            kontrak.lakdan?.rendan?.enjiniring?.paket?.prk?.prk ||
                                            '-'
                                        }}
                                    </td>
                                    <td class="px-4 py-3 text-right">
                                        <button
                                            @click.stop="handleSelect(kontrak)"
                                            type="button"
                                            class="px-3 py-1.5 text-xs font-medium text-indigo-700 dark:text-indigo-200 bg-indigo-100 dark:bg-indigo-700/50 rounded-md hover:bg-indigo-200">
                                            Pilih
                                        </button>
                                    </td>
                                </tr>
                                <tr v-if="filteredKontraks.length === 0">
                                    <td
                                        colspan="5"
                                        class="px-4 py-8 text-center text-gray-500 dark:text-gray-400">
                                        Data tidak ditemukan.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </template>
        </Modal>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import Modal from '@/Components/Modal.vue'

const props = defineProps({
    modelValue: [String, Number, null],
    kontraks: {
        type: Array,
        default: () => []
    },
    label: String,
    placeholder: {
        type: String,
        default: 'Klik untuk memilih Data Kontrak'
    },
    error: String,
    // Prop Baru untuk Fitur Disable
    disabled: {
        type: Boolean,
        default: false
    }
})

const emit = defineEmits(['update:modelValue'])

const showModal = ref(false)
const searchQuery = ref('')

const selectedKontrak = computed(() => {
    return props.kontraks.find(k => k.id === props.modelValue)
})

const handleSelect = kontrak => {
    emit('update:modelValue', kontrak.id)
    showModal.value = false
    searchQuery.value = ''
}

const clearSelection = () => {
    emit('update:modelValue', null)
    searchQuery.value = ''
}

const filteredKontraks = computed(() => {
    if (!searchQuery.value) return props.kontraks
    const query = searchQuery.value.toLowerCase()

    return props.kontraks.filter(kontrak => {
        const lakdan = kontrak.lakdan
        const rendan = lakdan?.rendan
        const enjiniring = rendan?.enjiniring
        const paket = enjiniring?.paket
        const prk = paket?.prk

        return (
            kontrak.nomor_perjanjian?.toLowerCase().includes(query) ||
            kontrak.vendor?.nama?.toLowerCase().includes(query) ||
            lakdan?.nomor_hps?.toLowerCase().includes(query) ||
            prk?.prk?.toLowerCase().includes(query) ||
            prk?.uraian?.toLowerCase().includes(query)
        )
    })
})
</script>
