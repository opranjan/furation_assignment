/// Shared values used by more than one screen.
abstract final class AppConstants {
  static const appName = 'Lumina';
  static const geist = 'Geist';
  static const satoshi = 'Satoshi';
  static const arvo = 'Arvo';

  /// Set this when the backend exists. No screen calls it yet.
  static const apiBaseUrl = '';
  static const apiTimeout = Duration(seconds: 30);

  static const indicatorDuration = Duration(milliseconds: 320);
  static const pageFlipDuration = Duration(milliseconds: 700);
  static const splashIntroDuration = Duration(milliseconds: 1100);
  static const splashHoldDuration = Duration(milliseconds: 2200);
  static const fadeSlideDuration = Duration(milliseconds: 520);

  static const journalAspect = 643 / 819;
  static const journalRadius = 18.0;

  static const navIndicator = 'assets/images/nav_indicator.png';
  static const navHome = 'assets/icons/nav_home.svg';
  static const navGoals = 'assets/icons/nav_goals.svg';
  static const navJournal = 'assets/icons/nav_journal.svg';
  static const navInsights = 'assets/icons/nav_insights.svg';
  static const journalCover = 'assets/images/journal_cover.png';
  static const journalPage = 'assets/images/journal_page_bg.png';
  static const journalQuill = 'assets/images/Teal Feather Quill Icon.png';
  static const goalsMountains = 'assets/images/goals_mountains.png';
  static const homeProfile = 'assets/icons/profile.svg';
  static const homeNotification = 'assets/icons/notification.svg';
  static const focusOfTheDay = 'assets/images/focus_of_the_day_bg.png';
  static const favourableDirection = 'assets/images/favourable_direction.png';
  static const luckyColour = 'assets/images/lucky_colour.png';
  static const funFacts = 'assets/images/fun_facts_bg.png';
  static const destiny = 'assets/images/destiny_bg.png';
  static const zodiacWheel = 'assets/images/zodiac_wheel.png';
  static const leoLion = 'assets/images/leo_lion.png';
  static const zodiacCancer = 'assets/images/zodiac_cancer.png';
  static const zodiacTaurus = 'assets/images/zodiac_taurus.png';
  static const zodiacGemini = 'assets/images/zodiac_gemini.png';
  static const zodiacAries = 'assets/images/zodiac_aries.png';
  static const zodiacLeo = 'assets/images/zodiac_leo.png';
  static const numerology = 'assets/images/numerology_bg.jpg';
  static const horoscope = 'assets/images/horoscope_bg.png';
  static const geminiCoin = 'assets/images/gemini_coin.png';
  static const dialTick = 'sounds/dial_tick.wav';
}
