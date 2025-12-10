<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class FileUploaderController extends Controller
{
    /**
     * Handle file upload request from the frontend (AJAX).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function uploadDigitalDocument(Request $request)
    {
        // 1. Validasi File
        $request->validate([
            'file' => 'required|file|mimes:pdf,jpg,jpeg,png|max:10240', // File field harus bernama 'file' di frontend
        ]);

        try {
            // 2. Simpan File
            $file = $request->file('file');
            // Simpan di storage/app/public/temp_uploads (sementara)
            $path = $file->store('temp_uploads', 'public');

            // 3. Kembalikan URL/Path File
            return response()->json([
                'success' => true,
                'path' => $path, // Path file di storage (e.g., temp_uploads/abc.pdf)
                'filename' => $file->getClientOriginalName(),
                'message' => 'File berhasil diunggah.'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengunggah file: ' . $e->getMessage()
            ], 500);
        }
    }
}
