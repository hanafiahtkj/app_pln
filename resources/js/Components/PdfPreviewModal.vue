<script setup>
import Modal from '@/Components/Modal.vue'
import { computed } from 'vue'

const props = defineProps({
    // State untuk menampilkan/menyembunyikan modal
    show: {
        type: Boolean,
        default: false
    },
    // URL dokumen PDF yang akan ditampilkan
    pdfUrl: {
        type: String,
        default: null
    }
})

// Definisikan event 'close' untuk mengirim sinyal penutupan ke parent
const emit = defineEmits(['close'])

// isDownloadable sudah tidak diperlukan, tapi dipertahankan jika ada logika lain.
// Namun, karena tombol download dihapus, ini bisa diabaikan.
// const isDownloadable = computed(() => !!props.pdfUrl)

const close = () => {
    emit('close')
}
</script>

<template>
    <Modal :show="show" @close="close" size="5xl">
        <template #title>
            <div class="flex items-center gap-2 text-sky-600 dark:text-sky-400">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-4.414-4.414A1 1 0 0013.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                </svg>
                Pratinjau Dokumen Digital
            </div>
        </template>
        <template #default>
            <div v-if="pdfUrl" class="w-full h-[80vh]">
                <iframe
                    :src="pdfUrl + '#toolbar=0&navpanes=0&scrollbar=0&view=fit'"
                    class="w-full h-full border-none"
                    frameborder="0"
                    title="PDF Preview"
                    allowfullscreen></iframe>
            </div>
            <p v-else class="text-center text-red-500">Tidak dapat memuat dokumen.</p>
        </template>
    </Modal>
</template>
