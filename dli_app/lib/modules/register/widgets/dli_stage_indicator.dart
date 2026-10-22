import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DliStageIndicator extends StatelessWidget {
  final int currentStage;
  final bool isMobile;
  final List<String> stages;

  const DliStageIndicator({
    super.key,
    this.currentStage = 0,
    this.isMobile = false,
    this.stages = const [
      'CONNECT',
      'VERIFY',
      'PROCESS',
      'COMPLETE',
    ],
  });

  static const Color dliBlue = Color(0xFF087BEF);
  static const Color inactiveGrey = Color(0xFFB9C5D1);
  static const Color activeGlow = Color(0xFFBFE2FF);
  static const Color inactiveText = Color(0xFF718396);

  @override
  Widget build(BuildContext context) {
    final int safeStage =
        currentStage.clamp(0, stages.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = isMobile
            ? constraints.maxWidth.clamp(280.0, 370.0)
            : 680.0;

        return SizedBox(
          width: width,
          height: isMobile ? 72 : 82,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Connecting line
              Positioned(
                left: isMobile ? 27.5 : 45,
                right: isMobile ? 27.5 : 45,
                top: isMobile ? 8 : 10,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DEE6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Stages
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  stages.length,
                  (index) {
                    final bool isActive =
                        index == safeStage;

                    return SizedBox(
                      width: isMobile ? 55 : 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circle
                          AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            width: isActive
                                ? (isMobile ? 18 : 20)
                                : (isMobile ? 12 : 14),
                            height: isActive
                                ? (isMobile ? 18 : 20)
                                : (isMobile ? 12 : 14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFFF8FAFC),
                              border: Border.all(
                                color: isActive
                                    ? dliBlue
                                    : inactiveGrey,
                                width: isActive ? 3 : 2,
                              ),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: activeGlow,
                                        blurRadius: 9,
                                        spreadRadius: 3,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isActive
                                ? Center(
                                    child: Container(
                                      width: isMobile ? 5 : 6,
                                      height: isMobile ? 5 : 6,
                                      decoration:
                                          const BoxDecoration(
                                        color: dliBlue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),

                          const SizedBox(height: 10),

                          // Stage text
                          Text(
                            stages[index],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.poppins(
                              fontSize: isMobile ? 8.5 : 11,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              letterSpacing:
                                  isMobile ? 0.1 : 0.2,
                              color: isActive
                                  ? dliBlue
                                  : inactiveText,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}