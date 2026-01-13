<script setup>
import { Head, useForm, router, Link } from '@inertiajs/vue3'
import DataTable from '@/Components/Datatable.vue'
import Default from '@/Layouts/Default.vue'
import Modal from '@/Components/Modal.vue'
import { createColumnHelper } from '@tanstack/vue-table'
import { h, ref, watch } from 'vue'
import PageHeader from '@/Components/PageHeader.vue'
import FormSelect from '@/Components/FormSelect.vue'

defineOptions({
    layout: Default
})

const props = defineProps({
    data: {
        type: Object,
        required: true // Data Kontrak dari pagination
    },
    filters: Object
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

const handleShow = paket => {
    if (!paket?.id) return
    router.visit(route('admin.kontrak.show', { kontrak: paket.id }))
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
    columnHelper.accessor('uraian_paket', {
        header: 'Uraian Paket',
        cell: info => {
            return h('span', info.row.original.uraian_paket || '-')
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

            // 1. Tombol Detail (Selalu muncul)
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
                            viewBox: '0 0 24 24'
                        },
                        [
                            h('path', {
                                'stroke-linecap': 'round',
                                'stroke-linejoin': 'round',
                                'stroke-width': '2',
                                d: 'M15 12a3 3 0 11-6 0 3 3 0 016 0z'
                            }),
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

            // 2. Tombol Delete (Hanya muncul jika SUDAH diproses / memiliki data enjiniring)
            const deleteButton = paket.enjiniring?.rendan?.lakdan?.kontrak
                ? h(
                      'button',
                      {
                          class: 'p-2 text-red-400 hover:text-red-600 transition-colors rounded-lg hover:bg-red-50 cursor-pointer',
                          onClick: () =>
                              confirmDeleteKontrak(paket.enjiniring.rendan.lakdan.kontrak), // Pastikan nama fungsi sesuai logic delete Anda
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
                : null // Jika belum diproses, return null

            // 3. Gabungkan tombol ke dalam array
            const actionButtons = [showButton]
            if (deleteButton) actionButtons.push(deleteButton)

            return h('div', { class: 'flex items-center gap-2 justify-end' }, actionButtons)
        }
    })
]

// Inisialisasi state filter dari props atau default
const filterStatus = ref(props.filters?.status || 'belum_diproses')

const resetFilters = () => {
    filterStatus.value = 'belum_diproses'
}

// Update Watcher untuk menyertakan filter_status
watch(
    [pagination, filterStatus], // Pantau keduanya
    ([newPagination, newStatus]) => {
        loading.value = true
        router.get(
            route('admin.kontrak.index'),
            {
                page: newPagination.current_page,
                per_page: Number(newPagination.per_page),
                filter_status: newStatus // Kirim status filter ke server
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
    // 1. Cek Tahapan Awal (Sequential/Berurutan)
    if (!paket.enjiniring)
        return { label: 'Paket', color: 'bg-gray-100 text-gray-600 border-gray-200' }

    if (!paket.enjiniring.rendan)
        return { label: 'Enjiniring', color: 'bg-blue-100 text-blue-700 border-blue-200' }

    if (!paket.enjiniring.rendan.lakdan)
        return { label: 'Rendan', color: 'bg-indigo-100 text-indigo-700 border-indigo-200' }

    if (!paket.enjiniring.rendan.lakdan.kontrak)
        return { label: 'Lakdan', color: 'bg-purple-100 text-purple-700 border-purple-200' }

    // 2. Tahapan Kontrak & Paralel (PO & Pembayaran)
    const kontrak = paket.enjiniring.rendan.lakdan.kontrak
    const hasPO = !!kontrak.purchase_order
    const hasBayar = !!kontrak.pembayaran

    // Kondisi jika keduanya sudah ada
    if (hasPO && hasBayar) {
        return { label: 'PO & Bayar', color: 'bg-emerald-600 text-white border-emerald-700' }
    }

    // Kondisi paralel: salah satu sudah ada
    if (hasBayar) {
        return { label: 'Pembayaran', color: 'bg-emerald-500 text-white border-emerald-600' }
    }

    if (hasPO) {
        return { label: 'PO', color: 'bg-orange-100 text-orange-700 border-orange-200' }
    }

    // Default jika baru sampai tahap kontrak saja
    return { label: 'Kontrak', color: 'bg-pink-100 text-pink-700 border-pink-200' }
}
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
                <!-- <template #actions>
                    <Link :href="route('admin.kontrak.create')" class="btn-primary btn-sm">
                        Tambah
                    </Link>
                </template> -->
            </PageHeader>

            <div
                class="p-6 border-b border-gray-200 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/50">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 items-end">
                    <div class="space-y-1">
                        <FormSelect
                            label="Filter Status"
                            v-model="filterStatus"
                            :options="[
                                { value: 'belum_diproses', label: 'Menunggu Diproses' },
                                { value: 'proses', label: 'Sedang Diproses' }
                                // { value: 'semua', label: 'Semua Status' }
                            ]" />
                    </div>

                    <div class="flex items-center pb-0">
                        <button @click="resetFilters" type="button" class="btn-secondary btn-sm">
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
