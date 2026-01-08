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
                <span v-if="!selectedLakdan" class="text-gray-400">
                    {{ placeholder }}
                </span>
                <div v-else class="space-y-0.5">
                    <div class="font-medium text-gray-900 dark:text-gray-100">
                        PRK: {{ selectedLakdan.rendan?.enjiniring?.paket?.prk?.prk || '-' }} | HPS:
                        {{ selectedLakdan.nomor_hps }}
                    </div>
                </div>
            </div>

            <div class="flex items-center border-l border-gray-300 dark:border-gray-600">
                <button
                    v-if="selectedLakdan && !disabled"
                    @click="clearSelection"
                    type="button"
                    title="Hapus Pilihan"
                    class="p-2 text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20">
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
                    title="Buka Pilihan Lakdan"
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
            <template #title>Pilih Data Pelaksanaan Pengadaan (Lakdan)</template>

            <template #default>
                <div class="space-y-4">
                    <input
                        type="text"
                        v-model="searchQuery"
                        placeholder="Cari Nomor HPS, Nomor PRK, atau Uraian..."
                        class="block w-full p-2.5 rounded-lg border-gray-300 dark:border-gray-600 dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:ring-indigo-500 focus:border-indigo-500" />

                    <div
                        class="overflow-x-auto max-h-96 border border-gray-200 dark:border-gray-700 rounded-lg shadow-sm">
                        <table
                            class="min-w-full divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                            <thead>
                                <tr
                                    class="bg-gray-100 dark:bg-gray-700 text-left text-xs font-semibold text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                                    <th class="px-4 py-3">PRK</th>
                                    <th class="px-4 py-3">No HPS</th>
                                    <th class="px-4 py-3">Nilai HPS</th>
                                    <th class="px-4 py-3">Status</th>
                                    <th class="px-4 py-3 text-right">Aksi</th>
                                </tr>
                            </thead>
                            <tbody
                                class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                                <tr
                                    v-for="lakdan in filteredLakdans"
                                    :key="lakdan.id"
                                    @click="handleSelect(lakdan)"
                                    class="group cursor-pointer transition-colors hover:bg-indigo-50/70 dark:hover:bg-indigo-900/30">
                                    <td class="px-4 py-3 text-gray-600 dark:text-gray-300 max-w-xs">
                                        <p
                                            class="truncate text-xs"
                                            :title="lakdan.rendan?.enjiniring?.paket?.prk?.uraian">
                                            {{ lakdan.rendan?.enjiniring?.paket?.prk?.prk || '-' }}
                                        </p>
                                    </td>
                                    <td
                                        class="px-4 py-3 font-semibold text-gray-900 dark:text-gray-100 whitespace-nowrap">
                                        {{ lakdan.nomor_hps || '-' }}
                                    </td>
                                    <td
                                        class="px-4 py-3 text-gray-600 dark:text-gray-300 whitespace-nowrap">
                                        Rp
                                        {{
                                            lakdan.nilai_hps
                                                ? lakdan.nilai_hps.toLocaleString('id-ID')
                                                : '0'
                                        }}
                                    </td>
                                    <td
                                        class="px-4 py-3 text-gray-700 dark:text-gray-200 whitespace-nowrap">
                                        {{ lakdan.status_pengadaan || '-' }}
                                    </td>
                                    <td class="px-4 py-3 text-right">
                                        <button
                                            @click.stop="handleSelect(lakdan)"
                                            type="button"
                                            class="px-3 py-1.5 text-xs font-medium text-indigo-700 dark:text-indigo-200 bg-indigo-100 dark:bg-indigo-700/50 rounded-md hover:bg-indigo-200">
                                            Pilih
                                        </button>
                                    </td>
                                </tr>
                                <tr v-if="filteredLakdans.length === 0">
                                    <td colspan="5" class="px-4 py-8 text-center text-gray-500">
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
    lakdans: {
        type: Array,
        default: () => []
    },
    label: String,
    placeholder: {
        type: String,
        default: 'Klik untuk memilih Data Pelaksanaan Pengadaan (Lakdan)'
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

const selectedLakdan = computed(() => {
    return props.lakdans.find(l => l.id === props.modelValue)
})

const handleSelect = lakdan => {
    emit('update:modelValue', lakdan.id)
    showModal.value = false
    searchQuery.value = ''
}

const clearSelection = () => {
    emit('update:modelValue', null)
    searchQuery.value = ''
}

const filteredLakdans = computed(() => {
    if (!searchQuery.value) return props.lakdans
    const query = searchQuery.value.toLowerCase()

    return props.lakdans.filter(lakdan => {
        const rendan = lakdan.rendan
        const enjiniring = rendan?.enjiniring
        const paket = enjiniring?.paket
        const prk = paket?.prk

        return (
            lakdan.nomor_hps?.toLowerCase().includes(query) ||
            lakdan.status_pengadaan?.toLowerCase().includes(query) ||
            rendan?.nomor_nd_user?.toLowerCase().includes(query) ||
            rendan?.nomor_rks?.toLowerCase().includes(query) ||
            prk?.prk?.toLowerCase().includes(query) ||
            prk?.uraian?.toLowerCase().includes(query)
        )
    })
})
</script>
