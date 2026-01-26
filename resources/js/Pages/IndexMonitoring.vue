<script setup>
import { Head, usePage, router, Link } from '@inertiajs/vue3'
import { computed, ref, watch } from 'vue'
import Default from '../Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormSelect from '@/Components/FormSelect.vue'

defineOptions({
    layout: Default
})

const props = defineProps({
    units: {
        type: Array,
        required: true,
        default: () => []
    },
    stats: {
        type: Array,
        required: true,
        default: () => []
    },
    pakets: {
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
        default: () => ({ tahun: '', unit_id: '', per_page: '' })
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
            backgroundColor: ['#10b981', '#f3f4f6'], // Emerald vs Gray
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
            backgroundColor: ['#f59e0b', '#6366f1'], // Amber vs Indigo
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
                backgroundColor: ['#10b981', '#e5e7eb'], // Hijau vs Abu-abu terang
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
                backgroundColor: ['#f59e0b', '#e5e7eb'], // Amber vs Abu-abu
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
const selectedTahun = ref(props.filters.tahun || '')
const selectedUnit = ref(props.filters.unit_id || '')
const perPage = ref(props.filters.per_page || '10')

const currentYear = new Date().getFullYear()
const yearsOptions = Array.from({ length: 10 }, (_, i) => {
    const year = currentYear - i
    return { value: year.toString(), label: year.toString() }
})

// Watcher untuk mendeteksi perubahan filter tahun
watch([selectedTahun, selectedUnit, perPage], ([newTahun, newUnit, newPerPage]) => {
    router.get(
        route('admin.monitoring.index'), // Pastikan nama route sesuai (cek dengan php artisan route:list)
        { tahun: newTahun, unit_id: newUnit, per_page: newPerPage },
        {
            preserveState: true,
            replace: true,
            preserveScroll: true
        }
    )
})

const paketsData = computed(() => props.pakets.data || [])

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
    // Jalur Kontrak & Pasca-Kontrak (PO & Pembayaran)
    const kontrak = paket.enjiniring?.rendan?.lakdan?.kontrak

    if (kontrak && kontrak.is_completed) {
        // Cek Purchase Order
        const hasPO = !!kontrak.purchase_order && kontrak.purchase_order.is_completed

        // Cek Pembayaran (Minimal ada satu yang is_completed)
        const hasBayar =
            Array.isArray(kontrak.pembayaran) &&
            kontrak.pembayaran.length > 0 &&
            kontrak.pembayaran.some(p => p.is_completed)

        if (hasPO && hasBayar) return 'PO & Pembayaran'
        if (hasBayar) return 'Pembayaran'
        if (hasPO) return 'Purchase Order'

        return 'Kontrak'
    }

    // Jalur Sequential (Perencanaan sampai Lakdan)
    // Status hanya bergeser jika tahap SEBELUMNYA sudah is_completed
    if (paket.enjiniring?.rendan?.lakdan?.is_completed) return 'Lakdan'
    if (paket.enjiniring?.rendan?.is_completed) return 'Rendan'
    if (paket.enjiniring?.is_completed) return 'Enjiniring'

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
    const enji = paket.enjiniring
    const ren = enji?.rendan
    const lak = ren?.lakdan
    const kon = lak?.kontrak
    const hasCompletedPayment =
        Array.isArray(kon?.pembayaran) && kon.pembayaran.some(p => p.is_completed)

    return [
        {
            name: 'Enjiniring',
            active: !!enji && enji.is_completed,
            date: formatTgl(enji?.updated_at)
        },
        {
            name: 'Rendan',
            active: !!ren && ren.is_completed,
            date: formatTgl(ren?.updated_at)
        },
        {
            name: 'Lakdan',
            active: !!lak && lak.is_completed,
            date: formatTgl(lak?.updated_at)
        },
        {
            name: 'Kontrak',
            active: !!kon && kon.is_completed,
            date: formatTgl(kon?.realisasi_tanggal_perjanjian || kon?.created_at)
        },
        {
            name: 'PO/MOS',
            active: !!kon?.purchase_order && kon.purchase_order.is_completed,
            date: formatTgl(kon?.purchase_order?.realisasi_po)
        },
        {
            name: 'Pembayaran',
            active: hasCompletedPayment,
            date: formatTgl(kon?.pembayaran?.find(p => p.is_completed)?.updated_at)
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

    <main class="mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader title=" Monitoring Proses Anggaran"></PageHeader>

            <div class="mx-auto">
                <section class="">
                    <div
                        class="p-6 border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50">
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
                            <div class="space-y-1">
                                <FormSelect
                                    label="Filter Tahun"
                                    v-model="selectedTahun"
                                    :options="[
                                        { value: 'semua', label: 'Semua Tahun' },
                                        ...yearsOptions
                                    ]" />
                            </div>

                            <div
                                v-if="
                                    page.props.auth.user.unit_id == 1 ||
                                    page.props.auth.user.roles.includes('superuser')
                                "
                                class="space-y-1">
                                <FormSelect
                                    label="Pilih Unit"
                                    v-model="selectedUnit"
                                    :options="[
                                        { value: '', label: 'Semua Unit' },
                                        ...units.map(u => ({ value: u.id, label: u.name }))
                                    ]" />
                            </div>

                            <div v-else class="px-4 py-2 bg-sky-100 dark:bg-sky-900/30 rounded-xl">
                                <span
                                    class="text-xs font-bold text-sky-700 dark:text-sky-400 uppercase tracking-widest">
                                    Unit: {{ page.props.auth.user?.unit?.name }}
                                </span>
                            </div>

                            <div class="space-y-1">
                                <FormSelect
                                    label="Rows per page"
                                    v-model="perPage"
                                    :options="[
                                        { value: '10', label: '10 Baris' },
                                        { value: '25', label: '25 Baris' },
                                        { value: '50', label: '50 Baris' },
                                        { value: '100', label: '100 Baris' }
                                    ]" />
                            </div>

                            <div class="flex items-center pb-0">
                                <a
                                    :href="route('dashboard.export', { tahun: selectedTahun })"
                                    target="_blank"
                                    class="btn-secondary btn-sm bg-green-600 hover:bg-green-700 text-white">
                                    <svg
                                        class="w-4 h-4"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24">
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                                    </svg>
                                    Excel
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="p-6 dark:bg-gray-900">
                        <div
                            class="overflow-x-auto rounded-2xl border border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900">
                            <table class="min-w-full border-separate border-spacing-0">
                                <thead class="bg-gray-50 dark:bg-gray-800">
                                    <tr>
                                        <th
                                            class="sticky left-0 top-0 z-40 bg-gray-50 dark:bg-gray-800 py-4 pl-8 pr-3 text-left border-b border-gray-100 dark:border-gray-800">
                                            Tahun
                                        </th>
                                        <th
                                            class="sticky left-[100px] top-0 z-40 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-left border-b border-gray-100 dark:border-gray-800">
                                            Referensi PRK
                                        </th>

                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 min-w-[200px] px-3 py-4 text-right pr-8 text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] border-b border-gray-100 dark:border-gray-800">
                                            Status Tahapan
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            SKAI
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            SKKI
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            Survey
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            TOR & HPE
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            RKS
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            ND User
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            HPS
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            Lelang
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            Penunjukan
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            Perjanjian
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            Bank Garansi
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            Efektif Kontrak
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            PO
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            MOS
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800">
                                            Progress Terkini
                                        </th>
                                        <th
                                            class="sticky top-0 z-10 bg-gray-50 dark:bg-gray-800 px-3 py-4 text-center text-[10px] font-bold uppercase tracking-wider text-blue-600 border-b border-gray-100 dark:border-gray-800 text-nowrap">
                                            Terbayar Tahun Ini
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-50 dark:divide-gray-800">
                                    <template v-for="(paket, pIndex) in paketsData" :key="paket.id">
                                        <tr
                                            @click="toggleExpand(paket.id)"
                                            class="group cursor-pointer hover:bg-sky-50/50 dark:hover:bg-sky-900/10 transition-all duration-200"
                                            :class="
                                                isExpanded(paket.id)
                                                    ? 'bg-sky-50/30 dark:bg-sky-900/5'
                                                    : ''
                                            ">
                                            <td
                                                class="sticky left-0 z-20 bg-white dark:bg-gray-900 group-hover:bg-sky-50 dark:group-hover:bg-gray-800 py-5 pl-8 pr-3 transition-colors">
                                                <div class="flex items-center gap-4">
                                                    <svg
                                                        class="w-4 h-4 text-sky-500 transition-transform"
                                                        :class="{
                                                            'rotate-90': isExpanded(paket.id)
                                                        }"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke="currentColor"
                                                        stroke-width="3">
                                                        <path
                                                            d="M9 5l7 7-7 7"
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round" />
                                                    </svg>
                                                    <div class="flex flex-col">
                                                        <span
                                                            class="text-xs font-mono text-sky-600">
                                                            #{{ paket.prk.tahun }}
                                                        </span>
                                                        <span
                                                            class="text-[9px] font-mono text-gray-400 uppercase tracking-tighter">
                                                            Paket {{ pIndex + 1 }}
                                                        </span>
                                                    </div>
                                                </div>
                                            </td>

                                            <td
                                                class="sticky left-[100px] z-20 bg-white dark:bg-gray-900 group-hover:bg-sky-50 dark:group-hover:bg-gray-800 px-3 py-5 transition-colors border-r border-gray-100 dark:border-gray-800 shadow-[4px_0_4px_-2px_rgba(0,0,0,0.05)]">
                                                <div class="flex flex-col">
                                                    <span
                                                        class="font-semibold text-[var(--color-text)] text-gray-800 dark:text-gray-200 group-hover:text-sky-600 transition-colors">
                                                        {{ paket.prk.uraian || '-' }}
                                                    </span>
                                                    <div class="flex items-center gap-2 mt-1">
                                                        <span
                                                            class="text-xs font-mono font-bold text-gray-400 bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 rounded">
                                                            {{ paket.prk.prk }}
                                                        </span>
                                                        |
                                                        <span
                                                            class="text-xs text-gray-400 uppercase font-medium">
                                                            {{ paket.prk.bidang?.name || 'N/A' }}
                                                        </span>
                                                        |
                                                        <span
                                                            class="text-xs text-gray-400 uppercase font-medium">
                                                            {{ paket.unit?.name || 'N/A' }}
                                                        </span>
                                                    </div>
                                                </div>
                                            </td>

                                            <td class="px-3 py-5 text-right pr-8">
                                                <span :class="getStatusStyles(paket).badge">
                                                    {{ getStatusTahapan(paket) }}
                                                </span>
                                            </td>

                                            <!-- <td class="px-3 py-4 text-center">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span :class="styleMuted">-</span>
                                                        <span
                                                            :class="
                                                                prk.tanggal_kkp
                                                                    ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                    : styleMuted
                                                            ">
                                                            {{ formatTglSingkat(prk.tanggal_kkp) }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span :class="styleMuted">-</span>
                                                        <span
                                                            :class="
                                                                prk.tanggal_ulasan_kajian_risiko
                                                                    ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    prk.tanggal_ulasan_kajian_risiko
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span :class="styleMuted">-</span>
                                                        <span
                                                            :class="
                                                                prk.tanggal_dokumen_grc
                                                                    ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    prk.tanggal_dokumen_grc
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span :class="styleMuted">-</span>
                                                        <span
                                                            :class="
                                                                prk.tanggal_tvv
                                                                    ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                    : styleMuted
                                                            ">
                                                            {{ formatTglSingkat(prk.tanggal_tvv) }}
                                                        </span>
                                                    </div>
                                                </td> -->

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span :class="styleMuted">-</span>
                                                    <span
                                                        :class="
                                                            paket.prk.tanggal_skai
                                                                ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(paket.prk.tanggal_skai)
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span :class="styleMuted">-</span>
                                                    <span
                                                        :class="
                                                            paket.tanggal_skk
                                                                ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                : styleMuted
                                                        ">
                                                        {{ formatTglSingkat(paket.tanggal_skk) }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.target_survey
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.target_survey
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.target_survey,
                                                                paket.enjiniring?.realisasi_survey
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.realisasi_survey
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring
                                                                ?.target_dokumen_enjiniring
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring
                                                                    ?.target_dokumen_enjiniring
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring
                                                                    ?.target_dokumen_enjiniring,
                                                                paket.enjiniring
                                                                    ?.realisasi_dokumen_enjiniring
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring
                                                                    ?.realisasi_dokumen_enjiniring
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan
                                                                ?.target_tanggal_rks
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan
                                                                    ?.target_tanggal_rks
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan
                                                                    ?.target_tanggal_rks,
                                                                paket.enjiniring?.rendan
                                                                    ?.tanggal_rks
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan
                                                                    ?.tanggal_rks
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span :class="styleMuted">-</span>
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan
                                                                ?.tanggal_nd_user
                                                                ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan
                                                                    ?.tanggal_nd_user
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.rencana_tanggal_hps
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_tanggal_hps
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_tanggal_hps,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_tanggal_hps
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_tanggal_hps
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.rencana_pengumuman_pengadaan
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_pengumuman_pengadaan
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_pengumuman_pengadaan,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_pengumuman_pengadaan
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_pengumuman_pengadaan
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.rencana_penunjukan_penyedia
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_penunjukan_penyedia
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.rencana_penunjukan_penyedia,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_penunjukan_penyedia
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.realisasi_penunjukan_penyedia
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak
                                                                ?.rencana_tanggal_perjanjian
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.rencana_tanggal_perjanjian
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.rencana_tanggal_perjanjian,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.realisasi_tanggal_perjanjian
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.realisasi_tanggal_perjanjian
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak
                                                                ?.rencana_jaminan_pelaksanaan
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.rencana_jaminan_pelaksanaan
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.rencana_jaminan_pelaksanaan,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.realisasi_jaminan_pelaksanaan
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak
                                                                    ?.realisasi_jaminan_pelaksanaan
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span :class="styleMuted">-</span>
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak?.tanggal_efektif
                                                                ? 'text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.tanggal_efektif
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak?.purchase_order
                                                                ?.rencana_po
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_po
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_po,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.realisasi_po
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.realisasi_po
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span
                                                        :class="
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak?.purchase_order
                                                                ?.rencana_mos
                                                                ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                : styleMuted
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_mos
                                                            )
                                                        }}
                                                    </span>
                                                    <span
                                                        :class="
                                                            getStatusColor(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_mos,
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.realisasi_mos
                                                            )
                                                        ">
                                                        {{
                                                            formatTglSingkat(
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.realisasi_mos
                                                            )
                                                        }}
                                                    </span>
                                                </div>
                                            </td>

                                            <!-- <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span
                                                            :class="
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_progress_25
                                                                    ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_25
                                                                )
                                                            }}
                                                        </span>
                                                        <span
                                                            :class="
                                                                getStatusColor(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_25,
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_25
                                                                )
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_25
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span
                                                            :class="
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_progress_50
                                                                    ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_50
                                                                )
                                                            }}
                                                        </span>
                                                        <span
                                                            :class="
                                                                getStatusColor(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_50,
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_50
                                                                )
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_50
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span
                                                            :class="
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_progress_75
                                                                    ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_75
                                                                )
                                                            }}
                                                        </span>
                                                        <span
                                                            :class="
                                                                getStatusColor(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_progress_75,
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_75
                                                                )
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_progress_75
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-3 py-4 text-center bg-sky-50/20">
                                                    <div class="flex flex-col gap-1.5">
                                                        <span
                                                            :class="
                                                                paket.enjiniring?.rendan?.lakdan
                                                                    ?.kontrak?.purchase_order
                                                                    ?.rencana_cod
                                                                    ? 'text-[10px] font-mono text-blue-500 border-b border-blue-100 pb-0.5'
                                                                    : styleMuted
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_cod
                                                                )
                                                            }}
                                                        </span>
                                                        <span
                                                            :class="
                                                                getStatusColor(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.rencana_cod,
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_cod
                                                                )
                                                            ">
                                                            {{
                                                                formatTglSingkat(
                                                                    paket.enjiniring?.rendan?.lakdan
                                                                        ?.kontrak?.purchase_order
                                                                        ?.realisasi_cod
                                                                )
                                                            }}
                                                        </span>
                                                    </div>
                                                </td>
                                                -->

                                            <td class="px-3 py-4 text-center bg-sky-50/20">
                                                <div class="flex flex-col gap-1.5">
                                                    <span :class="styleMuted">-</span>
                                                    <span
                                                        class="text-[10px] font-mono font-bold text-gray-700 dark:text-gray-300">
                                                        {{
                                                            paket.enjiniring?.rendan?.lakdan
                                                                ?.kontrak?.purchase_order
                                                                ?.progress_terkini || '0'
                                                        }}%
                                                    </span>
                                                </div>
                                            </td>

                                            <td class="px-3 py-4 text-center min-w-[150px]">
                                                <div class="flex flex-col gap-1">
                                                    <span
                                                        class="text-[9px] font-medium text-gray-400 border-b border-gray-100 pb-0.5">
                                                        Target:
                                                        {{ formatIDR(paket.nilai_perjanjian) }}
                                                    </span>

                                                    <div class="flex flex-col items-center">
                                                        <span
                                                            :class="[
                                                                'text-[11px] font-bold font-mono',
                                                                paket.total_terbayar >=
                                                                    paket.nilai_perjanjian &&
                                                                paket.nilai_perjanjian > 0
                                                                    ? 'text-emerald-600'
                                                                    : 'text-blue-600'
                                                            ]">
                                                            {{ formatIDR(paket.total_terbayar) }}
                                                        </span>

                                                        <span
                                                            v-if="paket.nilai_perjanjian > 0"
                                                            class="text-[8px] font-bold text-gray-400 uppercase">
                                                            ({{
                                                                (
                                                                    (paket.total_terbayar /
                                                                        paket.nilai_perjanjian) *
                                                                    100
                                                                ).toFixed(1)
                                                            }}%)
                                                        </span>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>

                                        <tr v-if="isExpanded(paket.id)">
                                            <td
                                                colspan="4"
                                                class="p-0 bg-gray-50/50 dark:bg-black/20">
                                                <div class="p-8 border-x-4 border-sky-500/20">
                                                    <div
                                                        class="bg-white dark:bg-gray-800 p-6 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700">
                                                        <div class="flex justify-between relative">
                                                            <div
                                                                class="absolute top-4 left-0 w-full h-0.5 bg-gray-100 dark:bg-gray-700 -z-0"></div>

                                                            <div
                                                                v-for="(step, sIdx) in getSteps(
                                                                    paket
                                                                )"
                                                                :key="sIdx"
                                                                class="relative z-10 flex flex-col items-center flex-1">
                                                                <div
                                                                    :class="[
                                                                        'w-8 h-8 rounded-full flex items-center justify-center mb-3 transition-all',
                                                                        step.active
                                                                            ? 'bg-sky-500 text-white ring-4 ring-sky-100 dark:ring-sky-900/30'
                                                                            : 'bg-white dark:bg-gray-800 border-2 border-gray-200 dark:border-gray-700 text-gray-300'
                                                                    ]">
                                                                    <svg
                                                                        v-if="step.active"
                                                                        class="w-4 h-4"
                                                                        fill="none"
                                                                        stroke="currentColor"
                                                                        viewBox="0 0 24 24">
                                                                        <path
                                                                            d="M5 13l4 4L19 7"
                                                                            stroke-width="3"
                                                                            stroke-linecap="round"
                                                                            stroke-linejoin="round" />
                                                                    </svg>
                                                                    <span
                                                                        v-else
                                                                        class="text-xs font-bold">
                                                                        {{ sIdx + 1 }}
                                                                    </span>
                                                                </div>
                                                                <span
                                                                    :class="[
                                                                        'text-xs font-semibold uppercase tracking-tighter',
                                                                        step.active
                                                                            ? 'text-sky-600'
                                                                            : 'text-gray-400'
                                                                    ]">
                                                                    {{ step.name }}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td colspan="23"></td>
                                        </tr>
                                    </template>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-6 flex items-center justify-between">
                            <div class="text-sm text-gray-500">
                                Menampilkan {{ pakets.from }} sampai {{ pakets.to }} dari
                                {{ pakets.total }} data Paket
                            </div>
                            <div class="flex gap-1">
                                <template v-for="(link, k) in pakets.links" :key="k">
                                    <Link
                                        v-if="link.url"
                                        :href="link.url"
                                        v-html="link.label"
                                        class="px-4 py-2 text-sm rounded-lg border transition-all"
                                        :class="{
                                            'bg-sky-500 text-white border-sky-500 shadow-md shadow-sky-200':
                                                link.active,
                                            'bg-white dark:bg-gray-800 text-gray-600 dark:text-gray-400 border-gray-200 dark:border-gray-700 hover:bg-gray-50':
                                                !link.active
                                        }" />
                                    <span
                                        v-else
                                        v-html="link.label"
                                        class="px-4 py-2 text-sm text-gray-400 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-lg cursor-not-allowed"></span>
                                </template>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </main>
</template>

<style scoped>
/* Mewarnai kolom GENAP, mulai dari kolom ke-4 ke atas.
   (Kolom 4, 6, 8, dst akan berwarna)
*/
thead th:nth-child(even):nth-child(n + 4),
tbody td:nth-child(even):nth-child(n + 4) {
    background-color: rgba(243, 244, 246, 0.5) !important;
}

/* Dukungan Dark Mode */
:deep(.dark) thead th:nth-child(even):nth-child(n + 4),
:deep(.dark) tbody td:nth-child(even):nth-child(n + 4) {
    background-color: rgba(31, 41, 55, 0.5) !important;
}

/* Memastikan kolom 1, 2, dan 3 tetap bersih (tanpa background)
   meskipun ada class bawaan dari Tailwind.
*/
</style>
