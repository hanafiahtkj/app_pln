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
        required: true // Data Pembayaran dari pagination
    }
})

const columnHelper = createColumnHelper()
const loading = ref(false)
const pagination = ref({
    current_page: props.data.current_page,
    per_page: Number(props.data.per_page),
    total: props.data.total
})

// --- STATE UNTUK DELETE PEMBAYARAN ---
const showDeleteModal = ref(false)
const pembayaranToDelete = ref(null) // Menyimpan data Pembayaran yang akan dihapus

const closeModal = () => {
    showDeleteModal.value = false
    pembayaranToDelete.value = null
}

// --- FUNGSI DELETE ---
const confirmDeletePembayaran = pembayaran => {
    pembayaranToDelete.value = pembayaran
    showDeleteModal.value = true
}

const deletePembayaran = () => {
    if (!pembayaranToDelete.value?.id) return

    // Menggunakan rute admin.pembayaran.destroy
    router.delete(route('admin.pembayaran.destroy', { pembayaran: pembayaranToDelete.value.id }), {
        preserveScroll: true,
        onSuccess: () => {
            showDeleteModal.value = false
            pembayaranToDelete.value = null
        },
        onError: () => {
            showDeleteModal.value = false
            pembayaranToDelete.value = null
        }
    })
}

// --- FUNGSI EDIT UNTUK NAVIGASI KE HALAMAN EDIT TERPISAH ---
const handleEdit = pembayaran => {
    if (!pembayaran?.id) return
    // Menggunakan rute admin.pembayaran.edit
    router.visit(route('admin.pembayaran.edit', { pembayaran: pembayaran.id }))
}

// Helper untuk render status Boolean (Checklist)
const renderBooleanStatus = value => {
    return h(
        'span',
        {
            class: `text-xs font-medium ${
                value ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'
            }`
        },
        value ? '✅ Ya' : '❌ Tidak'
    )
}

// Helper untuk render tanggal
const renderDate = dateString => {
    if (!dateString) return h('span', { class: 'text-xs text-gray-500' }, '-')

    // Format tanggal sederhana DD-MM-YYYY
    try {
        const date = new Date(dateString)
        const day = String(date.getDate()).padStart(2, '0')
        const month = String(date.getMonth() + 1).padStart(2, '0')
        const year = date.getFullYear()
        return h('span', `${day}-${month}-${year}`)
    } catch {
        return h('span', dateString)
    }
}

// Helper untuk render mata uang
const renderCurrency = value => {
    if (value === null || value === undefined || value === '') {
        return h('span', { class: 'text-xs text-gray-500' }, '-')
    }
    // Format IDR sederhana
    return h(
        'span',
        { class: 'text-sm font-semibold whitespace-nowrap' },
        new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(value)
    )
}

// --- DEFINISI KOLOM SESUAI PEMBAYARAN ---
const columns = [
    columnHelper.accessor('kontrak.nomor_perjanjian', {
        header: 'Nomor Kontrak',
        cell: info => {
            // Akses melalui relasi kontrak yang di eager load
            return h(
                'span',
                { class: 'font-medium' },
                info.row.original.kontrak?.nomor_perjanjian || '-'
            )
        }
    }),
    columnHelper.accessor('termin_pembayaran', {
        header: 'Termin',
        cell: info => h('span', info.getValue())
    }),
    columnHelper.accessor('nilai_tagihan', {
        header: 'Nilai Tagihan',
        cell: info => renderCurrency(info.getValue())
    }),
    columnHelper.accessor('realisasi_bayar', {
        header: 'Tgl. Bayar Vendor',
        cell: info => renderDate(info.getValue())
    }),
    columnHelper.accessor('realisasi_bayar_pajak', {
        header: 'Tgl. Bayar Pajak',
        cell: info => renderDate(info.getValue())
    }),
    columnHelper.accessor('lunas_vendor', {
        header: 'Lunas Vendor',
        cell: info => renderBooleanStatus(info.getValue()),
        enableSorting: false,
        size: 100
    }),
    columnHelper.accessor('lunas_pajak', {
        header: 'Lunas Pajak',
        cell: info => renderBooleanStatus(info.getValue()),
        enableSorting: false,
        size: 100
    }),
    columnHelper.accessor('keterangan', {
        header: 'Keterangan',
        cell: info =>
            h('span', { class: 'truncate max-w-xs block text-sm' }, info.getValue() || '-')
    }),
    columnHelper.display({
        id: 'actions',
        header: 'Aksi',
        cell: info => {
            const pembayaran = info.row.original
            if (!pembayaran?.id) return null

            const editButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 dark:hover:bg-blue-900/50 cursor-pointer',
                    onClick: () => handleEdit(pembayaran),
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
                    class: 'p-2 text-red-400 hover:text-red-600 transition-colors rounded-lg hover:bg-red-50 dark:hover:bg-red-900/50 cursor-pointer',
                    onClick: () => confirmDeletePembayaran(pembayaran),
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
            // Rute disesuaikan ke admin.pembayaran.index
            route('admin.pembayaran.index'),
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
    <Head title="Data Riwayat Pembayaran (Termin)" />

    <main class="max-w-7xl mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader
                title="Data Riwayat Pembayaran (Termin)"
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Pembayaran' }
                ]">
                <template #actions>
                    <Link :href="route('admin.pembayaran.create')" class="btn-primary btn-sm">
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
                    :search-fields="['kontrak.nomor_perjanjian', 'termin_pembayaran']"
                    empty-message="Belum ada data Pembayaran"
                    empty-description="Data pembayaran termin akan muncul di sini setelah Anda menambahkannya"
                    export-file-name="data_riwayat_pembayaran"
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
                Hapus Data Pembayaran
            </div>
        </template>
        <template #default>
            <div class="space-y-4">
                <p class="text-sm text-gray-500 dark:text-gray-400">
                    Apakah Anda yakin ingin menghapus data Pembayaran ini? Tindakan ini tidak dapat
                    dibatalkan.
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
                            Data riwayat pembayaran ini akan dihapus secara permanen dari sistem.
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
                    @click="deletePembayaran"
                    type="button"
                    class="btn-danger"
                    :disabled="false">
                    Ya, hapus
                </button>
            </div>
        </template>
    </Modal>
</template>
