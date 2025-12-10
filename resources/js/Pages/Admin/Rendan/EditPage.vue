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
        required: true // Data Rendan yang akan diedit
    },
    // Daftar PRK yang tersedia untuk dipilih di form
    prks: {
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

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN ND USER ---
const isUploadingNdUser = ref(false)
const uploadedNdUserPath = ref(null)
const uploadedNdUserName = ref(null)
const uploadNdUserError = ref(null)
const existingNdUserPath = ref(props.data.dokumen_nd_user)
const existingNdUserName = ref(
    props.data.dokumen_nd_user ? props.data.dokumen_nd_user.split('/').pop() : null
)

// --- STATE DAN LOGIKA UNTUK UPLOAD DOKUMEN RKS ---
const isUploadingRks = ref(false)
const uploadedRksPath = ref(null)
const uploadedRksName = ref(null)
const uploadRksError = ref(null)
const existingRksPath = ref(props.data.dokumen_rks)
const existingRksName = ref(props.data.dokumen_rks ? props.data.dokumen_rks.split('/').pop() : null)

// --- Inisialisasi Form RENDAN dengan data yang ada ---
const form = useForm({
    _method: 'put',

    // Core fields
    prk_id: props.data.prk_id,

    // ND User Fields
    nomor_nd_user: props.data.nomor_nd_user,
    tanggal_nd_user: formatDate(props.data.tanggal_nd_user),
    dokumen_nd_user_path: null,
    dokumen_nd_user_name: null,

    // RAB Field
    rab: props.data.rab,

    // RKS Fields
    nomor_rks: props.data.nomor_rks,
    tanggal_rks: formatDate(props.data.tanggal_rks),
    dokumen_rks_path: null,
    dokumen_rks_name: null
})

// --- Fungsi Reusable Upload File ---
const handleFileUpload = async (event, field) => {
    const file = event.target.files[0]
    if (!file) return

    // Tentukan state yang relevan
    const isUploadingRef = field === 'nd_user' ? isUploadingNdUser : isUploadingRks
    const uploadedPathRef = field === 'nd_user' ? uploadedNdUserPath : uploadedRksPath
    const uploadedNameRef = field === 'nd_user' ? uploadedNdUserName : uploadedRksName
    const uploadErrorRef = field === 'nd_user' ? uploadNdUserError : uploadRksError
    const existingPathRef = field === 'nd_user' ? existingNdUserPath : existingRksPath
    const existingNameRef = field === 'nd_user' ? existingNdUserName : existingRksName

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
            uploadErrorRef.value =
                data.message || `Gagal mengunggah file Dokumen ${field.toUpperCase()}.`
        }
    } catch (error) {
        uploadErrorRef.value = `Terjadi kesalahan jaringan saat mengunggah Dokumen ${field.toUpperCase()}.`
    } finally {
        isUploadingRef.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Menggunakan form.post untuk mengirim data ke route update (Laravel Inertia convention for PUT/PATCH)
    // Rute disesuaikan ke admin.rendan.update
    form.post(route('admin.rendan.update', props.data.id), {
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
    <Head :title="`Edit Data Rendan: ${props.data.nomor_nd_user || props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-rendan">
        <h1 class="sr-only" id="edit-rendan">Edit Data Rendan</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Rendan: ${props.data.nomor_nd_user || props.data.id}`"
                description="Perbarui detail lengkap Rencana Pengadaan (Rendan)."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Rendan',
                        href: route('admin.rendan.index') // Rute disesuaikan
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Utama Rendan
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Pilih PRK terkait dan detail RAB.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="PRK Terkait"
                                v-model.number="form.prk_id"
                                :options="prkOptions"
                                :error="form.errors.prk_id"
                                placeholder="Pilih Nomor PRK" />

                            <FormInput
                                label="RAB (Referensi/Status)"
                                v-model="form.rab"
                                :error="form.errors.rab"
                                placeholder="Cth: Penetapan / File-RAB-001" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Nota Dinas (ND) User
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail Nota Dinas User terkait rencana pengadaan.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor ND User"
                                v-model="form.nomor_nd_user"
                                :error="form.errors.nomor_nd_user"
                                placeholder="Cth: 0107/KEU.00.03/..." />

                            <FormInput
                                label="Tanggal ND User"
                                type="date"
                                v-model="form.tanggal_nd_user"
                                :error="form.errors.tanggal_nd_user" />

                            <div class="space-y-2">
                                <FormInput
                                    label="Dokumen ND User (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'nd_user')"
                                    :error="uploadNdUserError || form.errors.dokumen_nd_user_path"
                                    :disabled="isUploadingNdUser"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingNdUser"
                                    class="mt-1 text-sm text-sky-500 flex items-center">
                                    <svg
                                        class="animate-spin h-4 w-4 mr-3"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        xmlns="http://www.w3.org/2000/svg"></svg>
                                    Sedang mengunggah ND User ({{ uploadedNdUserName || '...' }})...
                                </div>
                                <div
                                    v-else-if="uploadNdUserError"
                                    class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadNdUserError }}
                                </div>
                                <div
                                    v-else-if="uploadedNdUserPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File ND User **{{ uploadedNdUserName }}** berhasil diunggah.
                                    (Akan menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingNdUserPath &&
                                        !isUploadingNdUser &&
                                        !uploadNdUserError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingNdUserName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingNdUserPath}`"
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

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            3. Rencana Kerja Syarat (RKS)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Detail dokumen Rencana Kerja Syarat.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor RKS"
                                v-model="form.nomor_rks"
                                :error="form.errors.nomor_rks"
                                placeholder="Cth: 045.RKS/DAN.01.01/..." />

                            <FormInput
                                label="Tanggal RKS"
                                type="date"
                                v-model="form.tanggal_rks"
                                :error="form.errors.tanggal_rks" />

                            <div class="space-y-2">
                                <FormInput
                                    label="Dokumen RKS (File Upload)"
                                    type="file"
                                    @input="handleFileUpload($event, 'rks')"
                                    :error="uploadRksError || form.errors.dokumen_rks_path"
                                    :disabled="isUploadingRks"
                                    accept=".pdf, .jpg, .jpeg, .png" />

                                <div
                                    v-if="isUploadingRks"
                                    class="mt-1 text-sm text-sky-500 flex items-center">
                                    <svg
                                        class="animate-spin h-4 w-4 mr-3"
                                        viewBox="0 0 24 24"
                                        fill="none"
                                        xmlns="http://www.w3.org/2000/svg"></svg>
                                    Sedang mengunggah RKS ({{ uploadedRksName || '...' }})...
                                </div>
                                <div v-else-if="uploadRksError" class="mt-1 text-sm text-red-500">
                                    Gagal unggah: {{ uploadRksError }}
                                </div>
                                <div
                                    v-else-if="uploadedRksPath"
                                    class="mt-1 text-sm text-green-500 font-medium">
                                    ✅ File RKS **{{ uploadedRksName }}** berhasil diunggah. (Akan
                                    menggantikan file lama).
                                </div>

                                <div
                                    v-else-if="
                                        existingRksPath && !isUploadingRks && !uploadRksError
                                    "
                                    class="flex items-center gap-4">
                                    <div
                                        class="text-sm text-gray-500 font-medium dark:text-gray-400">
                                        File saat ini: **{{ existingRksName }}**
                                    </div>
                                    <a
                                        :href="`/storage/${existingRksPath}`"
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
                        :disabled="form.processing || isUploadingNdUser || isUploadingRks"
                        :aria-busy="form.processing || isUploadingNdUser || isUploadingRks">
                        <svg
                            v-if="form.processing || isUploadingNdUser || isUploadingRks"
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
                        {{ form.processing ? 'Memperbarui...' : 'Update Rendan' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
