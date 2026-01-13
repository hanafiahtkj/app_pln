<script setup>
import { Head, useForm, router, Link } from '@inertiajs/vue3'
import DataTable from '@/Components/Datatable.vue'
import Default from '@/Layouts/Default.vue'
import Modal from '@/Components/Modal.vue'
import { createColumnHelper } from '@tanstack/vue-table'
import { h, ref, watch, onMounted } from 'vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormInput from '@/Components/FormInput.vue'
import FormSelect from '@/Components/FormSelect.vue'
import Switch from '@/Components/Switch.vue'

defineOptions({
    layout: Default
})

const props = defineProps({
    data: {
        type: Object,
        required: true
    },
    filters: Object
})

// --- STATE FILTER ---
const filterTahun = ref(props.filters?.tahun || '')

// Generate list tahun (10 tahun terakhir)
const currentYear = new Date().getFullYear()
const yearsOptions = Array.from({ length: 10 }, (_, i) => {
    const year = currentYear - i
    return { value: year.toString(), label: year.toString() }
})

// Fungsi Reset
const resetFilters = () => {
    filterTahun.value = ''
}

const columnHelper = createColumnHelper()
const loading = ref(false)
const pagination = ref({
    current_page: props.data.current_page,
    per_page: Number(props.data.per_page),
    total: props.data.total
})

// --- STATE UNTUK EDIT/CREATE PRK ---
const showFormModal = ref(false)
const prkToEdit = ref(null) // Menyimpan data PRK yang akan diedit

const showDeleteModal = ref(false)
const prkToDelete = ref(null)

// --- MEMODIFIKASI useForm SESUAI SKEMA PRK (Huruf Kecil) ---
const form = useForm({
    tahun: '',
    prk: '',
    fungsi: '',
    uraian: '',
    status: '',
    ai_rupiah: '',
    user: '',
    dokumen_kkp: '',
    tanggal_kkp: '',
    ulasan_kajian_risiko: '',
    tanggal_ulasan_kajian_risiko: '',
    dokumen_grc: '',
    tanggal_dokumen_grc: '',
    tanggal_tvv: '',
    status_persetujuan_tvv: '',
    dokumen_tvv: '',
    dokumen_skai: '',
    nomor_skai: '',
    tanggal_skai: '',
    nilai_skai: '',
    jumlah_paket: ''
})

const closeModal = () => {
    showDeleteModal.value = false
    prkToDelete.value = null
    showFormModal.value = false
    prkToEdit.value = null // Reset data edit
    form.reset()
}

// --- FUNGSI CREATE ---
const openCreateModal = () => {
    prkToEdit.value = null // Pastikan mode CREATE
    form.reset()
    showFormModal.value = true
}

const createPrk = () => {
    form.post(route('admin.prk.store'), {
        preserveScroll: true,
        onSuccess: () => {
            closeModal()
        }
    })
}

// --- FUNGSI EDIT ---
const openEditModal = prk => {
    prkToEdit.value = prk // Set data yang akan diedit

    // Isi form dengan data yang akan diedit
    form.tahun = prk.tahun
    form.prk = prk.prk
    form.fungsi = prk.fungsi
    form.uraian = prk.uraian
    form.status = prk.status
    form.ai_rupiah = prk.ai_rupiah
    form.user = prk.user
    form.dokumen_kkp = prk.dokumen_kkp
    form.tanggal_kkp = prk.tanggal_kkp
    form.ulasan_kajian_risiko = prk.ulasan_kajian_risiko
    form.tanggal_ulasan_kajian_risiko = prk.tanggal_ulasan_kajian_risiko
    form.dokumen_grc = prk.dokumen_grc
    form.tanggal_dokumen_grc = prk.tanggal_dokumen_grc
    form.tanggal_tvv = prk.tanggal_tvv
    form.status_persetujuan_tvv = prk.status_persetujuan_tvv
    form.dokumen_tvv = prk.dokumen_tvv
    form.dokumen_skai = prk.dokumen_skai
    form.nomor_skai = prk.nomor_skai
    form.tanggal_skai = prk.tanggal_skai
    form.nilai_skai = prk.nilai_skai
    form.jumlah_paket = prk.jumlah_paket

    showFormModal.value = true
}

const updatePrk = () => {
    if (!prkToEdit.value?.id) return

    // Gunakan PUT/PATCH untuk update
    form.put(route('admin.prk.update', { prk: prkToEdit.value.id }), {
        // Sesuaikan parameter route
        preserveScroll: true,
        onSuccess: () => {
            closeModal()
        }
    })
}

// --- FUNGSI DELETE ---
const confirmDeletePrk = prk => {
    prkToDelete.value = prk
    showDeleteModal.value = true
}

const deletePrk = () => {
    if (!prkToDelete.value?.id) return

    router.delete(route('admin.prk.destroy', { prk: prkToDelete.value.id }), {
        // Sesuaikan parameter route
        preserveScroll: true,
        onSuccess: () => {
            showDeleteModal.value = false
            prkToDelete.value = null
        },
        onError: () => {
            showDeleteModal.value = false
            prkToDelete.value = null
        }
    })
}

// --- DEFINISI KOLOM SESUAI PRK ---
const columns = [
    columnHelper.accessor('tahun', {
        header: 'Tahun',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('prk', {
        header: 'Nomor PRK',
        cell: info => h('span', info.getValue() || '-')
    }),
    // columnHelper.accessor('fungsi', {
    //     header: 'Fungsi',
    //     cell: info => h('span', info.getValue() || '-')
    // }),
    columnHelper.accessor('uraian', {
        header: 'Uraian',
        cell: info => h('span', info.getValue() || '-'),
        maxSize: 300
    }),
    // columnHelper.accessor('ai_rupiah', {
    //     header: 'AI (Rp)',
    //     cell: info => {
    //         const value = info.getValue()
    //         if (value === null) return h('span', '-')
    //         return h(
    //             'span',
    //             new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value)
    //         )
    //     }
    // }),
    // columnHelper.accessor('tanggal_skai', {
    //     header: 'Tgl SKAI',
    //     cell: info => h('span', info.getValue() || '-')
    // }),
    // columnHelper.accessor('status', {
    //     header: 'Status',
    //     cell: info => h('span', info.getValue() || '-')
    // }),
    // columnHelper.accessor('created_at', {
    //     header: 'Dibuat Pada',
    //     cell: info =>
    //         h(
    //             'span',
    //             new Date(info.getValue()).toLocaleString('id-ID', {
    //                 dateStyle: 'short',
    //                 timeStyle: 'short'
    //             })
    //         )
    // }),
    columnHelper.display({
        id: 'actions',
        header: 'Aksi',
        cell: info => {
            const prk = info.row.original
            if (!prk?.id) return null

            const showButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 cursor-pointer',
                    onClick: () => handleShow(prk),
                    type: 'button',
                    title: 'Lihat Detail'
                },
                [
                    h(
                        'svg',
                        {
                            class: 'w-4 h-4',
                            fill: 'none',
                            stroke: 'currentColor',
                            viewBox: '0 0 24 24',
                            xmlns: 'http://www.w3.org/2000/svg'
                        },
                        [
                            // Path Lingkaran Tengah (Pupil)
                            h('path', {
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': '2',
                                d: 'M15 12a3 3 0 11-6 0 3 3 0 016 0z'
                            }),
                            // Path Bentuk Mata
                            h('path', {
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': '2',
                                d: 'M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z'
                            })
                        ]
                    )
                ]
            )

            // --- TOMBOL EDIT BARU ---
            const editButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 cursor-pointer',
                    onClick: () => handleEdit(prk), // Ganti handleEdit
                    type: 'button',
                    title: 'Edit'
                },
                [
                    h(
                        'svg',
                        {
                            class: 'w-4 h-4',
                            fill: 'none',
                            stroke: 'currentColor',
                            viewBox: '0 0 24 24'
                        },
                        [
                            h('path', {
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': '2',
                                d: 'M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z'
                            })
                        ]
                    )
                ]
            )
            // --- AKHIR TOMBOL EDIT BARU ---

            const deleteButton = h(
                'button',
                {
                    class: 'p-2 text-red-400 hover:text-red-600 transition-colors rounded-lg hover:bg-red-50 cursor-pointer',
                    onClick: () => confirmDeletePrk(prk), // Ganti confirmDeleteHoliday
                    type: 'button',
                    title: 'Hapus'
                },
                [
                    h(
                        'svg',
                        {
                            class: 'w-4 h-4',
                            fill: 'none',
                            stroke: 'currentColor',
                            viewBox: '0 0 24 24'
                        },
                        [
                            h('path', {
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': '2',
                                d: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16'
                            })
                        ]
                    )
                ]
            )

            return h(
                'div',
                {
                    class: 'flex items-center gap-2 justify-end'
                },
                [showButton, editButton, deleteButton] // Tambahkan editButton di sini
            )
        }
    })
]

const handleShow = prk => {
    if (!prk?.id) return
    router.visit(route('admin.prk.show', { prk: prk.id }))
}

// Hapus fungsi handleEdit yang mengarahkan ke halaman baru (route('admin.prk.edit'))
// Jika Anda ingin menggunakan modal untuk edit, pastikan `openEditModal` dipanggil.
// Jika Anda ingin mengarahkan ke halaman edit, kembalikan fungsi `handleEdit` dan
// ganti `onClick` tombol edit di atas menjadi `onClick: () => handleEdit(prk)`.

watch(
    [pagination, filterTahun], // Watch keduanya sekaligus
    ([newPagination, newTahun]) => {
        loading.value = true
        router.get(
            route('admin.prk.index'),
            {
                page: newPagination.current_page,
                per_page: Number(newPagination.per_page),
                tahun: newTahun // Kirim ke backend
            },
            {
                preserveState: true,
                preserveScroll: true,
                onFinish: () => (loading.value = false)
            }
        )
    },
    { deep: true }
)

// Fungsi handleEdit yang diubah untuk membuka modal (jika Anda ingin menggunakan modal untuk edit):
// Jika Anda ingin route ke halaman edit:
const handleEdit = prk => {
    if (!prk?.id) return
    router.visit(route('admin.prk.edit', { prk: prk.id })) // Sesuaikan parameter route
}
</script>

<template>
    <Head title="Data PRK" />

    <main class="max-w-6xl mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader
                title="Data PRK"
                description="Daftar lengkap Program Rencana Kerja (PRK)."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data PRK' }
                ]">
                <template #actions>
                    <Link :href="route('admin.prk.create')" class="btn-primary btn-sm">Tambah</Link>
                </template>
            </PageHeader>

            <div
                class="p-6 border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
                    <div class="space-y-1">
                        <FormSelect
                            label="Filter Tahun"
                            v-model="filterTahun"
                            :options="[{ value: '', label: 'Semua Tahun' }, ...yearsOptions]" />
                    </div>

                    <div class="flex items-center pb-0">
                        <button
                            @click="resetFilters"
                            type="button"
                            class="btn-secondary btn-sm flex items-center gap-2"
                            v-if="filterTahun">
                            <svg
                                class="w-4 h-4"
                                fill="none"
                                stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    stroke-width="2"
                                    d="M6 18L18 6M6 6l12 12" />
                            </svg>
                            Reset Filter
                        </button>
                    </div>
                </div>
            </div>

            <div class="p-6 dark:bg-gray-900">
                <DataTable
                    :data="data.data"
                    :columns="columns"
                    :loading="loading"
                    :pagination="pagination"
                    :search-fields="['prk', 'uraian', 'user']"
                    empty-message="Belum ada data PRK"
                    empty-description="Data PRK akan muncul di sini setelah Anda menambahkannya"
                    export-file-name="data_prk"
                    @update:pagination="pagination = $event" />
            </div>
        </div>
    </main>

    <Modal :show="showDeleteModal" @close="closeModal" size="md">
        <template #title>
            <div class="flex items-center gap-2 text-red-600 dark:text-red-400">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
                Hapus PRK
            </div>
        </template>
        <template #default>
            <div class="space-y-4">
                <p class="text-sm text-gray-500 dark:text-gray-400">
                    Apakah Anda yakin ingin menghapus PRK ini? Tindakan ini tidak dapat dibatalkan.
                </p>
                <div
                    class="bg-amber-50 dark:bg-amber-900/20 p-4 rounded-lg border border-amber-200 dark:border-amber-800">
                    <div class="flex gap-2">
                        <svg
                            class="w-5 h-5 text-amber-600 dark:text-amber-400 flex-shrink-0"
                            fill="currentColor"
                            viewBox="0 0 20 20">
                            <path
                                fill-rule="evenodd"
                                d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                                clip-rule="evenodd" />
                        </svg>
                        <p class="text-sm text-amber-700 dark:text-amber-300">
                            Data PRK ini akan dihapus secara permanen dari sistem.
                        </p>
                    </div>
                </div>
            </div>
        </template>

        <template #footer>
            <div class="flex justify-end gap-3">
                <button
                    @click="closeModal"
                    type="button"
                    class="px-3 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 hover:text-gray-500 dark:hover:text-gray-400 cursor-pointer">
                    Batal
                </button>
                <button @click="deletePrk" type="button" class="btn-danger" :disabled="false">
                    Ya, hapus
                </button>
            </div>
        </template>
    </Modal>
</template>
