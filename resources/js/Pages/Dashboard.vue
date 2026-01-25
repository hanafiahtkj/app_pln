<script setup>
import { Head, usePage, router, Link } from '@inertiajs/vue3'
import { computed, ref, watch } from 'vue'
import Default from '../Layouts/Default.vue'
import StockWidget from '@/Components/Widgets/StockWidget.vue'
import StatWidget from '@/Components/Widgets/StatWidget.vue'
import ProgressWidget from '@/Components/Widgets/ProgressWidget.vue'
import ChartWidget from '@/Components/Widgets/ChartWidget.vue'
import ApexBarChart from '@/Components/Charts/ApexBarChart.vue'
import ApexDonutChart from '@/Components/Charts/ApexDonutChart.vue'

defineOptions({
    layout: Default
})

const props = defineProps({
    stats: {
        type: Array,
        required: true,
        default: () => []
    },
    prks: {
        type: Object, // Ubah dari Array ke Object,
        required: true,
        default: () => []
    },

    dashboardData: {
        type: Array,
        required: true
    },

    filters: {
        // Terima props filter dari controller
        type: Object,
        default: () => ({ tahun: '' })
    },

    totalStats: {
        type: Object,
        default: () => ({
            paket: { total: 0, terkontrak: 0 },
            keuangan: { rencana: 0, realisasi: 0 }
        })
    },

    unitStats: {
        type: Array,
        default: () => [] // Memberikan array kosong jika data belum dikirim
    }
})

// Grafik 1: Perbandingan Paket per Unit (Nasional/Per Unit)
const paketChartData = computed(() => ({
    // Mengambil semua nama unit untuk sumbu X
    labels: props.unitStats.map(u => u.unit_name),
    datasets: [
        {
            label: 'Total Paket',
            data: props.unitStats.map(u => u.total),
            backgroundColor: '#3b82f6', // Biru
            borderRadius: 4
        },
        {
            label: 'Terkontrak',
            data: props.unitStats.map(u => u.terkontrak),
            backgroundColor: '#10b981', // Hijau
            borderRadius: 4
        }
    ]
}))

// Grafik 2: Perbandingan Keuangan (Rencana vs Realisasi) per Unit
const financialChartData = computed(() => ({
    // Mengambil semua nama unit untuk sumbu X
    labels: props.unitStats.map(u => u.unit_name),
    datasets: [
        {
            label: 'Total Nilai Kontrak',
            data: props.unitStats.map(u => u.rencana),
            backgroundColor: '#6366f1', // Indigo
            borderRadius: 4
        },
        {
            label: 'Total Terbayar',
            data: props.unitStats.map(u => u.realisasi),
            backgroundColor: '#f59e0b', // Amber
            borderRadius: 4
        }
    ]
}))

// 1. Chart Status Paket (Total vs Terkontrak)
const piePaketChartData = computed(() => ({
    labels: ['Terkontrak', 'Belum Terkontrak'],
    datasets: [
        {
            data: [
                props.totalStats.paket.terkontrak,
                props.totalStats.paket.total - props.totalStats.paket.terkontrak
            ],
            backgroundColor: ['#FFD600', '#24a8e1'],
            borderWidth: 1
        }
    ]
}))

// 2. Chart Serapan Keuangan (Realisasi vs Sisa Anggaran)
const pieFinancialChartData = computed(() => ({
    labels: ['Realisasi Bayar', 'Sisa Nilai Kontrak'],
    datasets: [
        {
            data: [
                props.totalStats.keuangan.realisasi,
                props.totalStats.keuangan.rencana - props.totalStats.keuangan.realisasi
            ],
            backgroundColor: ['#FFD600', '#24a8e1'],
            borderWidth: 1
        }
    ]
}))

// Fungsi untuk memformat data masing-masing unit menjadi format yang dikenali Chart
const getUnitChartData = unit => {
    return {
        labels: ['Terkontrak', 'Belum Terkontrak'],
        datasets: [
            {
                data: [
                    unit.terkontrak,
                    unit.total - unit.terkontrak // Sisa paket yang belum kontrak
                ],
                backgroundColor: ['#FFD600', '#24a8e1'],
                borderWidth: 1
            }
        ]
    }
}

// Fungsi untuk memformat data keuangan per unit
const getFinancialUnitChartData = unit => {
    return {
        labels: ['Terbayar', 'Sisa Kontrak'],
        datasets: [
            {
                data: [
                    unit.realisasi,
                    // Jika realisasi melebihi rencana (kasus khusus), sisa jadi 0
                    Math.max(0, unit.rencana - unit.realisasi)
                ],
                backgroundColor: ['#FFD600', '#24a8e1'],
                borderWidth: 1
            }
        ]
    }
}

// Fungsi helper untuk memformat angka singkat (opsional agar tidak sesak)
const formatShortIDR = value => {
    // if (value >= 1000000000) return (value / 1000000000).toFixed(1) + ' M'
    // if (value >= 1000000) return (value / 1000000).toFixed(1) + ' Jt'
    // if (value >= 1000) return (value / 1000).toFixed(1) + ' Rb'
    return value.toLocaleString('id-ID')
}

const styleMuted =
    'text-[10px] font-medium text-gray-400 border-b border-gray-100 dark:border-gray-800 pb-0.5'

const getStatusColor = (target, realisasi) => {
    if (!realisasi) return styleMuted
    if (!target) return 'text-[10px] font-mono font-bold text-gray-700' // Default jika tidak ada target

    const tglTarget = new Date(target)
    const tglRealisasi = new Date(realisasi)

    // Jika realisasi lebih cepat atau sama dengan target = Hijau, jika telat = Merah
    return tglRealisasi <= tglTarget
        ? 'text-[10px] font-mono font-bold text-emerald-600'
        : 'text-[10px] font-mono font-bold text-rose-600'
}

// State untuk filter tahun
const selectedTahun = ref(props.filters.tahun || 'semua')

// List tahun (bisa hardcoded atau ambil dari database)
const listTahun = computed(() => {
    const currentYear = new Date().getFullYear()
    return [currentYear, currentYear - 1, currentYear - 2, currentYear - 3]
})

// Watcher untuk mendeteksi perubahan filter tahun
watch(selectedTahun, newTahun => {
    router.get(
        route('dashboard'), // Pastikan nama route sesuai (cek dengan php artisan route:list)
        { tahun: newTahun },
        {
            preserveState: true,
            replace: true,
            preserveScroll: true
        }
    )
})

const prkData = computed(() => props.prks.data || [])

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

const hitungTotalBayar = paket => {
    const pembayaran = paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran
    if (!pembayaran || !Array.isArray(pembayaran)) return 0

    // Menjumlahkan semua nilai_bayar di dalam array pembayaran
    return pembayaran.reduce((acc, curr) => acc + (Number(curr.nilai_pembayaran) || 0), 0)
}

const formatTgl = tgl => {
    if (!tgl) return '-'
    return new Date(tgl).toLocaleDateString('id-ID', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
    })
}

const getStatItems = paket => {
    return [
        {
            label: 'Nomor SKK',
            value: paket.nomor_skk || '-'
        },
        {
            label: 'Nilai SKK',
            value: formatRupiah(paket.nilai_skk)
        },
        {
            label: 'No. Kontrak',
            value: paket.enjiniring?.rendan?.lakdan?.kontrak?.nomor_perjanjian || 'Belum Kontrak'
        },
        {
            label: 'Penyedia Barang dan Jasa',
            value: paket.enjiniring?.rendan?.lakdan?.kontrak?.penyedia_barang_jasa || '-'
        }
    ]
}

const getStatusTahapan = paket => {
    const hasPO = !!paket.enjiniring?.rendan?.lakdan?.kontrak?.purchase_order
    const hasBayar = !!paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran?.length // Pembayaran biasanya array

    if (hasPO && hasBayar) return 'PO & Pembayaran'
    if (hasBayar) return 'Pembayaran'
    if (hasPO) return 'Purchase Order'

    if (paket.enjiniring?.rendan?.lakdan?.kontrak) return 'Kontrak'
    if (paket.enjiniring?.rendan?.lakdan) return 'Lakdan'
    if (paket.enjiniring?.rendan) return 'Rendan'
    if (paket.enjiniring) return 'Enjiniring'

    return 'Perencanaan'
}

const getStatusStyles = paket => {
    const status = getStatusTahapan(paket)
    const base =
        'px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider border shadow-sm transition-all'

    const styles = {
        'PO & Pembayaran': `${base} bg-gradient-to-r from-orange-50 to-emerald-50 text-emerald-700 border-emerald-200 dark:from-orange-950/20 dark:to-emerald-950/20`,
        'Purchase Order': `${base} bg-orange-50 text-orange-600 border-orange-100 dark:bg-orange-900/20 dark:border-orange-800`,
        Pembayaran: `${base} bg-emerald-50 text-emerald-600 border-emerald-100 dark:bg-emerald-900/20 dark:border-emerald-800`,
        Kontrak: `${base} bg-indigo-50 text-indigo-600 border-indigo-100 dark:bg-indigo-900/20 dark:border-indigo-800`,
        default: `${base} bg-blue-50 text-blue-600 border-blue-100 dark:bg-blue-900/20 dark:border-blue-800`
    }

    return {
        badge: styles[status] || styles['default']
    }
}

const getSteps = paket => {
    const kon = paket.enjiniring?.rendan?.lakdan?.kontrak
    return [
        {
            name: 'Enjiniring',
            active: !!paket.enjiniring,
            date: formatTgl(paket.enjiniring?.updated_at)
        },
        {
            name: 'Rendan',
            active: !!paket.enjiniring?.rendan,
            date: formatTgl(paket.enjiniring?.rendan?.updated_at)
        },
        {
            name: 'Lakdan',
            active: !!paket.enjiniring?.rendan?.lakdan,
            date: formatTgl(paket.enjiniring?.rendan?.lakdan?.updated_at)
        },
        { name: 'Kontrak', active: !!kon, date: formatTgl(kon?.created_at) },
        {
            name: 'PO/MOS',
            active: !!kon?.purchase_order,
            date: formatTgl(kon?.purchase_order?.realisasi_po)
        },
        {
            name: 'Pembayaran',
            active: kon?.pembayaran?.length > 0,
            date: formatTgl(kon?.pembayaran?.[0]?.updated_at)
        }
    ]
}

const formatTglSingkat = dateString => {
    if (!dateString) return '-'

    const date = new Date(dateString)

    // Menggunakan locale 'id-ID' dengan format numeric
    // year: '2-digit' akan menghasilkan '25' bukan '2025'
    return date
        .toLocaleDateString('id-ID', {
            day: '2-digit',
            month: '2-digit',
            year: '2-digit'
        })
        .replace(/\./g, '/') // Mengganti pemisah titik (default ID) menjadi garis miring
}

const formatIDR = val => {
    if (!val || val === 0) return 'Rp 0'
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        maximumFractionDigits: 0
    }).format(val)
}
</script>

<template>
    <Head title="Dashboard" />

    <main class="min-h-screen">
        <div class="mx-auto">
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

            <section class="">
                <div class="flex items-center justify-between">
                    <h2
                        class="text-xl font-bold text-[var(--color-text)] dark:text-white tracking-tight"></h2>

                    <div class="flex items-center gap-3">
                        <div class="relative min-w-[150px]">
                            <select
                                v-model="selectedTahun"
                                class="w-full bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-sm font-bold rounded-xl px-4 py-2 focus:ring-2 focus:ring-sky-500 transition-all appearance-none">
                                <option value="semua">Semua Tahun</option>
                                <option v-for="t in listTahun" :key="t" :value="t">{{ t }}</option>
                            </select>
                            <div
                                class="absolute inset-y-0 right-3 flex items-center pointer-events-none">
                                <svg
                                    class="w-4 h-4 text-gray-400"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M19 9l-7 7-7-7"
                                        stroke-width="2"
                                        stroke-linecap="round"
                                        stroke-linejoin="round" />
                                </svg>
                            </div>
                        </div>

                        <!-- <div class="px-4 py-2 bg-sky-100 dark:bg-sky-900/30 rounded-xl">
                            <span
                                class="text-xs font-bold text-sky-700 dark:text-sky-400 uppercase tracking-widest">
                                Unit: {{ page.props.auth.user?.unit?.name || 'All Units' }}
                            </span>
                        </div> -->
                    </div>
                </div>
            </section>

            <section class="mb-10">
                <div class="mx-auto py-6 space-y-6">
                    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                        <div
                            class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <p class="text-[10px] text-gray-500 uppercase font-bold tracking-wider">
                                Total Paket
                            </p>
                            <p class="text-2xl font-black text-blue-600">
                                {{ totalStats.paket.total }}
                            </p>
                        </div>
                        <div
                            class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <p class="text-[10px] text-gray-500 uppercase font-bold tracking-wider">
                                Terkontrak
                            </p>
                            <p class="text-2xl font-black text-emerald-600">
                                {{ totalStats.paket.terkontrak }}
                            </p>
                        </div>

                        <div
                            class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <p class="text-[10px] text-gray-500 uppercase font-bold tracking-wider">
                                Nilai Kontrak
                            </p>
                            <p
                                class="text-xl font-black text-indigo-600 truncate"
                                :title="formatIDR(totalStats.keuangan.rencana)">
                                {{ formatIDR(totalStats.keuangan.rencana) }}
                            </p>
                        </div>
                        <div
                            class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <div class="flex justify-between items-start">
                                <p
                                    class="text-[10px] text-gray-500 uppercase font-bold tracking-wider">
                                    Realisasi Bayar
                                </p>
                                <span
                                    class="text-[10px] font-bold px-1.5 py-0.5 rounded bg-amber-100 text-amber-700">
                                    {{ totalStats.keuangan.persen_serapan }}%
                                </span>
                            </div>
                            <p
                                class="text-xl font-black text-amber-600 truncate"
                                :title="formatIDR(totalStats.keuangan.realisasi)">
                                {{ formatIDR(totalStats.keuangan.realisasi) }}
                            </p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-6">
                        <div
                            class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <h3
                                class="text-sm font-bold text-gray-700 dark:text-gray-200 mb-4 uppercase">
                                Status Progress Paket (Fisik)
                            </h3>
                            <ApexDonutChart
                                :chart-data="piePaketChartData"
                                title="Terkontrak vs Total"
                                height="300px" />
                        </div>

                        <div
                            class="bg-white dark:bg-gray-800 p-6 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm">
                            <h3
                                class="text-sm font-bold text-gray-700 dark:text-gray-200 mb-4 uppercase">
                                Serapan Anggaran (IDR)
                            </h3>
                            <ApexDonutChart
                                :chart-data="pieFinancialChartData"
                                title="Realisasi vs Kontrak"
                                height="300px" />
                        </div>
                    </div>

                    <div class="mx-auto py-6 space-y-8">
                        <section
                            class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
                            <div
                                class="p-6 border-b border-gray-50 dark:border-gray-700 flex flex-col md:flex-row md:items-center justify-between gap-4">
                                <div>
                                    <h3
                                        class="text-base font-bold text-gray-800 dark:text-white flex items-center gap-2">
                                        <span class="w-2 h-5 bg-blue-500 rounded-full"></span>
                                        Monitoring Progres Kontrak Per Unit
                                    </h3>
                                    <p class="text-xs text-gray-400 mt-1">
                                        Komparasi jumlah paket yang masuk dengan paket yang berhasil
                                        terkontrak.
                                    </p>
                                </div>
                                <div class="flex items-center gap-3">
                                    <div class="text-right">
                                        <p class="text-[10px] text-gray-400 uppercase font-bold">
                                            Total Ratio
                                        </p>
                                        <p class="text-sm font-black text-blue-600">
                                            {{
                                                (
                                                    (totalStats.paket.terkontrak /
                                                        totalStats.paket.total) *
                                                    100
                                                ).toFixed(1)
                                            }}% Terkontrak
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="p-4 bg-gray-50/30 dark:bg-gray-900/10">
                                <!-- <div class="h-[400px]">
                                    <ApexBarChart :chart-data="paketChartData" height="400" />
                                </div> -->

                                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                    <div
                                        v-for="unit in props.unitStats"
                                        :key="unit.unit_name"
                                        class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm flex flex-col items-center">
                                        <h4
                                            class="text-[10px] font-bold uppercase text-gray-500 mb-2 text-center h-8">
                                            {{ unit.unit_name }}
                                        </h4>

                                        <div class="relative w-full">
                                            <ApexDonutChart
                                                :chart-data="getUnitChartData(unit)"
                                                height="150px" />

                                            <div
                                                class="absolute inset-0 flex flex-col items-center justify-center pt-4">
                                                <span
                                                    class="text-xs font-black text-gray-800 dark:text-white">
                                                    {{ unit.terkontrak }}/{{ unit.total }}
                                                </span>
                                                <span class="text-[8px] text-gray-400">Paket</span>
                                            </div>
                                        </div>

                                        <p class="mt-2 text-[10px] font-bold text-emerald-600">
                                            {{
                                                unit.total > 0
                                                    ? Math.round(
                                                          (unit.terkontrak / unit.total) * 100
                                                      )
                                                    : 0
                                            }}% Progress
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </section>

                        <section
                            class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
                            <div
                                class="p-6 border-b border-gray-50 dark:border-gray-700 flex flex-col md:flex-row md:items-center justify-between gap-4">
                                <div>
                                    <h3
                                        class="text-base font-bold text-gray-800 dark:text-white flex items-center gap-2">
                                        <span class="w-2 h-5 bg-amber-500 rounded-full"></span>
                                        Monitoring Realisasi Pembayaran Per Unit
                                    </h3>
                                    <p class="text-xs text-gray-400 mt-1">
                                        Perbandingan nilai total perjanjian (kontrak) dengan total
                                        dana yang sudah dibayarkan.
                                    </p>
                                </div>
                                <div class="flex items-center gap-3">
                                    <div class="text-right">
                                        <p class="text-[10px] text-gray-400 uppercase font-bold">
                                            Total Penyerapan
                                        </p>
                                        <p class="text-sm font-black text-amber-600">
                                            {{ totalStats.keuangan.persen_serapan }}% Terbayar
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="p-4 bg-gray-50/30 dark:bg-gray-900/10">
                                <!-- <div class="h-[400px]">
                                    <ApexBarChart :chart-data="financialChartData" height="400" />
                                </div> -->
                                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                                    <div
                                        v-for="unit in props.unitStats"
                                        :key="'fin-' + unit.unit_name"
                                        class="bg-white dark:bg-gray-800 p-4 rounded-xl border border-gray-100 dark:border-gray-700 shadow-sm flex flex-col items-center">
                                        <h4
                                            class="text-[10px] font-bold uppercase text-gray-500 mb-2 text-center h-8">
                                            Serapan: {{ unit.unit_name }}
                                        </h4>

                                        <div class="relative w-full">
                                            <ApexDonutChart
                                                :chart-data="getFinancialUnitChartData(unit)"
                                                height="150px" />

                                            <div
                                                class="absolute inset-0 flex items-center justify-center pt-4">
                                                <span class="text-xs font-black text-amber-600">
                                                    {{
                                                        unit.rencana > 0
                                                            ? Math.round(
                                                                  (unit.realisasi / unit.rencana) *
                                                                      100
                                                              )
                                                            : 0
                                                    }}%
                                                </span>
                                            </div>
                                        </div>

                                        <div class="mt-2 text-center">
                                            <p class="text-[9px] text-gray-400">Terbayar:</p>
                                            <p
                                                class="text-[10px] font-bold text-gray-700 dark:text-gray-200">
                                                {{ formatShortIDR(unit.realisasi) }}
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </section>
        </div>
    </main>
</template>
