<script setup>
import { Head, Link } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import PdfPreviewModal from '@/Components/PdfPreviewModal.vue'
import { h, ref, watch } from 'vue'

defineOptions({ layout: Default })
const props = defineProps({ data: { type: Object, required: true } })
const prk = props.data

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

const showPdfModal = ref(false)
const pdfUrl = ref(null)

const closeModal = () => {
    showPdfModal.value = false
    pdfUrl.value = null
}

// --- FUNGSI PDF PREVIEW ---
const openPdfPreview = path => {
    if (!path) return
    pdfUrl.value = path
    showPdfModal.value = true
}
</script>

<template>
    <Head :title="`Detail Proyek - ${prk.nomor_skk || prk.id}`" />

    <main class="max-w-6xl mx-auto space-y-8">
        <div class="container-border overflow-hidden">
            <PageHeader
                :title="`Detail Prk: ${props.data.id}`"
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Prk', href: route('admin.prk.index') },
                    { label: 'Detail' }
                ]">
                <template #actions>
                    <Link :href="route('admin.prk.index')" class="btn-primary btn-sm">
                        Kembali ke Daftar
                    </Link>
                </template>
            </PageHeader>

            <div class="p-6 md:p-8 relative">
                <div
                    class="absolute left-10 md:left-16 top-14 bottom-14 w-[1px] bg-gradient-to-b from-slate-200 via-slate-100 to-transparent dark:from-slate-700 dark:via-slate-800 hidden md:block"></div>

                <div class="space-y-12">
                    <section class="relative group">
                        <div
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all duration-300 border-l-[6px] border-l-white-600">
                            <div
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800">
                                <div class="flex items-center gap-4">
                                    <div class="flex items-center gap-2">
                                        <div class="w-2 h-2 rounded-full bg-blue-600"></div>
                                        <span
                                            class="text-xs font-bold text-gray-600 dark:text-gray-400 uppercase tracking-widest">
                                            Informasi Pokok PRK
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Informasi Pokok PRK
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Identitas, fungsi, dan uraian utama dari PRK.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tahun
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.tahun }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor PRK
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                                :title="prk?.prk">
                                                {{ prk?.prk || 'N/A' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Uraian
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                                :title="prk?.uraian">
                                                {{ prk?.uraian || 'N/A' }}
                                            </p>
                                        </div>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Fungsi
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ prk.fungsi || '-' }}
                                            </p>
                                        </div>

                                        <!-- <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Unit
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ prk.unit.name || '-' }}
                                            </p>
                                        </div> -->

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Bidang Pelaksana
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ prk.bidang.name || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Status
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ prk.status || '-' }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Anggaran dan Paket
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail biaya investasi dan jumlah paket yang disetujui.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Anggaran AI
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{ formatIDR(prk.ai_rupiah) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai SKAI
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{ formatIDR(prk.nilai_skai) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Jumlah Paket
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{ prk.jumlah_paket || '-' }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Kaji Ulang Dokumen (KKP, Risiko, GRC)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Data terkait kajian kebutuhan proyek, risiko, dan GRC.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen KKP
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.dokumen_kkp || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal KKP
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(prk.tanggal_kkp) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen KKP
                                            </p>

                                            <div v-if="prk.file_kkp">
                                                <a
                                                    @click="openPdfPreview(prk.file_kkp)"
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Ulasan Kajian Resiko
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.ulasan_kajian_risiko || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal Ulasan Kajian Resiko
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTanggal(prk.tanggal_ulasan_kajian_risiko)
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen Kajian Resiko
                                            </p>

                                            <div v-if="prk.file_kajian_risiko">
                                                <a
                                                    @click="openPdfPreview(prk.file_kajian_risiko)"
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen GRC
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.dokumen_grc || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal GRC
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(prk.tanggal_grc) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen GRC
                                            </p>

                                            <div v-if="prk.file_grc">
                                                <a
                                                    @click="openPdfPreview(prk.file_grc)"
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
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Persetujuan (TVV & SKAI)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Data terkait Technical Verification and Validation (TVV)
                                            dan SKAI.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen TVV
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.dokumen_tvv || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal TVV
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(prk.tanggal_tvv) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen TVV
                                            </p>

                                            <div v-if="prk.file_tvv">
                                                <a
                                                    @click="openPdfPreview(prk.file_tvv)"
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
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Status Persetujuan TVV
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.status_persetujuan_tvv || '-' }}
                                            </p>
                                        </div>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen SKAI
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ prk.nomor_skai || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal SKAI
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(prk.tanggal_skai) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen SKAI
                                            </p>

                                            <div v-if="prk.dokumen_skai">
                                                <a
                                                    @click="openPdfPreview(prk.dokumen_skai)"
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
                        </div>
                    </section>
                </div>
            </div>
        </div>
    </main>

    <PdfPreviewModal :show="showPdfModal" :pdf-url="pdfUrl" @close="closeModal" />
</template>

<style scoped>
a {
    cursor: pointer;
}
</style>
