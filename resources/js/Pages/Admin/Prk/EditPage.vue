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
    data: {
        type: Object,
        required: true
    }
})

// --- Definisikan opsi statis default ---
const defaultFungsiOptions = [
    { label: 'Gardu Induk', value: 'Gardu Induk' },
    { label: 'Transmisi', value: 'Transmisi' },
    { label: 'Operasi Sistem', value: 'Operasi Sistem' }
]

const defaultStatusOptions = [
    { label: 'Murni', value: 'Murni' },
    { label: 'Revisi', value: 'Revisi' }
]

const defaultTvvStatusOptions = [
    { label: 'Disetujui', value: 'Disetujui' },
    { label: 'Ditolak', value: 'Ditolak' },
    { label: 'Menunggu', value: 'Menunggu' }
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

// --- STATE UNTUK UPLOAD DOKUMEN SKAI ---
const isUploadingSkai = ref(false)
const uploadedSkaiPath = ref(null)
const uploadedSkaiName = ref(null)
const uploadSkaiError = ref(null)

// State untuk menampilkan file SKAI yang sudah ada
const existingSkaiPath = ref(props.data.dokumen_skai)
const existingSkaiName = ref(
    props.data.dokumen_skai ? props.data.dokumen_skai.split('/').pop() : null
)

// --- Inisialisasi Form PRK dengan data yang ada ---
const form = useForm({
    // Override method untuk PUT/PATCH
    _method: 'put',
    ...props.data, // Memuat semua data PRK

    // Format ulang tanggal-tanggal agar sesuai input[type=date]
    tanggal_kkp: formatDate(props.data.tanggal_kkp),
    tanggal_ulasan_kajian_risiko: formatDate(props.data.tanggal_ulasan_kajian_risiko),
    tanggal_dokumen_grc: formatDate(props.data.tanggal_dokumen_grc),
    tanggal_tvv: formatDate(props.data.tanggal_tvv),
    tanggal_skai: formatDate(props.data.tanggal_skai),

    // Reset path/name untuk upload file baru
    dokumen_skai_path: null,
    dokumen_skai_name: null
})

// --- Fungsi Khusus Upload File SKAI ---
const handleSkaiUpload = async event => {
    const file = event.target.files[0]
    if (!file) return

    isUploadingSkai.value = true
    uploadSkaiError.value = null
    uploadedSkaiPath.value = null
    uploadedSkaiName.value = null

    // Hapus tampilan file lama jika ada upload baru
    existingSkaiPath.value = null
    existingSkaiName.value = null

    const formData = new FormData()
    formData.append('file', file)

    try {
        // ASUMSI: Anda memiliki route backend bernama 'upload.digital-document'
        const response = await fetch(route('upload.digital-document'), {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })

        const data = await response.json()
        if (response.ok && data.success) {
            uploadedSkaiPath.value = data.path
            uploadedSkaiName.value = data.filename
            form.dokumen_skai_path = data.path
            form.dokumen_skai_name = data.filename
        } else {
            uploadSkaiError.value = data.message || 'Gagal mengunggah file Dokumen SKAI.'
        }
    } catch (error) {
        uploadSkaiError.value = 'Terjadi kesalahan jaringan saat mengunggah Dokumen SKAI.'
    } finally {
        isUploadingSkai.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Menggunakan form.put untuk mengirim data ke route update
    form.post(route('admin.prk.update', props.data.id), {
        preserveScroll: true
    })
}
</script>

<template>
    <Head :title="`Edit Data PRK: ${props.data.prk}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-prk">
        <h1 class="sr-only" id="edit-prk">Edit Data PRK</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data PRK: ${props.data.prk}`"
                description="Perbarui detail lengkap Program Rencana Kerja (PRK)."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data PRK',
                        href: route('admin.prk.index')
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Pokok PRK
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Identitas, fungsi, dan uraian utama dari PRK.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Tahun"
                                type="number"
                                v-model.number="form.tahun"
                                :error="form.errors.tahun"
                                placeholder="Cth: 2025" />
                            <FormInput
                                label="Nomor PRK"
                                v-model="form.prk"
                                :error="form.errors.prk"
                                placeholder="Cth: 2025.P3BK.4.001" />

                            <FormSelect
                                label="Fungsi"
                                v-model="form.fungsi"
                                :options="fungsiOptions"
                                :error="form.errors.fungsi"
                                placeholder="Pilih Fungsi" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="User/Unit Pengguna"
                                v-model="form.user"
                                :error="form.errors.user"
                                placeholder="Cth: Operasi Sistem" />

                            <FormSelect
                                label="Status PRK"
                                v-model="form.status"
                                :options="statusOptions"
                                :error="form.errors.status"
                                placeholder="Pilih Status" />

                            <div class="hidden md:block"></div>
                        </div>

                        <FormTextarea
                            label="Uraian Pekerjaan/Proyek"
                            v-model="form.uraian"
                            :error="form.errors.uraian"
                            rows="3" />
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Anggaran dan Paket
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail biaya investasi dan jumlah paket yang disetujui.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Anggaran Investasi (AI) Rupiah"
                                type="number"
                                step="0.0001"
                                v-model.number="form.ai_rupiah"
                                :error="form.errors.ai_rupiah"
                                placeholder="Cth: 2813445.684" />
                            <FormInput
                                label="Nilai SKAI (Rupiah)"
                                type="number"
                                step="0.0001"
                                v-model.number="form.nilai_skai"
                                :error="form.errors.nilai_skai"
                                placeholder="Cth: 2813445.684" />
                            <FormInput
                                label="Jumlah Paket"
                                type="number"
                                v-model.number="form.jumlah_paket"
                                :error="form.errors.jumlah_paket"
                                placeholder="Cth: 1" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            3. Kaji Ulang Dokumen (KKP, Risiko, GRC)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Data terkait kajian kebutuhan proyek, risiko, dan GRC.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Dokumen KKP"
                                v-model="form.dokumen_kkp"
                                :error="form.errors.dokumen_kkp"
                                placeholder="Cth: KKP 2025.P3BK.4.001" />
                            <FormInput
                                label="Tanggal KKP"
                                type="date"
                                v-model="form.tanggal_kkp"
                                :error="form.errors.tanggal_kkp" />

                            <FormInput
                                label="Ulasan Kajian Risiko"
                                v-model="form.ulasan_kajian_risiko"
                                :error="form.errors.ulasan_kajian_risiko"
                                placeholder="Cth: KR 2025.P3BK.4.001" />
                            <FormInput
                                label="Tanggal Ulasan Kajian Risiko"
                                type="date"
                                v-model="form.tanggal_ulasan_kajian_risiko"
                                :error="form.errors.tanggal_ulasan_kajian_risiko" />

                            <FormInput
                                label="Dokumen GRC"
                                v-model="form.dokumen_grc"
                                :error="form.errors.dokumen_grc"
                                placeholder="Cth: GRC 2025.P3BK.4.001" />
                            <FormInput
                                label="Tanggal Dokumen GRC"
                                type="date"
                                v-model="form.tanggal_dokumen_grc"
                                :error="form.errors.tanggal_dokumen_grc" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            4. Persetujuan (TVV & SKAI)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Data terkait Technical Verification and Validation (TVV) dan SKAI.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Tanggal TVV"
                                type="date"
                                v-model="form.tanggal_tvv"
                                :error="form.errors.tanggal_tvv" />

                            <FormSelect
                                label="Status Persetujuan TVV"
                                v-model="form.status_persetujuan_tvv"
                                :options="defaultTvvStatusOptions"
                                :error="form.errors.status_persetujuan_tvv"
                                placeholder="Pilih Status Persetujuan" />

                            <FormInput
                                label="Dokumen TVV (Nama File/Nomor)"
                                v-model="form.dokumen_tvv"
                                :error="form.errors.dokumen_tvv"
                                placeholder="Cth: Nota Persetujuan TVV" />
                            <div class="hidden md:block"></div>

                            <FormInput
                                label="Nomor SKAI"
                                v-model="form.nomor_skai"
                                :error="form.errors.nomor_skai"
                                placeholder="Cth: 8259/KEU.00.03/..." />
                            <FormInput
                                label="Tanggal SKAI"
                                type="date"
                                v-model="form.tanggal_skai"
                                :error="form.errors.tanggal_skai" />

                            <div class="md:col-span-2 space-y-2">
                                <FormInput
                                    label="Dokumen SKAI (File Upload)"
                                    type="file"
                                    @input="handleSkaiUpload($event)"
                                    :error="uploadSkaiError || form.errors.dokumen_skai_path"
                                    :disabled="isUploadingSkai"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingSkai"
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
                                    Sedang mengunggah ({{ uploadedSkaiName || '...' }})...
                                </div>
                                <div v-else-if="uploadSkaiError" class="mt-1 text-sm text-red-500">
                                    Gagal mengunggah: {{ uploadSkaiError }}
                                </div>
                                <div
                                    v-else-if="uploadedSkaiPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File **{{ uploadedSkaiName }}** berhasil diunggah dan siap
                                    disimpan. (Akan menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingSkaiPath && !isUploadingSkai && !uploadSkaiError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingSkaiName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingSkaiPath}`"
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

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="form.processing || isUploadingSkai"
                        :aria-busy="form.processing || isUploadingSkai">
                        <svg
                            v-if="form.processing || isUploadingSkai"
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
                        {{ form.processing ? 'Memperbarui...' : 'Update PRK' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
