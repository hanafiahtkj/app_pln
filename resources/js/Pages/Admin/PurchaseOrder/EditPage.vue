<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import KontrakSearchSelect from './KontrakSearchSelect.vue'
import FileManagerInput from '@/Components/FileManagerInput.vue'

defineOptions({ layout: Default })

const props = defineProps({
    data: {
        type: Object,
        required: true // Data PO & Progres yang akan diedit
    },
    kontraks: {
        type: Array,
        default: () => []
    }
})

// Helper untuk format tanggal dari database ke input date (YYYY-MM-DD)
const formatDate = dateString => {
    if (!dateString) return null
    try {
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString
    }
}

// Inisialisasi Form dengan data yang sudah ada
const form = useForm({
    _method: 'put',
    kontrak_id: props.data.kontrak_id,
    keterangan: props.data.keterangan,

    // Date Fields
    rencana_po: formatDate(props.data.rencana_po),
    realisasi_po: formatDate(props.data.realisasi_po),
    rencana_mos: formatDate(props.data.rencana_mos),
    realisasi_mos: formatDate(props.data.realisasi_mos),
    rencana_progress_25: formatDate(props.data.rencana_progress_25),
    realisasi_progress_25: formatDate(props.data.realisasi_progress_25),
    rencana_progress_50: formatDate(props.data.rencana_progress_50),
    realisasi_progress_50: formatDate(props.data.realisasi_progress_50),
    rencana_progress_75: formatDate(props.data.rencana_progress_75),
    realisasi_progress_75: formatDate(props.data.realisasi_progress_75),
    rencana_cod: formatDate(props.data.rencana_cod),
    realisasi_cod: formatDate(props.data.realisasi_cod),

    // Document Fields (URL path dari database)
    dokumen_po: props.data.dokumen_po,
    dokumen_pemeriksaan_mos: props.data.dokumen_pemeriksaan_mos,
    ba_pemeriksaan_25: props.data.ba_pemeriksaan_25,
    ba_pemeriksaan_50: props.data.ba_pemeriksaan_50,
    ba_pemeriksaan_75: props.data.ba_pemeriksaan_75,
    ba_pembayaran_25: props.data.ba_pembayaran_25,
    ba_pembayaran_50: props.data.ba_pembayaran_50,
    ba_pembayaran_75: props.data.ba_pembayaran_75,
    ba_stp: props.data.ba_stp,
    ba_stap: props.data.ba_stap
})

const submit = () => {
    form.post(route('admin.po.update', props.data.id), {
        preserveScroll: true
    })
}
</script>

<template>
    <Head :title="`Edit PO & Progres: ${props.data.id}`" />
    <main class="max-w-6xl mx-auto space-y-8">
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit PO & Progres: ${props.data.id}`"
                description="Perbarui detail Purchase Order dan pelacakan progres kontrak."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data PO & Progres', href: route('admin.po.index') },
                    { label: 'Edit' }
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
                                :disabled="true" />
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

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 items-start pt-2">
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

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 items-start pt-2">
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
                    <button
                        type="submit"
                        class="btn-primary flex items-center gap-2"
                        :disabled="form.processing">
                        <svg
                            v-if="form.processing"
                            class="animate-spin h-4 w-4"
                            viewBox="0 0 24 24">
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
                        {{ form.processing ? 'Memperbarui...' : 'Update Data PO & Progres' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
