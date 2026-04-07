import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  USAGE
//  1. Copy this file into lib/screens/
//  2. Add your logo: assets/images/vedant_logo.png
//     (use the sakshi.png you uploaded — rename it)
//  3. In pubspec.yaml add:
//       flutter:
//         assets:
//           - assets/images/vedant_logo.png
//  4. Set SplashScreen as your initial route in main.dart:
//       home: const SplashScreen()
//  5. Replace the Navigator push destination with your HomeScreen
// ─────────────────────────────────────────────

void main() => runApp(const _PreviewApp());

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();
  @override
  Widget build(BuildContext context) => const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ──────────────────────────────
  late final AnimationController _swooshCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _loaderCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _exitCtrl;

  // ── Swoosh draw animations ────────────────────
  late final Animation<double> _swooshOuter;
  late final Animation<double> _swooshInner;
  late final Animation<double> _swooshTop;

  // ── Text animations ───────────────────────────
  late final Animation<double> _vedantOpacity;
  late final Animation<Offset> _vedantSlide;
  late final Animation<double> _educationOpacity;
  late final Animation<Offset> _educationSlide;
  late final Animation<double> _taglineOpacity;

  // ── Misc ──────────────────────────────────────
  late final Animation<double> _loaderProgress;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;
  late final Animation<double> _shimmer;
  late final Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();

    // Swoosh: 0 – 1 s
    _swooshCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _swooshOuter = CurvedAnimation(
        parent: _swooshCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut));
    _swooshInner = CurvedAnimation(
        parent: _swooshCtrl,
        curve: const Interval(0.2, 0.85, curve: Curves.easeOut));
    _swooshTop = CurvedAnimation(
        parent: _swooshCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut));

    // Text: 1 – 2 s
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _vedantOpacity = CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut));
    _vedantSlide = Tween<Offset>(
        begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.0, 0.55,
            curve: Curves.elasticOut)));
    _educationOpacity = CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOut));
    _educationSlide = Tween<Offset>(
        begin: const Offset(0.4, 0), end: Offset.zero)
        .animate(CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.35, 0.9,
            curve: Curves.elasticOut)));
    _taglineOpacity = CurvedAnimation(
        parent: _textCtrl,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut));

    // Loader: 2 – 3.5 s
    _loaderCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _loaderProgress = CurvedAnimation(
        parent: _loaderCtrl, curve: Curves.easeInOut);

    // Pulse ring: looping every 1.5 s
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _pulseScale = Tween<double>(begin: 0.85, end: 1.45).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));
    _pulseOpacity = Tween<double>(begin: 0.7, end: 0.0).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut));

    // Shimmer across swoosh: looping
    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200));
    _shimmer = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));

    // Floating particles: looping
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));

    // Exit fade: 0 → 1 (white overlay)
    _exitCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _exitOpacity = CurvedAnimation(
        parent: _exitCtrl, curve: Curves.easeIn);

    _runSequence();
  }

  Future<void> _runSequence() async {
    // Phase 1 — draw swoosh
    await Future.delayed(const Duration(milliseconds: 300));
    _swooshCtrl.forward();

    // Phase 2 — reveal text
    await Future.delayed(const Duration(milliseconds: 1000));
    _textCtrl.forward();

    // Phase 3 — loader + ambient loops
    await Future.delayed(const Duration(milliseconds: 900));
    _loaderCtrl.forward();
    _pulseCtrl.repeat();
    _shimmerCtrl.repeat();
    _particleCtrl.repeat();

    // Phase 4 — exit
    await Future.delayed(const Duration(milliseconds: 2000));
    _exitCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
          const _PlaceholderHome(), // ← replace with your HomeScreen
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void dispose() {
    _swooshCtrl.dispose();
    _textCtrl.dispose();
    _loaderCtrl.dispose();
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _swooshCtrl,
          _textCtrl,
          _loaderCtrl,
          _pulseCtrl,
          _shimmerCtrl,
          _particleCtrl,
          _exitCtrl,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              // ── Background gradient ──────────────
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFFFFF),
                      Color(0xFFF0F4F8),
                      Color(0xFFE8F0FE),
                    ],
                    stops: [0.0, 0.4, 1.0],
                  ),
                ),
              ),

              // ── Floating particles ───────────────
              ..._buildParticles(),

              // ── Pulse ring ───────────────────────
              Center(
                child: Transform.scale(
                  scale: _pulseScale.value,
                  child: Opacity(
                    opacity: _pulseOpacity.value,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Main content ─────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo image with shimmer overlay
                    _buildLogoWithSwoosh(),
                    const SizedBox(height: 6),
                    // Tagline
                    FadeTransition(
                      opacity: _taglineOpacity,
                      child: const Text(
                        'EMPOWERING MINDS · SHAPING FUTURES',
                        style: TextStyle(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: Color(0xFF78909C),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Loader ───────────────────────────
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _loaderProgress,
                  child: Column(
                    children: [
                      // Progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 120),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _loaderProgress.value,
                            minHeight: 3,
                            backgroundColor:
                            const Color(0xFF4CAF50).withOpacity(0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF2E7D32)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Bouncing dots
                      _BouncingDots(controller: _loaderCtrl),
                    ],
                  ),
                ),
              ),

              // ── Exit white overlay ────────────────
              if (_exitOpacity.value > 0)
                Opacity(
                  opacity: _exitOpacity.value,
                  child: Container(color: Colors.white),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogoWithSwoosh() {
    return SizedBox(
      width: 260,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Swoosh drawn via CustomPainter
          CustomPaint(
            size: const Size(260, 220),
            painter: _SwooshPainter(
              outerProgress: _swooshOuter.value,
              innerProgress: _swooshInner.value,
              topProgress: _swooshTop.value,
              shimmerPosition: _shimmer.value,
            ),
          ),

          // Text block (Vedant + Education)
          // If you have the logo image use Image.asset below,
          // otherwise the text renders the brand manually.
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Option A: use logo image ──────────────────
              // Uncomment these lines if you add the asset:
              //
              // FadeTransition(
              //   opacity: _vedantOpacity,
              //   child: SlideTransition(
              //     position: _vedantSlide,
              //     child: Image.asset(
              //       'assets/images/vedant_logo.png',
              //       width: 180,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),

              // ── Option B: text-only (always works) ────────
              FadeTransition(
                opacity: _vedantOpacity,
                child: SlideTransition(
                  position: _vedantSlide,
                  child: const Text(
                    'Vedant',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFC0392B),
                      fontFamily: 'Georgia',
                      shadows: [
                        Shadow(
                          color: Color(0x33C0392B),
                          blurRadius: 12,
                          offset: Offset(2, 4),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _educationOpacity,
                child: SlideTransition(
                  position: _educationSlide,
                  child: const Text(
                    'EDUCATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A3A8C),
                      letterSpacing: 5,
                      fontFamily: 'Georgia',
                      shadows: [
                        Shadow(
                          color: Color(0x221A3A8C),
                          blurRadius: 8,
                          offset: Offset(1, 2),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    final rng = math.Random(42);
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2E7D32),
      const Color(0xFF1A3A8C),
      const Color(0xFFC0392B),
      const Color(0xFF81C784),
    ];
    final size = MediaQuery.of(context).size;

    return List.generate(18, (i) {
      final x = 0.08 + rng.nextDouble() * 0.84;
      final y = 0.15 + rng.nextDouble() * 0.7;
      final pSize = 3.0 + rng.nextDouble() * 3.0;
      final speed = 1.5 + rng.nextDouble() * 2.0;
      final phase = rng.nextDouble();
      final t = (_particleCtrl.value + phase) % 1.0;
      final opacity = t < 0.2
          ? t / 0.2
          : t > 0.85
          ? (1.0 - t) / 0.15
          : 0.5;
      final dy = t * 100;

      return Positioned(
        left: x * size.width,
        top: y * size.height - dy,
        child: Opacity(
          opacity: opacity.clamp(0.0, 0.6),
          child: Container(
            width: pSize,
            height: pSize,
            decoration: BoxDecoration(
              color: colors[i % colors.length],
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  Custom Painter — draws the green swoosh arcs
//  with stroke progress animation
// ─────────────────────────────────────────────
class _SwooshPainter extends CustomPainter {
  final double outerProgress;
  final double innerProgress;
  final double topProgress;
  final double shimmerPosition;

  _SwooshPainter({
    required this.outerProgress,
    required this.innerProgress,
    required this.topProgress,
    required this.shimmerPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Outer swoosh ─────────────────────────
    final outerPath = Path()
      ..moveTo(w * 0.15, h * 0.57)
      ..cubicTo(w * 0.05, h * 0.41, w * 0.09, h * 0.22, w * 0.275, h * 0.13)
      ..cubicTo(w * 0.39, h * 0.07, w * 0.55, h * 0.055, w * 0.70, h * 0.10)
      ..cubicTo(w * 0.825, h * 0.14, w * 0.91, h * 0.23, w * 0.91, h * 0.355)
      ..cubicTo(w * 0.91, h * 0.478, w * 0.825, h * 0.582, w * 0.725, h * 0.636);

    _drawAnimatedPath(
      canvas,
      outerPath,
      outerProgress,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 28
        ..strokeCap = StrokeCap.round
        ..shader = const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF2E7D32), Color(0xFF1B5E20)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // ── Inner swoosh ─────────────────────────
    final innerPath = Path()
      ..moveTo(w * 0.21, h * 0.592)
      ..cubicTo(w * 0.11, h * 0.455, w * 0.14, h * 0.264, w * 0.30, h * 0.182)
      ..cubicTo(w * 0.41, h * 0.118, w * 0.56, h * 0.109, w * 0.69, h * 0.155);

    _drawAnimatedPath(
      canvas,
      innerPath,
      innerProgress,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF81C784).withOpacity(0.75),
    );

    // ── Top cap ──────────────────────────────
    final topPath = Path()
      ..moveTo(w * 0.575, h * 0.109)
      ..cubicTo(w * 0.675, h * 0.091, w * 0.79, h * 0.118, w * 0.85, h * 0.191)
      ..cubicTo(w * 0.89, h * 0.245, w * 0.89, h * 0.309, w * 0.86, h * 0.364);

    _drawAnimatedPath(
      canvas,
      topPath,
      topProgress,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF4CAF50).withOpacity(0.9),
    );

    // ── Shimmer pass ─────────────────────────
    if (shimmerPosition > -0.5 && shimmerPosition < 1.5) {
      final shimPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.0),
          ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(shimmerPosition - 0.4, 0),
          end: Alignment(shimmerPosition + 0.4, 0),
        ).createShader(Rect.fromLTWH(0, 0, w, h));

      _drawAnimatedPath(canvas, outerPath, outerProgress, shimPaint);
    }
  }

  void _drawAnimatedPath(
      Canvas canvas, Path path, double progress, Paint paint) {
    if (progress <= 0) return;
    final metrics = path.computeMetrics().toList();
    for (final metric in metrics) {
      final len = metric.length * progress;
      canvas.drawPath(metric.extractPath(0, len), paint);
    }
  }

  @override
  bool shouldRepaint(_SwooshPainter old) =>
      old.outerProgress != outerProgress ||
          old.innerProgress != innerProgress ||
          old.topProgress != topProgress ||
          old.shimmerPosition != shimmerPosition;
}

// ─────────────────────────────────────────────
//  Bouncing dots loader
// ─────────────────────────────────────────────
class _BouncingDots extends StatefulWidget {
  final AnimationController controller;
  const _BouncingDots({required this.controller});
  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF4CAF50),
      Color(0xFF1A3A8C),
      Color(0xFFC0392B),
    ];
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final phase = i * 0.2;
          final t = (_ctrl.value + phase) % 1.0;
          final dy = math.sin(t * math.pi) * 5.0;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Transform.translate(
              offset: Offset(0, -dy),
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: colors[i],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Placeholder — replace with your HomeScreen
// ─────────────────────────────────────────────
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: const Center(
      child: Text(
        'Home Screen',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E7D32),
        ),
      ),
    ),
  );
}