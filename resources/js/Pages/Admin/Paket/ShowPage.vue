<script setup>
import { Head, Link } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import PdfPreviewModal from '@/Components/PdfPreviewModal.vue'
import { h, ref, watch } from 'vue'

defineOptions({ layout: Default })
const props = defineProps({ data: { type: Object, required: true } })
const paket = props.data

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

const checklistFields = [
    { key: 'berkas', label: 'Berkas Lengkap' },
    { key: 'vendor_upload_vip', label: 'Vendor Upload VIP' },
    { key: 'maker', label: 'Status Maker' },
    { key: 'checker', label: 'Status Checker' },
    { key: 'tax', label: 'Status Tax' },
    { key: 'sptjp', label: 'Status SPTJP' },
    { key: 'ira_irs', label: 'Status IRA/IRS' },
    { key: 'verifikator_pusat', label: 'Verifikator Pusat' },
    { key: 'lunas_vendor', label: 'Lunas Bayar Vendor' },
    { key: 'lunas_pajak', label: 'Lunas Bayar Pajak' }
]

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
    <Head :title="`Detail Proyek - ${paket.nomor_skk || paket.id}`" />

    <main class="max-w-6xl mx-auto space-y-8">
        <div class="container-border overflow-hidden">
            <PageHeader
                :title="`Detail Paket: ${props.data.id}`"
                description="Detail lengkap Paket Pekerjaan."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Paket', href: route('admin.paket.index') },
                    { label: 'Detail' }
                ]">
                <template #actions>
                    <Link :href="route('admin.paket.index')" class="btn-primary btn-sm">
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
                            class="absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full bg-blue-600 text-white text-xs font-bold z-10 border-4 border-white dark:border-gray-900 shadow-sm transition-transform group-hover:scale-110">
                            00
                        </div>

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
                                                {{ paket.prk.tahun }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor PRK
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                                :title="paket.prk?.prk">
                                                {{ paket.prk?.prk || 'N/A' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Uraian
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                                :title="paket.prk?.uraian">
                                                {{ paket.prk?.uraian || 'N/A' }}
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
                                                {{ paket.prk.fungsi || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Bidang Pelaksana
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ paket.prk.bidang.name || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Status
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ paket.prk.status || '-' }}
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
                                                {{ formatIDR(paket.prk.ai_rupiah) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai SKAI
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{ formatIDR(paket.prk.nilai_skai) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Jumlah Paket
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{ paket.prk.jumlah_paket || '-' }}
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
                                                {{ paket.prk.dokumen_kkp || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal KKP
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(paket.prk.tanggal_kkp) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen KKP
                                            </p>

                                            <div v-if="paket.prk.file_kkp">
                                                <a
                                                    @click="openPdfPreview(paket.prk.file_kkp)"
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
                                                {{ paket.prk.ulasan_kajian_risiko || '-' }}
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
                                                    formatTanggal(
                                                        paket.prk.tanggal_ulasan_kajian_risiko
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen Kajian Resiko
                                            </p>

                                            <div v-if="paket.prk.file_kajian_risiko">
                                                <a
                                                    @click="
                                                        openPdfPreview(paket.prk.file_kajian_risiko)
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen GRC
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ paket.prk.dokumen_grc || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal GRC
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(paket.prk.tanggal_grc) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen GRC
                                            </p>

                                            <div v-if="paket.prk.file_grc">
                                                <a
                                                    @click="openPdfPreview(paket.prk.file_grc)"
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
                                                {{ paket.prk.dokumen_tvv || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal TVV
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(paket.prk.tanggal_tvv) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen TVV
                                            </p>

                                            <div v-if="paket.prk.file_tvv">
                                                <a
                                                    @click="openPdfPreview(paket.prk.file_tvv)"
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
                                                {{ paket.prk.status_persetujuan_tvv || '-' }}
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
                                                {{ paket.prk.nomor_skai || '-' }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal SKAI
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTanggal(paket.prk.tanggal_skai) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen SKAI
                                            </p>

                                            <div v-if="paket.prk.dokumen_skai">
                                                <a
                                                    @click="openPdfPreview(paket.prk.dokumen_skai)"
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

                    <section class="relative group">
                        <div
                            class="absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full bg-blue-600 text-white text-xs font-bold z-10 border-4 border-white dark:border-gray-900 shadow-sm transition-transform group-hover:scale-110">
                            01
                        </div>

                        <div
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all duration-300 border-l-[6px] border-l-blue-600">
                            <div
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800">
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
                                    <span
                                        class="text-xs font-mono text-gray-500 dark:text-gray-400">
                                        #{{ paket.id }}
                                    </span>
                                </div>

                                <Link
                                    :href="route('admin.paket.edit', paket.id)"
                                    class="text-xs font-bold text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 px-3 py-1.5 rounded-lg transition-colors tracking-wide">
                                    PERBARUI DATA
                                </Link>
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
                                        {{ paket.tahun }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        PRK
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                        :title="paket.prk?.prk">
                                        {{ paket.prk?.prk || 'N/A' }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Uraian
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate"
                                        :title="paket.prk?.uraian">
                                        {{ paket.prk?.uraian || 'N/A' }}
                                    </p>
                                </div>
                            </div>

                            <div
                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6">
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nomor SKK
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                        {{ paket.nomor_skk || '-' }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Tanggal SKK
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                        {{ formatTanggal(paket.tanggal_skk) }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nilai SKK
                                    </p>
                                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                                        {{ formatIDR(paket.nilai_skk) }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Status Paket
                                    </p>
                                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                                        {{ paket.status_paket || '-' }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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

                    <section class="relative group">
                        <div
                            :class="[
                                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                                paket.enjiniring
                                    ? 'bg-orange-500 text-white'
                                    : 'bg-gray-200 text-gray-500'
                            ]">
                            02
                        </div>

                        <div
                            v-if="paket.enjiniring"
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-orange-500">
                            <div
                                class="flex justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800">
                                <div class="flex items-center gap-2">
                                    <div class="w-2 h-2 rounded-full bg-orange-500"></div>
                                    <h3
                                        class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                        Detail Enjiniring
                                    </h3>
                                </div>
                                <Link
                                    :href="route('admin.enjiniring.edit', paket.enjiniring.id)"
                                    class="text-xs font-bold text-blue-600 hover:underline transition-colors uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Status Survey
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Target dan realisasi pelaksanaan survey.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor Dokumen Survey
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate">
                                                {{ paket.enjiniring.dokumen_survey || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen Survey
                                            </p>

                                            <div v-if="paket.enjiniring.file_survey">
                                                <a
                                                    href="#"
                                                    @click="
                                                        openPdfPreview(paket.enjiniring.file_survey)
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Target Survey
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(paket.enjiniring.target_survey) || '-'
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Realisasi Survey
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.realisasi_survey
                                                        ? 'text-emerald-600'
                                                        : 'text-rose-600'
                                                ]">
                                                {{
                                                    formatTgl(paket.enjiniring.realisasi_survey) ||
                                                    'Belum Realisasi'
                                                }}
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
                                            Dokumen Enjiniring (RAB & TOR)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail status dokumen enjiniring dan referensi dokumen.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Target Dokumen
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.target_dokumen_enjiniring
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Realisasi Dokumen
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.realisasi_dokumen_enjiniring
                                                        ? 'text-emerald-600'
                                                        : 'text-gray-500'
                                                ]">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring
                                                            .realisasi_dokumen_enjiniring
                                                    ) || 'Proses'
                                                }}
                                            </p>
                                        </div>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor Dokumen RAB
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ paket.enjiniring.dokumen_rab || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen RAB
                                            </p>

                                            <div v-if="paket.enjiniring.file_rab">
                                                <a
                                                    @click="
                                                        openPdfPreview(paket.enjiniring.file_rab)
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor Dokumen TOR
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ paket.enjiniring.dokumen_tor || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen TOR
                                            </p>

                                            <div v-if="paket.enjiniring.file_tor">
                                                <a
                                                    @click="
                                                        openPdfPreview(paket.enjiniring.file_tor)
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

                            <div class="mt-8 pt-6 border-t border-gray-100 dark:border-gray-800">
                                <p
                                    class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-2">
                                    Keterangan
                                </p>
                                <p class="text-sm text-gray-700 dark:text-gray-400 leading-relaxed">
                                    {{ paket.enjiniring.keterangan }}
                                </p>
                            </div>
                        </div>

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-600 p-12 rounded-2xl text-center">
                            <p
                                class="text-sm font-medium text-gray-600 dark:text-gray-400 mb-6 italic">
                                Data Enjiniring belum diinput untuk paket ini
                            </p>

                            <Link
                                :href="route('admin.enjiniring.create', { paket_id: paket.id })"
                                class="inline-flex px-6 py-2.5 bg-orange-500 text-white text-xs font-bold uppercase rounded-full shadow-lg shadow-orange-100 transition-all hover:scale-105">
                                + Lengkapi Data Enjiniring
                            </Link>
                        </div>
                    </section>

                    <section class="relative group">
                        <div
                            :class="[
                                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                                paket.enjiniring?.rendan
                                    ? 'bg-indigo-600 text-white'
                                    : 'bg-gray-200 text-gray-500'
                            ]">
                            03
                        </div>

                        <div
                            v-if="paket.enjiniring?.rendan"
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-indigo-600">
                            <div
                                class="flex justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800">
                                <div class="flex items-center gap-2">
                                    <div class="w-2 h-2 rounded-full bg-indigo-600"></div>
                                    <h3
                                        class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                        Perencanaan Pengadaan (Rendan)
                                    </h3>
                                </div>
                                <Link
                                    :href="route('admin.rendan.edit', paket.enjiniring.rendan.id)"
                                    class="text-xs font-bold text-blue-600 hover:underline transition-colors uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <div
                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                <div class="sm:col-span-2 lg:col-span-1 space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nilai RAB
                                    </p>
                                    <p
                                        class="text-sm font-bold text-gray-900 dark:text-white tracking-tight">
                                        {{ formatIDR(paket.enjiniring.rendan.rab) }}
                                    </p>
                                </div>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Nota Dinas (ND) User
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail Nota Dinas User terkait rencana pengadaan.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor ND User
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ paket.enjiniring.rendan.nomor_nd_user || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal ND
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.tanggal_nd_user
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen ND
                                            </p>

                                            <div v-if="paket.enjiniring.rendan.dokumen_nd_user">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.dokumen_nd_user
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
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Rencana Kerja Syarat (RKS)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail dokumen Rencana Kerja Syarat.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor RKS
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{ paket.enjiniring.rendan.nomor_rks || '-' }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tanggal RKS
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{ formatTgl(paket.enjiniring.rendan.tanggal_rks) }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen RKS
                                            </p>

                                            <div v-if="paket.enjiniring.rendan.dokumen_rks">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.dokumen_rks
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
                        </div>

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
                            <div
                                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-500 border border-gray-300">
                                <svg
                                    class="w-6 h-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>

                            <p class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6">
                                Tahap Rendan belum tersedia
                            </p>

                            <Link
                                v-if="paket.enjiniring"
                                :href="
                                    route('admin.rendan.create', {
                                        enjiniring_id: paket.enjiniring.id
                                    })
                                "
                                class="inline-flex px-8 py-2.5 bg-indigo-600 text-white text-xs font-bold uppercase rounded-full shadow-lg shadow-indigo-100 transition-all hover:bg-indigo-700 hover:scale-105">
                                + Inisiasi Data Rendan
                            </Link>

                            <div
                                v-else
                                class="inline-flex items-center gap-2 px-6 py-2 bg-gray-200 dark:bg-gray-800 text-gray-600 dark:text-gray-500 text-xs font-bold uppercase rounded-full border border-gray-300">
                                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                                    <path
                                        d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z"></path>
                                </svg>

                                Selesaikan Tahap Enjiniring Terlebih Dahulu
                            </div>
                        </div>
                    </section>

                    <section class="relative group">
                        <div
                            :class="[
                                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                                paket.enjiniring?.rendan?.lakdan
                                    ? 'bg-purple-600 text-white'
                                    : 'bg-gray-200 text-gray-500'
                            ]">
                            04
                        </div>

                        <div
                            v-if="paket.enjiniring?.rendan?.lakdan"
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-purple-600">
                            <div
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800 gap-4">
                                <div class="flex items-center gap-4">
                                    <div class="flex items-center gap-2">
                                        <div class="w-2 h-2 rounded-full bg-purple-600"></div>
                                        <h3
                                            class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                            Pelaksanaan Pengadaan (Lakdan)
                                        </h3>
                                    </div>
                                </div>
                                <Link
                                    :href="
                                        route(
                                            'admin.lakdan.edit',
                                            paket.enjiniring.rendan.lakdan.id
                                        )
                                    "
                                    class="text-xs font-bold text-blue-600 hover:underline uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <div
                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Proses Pengadaan
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                        {{ paket.enjiniring.rendan.lakdan.proses_pengadaan || '-' }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Metode Pengadaan
                                    </p>
                                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                                        {{ paket.enjiniring.rendan.lakdan.metode_pengadaan || '-' }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        PIC
                                    </p>
                                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                                        {{ paket.enjiniring.rendan.lakdan.pic || '-' }}
                                    </p>
                                </div>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Harga Perkiraan Sendiri (HPS)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail dokumen Harga Perkiraan Sendiri.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor HPS
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.nomor_hps || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen HPS
                                            </p>

                                            <div v-if="paket.enjiniring.rendan.lakdan.dokumen_hps">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.lakdan
                                                                .dokumen_hps
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
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai HPS
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{
                                                    formatIDR(
                                                        paket.enjiniring.rendan.lakdan.nilai_hps
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl HPS (Rencana)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan
                                                            .rencana_tanggal_hps
                                                    )
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl HPS (Realisasi)
                                            </p>
                                            <p class="text-sm font-bold text-emerald-600">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan
                                                            .realisasi_tanggal_hps
                                                    ) || '-'
                                                }}
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
                                            Pengumuman Lelang
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail jadwal dan nomor Pengumuman Lelang/Tender.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor Pengumuman
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 truncate">
                                                {{
                                                    paket.enjiniring.rendan.lakdan
                                                        .nomor_pengumuman_lelang || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Pengumuman (Rencana)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan
                                                            .rencana_pengumuman_lelang
                                                    )
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Pengumuman (Realisasi)
                                            </p>
                                            <p class="text-sm font-bold text-emerald-600">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan
                                                            .realisasi_pengumuman_lelang
                                                    ) || '-'
                                                }}
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
                                            Tahapan Pelaksanaan Pengadaan
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Detail jadwal dan referensi tahapan pelaksanaan
                                            pengadaan.
                                        </p>
                                    </div>

                                    <div class="space-y-8 mb-8">
                                        <template
                                            v-for="(label, key) in {
                                                persiapan_pengadaan: 'Persiapan Pengadaan',
                                                pengumuman_pengadaan: 'Pengumuman Pengadaan',
                                                pendaftaran_ambil_dokumen:
                                                    'Pendaftaran & Ambil Dokumen',
                                                aanwijzing: 'Aanwijzing',
                                                pemasukan_penawaran: 'Pemasukan Dokumen Penawaran',
                                                pembukaan_evaluasi: 'Pembukaan & Evaluasi',
                                                klarifikasi_negosiasi:
                                                    'Klarifikasi & Negosiasi Harga',
                                                usulan_penetapan_pemenang:
                                                    'Usulan Penetapan Pemenang',
                                                izin_prinsip_kontrak:
                                                    'Izin Prinsip Tanda Tangan Kontrak',
                                                penetapan_pengumuman_pemenang:
                                                    'Penetapan & Pengumuman Pemenang',
                                                sanggah: 'Sanggah',
                                                penunjukan_penyedia:
                                                    'Penunjukan Penyedia Barang/Jasa',
                                                cda: 'Contract Discussion Agreement (CDA)'
                                            }"
                                            :key="key">
                                            <div
                                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-4 gap-x-6 pb-6 border-b border-gray-50 dark:border-gray-600 last:border-0">
                                                <div class="space-y-1">
                                                    <p
                                                        class="text-xs font-bold text-gray-400 uppercase tracking-wider">
                                                        {{ label }}
                                                    </p>
                                                    <p
                                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                        {{
                                                            paket.enjiniring.rendan.lakdan[key] ||
                                                            '-'
                                                        }}
                                                    </p>
                                                </div>

                                                <div class="space-y-1">
                                                    <p
                                                        class="text-xs font-bold text-gray-400 uppercase tracking-wider">
                                                        Tgl. Rencana
                                                    </p>
                                                    <p
                                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                        {{
                                                            formatTgl(
                                                                paket.enjiniring.rendan.lakdan[
                                                                    'rencana_' + key
                                                                ]
                                                            ) || '-'
                                                        }}
                                                    </p>
                                                </div>

                                                <div class="space-y-1">
                                                    <p
                                                        class="text-xs font-bold text-gray-400 uppercase tracking-wider">
                                                        Tgl. Realisasi
                                                    </p>
                                                    <p
                                                        :class="[
                                                            'text-sm font-bold',
                                                            paket.enjiniring.rendan.lakdan[
                                                                'realisasi_' + key
                                                            ]
                                                                ? 'text-emerald-600'
                                                                : 'text-gray-400 italic'
                                                        ]">
                                                        {{
                                                            formatTgl(
                                                                paket.enjiniring.rendan.lakdan[
                                                                    'realisasi_' + key
                                                                ]
                                                            ) || 'Belum Realisasi'
                                                        }}
                                                    </p>
                                                </div>

                                                <div
                                                    v-if="
                                                        key == 'penunjukan_penyedia' &&
                                                        paket.enjiniring.rendan.lakdan
                                                            .dokumen_penunjukan_penyedia
                                                    "
                                                    class="mt-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                                                    <p
                                                        class="text-xs font-bold text-blue-500 uppercase tracking-wider mb-2">
                                                        Dokumen Penunjukan Penyedia
                                                    </p>
                                                    <a
                                                        @click="
                                                            openPdfPreview(
                                                                paket.enjiniring.rendan.lakdan
                                                                    .dokumen_penunjukan_penyedia
                                                            )
                                                        "
                                                        class="inline-flex items-center gap-2 text-sm font-bold text-blue-600 dark:text-blue-400 hover:underline">
                                                        <svg
                                                            class="w-5 h-5 text-rose-500"
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
                                            </div>
                                        </template>
                                    </div>
                                </div>
                            </section>
                        </div>

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
                            <div
                                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-500 border border-gray-300">
                                <svg
                                    class="w-6 h-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>

                            <p class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6">
                                Tahap Pelaksanaan Pengadaan Belum Dimulai
                            </p>

                            <Link
                                v-if="paket.enjiniring?.rendan"
                                :href="
                                    route('admin.lakdan.create', {
                                        rendan_id: paket.enjiniring.rendan.id
                                    })
                                "
                                class="inline-flex px-8 py-2.5 bg-purple-600 text-white text-xs font-bold uppercase rounded-full shadow-lg hover:bg-purple-700 transition-all hover:scale-105">
                                + Mulai Proses Lakdan
                            </Link>
                        </div>
                    </section>

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
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800 gap-4">
                                <div class="flex items-center gap-4">
                                    <div class="flex items-center gap-2">
                                        <div class="w-2.5 h-2.5 rounded-full bg-emerald-600"></div>
                                        <h3
                                            class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                            Dokumen Kontrak (Perjanjian)
                                        </h3>
                                    </div>
                                </div>
                                <Link
                                    :href="
                                        route(
                                            'admin.kontrak.edit',
                                            paket.enjiniring.rendan.lakdan.kontrak.id
                                        )
                                    "
                                    class="text-xs font-bold text-blue-600 hover:underline uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Detail Perjanjian (Kontrak)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Tanggal, nomor, nilai, dan dokumen perjanjian.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nomor Perjanjian
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .nomor_perjanjian
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai (Inc. PPN)
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{
                                                    formatIDR(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .nilai_perjanjian_ppn
                                                    )
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai (Excl. PPN)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatIDR(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .nilai_perjanjian_sebelum_ppn
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Berakhir Kontrak
                                            </p>
                                            <p class="text-sm font-bold text-emerald-600">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .tanggal_berakhir
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen Kontrak
                                            </p>

                                            <div
                                                v-if="
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .dokumen_perjanjian
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
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Detail Jaminan Pelaksanaan
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Informasi mengenai jaminan pelaksanaan kontrak.
                                        </p>
                                    </div>
                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Nilai Jaminan Pelaksanaan
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white">
                                                {{
                                                    formatIDR(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .nilai_jaminan_pelaksanaan
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Bank Pemberi Jaminan
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .bank_pemberi_jaminan || '-'
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Metrik dan Keterangan Tambahan
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Informasi mengenai risiko, TKDN, dan efisiensi.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-8 gap-x-6 mb-8">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
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
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Jenis Perjanjian
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .jenis_perjanjian || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Status Proses
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .status_proses
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Durasi Pengadaan
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white leading-tight">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .durasi_pengadaan
                                                }}
                                                Hari
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Masa Pelaksanaan
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .masa_pelaksanaan
                                                }}
                                                Hari
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                TKDN
                                            </p>
                                            <p class="text-sm font-bold text-emerald-600">
                                                {{ paket.enjiniring.rendan.lakdan.kontrak.tkdn }}%
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Efisiensi HPS
                                            </p>
                                            <p class="text-sm font-semibold text-emerald-600">
                                                {{
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .efisiensi_thd_hps || '-'
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Risiko CSMS
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
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

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
                            <div
                                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-500 border border-gray-300">
                                <svg
                                    class="w-6 h-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>

                            <p
                                class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6 italic">
                                Proses Pengadaan Selesai. Menunggu Input Dokumen Kontrak
                                (Perjanjian).
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

                    <section class="relative group">
                        <div
                            :class="[
                                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                                paket.enjiniring?.rendan?.lakdan?.kontrak?.purchase_order
                                    ? 'bg-orange-600 text-white'
                                    : 'bg-gray-200 text-gray-500'
                            ]">
                            06
                        </div>

                        <div
                            v-if="paket.enjiniring?.rendan?.lakdan?.kontrak?.purchase_order"
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-orange-600">
                            <div
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800 gap-4">
                                <div class="flex items-center gap-2">
                                    <div
                                        class="w-2.5 h-2.5 rounded-full bg-orange-600 animate-pulse"></div>
                                    <h3
                                        class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                        Pelaksanaan (PO & Fisik)
                                    </h3>
                                </div>
                                <Link
                                    :href="
                                        route(
                                            'admin.po.edit',
                                            paket.enjiniring.rendan.lakdan.kontrak.purchase_order.id
                                        )
                                    "
                                    class="text-xs font-bold text-blue-600 hover:underline uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Purchase Order (PO) & Material On Site (MOS)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Tanggal rencana dan realisasi untuk PO dan Material On
                                            Site.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-10 gap-x-6 mb-10">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl PO (Rencana)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.rencana_po
                                                    )
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl PO (Realisasi)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.realisasi_po
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen PO
                                            </p>

                                            <div
                                                v-if="
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .purchase_order.dokumen_po
                                                ">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order.dokumen_po
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

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl MOS (Rencana)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.rencana_mos
                                                    )
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl MOS (Realisasi)
                                            </p>
                                            <p
                                                class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.realisasi_mos
                                                    )
                                                }}
                                            </p>
                                        </div>

                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen MOS
                                            </p>

                                            <div
                                                v-if="
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .purchase_order.dokumen_pemeriksaan_mos
                                                ">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order
                                                                .dokumen_pemeriksaan_mos
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
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Pelacakan Progres 25%, 50%, dan 75%
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Tanggal rencana dan realisasi untuk setiap tahapan
                                            progres.
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                                        <template v-for="step in ['25', '50', '75']" :key="step">
                                            <div class="space-y-1">
                                                <p
                                                    class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Rencana Tgl {{ step }}%
                                                </p>
                                                <p
                                                    :class="[
                                                        'text-sm font-bold',
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order[
                                                            `rencana_progress_${step}`
                                                        ]
                                                            ? 'text-emerald-600'
                                                            : 'text-gray-400 italic'
                                                    ]">
                                                    {{
                                                        formatTgl(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order[
                                                                `rencana_progress_${step}`
                                                            ]
                                                        ) || 'Belum'
                                                    }}
                                                </p>
                                            </div>
                                            <div class="space-y-1">
                                                <p
                                                    class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    Realisasi Tgl {{ step }}%
                                                </p>
                                                <p
                                                    :class="[
                                                        'text-sm font-bold',
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order[
                                                            `realisasi_progress_${step}`
                                                        ]
                                                            ? 'text-emerald-600'
                                                            : 'text-gray-400 italic'
                                                    ]">
                                                    {{
                                                        formatTgl(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order[
                                                                `realisasi_progress_${step}`
                                                            ]
                                                        ) || 'Belum'
                                                    }}
                                                </p>
                                            </div>

                                            <div class="space-y-1">
                                                <p
                                                    class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    BA Pemeriksaan {{ step }}%
                                                </p>

                                                <div
                                                    v-if="
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order[
                                                            `ba_pemeriksaan_${step}`
                                                        ]
                                                    ">
                                                    <a
                                                        @click="
                                                            openPdfPreview(
                                                                paket.enjiniring.rendan.lakdan
                                                                    .kontrak.purchase_order[
                                                                    `ba_pemeriksaan_${step}`
                                                                ]
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
                                            <div class="space-y-1">
                                                <p
                                                    class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                    BA Pembayaran {{ step }}%
                                                </p>
                                                <div
                                                    v-if="
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order[`ba_pembayaran_${step}`]
                                                    ">
                                                    <a
                                                        @click="
                                                            openPdfPreview(
                                                                paket.enjiniring.rendan.lakdan
                                                                    .kontrak.purchase_order[
                                                                    `ba_pembayaran_${step}`
                                                                ]
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
                                        </template>
                                    </div>
                                </div>
                            </section>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Commercial Operation Date (COD)
                                        </h3>
                                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                            Tanggal rencana dan realisasi untuk COD (Serah Terima
                                            Pekerjaan/Aset).
                                        </p>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Rencana Tgl (COD)
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white uppercase">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.rencana_cod
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Realisasi Tgl (COD)
                                            </p>
                                            <p
                                                class="text-sm font-bold text-gray-900 dark:text-white uppercase">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .purchase_order.realisasi_cod
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen BA STP
                                            </p>

                                            <div
                                                v-if="
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .purchase_order.ba_stp
                                                ">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order.ba_stp
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
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Dokumen BA STAP
                                            </p>

                                            <div
                                                v-if="
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .purchase_order.ba_stap
                                                ">
                                                <a
                                                    @click="
                                                        openPdfPreview(
                                                            paket.enjiniring.rendan.lakdan.kontrak
                                                                .purchase_order.ba_stap
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

                            <div
                                class="mt-6 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-gray-200 dark:border-gray-700">
                                <p
                                    class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed italic">
                                    <span
                                        class="font-bold text-orange-600 not-italic mr-1 uppercase">
                                        Catatan:
                                    </span>
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak.purchase_order
                                            .keterangan || '-'
                                    }}
                                </p>
                            </div>
                        </div>

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
                            <div
                                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-600 border border-gray-300">
                                <svg
                                    class="w-6 h-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>

                            <p
                                class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6 italic">
                                Kontrak Terbit. Menunggu Inisiasi Purchase Order & Progres Fisik.
                            </p>

                            <Link
                                v-if="paket.enjiniring?.rendan?.lakdan?.kontrak"
                                :href="
                                    route('admin.po.create', {
                                        kontrak_id: paket.enjiniring.rendan.lakdan.kontrak.id
                                    })
                                "
                                class="inline-flex px-8 py-2.5 bg-orange-600 text-white text-xs font-bold uppercase rounded-full shadow-lg hover:bg-orange-700 transition-all hover:scale-105">
                                + Inisiasi Progres Lapangan
                            </Link>

                            <p
                                v-else
                                class="text-xs font-bold text-gray-600 dark:text-gray-500 uppercase tracking-widest border border-gray-300 px-4 py-2 rounded-full inline-block">
                                Menunggu Tahap Kontrak
                            </p>
                        </div>
                    </section>

                    <section class="relative group">
                        <div
                            :class="[
                                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                                paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran
                                    ? 'bg-rose-600 text-white'
                                    : 'bg-gray-200 text-gray-500'
                            ]">
                            07
                        </div>

                        <div
                            v-if="paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran"
                            class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-rose-600">
                            <div
                                class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800 gap-4">
                                <div class="flex items-center gap-4">
                                    <div class="flex items-center gap-2">
                                        <div class="w-2.5 h-2.5 rounded-full bg-rose-600"></div>
                                        <h3
                                            class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                            Informasi Pembayaran
                                        </h3>
                                    </div>
                                </div>
                                <Link
                                    :href="
                                        route(
                                            'admin.pembayaran.edit',
                                            paket.enjiniring.rendan.lakdan.kontrak.pembayaran.id
                                        )
                                    "
                                    class="text-xs font-bold text-blue-600 hover:underline uppercase">
                                    PERBARUI DATA
                                </Link>
                            </div>

                            <div
                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Termin Pembayaran
                                    </p>
                                    <p class="text-sm font-semibold text-gray-900 dark:text-white">
                                        {{
                                            paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                .termin_pembayaran
                                        }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Denda
                                    </p>
                                    <p
                                        :class="[
                                            'text-sm font-bold',
                                            paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                .denda > 0
                                                ? 'text-rose-600'
                                                : 'text-gray-400'
                                        ]">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .denda
                                            ) || 'Rp 0'
                                        }}
                                    </p>
                                </div>
                            </div>

                            <div
                                class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Total Nilai Tagihan
                                    </p>
                                    <p class="text-xl font-bold text-gray-900 dark:text-white">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_tagihan
                                            )
                                        }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nilai AKB
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_akb
                                            )
                                        }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nilai Bayar Vendor
                                    </p>
                                    <p class="text-lg font-bold text-emerald-600">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_bayar_vendor
                                            )
                                        }}
                                    </p>
                                </div>

                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Pajak PPN
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_ppn
                                            ) || 'Rp 0'
                                        }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Pajak PPH
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_pph
                                            ) || 'Rp 0'
                                        }}
                                    </p>
                                </div>
                                <div class="space-y-1">
                                    <p
                                        class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                        Nilai Bayar Pajak
                                    </p>
                                    <p
                                        class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                        {{
                                            formatIDR(
                                                paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                                    .nilai_bayar_pajak
                                            ) || 'Rp 0'
                                        }}
                                    </p>
                                </div>
                            </div>

                            <section class="dark:bg-gray-700">
                                <div class="max-w-4xl space-y-6">
                                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                                        <h3
                                            class="text-xl font-semibold text-gray-900 dark:text-white">
                                            Tanggal Rencana & Realisasi Pembayaran
                                        </h3>
                                    </div>

                                    <div
                                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Bayar Vendor (Rencana)
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .pembayaran.rencana_bayar
                                                        ? 'text-emerald-600'
                                                        : 'text-gray-400 italic'
                                                ]">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .pembayaran.rencana_bayar
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Bayar Vendor (Realisasi)
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .pembayaran.realisasi_bayar
                                                        ? 'text-emerald-600'
                                                        : 'text-gray-400 italic'
                                                ]">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .pembayaran.realisasi_bayar
                                                    ) || 'Menunggu Transfer'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Bayar Pajak (Rencana)
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .pembayaran.rencana_bayar_pajak
                                                        ? 'text-emerald-600'
                                                        : 'text-gray-400 italic'
                                                ]">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .pembayaran.rencana_bayar_pajak
                                                    ) || '-'
                                                }}
                                            </p>
                                        </div>
                                        <div class="space-y-1">
                                            <p
                                                class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                                Tgl Bayar Pajak (Realisasi)
                                            </p>
                                            <p
                                                :class="[
                                                    'text-sm font-bold',
                                                    paket.enjiniring.rendan.lakdan.kontrak
                                                        .pembayaran.realisasi_bayar_pajak
                                                        ? 'text-emerald-600'
                                                        : 'text-gray-400 italic'
                                                ]">
                                                {{
                                                    formatTgl(
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .pembayaran.realisasi_bayar_pajak
                                                    ) || 'Belum Setor'
                                                }}
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
                                            Status Dokumen / Checklist
                                        </h3>
                                    </div>

                                    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                                        <div v-for="field in checklistFields" :key="field.key">
                                            <label
                                                class="flex items-center space-x-2 cursor-pointer">
                                                <input
                                                    type="checkbox"
                                                    :id="field.key"
                                                    v-model="
                                                        paket.enjiniring.rendan.lakdan.kontrak
                                                            .pembayaran[field.key]
                                                    "
                                                    :true-value="1"
                                                    :false-value="0"
                                                    class="rounded border-gray-300 text-indigo-600 shadow-sm focus:ring-indigo-500 dark:bg-gray-800 dark:border-gray-600 dark:checked:bg-indigo-600" />
                                                <span
                                                    class="text-sm font-medium text-gray-700 dark:text-gray-300">
                                                    {{ field.label }}
                                                </span>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <div
                                class="mt-10 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-gray-200 dark:border-gray-700">
                                <p
                                    class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed italic">
                                    <span class="font-bold text-rose-600 not-italic mr-1 uppercase">
                                        Catatan:
                                    </span>
                                    {{
                                        paket.enjiniring.rendan.lakdan.kontrak.pembayaran
                                            .keterangan || '-'
                                    }}
                                </p>
                            </div>
                        </div>

                        <div
                            v-else
                            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
                            <div
                                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-600 border border-gray-300 shadow-inner">
                                <svg
                                    class="w-6 h-6"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>

                            <p
                                class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6 italic">
                                Progres Lapangan Terverifikasi. Menunggu Input Realisasi Pembayaran.
                            </p>

                            <Link
                                v-if="paket.enjiniring?.rendan?.lakdan?.kontrak"
                                :href="
                                    route('admin.pembayaran.create', {
                                        kontrak_id: paket.enjiniring.rendan.lakdan.kontrak.id
                                    })
                                "
                                class="inline-flex px-8 py-2.5 bg-rose-600 text-white text-xs font-bold uppercase rounded-full shadow-lg hover:bg-rose-700 transition-all hover:scale-105">
                                + Input Data Pembayaran
                            </Link>

                            <p
                                v-else
                                class="text-xs font-bold text-gray-600 dark:text-gray-500 uppercase tracking-widest border border-gray-300 px-4 py-2 rounded-full inline-block">
                                Menunggu Tahap Kontrak
                            </p>
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
