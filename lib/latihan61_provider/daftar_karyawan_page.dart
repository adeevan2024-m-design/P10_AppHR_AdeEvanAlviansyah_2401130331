import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/karyawan.dart';
import 'badge_cuti.dart';
import 'cuti_notifier.dart';
import 'ringkasan_cuti_page.dart';

class DaftarKaryawanPage extends StatelessWidget {
  const DaftarKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LuxScaffold(
      appBar: LuxAppBar(
        title: const Text('Pengajuan Cuti'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Ringkasan cuti',
              style: IconButton.styleFrom(foregroundColor: AppColors.gold),
              icon: const BadgeCuti(),
              onPressed: () =>
                  Navigator.push(context, luxRoute(const RingkasanCutiPage())),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          const FadeSlideIn(child: _InfoBanner()),
          const SizedBox(height: 22),
          const FadeSlideIn(index: 1, child: SectionLabel('Daftar Karyawan')),
          const SizedBox(height: 14),
          for (var i = 0; i < dummyKaryawan.length; i++) ...[
            FadeSlideIn(
              index: i + 2,
              child: KaryawanCutiTile(karyawan: dummyKaryawan[i]),
            ),
            if (i < dummyKaryawan.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.gold.withValues(alpha: 0.07),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 20,
            color: AppColors.gold,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pilih karyawan untuk mengajukan cuti, lalu ketuk ikon pantai di kanan atas untuk melihat ringkasan.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.ivory.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KaryawanCutiTile extends StatelessWidget {
  const KaryawanCutiTile({super.key, required this.karyawan});

  final Karyawan karyawan;

  @override
  Widget build(BuildContext context) {
   
    final mengajukan = context.select<CutiNotifier, bool>(
      (n) => n.sudahMengajukan(karyawan.nik),
    );

    final textTheme = Theme.of(context).textTheme;
    const compact = Size(0, 40);
    const compactPadding = EdgeInsets.symmetric(horizontal: 14);

    return LuxCard(
      highlight: mengajukan,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          GoldAvatar(active: mengajukan, child: Text(karyawan.inisial)),
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
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    LuxChip(
                      label: karyawan.divisi,
                      color: divisiColor(karyawan.divisi),
                      dense: true,
                    ),
                    Text(
                      karyawan.nik,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.muted,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: mengajukan
                ? OutlinedButton.icon(
                    key: const ValueKey('batal'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: compact,
                      padding: compactPadding,
                    ),
                    onPressed: () =>
                        context.read<CutiNotifier>().batalkan(karyawan.nik),
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('Batal'),
                  )
                : FilledButton.icon(
                    key: const ValueKey('ajukan'),
                    style: FilledButton.styleFrom(
                      minimumSize: compact,
                      padding: compactPadding,
                    ),
                    onPressed: () =>
                        context.read<CutiNotifier>().ajukan(karyawan.nik),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Ajukan'),
                  ),
          ),
        ],
      ),
    );
  }
}
