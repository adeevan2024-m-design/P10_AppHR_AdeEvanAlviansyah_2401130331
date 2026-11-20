import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';
import 'latihan61_provider/daftar_karyawan_page.dart';
import 'latihan62_riverpod/penggajian_page.dart';
import 'latihan63_bloc/login_bloc_page.dart';
import 'models/karyawan.dart';

class _Modul {
  const _Modul({
    required this.icon,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.halaman,
  });

  final IconData icon;
  final String badge;
  final String title;
  final String subtitle;
  final Color accent;
  final Widget Function() halaman;
}

final List<_Modul> _daftarModul = [
  _Modul(
    icon: Icons.beach_access_rounded,
    badge: 'Latihan 6.1',
    title: 'Pengajuan Cuti (Provider)',
    subtitle: 'Ajukan dan tinjau cuti karyawan dengan Provider.',
    accent: AppColors.emerald,
    halaman: () => const DaftarKaryawanPage(),
  ),
  _Modul(
    icon: Icons.payments_rounded,
    badge: 'Latihan 6.2',
    title: 'Penggajian (Riverpod 3)',
    subtitle: 'Lihat ringkasan gaji karyawan dengan Riverpod.',
    accent: AppColors.sapphire,
    halaman: () => const PenggajianPage(),
  ),
  _Modul(
    icon: Icons.lock_person_rounded,
    badge: 'Latihan 6.3',
    title: 'Autentikasi Login (Cubit)',
    subtitle: 'Pelajari alur autentikasi menggunakan Cubit.',
    accent: AppColors.copper,
    halaman: () => const LoginBlocPage(),
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _buka(BuildContext context, Widget page) {
    Navigator.push(context, luxRoute(page));
  }

  @override
  Widget build(BuildContext context) {
    final jumlahDivisi = dummyKaryawan.map((k) => k.divisi).toSet().length;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: LuxScaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 900
                  ? 36.0
                  : constraints.maxWidth >= 600
                      ? 28.0
                      : 18.0;

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FadeSlideIn(child: _Header()),
                        const SizedBox(height: 28),
                        const FadeSlideIn(index: 1, child: _HeroCard()),
                        const SizedBox(height: 20),
                        FadeSlideIn(
                          index: 2,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              const gap = 12.0;
                              final width =
                                  (constraints.maxWidth - gap * 2) / 3;

                              return Wrap(
                                spacing: gap,
                                runSpacing: gap,
                                children: [
                                  SizedBox(
                                    width: width,
                                    child: StatTile(
                                      value: '${_daftarModul.length}',
                                      label: 'Modul',
                                      icon: Icons.widgets_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: StatTile(
                                      value: '${dummyKaryawan.length}',
                                      label: 'Karyawan',
                                      icon: Icons.groups_rounded,
                                      color: AppColors.emerald,
                                    ),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: StatTile(
                                      value: '$jumlahDivisi',
                                      label: 'Divisi',
                                      icon: Icons.apartment_rounded,
                                      color: AppColors.sapphire,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Jelajahi modul',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pilih latihan untuk mulai belajar.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.muted),
                        ),
                        const SizedBox(height: 16),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = constraints.maxWidth >= 900
                                ? 3
                                : constraints.maxWidth >= 600
                                    ? 2
                                    : 1;
                            const gap = 16.0;
                            final width =
                                (constraints.maxWidth - gap * (columns - 1)) /
                                    columns;

                            return Wrap(
                              spacing: gap,
                              runSpacing: gap,
                              children: [
                                for (var i = 0; i < _daftarModul.length; i++)
                                  SizedBox(
                                    width: width,
                                    child: FadeSlideIn(
                                      index: 3 + i,
                                      child: _ModulCard(
                                        modul: _daftarModul[i],
                                        onTap: () => _buka(
                                          context,
                                          _daftarModul[i].halaman(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 28),
                        const _Footer(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.workspaces_rounded,
            color: AppColors.gold,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'APLIKASI HR',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Ade Evan Alviansyah',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        if (MediaQuery.sizeOf(context).width >= 520)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.outline),
            ),
            child: Text(
              'MANAJEMEN SDM',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return LuxCard(
      highlight: true,
      radius: 20,
      padding: const EdgeInsets.all(22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textTheme = Theme.of(context).textTheme;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LuxChip(
                label: 'MANAJEMEN STATE FLUTTER',
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 14),
              Text(
                'Kelola tim lebih mudah',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Jelajahi latihan Provider, Riverpod, dan Cubit dalam satu aplikasi.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
            ],
          );
          final illustration = Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.groups_2_rounded,
              color: AppColors.gold,
              size: 44,
            ),
          );

          if (constraints.maxWidth >= 520) {
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 24),
                illustration,
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: 16),
              Align(alignment: Alignment.centerRight, child: illustration),
            ],
          );
        },
      ),
    );
  }
}

class _ModulCard extends StatelessWidget {
  const _ModulCard({required this.modul, required this.onTap});

  final _Modul modul;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final accent = modul.accent;

    return LuxCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: accent.withValues(alpha: 0.08),
            ),
            child: Icon(modul.icon, color: accent, size: 23),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  modul.title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  modul.subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.muted,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                LuxChip(label: modul.badge, color: accent, dense: true),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.muted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gold.withValues(alpha: 0),
                AppColors.gold.withValues(alpha: 0.5),
                AppColors.gold.withValues(alpha: 0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Provider  ·  Riverpod 3  ·  Cubit',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.muted,
              ),
        ),
      ],
    );
  }
}
