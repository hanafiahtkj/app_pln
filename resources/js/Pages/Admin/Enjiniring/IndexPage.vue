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
        required: true // Data dari PaketEnjiniring::paginate()
    }
})

const columnHelper = createColumnHelper()
const loading = ref(false)
const pagination = ref({
    current_page: props.data.current_page,
    per_page: Number(props.data.per_page),
    total: props.data.total
})

// --- STATE UNTUK DELETE PAKET ENJINIRING ---
const showDeleteModal = ref(false)
const enjiniringToDelete = ref(null) // Menyimpan data yang akan dihapus

const closeModal = () => {
    showDeleteModal.value = false
    enjiniringToDelete.value = null
}

// --- FUNGSI DELETE ---
const confirmDeleteEnjiniring = enjiniring => {
    enjiniringToDelete.value = enjiniring
    showDeleteModal.value = true
}

const deleteEnjiniring = () => {
    if (!enjiniringToDelete.value?.id) return

    router.delete(route('admin.enjiniring.destroy', { enjiniring: enjiniringToDelete.value.id }), {
        preserveScroll: true,
        onSuccess: () => closeModal(),
        onError: () => closeModal()
    })
}

// Helper untuk tombol aksi
const handleEdit = enjiniring => {
    if (!enjiniring?.id) return
    router.visit(route('admin.enjiniring.edit', { id: enjiniring.id }))
}

// --- DEFINISI KOLOM SESUAI PAKET ---
const columns = [
    // 1. TAHUN (dari Paket)
    columnHelper.accessor('paket.tahun', {
        header: 'Tahun',
        // Menggunakan optional chaining (?.) untuk menghindari error jika 'paket' adalah null
        cell: info => h('span', info.row.original.paket?.tahun || '-')
    }),

    // 2. NOMOR PRK (dari Paket -> PRK)
    columnHelper.accessor('paket.prk.prk', {
        header: 'Nomor PRK',
        cell: info => {
            // Mengakses melalui paket?.prk?.prk
            return h('span', info.row.original.paket?.prk?.prk || '-')
        }
    }),

    // 3. NOMOR SKK (dari Paket)
    columnHelper.accessor('paket.nomor_skk', {
        header: 'Nomor SKK',
        cell: info => h('span', info.row.original.paket?.nomor_skk || '-')
    }),

    // 4. NILAI SKK (dari Paket)
    columnHelper.accessor('paket.nilai_skk', {
        header: 'Nilai SKK (Rp)',
        cell: info => {
            const value = info.row.original.paket?.nilai_skk // Akses melalui paket
            if (value === null || value === undefined) return h('span', '-')
            return h(
                'span',
                new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value)
            )
        }
    }),

    // 5. TGL SKK (dari Paket)
    columnHelper.accessor('paket.tanggal_skk', {
        header: 'Tgl SKK',
        cell: info => h('span', info.row.original.paket?.tanggal_skk || '-') // Akses melalui paket
    }),

    // 6. STATUS PAKET (dari Paket)
    columnHelper.accessor('paket.status_paket', {
        header: 'Status',
        cell: info => h('span', info.row.original.paket?.status_paket || '-') // Akses melalui paket
    }),

    // 7. DIBUAT PADA (dari Enjiniring itu sendiri, tidak berubah)
    columnHelper.accessor('created_at', {
        header: 'Dibuat Pada',
        cell: info =>
            h(
                'span',
                new Date(info.getValue()).toLocaleString('id-ID', {
                    dateStyle: 'short',
                    timeStyle: 'short'
                })
            )
    }),

    // 8. AKSI (Aksi dilakukan pada objek Enjiniring)
    columnHelper.display({
        id: 'actions',
        header: 'Aksi',
        cell: info => {
            // Objek yang dikirim adalah objek Enjiniring, bukan Paket.
            const enjiniring = info.row.original
            // Gunakan id Enjiniring untuk Edit/Hapus
            if (!enjiniring?.id) return null

            // --- TOMBOL EDIT BARU ---
            const editButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 cursor-pointer',
                    onClick: () => handleEdit(enjiniring), // Kirim objek Enjiniring
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
                    onClick: () => confirmDeleteEnjiniring(enjiniring), // Ubah ke confirmDeleteEnjiniring
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

// --- WATCHER UNTUK PAGINASI ---
watch(
    pagination,
    newPagination => {
        loading.value = true
        router.get(
            route('admin.enjiniring.index'),
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
    <Head title="Data Enjiniring" />

    <main class="max-w-7xl mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader
                title="Data Enjiniring"
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Enjiniring' }
                ]">
                <template #actions>
                    <Link :href="route('admin.enjiniring.create')" class="btn-primary btn-sm">
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
                    :search-fields="['prk.prk']"
                    empty-message="Belum ada data Enjiniring"
                    empty-description="Data Enjiniring akan muncul di sini setelah Anda menambahkannya"
                    export-file-name="data_enjiniring"
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
                Hapus Data Enjiniring
            </div>
        </template>
        <template #default>
            <div class="space-y-4">
                <p class="text-sm text-gray-500 dark:text-gray-400">
                    Apakah Anda yakin ingin menghapus data Enjiniring terkait PRK:
                    <span class="font-semibold text-gray-700 dark:text-gray-200">
                        {{ enjiniringToDelete?.prk?.prk || '-' }}
                    </span>
                    ? Tindakan ini tidak dapat dibatalkan.
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
                            Data ini akan dihapus secara permanen dari sistem.
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
                <button
                    @click="deleteEnjiniring"
                    type="button"
                    class="btn-danger"
                    :disabled="false">
                    Ya, hapus
                </button>
            </div>
        </template>
    </Modal>
</template>
