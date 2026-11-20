import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import 'home_bloc_page.dart';

class LoginBlocPage extends StatefulWidget {
  const LoginBlocPage({super.key});

  @override
  State<LoginBlocPage> createState() => _LoginBlocPageState();
}

class _LoginBlocPageState extends State<LoginBlocPage> {
  final _emailController = TextEditingController(text: 'admin@company.com');
  final _passwordController = TextEditingController();
  bool _sembunyikanPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _masuk(BuildContext context) {
    context.read<AuthCubit>().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LuxScaffold(
      appBar: const LuxAppBar(title: Text('Login (Cubit)')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              luxRoute(const HomeBlocPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: AppColors.ruby,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(state.pesan)),
                    ],
                  ),
                ),
              );
          }
        },
        
        builder: (context, state) {
          final loading = state is AuthLoading;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeSlideIn(
                      child: LuxCard(
                        highlight: true,
                        radius: 28,
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: GoldAvatar(
                                size: 76,
                                active: true,
                                child: Icon(Icons.lock_outline_rounded),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: GoldText(
                                'Masuk Portal HR',
                                textAlign: TextAlign.center,
                                style: textTheme.headlineSmall,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Autentikasi berbasis AuthCubit dan Equatable',
                              textAlign: TextAlign.center,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 28),
                            TextField(
                              controller: _emailController,
                              enabled: !loading,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              enabled: !loading,
                              obscureText: _sembunyikanPassword,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _masuk(context),
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.key_outlined),
                                suffixIcon: IconButton(
                                  tooltip: _sembunyikanPassword
                                      ? 'Tampilkan password'
                                      : 'Sembunyikan password',
                                  icon: Icon(
                                    _sembunyikanPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  onPressed: () => setState(
                                    () => _sembunyikanPassword =
                                        !_sembunyikanPassword,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            GoldButton(
                              label: loading ? 'Memproses...' : 'Masuk',
                              icon: loading ? null : Icons.login_rounded,
                              loading: loading,
                              onPressed: loading ? null : () => _masuk(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeSlideIn(
                      index: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.28),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.badge_outlined,
                              size: 20,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Akun uji: admin@company.com / admin123',
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.ivory.withValues(
                                    alpha: 0.85,
                                  ),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
