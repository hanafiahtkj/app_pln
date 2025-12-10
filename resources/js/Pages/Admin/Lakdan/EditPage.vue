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
    proses_pengadaan: props.data.proses_pengadaan,
    metode_pengadaan: props.data.metode_pengadaan,

    // HPS Fields
    rencana_tanggal_hps: formatDate(props.data.rencana_tanggal_hps),
    realisasi_tanggal_hps: formatDate(props.data.realisasi_tanggal_hps),
    nomor_hps: props.data.nomor_hps,
    nilai_hps: props.data.nilai_hps,
    dokumen_hps_path: null,
    dokumen_hps_name: null,

    // Pengumuman Lelang Fields
    rencana_pengumuman_lelang: formatDate(props.data.rencana_pengumuman_lelang),
    realisasi_pengumuman_lelang: formatDate(props.data.realisasi_pengumuman_lelang),
    nomor_pengumuman_lelang: props.data.nomor_pengumuman_lelang,

    // Penunjukan Pemenang Fields
    rencana_penunjukan_pemenang: formatDate(props.data.rencana_penunjukan_pemenang),
    realisasi_penunjukan_pemenang: formatDate(props.data.realisasi_penunjukan_pemenang),
    nomor_penunjukan_pemenang: props.data.nomor_penunjukan_pemenang,
    dokumen_penunjukan_pemenang_path: null,
    dokumen_penunjukan_pemenang_name: null
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
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Utama Pengadaan
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Pilih Rendan terkait dan metode pelaksanaan.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Rendan Terkait (Nomor ND User)"
                                v-model.number="form.rendan_id"
                                :options="rendanOptions"
                                :error="form.errors.rendan_id"
                                placeholder="Pilih Nomor ND User Rendan" />

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
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Harga Perkiraan Sendiri (HPS)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail dokumen Harga Perkiraan Sendiri.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor HPS"
                                v-model="form.nomor_hps"
                                :error="form.errors.nomor_hps"
                                placeholder="Cth: 001.HPS/DAN.01.03/..." />

                            <FormInput
                                label="Nilai HPS (Rupiah)"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_hps"
                                :error="form.errors.nilai_hps"
                                placeholder="Cth: 1234567.89" />

                            <div class="space-y-2">
                                <FormInput
                                    label="Dokumen HPS (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'hps')"
                                    :error="uploadHpsError || form.errors.dokumen_hps_path"
                                    :disabled="isUploadingHps"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingHps"
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
                                    Sedang mengunggah HPS ({{ uploadedHpsName || '...' }})...
                                </div>
                                <div v-else-if="uploadHpsError" class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadHpsError }}
                                </div>
                                <div
                                    v-else-if="uploadedHpsPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File HPS **{{ uploadedHpsName }}** berhasil diunggah. (Akan
                                    menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingHpsPath && !isUploadingHps && !uploadHpsError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingHpsName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingHpsPath}`"
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
                        </div>

                        <div
                            class="grid grid-cols-1 md:grid-cols-3 gap-6 pt-4 border-t border-gray-200 dark:border-gray-600">
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

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            3. Pengumuman Lelang
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail jadwal dan nomor Pengumuman Lelang/Tender.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Pengumuman Lelang"
                                v-model="form.nomor_pengumuman_lelang"
                                :error="form.errors.nomor_pengumuman_lelang"
                                placeholder="Cth: EPROC-7300-..." />

                            <FormInput
                                label="Rencana Tgl. Pengumuman"
                                type="date"
                                v-model="form.rencana_pengumuman_lelang"
                                :error="form.errors.rencana_pengumuman_lelang" />

                            <FormInput
                                label="Realisasi Tgl. Pengumuman"
                                type="date"
                                v-model="form.realisasi_pengumuman_lelang"
                                :error="form.errors.realisasi_pengumuman_lelang" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            4. Penunjukan Pemenang
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail dokumen Penunjukan Pemenang.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Penunjukan Pemenang"
                                v-model="form.nomor_penunjukan_pemenang"
                                :error="form.errors.nomor_penunjukan_pemenang"
                                placeholder="Cth: 0932/DAN.01.03/..." />

                            <FormInput
                                label="Rencana Tgl. Pemenang"
                                type="date"
                                v-model="form.rencana_penunjukan_pemenang"
                                :error="form.errors.rencana_penunjukan_pemenang" />

                            <FormInput
                                label="Realisasi Tgl. Pemenang"
                                type="date"
                                v-model="form.realisasi_penunjukan_pemenang"
                                :error="form.errors.realisasi_penunjukan_pemenang" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <div class="md:col-span-1 space-y-2">
                                <FormInput
                                    label="Dokumen Penunjukan Pemenang (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'penunjukan_pemenang')"
                                    :error="
                                        uploadPemenangError ||
                                        form.errors.dokumen_penunjukan_pemenang_path
                                    "
                                    :disabled="isUploadingPemenang"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingPemenang"
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
                                    Sedang mengunggah Dokumen Pemenang ({{
                                        uploadedPemenangName || '...'
                                    }})...
                                </div>
                                <div
                                    v-else-if="uploadPemenangError"
                                    class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadPemenangError }}
                                </div>
                                <div
                                    v-else-if="uploadedPemenangPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File Pemenang **{{ uploadedPemenangName }}** berhasil
                                    diunggah. (Akan menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingPemenangPath &&
                                        !isUploadingPemenang &&
                                        !uploadPemenangError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingPemenangName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingPemenangPath}`"
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
