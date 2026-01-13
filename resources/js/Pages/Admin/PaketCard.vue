<script setup>
import { ref } from 'vue'
import { Link } from '@inertiajs/vue3' // Asumsi menggunakan Inertia.js sesuai kode Anda

// Definisi Props
const props = defineProps({
    paket: {
        type: Object,
        required: true
    },
    hasAccess: {
        type: Boolean,
        default: false
    },
    isOpen: {
        type: Boolean,
        default: false
    }
})

const isOpen = ref(props.isOpen)

const toggleCollapse = () => {
    isOpen.value = !isOpen.value
}

const formatIDR = val => {
    return val
        ? new Intl.NumberFormat('id-ID', {
              style: 'currency',
              currency: 'IDR',
              maximumFractionDigits: 0
          }).format(val)
        : 'Rp 0'
}

const formatTanggal = dateString => {
    if (!dateString) return '-'
    return new Date(dateString).toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    })
}

const formatTgl = tgl => {
    if (!tgl) return '-'
    return new Date(tgl).toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
    })
}

const emit = defineEmits(['openPdfPreview'])
const openPdfPreview = url => {
    emit('openPdfPreview', url)
}
</script>

<template>
    <section class="relative group">
        <div
            class="absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full bg-blue-600 text-white text-xs font-bold z-10 border-4 border-white dark:border-gray-900 shadow-sm transition-transform group-hover:scale-110">
            01
        </div>

        <div
            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all duration-300 border-l-[6px] border-l-blue-600">
            <div
                @click="toggleCollapse"
                class="flex flex-wrap justify-between items-center p-7 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors">
                <div class="flex items-center gap-4">
                    <div class="flex items-center gap-2">
                        <div class="w-2 h-2 rounded-full bg-blue-600"></div>
                        <span
                            class="text-xs font-bold text-gray-600 dark:text-gray-400 uppercase tracking-widest">
                            Informasi Paket
                        </span>
                    </div>
                    <span class="h-4 w-px bg-gray-300 dark:bg-gray-700"></span>
                    <span
                        class="px-3 py-1 bg-emerald-100 text-emerald-700 dark:bg-emerald-900/40 dark:text-emerald-400 text-xs font-bold rounded-full">
                        {{ paket.status_paket }}
                    </span>
                    <span class="text-xs font-mono text-gray-500 dark:text-gray-400">
                        #{{ paket.id }}
                    </span>
                </div>
                <div class="flex items-center gap-4">
                    <Link
                        v-if="hasAccess"
                        :href="route('admin.paket.edit', paket.id)"
                        class="text-xs font-bold text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 px-3 py-1.5 rounded-lg transition-colors tracking-wide">
                        PERBARUI DATA
                    </Link>

                    <svg
                        :class="{ 'rotate-180': isOpen }"
                        class="w-5 h-5 text-gray-400 transition-transform duration-300"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24">
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M19 9l-7 7-7-7" />
                    </svg>
                </div>
            </div>

            <div
                v-show="isOpen"
                class="px-7 pb-7 border-t border-gray-200 dark:border-gray-800 pt-6">
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Tahun
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ paket.tahun }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">PRK</p>
                        <p
                            class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                            :title="paket.prk?.prk">
                            {{ paket.prk?.prk || 'N/A' }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Uraian Paket
                        </p>
                        <p
                            class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                            :title="paket.uraian_paket">
                            {{ paket.uraian_paket || 'N/A' }}
                        </p>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6">
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Nomor SKK
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                            {{ paket.nomor_skk || '-' }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Tanggal SKK
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ formatTanggal(paket.tanggal_skk) }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Nilai SKK
                        </p>
                        <p class="text-sm font-bold text-gray-900 dark:text-white">
                            {{ formatIDR(paket.nilai_skk) }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Status Paket
                        </p>
                        <p class="text-sm font-bold text-gray-900 dark:text-white">
                            {{ paket.status_paket || '-' }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Dokumen SKK
                        </p>

                        <div v-if="paket.dokumen_skk">
                            <a
                                @click="openPdfPreview(paket.dokumen_skk)"
                                target="_blank"
                                class="inline-flex items-center gap-2 text-xs font-bold text-blue-600 hover:underline uppercase tracking-widest">
                                <svg
                                    class="w-4 h-4 text-rose-500"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                                Lihat Dokumen
                            </a>
                        </div>
                        <div v-else class="text-xs text-gray-500 italic flex items-center gap-2">
                            <svg
                                class="w-4 h-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path
                                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
                                    stroke-width="2"
                                    stroke-linecap="round"
                                    stroke-linejoin="round" />
                            </svg>
                            Dokumen belum diunggah
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
