import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);
  static const Color whiteTransparent = Color(0x00FFFFFF);
  static const Color labelHalo = Color(0xF2FFFFFF);
  static const Color shadowSoft = Color(0x14000000);

  // Header / cosmic background
  static const Color headerTop = Color(0xFF0A2F32);
  static const Color headerLift = Color(0xFF0B3034);
  static const Color headerMid = Color(0xFF071F22);
  static const Color headerBottom = Color(0xFF041416);
  static const Color greetingMuted = Color(0xFFC5D4D3);

  // Brand teal
  static const Color primary = Color(0xFF0E6B66);
  static const Color primaryDark = Color(0xFF0A4F4B);
  static const Color primaryDeep = Color(0xFF063532);
  static const Color primaryButton = Color(0xFF0C5C57);
  static const Color journalCover = Color(0xFF14544C);
  static const Color journalPlate = Color(0xFF0B3D46);
  static const Color journalAccent = Color(0xFF1F8A86);

  // Surfaces
  static const Color cream = white;
  static const Color surface = white;
  static const Color sheet = white;
  static const Color cardMint = Color(0xFFF3F8F7);
  static const Color cardBorder = Color(0xFFE6EEEC);
  static const Color journalPage = Color(0xFFF9F8F6);
  static const Color iconRing = Color(0xFFD5E5E3);
  static const Color chipIdle = Color(0xFFFEFDF8);
  static const Color chipBorder = Color(0xFFE7E5DB);
  static const Color chipSelected = Color(0xFF16343A);
  static const Color horoscopeFill = Color(0xFFFEFBEC);

  // Page gradients
  static const Color mintLight = Color(0xFFD4E8EC);
  static const Color yellowLight = Color(0xFFFEF2C2);
  static const Color mintFade = Color(0xFFE9F3F5);
  static const Color entryStart = Color(0xFFF4F4F4);
  static const Color entryEnd = Color(0xFFB8E2E2);
  static const Color entryInner = Color(0xFFE9F5F5);

  // Goals empty card
  static const Color goalsBorder = Color(0xFFE8E4D8);
  static const Color goalsSand = Color(0xFFF8F0D4);
  static const Color goalsGold = Color(0xFFE4D4A0);
  static const Color goalsSage = Color(0xFF9BB8A8);
  static const Color goalsDeep = Color(0xFF3A7A78);

  // Dial rings (outer → inner), drawn wheel
  static const Color dialYrs = Color(0xFFF4EFE4);
  static const Color dialMm = Color(0xFFF0E2A8);
  static const Color dialDays = Color(0xFFD4B896);
  static const Color dialHrs = Color(0xFF7A9A9E);
  static const Color dialMins = Color(0xFF4F8A8A);
  static const Color dialSec = Color(0xFF9FD0D8);
  static const Color dialYrsFill = Color(0xFFFFF9E7);
  static const Color dialYrsMuted = Color(0xFFC4BBA8);
  static const Color dialMmFill = Color(0xFFFFF0B8);
  static const Color dialMmMuted = Color(0xFFB8A978);
  static const Color dialDaysFill = Color(0xFFD9CCA0);
  static const Color dialDaysMuted = Color(0xFF8A7E5C);
  static const Color dialHrsFill = Color(0xFF5595A2);
  static const Color dialHrsMuted = Color(0xFF1F4A54);
  static const Color dialMinsFill = Color(0xFF8BC1C8);
  static const Color dialSecFill = Color(0xFFB0D5D8);
  static const Color dialSecMuted = Color(0xFF2A5A62);
  static const Color dialMinsMuted = dialSecMuted;
  static const Color dialHub = Color(0xFFC5E4EA);
  static const Color dialHubInner = Color(0xFFD8F0F4);
  static const Color dialSelected = Color(0xFF111111);
  static const Color dialSeparator = Color(0x261A1A1A);

  // Numerology globe
  static const Color numerologyBorder = Color(0xFFCFC7A9);
  static const Color numerologyBorderLight = Color(0xFFFCF6DE);
  static const Color numerologyLabel = Color(0xFF3D7A8A);
  static const Color globeTeal = Color(0xFF4A9BB0);
  static const Color globeTealDeep = Color(0xFF3A8498);
  static const Color globeTealSoft = Color(0xFF6BB8C8);
  static const Color globeCream = Color(0xFFFEF8E0);
  static const Color globeGlow = Color(0xFF5BB8D0);
  static const Color globeHighlight = Color(0xFFD2F4FA);
  static const Color globeMid = Color(0xFF7EC9DC);
  static const Color globeOcean = Color(0xFF3A8FAA);
  static const Color globeDeep = Color(0xFF1E5A6E);
  static const Color globeAbyss = Color(0xFF0F3340);
  static const Color globeRing = Color(0xFFD4C48A);
  static const Color globeRingFade = Color(0x00E8D9A0);
  static const Color globeRingGold = Color(0xFFF0E0A8);
  static const Color globeRingCyan = Color(0xFFC5E8F2);
  static const Color globeRingCyanFade = Color(0x00C5E8F2);
  static const Color globeRingSoft = Color(0xFFE8D9A0);

  // Insights illustration
  static const Color ringStroke = Color(0xFFC5D8D6);
  static const Color zodiacGlyph = Color(0xFF6A8B92);
  static const Color chartInk = Color(0xFF1C3A40);
  static const Color destinyNumber = Color(0xFF1E3338);
  static const Color destinyTitle = Color(0xFF6B9AAB);
  static const Color periodSelected = Color(0xFF1A3336);
  static const Color periodIdle = Color(0xFF8FA3A6);
  static const Color sunCream = Color(0xFFFFF6D0);
  static const Color sunIvory = Color(0xFFF8F3E4);
  static const Color sunMist = Color(0xFFE7F3F4);
  static const Color sunFade = Color(0x00F7F6F2);
  static const Color sunGold = Color(0xFFF0D48A);
  static const Color sunFill = Color(0xFFF6D98A);
  static const Color moonFill = Color(0xFFE7F4F6);
  static const Color moonShade = Color(0xFF143844);
  static const Color starFill = Color(0xFFF3E6B8);

  // Accents
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldSoft = Color(0xFFF0E0A0);
  static const Color starGold = Color(0xFFC9A227);
  static const Color cyanMuted = Color(0xFF9EC8C8);
  static const Color accentPink = Color(0xFFE8A0B8);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7372);
  static const Color textMuted = Color(0xFF9AA3A1);
  static const Color textOnDark = white;
  static const Color textOnDarkMuted = Color(0xFFB7C9C8);
  static const Color sectionLabel = Color(0xFF8A9391);
  static const Color journalHeading = Color(0xFF191919);
  static const Color journalDate = Color(0xFF8E8E8E);
  static const Color journalMuted = Color(0xFF8A8A8A);
  static const Color bodyGray = Color(0xFF6A6A6A);
  static const Color goalsSubtitle = Color(0xFF4A4A4A);
  static const Color numerologyBody = Color(0xFF2A2A2A);
  static const Color horoscopeBody = Color(0xFF6E6E6E);
  static const Color signValue = Color(0xFF3A3A3A);
  static const Color textSoft = Color(0xFF9A9A9A);
  static const Color textFaint = Color(0xFFA3A3A3);
  static const Color insightCaption = Color(0xFF5C6E72);
  static const Color entryBody = Color(0xFF4C4C4C);
  static const Color entryHint = Color(0xFFB0B0B0);
  static const Color monthIdle = Color(0xFF7BA8A4);

  static const Color navInactive = Color(0xFF8A9694);
  static const Color navIdle = Color(0xFF9AA5A3);
  static const Color divider = Color(0xFFD8E3E1);

  // Splash
  static const Color splashBg = headerBottom;
  static const Color splashTop = Color(0xFF0B3F3C);
  static const Color splashBottom = Color(0xFF031E1C);
}
