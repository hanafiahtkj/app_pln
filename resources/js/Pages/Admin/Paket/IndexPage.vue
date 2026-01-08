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
    }
    // Asumsi: 'prks' (list PRK) juga dikirim dari controller jika diperlukan
})

const columnHelper = createColumnHelper()
const loading = ref(false)
const pagination = ref({
    current_page: props.data.current_page,
    per_page: Number(props.data.per_page),
    total: props.data.total
})

// --- STATE UNTUK EDIT/DELETE PAKET ---
const showFormModal = ref(false)
const paketToEdit = ref(null) // Menyimpan data Paket yang akan diedit

const showDeleteModal = ref(false)
const paketToDelete = ref(null)

// --- MEMODIFIKASI useForm SESUAI SKEMA PAKET ---
const form = useForm({
    prk_id: null,
    tahun: '',

    // SKK Fields
    dokumen_skk: '', // Jika menggunakan file upload async, field ini terisi dari path lama/baru
    nomor_skk: '',
    tanggal_skk: '',
    nilai_skk: '',
    status_paket: '',

    // File upload (khusus untuk mode modal create/edit, jika digunakan)
    dokumen_skk_path: null,
    dokumen_skk_name: null
})

const closeModal = () => {
    showDeleteModal.value = false
    paketToDelete.value = null
    showFormModal.value = false
    paketToEdit.value = null // Reset data edit
    form.reset()
}

// --- FUNGSI CREATE (jika menggunakan modal) ---
const openCreateModal = () => {
    paketToEdit.value = null // Pastikan mode CREATE
    form.reset()
    showFormModal.value = true
}

const createPaket = () => {
    form.post(route('admin.paket.store'), {
        preserveScroll: true,
        onSuccess: () => {
            closeModal()
        }
    })
}

// --- FUNGSI EDIT (jika menggunakan modal) ---
const openEditModal = paket => {
    paketToEdit.value = paket // Set data yang akan diedit

    // Isi form dengan data yang akan diedit
    form.prk_id = paket.prk_id
    form.tahun = paket.tahun
    form.nomor_skk = paket.nomor_skk
    form.tanggal_skk = paket.tanggal_skk // Asumsi format YYYY-MM-DD
    form.nilai_skk = paket.nilai_skk
    form.status_paket = paket.status_paket

    // Asumsi dokumen_skk adalah path file yang ada
    form.dokumen_skk = paket.dokumen_skk

    showFormModal.value = true
}

const updatePaket = () => {
    if (!paketToEdit.value?.id) return

    // Gunakan PUT/PATCH untuk update
    form.put(route('admin.paket.update', { paket: paketToEdit.value.id }), {
        preserveScroll: true,
        onSuccess: () => {
            closeModal()
        }
    })
}

// --- FUNGSI DELETE ---
const confirmDeletePaket = paket => {
    paketToDelete.value = paket
    showDeleteModal.value = true
}

const deletePaket = () => {
    if (!paketToDelete.value?.id) return

    router.delete(route('admin.paket.destroy', { paket: paketToDelete.value.id }), {
        preserveScroll: true,
        onSuccess: () => {
            showDeleteModal.value = false
            paketToDelete.value = null
        },
        onError: () => {
            showDeleteModal.value = false
            paketToDelete.value = null
        }
    })
}

// --- DEFINISI KOLOM SESUAI PAKET ---
const columns = [
    columnHelper.accessor('tahun', {
        header: 'Tahun',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('prk.prk', {
        header: 'PRK',
        cell: info => {
            return h('span', info.row.original.prk?.prk || '-')
        }
    }),
    columnHelper.accessor('prk.uraian', {
        header: 'Uraian',
        cell: info => {
            return h('span', info.row.original.prk?.uraian || '-')
        }
    }),
    columnHelper.accessor('nomor_skk', {
        header: 'Nomor SKK',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('nilai_skk', {
        header: 'Nilai SKK (Rp)',
        cell: info => {
            const value = info.getValue()
            if (value === null) return h('span', '-')
            return h(
                'span',
                new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value)
            )
        }
    }),
    columnHelper.accessor('tanggal_skk', {
        header: 'Tgl SKK',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.accessor('status_paket', {
        header: 'Status',
        cell: info => h('span', info.getValue() || '-')
    }),
    columnHelper.display({
        id: 'progress_tracker',
        header: 'Progres',
        cell: info => {
            const status = getProgressStatus(info.row.original)
            return h('div', { class: 'flex items-center' }, [
                h(
                    'span',
                    {
                        class: `px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter border ${status.color}`
                    },
                    status.label
                )
            ])
        }
    }),
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
    columnHelper.display({
        id: 'actions',
        header: 'Aksi',
        cell: info => {
            const paket = info.row.original
            if (!paket?.id) return null

            const showButton = h(
                'button',
                {
                    class: 'p-2 text-blue-400 hover:text-blue-600 transition-colors rounded-lg hover:bg-blue-50 cursor-pointer',
                    onClick: () => handleShow(paket),
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
            // --- AKHIR TOMBOL EDIT BARU ---

            const deleteButton = h(
                'button',
                {
                    class: 'p-2 text-red-400 hover:text-red-600 transition-colors rounded-lg hover:bg-red-50 cursor-pointer',
                    onClick: () => confirmDeletePaket(paket),
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
                [showButton, deleteButton]
            )
        }
    })
]

// Fungsi handleEdit untuk navigasi ke halaman edit terpisah
const handleEdit = paket => {
    if (!paket?.id) return
    router.visit(route('admin.paket.edit', { paket: paket.id }))
}

const handleShow = paket => {
    if (!paket?.id) return
    router.visit(route('admin.paket.show', { paket: paket.id }))
}

watch(
    pagination,
    newPagination => {
        loading.value = true
        router.get(
            route('admin.paket.index'), // Rute disesuaikan
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

const getProgressStatus = paket => {
    // 1. Cek Enjiniring
    if (!paket.enjiniring)
        return { label: 'Paket', color: 'bg-gray-100 text-gray-600 border-gray-200' }

    // 2. Cek Rendan
    if (!paket.enjiniring.rendan)
        return { label: 'Enjiniring', color: 'bg-blue-100 text-blue-700 border-blue-200' }

    // 3. Cek Lakdan
    if (!paket.enjiniring.rendan.lakdan)
        return { label: 'Rendan', color: 'bg-indigo-100 text-indigo-700 border-indigo-200' }

    // 4. Cek Kontrak
    if (!paket.enjiniring.rendan.lakdan.kontrak)
        return { label: 'Lakdan', color: 'bg-purple-100 text-purple-700 border-purple-200' }

    const kontrak = paket.enjiniring.rendan.lakdan.kontrak

    // 5. Cek Purchase Order (PO)
    if (!kontrak.purchase_order)
        return { label: 'Kontrak', color: 'bg-pink-100 text-pink-700 border-pink-200' }

    // 6. Cek Pembayaran (Tahap Akhir)
    if (kontrak.pembayaran) {
        return {
            label: 'Pembayaran',
            color: 'bg-emerald-500 text-white border-emerald-600'
        }
    }

    // Jika sudah ada PO tapi belum ada pembayaran
    return { label: 'PO', color: 'bg-orange-100 text-orange-700 border-orange-200' }
}
</script>

<template>
    <Head title="Data Paket" />

    <main class="max-w-6xl mx-auto" role="main">
        <div class="container-border overflow-hidden">
            <PageHeader
                title="Data Paket"
                description="Daftar Paket Pekerjaan yang terkait dengan PRK"
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Paket' }
                ]">
                <template #actions>
                    <Link :href="route('admin.paket.create')" class="btn-primary btn-sm">
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
                    :search-fields="['nomor_skk', 'prk_id']"
                    empty-message="Belum ada data Paket"
                    empty-description="Data Paket akan muncul di sini setelah Anda menambahkannya"
                    export-file-name="data_paket"
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
                Hapus Paket
            </div>
        </template>
        <template #default>
            <div class="space-y-4">
                <p class="text-sm text-gray-500 dark:text-gray-400">
                    Apakah Anda yakin ingin menghapus Paket ini? Tindakan ini tidak dapat
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
                            Data Paket ini akan dihapus secara permanen dari sistem.
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
                <button @click="deletePaket" type="button" class="btn-danger" :disabled="false">
                    Ya, hapus
                </button>
            </div>
        </template>
    </Modal>
</template>
