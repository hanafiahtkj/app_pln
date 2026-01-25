<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormTextarea from '@/Components/FormTextarea.vue'
import FormSelect from '@/Components/FormSelect.vue'
import PaketSearchSelect from './PaketSearchSelect.vue'
import { ref, computed, watch, onMounted } from 'vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'
import FormCurrency from '@/Components/FormCurrency.vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Prop: Daftar PRK yang tersedia untuk dipilih (Foreign Key)
    pakets: {
        type: Array,
        default: () => []
    }
})

const isLocked = ref(false)

// --- Inisialisasi Form PAKET ENJINIRING ---
const form = useForm({
    paket_id: null, // Diubah dari 'paket_id' menjadi 'prk_id'

    // Target dan Realisasi Tanggal
    target_survey: null,
    realisasi_survey: null,
    target_dokumen_enjiniring: null,
    realisasi_dokumen_enjiniring: null,

    // Field Dokumen (Disimpan sebagai String/Teks/Nomor Referensi)
    dokumen_survey: '',
    dokumen_rab: '',
    dokumen_tor: '',
    rab: '',

    // Keterangan
    keterangan: '',

    file_survey: '',
    file_rab: '',
    file_tor: ''
})

const submit = () => {
    const routeParams = form.paket_id ? { paket_id: form.paket_id } : {}

    form.post(route('admin.enjiniring.store', routeParams), {
        preserveScroll: true,
        onSuccess: () => {}
    })
}

onMounted(() => {
    // Ambil parameter dari URL
    const urlParams = new URLSearchParams(window.location.search)
    const paketIdFromUrl = urlParams.get('paket_id')

    if (paketIdFromUrl) {
        form.paket_id = paketIdFromUrl
        isLocked.value = true
    }
})
</script>

<template>
    <Head title="Buat Data Enjiniring" />
    <main class="mx-auto space-y-8" aria-labelledby="create-paket-enjiniring">
        <h1 class="sr-only" id="create-paket-enjiniring">Buat Data Paket Enjiniring</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data Enjiniring"
                description="Masukkan detail lengkap status Enjiniring untuk PRK tertentu."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Enjiniring',
                        href: route('admin.enjiniring.index')
                    },
                    { label: 'Buat' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
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
                                :disabled="isLocked" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
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
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Dokumen Enjiniring (RAB & TOR)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail status dokumen enjiniring dan referensi dokumen.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
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
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormCurrency
                                label="RAB (Rupiah)"
                                v-model="form.rab"
                                :error="form.errors.rab"
                                placeholder="RAB Rupiah" />

                            <div class="hidden md:block"></div>

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
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Data Enjiniring' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
