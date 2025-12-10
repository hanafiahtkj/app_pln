<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import { ref } from 'vue'

defineOptions({ layout: Default })

const props = defineProps({
    data: {
        type: Object,
        required: true // Data Kontrak yang akan diedit
    },
    // Daftar Lakdan yang tersedia untuk dipilih di form
    lakdans: {
        type: Array,
        default: () => []
    }
})

// Helper untuk format tanggal dari database ke input date (YYYY-MM-DD)
const formatDate = dateString => {
    if (!dateString) return null
    try {
        // Coba format YYYY-MM-DD
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString // Kembalikan string asli jika gagal
    }
}

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN PERJANJIAN (KONTRAK) ---
const isUploadingPerjanjian = ref(false)
const uploadedPerjanjianPath = ref(null)
const uploadedPerjanjianName = ref(null)
const uploadPerjanjianError = ref(null)
const existingPerjanjianPath = ref(props.data.dokumen_perjanjian)
const existingPerjanjianName = ref(
    props.data.dokumen_perjanjian ? props.data.dokumen_perjanjian.split('/').pop() : null
)

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN JAMINAN PELAKSANAAN ---
const isUploadingJaminan = ref(false)
const uploadedJaminanPath = ref(null)
const uploadedJaminanName = ref(null)
const uploadJaminanError = ref(null)
const existingJaminanPath = ref(props.data.dokumen_jaminan_pelaksanaan)
const existingJaminanName = ref(
    props.data.dokumen_jaminan_pelaksanaan
        ? props.data.dokumen_jaminan_pelaksanaan.split('/').pop()
        : null
)

// Opsi status proses, jenis perjanjian, dan risiko CSMS
const statusOptions = [
    { label: 'Terkontrak', value: 'TERKONTRAK' },
    { label: 'Progress', value: 'PROGRESS' },
    { label: 'Selesai', value: 'SELESAI' },
    { label: 'Batal', value: 'BATAL' }
]

const jenisPerjanjianOptions = [
    { label: 'Lump Sum', value: 'LUMSUM' },
    { label: 'Harga Satuan', value: 'HARGA SATUAN' },
    { label: 'Gabungan Lump Sum & Harga Satuan', value: 'GABUNGAN' }
]

const risikoCsmsOptions = [
    { label: 'Ekstrem', value: 'Ekstrem' },
    { label: 'Tinggi', value: 'Tinggi' },
    { label: 'Sedang', value: 'Sedang' },
    { label: 'Rendah', value: 'Rendah' }
]

// --- Inisialisasi Form KONTRAK dengan data yang ada ---
const form = useForm({
    _method: 'put',

    // Foreign Key
    lakdan_id: props.data.lakdan_id,

    // Core Kontrak Fields
    penyedia_barang_jasa: props.data.penyedia_barang_jasa,
    jenis_perjanjian: props.data.jenis_perjanjian,
    status_proses: props.data.status_proses,
    keterangan: props.data.keterangan,
    masa_pelaksanaan: props.data.masa_pelaksanaan,
    durasi_pengadaan: props.data.durasi_pengadaan,

    // Date & Numeric Fields
    rencana_tanggal_perjanjian: formatDate(props.data.rencana_tanggal_perjanjian),
    realisasi_tanggal_perjanjian: formatDate(props.data.realisasi_tanggal_perjanjian),
    tanggal_berakhir: formatDate(props.data.tanggal_berakhir),
    nomor_perjanjian: props.data.nomor_perjanjian,
    nilai_perjanjian_ppn: props.data.nilai_perjanjian_ppn,
    nilai_perjanjian_sebelum_ppn: props.data.nilai_perjanjian_sebelum_ppn,

    // Jaminan Pelaksanaan Fields
    rencana_jaminan_pelaksanaan: formatDate(props.data.rencana_jaminan_pelaksanaan),
    realisasi_jaminan_pelaksanaan: formatDate(props.data.realisasi_jaminan_pelaksanaan),
    nomor_jaminan_pelaksanaan: props.data.nomor_jaminan_pelaksanaan,
    nilai_jaminan_pelaksanaan: props.data.nilai_jaminan_pelaksanaan,
    bank_pemberi_jaminan: props.data.bank_pemberi_jaminan,

    // Metric Fields
    tingkat_risiko_csms: props.data.tingkat_risiko_csms,
    tkdn: props.data.tkdn,
    efisiensi_thd_hps: props.data.efisiensi_thd_hps,

    // Document Paths (Only sent if new file is uploaded)
    dokumen_perjanjian_path: null,
    dokumen_perjanjian_name: null,
    dokumen_jaminan_pelaksanaan_path: null,
    dokumen_jaminan_pelaksanaan_name: null
})

// --- Fungsi Reusable Upload File ---
const handleFileUpload = async (event, field) => {
    const file = event.target.files[0]
    if (!file) return

    // Tentukan state yang relevan
    let isUploadingRef, uploadedPathRef, uploadedNameRef, uploadErrorRef
    let existingPathRef, existingNameRef
    let pathFieldName, nameFieldName
    let fieldLabel

    if (field === 'perjanjian') {
        isUploadingRef = isUploadingPerjanjian
        uploadedPathRef = uploadedPerjanjianPath
        uploadedNameRef = uploadedPerjanjianName
        uploadErrorRef = uploadPerjanjianError
        existingPathRef = existingPerjanjianPath
        existingNameRef = existingPerjanjianName
        pathFieldName = 'dokumen_perjanjian_path'
        nameFieldName = 'dokumen_perjanjian_name'
        fieldLabel = 'Dokumen Kontrak'
    } else if (field === 'jaminan_pelaksanaan') {
        isUploadingRef = isUploadingJaminan
        uploadedPathRef = uploadedJaminanPath
        uploadedNameRef = uploadedJaminanName
        uploadErrorRef = uploadJaminanError
        existingPathRef = existingJaminanPath
        existingNameRef = existingJaminanName
        pathFieldName = 'dokumen_jaminan_pelaksanaan_path'
        nameFieldName = 'dokumen_jaminan_pelaksanaan_name'
        fieldLabel = 'Dokumen Jaminan Pelaksanaan'
    } else {
        return
    }

    isUploadingRef.value = true
    uploadErrorRef.value = null
    uploadedPathRef.value = null
    uploadedNameRef.value = null

    // Hapus tampilan file lama jika ada upload baru
    existingPathRef.value = null
    existingNameRef.value = null
    // Pastikan field di form juga disetel ulang jika ada upload baru
    form[pathFieldName] = null
    form[nameFieldName] = null

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
            form[pathFieldName] = data.path
            form[nameFieldName] = data.filename
        } else {
            uploadErrorRef.value = data.message || `Gagal mengunggah ${fieldLabel}.`
        }
    } catch (error) {
        uploadErrorRef.value = `Terjadi kesalahan jaringan saat mengunggah ${fieldLabel}.`
    } finally {
        isUploadingRef.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Rute disesuaikan ke admin.kontrak.update
    form.post(route('admin.kontrak.update', props.data.id), {
        preserveScroll: true
    })
}

// Konversi daftar Lakdan dari props ke format opsi select
const lakdanOptions = props.lakdans.map(lakdan => ({
    label: `${lakdan.nomor_hps} (ID Lakdan: ${lakdan.id})`, // Tampilkan Nomor HPS Lakdan
    value: lakdan.id // Nilai yang dikirim adalah ID Lakdan
}))
</script>

<template>
    <Head :title="`Edit Data Kontrak ID: ${props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-kontrak">
        <h1 class="sr-only" id="edit-kontrak">Edit Data Kontrak</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Kontrak ID: ${props.data.id}`"
                description="Perbarui detail lengkap Kontrak."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Kontrak',
                        href: route('admin.kontrak.index') // Rute disesuaikan
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Utama Kontrak
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Pilih Lakdan terkait dan detail dasar kontrak.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Lakdan Terkait (Nomor HPS)"
                                v-model.number="form.lakdan_id"
                                :options="lakdanOptions"
                                :error="form.errors.lakdan_id"
                                placeholder="Pilih Nomor HPS Lakdan" />

                            <FormInput
                                label="Penyedia Barang/Jasa"
                                v-model="form.penyedia_barang_jasa"
                                :error="form.errors.penyedia_barang_jasa"
                                placeholder="Cth: PT Sinar Jaya" />

                            <FormSelect
                                label="Jenis Perjanjian"
                                v-model="form.jenis_perjanjian"
                                :options="jenisPerjanjianOptions"
                                :error="form.errors.jenis_perjanjian"
                                placeholder="Pilih Jenis Perjanjian" />

                            <FormSelect
                                label="Status Proses"
                                v-model="form.status_proses"
                                :options="statusOptions"
                                :error="form.errors.status_proses"
                                placeholder="Pilih Status Proses" />

                            <FormInput
                                label="Durasi Pengadaan (Hari)"
                                type="number"
                                v-model.number="form.durasi_pengadaan"
                                :error="form.errors.durasi_pengadaan"
                                placeholder="Cth: 120" />

                            <FormInput
                                label="Masa Pelaksanaan (Hari)"
                                type="number"
                                v-model.number="form.masa_pelaksanaan"
                                :error="form.errors.masa_pelaksanaan"
                                placeholder="Cth: 90" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Detail Perjanjian (Kontrak)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Tanggal, nomor, nilai, dan dokumen perjanjian.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Perjanjian"
                                v-model="form.nomor_perjanjian"
                                :error="form.errors.nomor_perjanjian"
                                placeholder="Cth: 001.Pj/DAN.01.03/F48000000/2025" />

                            <FormInput
                                label="Nilai Perjanjian (PPN)"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_perjanjian_ppn"
                                :error="form.errors.nilai_perjanjian_ppn"
                                placeholder="Nilai termasuk PPN" />

                            <FormInput
                                label="Nilai Perjanjian (sebelum PPN)"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_perjanjian_sebelum_ppn"
                                :error="form.errors.nilai_perjanjian_sebelum_ppn"
                                placeholder="Nilai sebelum PPN" />

                            <FormInput
                                label="Rencana Tgl. Perjanjian"
                                type="date"
                                v-model="form.rencana_tanggal_perjanjian"
                                :error="form.errors.rencana_tanggal_perjanjian" />

                            <FormInput
                                label="Realisasi Tgl. Perjanjian"
                                type="date"
                                v-model="form.realisasi_tanggal_perjanjian"
                                :error="form.errors.realisasi_tanggal_perjanjian" />

                            <FormInput
                                label="Tanggal Berakhir Kontrak"
                                type="date"
                                v-model="form.tanggal_berakhir"
                                :error="form.errors.tanggal_berakhir" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="md:col-span-1 space-y-2">
                                <FormInput
                                    label="Dokumen Kontrak (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'perjanjian')"
                                    :error="
                                        uploadPerjanjianError || form.errors.dokumen_perjanjian_path
                                    "
                                    :disabled="isUploadingPerjanjian"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingPerjanjian"
                                    class="mt-1 text-sm text-sky-500 flex items-center">
                                    <svg
                                        class="animate-spin h-4 w-4 mr-3"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <circle
                                            cx="12"
                                            cy="12"
                                            r="10"
                                            stroke="currentColor"
                                            stroke-width="4"
                                            class="opacity-25"></circle>
                                        <path
                                            fill="currentColor"
                                            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                                            class="opacity-75"></path>
                                    </svg>
                                    Sedang mengunggah Dokumen Kontrak ({{
                                        uploadedPerjanjianName || '...'
                                    }})
                                </div>
                                <div
                                    v-else-if="uploadPerjanjianError"
                                    class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadPerjanjianError }}
                                </div>
                                <div
                                    v-else-if="uploadedPerjanjianPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File Kontrak **{{ uploadedPerjanjianName }}** berhasil
                                    diunggah. (Akan menggantikan file lama).
                                </div>
                                <div
                                    v-else-if="
                                        existingPerjanjianPath &&
                                        !isUploadingPerjanjian &&
                                        !uploadPerjanjianError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingPerjanjianName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingPerjanjianPath}`"
                                        target="_blank"
                                        class="inline-flex items-center text-sm font-semibold text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-500 transition duration-150 ease-in-out border border-blue-600 hover:border-blue-700 dark:border-blue-400 dark:hover:border-blue-500 px-3 py-1 rounded-md">
                                        <svg
                                            xmlns="http://www.w3.org/2000/svg"
                                            class="h-4 w-4 mr-1"
                                            fill="none"
                                            viewBox="0 0 24 24"
                                            stroke="currentColor"
                                            stroke-width="2">
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        Lihat Dokumen
                                    </a>
                                </div>
                            </div>
                            <div class="md:col-span-2"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            3. Detail Jaminan Pelaksanaan
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Informasi mengenai jaminan pelaksanaan kontrak.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Jaminan Pelaksanaan"
                                v-model="form.nomor_jaminan_pelaksanaan"
                                :error="form.errors.nomor_jaminan_pelaksanaan"
                                placeholder="Cth: BG5344615" />

                            <FormInput
                                label="Nilai Jaminan Pelaksanaan"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_jaminan_pelaksanaan"
                                :error="form.errors.nilai_jaminan_pelaksanaan"
                                placeholder="Cth: 123456.78" />

                            <FormInput
                                label="Bank Pemberi Jaminan"
                                v-model="form.bank_pemberi_jaminan"
                                :error="form.errors.bank_pemberi_jaminan"
                                placeholder="Cth: Bank Mandiri" />

                            <FormInput
                                label="Rencana Tgl. Jaminan"
                                type="date"
                                v-model="form.rencana_jaminan_pelaksanaan"
                                :error="form.errors.rencana_jaminan_pelaksanaan" />

                            <FormInput
                                label="Realisasi Tgl. Jaminan"
                                type="date"
                                v-model="form.realisasi_jaminan_pelaksanaan"
                                :error="form.errors.realisasi_jaminan_pelaksanaan" />

                            <div class="hidden md:block"></div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="md:col-span-1 space-y-2">
                                <FormInput
                                    label="Dokumen Jaminan Pelaksanaan (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'jaminan_pelaksanaan')"
                                    :error="
                                        uploadJaminanError ||
                                        form.errors.dokumen_jaminan_pelaksanaan_path
                                    "
                                    :disabled="isUploadingJaminan"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingJaminan"
                                    class="mt-1 text-sm text-sky-500 flex items-center">
                                    <svg
                                        class="animate-spin h-4 w-4 mr-3"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        xmlns="http://www.w3.org/2000/svg">
                                        <circle
                                            cx="12"
                                            cy="12"
                                            r="10"
                                            stroke="currentColor"
                                            stroke-width="4"
                                            class="opacity-25"></circle>
                                        <path
                                            fill="currentColor"
                                            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                                            class="opacity-75"></path>
                                    </svg>
                                    Sedang mengunggah Dokumen Jaminan ({{
                                        uploadedJaminanName || '...'
                                    }})...
                                </div>
                                <div
                                    v-else-if="uploadJaminanError"
                                    class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadJaminanError }}
                                </div>
                                <div
                                    v-else-if="uploadedJaminanPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File Jaminan **{{ uploadedJaminanName }}** berhasil diunggah.
                                    (Akan menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingJaminanPath &&
                                        !isUploadingJaminan &&
                                        !uploadJaminanError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingJaminanName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingJaminanPath}`"
                                        target="_blank"
                                        class="inline-flex items-center text-sm font-semibold text-blue-600 hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-500 transition duration-150 ease-in-out border border-blue-600 hover:border-blue-700 dark:border-blue-400 dark:hover:border-blue-500 px-3 py-1 rounded-md">
                                        <svg
                                            xmlns="http://www.w3.org/2000/svg"
                                            class="h-4 w-4 mr-1"
                                            fill="none"
                                            viewBox="0 0 24 24"
                                            stroke="currentColor"
                                            stroke-width="2">
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                        </svg>
                                        Lihat Dokumen
                                    </a>
                                </div>
                            </div>
                            <div class="md:col-span-2"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            4. Metrik dan Keterangan Tambahan
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Informasi mengenai risiko, TKDN, dan efisiensi.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Tingkat Risiko CSMS"
                                v-model="form.tingkat_risiko_csms"
                                :options="risikoCsmsOptions"
                                :error="form.errors.tingkat_risiko_csms"
                                placeholder="Pilih Tingkat Risiko" />

                            <FormInput
                                label="TKDN (%)"
                                type="number"
                                step="0.01"
                                v-model.number="form.tkdn"
                                :error="form.errors.tkdn"
                                placeholder="Cth: 5.00" />

                            <FormInput
                                label="Efisiensi thd HPS (String)"
                                v-model="form.efisiensi_thd_hps"
                                :error="form.errors.efisiensi_thd_hps"
                                placeholder="Cth: 1,36%" />
                        </div>

                        <div>
                            <FormInput
                                label="Keterangan"
                                type="textarea"
                                v-model="form.keterangan"
                                :error="form.errors.keterangan"
                                rows="3"
                                placeholder="Catatan atau keterangan tambahan mengenai kontrak." />
                        </div>
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="form.processing || isUploadingPerjanjian || isUploadingJaminan"
                        :aria-busy="form.processing || isUploadingPerjanjian || isUploadingJaminan">
                        <svg
                            v-if="form.processing || isUploadingPerjanjian || isUploadingJaminan"
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
                        {{ form.processing ? 'Memperbarui...' : 'Update Kontrak' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
