<?php

namespace App\Exports;

use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use Maatwebsite\Excel\Concerns\WithStyles;
use PhpOffice\PhpSpreadsheet\Worksheet\Worksheet;
use PhpOffice\PhpSpreadsheet\Style\Alignment;
use PhpOffice\PhpSpreadsheet\Style\Border;
use PhpOffice\PhpSpreadsheet\Style\Fill;
use Carbon\Carbon;

class MonitoringExport implements FromCollection, WithHeadings, ShouldAutoSize, WithStyles
{
    protected $prks;

    public function __construct($prks)
    {
        $this->prks = $prks;
    }

    public function collection()
    {
        $data = collect();
        $no = 1;

        foreach ($this->prks as $prk) {
            foreach ($prk->pakets as $paket) {
                $fmt = fn($date) => $date ? Carbon::parse($date)->format('d/m/y') : '-';

                $enj = $paket->enjiniring;
                $ren = $enj?->rendan;
                $lak = $ren?->lakdan;
                $kon = $lak?->kontrak;
                $po  = $kon?->purchase_order;

                $nilaiPerjanjian = $kon?->nilai_perjanjian_ppn ?? 0;
                $totalTerbayar = 0;
                if ($kon && $kon->pembayaran) {
                    $totalTerbayar = $kon->pembayaran->where('lunas_vendor', true)->sum('nilai_bayar_vendor') +
                                     $kon->pembayaran->where('lunas_pajak', true)->sum('nilai_bayar_pajak');
                }
                $persenSerapan = $nilaiPerjanjian > 0 ? round(($totalTerbayar / $nilaiPerjanjian) * 100, 1) . '%' : '0%';

                // --- BARIS 1: TARGET / RENCANA ---
                $data->push([
                    'NO'            => $no,
                    'TAHUN'         => "#" . $prk->tahun,
                    'PRK'           => $prk->prk,
                    'REFERENSI'     => $prk->uraian ?? '-',
                    'URAIAN_PAKET'  => $paket->uraian_paket ?? '-',
                    'UNIT'          => $paket->unit?->name ?? 'N/A',
                    'KKP'           => '-',
                    'RISK'          => '-',
                    'GRC'           => '-',
                    'TVV'           => '-',
                    'SKAI'          => '-',
                    'SKKI'          => '-',
                    'SURVEY'        => $fmt($enj?->target_survey),
                    'TOR_HPE'       => $fmt($enj?->target_dokumen_enjiniring),
                    'RKS'           => $fmt($ren?->target_tanggal_rks),
                    'ND_USER'       => '-',
                    'HPS'           => $fmt($lak?->rencana_tanggal_hps),
                    'LELANG'        => $fmt($lak?->rencana_pengumuman_pengadaan),
                    'PENUNJUKAN'    => $fmt($lak?->rencana_penunjukan_penyedia),
                    'PERJANJIAN'    => $fmt($kon?->rencana_tanggal_perjanjian),
                    'BANK_GARANSI'  => $fmt($kon?->rencana_jaminan_pelaksanaan),
                    'EFEKTIF'       => '-',
                    'PO'            => $fmt($po?->rencana_po),
                    'MOS'           => $fmt($po?->rencana_mos),
                    'PROGRESS'      => '-', // Label target progress
                    'TERBAYAR'      => "Target: " . number_format($nilaiPerjanjian, 0, ',', '.')
                ]);

                // --- BARIS 2: REALISASI ---
                $data->push([
                    'NO'            => '',
                    'TAHUN'         => '',
                    'PRK'           => '',
                    'REFERENSI'     => '',
                    'URAIAN_PAKET'  => '',
                    'UNIT'          => '',
                    'KKP'           => $fmt($prk->tanggal_kkp),
                    'RISK'          => $fmt($prk->tanggal_ulasan_kajian_risiko),
                    'GRC'           => $fmt($prk->tanggal_dokumen_grc),
                    'TVV'           => $fmt($prk->tanggal_tvv),
                    'SKAI'          => $fmt($prk->tanggal_skai),
                    'SKKI'          => $fmt($paket->tanggal_skk),
                    'SURVEY'        => $fmt($enj?->realisasi_survey),
                    'TOR_HPE'       => $fmt($enj?->realisasi_dokumen_enjiniring),
                    'RKS'           => $fmt($ren?->tanggal_rks),
                    'ND_USER'       => $fmt($ren?->tanggal_nd_user),
                    'HPS'           => $fmt($lak?->realisasi_tanggal_hps),
                    'LELANG'        => $fmt($lak?->realisasi_pengumuman_pengadaan),
                    'PENUNJUKAN'    => $fmt($lak?->realisasi_penunjukan_penyedia),
                    'PERJANJIAN'    => $fmt($kon?->realisasi_tanggal_perjanjian),
                    'BANK_GARANSI'  => $fmt($kon?->realisasi_jaminan_pelaksanaan),
                    'EFEKTIF'       => $fmt($kon?->tanggal_efektif),
                    'PO'            => $fmt($po?->realisasi_po),
                    'MOS'           => $fmt($po?->realisasi_mos),
                    'PROGRESS'      => ($po?->progress_terkini ?? 0) . '%', // Realisasi progress
                    'TERBAYAR'      => number_format($totalTerbayar, 0, ',', '.') . " (" . $persenSerapan . ")"
                ]);

                $no++;
            }
        }
        return $data;
    }

    public function headings(): array
    {
        return [
            'NO', 'TAHUN', 'PRK', 'REFERENSI PRK', 'URAIAN PAKET', 'UNIT',
            'KKP', 'RISK', 'GRC', 'TVV', 'SKAI', 'SKKI', 'SURVEY',
            'TOR & HPE', 'RKS', 'ND USER', 'HPS', 'LELANG',
            'PENUNJUKAN', 'PERJANJIAN', 'BANK GARANSI', 'EFEKTIF KONTRAK',
            'PO', 'MOS', 'PROGRESS TERKINI', 'TERBAYAR TAHUN INI'
        ];
    }

    public function styles(Worksheet $sheet)
    {
        $lastRow = $sheet->getHighestRow();

        // Style Header (Kolom berakhir di Z karena kolom dikurangi)
        $sheet->getStyle('A1:Z1')->applyFromArray([
            'font' => ['bold' => true, 'color' => ['rgb' => 'FFFFFF']],
            'fill' => ['fillType' => Fill::FILL_SOLID, 'startColor' => ['rgb' => '1E40AF']],
            'alignment' => [
                'horizontal' => Alignment::HORIZONTAL_CENTER,
                'vertical' => Alignment::VERTICAL_CENTER
            ]
        ]);

        for ($i = 2; $i <= $lastRow; $i += 2) {
            $rT = $i;
            $rR = $i + 1;

            // Indeks Kolom Pewarnaan untuk Tanggal (M sampai X)
            $cols = ['M', 'N', 'O', 'Q', 'R', 'S', 'T', 'U', 'W', 'X'];
            foreach ($cols as $col) {
                $valT = $sheet->getCell($col . $rT)->getValue();
                $valR = $sheet->getCell($col . $rR)->getValue();

                if ($valT !== '-' && $valR !== '-') {
                    try {
                        $dT = Carbon::createFromFormat('d/m/y', $valT);
                        $dR = Carbon::createFromFormat('d/m/y', $valR);
                        $color = $dR->lte($dT) ? '10B981' : 'EF4444';
                        $sheet->getStyle($col . $rR)->getFont()->getColor()->setARGB($color);
                    } catch (\Exception $e) {}
                }
            }

            // Style Target (Baris Pertama Paket)
            $sheet->getStyle("G$rT:Y$rT")->getFont()->getColor()->setARGB('3B82F6');

            // Style Progress Terkini (Kolom Y)
            $sheet->getStyle("Y$rR")->getFont()->setBold(true);

            // Kolom Z (Terbayar) di Baris Realisasi dibuat Bold
            $sheet->getStyle("Z$rR")->getFont()->setBold(true);

            // Border Pemisah antar paket
            $sheet->getStyle("A$rR:Z$rR")->getBorders()->getBottom()->setBorderStyle(Border::BORDER_MEDIUM);

            // Zebra Striping
            if (($i / 2) % 2 == 0) {
                $sheet->getStyle("A$rT:Z$rR")->getFill()->setFillType(Fill::FILL_SOLID)->getStartColor()->setARGB('F9FAFB');
            }
        }

        $sheet->getStyle('A1:Z' . $lastRow)->getAlignment()->setVertical(Alignment::VERTICAL_CENTER);
        $sheet->getStyle('A1:A' . $lastRow)->getAlignment()->setHorizontal(Alignment::HORIZONTAL_CENTER);

        return [];
    }
}
