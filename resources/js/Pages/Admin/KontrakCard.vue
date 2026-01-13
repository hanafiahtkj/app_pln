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
            :class="[
                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                paket.enjiniring?.rendan?.lakdan?.kontrak
                    ? 'bg-emerald-600 text-white'
                    : 'bg-gray-200 text-gray-500'
            ]">
            05
        </div>

        <div
            v-if="paket.enjiniring?.rendan?.lakdan?.kontrak"
            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-emerald-600">
            <div
                @click="toggleCollapse"
                class="flex flex-wrap justify-between items-center p-7 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors">
                <div class="flex items-center gap-4">
                    <div class="flex items-center gap-2">
                        <div class="w-2.5 h-2.5 rounded-full bg-emerald-600"></div>
                        <h3
                            class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                            Dokumen Kontrak (Perjanjian)
                        </h3>
                    </div>
                </div>
                <div class="flex items-center gap-4">
                    <Link
                        v-if="hasAccess"
                        :href="
                            route('admin.kontrak.edit', paket.enjiniring.rendan.lakdan.kontrak.id)
                        "
                        class="text-xs font-bold text-blue-600 hover:underline uppercase">
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
                <section class="dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                Detail Perjanjian (Kontrak)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tanggal, nomor, nilai, dan dokumen perjanjian.
                            </p>
                        </div>
                        <div
                            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Nomor Perjanjian
                                </p>
                                <p
                                    class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                    {{ paket.enjiniring.rendan.lakdan.kontrak.nomor_perjanjian }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Nilai (Inc. PPN)
                                </p>
                                <p class="text-sm font-bold text-gray-900 dark:text-white">
                                    {{
                                        formatIDR(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .nilai_perjanjian_ppn
                                        )
                                    }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Nilai (Excl. PPN)
                                </p>
                                <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                    {{
                                        formatIDR(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .nilai_perjanjian_sebelum_ppn
                                        )
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Perjanjian (Rencana)
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{
                                        formatTgl(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .rencana_tanggal_perjanjian
                                        ) || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Perjanjian (Realisasi)
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{
                                        formatTgl(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .realisasi_tanggal_perjanjian
                                        ) || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Berakhir Kontrak
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{
                                        formatTgl(
                                            paket.enjiniring.rendan.lakdan.kontrak.tanggal_berakhir
                                        ) || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Dokumen Kontrak
                                </p>

                                <div
                                    v-if="
                                        paket.enjiniring.rendan.lakdan.kontrak.dokumen_perjanjian
                                    ">
                                    <a
                                        @click="
                                            openPdfPreview(
                                                paket.enjiniring.rendan.lakdan.kontrak
                                                    .dokumen_perjanjian
                                            )
                                        "
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
                                <div
                                    v-else
                                    class="text-xs text-gray-500 italic flex items-center gap-2">
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
                </section>

                <section class="dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                Detail Jaminan Pelaksanaan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Informasi mengenai jaminan pelaksanaan kontrak.
                            </p>
                        </div>
                        <div
                            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Nomor Jaminan Pelaksanaan
                                </p>
                                <p
                                    class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak
                                            .nomor_jaminan_pelaksanaan || '-'
                                    }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Nilai Jaminan Pelaksanaan
                                </p>
                                <p class="text-sm font-bold text-gray-900 dark:text-white">
                                    {{
                                        formatIDR(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .nilai_jaminan_pelaksanaan
                                        ) || '-'
                                    }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Bank Pemberi Jaminan
                                </p>
                                <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak
                                            .bank_pemberi_jaminan || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Jaminan (Rencana)
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{
                                        formatTgl(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .rencana_jaminan_pelaksanaan
                                        ) || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Jaminan (Realisasi)
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{
                                        formatTgl(
                                            paket.enjiniring.rendan.lakdan.kontrak
                                                .realisasi_jaminan_pelaksanaan
                                        ) || '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Dokumen Jaminan
                                </p>

                                <div
                                    v-if="
                                        paket.enjiniring.rendan.lakdan.kontrak
                                            .dokumen_jaminan_pelaksanaan
                                    ">
                                    <a
                                        @click="
                                            openPdfPreview(
                                                paket.enjiniring.rendan.lakdan.kontrak
                                                    .dokumen_jaminan_pelaksanaan
                                            )
                                        "
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
                                <div
                                    v-else
                                    class="text-xs text-gray-500 italic flex items-center gap-2">
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
                </section>

                <section class="dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                Metrik dan Keterangan Tambahan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Informasi mengenai risiko, TKDN, dan efisiensi.
                            </p>
                        </div>

                        <div
                            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Penyedia Barang/Jasa
                                </p>
                                <p
                                    class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak
                                            .penyedia_barang_jasa || '-'
                                    }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Jenis Perjanjian
                                </p>
                                <p
                                    class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak.jenis_perjanjian ||
                                        '-'
                                    }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Status Proses
                                </p>
                                <p
                                    class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                    {{ paket.enjiniring.rendan.lakdan.kontrak.status_proses }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Durasi Pengadaan
                                </p>
                                <p
                                    class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                    {{ paket.enjiniring.rendan.lakdan.kontrak.durasi_pengadaan }}
                                    Hari
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Masa Pelaksanaan
                                </p>
                                <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                    {{ paket.enjiniring.rendan.lakdan.kontrak.masa_pelaksanaan }}
                                    Hari
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    TKDN
                                </p>
                                <p class="text-sm font-bold text-emerald-600">
                                    {{ paket.enjiniring.rendan.lakdan.kontrak.tkdn }}%
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Efisiensi HPS
                                </p>
                                <p class="text-sm font-semibold text-emerald-600">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak.efisiensi_thd_hps ||
                                        '-'
                                    }}
                                </p>
                            </div>

                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Risiko CSMS
                                </p>
                                <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak
                                            .tingkat_risiko_csms || '-'
                                    }}
                                </p>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>

        <div
            v-else
            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
            <div
                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-500 border border-gray-300">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round" />
                </svg>
            </div>

            <p class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6 italic">
                Proses Pengadaan Selesai. Menunggu Input Dokumen Kontrak (Perjanjian).
            </p>

            <Link
                v-if="paket.enjiniring?.rendan?.lakdan"
                :href="
                    route('admin.kontrak.create', {
                        lakdan_id: paket.enjiniring.rendan.lakdan.id
                    })
                "
                class="inline-flex px-8 py-2.5 bg-emerald-600 text-white text-xs font-bold uppercase rounded-full shadow-lg hover:bg-emerald-700 transition-all hover:scale-105">
                + Input Data Kontrak
            </Link>

            <p
                v-else
                class="text-xs font-bold text-gray-400 uppercase tracking-widest border border-gray-300 px-4 py-2 rounded-full inline-block">
                Menunggu Tahap Pelaksanaan Pengadaan
            </p>
        </div>
    </section>
</template>
