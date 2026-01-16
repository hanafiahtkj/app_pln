<script setup>
import { Head, useForm } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import KontrakSearchSelect from './KontrakSearchSelect.vue'
import FormCurrency from '@/Components/FormCurrency.vue'
// import FormCheckbox from '@/Components/FormCheckbox.vue' // Jika menggunakan component khusus
import { ref } from 'vue'

defineOptions({ layout: Default })

const props = defineProps({
    // Data Pembayaran yang akan diedit
    data: {
        type: Object,
        required: true
    },
    // Daftar Kontrak yang tersedia untuk dipilih (Foreign Key)
    kontraks: {
        type: Array,
        default: () => []
    }
})

// Daftar field checklist untuk memudahkan rendering
const checklistFields = [
    { key: 'berkas', label: 'Berkas Lengkap' },
    { key: 'vendor_upload_vip', label: 'Vendor Upload VIP' },
    { key: 'maker', label: 'Status Maker' },
    { key: 'checker', label: 'Status Checker' },
    { key: 'tax', label: 'Status Tax' },
    { key: 'sptjp', label: 'Status SPTJP' },
    { key: 'ira_irs', label: 'Status IRA/IRS' },
    { key: 'verifikator_pusat', label: 'Verifikator Pusat' },
    { key: 'lunas_vendor', label: 'Lunas Bayar Vendor' },
    { key: 'lunas_pajak', label: 'Lunas Bayar Pajak' }
]

// --- Inisialisasi Form Pembayaran dengan data yang ada ---
const form = useForm({
    // Menggunakan Inertia's PUT method
    // _method: 'put' tidak perlu ditambahkan jika menggunakan form.put()

    // Foreign Key
    kontrak_id: props.data.kontrak_id,

    // Detail Termin & Denda
    termin_pembayaran: props.data.termin_pembayaran,
    denda: props.data.denda, // Numeric fields
    sub_id: props.data.sub_id,

    // Nilai (gunakan tipe number pada input)
    // Pastikan field numerik diinisialisasi dengan nilai yang ada, null akan otomatis menjadi 0 jika form data dikirim
    nilai_tagihan: props.data.nilai_tagihan,
    nilai_akb: props.data.nilai_akb,
    nilai_ppn: props.data.nilai_ppn,
    nilai_pph: props.data.nilai_pph,
    nilai_bayar_vendor: props.data.nilai_bayar_vendor,
    nilai_bayar_pajak: props.data.nilai_bayar_pajak,

    // Tanggal
    rencana_bayar: props.data.rencana_bayar,
    realisasi_bayar: props.data.realisasi_bayar,
    rencana_bayar_pajak: props.data.rencana_bayar_pajak,
    realisasi_bayar_pajak: props.data.realisasi_bayar_pajak,

    // Status Checklist (Boolean) - Konversi ke boolean eksplisit
    berkas: !!props.data.berkas,
    vendor_upload_vip: !!props.data.vendor_upload_vip,
    maker: !!props.data.maker,
    checker: !!props.data.checker,
    tax: !!props.data.tax,
    sptjp: !!props.data.sptjp,
    ira_irs: !!props.data.ira_irs,
    verifikator_pusat: !!props.data.verifikator_pusat,
    lunas_vendor: !!props.data.lunas_vendor,
    lunas_pajak: !!props.data.lunas_pajak,

    // Keterangan
    keterangan: props.data.keterangan
})

const submit = () => {
    // Menggunakan form.put untuk mengirim update ke rute admin.pembayaran.update
    form.put(route('admin.pembayaran.update', { pembayaran: props.data.id }), {
        preserveScroll: true
    })
}

// Konversi daftar Kontrak dari props ke format opsi select
// const kontrakOptions = props.kontraks.map(kontrak => ({
//     // Tampilkan Nomor Perjanjian Kontrak sebagai label yang terkait
//     label: `${kontrak.nomor_perjanjian} (ID Kontrak: ${kontrak.id})`,
//     value: kontrak.id // Nilai yang dikirim adalah ID Kontrak
// }))
</script>

<template>
    <Head :title="`Edit Data Riwayat Pembayaran (Termin) ${props.data.termin_pembayaran}`" />
    <main class="max-w-6xl mx-auto space-y-8" aria-labelledby="edit-pembayaran">
        <h1 class="sr-only" id="edit-pembayaran">Edit Data Riwayat Pembayaran (Termin)</h1>
        <section class="container-border overflow-hidden">
            <PageHeader
                :title="`Edit Data Riwayat Pembayaran: ${props.data.termin_pembayaran} (${props.data.kontrak_id})`"
                description="Perbarui detail lengkap termin pembayaran terkait Kontrak ini."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    {
                        label: 'Data Pembayaran',
                        href: route('admin.pembayaran.index') // Rute disesuaikan
                    },
                    { label: 'Edit' }
                ]" />

            <form @submit.prevent="submit" class="divide-y divide-gray-200 dark:divide-gray-600">
                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                1. Informasi Kontrak & Termin
                            </h3>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <KontrakSearchSelect
                                label="Kontrak Terkait (Nomor Perjanjian / PRK)"
                                v-model="form.kontrak_id"
                                :kontraks="props.kontraks"
                                :error="form.errors.kontrak_id"
                                placeholder="Cari Nomor Perjanjian Kontrak atau PRK"
                                :disabled="true" />

                            <FormInput
                                label="Termin Pembayaran (Cth: Termin #1)"
                                type="text"
                                v-model="form.termin_pembayaran"
                                :error="form.errors.termin_pembayaran"
                                required />

                            <FormCurrency
                                label="Denda"
                                v-model="form.denda"
                                :error="form.errors.denda"
                                placeholder="Denda" />

                            <FormInput
                                label="Sub ID"
                                type="text"
                                v-model="form.sub_id"
                                :error="form.errors.sub_id"
                                placeholder="Masukkan Sub ID jika ada" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                2. Detail Nilai Pembayaran (dalam Rupiah)
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Masukkan nilai dalam format numerik (tanpa titik/koma ribuan).
                                Gunakan titik (.) untuk desimal.
                            </p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormCurrency
                                label="Nilai Tagihan"
                                v-model="form.nilai_tagihan"
                                :error="form.errors.nilai_tagihan"
                                placeholder="Nilai Tagihan" />

                            <FormCurrency
                                label="Nilai AKB"
                                v-model="form.nilai_akb"
                                :error="form.errors.nilai_akb"
                                placeholder="Nilai AKB" />

                            <FormCurrency
                                label="Nilai PPN"
                                v-model="form.nilai_ppn"
                                :error="form.errors.nilai_ppn"
                                placeholder="Nilai PPN" />
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <FormCurrency
                                label="Nilai PPH"
                                v-model="form.nilai_pph"
                                :error="form.errors.nilai_pph"
                                placeholder="Nilai PPH" />

                            <FormCurrency
                                label="Nilai Bayar Vendor"
                                v-model="form.nilai_bayar_vendor"
                                :error="form.errors.nilai_bayar_vendor"
                                placeholder="Nilai Bayar Vendor" />

                            <FormCurrency
                                label="Nilai Bayar Pajak"
                                v-model="form.nilai_bayar_pajak"
                                :error="form.errors.nilai_bayar_pajak"
                                placeholder="Nilai Bayar Pajak" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                3. Tanggal Rencana & Realisasi Pembayaran
                            </h3>
                        </div>
                        <h4 class="font-semibold text-gray-700 dark:text-gray-300">
                            Pembayaran Vendor
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Rencana Bayar Vendor"
                                type="date"
                                v-model="form.rencana_bayar"
                                :error="form.errors.rencana_bayar" />
                            <FormInput
                                label="Realisasi Bayar Vendor"
                                type="date"
                                v-model="form.realisasi_bayar"
                                :error="form.errors.realisasi_bayar" />
                        </div>

                        <h4 class="font-semibold text-gray-700 dark:text-gray-300 pt-4">
                            Pembayaran Pajak
                        </h4>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <FormInput
                                label="Rencana Bayar Pajak"
                                type="date"
                                v-model="form.rencana_bayar_pajak"
                                :error="form.errors.rencana_bayar_pajak" />
                            <FormInput
                                label="Realisasi Bayar Pajak"
                                type="date"
                                v-model="form.realisasi_bayar_pajak"
                                :error="form.errors.realisasi_bayar_pajak" />
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                4. Status Dokumen / Checklist
                            </h3>
                            <p class="mt-1 text-sm text-gray-500 dark:text-gray-400">
                                Tandai status dokumen/proses yang telah selesai.
                            </p>
                        </div>

                        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                            <div v-for="field in checklistFields" :key="field.key">
                                <label class="flex items-center space-x-2 cursor-pointer">
                                    <input
                                        type="checkbox"
                                        :id="field.key"
                                        v-model="form[field.key]"
                                        class="rounded border-gray-300 text-indigo-600 shadow-sm focus:ring-indigo-500 dark:bg-gray-800 dark:border-gray-600 dark:checked:bg-indigo-600" />
                                    <span
                                        class="text-sm font-medium text-gray-700 dark:text-gray-300">
                                        {{ field.label }}
                                    </span>
                                </label>
                                <p
                                    v-if="form.errors[field.key]"
                                    class="mt-1 text-sm text-red-600 dark:text-red-400">
                                    {{ form.errors[field.key] }}
                                </p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="p-6 dark:bg-gray-700">
                    <div class="max-w-4xl space-y-6">
                        <div class="border-b border-gray-100 dark:border-gray-600 pb-2">
                            <h3 class="text-xl font-semibold text-gray-900 dark:text-white">
                                5. Keterangan Tambahan
                            </h3>
                        </div>
                        <div>
                            <FormInput
                                label="Keterangan"
                                type="textarea"
                                v-model="form.keterangan"
                                :error="form.errors.keterangan"
                                rows="3"
                                placeholder="Catatan atau keterangan tambahan mengenai pembayaran termin." />
                        </div>
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
                        {{ form.processing ? 'Memperbarui...' : 'Perbarui Data Pembayaran' }}
                    </button>
                </div>
            </form>
        </section>
    </main>
</template>
