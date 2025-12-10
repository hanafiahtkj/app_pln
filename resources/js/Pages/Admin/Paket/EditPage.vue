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
        required: true // Data Paket yang akan diedit
    },
    // Asumsi: Daftar PRK yang tersedia untuk dipilih di form (untuk mengedit prk_id)
    prks: {
        type: Array,
        default: () => []
    }
})

// --- Definisikan opsi statis default untuk Status Paket ---
const defaultStatusOptions = [
    { label: 'Penetapan', value: 'Penetapan' },
    { label: 'Indikatif', value: 'Indikatif' }
]

// Helper untuk format tanggal dari database (YYYY-MM-DD HH:MM:SS) ke input date (YYYY-MM-DD)
const formatDate = dateString => {
    if (!dateString) return null
    try {
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString
    }
}

// --- STATE UNTUK UPLOAD DOKUMEN SKK ---
const isUploadingSkk = ref(false)
const uploadedSkkPath = ref(null)
const uploadedSkkName = ref(null)
const uploadSkkError = ref(null)

// State untuk menampilkan file SKK yang sudah ada
const existingSkkPath = ref(props.data.dokumen_skk)
const existingSkkName = ref(props.data.dokumen_skk ? props.data.dokumen_skk.split('/').pop() : null)

// --- Inisialisasi Form PAKET dengan data yang ada ---
const form = useForm({
    // Override method untuk PUT/PATCH
    _method: 'put',

    // Core fields (diambil dari props.data)
    prk_id: props.data.prk_id,
    tahun: props.data.tahun,

    // Informasi SKK
    nomor_skk: props.data.nomor_skk,
    tanggal_skk: formatDate(props.data.tanggal_skk),
    nilai_skk: props.data.nilai_skk,
    status_paket: props.data.status_paket,

    // File fields (path and name for new upload)
    // dokumen_skk adalah field di DB yang menyimpan path lama
    // dokumen_skk_path/name digunakan untuk mengirim file baru
    dokumen_skk_path: null,
    dokumen_skk_name: null
})

// --- Fungsi Khusus Upload File SKK ---
const handleSkkUpload = async event => {
    const file = event.target.files[0]
    if (!file) return

    isUploadingSkk.value = true
    uploadSkkError.value = null
    uploadedSkkPath.value = null
    uploadedSkkName.value = null

    // Hapus tampilan file lama jika ada upload baru
    existingSkkPath.value = null
    existingSkkName.value = null

    const formData = new FormData()
    formData.append('file', file)

    try {
        // ASUMSI: Anda memiliki route backend bernama 'upload.digital-document'
        const response = await fetch(route('upload.digital-document'), {
            method: 'POST',
            body: formData,
            headers: {
                // Pastikan token CSRF tersedia
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })

        const data = await response.json()
        if (response.ok && data.success) {
            uploadedSkkPath.value = data.path
            uploadedSkkName.value = data.filename
            form.dokumen_skk_path = data.path
            form.dokumen_skk_name = data.filename
        } else {
            uploadSkkError.value = data.message || 'Gagal mengunggah file Dokumen SKK.'
        }
    } catch (error) {
        uploadSkkError.value = 'Terjadi kesalahan jaringan saat mengunggah Dokumen SKK.'
    } finally {
        isUploadingSkk.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Menggunakan form.post untuk mengirim data ke route update (Laravel Inertia convention for PUT/PATCH)
    form.post(route('admin.paket.update', props.data.id), {
        preserveScroll: true
    })
}

// Konversi daftar PRK dari props ke format opsi select
const prkOptions = props.prks.map(prk => ({
    label: prk.prk, // Tampilkan nomor PRK
    value: prk.id // Nilai yang dikirim adalah ID PRK
}))
</script>

<template>
    <Head :title="`Edit Data Paket: ${props.data.nomor_skk || props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-paket">
        <h1 class="sr-only" id="edit-paket">Edit Data Paket</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Paket: ${props.data.nomor_skk || props.data.id}`"
                description="Perbarui detail lengkap Paket Pekerjaan."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Paket',
                        href: route('admin.paket.index')
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Utama Paket
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Pilih PRK terkait dan detail tahun.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Tahun"
                                type="number"
                                v-model.number="form.tahun"
                                :error="form.errors.tahun"
                                placeholder="Cth: 2025" />

                            <FormSelect
                                label="PRK Terkait"
                                v-model.number="form.prk_id"
                                :options="prkOptions"
                                :error="form.errors.prk_id"
                                placeholder="Pilih Nomor PRK" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Surat Keputusan Kebutuhan (SKK)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail SKK terkait paket ini.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor SKK"
                                v-model="form.nomor_skk"
                                :error="form.errors.nomor_skk"
                                placeholder="Cth: 3751/KEU.01.08/..." />

                            <FormInput
                                label="Tanggal SKK"
                                type="date"
                                v-model="form.tanggal_skk"
                                :error="form.errors.tanggal_skk" />

                            <FormSelect
                                label="Status Paket"
                                v-model="form.status_paket"
                                :options="defaultStatusOptions"
                                :error="form.errors.status_paket"
                                placeholder="Pilih Status" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nilai SKK (Rupiah)"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_skk"
                                :error="form.errors.nilai_skk"
                                placeholder="Cth: 2813445.684" />

                            <div class="md:col-span-2 space-y-2">
                                <FormInput
                                    label="Dokumen SKK (File Upload)"
                                    type="file"
                                    @input="handleSkkUpload($event)"
                                    :error="uploadSkkError || form.errors.dokumen_skk_path"
                                    :disabled="isUploadingSkk"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingSkk"
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
                                    Sedang mengunggah ({{ uploadedSkkName || '...' }})...
                                </div>
                                <div v-else-if="uploadSkkError" class="mt-1 text-sm text-red-500">
                                    Gagal mengunggah: {{ uploadSkkError }}
                                </div>
                                <div
                                    v-else-if="uploadedSkkPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File **{{ uploadedSkkName }}** berhasil diunggah dan siap
                                    disimpan. (Akan menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingSkkPath && !isUploadingSkk && !uploadSkkError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingSkkName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingSkkPath}`"
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
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="form.processing || isUploadingSkk"
                        :aria-busy="form.processing || isUploadingSkk">
                        <svg
                            v-if="form.processing || isUploadingSkk"
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
                        {{ form.processing ? 'Memperbarui...' : 'Update Paket' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
