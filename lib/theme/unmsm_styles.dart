import 'package:flutter/material.dart';

class AppColors {
  // Light
  static const Color unmsmRed = Color(0xFFC1272D);
  static const Color unmsmRedDark = Color(0xFF8B1F24);
  static const Color unmsmGold = Color(0xFFD4AF37);

  static const Color bgBody = Color(0xFFF8FAFC);
  static const Color bgSurface = Color(0xFFFFFFFF);
  static const Color bgHover = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color border = Color(0xFFE2E8F0);

  static const Color successBg = Color(0xFFDCFCE7);
  static const Color successText = Color(0xFF166534);
  static const Color warningBg = Color(0xFFFEF9C3);
  static const Color warningText = Color(0xFF854D0E);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFF991B1B);

  // Extra accents found in CSS
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentGreen = Color(0xFF16A34A);
  static const Color accentPurple = Color(0xFF9333EA);
  static const Color accentAmber = Color(0xFFD97706);
  static const Color bootstrapPrimary = Color(0xFF0D6EFD);

  static const Color successSubtle = Color(0xFFD1E7DD);
  static const Color dangerSubtle = Color(0xFFF8D7DA);
  static const Color warningSubtle = Color(0xFFFFF3CD);

  // Login-specific text overrides
  static const Color inputTextLight = Color(0xFF1E293B);
  static const Color inputTextDark = Color(0xFFF1F5F9);

  // Dark
  static const Color unmsmRedDarkMode = Color(0xFFE0555A);
  static const Color unmsmRedDarkDarkMode = Color(0xFFD14348);
  static const Color unmsmGoldDarkMode = Color(0xFFE6C158);

  static const Color bgBodyDark = Color(0xFF0F172A);
  static const Color bgSurfaceDark = Color(0xFF1E293B);
  static const Color bgHoverDark = Color(0xFF2D3748);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF94A3B8);

  static const Color borderDark = Color(0xFF475569);

  static const Color successBgDark = Color(0xFF064E3B);
  static const Color successTextDark = Color(0xFFA7F3D0);
  static const Color warningBgDark = Color(0xFF78350F);
  static const Color warningTextDark = Color(0xFFFDE68A);
  static const Color dangerBgDark = Color(0xFF7F1D1D);
  static const Color dangerTextDark = Color(0xFFFECACA);
}

class AppSpacing {
  // Based on values used across CSS (rems -> 4px scale)
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;
}

class AppRadii {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 14;
  static const double xxl = 16;
  static const double pill = 50;
  static const double card = 20;
}

class AppTextStyles {
  static const String fontDisplay = 'Sora';
  static const String fontBody = 'IBM Plex Sans';
  static const String fontMono = 'IBM Plex Mono';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle title = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontBody,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 11.2, // 0.7rem
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: fontMono,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
}

class AppShadows {
  // Light
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.1)
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  // Dark
  static const List<BoxShadow> smDark = [
    BoxShadow(
      color: Color(0x80000000), // rgba(0,0,0,0.5)
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> mdDark = [
    BoxShadow(
      color: Color(0x66000000), // rgba(0,0,0,0.4)
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x33000000), // rgba(0,0,0,0.2)
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}

class AppSizes {
  static const double sidebarWidth = 280;
  static const double topbarHeight = 72;
}
