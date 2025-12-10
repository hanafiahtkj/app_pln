<script setup>
import { Head, usePage } from '@inertiajs/vue3'
import { computed, ref } from 'vue'
import Default from '../Layouts/Default.vue'
import StockWidget from '@/Components/Widgets/StockWidget.vue'
import StatWidget from '@/Components/Widgets/StatWidget.vue'
import ProgressWidget from '@/Components/Widgets/ProgressWidget.vue'
import ChartWidget from '@/Components/Widgets/ChartWidget.vue'

defineOptions({
    layout: Default
})

// --- DATA DEMO 10 BARIS (DIPERTAHANKAN) ---
const demoDashboardData = [
    // 1. Proyek Selesai & Terbayar Penuh (Berdasarkan Snippet)
    {
        No: 1,
        TAHUN: 2025,
        PRK: '2025.P3BK.4.001',
        'URAIAN PAKET': 'Pekerjaan Uprating Konduktor Busbar Gardu Induk',
        UNIT: 'UIP3B Kalimantan',
        KKP: '2025-01-15',
        Risk: '2025-01-20',
        GRC: '2025-01-25',
        TVV: '2025-02-01',
        SKAI: '2025-02-10',
        SKKI: '2025-02-15',
        Survey: '2025-02-27',
        'TOR & HPE': '2025-03-14',
        RKS: '2025-03-21',
        'ND User': '2025-03-23',
        HPS: '2025-04-06',
        Lelang: '2025-04-13',
        'Penunjukan Pemenang': '2025-05-04',
        Perjanjian: '2025-05-11',
        'Bank Garansi': '2025-05-25',
        'Efektif Kontrak': '2025-05-26',
        PO: '2025-06-11',
        MOS: '2025-10-09',
        0.25: '2025-07-20',
        0.5: '2025-08-25',
        0.75: '2025-09-30',
        1: '2025-11-05',
        'Terbayar Tahun Ini': 2702033.23,
        Keterangan: 'Proyek Selesai. Pembayaran 100% tuntas.'
    },
    // 2. Proyek Dalam Tahap Perencanaan Awal
    {
        No: 2,
        TAHUN: 2026,
        PRK: '2026.P3BK.1.015',
        'URAIAN PAKET': 'Pengadaan dan Pemasangan Proteksi Petir',
        UNIT: 'UPT Pontianak',
        KKP: '2025-11-01',
        Risk: '2025-11-15',
        GRC: '2025-11-20',
        TVV: '2025-12-05',
        SKAI: '2025-12-10',
        SKKI: '2025-12-20',
        Survey: '',
        'TOR & HPE': '',
        RKS: '',
        'ND User': '',
        HPS: '',
        Lelang: '',
        'Penunjukan Pemenang': '',
        Perjanjian: '',
        'Bank Garansi': '',
        'Efektif Kontrak': '',
        PO: '',
        MOS: '',
        0.25: '',
        0.5: '',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 0,
        Keterangan: 'Menunggu hasil Survey lapangan.'
    },
    // 3. Proyek Dalam Tahap Lelang
    {
        No: 3,
        TAHUN: 2025,
        PRK: '2025.P3BK.3.007',
        'URAIAN PAKET': 'Pekerjaan Upgrade Sistem SCADA GI',
        UNIT: 'UPT Balikpapan',
        KKP: '2025-02-01',
        Risk: '2025-02-10',
        GRC: '2025-02-15',
        TVV: '2025-03-01',
        SKAI: '2025-03-05',
        SKKI: '2025-03-10',
        Survey: '2025-03-20',
        'TOR & HPE': '2025-04-01',
        RKS: '2025-04-10',
        'ND User': '2025-04-12',
        HPS: '2025-04-20',
        Lelang: '2025-05-01',
        'Penunjukan Pemenang': '',
        Perjanjian: '',
        'Bank Garansi': '',
        'Efektif Kontrak': '',
        PO: '',
        MOS: '',
        0.25: '',
        0.5: '',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 0,
        Keterangan: 'Proses Evaluasi dokumen penawaran.'
    },
    // 4. Proyek Menunggu PO
    {
        No: 4,
        TAHUN: 2025,
        PRK: '2025.P3BK.4.008',
        'URAIAN PAKET': 'Pembangunan Feeder Line 20kV Baru',
        UNIT: 'UPT Palangkaraya',
        KKP: '2025-01-05',
        Risk: '2025-01-10',
        GRC: '2025-01-15',
        TVV: '2025-01-20',
        SKAI: '2025-01-25',
        SKKI: '2025-01-30',
        Survey: '2025-02-15',
        'TOR & HPE': '2025-03-01',
        RKS: '2025-03-10',
        'ND User': '2025-03-12',
        HPS: '2025-04-01',
        Lelang: '2025-04-15',
        'Penunjukan Pemenang': '2025-05-10',
        Perjanjian: '2025-05-25',
        'Bank Garansi': '2025-06-05',
        'Efektif Kontrak': '2025-06-10',
        PO: '',
        MOS: '',
        0.25: '',
        0.5: '',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 0,
        Keterangan: 'Kontrak sudah efektif. Menunggu penerbitan PO.'
    },
    // 5. Proyek Tahap Eksekusi (Progress 25%)
    {
        No: 5,
        TAHUN: 2025,
        PRK: '2025.P3BK.2.012',
        'URAIAN PAKET': 'Pengadaan Spare Part Trafo Daya 150 kV',
        UNIT: 'UPT Samarinda',
        KKP: '2025-03-01',
        Risk: '2025-03-05',
        GRC: '2025-03-10',
        TVV: '2025-03-15',
        SKAI: '2025-03-20',
        SKKI: '2025-03-25',
        Survey: '2025-04-01',
        'TOR & HPE': '2025-04-10',
        RKS: '2025-04-20',
        'ND User': '2025-04-25',
        HPS: '2025-05-05',
        Lelang: '2025-05-20',
        'Penunjukan Pemenang': '2025-06-15',
        Perjanjian: '2025-07-01',
        'Bank Garansi': '2025-07-15',
        'Efektif Kontrak': '2025-07-20',
        PO: '2025-08-01',
        MOS: '2026-01-30',
        0.25: '2025-10-01',
        0.5: '',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 45000000.0,
        Keterangan: 'Progress fisik 25% telah dibayar.'
    },
    // 6. Proyek Tahap Eksekusi (Progress 75%)
    {
        No: 6,
        TAHUN: 2025,
        PRK: '2025.P3BK.4.002',
        'URAIAN PAKET': 'Revitalisasi Proteksi Jaringan Transmisi SUTT 150kV',
        UNIT: 'UIP3B Kalimantan',
        KKP: '2024-12-10',
        Risk: '2024-12-15',
        GRC: '2024-12-20',
        TVV: '2025-01-05',
        SKAI: '2025-01-10',
        SKKI: '2025-01-15',
        Survey: '2025-01-25',
        'TOR & HPE': '2025-02-10',
        RKS: '2025-02-20',
        'ND User': '2025-02-22',
        HPS: '2025-03-10',
        Lelang: '2025-03-25',
        'Penunjukan Pemenang': '2025-04-20',
        Perjanjian: '2025-05-05',
        'Bank Garansi': '2025-05-15',
        'Efektif Kontrak': '2025-05-20',
        PO: '2025-06-01',
        MOS: '2025-11-20',
        0.25: '2025-07-01',
        0.5: '2025-08-15',
        0.75: '2025-10-10',
        1: '',
        'Terbayar Tahun Ini': 800000000.0,
        Keterangan: 'Telah mencapai progress 75%. Finalisasi pekerjaan.'
    },
    // 7. Proyek Terlambat (Semua Tahap Terisi)
    {
        No: 7,
        TAHUN: 2024,
        PRK: '2024.P3BK.4.010',
        'URAIAN PAKET': 'Pengadaan dan Pemasangan Busbar Proteksi GI Baru',
        UNIT: 'UPT Pontianak',
        KKP: '2024-03-01',
        Risk: '2024-03-15',
        GRC: '2024-03-20',
        TVV: '2024-04-05',
        SKAI: '2024-04-10',
        SKKI: '2024-04-15',
        Survey: '2024-05-01',
        'TOR & HPE': '2024-05-20',
        RKS: '2024-06-01',
        'ND User': '2024-06-05',
        HPS: '2024-06-25',
        Lelang: '2024-07-15',
        'Penunjukan Pemenang': '2024-08-10',
        Perjanjian: '2024-09-01',
        'Bank Garansi': '2024-09-10',
        'Efektif Kontrak': '2024-09-15',
        PO: '2024-10-01',
        MOS: '2025-02-01',
        0.25: '2024-11-15',
        0.5: '2025-01-05',
        0.75: '2025-02-15',
        1: '2025-04-01',
        'Terbayar Tahun Ini': 120000000.0, // Bayar sisa
        Keterangan: 'Tuntas, namun realisasi COD terlambat 2 bulan.'
    },
    // 8. Proyek Baru (Hanya Perencanaan)
    {
        No: 8,
        TAHUN: 2026,
        PRK: '2026.P3BK.4.011',
        'URAIAN PAKET': 'Pengadaan dan Pemasangan Supply DC UPT Balikpapan',
        UNIT: 'UPT Balikpapan',
        KKP: '2025-12-01',
        Risk: '2025-12-10',
        GRC: '2025-12-15',
        TVV: '',
        SKAI: '',
        SKKI: '',
        Survey: '',
        'TOR & HPE': '',
        RKS: '',
        'ND User': '',
        HPS: '',
        Lelang: '',
        'Penunjukan Pemenang': '',
        Perjanjian: '',
        'Bank Garansi': '',
        'Efektif Kontrak': '',
        PO: '',
        MOS: '',
        0.25: '',
        0.5: '',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 0,
        Keterangan: 'Tahap awal RKP. Belum ada dokumen teknis.'
    },
    // 9. Proyek Cepat (Nilai Rendah)
    {
        No: 9,
        TAHUN: 2025,
        PRK: '2025.P3BK.1.005',
        'URAIAN PAKET': 'Jasa Perbaikan Minor Kontrol GI',
        UNIT: 'UP2B Kaltimra',
        KKP: '2025-08-01',
        Risk: '2025-08-02',
        GRC: '2025-08-03',
        TVV: '2025-08-05',
        SKAI: '2025-08-07',
        SKKI: '2025-08-08',
        Survey: '2025-08-10',
        'TOR & HPE': '2025-08-15',
        RKS: '2025-08-20',
        'ND User': '2025-08-21',
        HPS: '2025-08-25',
        Lelang: '2025-09-01',
        'Penunjukan Pemenang': '2025-09-10',
        Perjanjian: '2025-09-15',
        'Bank Garansi': '2025-09-18',
        'Efektif Kontrak': '2025-09-20',
        PO: '2025-09-25',
        MOS: '2025-10-25',
        0.25: '2025-10-05',
        0.5: '2025-10-15',
        0.75: '2025-10-20',
        1: '2025-11-01',
        'Terbayar Tahun Ini': 15000000.0,
        Keterangan: 'Proyek sederhana dengan durasi cepat.'
    },
    // 10. Proyek Nilai Tinggi (Progress 50%)
    {
        No: 10,
        TAHUN: 2026,
        PRK: '2026.P3BK.4.069',
        'URAIAN PAKET': 'Penguatan Defense Scheme Kalimantan (Multi-Year)',
        UNIT: 'UP2B Kaltimra',
        KKP: '2025-01-01',
        Risk: '2025-01-10',
        GRC: '2025-01-20',
        TVV: '2025-02-05',
        SKAI: '2025-02-15',
        SKKI: '2025-02-25',
        Survey: '2025-03-10',
        'TOR & HPE': '2025-04-01',
        RKS: '2025-04-20',
        'ND User': '2025-04-25',
        HPS: '2025-05-15',
        Lelang: '2025-06-01',
        'Penunjukan Pemenang': '2025-07-01',
        Perjanjian: '2025-08-01',
        'Bank Garansi': '2025-08-15',
        'Efektif Kontrak': '2025-08-20',
        PO: '2025-09-01',
        MOS: '2026-08-30',
        0.25: '2025-11-01',
        0.5: '2026-02-01',
        0.75: '',
        1: '',
        'Terbayar Tahun Ini': 3500000000.0,
        Keterangan: 'Proyek tahun jamak, progress 50% di Q1 2026.'
    }
]
// --- AKHIR DATA DEMO ---

const props = defineProps({
    stats: {
        type: Array,
        required: true,
        default: () => []
    },
    // PROPS: Untuk data status proyek
    dashboardData: {
        type: Array,
        required: true
        // Gunakan data demo sebagai default agar tampilan kartu terlihat
        // default: () => demoDashboardData
    }
})

// --- Logic Tabel Expandable ---
// Array untuk melacak Nomor (No) proyek yang sedang di-expand
const expandedRows = ref([])

const isExpanded = no => {
    return expandedRows.value.includes(no)
}

const toggleExpand = no => {
    const index = expandedRows.value.indexOf(no)
    if (index > -1) {
        // Jika sudah ada, hapus (collapse)
        expandedRows.value.splice(index, 1)
    } else {
        // Jika belum ada, tambahkan (expand)
        expandedRows.value.push(no)
    }
}
// --- Akhir Logic Tabel Expandable ---

const page = usePage()
const userName = computed(() => page.props.auth.user?.name || 'User')

// ... (sisanya fungsi computed, greeting, formatRupiah, icons, stocks tetap sama)

const formattedDate = computed(() => {
    const date = new Date()
    return {
        display: date.toLocaleDateString('id-ID', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        }),
        mobileDisplay: date.toLocaleDateString('id-ID', {
            month: '2-digit',
            day: '2-digit'
        }),
        dayOfWeek: date.toLocaleDateString('id-ID', { weekday: 'short' })
    }
})

const greeting = computed(() => {
    const hour = new Date().getHours()
    if (hour < 12) return 'Selamat Pagi'
    if (hour < 17) return 'Selamat Siang/Sore'
    return 'Selamat Malam'
})

// Fungsi untuk format rupiah (untuk kolom Terbayar Tahun Ini)
const formatRupiah = value => {
    const numericValue = parseFloat(value)

    if (
        isNaN(numericValue) ||
        numericValue === 0 ||
        numericValue === null ||
        numericValue === undefined
    ) {
        return 'Rp 0'
    }
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(numericValue)
}

const icons = {
    revenue: '<path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/>',
    users: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
    performance: '<path d="M12 20V10"/><path d="M18 20V4"/><path d="M6 20v-4"/>',
    projects: '<path d="M22 19a2 2 0 01-2 2H4a2 2 0 01-2-2V5a2 2 0 012-2h5l2 3h9a2 2 0 012 2z"/>',
    tasks: '<path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h11"/>',
    chevronRight: '<path d="M9 5l7 7-7 7" />',
    checkCircle: '<path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />',
    clock: '<path d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />',
    info: '<path d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />'
}

const stocks = ref([
    {
        symbol: 'AAPL',
        name: 'Apple, Inc',
        price: '173.25',
        change: 0.86,
        icon: 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg',
        bgColor: 'gray'
    },
    {
        symbol: 'PYPL',
        name: 'Paypal, Inc',
        price: '65.23',
        change: -1.42,
        icon: 'https://upload.wikimedia.org/wikipedia/commons/b/b5/PayPal.svg',
        bgColor: 'blue'
    },
    {
        symbol: 'TSLA',
        name: 'Tesla, Inc',
        price: '241.53',
        change: 2.76,
        icon: 'https://upload.wikimedia.org/wikipedia/commons/e/e8/Tesla_logo.png',
        bgColor: 'red'
    },
    {
        symbol: 'HPQ',
        name: 'HP Inc',
        price: '29.78',
        change: 0.95,
        icon: 'https://logodownload.org/wp-content/uploads/2014/04/hp-logo-1.png',
        bgColor: 'blue'
    }
])

// Ikon untuk indikator status (bisa diganti dengan Heroicons)

// Fungsi bantu untuk menentukan status dan warna ikon
const getStatusIcon = date => {
    // Mengecek apakah tanggal terisi dan bukan string kosong/hyphen
    if (date && date !== '-' && date !== '') {
        return {
            icon: icons.checkCircle,
            color: 'text-green-500'
        }
    }
    // Jika kosong atau belum terisi
    return {
        icon: icons.clock,
        color: 'text-yellow-500'
    }
}
</script>

<template>
    <Head title="Dashboard" />

    <main class="min-h-screen">
        <div class="max-w-6xl mx-auto">
            <header
                class="mb-6 sm:mb-8 lg:mb-10 bg-gradient-to-r from-[var(--color-surface)] to-[var(--color-surface-muted)] rounded-lg border border-[var(--color-border)] shadow-xs p-6 sm:p-8">
                <div
                    class="flex flex-col sm:flex-row sm:items-start sm:justify-between gap-4 sm:gap-6">
                    <div class="flex-1">
                        <h1 class="text-3xl sm:text-4xl font-bold text-[var(--color-text)] mb-2">
                            {{ greeting }}, {{ userName }}
                        </h1>
                        <p class="text-sm sm:text-base text-[var(--color-text-muted)]">
                            Berikut adalah ringkasan status Anda hari ini.
                        </p>
                    </div>
                    <time
                        class="flex items-center gap-3 text-xs sm:text-sm font-medium text-[var(--color-text-muted)] bg-[var(--color-surface)] px-4 py-2.5 rounded-lg border border-[var(--color-border)] whitespace-nowrap">
                        <svg
                            class="w-4 h-4 flex-shrink-0"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor">
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        <div>
                            <div class="hidden sm:block font-semibold text-[var(--color-text)]">
                                {{ formattedDate.display }}
                            </div>
                            <div class="sm:hidden">
                                {{ formattedDate.dayOfWeek }} {{ formattedDate.mobileDisplay }}
                            </div>
                        </div>
                    </time>
                </div>
            </header>

            <section class="mb-10">
                <h2
                    class="text-xl font-bold text-[var(--color-text)] mb-4 border-b pb-2 border-[var(--color-border-muted)]">
                    Monitoring Proses Anggaran
                </h2>

                <div
                    class="bg-[var(--color-surface)] border border-[var(--color-border)] rounded-xl overflow-x-auto transition-all duration-300">
                    <table class="min-w-full divide-y divide-[var(--color-border-muted)]">
                        <thead class="bg-[var(--color-surface-muted)]">
                            <tr>
                                <th
                                    scope="col"
                                    class="py-3 pl-6 pr-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] sm:pl-8 w-16">
                                    Paket #
                                </th>
                                <th
                                    scope="col"
                                    class="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] min-w-96">
                                    Uraian Paket & Lokasi
                                </th>
                                <th
                                    scope="col"
                                    class="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] w-28">
                                    Progress Bayar
                                </th>
                                <th
                                    scope="col"
                                    class="px-3 py-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] w-48">
                                    Keterangan Status
                                </th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-[var(--color-border-muted)]">
                            <template
                                v-for="(item, index) in demoDashboardData"
                                :key="item.No || index">
                                <tr
                                    class="group hover:bg-[var(--color-surface-hover)] cursor-pointer transition-colors duration-150"
                                    @click="toggleExpand(item.No)">
                                    <td
                                        class="whitespace-nowrap py-4 pl-6 pr-3 text-sm font-medium text-[var(--color-text)] sm:pl-8">
                                        <button class="flex items-center gap-2 font-mono text-xs">
                                            <svg
                                                class="w-4 h-4 text-indigo-500 transition-transform duration-300 transform"
                                                :class="{ 'rotate-90': isExpanded(item.No) }"
                                                fill="none"
                                                viewBox="0 0 24 24"
                                                stroke="currentColor"
                                                stroke-width="2"
                                                v-html="icons.chevronRight"></svg>
                                            {{ item.TAHUN }}/{{ item.No }}
                                        </button>
                                    </td>
                                    <td class="px-3 py-4 text-sm text-[var(--color-text)]">
                                        <div
                                            class="font-semibold text-[var(--color-text)] leading-snug">
                                            {{ item['URAIAN PAKET'] }}
                                        </div>
                                        <div class="text-xs text-[var(--color-text-muted)] mt-0.5">
                                            {{ item.UNIT || 'N/A' }} | PRK:
                                            <span class="font-mono text-xs">{{ item.PRK }}</span>
                                        </div>
                                    </td>
                                    <td
                                        class="whitespace-nowrap px-3 py-4 text-sm font-bold"
                                        :class="
                                            item['Terbayar Tahun Ini'] > 0
                                                ? 'text-green-600'
                                                : 'text-[var(--color-text-muted)]'
                                        ">
                                        {{ formatRupiah(item['Terbayar Tahun Ini']) }}
                                    </td>
                                    <td class="px-3 py-4 text-sm text-[var(--color-text-muted)]">
                                        <p class="line-clamp-2">
                                            {{ item.Keterangan || 'Tidak ada keterangan.' }}
                                        </p>
                                    </td>
                                </tr>

                                <tr
                                    v-if="isExpanded(item.No)"
                                    class="bg-[var(--color-surface-muted)]/30 transition-all duration-300">
                                    <td :colspan="5" class="p-0">
                                        <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
                                            <div
                                                class="space-y-4 p-4 rounded-lg border border-[var(--color-border)] shadow-sm bg-[var(--color-surface)]">
                                                <div
                                                    class="text-sm font-bold text-indigo-600 border-b border-[var(--color-border-muted)] pb-2 mb-2">
                                                    Dokumen Awal & Perencanaan
                                                </div>
                                                <div
                                                    class="divide-y divide-[var(--color-border-muted)] space-y-2">
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            KKP/Risk/GRC/TVV
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{
                                                                (item.KKP || '-') +
                                                                ' | ' +
                                                                (item.Risk || '-') +
                                                                ' | ' +
                                                                (item.GRC || '-') +
                                                                ' | ' +
                                                                (item.TVV || '-')
                                                            }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            SKAI/SKKI/Survey
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{
                                                                (item.SKAI || '-') +
                                                                ' | ' +
                                                                (item.SKKI || '-') +
                                                                ' | ' +
                                                                (item.Survey || '-')
                                                            }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            TOR & HPE
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['TOR & HPE'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            ND User
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['ND User'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            RKS
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.RKS || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="text-sm font-medium text-[var(--color-text-muted)]">
                                                            HPS
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.HPS || '-' }}
                                                        </span>
                                                    </div>
                                                </div>

                                                <div
                                                    class="text-sm font-bold text-pink-600 border-b border-[var(--color-border-muted)] pt-4 pb-2 mb-2">
                                                    Proses Pengadaan
                                                </div>
                                                <div
                                                    class="divide-y divide-[var(--color-border-muted)] space-y-2">
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Lelang
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.Lelang || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Penunjukan Pemenang
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['Penunjukan Pemenang'] || '-' }}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div
                                                class="space-y-4 p-4 rounded-lg border border-[var(--color-border)] shadow-sm bg-[var(--color-surface)]">
                                                <div
                                                    class="text-sm font-bold text-sky-600 border-b border-[var(--color-border-muted)] pb-2 mb-2">
                                                    Kontrak & Efektivitas
                                                </div>
                                                <div
                                                    class="divide-y divide-[var(--color-border-muted)] space-y-2">
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Perjanjian
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.Perjanjian || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Efektif Kontrak
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['Efektif Kontrak'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Bank Garansi
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['Bank Garansi'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            PO (Tanggal)
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.PO || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            MOS (Tanggal)
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item.MOS || '-' }}
                                                        </span>
                                                    </div>
                                                </div>

                                                <div
                                                    class="text-sm font-bold text-green-600 border-b border-[var(--color-border-muted)] pt-4 pb-2 mb-2">
                                                    Milestone Pembayaran
                                                </div>
                                                <div
                                                    class="divide-y divide-[var(--color-border-muted)] space-y-2">
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Progress 25%
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['0.25'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Progress 50%
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['0.5'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Progress 75%
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['0.75'] || '-' }}
                                                        </span>
                                                    </div>
                                                    <div
                                                        class="flex justify-between items-center pt-2">
                                                        <span
                                                            class="font-medium text-[var(--color-text-muted)]">
                                                            Progress 100%
                                                        </span>
                                                        <span
                                                            class="font-semibold text-[var(--color-text)] text-sm">
                                                            {{ item['1'] || '-' }}
                                                        </span>
                                                    </div>
                                                </div>

                                                <div
                                                    class="flex justify-between items-center p-3 mt-4 -mx-4 border-t border-[var(--color-border-muted)] bg-[var(--color-surface-muted)]/60 rounded-b-lg">
                                                    <span
                                                        class="text-sm font-extrabold text-[var(--color-text)] uppercase">
                                                        Total Bayar Tahun Ini
                                                    </span>
                                                    <span
                                                        class="text-lg font-extrabold text-green-600">
                                                        {{
                                                            formatRupiah(item['Terbayar Tahun Ini'])
                                                        }}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>
                </div>
            </section>
            <section class="mb-10">
                <h2 class="text-xl font-semibold text-[var(--color-text)] mb-4">Stock Widgets</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <StockWidget
                        :stock="stocks[0]"
                        :src="stocks[0].icon"
                        :alt="stocks[0].name"
                        :bg-color="stocks[0].bgColor"
                        size="lg" />
                    <StockWidget
                        :stock="stocks[1]"
                        :src="stocks[1].icon"
                        :alt="stocks[1].name"
                        :bg-color="stocks[1].bgColor"
                        size="lg" />
                    <StockWidget
                        :stock="stocks[2]"
                        :src="stocks[2].icon"
                        :alt="stocks[2].name"
                        :bg-color="stocks[2].bgColor"
                        size="lg" />
                    <StockWidget
                        :stock="stocks[3]"
                        :src="stocks[3].icon"
                        :alt="stocks[3].name"
                        :bg-color="stocks[3].bgColor"
                        size="lg" />
                </div>
            </section>

            <section class="mb-10">
                <h2 class="text-xl font-semibold text-[var(--color-text)] mb-4">Stats Overview</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <StatWidget
                        v-for="(stat, index) in stats"
                        :key="index"
                        :title="stat.title"
                        :value="stat.value"
                        :trend="
                            stat.growth.startsWith('+')
                                ? 'up'
                                : stat.growth.startsWith('-')
                                ? 'down'
                                : 'neutral'
                        "
                        :color="
                            stat.growth.startsWith('+')
                                ? 'green'
                                : stat.growth.startsWith('-')
                                ? 'red'
                                : 'blue'
                        "
                        :icon="
                            stat.title.includes('Member')
                                ? icons.users
                                : stat.title.includes('Growth')
                                ? icons.performance
                                : stat.title.includes('Session')
                                ? icons.projects
                                : icons.tasks
                        " />
                </div>
            </section>

            <section class="mb-10">
                <h2 class="text-xl font-semibold text-[var(--color-text)] mb-4">
                    Progress Widgets
                </h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <ProgressWidget
                        title="Storage Used"
                        :value="75"
                        :max="100"
                        description="75GB of 100GB used"
                        color="blue" />
                    <ProgressWidget
                        title="Tasks Completed"
                        :value="42"
                        :max="60"
                        description="42 of 60 tasks done"
                        color="green" />
                    <ProgressWidget
                        title="Project Progress"
                        :value="88"
                        :max="100"
                        description="Nearly complete"
                        color="purple" />
                    <ProgressWidget
                        title="Monthly Goals"
                        :value="35"
                        :max="50"
                        description="70% achieved"
                        color="indigo" />
                </div>
            </section>

            <section class="mb-10">
                <h2 class="text-xl font-semibold text-[var(--color-text)] mb-4">Chart Widgets</h2>
                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                    <ChartWidget
                        title="Revenue"
                        value="$45,231"
                        :change="12.5"
                        :data="[30, 40, 35, 50, 49, 60, 70, 91, 125]"
                        color="emerald" />
                    <ChartWidget
                        title="Visitors"
                        value="8,234"
                        :change="8.1"
                        :data="[20, 30, 35, 45, 40, 55, 60, 70, 65]"
                        color="blue" />
                    <ChartWidget
                        title="Orders"
                        value="1,234"
                        :change="-3.2"
                        :data="[50, 45, 40, 42, 38, 35, 33, 30, 28]"
                        color="red" />
                    <ChartWidget
                        title="Conversion"
                        value="3.24%"
                        :change="5.4"
                        :data="[15, 20, 18, 25, 30, 28, 35, 40, 42]"
                        color="purple" />
                </div>
            </section>
        </div>
    </main>
</template>
