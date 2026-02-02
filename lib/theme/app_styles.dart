import 'package:flutter/material.dart';

class AppColors {
  // Light (Base UNMSM Red)
  static const Color primary = Color(0xFFC1272D); // unmsmRed
  static const Color primaryDark = Color(0xFF8B1F24); // unmsmRedDark
  static const Color accentGold = Color(0xFFD4AF37); // unmsmGold
  
  static const Color background = Color(0xFFF8FAFC); // bgBody
  static const Color surface = Color(0xFFFFFFFF); // bgSurface
  static const Color hover = Color(0xFFF1F5F9); // bgHover

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static const Color textOnPrimary = Colors.white;
  static const Color textOnPrimaryMuted = Colors.white70;

  static const Color border = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF166534); // successText
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFF854D0E); // warningText
  static const Color warningBg = Color(0xFFFEF9C3);
  static const Color danger = Color(0xFF991B1B); // dangerText
  static const Color dangerBg = Color(0xFFFEE2E2);

  // Extra accents
  static const Color accentBlue = Color(0xFF2563EB);
  static const Color accentGreen = Color(0xFF16A34A);
  static const Color accentPurple = Color(0xFF9333EA);
  static const Color accentAmber = Color(0xFFD97706);

  // Dark Mode
  static const Color primaryDarkMode = Color(0xFFE0555A); // unmsmRedDarkMode
  static const Color backgroundDark = Color(0xFF0F172A); // bgBodyDark
  static const Color surfaceDark = Color(0xFF1E293B); // bgSurfaceDark
  
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textMutedDark = Color(0xFF94A3B8);
  static const Color borderDark = Color(0xFF475569);
  
  static const Color textOnPrimaryDark = Colors.white;
  static const Color textOnPrimaryMutedDark = Colors.white70;

  // For compatibility with previous names
  static const Color neutralHint = textMuted;
}

class AppSpacing {
  // Scale based on 4px
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double huge = 48;

  // Semantic mappings used in the app
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets screenPaddingLarge = EdgeInsets.all(xxl);
  static const EdgeInsets listPadding = EdgeInsets.all(sm);
  static const EdgeInsets tilePadding = EdgeInsets.all(lg);
  static const EdgeInsets cardMarginBottom = EdgeInsets.only(bottom: xs);
  static const EdgeInsets filterPadding =
      EdgeInsets.symmetric(horizontal: sm + 3, vertical: xs + 2); // preserved ~15, 10
      
  static const double gapXs = xs + 2; // ~10
  static const double gapSm = sm + 3; // ~15
  static const double gapMd = lg;     // ~20
  static const double gapLgAlt = xl;  // 24
  static const double gapLg = xxl;    // ~30
  static const double gapXl = xxxl;   // 40
}

class AppRadii {
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 14;
  static const double xxl = 16;
  static const double pill = 50;
  static const double cardRadius = 20;

  static final BorderRadius card = BorderRadius.circular(cardRadius);
  static final BorderRadius badge = BorderRadius.circular(sm);
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

  // Semantic mappings used in the app
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle menuTitle = TextStyle(
    fontFamily: fontDisplay,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontDisplay,
    fontWeight: FontWeight.bold, 
    fontSize: 16,
  );
  
  static const TextStyle horarioTitle = TextStyle(
    fontFamily: fontBody,
    fontWeight: FontWeight.bold, 
    fontSize: 14,
  );
  
  static const TextStyle onPrimary = TextStyle(
    color: AppColors.textOnPrimary,
    fontFamily: fontBody,
  );
  
  static const TextStyle helper = TextStyle(
    color: AppColors.textMuted, 
    fontStyle: FontStyle.italic,
    fontFamily: fontBody,
    fontSize: 12,
  );
  
  static const TextStyle danger = TextStyle(
    color: AppColors.danger,
    fontFamily: fontBody,
  );
  
  static const TextStyle splashTitle = TextStyle(
    color: AppColors.textOnPrimary,
    fontFamily: fontDisplay,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );
  
  static const TextStyle splashSubtitle = TextStyle(
    color: AppColors.textOnPrimaryMuted,
    fontFamily: fontBody,
    fontSize: 18,
  );
  
  static const TextStyle chipDay = TextStyle(
    color: AppColors.textOnPrimary,
    fontWeight: FontWeight.bold,
    fontFamily: fontBody,
  );
  
  static const TextStyle chipTime = TextStyle(
    color: AppColors.textOnPrimaryMuted,
    fontSize: 10,
    fontFamily: fontMono,
  );
}

class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
}
