<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import RendanSearchSelect from './RendanSearchSelect.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
import { ref } from 'vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    data: {
        type: Object,
        required: true // Data Lakdan yang akan diedit
    },
    // Daftar Rendan yang tersedia untuk dipilih di form
    rendans: {
        type: Array,
        default: () => []
    }
})

// Helper untuk format tanggal dari database (YYYY-MM-DD HH:MM:SS) ke input date (YYYY-MM-DD)
const formatDate = dateString => {
    if (!dateString) return null
    try {
        // Coba format YYYY-MM-DD
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString // Kembalikan string asli jika gagal
    }
}

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN HPS ---
const isUploadingHps = ref(false)
const uploadedHpsPath = ref(null)
const uploadedHpsName = ref(null)
const uploadHpsError = ref(null)
const existingHpsPath = ref(props.data.dokumen_hps)
const existingHpsName = ref(props.data.dokumen_hps ? props.data.dokumen_hps.split('/').pop() : null)

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN PENUNJUKAN PEMENANG ---
const isUploadingPemenang = ref(false)
const uploadedPemenangPath = ref(null)
const uploadedPemenangName = ref(null)
const uploadPemenangError = ref(null)
const existingPemenangPath = ref(props.data.dokumen_penunjukan_pemenang)
const existingPemenangName = ref(
    props.data.dokumen_penunjukan_pemenang
        ? props.data.dokumen_penunjukan_pemenang.split('/').pop()
        : null
)

// --- Inisialisasi Form LAKDAN dengan data yang ada ---
const form = useForm({
    _method: 'put',

    // Foreign Key
    rendan_id: props.data.rendan_id,

    // Core Lakdan Fields
    pic: props.data.pic,
    proses_pengadaan: props.data.proses_pengadaan,
    metode_pengadaan: props.data.metode_pengadaan,

    // HPS Fields
    rencana_tanggal_hps: formatDate(props.data.rencana_tanggal_hps),
    realisasi_tanggal_hps: formatDate(props.data.realisasi_tanggal_hps),
    nomor_hps: props.data.nomor_hps,
    nilai_hps: props.data.nilai_hps,
    dokumen_hps: props.data.dokumen_hps,

    // Pengumuman Lelang Fields
    rencana_pengumuman_lelang: formatDate(props.data.rencana_pengumuman_lelang),
    realisasi_pengumuman_lelang: formatDate(props.data.realisasi_pengumuman_lelang),
    nomor_pengumuman_lelang: props.data.nomor_pengumuman_lelang,

    // Penunjukan Pemenang Fields
    rencana_penunjukan_pemenang: formatDate(props.data.rencana_penunjukan_pemenang),
    realisasi_penunjukan_pemenang: formatDate(props.data.realisasi_penunjukan_pemenang),
    nomor_penunjukan_pemenang: props.data.nomor_penunjukan_pemenang,
    dokumen_penunjukan_pemenang: props.data.dokumen_penunjukan_pemenang,

    // 1. Persiapan Pengadaan
    rencana_persiapan_pengadaan: formatDate(props.data.rencana_persiapan_pengadaan),
    realisasi_persiapan_pengadaan: formatDate(props.data.realisasi_persiapan_pengadaan),
    persiapan_pengadaan: props.data.persiapan_pengadaan || '',

    // 2. Pengumuman Pengadaan
    rencana_pengumuman_pengadaan: formatDate(props.data.rencana_pengumuman_pengadaan),
    realisasi_pengumuman_pengadaan: formatDate(props.data.realisasi_pengumuman_pengadaan),
    pengumuman_pengadaan: props.data.pengumuman_pengadaan || '',

    // 3. Pendaftaran & Pengambilan Dokumen
    rencana_pendaftaran_ambil_dokumen: formatDate(props.data.rencana_pendaftaran_ambil_dokumen),
    realisasi_pendaftaran_ambil_dokumen: formatDate(props.data.realisasi_pendaftaran_ambil_dokumen),
    pendaftaran_ambil_dokumen: props.data.pendaftaran_ambil_dokumen || '',

    // 4. Aanwijzing
    rencana_aanwijzing: formatDate(props.data.rencana_aanwijzing),
    realisasi_aanwijzing: formatDate(props.data.realisasi_aanwijzing),
    aanwijzing: props.data.aanwijzing || '',

    // 5. Pemasukan Dokumen Penawaran
    rencana_pemasukan_penawaran: formatDate(props.data.rencana_pemasukan_penawaran),
    realisasi_pemasukan_penawaran: formatDate(props.data.realisasi_pemasukan_penawaran),
    pemasukan_penawaran: props.data.pemasukan_penawaran || '',

    // 6. Pembukaan Dokumen dan Evaluasi
    rencana_pembukaan_evaluasi: formatDate(props.data.rencana_pembukaan_evaluasi),
    realisasi_pembukaan_evaluasi: formatDate(props.data.realisasi_pembukaan_evaluasi),
    pembukaan_evaluasi: props.data.pembukaan_evaluasi || '',

    // 7. Klarifikasi dan Negosiasi Harga
    rencana_klarifikasi_negosiasi: formatDate(props.data.rencana_klarifikasi_negosiasi),
    realisasi_klarifikasi_negosiasi: formatDate(props.data.realisasi_klarifikasi_negosiasi),
    klarifikasi_negosiasi: props.data.klarifikasi_negosiasi || '',

    // 8. Usulan Penetapan Pemenang
    rencana_usulan_penetapan_pemenang: formatDate(props.data.rencana_usulan_penetapan_pemenang),
    realisasi_usulan_penetapan_pemenang: formatDate(props.data.realisasi_usulan_penetapan_pemenang),
    usulan_penetapan_pemenang: props.data.usulan_penetapan_pemenang || '',

    // 9. Izin Prinsip Tanda Tangan Kontrak
    rencana_izin_prinsip_kontrak: formatDate(props.data.rencana_izin_prinsip_kontrak),
    realisasi_izin_prinsip_kontrak: formatDate(props.data.realisasi_izin_prinsip_kontrak),
    izin_prinsip_kontrak: props.data.izin_prinsip_kontrak || '',

    // 10. Penetapan dan Pengumuman Pemenang
    rencana_penetapan_pengumuman_pemenang: formatDate(
        props.data.rencana_penetapan_pengumuman_pemenang
    ),
    realisasi_penetapan_pengumuman_pemenang: formatDate(
        props.data.realisasi_penetapan_pengumuman_pemenang
    ),
    penetapan_pengumuman_pemenang: props.data.penetapan_pengumuman_pemenang || '',

    // 11. Sanggah
    rencana_sanggah: formatDate(props.data.rencana_sanggah),
    realisasi_sanggah: formatDate(props.data.realisasi_sanggah),
    sanggah: props.data.sanggah || '',

    // 12. Penunjukan Penyedia Barang/Jasa
    rencana_penunjukan_penyedia: formatDate(props.data.rencana_penunjukan_penyedia),
    realisasi_penunjukan_penyedia: formatDate(props.data.realisasi_penunjukan_penyedia),
    penunjukan_penyedia: props.data.penunjukan_penyedia || '',
    dokumen_penunjukan_penyedia: props.data.dokumen_penunjukan_penyedia || '',

    // 13. Contract Discussion Agreement (CDA)
    rencana_cda: formatDate(props.data.rencana_cda),
    realisasi_cda: formatDate(props.data.realisasi_cda),
    cda: props.data.cda || ''
})

// --- Fungsi Reusable Upload File ---
const handleFileUpload = async (event, field) => {
    const file = event.target.files[0]
    if (!file) return

    // Tentukan state yang relevan
    const isUploadingRef = field === 'hps' ? isUploadingHps : isUploadingPemenang
    const uploadedPathRef = field === 'hps' ? uploadedHpsPath : uploadedPemenangPath
    const uploadedNameRef = field === 'hps' ? uploadedHpsName : uploadedPemenangName
    const uploadErrorRef = field === 'hps' ? uploadHpsError : uploadPemenangError
    const existingPathRef = field === 'hps' ? existingHpsPath : existingPemenangPath
    const existingNameRef = field === 'hps' ? existingHpsName : existingPemenangName
    const fieldName = field === 'hps' ? 'HPS' : 'Penunjukan Pemenang'

    isUploadingRef.value = true
    uploadErrorRef.value = null
    uploadedPathRef.value = null
    uploadedNameRef.value = null

    // Hapus tampilan file lama jika ada upload baru
    existingPathRef.value = null
    existingNameRef.value = null

    const formData = new FormData()
    formData.append('file', file)

    try {
        const response = await fetch(route('upload.digital-document'), {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })

        const data = await response.json()
        if (response.ok && data.success) {
            uploadedPathRef.value = data.path
            uploadedNameRef.value = data.filename

            // Simpan path ke form untuk dikirim ke controller Laravel
            form[`dokumen_${field}_path`] = data.path
            form[`dokumen_${field}_name`] = data.filename
        } else {
            uploadErrorRef.value = data.message || `Gagal mengunggah file Dokumen ${fieldName}.`
        }
    } catch (error) {
        uploadErrorRef.value = `Terjadi kesalahan jaringan saat mengunggah Dokumen ${fieldName}.`
    } finally {
        isUploadingRef.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Menggunakan form.post untuk mengirim data ke route update (Laravel Inertia convention for PUT/PATCH)
    // Rute disesuaikan ke admin.lakdan.update
    form.post(route('admin.lakdan.update', props.data.id), {
        preserveScroll: true
    })
}

// Konversi daftar Rendan dari props ke format opsi select
const rendanOptions = props.rendans.map(rendan => ({
    label: `${rendan.nomor_nd_user} (ID: ${rendan.id})`, // Tampilkan nomor ND User Rendan
    value: rendan.id // Nilai yang dikirim adalah ID Rendan
}))
</script>

<template>
    <Head :title="`Edit Data Lakdan ID: ${props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-lakdan">
        <h1 class="sr-only" id="edit-lakdan">Edit Data Pelaksanaan Pengadaan</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Pelaksanaan Pengadaan (Lakdan) ID: ${props.data.id}`"
                description="Perbarui detail lengkap Pelaksanaan Pengadaan."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Lakdan',
                        href: route('admin.lakdan.index') // Rute disesuaikan
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Utama Pengadaan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih Rendan terkait dan metode pelaksanaan.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <RendanSearchSelect
                                label="Data Rendan Terkait (ND User)"
                                v-model="form.rendan_id"
                                :rendans="props.rendans"
                                :error="form.errors.rendan_id"
                                placeholder="Cari Nomor ND User Rendan"
                                :disabled="true" />

                            <FormInput
                                label="Proses Pengadaan"
                                v-model="form.proses_pengadaan"
                                :error="form.errors.proses_pengadaan"
                                placeholder="Cth: E-Proc, Manual" />

                            <FormInput
                                label="Metode Pengadaan"
                                v-model="form.metode_pengadaan"
                                :error="form.errors.metode_pengadaan"
                                placeholder="Cth: Tender Terbuka, Penunjukan Langsung" />

                            <FormInput
                                label="PIC"
                                v-model="form.pic"
                                :error="form.errors.pic"
                                placeholder="Cth: ..." />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Harga Perkiraan Sendiri (HPS)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail dokumen Harga Perkiraan Sendiri.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor HPS"
                                v-model="form.nomor_hps"
                                :error="form.errors.nomor_hps"
                                placeholder="Cth: 001.HPS/DAN.01.03/..." />

                            <FormInput
                                label="Rencana Tanggal HPS"
                                type="date"
                                v-model="form.rencana_tanggal_hps"
                                :error="form.errors.rencana_tanggal_hps" />

                            <FormInput
                                label="Realisasi Tanggal HPS"
                                type="date"
                                v-model="form.realisasi_tanggal_hps"
                                :error="form.errors.realisasi_tanggal_hps" />
                        </div>

                        <div
                            class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-4 border-t border-gray-200 dark:border-gray-600">
                            <FileManagerInput
                                label="Dokumen HPS"
                                v-model="form.dokumen_hps"
                                :error="form.errors.dokumen_hps"
                                placeholder="Pilih Dokumen" />

                            <FormCurrency
                                label="Nilai HPS (Rupiah)"
                                v-model="form.nilai_hps"
                                :error="form.errors.nilai_hps"
                                placeholder="HPS Rupiah" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Tahapan Lelang
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail jadwal dan nomor tahapan pelaksanaan pengadaan.
                            </p>
                        </div>

                        <div class="space-y-8">
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                                <FormInput
                                    label="Persiapan Pengadaan"
                                    v-model="form.persiapan_pengadaan"
                                    :error="form.errors.persiapan_pengadaan" />
                                <FormInput
                                    label="Rencana Tgl. Persiapan"
                                    type="date"
                                    v-model="form.rencana_persiapan_pengadaan"
                                    :error="form.errors.rencana_persiapan_pengadaan" />
                                <FormInput
                                    label="Realisasi Tgl. Persiapan"
                                    type="date"
                                    v-model="form.realisasi_persiapan_pengadaan"
                                    :error="form.errors.realisasi_persiapan_pengadaan" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Pengumuman Pengadaan "
                                    v-model="form.pengumuman_pengadaan"
                                    :error="form.errors.pengumuman_pengadaan" />
                                <FormInput
                                    label="Rencana Tgl. Pengumuman"
                                    type="date"
                                    v-model="form.rencana_pengumuman_pengadaan"
                                    :error="form.errors.rencana_pengumuman_pengadaan" />
                                <FormInput
                                    label="Realisasi Tgl. Pengumuman"
                                    type="date"
                                    v-model="form.realisasi_pengumuman_pengadaan"
                                    :error="form.errors.realisasi_pengumuman_pengadaan" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Pendaftaran Dokumen"
                                    v-model="form.pendaftaran_ambil_dokumen"
                                    :error="form.errors.pendaftaran_ambil_dokumen" />
                                <FormInput
                                    label="Rencana Tgl. Pendaftaran"
                                    type="date"
                                    v-model="form.rencana_pendaftaran_ambil_dokumen"
                                    :error="form.errors.rencana_pendaftaran_ambil_dokumen" />
                                <FormInput
                                    label="Realisasi Tgl. Pendaftaran"
                                    type="date"
                                    v-model="form.realisasi_pendaftaran_ambil_dokumen"
                                    :error="form.errors.realisasi_pendaftaran_ambil_dokumen" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Aanwijzing"
                                    v-model="form.aanwijzing"
                                    :error="form.errors.aanwijzing" />
                                <FormInput
                                    label="Rencana Tgl. Aanwijzing"
                                    type="date"
                                    v-model="form.rencana_aanwijzing"
                                    :error="form.errors.rencana_aanwijzing" />
                                <FormInput
                                    label="Realisasi Tgl. Aanwijzing"
                                    type="date"
                                    v-model="form.realisasi_aanwijzing"
                                    :error="form.errors.realisasi_aanwijzing" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Pemasukan Penawaran (No/Ref)"
                                    v-model="form.pemasukan_penawaran"
                                    :error="form.errors.pemasukan_penawaran" />
                                <FormInput
                                    label="Rencana Tgl. Pemasukan"
                                    type="date"
                                    v-model="form.rencana_pemasukan_penawaran"
                                    :error="form.errors.rencana_pemasukan_penawaran" />
                                <FormInput
                                    label="Realisasi Tgl. Pemasukan"
                                    type="date"
                                    v-model="form.realisasi_pemasukan_penawaran"
                                    :error="form.errors.realisasi_pemasukan_penawaran" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Pembukaan & Evaluasi"
                                    v-model="form.pembukaan_evaluasi"
                                    :error="form.errors.pembukaan_evaluasi" />
                                <FormInput
                                    label="Rencana Tgl. Evaluasi"
                                    type="date"
                                    v-model="form.rencana_pembukaan_evaluasi"
                                    :error="form.errors.rencana_pembukaan_evaluasi" />
                                <FormInput
                                    label="Realisasi Tgl. Evaluasi"
                                    type="date"
                                    v-model="form.realisasi_pembukaan_evaluasi"
                                    :error="form.errors.realisasi_pembukaan_evaluasi" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Klarifikasi & Negosiasi"
                                    v-model="form.klarifikasi_negosiasi"
                                    :error="form.errors.klarifikasi_negosiasi" />
                                <FormInput
                                    label="Rencana Tgl. Negosiasi"
                                    type="date"
                                    v-model="form.rencana_klarifikasi_negosiasi"
                                    :error="form.errors.rencana_klarifikasi_negosiasi" />
                                <FormInput
                                    label="Realisasi Tgl. Negosiasi"
                                    type="date"
                                    v-model="form.realisasi_klarifikasi_negosiasi"
                                    :error="form.errors.realisasi_klarifikasi_negosiasi" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Usulan Pemenang "
                                    v-model="form.usulan_penetapan_pemenang"
                                    :error="form.errors.usulan_penetapan_pemenang" />
                                <FormInput
                                    label="Rencana Tgl. Usulan"
                                    type="date"
                                    v-model="form.rencana_usulan_penetapan_pemenang"
                                    :error="form.errors.rencana_usulan_penetapan_pemenang" />
                                <FormInput
                                    label="Realisasi Tgl. Usulan"
                                    type="date"
                                    v-model="form.realisasi_usulan_penetapan_pemenang"
                                    :error="form.errors.realisasi_usulan_penetapan_pemenang" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Izin Prinsip Kontrak"
                                    v-model="form.izin_prinsip_kontrak"
                                    :error="form.errors.izin_prinsip_kontrak" />
                                <FormInput
                                    label="Rencana Tgl. Izin"
                                    type="date"
                                    v-model="form.rencana_izin_prinsip_kontrak"
                                    :error="form.errors.rencana_izin_prinsip_kontrak" />
                                <FormInput
                                    label="Realisasi Tgl. Izin"
                                    type="date"
                                    v-model="form.realisasi_izin_prinsip_kontrak"
                                    :error="form.errors.realisasi_izin_prinsip_kontrak" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Penetapan Pemenang"
                                    v-model="form.penetapan_pengumuman_pemenang"
                                    :error="form.errors.penetapan_pengumuman_pemenang" />
                                <FormInput
                                    label="Rencana Tgl. Penetapan"
                                    type="date"
                                    v-model="form.rencana_penetapan_pengumuman_pemenang"
                                    :error="form.errors.rencana_penetapan_pengumuman_pemenang" />
                                <FormInput
                                    label="Realisasi Tgl. Penetapan"
                                    type="date"
                                    v-model="form.realisasi_penetapan_pengumuman_pemenang"
                                    :error="form.errors.realisasi_penetapan_pengumuman_pemenang" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Sanggah"
                                    v-model="form.sanggah"
                                    :error="form.errors.sanggah" />
                                <FormInput
                                    label="Rencana Tgl. Sanggah"
                                    type="date"
                                    v-model="form.rencana_sanggah"
                                    :error="form.errors.rencana_sanggah" />
                                <FormInput
                                    label="Realisasi Tgl. Sanggah"
                                    type="date"
                                    v-model="form.realisasi_sanggah"
                                    :error="form.errors.realisasi_sanggah" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="Penunjukan Penyedia "
                                    v-model="form.penunjukan_penyedia"
                                    :error="form.errors.penunjukan_penyedia" />
                                <FormInput
                                    label="Rencana Tgl. Penunjukan"
                                    type="date"
                                    v-model="form.rencana_penunjukan_penyedia"
                                    :error="form.errors.rencana_penunjukan_penyedia" />
                                <FormInput
                                    label="Realisasi Tgl. Penunjukan"
                                    type="date"
                                    v-model="form.realisasi_penunjukan_penyedia"
                                    :error="form.errors.realisasi_penunjukan_penyedia" />

                                <FileManagerInput
                                    label="Dokumen Penunjukan"
                                    v-model="form.dokumen_penunjukan_penyedia"
                                    :error="form.errors.dokumen_penunjukan_penyedia"
                                    placeholder="Pilih Dokumen" />
                            </div>

                            <div
                                class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-8 border-t border-gray-200 dark:border-gray-600">
                                <FormInput
                                    label="CDA"
                                    v-model="form.cda"
                                    :error="form.errors.cda" />
                                <FormInput
                                    label="Rencana Tgl. CDA"
                                    type="date"
                                    v-model="form.rencana_cda"
                                    :error="form.errors.rencana_cda" />
                                <FormInput
                                    label="Realisasi Tgl. CDA"
                                    type="date"
                                    v-model="form.realisasi_cda"
                                    :error="form.errors.realisasi_cda" />
                            </div>
                        </div>
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="form.processing || isUploadingHps || isUploadingPemenang"
                        :aria-busy="form.processing || isUploadingHps || isUploadingPemenang">
                        <svg
                            v-if="form.processing || isUploadingHps || isUploadingPemenang"
                            class="animate-spin h-4 w-4"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            aria-hidden="true">
                            <circle
                                class="opacity-25"
                                cx="12"
                                cy="12"
                                r="10"
                                stroke="currentColor"
                                stroke-width="4" />
                            <path
                                class="opacity-75"
                                fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
                        </svg>
                        {{ form.processing ? 'Memperbarui...' : 'Update Lakdan' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
