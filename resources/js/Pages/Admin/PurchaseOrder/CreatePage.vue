<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import { ref } from 'vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Daftar Kontrak yang tersedia untuk dipilih (Foreign Key)
    kontraks: {
        type: Array,
        default: () => []
    }
})

// --- Daftar Field Dokumen Progres ---
const documentFields = [
    { key: 'dokumen_po', label: 'Dokumen PO' },
    { key: 'dokumen_pemeriksaan_mos', label: 'Dokumen Pemeriksaan MOS' },
    { key: 'ba_pemeriksaan_25', label: 'BA Pemeriksaan Progress 25%' },
    { key: 'ba_pemeriksaan_50', label: 'BA Pemeriksaan Progress 50%' },
    { key: 'ba_pemeriksaan_75', label: 'BA Pemeriksaan Progress 75%' },
    { key: 'ba_stp', label: 'Berita Acara STP (COD)' },
    { key: 'ba_stap', label: 'Berita Acara STAP (COD)' }
]

// --- State Dinamis untuk Semua Upload Dokumen ---
const documentStates = ref(
    documentFields.reduce((acc, field) => {
        acc[field.key] = {
            isUploading: false,
            uploadedPath: null,
            uploadedName: null,
            error: null
        }
        return acc
    }, {})
)

// --- Inisialisasi Form Purchase Order (PO) ---
// Membuat objek form awal dengan semua field yang diperlukan
const initialFormState = {
    kontrak_id: null, // Foreign Key ke Kontrak
    keterangan: '',

    // Date Fields
    rencana_po: '',
    realisasi_po: '',
    rencana_mos: '',
    realisasi_mos: '',
    rencana_progress_25: '',
    realisasi_progress_25: '',
    rencana_progress_50: '',
    realisasi_progress_50: '',
    rencana_progress_75: '',
    realisasi_progress_75: '',
    rencana_cod: '',
    realisasi_cod: ''
}

// Menambahkan field path dan name sementara untuk semua dokumen ke form
documentFields.forEach(field => {
    initialFormState[`${field.key}_path`] = null
    initialFormState[`${field.key}_name`] = null
})

const form = useForm(initialFormState)

// --- Fungsi Reusable Upload File ---
const handleFileUpload = async (event, fieldKey) => {
    const file = event.target.files[0]
    if (!file) return

    const state = documentStates.value[fieldKey]
    const pathFieldName = `${fieldKey}_path`
    const nameFieldName = `${fieldKey}_name`
    const fieldLabel = documentFields.find(f => f.key === fieldKey)?.label || fieldKey

    state.isUploading = true
    state.error = null
    state.uploadedPath = null
    state.uploadedName = null
    form[pathFieldName] = null
    form[nameFieldName] = null

    const formData = new FormData()
    formData.append('file', file)

    try {
        // ASUMSI: Menggunakan rute yang sama untuk mengunggah digital document
        const response = await fetch(route('upload.digital-document'), {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            }
        })

        const data = await response.json()

        if (response.ok && data.success) {
            state.uploadedPath = data.path
            state.uploadedName = data.filename

            // Simpan path ke form untuk dikirim ke controller Laravel
            form[pathFieldName] = data.path
            form[nameFieldName] = data.filename
        } else {
            state.error = data.message || `Gagal mengunggah file ${fieldLabel}.`
        }
    } catch (error) {
        state.error = `Terjadi kesalahan jaringan saat mengunggah ${fieldLabel}.`
    } finally {
        state.isUploading = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Rute disesuaikan ke admin.po.store
    form.post(route('admin.po.store'), {
        preserveScroll: true
    })
}

// Konversi daftar Kontrak dari props ke format opsi select
const kontrakOptions = props.kontraks.map(kontrak => ({
    // Tampilkan Nomor Perjanjian Kontrak sebagai label yang terkait
    label: `${kontrak.nomor_perjanjian} (ID Kontrak: ${kontrak.id})`,
    value: kontrak.id // Nilai yang dikirim adalah ID Kontrak
}))
</script>

<template>
    <Head title="Buat Data Purchase Order (PO) & Progres" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="create-po">
        <h1 class="sr-only" id="create-po">Buat Data Purchase Order (PO) & Progres</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data Purchase Order (PO) & Progres"
                description="Masukkan detail lengkap Purchase Order dan pelacakan progres terkait Kontrak."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data PO & Progres',
                        href: route('admin.po.index') // Rute disesuaikan
                    },
                    { label: 'Buat' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            1. Informasi Kontrak Terkait
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Pilih Kontrak yang menjadi induk dari Purchase Order dan Progres ini.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormSelect
                                label="Kontrak Terkait (Nomor Perjanjian)"
                                v-model="form.kontrak_id"
                                :options="kontrakOptions"
                                :error="form.errors.kontrak_id"
                                placeholder="Pilih Nomor Perjanjian Kontrak" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            2. Purchase Order (PO) & Mobilisasi (MOS)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Tanggal rencana dan realisasi untuk PO dan Mobilisasi.
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Rencana Tanggal PO"
                                type="date"
                                v-model="form.rencana_po"
                                :error="form.errors.rencana_po" />
                            <FormInput
                                label="Realisasi Tanggal PO"
                                type="date"
                                v-model="form.realisasi_po"
                                :error="form.errors.realisasi_po" />
                            <div class="hidden md:block"></div>

                            <FormInput
                                label="Rencana Tanggal MOS"
                                type="date"
                                v-model="form.rencana_mos"
                                :error="form.errors.rencana_mos" />
                            <FormInput
                                label="Realisasi Tanggal MOS"
                                type="date"
                                v-model="form.realisasi_mos"
                                :error="form.errors.realisasi_mos" />
                            <div class="hidden md:block"></div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4">
                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[0].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[0].key)"
                                    :error="
                                        documentStates.dokumen_po.error ||
                                        form.errors.dokumen_po_path
                                    "
                                    :disabled="documentStates.dokumen_po.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.dokumen_po.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah Dokumen PO...
                                </div>
                                <div
                                    v-else-if="documentStates.dokumen_po.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.dokumen_po.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.dokumen_po.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File PO **{{ documentStates.dokumen_po.uploadedName }}**
                                    siap.
                                </div>
                            </div>

                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[1].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[1].key)"
                                    :error="
                                        documentStates.dokumen_pemeriksaan_mos.error ||
                                        form.errors.dokumen_pemeriksaan_mos_path
                                    "
                                    :disabled="documentStates.dokumen_pemeriksaan_mos.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.dokumen_pemeriksaan_mos.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah Dokumen Pemeriksaan MOS...
                                </div>
                                <div
                                    v-else-if="documentStates.dokumen_pemeriksaan_mos.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.dokumen_pemeriksaan_mos.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.dokumen_pemeriksaan_mos.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File MOS **{{
                                        documentStates.dokumen_pemeriksaan_mos.uploadedName
                                    }}** siap.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            3. Pelacakan Progres 25%, 50%, dan 75%
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Tanggal rencana dan realisasi untuk setiap tahapan progres.
                        </p>

                        <h4 class="font-semibold text-gray-700 dark:text-gray-300">Progress 25%</h4>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Rencana Tgl. Progres 25%"
                                type="date"
                                v-model="form.rencana_progress_25"
                                :error="form.errors.rencana_progress_25" />
                            <FormInput
                                label="Realisasi Tgl. Progres 25%"
                                type="date"
                                v-model="form.realisasi_progress_25"
                                :error="form.errors.realisasi_progress_25" />
                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[2].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[2].key)"
                                    :error="
                                        documentStates.ba_pemeriksaan_25.error ||
                                        form.errors.ba_pemeriksaan_25_path
                                    "
                                    :disabled="documentStates.ba_pemeriksaan_25.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.ba_pemeriksaan_25.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah BA 25%...
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_25.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.ba_pemeriksaan_25.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_25.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File BA 25% **{{
                                        documentStates.ba_pemeriksaan_25.uploadedName
                                    }}** siap.
                                </div>
                            </div>
                        </div>

                        <h4 class="font-semibold text-gray-700 dark:text-gray-300 pt-4">
                            Progress 50%
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Rencana Tgl. Progres 50%"
                                type="date"
                                v-model="form.rencana_progress_50"
                                :error="form.errors.rencana_progress_50" />
                            <FormInput
                                label="Realisasi Tgl. Progres 50%"
                                type="date"
                                v-model="form.realisasi_progress_50"
                                :error="form.errors.realisasi_progress_50" />
                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[3].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[3].key)"
                                    :error="
                                        documentStates.ba_pemeriksaan_50.error ||
                                        form.errors.ba_pemeriksaan_50_path
                                    "
                                    :disabled="documentStates.ba_pemeriksaan_50.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.ba_pemeriksaan_50.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah BA 50%...
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_50.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.ba_pemeriksaan_50.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_50.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File BA 50% **{{
                                        documentStates.ba_pemeriksaan_50.uploadedName
                                    }}** siap.
                                </div>
                            </div>
                        </div>

                        <h4 class="font-semibold text-gray-700 dark:text-gray-300 pt-4">
                            Progress 75%
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Rencana Tgl. Progres 75%"
                                type="date"
                                v-model="form.rencana_progress_75"
                                :error="form.errors.rencana_progress_75" />
                            <FormInput
                                label="Realisasi Tgl. Progres 75%"
                                type="date"
                                v-model="form.realisasi_progress_75"
                                :error="form.errors.realisasi_progress_75" />
                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[4].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[4].key)"
                                    :error="
                                        documentStates.ba_pemeriksaan_75.error ||
                                        form.errors.ba_pemeriksaan_75_path
                                    "
                                    :disabled="documentStates.ba_pemeriksaan_75.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.ba_pemeriksaan_75.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah BA 75%...
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_75.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.ba_pemeriksaan_75.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.ba_pemeriksaan_75.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File BA 75% **{{
                                        documentStates.ba_pemeriksaan_75.uploadedName
                                    }}** siap.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            4. Commercial Operation Date (COD)
                        </h3>
                        <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                            Tanggal rencana dan realisasi untuk COD (Serah Terima Pekerjaan/Aset).
                        </p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Rencana Tgl. COD"
                                type="date"
                                v-model="form.rencana_cod"
                                :error="form.errors.rencana_cod" />
                            <FormInput
                                label="Realisasi Tgl. COD"
                                type="date"
                                v-model="form.realisasi_cod"
                                :error="form.errors.realisasi_cod" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4">
                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[5].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[5].key)"
                                    :error="documentStates.ba_stp.error || form.errors.ba_stp_path"
                                    :disabled="documentStates.ba_stp.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.ba_stp.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah BA STP...
                                </div>
                                <div
                                    v-else-if="documentStates.ba_stp.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.ba_stp.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.ba_stp.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File BA STP **{{ documentStates.ba_stp.uploadedName }}**
                                    siap.
                                </div>
                            </div>

                            <div class="space-y-2">
                                <FormInput
                                    :label="documentFields[6].label + ' (File Upload)'"
                                    type="file"
                                    @input="handleFileUpload($event, documentFields[6].key)"
                                    :error="
                                        documentStates.ba_stap.error || form.errors.ba_stap_path
                                    "
                                    :disabled="documentStates.ba_stap.isUploading"
                                    accept=".pdf, .jpg, .jpeg, .png" />
                                <div
                                    v-if="documentStates.ba_stap.isUploading"
                                    class="upload-message text-sky-500">
                                    Mengunggah BA STAP...
                                </div>
                                <div
                                    v-else-if="documentStates.ba_stap.error"
                                    class="upload-message text-red-500">
                                    Gagal unggah: {{ documentStates.ba_stap.error }}
                                </div>
                                <div
                                    v-else-if="documentStates.ba_stap.uploadedPath"
                                    class="upload-message text-green-500 font-medium">
                                    ✅ File BA STAP **{{ documentStates.ba_stap.uploadedName }}**
                                    siap.
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                            5. Keterangan Tambahan
                        </h3>
                        <div>
                            <FormInput
                                label="Keterangan"
                                type="textarea"
                                v-model="form.keterangan"
                                :error="form.errors.keterangan"
                                rows="3"
                                placeholder="Catatan atau keterangan tambahan mengenai progres PO." />
                        </div>
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="
                            form.processing ||
                            Object.values(documentStates).some(s => s.isUploading)
                        "
                        :aria-busy="
                            form.processing ||
                            Object.values(documentStates).some(s => s.isUploading)
                        ">
                        <svg
                            v-if="
                                form.processing ||
                                Object.values(documentStates).some(s => s.isUploading)
                            "
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
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Data PO & Progres' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
