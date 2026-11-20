import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../models/karyawan.dart';
import 'gaji_detail_page.dart';
import 'gaji_providers.dart';

class PenggajianPage extends ConsumerWidget {
  const PenggajianPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daftarAsync = ref.watch(daftarGajiProvider);
    final penggajian = ref.watch(penggajianProvider);

    return LuxScaffold(
      appBar: LuxAppBar(
        title: Text('Penggajian (${penggajian.totalDiproses} diproses)'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            style: IconButton.styleFrom(foregroundColor: AppColors.gold),
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.read(penggajianProvider.notifier).reset();
              ref.invalidate(daftarGajiProvider); 
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: daftarAsync.when(
        loading: () => const LuxLoader(message: 'Memuat data penggajian...'),
        error: (error, stackTrace) => StateMessage(
          icon: Icons.error_outline_rounded,
          color: AppColors.ruby,
          title: 'Terjadi Kendala',
          message: pesanGalat(error),
          action: GoldButton(
            label: 'Coba Lagi',
            icon: Icons.refresh_rounded,
            onPressed: () => ref.invalidate(daftarGajiProvider),
          ),
        ),
        data: (daftar) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [
            FadeSlideIn(
              child: _RingkasanGaji(
                daftar: daftar,
                diproses: penggajian.totalDiproses,
              ),
            ),
            const SizedBox(height: 22),
            const FadeSlideIn(index: 1, child: SectionLabel('Daftar Gaji')),
            const SizedBox(height: 14),
            for (var i = 0; i < daftar.length; i++) ...[
              FadeSlideIn(
                index: i + 2,
                child: _GajiTile(
                  karyawan: daftar[i],
                  sudah: penggajian.diproses.contains(daftar[i].nik),
                ),
              ),
              if (i < daftar.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.96),
          border: Border(
            top: BorderSide(color: AppColors.gold.withValues(alpha: 0.22)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: GoldButton(
              label: penggajian.isProcessing ? 'Memproses...' : 'Proses Semua',
              icon: Icons.payments_rounded,
              loading: penggajian.isProcessing,
              onPressed: !daftarAsync.hasValue || penggajian.isProcessing
                  ? null
                  : () => ref
                        .read(penggajianProvider.notifier)
                        .prosesSemua(daftarAsync.requireValue),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingkasanGaji extends StatelessWidget {
  const _RingkasanGaji({required this.daftar, required this.diproses});

  final List<Karyawan> daftar;
  final int diproses;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final total = daftar.fold<double>(0, (jumlah, k) => jumlah + k.gajiPokok);
    final progres = daftar.isEmpty ? 0.0 : diproses / daftar.length;

    return LuxCard(
      highlight: true,
      radius: 24,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL GAJI POKOK',
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.muted,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          GoldText(formatRupiah(total), style: textTheme.headlineMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Progres pemrosesan',
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
              ),
              Text(
                '$diproses / ${daftar.length}',
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.goldLight,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progres),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => LinearProgressIndicator(
              value: value,
              minHeight: 6,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

class _GajiTile extends StatelessWidget {
  const _GajiTile({required this.karyawan, required this.sudah});

  final Karyawan karyawan;
  final bool sudah;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LuxCard(
      highlight: sudah,
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      onTap: () => Navigator.push(
        context,
        luxRoute(GajiDetailPage(nik: karyawan.nik)),
      ),
      child: Row(
        children: [
          GoldAvatar(
            active: sudah,
            child: Icon(sudah ? Icons.check_rounded : Icons.schedule_rounded),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  karyawan.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${karyawan.nik} · ${karyawan.divisi}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: divisiColor(karyawan.divisi),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatRupiah(karyawan.gajiPokok),
                  style: textTheme.titleSmall?.copyWith(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LuxChip(
                label: sudah ? 'Diproses' : 'Menunggu',
                color: sudah ? AppColors.emerald : AppColors.muted,
                dense: true,
              ),
              const SizedBox(height: 12),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.muted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
