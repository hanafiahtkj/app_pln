<script setup>
import { Link } from '@inertiajs/vue3'

// Definisi Props
const props = defineProps({
    paket: {
        type: Object,
        required: true
    },
    hasAccess: {
        type: Boolean,
        default: false
    }
})

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
</script>

<template>
    <section class="relative group">
        <div
            :class="[
                'absolute -left-3 top-6 hidden lg:flex items-center justify-center w-8 h-8 rounded-full text-xs font-bold z-10 border-4 border-white dark:border-gray-900 transition-all shadow-sm',
                paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran?.length > 0
                    ? 'bg-rose-600 text-white'
                    : 'bg-gray-200 text-gray-500'
            ]">
            07
        </div>

        <div
            v-if="paket.enjiniring?.rendan?.lakdan?.kontrak?.pembayaran?.length > 0"
            class="space-y-8">
            <div
                v-for="(bayar, index) in paket.enjiniring.rendan.lakdan.kontrak.pembayaran"
                :key="bayar.id || index"
                class="bg-white dark:bg-gray-900 border border-gray-300 dark:border-gray-700 p-7 rounded-2xl shadow-xs hover:shadow-md transition-all border-l-[6px] border-l-rose-600">
                <div
                    class="flex flex-wrap justify-between items-center mb-8 pb-4 border-b border-gray-200 dark:border-gray-800 gap-4">
                    <div class="flex items-center gap-4">
                        <div class="flex items-center gap-2">
                            <div class="w-2.5 h-2.5 rounded-full bg-rose-600"></div>
                            <h3
                                class="text-xs font-bold text-gray-800 dark:text-gray-200 uppercase tracking-widest">
                                Informasi Pembayaran - Termin {{ index + 1 }}
                            </h3>
                        </div>
                    </div>
                    <Link
                        v-if="hasAccess"
                        :href="route('admin.pembayaran.edit', bayar.id)"
                        class="text-xs font-bold text-blue-600 hover:underline uppercase">
                        PERBARUI DATA
                    </Link>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Termin Pembayaran
                        </p>
                        <p class="text-sm font-semibold text-gray-900 dark:text-white">
                            {{ bayar.termin_pembayaran }}
                        </p>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Denda
                        </p>
                        <p
                            :class="[
                                'text-sm font-bold',
                                bayar.denda > 0 ? 'text-rose-600' : 'text-gray-400'
                            ]">
                            {{ formatIDR(bayar.denda) || 'Rp 0' }}
                        </p>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Total Nilai Tagihan
                        </p>
                        <p class="text-xl font-bold text-gray-900 dark:text-white">
                            {{ formatIDR(bayar.nilai_tagihan) }}
                        </p>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Nilai AKB
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ formatIDR(bayar.nilai_akb) }}
                        </p>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Nilai Bayar Vendor
                        </p>
                        <p class="text-lg font-bold text-emerald-600">
                            {{ formatIDR(bayar.nilai_bayar_vendor) }}
                        </p>
                    </div>

                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Pajak PPN
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ formatIDR(bayar.nilai_ppn) || 'Rp 0' }}
                        </p>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Pajak PPH
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ formatIDR(bayar.nilai_pph) || 'Rp 0' }}
                        </p>
                    </div>
                    <div class="space-y-1">
                        <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                            Nilai Bayar Pajak
                        </p>
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                            {{ formatIDR(bayar.nilai_bayar_pajak) || 'Rp 0' }}
                        </p>
                    </div>
                </div>

                <section class="dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                Tanggal Rencana & Realisasi Pembayaran
                            </h3>
                        </div>

                        <div
                            class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-y-10 gap-x-6 mb-10">
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Bayar Vendor (Rencana)
                                </p>
                                <p
                                    :class="[
                                        'text-sm font-bold',
                                        bayar.rencana_bayar
                                            ? 'text-emerald-600'
                                            : 'text-gray-400 italic'
                                    ]">
                                    {{ formatTgl(bayar.rencana_bayar) || '-' }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Bayar Vendor (Realisasi)
                                </p>
                                <p
                                    :class="[
                                        'text-sm font-bold',
                                        bayar.realisasi_bayar
                                            ? 'text-emerald-600'
                                            : 'text-gray-400 italic'
                                    ]">
                                    {{ formatTgl(bayar.realisasi_bayar) || 'Menunggu Transfer' }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Bayar Pajak (Rencana)
                                </p>
                                <p
                                    :class="[
                                        'text-sm font-bold',
                                        bayar.rencana_bayar_pajak
                                            ? 'text-emerald-600'
                                            : 'text-gray-400 italic'
                                    ]">
                                    {{ formatTgl(bayar.rencana_bayar_pajak) || '-' }}
                                </p>
                            </div>
                            <div class="space-y-1">
                                <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                    Tgl Bayar Pajak (Realisasi)
                                </p>
                                <p
                                    :class="[
                                        'text-sm font-bold',
                                        bayar.realisasi_bayar_pajak
                                            ? 'text-emerald-600'
                                            : 'text-gray-400 italic'
                                    ]">
                                    {{ formatTgl(bayar.realisasi_bayar_pajak) || 'Belum Setor' }}
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                Status Dokumen / Checklist
                            </h3>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                            <div v-for="field in checklistFields" :key="field.key">
                                <label class="flex items-center space-x-2 cursor-pointer">
                                    <input
                                        type="checkbox"
                                        :id="`${field.key}-${bayar.id}`"
                                        v-model="bayar[field.key]"
                                        :true-value="1"
                                        :false-value="0"
                                        :disabled="!hasAccess"
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
                    <p class="text-xs text-gray-600 dark:text-gray-400 leading-relaxed italic">
                        <span class="font-bold text-rose-600 not-italic mr-1 uppercase">
                            Catatan:
                        </span>
                        {{ bayar.keterangan || '-' }}
                    </p>
                </div>
            </div>

            <div class="flex justify-center mt-4">
                <Link
                    :href="
                        route('admin.pembayaran.create', {
                            kontrak_id: paket.enjiniring.rendan.lakdan.kontrak.id
                        })
                    "
                    class="text-xs font-bold bg-rose-50 text-rose-600 border border-rose-200 px-6 py-2 rounded-full hover:bg-rose-600 hover:text-white transition-all">
                    + TAMBAH TERMIN PEMBAYARAN
                </Link>
            </div>
        </div>

        <div
            v-else
            class="bg-gray-50/50 dark:bg-gray-800/10 border-2 border-dashed border-gray-400 dark:border-gray-700 p-12 rounded-2xl text-center">
            <div
                class="mb-4 inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-200 text-gray-600 border border-gray-300 shadow-inner">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                        stroke-width="2"
                        stroke-linecap="round"
                        stroke-linejoin="round" />
                </svg>
            </div>

            <p class="text-sm font-bold text-gray-700 dark:text-gray-400 mb-6 italic">
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
</template>
