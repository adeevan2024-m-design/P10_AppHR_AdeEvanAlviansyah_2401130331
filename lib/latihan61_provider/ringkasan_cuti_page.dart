import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/karyawan.dart';
import 'cuti_notifier.dart';

class RingkasanCutiPage extends StatelessWidget {
  const RingkasanCutiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final daftarNik = context.watch<CutiNotifier>().pengajuan;

    return LuxScaffold(
      appBar: LuxAppBar(title: Text('Ringkasan Cuti (${daftarNik.length})')),
      body: daftarNik.isEmpty
          ? const StateMessage(
              icon: Icons.event_available_rounded,
              title: 'Belum ada pengajuan cuti',
              message:
                  'Ajukan cuti pada daftar karyawan untuk melihat daftar ringkasan di halaman ini.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                FadeSlideIn(
                  child: StatTile(
                    value: '${daftarNik.length}',
                    label: 'Total pengajuan cuti',
                    icon: Icons.event_busy_rounded,
                  ),
                ),
                const SizedBox(height: 22),
                const FadeSlideIn(
                  index: 1,
                  child: SectionLabel('Karyawan Mengajukan'),
                ),
                const SizedBox(height: 14),
                for (var i = 0; i < daftarNik.length; i++) ...[
                  _PengajuanTile(nik: daftarNik[i]),
                  if (i < daftarNik.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _PengajuanTile extends StatelessWidget {
  const _PengajuanTile({required this.nik});

  final String nik;

  @override
  Widget build(BuildContext context) {
    final karyawan = cariKaryawan(nik);
    final textTheme = Theme.of(context).textTheme;

    return LuxCard(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      child: Row(
        children: [
          GoldAvatar(
            active: true,
            child: karyawan != null
                ? Text(karyawan.inisial)
                : const Icon(Icons.event_busy_rounded),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  karyawan?.nama ?? nik,
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
                    if (karyawan != null)
                      LuxChip(
                        label: karyawan.divisi,
                        color: divisiColor(karyawan.divisi),
                        dense: true,
                      ),
                    Text(
                      nik,
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
          IconButton(
            tooltip: 'Batalkan',
            icon: const Icon(Icons.close_rounded, color: AppColors.ruby),
            onPressed: () => context.read<CutiNotifier>().batalkan(nik),
          ),
        ],
      ),
    );
  }
}
