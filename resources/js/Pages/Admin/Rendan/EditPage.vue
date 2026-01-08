<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
import EnjiniringSearchSelect from './EnjiniringSearchSelect.vue'
import FileManagerInput from '@/Components/FileManagerInput.vue' // Import Komponen Baru

defineOptions({ layout: Default })

const props = defineProps({
    data: {
        type: Object,
        required: true
    },
    enjinirings: {
        type: Array,
        default: () => []
    }
})

// Helper untuk format tanggal agar sesuai dengan <input type="date">
const formatDate = dateString => {
    if (!dateString) return null
    try {
        return new Date(dateString).toISOString().split('T')[0]
    } catch {
        return dateString
    }
}

// Inisialisasi Form RENDAN dengan data dari database
const form = useForm({
    _method: 'put',
    enjiniring_id: props.data.enjiniring_id,

    // ND User Fields
    nomor_nd_user: props.data.nomor_nd_user,
    tanggal_nd_user: formatDate(props.data.tanggal_nd_user),
    dokumen_nd_user: props.data.dokumen_nd_user, // Simpan URL path langsung

    // RAB Field
    rab: props.data.rab,

    // RKS Fields
    nomor_rks: props.data.nomor_rks,
    tanggal_rks: formatDate(props.data.tanggal_rks),
    dokumen_rks: props.data.dokumen_rks // Simpan URL path langsung
})

const submit = () => {
    form.post(route('admin.rendan.update', props.data.id), {
        preserveScroll: true
    })
}
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
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Utama Rendan
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Pilih Enjiniring terkait dan detail RAB.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <EnjiniringSearchSelect
                                label="Data Enjiniring Terkait"
                                v-model="form.enjiniring_id"
                                :enjinirings="props.enjinirings"
                                :error="form.errors.enjiniring_id"
                                placeholder="Cari Enjiniring/Paket..."
                                :disabled="true" />

                            <FormCurrency
                                label="RAB (Rupiah)"
                                v-model="form.rab"
                                :error="form.errors.rab"
                                placeholder="RAB Rupiah" />

                            <div class="hidden md:block"></div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Nota Dinas (ND) User
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail Nota Dinas User terkait rencana pengadaan.
                            </p>
                        </div>

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

                            <FileManagerInput
                                label="Dokumen ND User"
                                v-model="form.dokumen_nd_user"
                                :error="form.errors.dokumen_nd_user"
                                placeholder="Pilih Dokumen ND..." />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Rencana Kerja Syarat (RKS)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Detail dokumen Rencana Kerja Syarat.
                            </p>
                        </div>

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

                            <FileManagerInput
                                label="Dokumen RKS"
                                v-model="form.dokumen_rks"
                                :error="form.errors.dokumen_rks"
                                placeholder="Pilih Dokumen RKS..." />
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
