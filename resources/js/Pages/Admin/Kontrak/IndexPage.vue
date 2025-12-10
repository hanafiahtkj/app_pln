<script setup>
import { Head, useForm, router, Link } from '@inertiajs/vue3'
import DataTable from '@/Components/Datatable.vue'
import Default from '@/Layouts/Default.vue'
import Modal from '@/Components/Modal.vue'
import { createColumnHelper } from '@tanstack/vue-table'
import { h, ref, watch } from 'vue'
import PageHeader from '@/Components/PageHeader.vue'

defineOptions({
    layout: Default
})

const props = defineProps({
    data: {
        type: Object,
        required: true // Data Kontrak dari pagination
    }
})

const columnHelper = createColumnHelper()
const loading = ref(false)
const pagination = ref({
    current_page: props.data.current_page,
    per_page: Number(props.data.per_page),
    total: props.data.total
})

// --- STATE UNTUK DELETE KONTRAK ---
const showDeleteModal = ref(false)
const kontrakToDelete = ref(null) // Menyimpan data Kontrak yang akan dihapus

const closeModal = () => {
    showDeleteModal.value = false
    kontrakToDelete.value = null
}

// --- FUNGSI DELETE ---
const confirmDeleteKontrak = kontrak => {
    kontrakToDelete.value = kontrak
    showDeleteModal.value = true
}

const deleteKontrak = () => {
    if (!kontrakToDelete.value?.id) return

    // Menggunakan rute admin.kontrak.destroy
    router.delete(route('admin.kontrak.destroy', { kontrak: kontrakToDelete.value.id }), {
        preserveScroll: true,
        onSuccess: () => {
            showDeleteModal.value = false
            kontrakToDelete.value = null
        },
        onError: () => {
            showDeleteModal.value = false
            kontrakToDelete.value = null
        }
    })
}

// --- FUNGSI EDIT UNTUK NAVIGASI KE HALAMAN EDIT TERPISAH ---
const handleEdit = kontrak => {
    if (!kontrak?.id) return
    // Menggunakan rute admin.kontrak.edit
    router.visit(route('admin.kontrak.edit', { kontrak: kontrak.id }))
}

// Helper untuk menampilkan status file
const renderFileStatus = path => {
    if (path) {
        // Nama file diambil dari path, atau bisa ditambahkan kolom nama file di DB jika diperlukan
        // Di sini kita asumsikan kolom name juga ada di DB jika diperlukan nama aslinya.
        const fileName = path.split('/').pop()
        return h(
            'a',
            {
                href: `/storage/${path}`,
                target: '_blank',
                class: 'text-sm font-medium text-green-600 dark:text-green-400 hover:underline'
            },
            ['✅ Lihat File']
        )
    }
    return h('span', { class: 'text-xs text-gray-500' }, 'Tidak Ada File')
}

// Helper untuk format nilai mata uang
const formatCurrency = value => {
    if (value === null || value === undefined) return '-'
    // Menggunakan Intl.NumberFormat untuk format mata uang Rupiah
    return `Rp ${Number(value).toLocaleString('id-ID', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 2
    })}`
}

// --- DEFINISI KOLOM SESUAI KONTRAK ---
const columns = [
    columnHelper.accessor('nomor_perjanjian', {
        header: 'Nomor Kontrak',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('lakdan.nomor_hps', {
        header: 'Nomor HPS Terkait',
        cell: info => {
            // Akses melalui relasi lakdan yang di eager load
            return h('span', info.row.original.lakdan?.nomor_hps || '-')
        }
    }),
    columnHelper.accessor('penyedia_barang_jasa', {
        header: 'Penyedia Barang/Jasa',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('nilai_perjanjian_ppn', {
        header: 'Nilai Kontrak (PPN)',
        cell: info => h('span', formatCurrency(info.getValue()))
    }),
    columnHelper.accessor('realisasi_tanggal_perjanjian', {
        header: 'Tgl. Realisasi Kontrak',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('dokumen_perjanjian', {
        header: 'Dokumen Kontrak',
        cell: info => renderFileStatus(info.getValue())
    }),
    columnHelper.accessor('status_proses', {
        header: 'Status Proses',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('masa_pelaksanaan', {
        header: 'Masa Pelaksanaan (Hari)',
        cell: info => h('span', info.getValue() !== null ? `${info.getValue()} Hari` : '-')
    }),
    columnHelper.accessor('efisiensi_thd_hps', {
        header: 'Efisiensi vs HPS',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('dokumen_jaminan_pelaksanaan', {
        header: 'Dokumen Jaminan',
        cell: info => renderFileStatus(info.getValue())
    }),
    columnHelper.display({
        id: 'actions',
        header: 'Aksi',
        cell: info => {
            const kontrak = info.row.original
            if (!kontrak?.id) return null

            const editButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 cursor-pointer',
                    onClick: () => handleEdit(kontrak),
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

            const deleteButton = h(
                'button',
                {
                    class: 'p-2 text-red-400 hover:text-red-600 transition-colors rounded-lg hover:bg-red-50 cursor-pointer',
                    onClick: () => confirmDeleteKontrak(kontrak),
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
                [editButton, deleteButton]
            )
        }
    })
]

watch(
    pagination,
    newPagination => {
        loading.value = true
        router.get(
            // Rute disesuaikan ke admin.kontrak.index
            route('admin.kontrak.index'),
            {
                page: newPagination.current_page,
                per_page: Number(newPagination.per_page)
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
</script>

<template>
    <Head title="Data Kontrak" />

    <main class="max-w-7xl mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader
                title="Data Kontrak"
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Kontrak' }
                ]">
                <template #actions>
                    <Link :href="route('admin.kontrak.create')" class="btn-primary btn-sm">
                        Tambah
                    </Link>
                </template>
            </PageHeader>

            <div class="p-6 dark:bg-gray-900">
                <DataTable
                    :data="data.data"
                    :columns="columns"
                    :loading="loading"
                    :pagination="pagination"
                    :search-fields="['nomor_perjanjian', 'penyedia_barang_jasa']"
                    empty-message="Belum ada data Kontrak"
                    empty-description="Data Kontrak akan muncul di sini setelah Anda menambahkannya"
                    export-file-name="data_kontrak"
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
                Hapus Data Kontrak
            </div>
        </template>
        <template #default>
            <div class="space-y-4">
                <p class="text-sm text-gray-500 dark:text-gray-400">
                    Apakah Anda yakin ingin menghapus data Kontrak ini? Tindakan ini tidak dapat
                    dibatalkan dan **akan menghapus file dokumen Kontrak dan Jaminan Pelaksanaan
                    terkait**.
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
                            Data Kontrak ini akan dihapus secara permanen dari sistem.
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
                <button @click="deleteKontrak" type="button" class="btn-danger" :disabled="false">
                    Ya, hapus
                </button>
            </div>
        </template>
    </Modal>
</template>
