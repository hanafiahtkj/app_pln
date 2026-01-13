<script setup>
import { Head, Link } from '@inertiajs/vue3'
import Default from '@/Layouts/Default.vue'
import PageHeader from '@/Components/PageHeader.vue'
import PdfPreviewModal from '@/Components/PdfPreviewModal.vue'
import { h, ref, watch } from 'vue'
import PaketCard from '../PaketCard.vue'
import PrkCard from '../PrkCard.vue'
import EnjiniringCard from '../EnjiniringCard.vue'
import RendanCard from '../RendanCard.vue'
import LakdanCard from '../LakdanCard.vue'
import KontrakCard from '../KontrakCard.vue'
import PurchaseOrderCard from '../PurchaseOrderCard.vue'
import PembayaranCard from '../PembayaranCard.vue'

defineOptions({ layout: Default })
const props = defineProps({ data: { type: Object, required: true } })
const paket = props.data

const showPdfModal = ref(false)
const pdfUrl = ref(null)

const closeModal = () => {
    showPdfModal.value = false
    pdfUrl.value = null
}

// --- FUNGSI PDF PREVIEW ---
const openPdfPreview = path => {
    if (!path) return
    pdfUrl.value = path
    showPdfModal.value = true
}
</script>

<template>
    <Head :title="`Detail Proyek - ${paket.nomor_skk || paket.id}`" />

    <main class="max-w-6xl mx-auto space-y-8">
        <div class="container-border overflow-hidden">
            <PageHeader
                :title="`Detail Paket: ${props.data.id}`"
                description="Detail lengkap Paket Pekerjaan."
                :breadcrumbs="[
                    { label: 'Dashboard', href: route('dashboard') },
                    { label: 'Data Paket', href: route('admin.rendan.index') },
                    { label: 'Detail' }
                ]">
                <template #actions>
                    <Link :href="route('admin.rendan.index')" class="btn-primary btn-sm">
                        Kembali ke Daftar
                    </Link>
                </template>
            </PageHeader>

            <div class="p-6 md:p-8 relative">
                <div
                    class="absolute left-10 md:left-16 top-14 bottom-14 w-[1px] bg-gradient-to-b from-slate-200 via-slate-100 to-transparent dark:from-slate-700 dark:via-slate-800 hidden md:block"></div>

                <div class="space-y-12">
                    <PrkCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <PaketCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <EnjiniringCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <RendanCard :hasAccess="true" :paket="paket" @openPdfPreview="openPdfPreview" />
                    <!-- <LakdanCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <KontrakCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <PurchaseOrderCard :paket="paket" @openPdfPreview="openPdfPreview" />
                    <PembayaranCard :paket="paket" @openPdfPreview="openPdfPreview" /> -->
                </div>
            </div>
        </div>
    </main>

    <PdfPreviewModal :show="showPdfModal" :pdf-url="pdfUrl" @close="closeModal" />
</template>

<style scoped>
a {
    cursor: pointer;
}
</style>
