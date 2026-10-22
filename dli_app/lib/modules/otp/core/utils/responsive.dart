/// Layout breakpoints shared by every screen.
class Responsive {
  Responsive._();

  static const double tablet = 600;
  static const double desktop = 900;

  static bool isDesktop(double width) => width >= desktop;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isMobile(double width) => width < tablet;
}
