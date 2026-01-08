<script setup>
import { Head, usePage, router, Link } from '@inertiajs/vue3'
import { computed, ref, watch } from 'vue'
import Default from '../Layouts/Default.vue'
import StockWidget from '@/Components/Widgets/StockWidget.vue'
import StatWidget from '@/Components/Widgets/StatWidget.vue'
import ProgressWidget from '@/Components/Widgets/ProgressWidget.vue'
import ChartWidget from '@/Components/Widgets/ChartWidget.vue'

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
    }
})

// State untuk filter tahun
const selectedTahun = ref(props.filters.tahun || '')

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
    if (paket.enjiniring?.rendan?.lakdan?.kontrak?.purchase_order) return 'Purchase Order'
    if (paket.enjiniring?.rendan?.lakdan?.kontrak) return 'Kontrak'
    if (paket.enjiniring?.rendan?.lakdan) return 'Pelaksanaan Pengadaan'
    return 'Perencanaan'
}

const getStatusStyles = paket => {
    const status = getStatusTahapan(paket)
    const base =
        'px-3 py-1 rounded-full text-xs font-semibold uppercase tracking-wider border-2 shadow-sm transition-all'

    switch (status) {
        case 'Purchase Order':
            return {
                badge: `${base} bg-orange-50 text-orange-600 border-orange-100 dark:bg-orange-950/30 dark:border-orange-900`
            }
        case 'Selesai / Pembayaran':
            return {
                badge: `${base} bg-emerald-50 text-emerald-600 border-emerald-100 dark:bg-emerald-950/30 dark:border-emerald-900`
            }
        case 'Kontrak':
            return {
                badge: `${base} bg-indigo-50 text-indigo-600 border-indigo-100 dark:bg-indigo-950/30 dark:border-indigo-900`
            }
        default:
            return {
                badge: `${base} bg-blue-50 text-blue-600 border-blue-100 dark:bg-blue-950/30 dark:border-blue-900`
            }
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
                <div class="flex items-center justify-between mb-6">
                    <h2
                        class="text-xl font-bold text-[var(--color-text)] dark:text-white tracking-tight">
                        Monitoring Proses Anggaran
                    </h2>

                    <div class="flex items-center gap-3">
                        <div class="relative min-w-[150px]">
                            <select
                                v-model="selectedTahun"
                                class="w-full bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-sm font-bold rounded-xl px-4 py-2 focus:ring-2 focus:ring-sky-500 transition-all appearance-none">
                                <option value="">Semua Tahun</option>
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

                        <div class="px-4 py-2 bg-sky-100 dark:bg-sky-900/30 rounded-xl">
                            <span
                                class="text-xs font-bold text-sky-700 dark:text-sky-400 uppercase tracking-widest">
                                Unit: {{ page.props.auth.user?.unit?.name || 'All Units' }}
                            </span>
                        </div>
                    </div>
                </div>

                <div
                    class="overflow-x-auto rounded-2xl border border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900">
                    <table class="min-w-full divide-y divide-[var(--color-border-muted)]">
                        <thead class="bg-gray-50/50 dark:bg-gray-800/50">
                            <tr>
                                <th
                                    class="py-4 pl-8 pr-3 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] border-b border-gray-100 dark:border-gray-800">
                                    Tahun
                                </th>
                                <th
                                    class="px-3 py-4 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] border-b border-gray-100 dark:border-gray-800">
                                    Uraian Paket & Referensi PRK
                                </th>
                                <th
                                    class="px-3 py-4 text-left text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] border-b border-gray-100 dark:border-gray-800">
                                    Realisasi Bayar
                                </th>
                                <th
                                    class="px-3 py-4 text-right pr-8 text-xs font-semibold uppercase tracking-wider text-[var(--color-text-muted)] border-b border-gray-100 dark:border-gray-800">
                                    Status Tahapan
                                </th>
                            </tr>
                        </thead>

                        <tbody class="divide-y divide-gray-50 dark:divide-gray-800">
                            <template v-for="prk in prkData" :key="prk.id">
                                <tr
                                    v-if="!prk.pakets || prk.pakets.length === 0"
                                    class="bg-gray-50/30 dark:bg-gray-800/10">
                                    <td class="py-5 pl-8 pr-3">
                                        <div class="flex flex-col">
                                            <span class="text-xs font-mono text-gray-300">
                                                #{{ prk.tahun }}
                                            </span>
                                            <span
                                                class="text-[9px] font-bold text-gray-300 uppercase tracking-tighter">
                                                Draft
                                            </span>
                                        </div>
                                    </td>
                                    <td class="px-3 py-5">
                                        <div class="flex flex-col">
                                            <span
                                                class="text-sm font-semibold text-gray-400 italic">
                                                {{ prk.uraian }}
                                            </span>
                                            <span class="text-[10px] text-gray-300 font-mono mt-1">
                                                PRK: {{ prk.prk }}
                                            </span>
                                        </div>
                                    </td>
                                    <td class="px-3 py-5 text-sm text-gray-300 font-bold italic">
                                        - Belum Ada Paket -
                                    </td>
                                    <td class="px-3 py-5 text-right pr-8">
                                        <span
                                            class="px-2 py-1 rounded bg-gray-100 dark:bg-gray-800 text-[9px] font-bold text-gray-400 uppercase">
                                            -
                                        </span>
                                    </td>
                                </tr>

                                <template
                                    v-else
                                    v-for="(paket, pIndex) in prk.pakets"
                                    :key="paket.id">
                                    <tr
                                        @click="toggleExpand(paket.id)"
                                        class="group cursor-pointer hover:bg-sky-50/50 dark:hover:bg-sky-900/10 transition-all duration-200"
                                        :class="
                                            isExpanded(paket.id)
                                                ? 'bg-sky-50/30 dark:bg-sky-900/5'
                                                : ''
                                        ">
                                        <td class="py-5 pl-8 pr-3">
                                            <div class="flex items-center gap-4">
                                                <svg
                                                    class="w-4 h-4 text-sky-500 transition-transform"
                                                    :class="{ 'rotate-90': isExpanded(paket.id) }"
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
                                                    <span class="text-xs font-mono text-sky-600">
                                                        #{{ prk.tahun }}
                                                    </span>
                                                    <span
                                                        class="text-[9px] font-mono text-gray-400 uppercase tracking-tighter">
                                                        Paket {{ pIndex + 1 }}
                                                    </span>
                                                </div>
                                            </div>
                                        </td>

                                        <td class="px-3 py-5">
                                            <div class="flex flex-col">
                                                <span
                                                    class="font-semibold text-[var(--color-text)] text-gray-800 dark:text-gray-200 group-hover:text-sky-600 transition-colors">
                                                    {{ prk.uraian || '-' }}
                                                </span>
                                                <div class="flex items-center gap-2 mt-1">
                                                    <span
                                                        class="text-xs font-mono font-bold text-gray-400 bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 rounded">
                                                        {{ prk.prk }}
                                                    </span>
                                                    <span
                                                        class="text-xs text-gray-400 uppercase font-medium">
                                                        {{ prk.bidang?.name || 'N/A' }}
                                                    </span>
                                                </div>
                                            </div>
                                        </td>

                                        <td class="px-3 py-5">
                                            <div class="flex flex-col">
                                                <span
                                                    class="text-sm text-emerald-600 font-bold dark:text-emerald-400">
                                                    {{ formatRupiah(hitungTotalBayar(paket)) }}
                                                </span>
                                                <span
                                                    class="text-[9px] text-gray-400 uppercase font-bold tracking-widest">
                                                    Confirmed
                                                </span>
                                            </div>
                                        </td>

                                        <td class="px-3 py-5 text-right pr-8">
                                            <span :class="getStatusStyles(paket).badge">
                                                {{ getStatusTahapan(paket) }}
                                            </span>
                                        </td>
                                    </tr>

                                    <tr v-if="isExpanded(paket.id)">
                                        <td colspan="4" class="p-0 bg-gray-50/50 dark:bg-black/20">
                                            <div class="p-8 border-x-4 border-sky-500/20">
                                                <div
                                                    class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                                                    <div
                                                        v-for="item in getStatItems(paket)"
                                                        :key="item.label"
                                                        class="bg-white dark:bg-gray-800 p-4 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700">
                                                        <p
                                                            class="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">
                                                            {{ item.label }}
                                                        </p>
                                                        <p
                                                            class="text-sm font-bold text-gray-800 dark:text-gray-100">
                                                            {{ item.value || '-' }}
                                                        </p>
                                                    </div>
                                                </div>

                                                <div
                                                    class="bg-white dark:bg-gray-800 p-6 rounded-3xl shadow-sm border border-gray-100 dark:border-gray-700">
                                                    <div class="flex justify-between relative">
                                                        <div
                                                            class="absolute top-4 left-0 w-full h-0.5 bg-gray-100 dark:bg-gray-700 -z-0"></div>

                                                        <div
                                                            v-for="(step, sIdx) in getSteps(paket)"
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
                                    </tr>
                                </template>
                            </template>
                        </tbody>
                    </table>
                </div>

                <div class="mt-6 flex items-center justify-between">
                    <div class="text-sm text-gray-500">
                        Menampilkan {{ prks.from }} sampai {{ prks.to }} dari {{ prks.total }} data
                        PRK
                    </div>
                    <div class="flex gap-1">
                        <template v-for="(link, k) in prks.links" :key="k">
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
            </section>
        </div>
    </main>
</template>
