<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormTextarea from '@/Components/FormTextarea.vue'
import FormSelect from '@/Components/FormSelect.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
import { ref } from 'vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    bidangs: Object // <-- Terima data Bidangs
})

// --- Definisikan opsi statis default untuk Fungsi dan Status ---
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

// --- STATE UNTUK UPLOAD DOKUMEN SKAI ---
const isUploadingSkai = ref(false)
const uploadedSkaiPath = ref(null)
const uploadedSkaiName = ref(null)
const uploadSkaiError = ref(null)

const currentYear = new Date().getFullYear()
const minYear = 2024 // Tentukan tahun awal yang wajar
const maxYear = currentYear + 1 // Tentukan tahun akhir yang wajar
const tahunOptions = []

for (let year = maxYear; year >= minYear; year--) {
    tahunOptions.push({ label: String(year), value: year })
}

// --- Inisialisasi Form PRK ---
const form = useForm({
    tahun: currentYear,
    prk: '',
    fungsi: '',
    uraian: '',
    status: '',
    ai_rupiah: null,
    bidang_id: null,

    // Dokumen & Tanggal Kajian
    dokumen_kkp: '',
    tanggal_kkp: '',
    ulasan_kajian_risiko: '',
    tanggal_ulasan_kajian_risiko: '',
    dokumen_grc: '',
    tanggal_dokumen_grc: '',

    // Dokumen & Tanggal Persetujuan TVV
    tanggal_tvv: '',
    status_persetujuan_tvv: '',
    dokumen_tvv: '',

    // SKAI
    nomor_skai: '',
    tanggal_skai: '',
    nilai_skai: null,
    jumlah_paket: null,

    // FIELD BARU UNTUK FILE UPLOAD SKAI
    dokumen_skai: null,

    file_kkp: null,
    file_kajian_risiko: null,
    file_grc: null,
    file_tvv: null
})

const submit = () => {
    form.post(route('admin.prk.store'), {
        preserveScroll: true
    })
}
</script>

<template>
    <Head title="Buat Data PRK" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="create-prk">
        <h1 class="sr-only" id="create-prk">Buat Data PRK</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data PRK"
                description="Masukkan detail lengkap Program Rencana Kerja (PRK)."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data PRK',
                        href: route('admin.prk.index')
                    },
                    { label: 'Buat' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Pokok PRK
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Identitas, fungsi, dan uraian utama dari PRK.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Tahun"
                                v-model.number="form.tahun"
                                :options="tahunOptions"
                                :error="form.errors.tahun"
                                placeholder="Pilih Tahun" />
                            <FormInput
                                label="Nomor PRK"
                                v-model="form.prk"
                                :error="form.errors.prk"
                                placeholder="Cth: 2025.P3BK.4.001" />

                            <FormSelect
                                label="Fungsi"
                                v-model="form.fungsi"
                                :options="defaultFungsiOptions"
                                :error="form.errors.fungsi"
                                placeholder="Pilih Fungsi" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Bidang Pelaksana"
                                v-model.number="form.bidang_id"
                                :options="props.bidangs?.data || []"
                                option-label="name"
                                option-value="id"
                                :error="form.errors.bidang_id"
                                placeholder="Pilih Bidang" />

                            <FormSelect
                                label="Status PRK"
                                v-model="form.status"
                                :options="defaultStatusOptions"
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
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Anggaran dan Paket
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail biaya investasi dan jumlah paket yang disetujui.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormCurrency
                                label="Anggaran Investasi (AI) Rupiah"
                                v-model="form.ai_rupiah"
                                :error="form.errors.ai_rupiah"
                                placeholder="AI Rupiah" />

                            <FormCurrency
                                label="Nilai SKAI (Rupiah)"
                                v-model="form.nilai_skai"
                                :error="form.errors.nilai_skai"
                                placeholder="SKAI Rupiah" />

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
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Kaji Ulang Dokumen (KKP, Risiko, GRC)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Data terkait kajian kebutuhan proyek, risiko, dan GRC.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
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
                            <FileManagerInput
                                label="File KKP"
                                v-model="form.file_kkp"
                                :error="form.errors.file_kkp" />

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
                            <FileManagerInput
                                label="File Kajian Risiko"
                                v-model="form.file_kajian_risiko"
                                :error="form.errors.file_kajian_risiko" />

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
                            <FileManagerInput
                                label="File GRC"
                                v-model="form.file_grc"
                                :error="form.errors.file_grc" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                4. Persetujuan (TVV & SKAI)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Data terkait Technical Verification and Validation (TVV) dan SKAI.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-x-8 gap-y-6">
                            <FormInput
                                label="Dokumen TVV (Nama/Nomor)"
                                v-model="form.dokumen_tvv"
                                :error="form.errors.dokumen_tvv"
                                placeholder="Cth: Nota Persetujuan TVV" />

                            <FormInput
                                label="Tanggal TVV"
                                type="date"
                                v-model="form.tanggal_tvv"
                                :error="form.errors.tanggal_tvv" />

                            <FileManagerInput
                                label="File TTV"
                                v-model="form.file_tvv"
                                :error="form.errors.file_tvv" />

                            <FormSelect
                                label="Status Persetujuan TVV"
                                v-model="form.status_persetujuan_tvv"
                                :options="defaultTvvStatusOptions"
                                :error="form.errors.status_persetujuan_tvv"
                                placeholder="Pilih Status Persetujuan" />
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-x-8 gap-y-6">
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

                            <FileManagerInput
                                label="Dokumen SKAI"
                                v-model="form.dokumen_skai"
                                :error="form.errors.dokumen_skai" />
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
                        {{ form.processing ? 'Menyimpan...' : 'Simpan PRK' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
