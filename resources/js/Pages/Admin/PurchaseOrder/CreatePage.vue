<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import KontrakSearchSelect from './KontrakSearchSelect.vue'
import FileManagerInput from '@/Components/FileManagerInput.vue' // Komponen Baru
import { ref, onMounted } from 'vue'

defineOptions({ layout: Default })

const props = defineProps({
    kontraks: {
        type: Array,
        default: () => []
    }
})

const isLocked = ref(false)

// Inisialisasi Form sesuai dengan field database Anda
const form = useForm({
    kontrak_id: null,
    keterangan: '',
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
    realisasi_cod: '',
    // Field Dokumen menggunakan v-model ke FileManagerInput
    dokumen_po: null,
    dokumen_pemeriksaan_mos: null,
    ba_pemeriksaan_25: null,
    ba_pemeriksaan_50: null,
    ba_pemeriksaan_75: null,
    ba_pembayaran_25: null,
    ba_pembayaran_50: null,
    ba_pembayaran_75: null,
    ba_stp: null,
    ba_stap: null
})

const submit = () => {
    form.post(route('admin.po.store'), {
        preserveScroll: true
    })
}

onMounted(() => {
    const urlParams = new URLSearchParams(window.location.search)
    const kontrakIdFromUrl = urlParams.get('kontrak_id')
    if (kontrakIdFromUrl) {
        form.kontrak_id = kontrakIdFromUrl
        isLocked.value = true
    }
})
</script>

<template>
    <Head title="Buat Data Purchase Order (PO) & Progres" />
    <main class="max-w-6xl mx-auto space-y-8">
        <section class="container-border overflow-hidden">
            <PageHeader
                title="Buat Data Purchase Order (PO) & Progres"
                description="Masukkan detail lengkap Purchase Order dan pelacakan progres terkait Kontrak."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data PO & Progres', href: route('admin.po.index') },
                    { label: 'Buat' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Kontrak Terkait
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih Kontrak yang menjadi induk dari Purchase Order dan Progres
                                ini.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-start">
                            <KontrakSearchSelect
                                label="Kontrak Terkait"
                                v-model="form.kontrak_id"
                                :kontraks="props.kontraks"
                                :error="form.errors.kontrak_id"
                                :disabled="isLocked" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Purchase Order (PO) & Material On Site (MOS)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tanggal rencana dan realisasi untuk PO dan Material On Site.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 items-start">
                            <FormInput
                                label="Rencana Tgl PO"
                                type="date"
                                v-model="form.rencana_po"
                                :error="form.errors.rencana_po" />
                            <FormInput
                                label="Realisasi Tgl PO"
                                type="date"
                                v-model="form.realisasi_po"
                                :error="form.errors.realisasi_po" />
                            <FileManagerInput
                                label="Dokumen PO"
                                v-model="form.dokumen_po"
                                :error="form.errors.dokumen_po" />

                            <FormInput
                                label="Rencana Tgl MOS"
                                type="date"
                                v-model="form.rencana_mos"
                                :error="form.errors.rencana_mos" />
                            <FormInput
                                label="Realisasi Tgl MOS"
                                type="date"
                                v-model="form.realisasi_mos"
                                :error="form.errors.realisasi_mos" />
                            <FileManagerInput
                                label="Dokumen MOS"
                                v-model="form.dokumen_pemeriksaan_mos"
                                :error="form.errors.dokumen_pemeriksaan_mos" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Pelacakan Progres 25%, 50%, dan 75%
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tanggal rencana dan realisasi untuk setiap tahapan progres.
                            </p>
                        </div>

                        <div class="space-y-8">
                            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 items-start">
                                <FormInput
                                    label="Rencana Tgl 25%"
                                    type="date"
                                    v-model="form.rencana_progress_25"
                                    :error="form.errors.rencana_progress_25" />
                                <FormInput
                                    label="Realisasi Tgl 25%"
                                    type="date"
                                    v-model="form.realisasi_progress_25"
                                    :error="form.errors.realisasi_progress_25" />
                                <FileManagerInput
                                    label="BA Pemeriksaan 25%"
                                    v-model="form.ba_pemeriksaan_25"
                                    :error="form.errors.ba_pemeriksaan_25" />
                                <FileManagerInput
                                    label="BA Pembayaran 25%"
                                    v-model="form.ba_pembayaran_25"
                                    :error="form.errors.ba_pembayaran_25" />
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 items-start">
                                <FormInput
                                    label="Rencana Tgl 50%"
                                    type="date"
                                    v-model="form.rencana_progress_50"
                                    :error="form.errors.rencana_progress_50" />
                                <FormInput
                                    label="Realisasi Tgl 50%"
                                    type="date"
                                    v-model="form.realisasi_progress_50"
                                    :error="form.errors.realisasi_progress_50" />
                                <FileManagerInput
                                    label="BA Pemeriksaan 50%"
                                    v-model="form.ba_pemeriksaan_50"
                                    :error="form.errors.ba_pemeriksaan_50" />
                                <FileManagerInput
                                    label="BA Pembayaran 50%"
                                    v-model="form.ba_pembayaran_50"
                                    :error="form.errors.ba_pembayaran_50" />
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-4 gap-6 items-start">
                                <FormInput
                                    label="Rencana Tgl 75%"
                                    type="date"
                                    v-model="form.rencana_progress_75"
                                    :error="form.errors.rencana_progress_75" />
                                <FormInput
                                    label="Realisasi Tgl 75%"
                                    type="date"
                                    v-model="form.realisasi_progress_75"
                                    :error="form.errors.realisasi_progress_75" />
                                <FileManagerInput
                                    label="BA Pemeriksaan 75%"
                                    v-model="form.ba_pemeriksaan_75"
                                    :error="form.errors.ba_pemeriksaan_75" />
                                <FileManagerInput
                                    label="BA Pembayaran 75%"
                                    v-model="form.ba_pembayaran_75"
                                    :error="form.errors.ba_pembayaran_75" />
                            </div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                4. Commercial Operation Date (COD)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tanggal rencana dan realisasi untuk COD (Serah Terima
                                Pekerjaan/Aset).
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 items-start">
                            <FormInput
                                label="Rencana Tgl COD"
                                type="date"
                                v-model="form.rencana_cod"
                                :error="form.errors.rencana_cod" />
                            <FormInput
                                label="Realisasi Tgl COD"
                                type="date"
                                v-model="form.realisasi_cod"
                                :error="form.errors.realisasi_cod" />

                            <FileManagerInput
                                label="BA STP (COD)"
                                v-model="form.ba_stp"
                                :error="form.errors.ba_stp" />
                            <FileManagerInput
                                label="BA STAP (COD)"
                                v-model="form.ba_stap"
                                :error="form.errors.ba_stap" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                5. Keterangan Tambahan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Catatan atau keterangan tambahan mengenai progres PO.
                            </p>
                        </div>

                        <FormInput
                            label="Keterangan"
                            type="textarea"
                            v-model="form.keterangan"
                            :error="form.errors.keterangan"
                            rows="3" />
                    </div>
                </section>

                <div class="px-6 py-4 bg-gray-50 dark:bg-gray-800 flex justify-end">
                    <button type="submit" class="btn-primary" :disabled="form.processing">
                        {{ form.processing ? 'Menyimpan...' : 'Simpan Data PO & Progres' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
