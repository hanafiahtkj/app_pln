<script setup>
import { Head, useForm, usePage } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormTextarea from '@/Components/FormTextarea.vue'
import FormSelect from '@/Components/FormSelect.vue'
import PrkSearchSelect from './PrkSearchSelect.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
import { ref, computed, watch } from 'vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Asumsi: Daftar PRK yang tersedia untuk dipilih di form
    prks: {
        type: Array,
        default: () => []
    },
    units: Object
})

const page = usePage()

const formattedUnits = computed(() => {
    return (
        props.units?.data.map(unit => ({
            ...unit,
            label_with_code: `${unit.kode} - ${unit.name}`
        })) || []
    )
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

const currentYear = new Date().getFullYear()
const minYear = 2024 // Tentukan tahun awal yang wajar
const maxYear = currentYear + 1 // Tentukan tahun akhir yang wajar
const tahunOptions = []

for (let year = maxYear; year >= minYear; year--) {
    tahunOptions.push({ label: String(year), value: year })
}

const getFileName = url => {
    if (!url) return ''
    return url.split('/').pop()
}

// --- Inisialisasi Form PAKET ---
const form = useForm({
    prk_id: null, // Foreign Key ke PRK
    tahun: currentYear,
    uraian_paket: '',
    unit_id: page.props.auth.user?.unit?.id || null,

    // Informasi SKK (Surat Keputusan Kebutuhan)
    nomor_skk: '',
    tanggal_skk: '',
    nilai_skk: null,
    status_paket: '',

    // FIELD BARU UNTUK FILE UPLOAD DOKUMEN SKK
    dokumen_skk: null
})

const openFileManager = () => {
    // Pastikan prefix sesuai dengan config/lfm.php Anda
    const route_prefix = '/filemanager'
    window.open(route_prefix + '?type=Files', 'FileManager', 'width=900,height=600')

    window.SetUrl = items => {
        const file = Array.isArray(items) ? items[0] : items
        form.dokumen_skk = file.url // Menyimpan path/URL ke form
    }
}

const clearFile = () => {
    form.dokumen_skk = null
}

// --- Computed Property untuk Filter PRK berdasarkan Tahun ---
const filteredPrks = computed(() => {
    const selectedTahun = form.tahun

    // 1. Cek jika Tahun TIDAK diisi atau TIDAK valid
    // Jika null, 0, atau bukan angka, kembalikan SEMUA PRK.
    if (!selectedTahun || isNaN(selectedTahun) || selectedTahun <= 0) {
        return props.prks // <<< KEMBALIKAN SEMUA PRK
    }

    // 2. Jika Tahun diisi dan valid, lakukan filter
    return props.prks.filter(prk => prk.tahun == selectedTahun)
})

// --- Bersihkan prk_id jika tahun berubah ---
// Ini penting agar prk_id tidak merujuk ke PRK dari tahun sebelumnya.
watch(
    () => form.tahun,
    (newTahun, oldTahun) => {
        if (newTahun !== oldTahun) {
            form.prk_id = null
        }
    }
)

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
// const prkOptions = props.prks.map(prk => ({
//     label: prk.prk, // Tampilkan nomor PRK
//     value: prk.id // Nilai yang dikirim adalah ID PRK
// }))
</script>

<template>
    <Head title="Buat Data Paket" />
    <main class="mx-auto space-y-8" aria-labelledby="create-paket">
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
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Utama Paket
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih PRK terkait dan detail tahun.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormSelect
                                label="Tahun"
                                v-model.number="form.tahun"
                                :options="tahunOptions"
                                :error="form.errors.tahun"
                                placeholder="Pilih Tahun" />

                            <PrkSearchSelect
                                label="PRK Terkait"
                                v-model="form.prk_id"
                                :prks="filteredPrks"
                                :error="form.errors.prk_id"
                                placeholder="Cari PRK..." />

                            <FormSelect
                                label="Unit"
                                v-model.number="form.unit_id"
                                :options="formattedUnits || []"
                                option-label="label_with_code"
                                option-value="id"
                                :error="form.errors.unit_id"
                                placeholder="Pilih Unit" />

                            <div class="hidden md:block"></div>
                        </div>

                        <FormTextarea
                            label="Uraian Paket"
                            v-model="form.uraian_paket"
                            :error="form.errors.uraian_paket"
                            rows="3" />
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-6xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Surat Keputusan Kebutuhan (SKK)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail SKK terkait paket ini.
                            </p>
                        </div>

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
                            <FormCurrency
                                label="Nilai SKK (Rupiah)"
                                v-model="form.nilai_skk"
                                :error="form.errors.nilai_skk"
                                placeholder="SKK Rupiah" />

                            <FileManagerInput
                                label="Dokumen SKK"
                                v-model="form.dokumen_skk"
                                :error="form.errors.dokumen_skk" />
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
