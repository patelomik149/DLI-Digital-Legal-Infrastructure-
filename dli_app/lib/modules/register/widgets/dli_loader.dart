import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dli_stage_indicator.dart';

class DliLoader extends StatefulWidget {
  final int currentStage;
  final Duration duration;
  final String nextRoute;
  final String logoAsset;

  const DliLoader({
    super.key,
    this.currentStage = 0,
    this.duration = const Duration(seconds: 4),
    required this.nextRoute,
    this.logoAsset = 'assets/images/primary_logo.png',
  });

  @override
  State<DliLoader> createState() => _DliLoaderState();
}

class _DliLoaderState extends State<DliLoader>
    with SingleTickerProviderStateMixin {
  static const Color dliBlue = Color(0xFF087BEF);
  static const Color secondaryText = Color(0xFF7890A5);
  static const Color waveBlue = Color(0xFFEEF7FF);

  Timer? _timer;

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _startLoader();
  }

  void _startLoader() {
    _timer = Timer(
      widget.duration,
      () {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          widget.nextRoute,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile =
                constraints.maxWidth < 700;

            return isMobile
                ? _buildMobileLoader()
                : _buildWebLoader();
          },
        ),
      ),
    );
  }

  // ============================================================
  // WEB LOADER
  // ============================================================

  Widget _buildWebLoader() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _buildTopCircuit(false),
          ),

          Positioned(
            right: 0,
            bottom: 20,
            child: _buildBottomCircuit(false),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomWave(false),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    _buildLogo(false),

                    const SizedBox(height: 42),

                    DliStageIndicator(
                      currentStage:
                          widget.currentStage,
                      isMobile: false,
                    ),

                    const SizedBox(height: 38),

                    _buildTagline(false),

                    const SizedBox(height: 50),

                    _buildLoadingIndicator(false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LOADER
  // ============================================================

  Widget _buildMobileLoader() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: _buildTopCircuit(true),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomWave(true),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    _buildLogo(true),

                    const SizedBox(height: 48),

                    DliStageIndicator(
                      currentStage:
                          widget.currentStage,
                      isMobile: true,
                    ),

                    const SizedBox(height: 32),

                    _buildTagline(true),

                    const SizedBox(height: 42),

                    _buildLoadingIndicator(true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo(bool isMobile) {
    return Image.asset(
      widget.logoAsset,
      width: isMobile ? 220 : 330,
      height: isMobile ? 125 : 170,
      fit: BoxFit.contain,
    );
  }

  // ============================================================
  // TAGLINE
  // ============================================================

  Widget _buildTagline(bool isMobile) {
    return Text(
      'Building a Smarter\nLegal Tomorrow',
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: isMobile ? 13 : 16,
        height: 1.45,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w400,
        color: secondaryText,
      ),
    );
  }

  // ============================================================
  // LOADING INDICATOR
  // ============================================================

  Widget _buildLoadingIndicator(bool isMobile) {
    final double size = isMobile ? 55 : 68;

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle:
              _rotationController.value *
              6.283185307,
          child: SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _LoaderPainter(
                color: dliBlue,
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // TOP CIRCUIT
  // ============================================================

  Widget _buildTopCircuit(bool isMobile) {
    return SizedBox(
      width: isMobile ? 150 : 240,
      height: isMobile ? 160 : 220,
      child: CustomPaint(
        painter: _TopCircuitPainter(
          color: const Color(0xFFDDEFFF),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM CIRCUIT
  // ============================================================

  Widget _buildBottomCircuit(bool isMobile) {
    return SizedBox(
      width: isMobile ? 170 : 280,
      height: isMobile ? 170 : 230,
      child: CustomPaint(
        painter: _BottomCircuitPainter(
          color: const Color(0xFFDDEFFF),
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM WAVE
  // ============================================================

  Widget _buildBottomWave(bool isMobile) {
    return SizedBox(
      height: isMobile ? 115 : 145,
      width: double.infinity,
      child: CustomPaint(
        painter: _WavePainter(
          color: waveBlue,
        ),
      ),
    );
  }
}

// ================================================================
// LOADER PAINTER
// ================================================================

class _LoaderPainter extends CustomPainter {
  final Color color;

  _LoaderPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final Rect rect = Offset.zero & size;

    paint.shader = LinearGradient(
      colors: [
        color.withOpacity(0.08),
        color.withOpacity(0.25),
        color,
      ],
    ).createShader(rect);

    canvas.drawArc(
      rect.deflate(5),
      -1.0,
      4.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _LoaderPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// ================================================================
// TOP CIRCUIT PAINTER
// ================================================================

class _TopCircuitPainter extends CustomPainter {
  final Color color;

  _TopCircuitPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path1 = Path();

    path1.moveTo(
      0,
      size.height * 0.55,
    );

    path1.lineTo(
      size.width * 0.20,
      size.height * 0.55,
    );

    path1.lineTo(
      size.width * 0.34,
      size.height * 0.30,
    );

    path1.lineTo(
      size.width * 0.68,
      size.height * 0.30,
    );

    canvas.drawPath(path1, paint);

    canvas.drawCircle(
      Offset(
        size.width * 0.68,
        size.height * 0.30,
      ),
      5,
      paint,
    );

    final Path path2 = Path();

    path2.moveTo(
      0,
      size.height * 0.72,
    );

    path2.lineTo(
      size.width * 0.15,
      size.height * 0.72,
    );

    path2.lineTo(
      size.width * 0.30,
      size.height * 0.45,
    );

    path2.lineTo(
      size.width * 0.54,
      size.height * 0.45,
    );

    canvas.drawPath(path2, paint);

    canvas.drawCircle(
      Offset(
        size.width * 0.54,
        size.height * 0.45,
      ),
      5,
      paint,
    );

    final Path path3 = Path();

    path3.moveTo(
      0,
      size.height * 0.38,
    );

    path3.lineTo(
      size.width * 0.18,
      size.height * 0.38,
    );

    path3.lineTo(
      size.width * 0.31,
      size.height * 0.15,
    );

    path3.lineTo(
      size.width * 0.48,
      size.height * 0.15,
    );

    canvas.drawPath(path3, paint);

    canvas.drawCircle(
      Offset(
        size.width * 0.48,
        size.height * 0.15,
      ),
      4,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _TopCircuitPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// ================================================================
// BOTTOM CIRCUIT PAINTER
// ================================================================

class _BottomCircuitPainter extends CustomPainter {
  final Color color;

  _BottomCircuitPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Path path1 = Path();

    path1.moveTo(
      size.width,
      size.height * 0.25,
    );

    path1.lineTo(
      size.width * 0.72,
      size.height * 0.25,
    );

    path1.lineTo(
      size.width * 0.58,
      size.height * 0.52,
    );

    path1.lineTo(
      size.width * 0.30,
      size.height * 0.52,
    );

    canvas.drawPath(path1, paint);

    canvas.drawCircle(
      Offset(
        size.width * 0.30,
        size.height * 0.52,
      ),
      5,
      paint,
    );

    final Path path2 = Path();

    path2.moveTo(
      size.width,
      size.height * 0.43,
    );

    path2.lineTo(
      size.width * 0.80,
      size.height * 0.43,
    );

    path2.lineTo(
      size.width * 0.67,
      size.height * 0.70,
    );

    path2.lineTo(
      size.width * 0.45,
      size.height * 0.70,
    );

    canvas.drawPath(path2, paint);

    canvas.drawCircle(
      Offset(
        size.width * 0.45,
        size.height * 0.70,
      ),
      4,
      paint,
    );

    final Path path3 = Path();

    path3.moveTo(
      size.width,
      size.height * 0.10,
    );

    path3.lineTo(
      size.width * 0.86,
      size.height * 0.10,
    );

    path3.lineTo(
      size.width * 0.74,
      size.height * 0.33,
    );

    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(
    covariant _BottomCircuitPainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}

// ================================================================
// WAVE PAINTER
// ================================================================

class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();

    path.moveTo(
      0,
      size.height * 0.60,
    );

    path.cubicTo(
      size.width * 0.16,
      size.height * 0.35,
      size.width * 0.28,
      size.height * 0.82,
      size.width * 0.43,
      size.height * 0.60,
    );

    path.cubicTo(
      size.width * 0.58,
      size.height * 0.38,
      size.width * 0.70,
      size.height * 0.80,
      size.width * 0.84,
      size.height * 0.57,
    );

    path.cubicTo(
      size.width * 0.92,
      size.height * 0.44,
      size.width * 0.97,
      size.height * 0.55,
      size.width,
      size.height * 0.47,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(
    covariant _WavePainter oldDelegate,
  ) {
    return oldDelegate.color != color;
  }
}