<script setup>
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
</script>

<template>
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
                    v-if="hasAccess"
                    :href="route('admin.lakdan.edit', paket.enjiniring.rendan.lakdan.id)"
                    class="text-xs font-bold text-blue-600 hover:underline uppercase">
                    PERBARUI DATA
                </Link>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                <div class="space-y-1">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                        Proses Pengadaan
                    </p>
                    <p class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                        {{ paket.enjiniring.rendan.lakdan.proses_pengadaan || '-' }}
                    </p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                        Metode Pengadaan
                    </p>
                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                        {{ paket.enjiniring.rendan.lakdan.metode_pengadaan || '-' }}
                    </p>
                </div>
                <div class="space-y-1">
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">PIC</p>
                    <p class="text-sm font-bold text-gray-900 dark:text-white">
                        {{ paket.enjiniring.rendan.lakdan.pic || '-' }}
                    </p>
                </div>
            </div>

            <section class="dark:bg-gray-700">
                <div class="max-w-4xl space-y-6">
                    <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            Harga Perkiraan Sendiri (HPS)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail dokumen Harga Perkiraan Sendiri.
                        </p>
                    </div>

                    <div
                        class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-y-8 gap-x-6 mb-8">
                        <div class="space-y-1">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                Nomor HPS
                            </p>
                            <p
                                class="text-sm font-semibold text-gray-800 dark:text-gray-300 font-mono">
                                {{ paket.enjiniring.rendan.lakdan.nomor_hps || '-' }}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                Dokumen HPS
                            </p>

                            <div v-if="paket.enjiniring.rendan.lakdan.dokumen_hps">
                                <a
                                    @click="
                                        openPdfPreview(paket.enjiniring.rendan.lakdan.dokumen_hps)
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
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                Nilai HPS
                            </p>
                            <p class="text-sm font-bold text-gray-900 dark:text-white">
                                {{ formatIDR(paket.enjiniring.rendan.lakdan.nilai_hps) }}
                            </p>
                        </div>

                        <div class="space-y-1">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                Tgl HPS (Rencana)
                            </p>
                            <p class="text-sm font-semibold text-gray-800 dark:text-gray-300">
                                {{ formatTgl(paket.enjiniring.rendan.lakdan.rencana_tanggal_hps) }}
                            </p>
                        </div>
                        <div class="space-y-1">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-wider">
                                Tgl HPS (Realisasi)
                            </p>
                            <p class="text-sm font-bold text-emerald-600">
                                {{
                                    formatTgl(
                                        paket.enjiniring.rendan.lakdan.realisasi_tanggal_hps
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
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            Tahapan Pelaksanaan Pengadaan
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail jadwal dan referensi tahapan pelaksanaan pengadaan.
                        </p>
                    </div>

                    <div class="space-y-8 mb-8">
                        <template
                            v-for="(label, key) in {
                                persiapan_pengadaan: 'Persiapan Pengadaan',
                                pengumuman_pengadaan: 'Pengumuman Pengadaan',
                                pendaftaran_ambil_dokumen: 'Pendaftaran & Ambil Dokumen',
                                aanwijzing: 'Aanwijzing',
                                pemasukan_penawaran: 'Pemasukan Dokumen Penawaran',
                                pembukaan_evaluasi: 'Pembukaan & Evaluasi',
                                klarifikasi_negosiasi: 'Klarifikasi & Negosiasi Harga',
                                usulan_penetapan_pemenang: 'Usulan Penetapan Pemenang',
                                izin_prinsip_kontrak: 'Izin Prinsip Tanda Tangan Kontrak',
                                penetapan_pengumuman_pemenang: 'Penetapan & Pengumuman Pemenang',
                                sanggah: 'Sanggah',
                                penunjukan_penyedia: 'Penunjukan Penyedia Barang/Jasa',
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
                                        {{ paket.enjiniring.rendan.lakdan[key] || '-' }}
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
                                                paket.enjiniring.rendan.lakdan['rencana_' + key]
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
                                            paket.enjiniring.rendan.lakdan['realisasi_' + key]
                                                ? 'text-emerald-600'
                                                : 'text-gray-400 italic'
                                        ]">
                                        {{
                                            formatTgl(
                                                paket.enjiniring.rendan.lakdan['realisasi_' + key]
                                            ) || 'Belum Realisasi'
                                        }}
                                    </p>
                                </div>

                                <div
                                    v-if="
                                        key == 'penunjukan_penyedia' &&
                                        paket.enjiniring.rendan.lakdan.dokumen_penunjukan_penyedia
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
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
</template>
