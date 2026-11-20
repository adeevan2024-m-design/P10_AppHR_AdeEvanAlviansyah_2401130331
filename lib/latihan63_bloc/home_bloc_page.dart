import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'login_bloc_page.dart';

class HomeBlocPage extends StatelessWidget {
  const HomeBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LuxScaffold(
      appBar: const LuxAppBar(title: Text('Beranda HR')),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final nama = state is Authenticated ? state.nama : '';
          final email = state is Authenticated ? state.email : '';

         return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: FadeSlideIn(
                  child: LuxCard(
                    highlight: true,
                    radius: 28,
                    padding: const EdgeInsets.fromLTRB(24, 34, 24, 26),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: GoldAvatar(
                            size: 92,
                            active: true,
                            child: Icon(Icons.verified_user_rounded),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Center(
                          child: LuxChip(
                            label: 'Terautentikasi',
                            color: AppColors.emerald,
                            icon: Icons.check_circle_outline_rounded,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Selamat datang,',
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GoldText(
                          nama,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineMedium,
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            email,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.ivory.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                        const SizedBox(height: 26),
                        const Divider(),
                        const SizedBox(height: 20),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthCubit>().logout();
                            Navigator.pushReplacement(
                              context,
                              luxRoute(const LoginBlocPage()),
                            );
                          },
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
