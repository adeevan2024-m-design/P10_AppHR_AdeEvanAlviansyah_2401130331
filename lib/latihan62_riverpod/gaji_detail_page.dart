import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../models/karyawan.dart';
import 'gaji_providers.dart';

class GajiDetailPage extends ConsumerWidget {
  const GajiDetailPage({super.key, required this.nik});

  final String nik;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(gajiDetailProvider(nik));
    final sudah = ref.watch(
      penggajianProvider.select((s) => s.diproses.contains(nik)),
    );

    return LuxScaffold(
      appBar: LuxAppBar(title: Text('Detail Gaji $nik')),
      body: detailAsync.when(
        loading: () => const LuxLoader(message: 'Memuat detail gaji...'),
        error: (error, stackTrace) => StateMessage(
          icon: Icons.error_outline_rounded,
          color: AppColors.ruby,
          title: 'Data Tidak Tersedia',
          message: pesanGalat(error),
        ),
        data: (k) => _DetailBody(karyawan: k, sudah: sudah),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.karyawan, required this.sudah});

  final Karyawan karyawan;
  final bool sudah;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final warnaDivisi = divisiColor(karyawan.divisi);
    final warnaStatus = sudah ? AppColors.emerald : AppColors.muted;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        FadeSlideIn(
          child: LuxCard(
            highlight: true,
            radius: 26,
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  GoldAvatar(
                    size: 88,
                    active: sudah,
                    child: Text(karyawan.inisial),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    karyawan.nama,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      LuxChip(
                        label: karyawan.divisi,
                        color: warnaDivisi,
                        icon: Icons.apartment_rounded,
                      ),
                      LuxChip(
                        label: 'NIK ${karyawan.nik}',
                        color: AppColors.muted,
                        icon: Icons.badge_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        FadeSlideIn(
          index: 1,
          child: LuxCard(
            radius: 24,
            padding: const EdgeInsets.all(22),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GAJI POKOK',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.muted,
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GoldText(
                    formatRupiah(karyawan.gajiPokok),
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        const FadeSlideIn(index: 2, child: SectionLabel('Rincian')),
        const SizedBox(height: 14),
        FadeSlideIn(
          index: 3,
          child: LuxCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _DetailRowItem(
                  label: 'Nama Karyawan',
                  value: karyawan.nama,
                  icon: Icons.person_outline_rounded,
                ),
                const Divider(indent: 16, endIndent: 16),
                _DetailRowItem(
                  label: 'Divisi',
                  value: karyawan.divisi,
                  icon: Icons.apartment_rounded,
                  color: warnaDivisi,
                ),
                const Divider(indent: 16, endIndent: 16),
                _DetailRowItem(
                  label: 'Status',
                  value: sudah ? 'Sudah diproses' : 'Belum diproses',
                  icon: sudah
                      ? Icons.verified_rounded
                      : Icons.pending_actions_rounded,
                  color: warnaStatus,
                  valueColor: warnaStatus,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailRowItem extends StatelessWidget {
  const _DetailRowItem({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.gold,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(color: AppColors.muted),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
