<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormTextarea from '@/Components/FormTextarea.vue'
import FormSelect from '@/Components/FormSelect.vue'
import { ref } from 'vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Asumsi: Daftar PRK yang tersedia untuk dipilih di form
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

// --- STATE UNTUK UPLOAD DOKUMEN SKK ---
const isUploadingSkk = ref(false)
const uploadedSkkPath = ref(null)
const uploadedSkkName = ref(null)
const uploadSkkError = ref(null)

// --- Inisialisasi Form PAKET ---
const form = useForm({
    prk_id: null, // Foreign Key ke PRK
    tahun: null,

    // Informasi SKK (Surat Keputusan Kebutuhan)
    nomor_skk: '',
    tanggal_skk: '',
    nilai_skk: null,
    status_paket: '',

    // FIELD BARU UNTUK FILE UPLOAD DOKUMEN SKK
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

    const formData = new FormData()
    formData.append('file', file) // Gunakan key file yang spesifik

    try {
        // ASUMSI: Anda menggunakan rute yang sama untuk mengunggah digital document
        const response = await fetch(route('upload.digital-document'), {
            method: 'POST',
            body: formData,
            headers: {
                // ASUMSI: CSRF Token tersedia di DOM
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })

        const data = await response.json()
        if (response.ok && data.success) {
            uploadedSkkPath.value = data.path
            uploadedSkkName.value = data.filename
            // Simpan path ke form untuk dikirim ke controller Laravel
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
    form.post(route('admin.paket.store'), {
        // Sesuaikan rute ke admin.paket.store
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
    <Head title="Buat Data Paket" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="create-paket">
        <h1 class="sr-only" id="create-paket">Buat Data Paket</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data Paket"
                description="Masukkan detail lengkap Paket Pekerjaan yang terkait dengan PRK."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Paket',
                        href: route('admin.paket.index') // Sesuaikan rute
                    },
                    { label: 'Buat' }
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
                                v-model="form.prk_id"
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
                                    disimpan.
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
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Paket' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
