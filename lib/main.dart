import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'latihan61_provider/cuti_notifier.dart';
import 'latihan63_bloc/app_bloc_observer.dart';
import 'latihan63_bloc/auth_cubit.dart';

void main() {
  Bloc.observer = AppBlocObserver();

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      child: ChangeNotifierProvider(
        create: (_) => CutiNotifier(),
        child: BlocProvider(
          create: (_) => AuthCubit(),
          child: const AplikasiHR(),
        ),
      ),
    ),
  );
}

class AplikasiHR extends StatelessWidget {
  const AplikasiHR({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi HR',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

abstract final class AppColors {
  static const Color ink = Color(0xFF1E293B);
  static const Color canvas = Color(0xFFF5F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceHigh = Color(0xFFF8FAFC);
  static const Color surfaceHighest = Color(0xFFEEF2F7);
  static const Color outline = Color(0xFFE2E8F0);

  static const Color goldLight = Color(0xFF4338CA);
  static const Color gold = Color(0xFF4F46E5);
  static const Color goldDeep = Color(0xFF3730A3);

  static const Color ivory = Color(0xFF1E293B);
  static const Color muted = Color(0xFF64748B);

  static const Color emerald = Color(0xFF15803D);
  static const Color ruby = Color(0xFFBE123C);
  static const Color sapphire = Color(0xFF0369A1);
  static const Color copper = Color(0xFFC2410C);
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), gold, goldDeep],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceHigh],
  );
}

abstract final class AppTheme {
  static final ThemeData light = _build();

  static ThemeData _build() {
    const scheme = ColorScheme.light(
      primary: AppColors.gold,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFE0E7FF),
      onPrimaryContainer: Color(0xFF312E81),
      secondary: Color(0xFF0F766E),
      onSecondary: Colors.white,
      secondaryContainer: AppColors.surfaceHighest,
      onSecondaryContainer: AppColors.ivory,
      tertiary: AppColors.sapphire,
      onTertiary: Colors.white,
      error: AppColors.ruby,
      onError: Colors.white,
      errorContainer: Color(0xFFFFE4E6),
      onErrorContainer: Color(0xFF881337),
      surface: AppColors.surface,
      onSurface: AppColors.ivory,
      onSurfaceVariant: AppColors.muted,
      outline: Color(0xFF94A3B8),
      outlineVariant: AppColors.outline,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.surfaceHigh,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHighest,
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
    );

    final text = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    const buttonText = TextStyle(fontWeight: FontWeight.w600);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: text,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: AppColors.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.ink),
        actionsIconTheme: const IconThemeData(color: AppColors.gold),
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: inputBorder(AppColors.outline),
        enabledBorder: inputBorder(AppColors.outline),
        focusedBorder: inputBorder(AppColors.gold, 1.5),
        errorBorder: inputBorder(AppColors.ruby),
        focusedErrorBorder: inputBorder(AppColors.ruby, 1.5),
        disabledBorder: inputBorder(AppColors.outline.withValues(alpha: 0.4)),
        labelStyle: const TextStyle(color: AppColors.muted),
        floatingLabelStyle: const TextStyle(color: AppColors.gold),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? AppColors.gold
              : AppColors.muted,
        ),
        suffixIconColor: AppColors.muted,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.gold,
        selectionHandleColor: AppColors.gold,
        selectionColor: AppColors.gold.withValues(alpha: 0.3),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceHighest,
          disabledForegroundColor: AppColors.muted,
          minimumSize: const Size(64, 48),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          disabledForegroundColor: AppColors.muted,
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.55)),
          minimumSize: const Size(64, 52),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      badgeTheme: const BadgeThemeData(
        backgroundColor: AppColors.gold,
        textColor: AppColors.ink,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.gold,
        linearTrackColor: AppColors.surfaceHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

Color divisiColor(String divisi) {
  return switch (divisi) {
    'Engineering' => AppColors.sapphire,
    'Sales' => AppColors.copper,
    'HR' => AppColors.gold,
    'Finance' => AppColors.emerald,
    _ => AppColors.muted,
  };
}

class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  Widget build(BuildContext context) {
    final milidetik = 380 + (index > 8 ? 8 : index) * 70;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: milidetik),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
    );
  }
}

class GoldAvatar extends StatelessWidget {
  const GoldAvatar({
    super.key,
    required this.child,
    this.size = 46,
    this.active = false,
  });

  final Widget child;
  final double size;
  final bool active;

  static const LinearGradient _ringSoft = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF818CF8), Color(0xFF4F46E5), Color(0xFF3730A3)],
  );

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 260);
    final foreground = active ? Colors.white : AppColors.gold;

    return AnimatedContainer(
      duration: duration,
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: active ? AppColors.goldGradient : _ringSoft,
      ),
      child: AnimatedContainer(
        duration: duration,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? null : AppColors.surfaceHighest,
          gradient: active ? AppColors.goldGradient : null,
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.34,
            letterSpacing: 0.5,
          ),
          child: IconTheme.merge(
            data: IconThemeData(color: foreground, size: size * 0.46),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final borderRadius = BorderRadius.circular(12);

    return Semantics(
      button: true,
      enabled: enabled,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled ? 1 : (loading ? 0.85 : 0.45),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: borderRadius,
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Material(
            type: MaterialType.transparency,
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              splashColor: Colors.white.withValues(alpha: 0.2),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 52),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (loading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      else if (icon != null)
                        Icon(icon, size: 20, color: Colors.white),
                      if (loading || icon != null) const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GoldText extends StatelessWidget {
  const GoldText(this.data, {super.key, this.style, this.textAlign});

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.goldGradient.createShader(bounds),
      child: Text(
        data,
        textAlign: textAlign,
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}

class LuxCard extends StatelessWidget {
  const LuxCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.highlight = false,
    this.radius = 20,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool highlight;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: borderRadius,
        border: Border.all(
          color: highlight
              ? AppColors.gold.withValues(alpha: 0.28)
              : AppColors.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          if (highlight)
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.05),
              blurRadius: 20,
            ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.gold.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class LuxChip extends StatelessWidget {
  const LuxChip({
    super.key,
    required this.label,
    this.color = AppColors.gold,
    this.icon,
    this.dense = false,
  });

  final String label;
  final Color color;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route<T> luxRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 380),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.05, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class LuxBackground extends StatelessWidget {
  const LuxBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppColors.canvas);
  }
}

class LuxScaffold extends StatelessWidget {
  const LuxScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const LuxBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ],
    );
  }
}

class LuxAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LuxAppBar({super.key, required this.title, this.actions});

  final Widget title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: _GoldHairline(),
      ),
    );
  }
}

class _GoldHairline extends StatelessWidget {
  const _GoldHairline();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.gold.withValues(alpha: 0),
            AppColors.gold.withValues(alpha: 0.5),
            AppColors.gold.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 2,
          decoration: BoxDecoration(
            gradient: AppColors.goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
        ),
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color = AppColors.gold,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return LuxCard(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(color: AppColors.ivory),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.muted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.color = AppColors.gold,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                  border: Border.all(color: color.withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.18),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: Icon(icon, size: 38, color: color),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted,
                  height: 1.45,
                ),
              ),
              if (action != null) ...[const SizedBox(height: 24), action!],
            ],
          ),
        ),
      ),
    );
  }
}

class LuxLoader extends StatelessWidget {
  const LuxLoader({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                Icon(
                  Icons.workspace_premium_rounded,
                  size: 24,
                  color: AppColors.gold.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
