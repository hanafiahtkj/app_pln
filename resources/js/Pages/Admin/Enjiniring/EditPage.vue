<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormTextarea from '@/Components/FormTextarea.vue' // Tambahkan FormTextarea
import FormSelect from '@/Components/FormSelect.vue'
import PaketSearchSelect from './PaketSearchSelect.vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    data: {
        type: Object,
        required: true // Data Paket Enjiniring yang akan diedit (dengan relasi prk)
    },
    pakets: {
        type: Array,
        default: () => []
    }
})

// Helper untuk format tanggal dari database (YYYY-MM-DD HH:MM:SS) ke input date (YYYY-MM-DD)
const formatDate = dateString => {
    if (!dateString) return null
    try {
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString
    }
}

// Konversi daftar PRK dari props ke format opsi select
// const prkOptions = props.prks.map(prk => ({
//     label: `PRK: ${prk.prk}`,
//     value: prk.id
// }))

// --- Inisialisasi Form PAKET ENJINIRING dengan data yang ada ---
const form = useForm({
    _method: 'put',

    // Foreign Key
    paket_id: props.data.paket_id,

    // Target dan Realisasi Tanggal Survey
    target_survey: formatDate(props.data.target_survey),
    realisasi_survey: formatDate(props.data.realisasi_survey),

    // Target dan Realisasi Dokumen Enjiniring
    target_dokumen_enjiniring: formatDate(props.data.target_dokumen_enjiniring),
    realisasi_dokumen_enjiniring: formatDate(props.data.realisasi_dokumen_enjiniring),

    // Field Dokumen (String/Teks/Nomor Referensi)
    dokumen_survey: props.data.dokumen_survey || '',
    dokumen_rab: props.data.dokumen_rab || '',
    dokumen_tor: props.data.dokumen_tor || '',

    // Keterangan
    keterangan: props.data.keterangan || '',

    file_survey: props.data.file_survey || '',
    file_rab: props.data.file_rab || '',
    file_tor: props.data.file_tor || ''
})

const submit = () => {
    // Ubah rute ke update Paket Enjiniring
    form.post(route('admin.enjiniring.update', props.data.id), {
        preserveScroll: true
    })
}
</script>

<template>
    <Head :title="`Edit Data Enjiniring: ${props.data.prk_id || props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-paket-enjiniring">
        <h1 class="sr-only" id="edit-paket-enjiniring">Edit Data Enjiniring</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Enjiniring : ${props.data.id}`"
                description="Perbarui detail lengkap status Enjiniring untuk Paket tertentu."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Enjiniring',
                        href: route('admin.enjiniring.index')
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Paket Terkait
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih Nomor Paket Pekerjaan yang akan diberi detail Enjiniring.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                            <PaketSearchSelect
                                label="Nomor Paket"
                                v-model="form.paket_id"
                                :pakets="props.pakets"
                                :error="form.errors.paket_id"
                                placeholder="Cari Paket Pekerjaan..."
                                class="md:col-span-2"
                                :disabled="true" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Status Survey
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Target dan realisasi pelaksanaan survey.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Nomor/Nama Dokumen Survey"
                                v-model="form.dokumen_survey"
                                :error="form.errors.dokumen_survey"
                                placeholder="Cth: Dok. Survey 2025.P3BK.4.001" />

                            <FileManagerInput
                                label="File Survey"
                                v-model="form.file_survey"
                                :error="form.errors.file_survey" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Tanggal Target Survey"
                                type="date"
                                v-model="form.target_survey"
                                :error="form.errors.target_survey" />

                            <FormInput
                                label="Tanggal Realisasi Survey"
                                type="date"
                                v-model="form.realisasi_survey"
                                :error="form.errors.realisasi_survey" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Dokumen Enjiniring (RAB & TOR)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail status dokumen enjiniring dan referensi dokumen.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Tanggal Target Dokumen Enjiniring"
                                type="date"
                                v-model="form.target_dokumen_enjiniring"
                                :error="form.errors.target_dokumen_enjiniring" />

                            <FormInput
                                label="Tanggal Realisasi Dokumen Enjiniring"
                                type="date"
                                v-model="form.realisasi_dokumen_enjiniring"
                                :error="form.errors.realisasi_dokumen_enjiniring" />

                            <FormInput
                                label="Nomor/Nama Dokumen RAB"
                                v-model="form.dokumen_rab"
                                :error="form.errors.dokumen_rab"
                                placeholder="Cth: Dok. RAB 2025.P3BK.4.001" />

                            <FileManagerInput
                                label="File RAB"
                                v-model="form.file_rab"
                                :error="form.errors.file_rab" />

                            <FormInput
                                label="Nomor/Nama Dokumen TOR"
                                v-model="form.dokumen_tor"
                                :error="form.errors.dokumen_tor"
                                placeholder="Cth: Dok. TOR 2025.P3BK.4.001" />

                            <FileManagerInput
                                label="File TOR"
                                v-model="form.file_tor"
                                :error="form.errors.file_tor" />
                        </div>

                        <FormTextarea
                            label="Keterangan Tambahan"
                            v-model="form.keterangan"
                            :error="form.errors.keterangan"
                            rows="3" />
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button
                        type="submit"
                        class="btn-primary inline-flex items-center gap-2"
                        :disabled="form.processing"
                        :aria-busy="form.processing">
                        <svg
                            v-if="form.processing"
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
                        {{ form.processing ? 'Memperbarui...' : 'Update Data Enjiniring' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
