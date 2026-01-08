<template>
    <div class="relative w-full">
        <div
            class="flex items-center rounded-lg border dark:border-gray-600 dark:bg-gray-800 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:border-indigo-500"
            :class="[error ? 'border-red-500' : 'border-gray-300']">
            <div
                class="flex-1 p-2 text-sm text-gray-700 dark:text-gray-300 min-h-[35px] cursor-pointer"
                @click="showModal = true">
                <span v-if="!selectedPrk">
                    {{ placeholder }}
                </span>
                <div v-else class="space-y-0.5">
                    <div>{{ selectedPrk.prk }}</div>
                </div>
            </div>

            <div class="flex items-center border-l border-gray-300 dark:border-gray-600">
                <button
                    v-if="selectedPrk"
                    @click="clearSelection"
                    type="button"
                    title="Hapus Pilihan"
                    class="p-2 text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M6 18L18 6M6 6l12 12"></path>
                    </svg>
                </button>
                <button
                    @click="showModal = true"
                    type="button"
                    title="Buka Pilihan PRK"
                    class="p-2 text-indigo-600 hover:bg-indigo-50 dark:hover:bg-indigo-900/20">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M19 9l-7 7-7-7"></path>
                    </svg>
                </button>
            </div>
        </div>

        <p v-if="error" class="mt-1 text-xs text-red-600 dark:text-red-400">{{ error }}</p>

        <Modal :show="showModal" @close="showModal = false" size="5xl">
            <template #title>Pilih PRK Terkait</template>

            <template #default>
                <div class="space-y-4">
                    <input
                        type="text"
                        v-model="searchQuery"
                        placeholder="Cari Nomor PRK, Uraian, Fungsi, atau Tahun..."
                        class="block w-full p-2.5 rounded-lg border-gray-300 dark:border-gray-600 dark:bg-gray-700 text-gray-900 dark:text-gray-100" />

                    <div
                        class="overflow-x-auto max-h-96 border border-gray-200 dark:border-gray-700 rounded-lg shadow-sm">
                        <table
                            class="min-w-full divide-y divide-gray-200 dark:divide-gray-700 text-sm">
                            <thead>
                                <tr
                                    class="bg-gray-100 dark:bg-gray-700 text-left text-xs font-semibold text-gray-600 dark:text-gray-300 uppercase tracking-wider">
                                    <th scope="col" class="px-4 py-3">Tahun</th>
                                    <th scope="col" class="px-4 py-3">PRK</th>
                                    <th scope="col" class="px-4 py-3">Uraian</th>
                                    <th scope="col" class="px-4 py-3">Aksi</th>
                                </tr>
                            </thead>
                            <tbody
                                class="divide-y divide-gray-200 dark:divide-gray-700 bg-white dark:bg-gray-800">
                                <tr
                                    v-for="prk in filteredPrks"
                                    :key="prk.id"
                                    @click="handleSelect(prk)"
                                    class="group cursor-pointer transition-colors duration-150 ease-in-out hover:bg-indigo-50/70 dark:hover:bg-indigo-900/30">
                                    <td
                                        class="px-4 py-3 text-gray-600 dark:text-gray-300 whitespace-nowrap">
                                        {{ prk.tahun }}
                                    </td>
                                    <td
                                        class="px-4 py-3 font-semibold text-gray-900 dark:text-gray-100 whitespace-nowrap">
                                        {{ prk.prk }}
                                    </td>

                                    <td class="px-4 py-3 text-gray-700 dark:text-gray-200 max-w-sm">
                                        <p class="truncate text-xs" :title="prk.uraian">
                                            {{ prk.uraian }}
                                        </p>
                                    </td>

                                    <td class="px-4 py-3 whitespace-nowrap text-right">
                                        <button
                                            @click.stop="handleSelect(prk)"
                                            type="button"
                                            class="px-3 py-1.5 text-xs font-medium text-indigo-700 dark:text-indigo-200 bg-indigo-100 dark:bg-indigo-700/50 rounded-md hover:bg-indigo-200 dark:hover:bg-indigo-600 transition-colors">
                                            Pilih
                                        </button>
                                    </td>
                                </tr>
                                <tr v-if="filteredPrks.length === 0">
                                    <td
                                        colspan="7"
                                        class="px-4 py-4 text-center text-gray-500 dark:text-gray-400">
                                        {{
                                            searchQuery
                                                ? 'Tidak ada PRK yang cocok.'
                                                : 'Silakan cari PRK.'
                                        }}
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
    prks: {
        // Asumsi prks kini menyertakan field `tahun`
        type: Array,
        default: () => []
    },
    label: String,
    placeholder: {
        type: String,
        default: 'Klik untuk memilih PRK'
    },
    error: String
})

const emit = defineEmits(['update:modelValue'])

const showModal = ref(false)
const searchQuery = ref('')

// --- Logika Input Trigger ---
const selectedPrk = computed(() => {
    return props.prks.find(p => p.id === props.modelValue)
})

const handleSelect = prk => {
    emit('update:modelValue', prk.id)
    showModal.value = false
    searchQuery.value = '' // Reset pencarian setelah memilih
}

const clearSelection = () => {
    emit('update:modelValue', null)
    searchQuery.value = '' // Reset pencarian jika ada
}

// --- Logika Modal/Pencarian (Diperbarui untuk mencari Tahun) ---
const filteredPrks = computed(() => {
    if (!searchQuery.value) return props.prks
    const query = searchQuery.value.toLowerCase()

    return props.prks.filter(
        prk =>
            prk.prk.toLowerCase().includes(query) ||
            prk.uraian.toLowerCase().includes(query) ||
            prk.fungsi.toLowerCase().includes(query) ||
            prk.status.toLowerCase().includes(query) ||
            // TAMBAH PENCARIAN TAHUN
            String(prk.tahun).includes(query)
    )
})
</script>
