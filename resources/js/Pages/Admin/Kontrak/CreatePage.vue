<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import LakdanSearchSelect from './LakdanSearchSelect.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
import { ref, onMounted } from 'vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Daftar Lakdan yang tersedia untuk dipilih (Foreign Key)
    lakdans: {
        type: Array,
        default: () => []
    }
})

const isLocked = ref(false)

// --- STATE UNTUK UPLOAD DOKUMEN PERJANJIAN ---
const isUploadingPerjanjian = ref(false)
const uploadedPerjanjianPath = ref(null)
const uploadedPerjanjianName = ref(null)
const uploadPerjanjianError = ref(null)

// --- STATE UNTUK UPLOAD DOKUMEN JAMINAN PELAKSANAAN ---
const isUploadingJaminan = ref(false)
const uploadedJaminanPath = ref(null)
const uploadedJaminanName = ref(null)
const uploadJaminanError = ref(null)

// --- Inisialisasi Form KONTRAK ---
const form = useForm({
    lakdan_id: null, // Foreign Key ke Lakdan

    // Core Kontrak Fields
    penyedia_barang_jasa: '',
    jenis_perjanjian: '',
    status_proses: '',
    keterangan: '',
    masa_pelaksanaan: null,
    durasi_pengadaan: null,

    // Date & Numeric Fields
    rencana_tanggal_perjanjian: '',
    realisasi_tanggal_perjanjian: '',
    tanggal_berakhir: '',
    nomor_perjanjian: '',
    nilai_perjanjian_ppn: null,
    nilai_perjanjian_sebelum_ppn: null,

    // Jaminan Pelaksanaan Fields
    rencana_jaminan_pelaksanaan: '',
    realisasi_jaminan_pelaksanaan: '',
    nomor_jaminan_pelaksanaan: '',
    nilai_jaminan_pelaksanaan: null,
    bank_pemberi_jaminan: '',

    // Metric Fields
    tingkat_risiko_csms: '',
    tkdn: null,
    efisiensi_thd_hps: '',

    // Document Fields
    dokumen_perjanjian: null,
    dokumen_jaminan_pelaksanaan: null,

    tanggal_efektif: ''
})

// Opsi status proses dan jenis perjanjian untuk FormSelect
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

// --- Fungsi Reusable Upload File ---
const handleFileUpload = async (event, field) => {
    const file = event.target.files[0]
    if (!file) return

    // Tentukan state yang relevan
    let isUploadingRef, uploadedPathRef, uploadedNameRef, uploadErrorRef
    let pathFieldName, nameFieldName

    if (field === 'perjanjian') {
        isUploadingRef = isUploadingPerjanjian
        uploadedPathRef = uploadedPerjanjianPath
        uploadedNameRef = uploadedPerjanjianName
        uploadErrorRef = uploadPerjanjianError
        pathFieldName = 'dokumen_perjanjian_path'
        nameFieldName = 'dokumen_perjanjian_name'
    } else if (field === 'jaminan_pelaksanaan') {
        isUploadingRef = isUploadingJaminan
        uploadedPathRef = uploadedJaminanPath
        uploadedNameRef = uploadedJaminanName
        uploadErrorRef = uploadJaminanError
        pathFieldName = 'dokumen_jaminan_pelaksanaan_path'
        nameFieldName = 'dokumen_jaminan_pelaksanaan_name'
    } else {
        return
    }

    isUploadingRef.value = true
    uploadErrorRef.value = null
    uploadedPathRef.value = null
    uploadedNameRef.value = null

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
        const fieldLabel = field === 'perjanjian' ? 'Perjanjian' : 'Jaminan Pelaksanaan'

        if (response.ok && data.success) {
            uploadedPathRef.value = data.path
            uploadedNameRef.value = data.filename

            // Simpan path ke form untuk dikirim ke controller Laravel
            form[pathFieldName] = data.path
            form[nameFieldName] = data.filename
        } else {
            uploadErrorRef.value = data.message || `Gagal mengunggah file Dokumen ${fieldLabel}.`
        }
    } catch (error) {
        const fieldLabel = field === 'perjanjian' ? 'Perjanjian' : 'Jaminan Pelaksanaan'
        uploadErrorRef.value = `Terjadi kesalahan jaringan saat mengunggah Dokumen ${fieldLabel}.`
    } finally {
        isUploadingRef.value = false
        event.target.value = '' // Reset input file
    }
}

const submit = () => {
    // Rute disesuaikan ke admin.kontrak.store
    form.post(route('admin.kontrak.store'), {
        preserveScroll: true
    })
}

// Konversi daftar Lakdan dari props ke format opsi select
// const lakdanOptions = props.lakdans.map(lakdan => ({
//     // Tampilkan Nomor HPS Lakdan sebagai label yang terkait dengan Kontrak
//     label: `${lakdan.nomor_hps} (ID Lakdan: ${lakdan.id})`,
//     value: lakdan.id // Nilai yang dikirim adalah ID Lakdan
// }))

onMounted(() => {
    // Ambil parameter dari URL
    const urlParams = new URLSearchParams(window.location.search)
    const lakdanIdFromUrl = urlParams.get('lakdan_id')

    if (lakdanIdFromUrl) {
        form.lakdan_id = lakdanIdFromUrl
        isLocked.value = true
    }
})
</script>

<template>
    <Head title="Buat Data Kontrak" />
    <main class="mx-auto space-y-8" aria-labelledby="create-kontrak">
        <h1 class="sr-only" id="create-kontrak">Buat Data Kontrak</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data Kontrak"
                description="Masukkan detail lengkap Kontrak yang terkait dengan Pelaksanaan Pengadaan (Lakdan)."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Kontrak',
                        href: route('admin.kontrak.index') // Rute disesuaikan
                    },
                    { label: 'Buat' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Utama Kontrak
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih Lakdan terkait dan detail dasar kontrak.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <LakdanSearchSelect
                                label="Lakdan Terkait (Nomor HPS / PRK)"
                                v-model="form.lakdan_id"
                                :lakdans="props.lakdans"
                                :error="form.errors.lakdan_id"
                                placeholder="Cari Nomor HPS atau PRK Lakdan"
                                :disabled="isLocked" />

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
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Detail Perjanjian (Kontrak)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tanggal, nomor, nilai, dan dokumen perjanjian.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Perjanjian"
                                v-model="form.nomor_perjanjian"
                                :error="form.errors.nomor_perjanjian"
                                placeholder="Cth: 001.Pj/DAN.01.03/F48000000/2025" />

                            <FormCurrency
                                label="Nilai Perjanjian (PPN)"
                                v-model="form.nilai_perjanjian_ppn"
                                :error="form.errors.nilai_perjanjian_ppn"
                                placeholder="Nilai termasuk PPN" />

                            <FormCurrency
                                label="Nilai Perjanjian (sebelum PPN)"
                                v-model="form.nilai_perjanjian_sebelum_ppn"
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
                            <FileManagerInput
                                label="Dokumen Kontrak"
                                v-model="form.dokumen_perjanjian"
                                :error="form.errors.dokumen_perjanjian"
                                placeholder="Pilih Dokumen" />

                            <FormInput
                                label="Tgl Efektif ontrak"
                                type="date"
                                v-model="form.tanggal_efektif"
                                :error="form.errors.tanggal_efektif"
                                placeholder="Cth: PT Sinar Jaya" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Detail Jaminan Pelaksanaan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Informasi mengenai jaminan pelaksanaan kontrak.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormInput
                                label="Nomor Jaminan Pelaksanaan"
                                v-model="form.nomor_jaminan_pelaksanaan"
                                :error="form.errors.nomor_jaminan_pelaksanaan"
                                placeholder="Cth: BG5344615" />

                            <FormCurrency
                                label="Nilai Jaminan Pelaksanaan"
                                v-model="form.nilai_jaminan_pelaksanaan"
                                :error="form.errors.nilai_jaminan_pelaksanaan"
                                placeholder="Nilai Jaminan Pelaksanaan" />

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
                            <FileManagerInput
                                label="Dokumen Jaminan Pelaksanaan"
                                v-model="form.dokumen_jaminan_pelaksanaan"
                                :error="form.errors.dokumen_jaminan_pelaksanaan"
                                placeholder="Pilih Dokumen" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                4. Metrik dan Keterangan Tambahan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Informasi mengenai risiko, TKDN, dan efisiensi.
                            </p>
                        </div>

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
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Kontrak' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
