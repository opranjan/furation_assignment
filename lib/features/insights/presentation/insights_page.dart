import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../home/domain/entities/horoscope.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../home/presentation/widgets/numerology_card.dart';
import 'bloc/insights_bloc.dart';
import '../../../core/theme/app_colors.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsBloc, InsightsState>(
      builder: (context, state) => _InsightsView(state: state),
    );
  }
}

class _InsightsView extends StatelessWidget {
  const _InsightsView({required this.state});

  final InsightsState state;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final horoscope = state.horoscope;

    // CSS linear-gradient(201.84deg, #D4E8EC 23.03%, #FEF2C2 85.7%)
    final radians = 201.84 * math.pi / 180;
    final dx = math.sin(radians);
    final dy = -math.cos(radians);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: ColoredBox(
        color: AppColors.white,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 28),
          physics: const BouncingScrollPhysics(),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-dx, -dy),
                  end: Alignment(dx, dy),
                  colors: const [AppColors.mintLight, AppColors.yellowLight],
                  stops: const [0.2303, 0.857],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.43, top + 12, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FadeSlideIn(child: _Title()),
                        const SizedBox(height: 18),
                        const FadeSlideIn(
                          delay: Duration(milliseconds: 60),
                          child: _PeriodTabs(),
                        ),
                        const SizedBox(height: 12),
                        FadeSlideIn(
                          delay: const Duration(milliseconds: 140),
                          child: _ZodiacHero(
                            name: state.displayName,
                            birth: state.birthLabel,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const IgnorePointer(
                    child: SizedBox(
                      height: 72,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.whiteTransparent,
                              AppColors.white,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionLabel('ASTROLOGY'),
                  const SizedBox(height: 14),
                  _FocusRow(focus: horoscope.focusOfDay),
                  const SizedBox(height: 14),
                  _HoroscopeCard(horoscope: horoscope),
                  const SizedBox(height: 12),
                  _FunFactsCard(text: horoscope.funFact),
                  const SizedBox(height: 22),
                  const _SectionLabel('NUMEROLOGY'),
                  const SizedBox(height: 14),
                  NumerologyCard(luckyNumber: horoscope.luckyNumber),
                  const SizedBox(height: 18),
                  _DestinyBlock(
                    number: state.destinyNumber,
                    title: state.destinyTitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Insights',
      style: TextStyle(
        fontFamily: 'Geist',
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1,
        letterSpacing: 0,
        color: AppColors.black,
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs();

  static const items = <(InsightPeriod, String)>[
    (InsightPeriod.yesterday, 'YESTERDAY'),
    (InsightPeriod.today, 'TODAY'),
    (InsightPeriod.tomorrow, 'TOMORROW'),
    (InsightPeriod.week, 'WEEK'),
    (InsightPeriod.month, 'MONTH'),
  ];

  static const selectedColor = AppColors.periodSelected;
  static const idleColor = AppColors.periodIdle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InsightsBloc, InsightsState>(
      builder: (context, state) {
        return _PeriodTabBar(
          period: state.period,
          onSelect:
              (period) => context.read<InsightsBloc>().add(
                InsightsPeriodSelected(period),
              ),
        );
      },
    );
  }
}

class _PeriodTabBar extends StatefulWidget {
  const _PeriodTabBar({required this.period, required this.onSelect});

  final InsightPeriod period;
  final ValueChanged<InsightPeriod> onSelect;

  @override
  State<_PeriodTabBar> createState() => _PeriodTabBarState();
}

class _PeriodTabBarState extends State<_PeriodTabBar> {
  final _scroll = ScrollController();
  final _stackKey = GlobalKey();
  final _tabKeys = List<GlobalKey>.generate(
    _PeriodTabs.items.length,
    (_) => GlobalKey(),
  );

  double _left = 0;
  double _width = 0;
  bool _placed = false;
  bool _animate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _place(scroll: false));
  }

  @override
  void didUpdateWidget(covariant _PeriodTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.period != widget.period) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _place(scroll: true));
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  int get _index =>
      _PeriodTabs.items.indexWhere((item) => item.$1 == widget.period);

  void _place({required bool scroll}) {
    if (!mounted) return;
    final index = _index;
    if (index < 0) return;
    final tabBox =
        _tabKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (tabBox == null || stackBox == null || !tabBox.hasSize) return;

    final origin = stackBox.localToGlobal(Offset.zero);
    final tab = tabBox.localToGlobal(Offset.zero);
    setState(() {
      _animate = scroll && _placed;
      _left = tab.dx - origin.dx;
      _width = tabBox.size.width;
      _placed = true;
    });

    if (!scroll || !_scroll.hasClients) return;
    final target = (_left - 32).clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      target,
      duration: AppConstants.indicatorDuration,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final index = _index;
    return SizedBox(
      height: 28,
      child: SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Stack(
          key: _stackKey,
          clipBehavior: Clip.none,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _PeriodTabs.items.length; i++) ...[
                  if (i > 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '·',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          height: 1,
                          color: _PeriodTabs.idleColor,
                        ),
                      ),
                    ),
                  GestureDetector(
                    key: _tabKeys[i],
                    onTap: () => widget.onSelect(_PeriodTabs.items[i].$1),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight:
                            i == index ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 12,
                        height: 1,
                        letterSpacing: 0.4,
                        color:
                            i == index
                                ? _PeriodTabs.selectedColor
                                : _PeriodTabs.idleColor,
                      ),
                      child: Text(_PeriodTabs.items[i].$2),
                    ),
                  ),
                ],
              ],
            ),
            AnimatedPositioned(
              duration:
                  _animate ? AppConstants.indicatorDuration : Duration.zero,
              curve: Curves.easeOutCubic,
              left: _left,
              width: _width == 0 ? 0 : _width,
              top: 15,
              child: Column(
                children: [
                  Container(height: 1.2, color: _PeriodTabs.selectedColor),
                  const SizedBox(height: 3),
                  Center(
                    child: Container(
                      width: 3.5,
                      height: 3.5,
                      decoration: const BoxDecoration(
                        color: _PeriodTabs.selectedColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Profile extends StatelessWidget {
  const _Profile({required this.name, required this.birth});

  final String name;
  final String birth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Geist',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          birth,
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        letterSpacing: 1.6,
        color: AppColors.textFaint,
      ),
    );
  }
}

class _FocusRow extends StatelessWidget {
  const _FocusRow({required this.focus});

  final String focus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(left: 16, right: 88),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage(AppConstants.focusOfTheDay),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            height: 1.2,
            color: AppColors.insightCaption,
          ),
          children: [
            const TextSpan(
              text: 'Focus of the day: ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextSpan(
              text: focus,
              style: const TextStyle(
                fontFamily: 'Geist',
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoroscopeCard extends StatelessWidget {
  const _HoroscopeCard({required this.horoscope});

  final Horoscope horoscope;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.black.withValues(alpha: 0.05),
        //     blurRadius: 18,
        //     offset: const Offset(0, 8),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.horoscopeFill,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.yellowLight),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your today's horoscope",
                      style: TextStyle(
                        fontFamily: 'Geist',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      horoscope.body,
                      style: const TextStyle(
                        fontFamily: 'Satoshi',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        height: 1.45,
                        color: AppColors.horoscopeBody,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _SignTile(
                    title: 'Favourable Direction',
                    value: horoscope.favourableDirection,
                    image: AppConstants.favourableDirection,
                    background: AppColors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SignTile(
                    title: 'Lucky Colour',
                    value: horoscope.luckyColour,
                    image: AppConstants.luckyColour,
                    fillImage: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignTile extends StatelessWidget {
  const _SignTile({
    required this.title,
    required this.value,
    required this.image,
    this.background,
    this.fillImage = false,
  });

  final String title;
  final String value;
  final String image;
  final Color? background;
  final bool fillImage;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 156,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (fillImage)
              Image.asset(image, fit: BoxFit.cover)
            else
              ColoredBox(
                color: background ?? AppColors.white,
                child: Center(
                  child: Image.asset(
                    image,
                    width: 78,
                    height: 78,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '· $value ·',
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: AppColors.signValue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FunFactsCard extends StatelessWidget {
  const _FunFactsCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppConstants.funFacts),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 14, 16, 14),
        child: Row(
          children: [
            const SizedBox(
              width: 92,
              height: 88,
              child: CustomPaint(painter: _SunMoonPainter()),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fun Facts',
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 1.4,
                      color: AppColors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinyBlock extends StatelessWidget {
  const _DestinyBlock({required this.number, required this.title});

  final int number;
  final String title;

  @override
  Widget build(BuildContext context) {
    // Image is 1024×770. The sun center sits at y=178.
    const imgW = 1024.0;
    const imgH = 770.0;
    const numberY = 178.0;
    const imageHeight = 300.0;

    return Column(
      children: [
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final scale = math.min(
                constraints.maxWidth / imgW,
                imageHeight / imgH,
              );
              final drawnW = imgW * scale;
              final drawnH = imgH * scale;
              final dx = (constraints.maxWidth - drawnW) / 2;
              final dy = (imageHeight - drawnH) / 2;
              final numberSize = 92 * scale;
              return ClipRect(
                child: Stack(
                  children: [
                    Positioned(
                      left: dx,
                      top: dy,
                      width: drawnW,
                      height: drawnH,
                      child: Image.asset(
                        AppConstants.destiny,
                        fit: BoxFit.fill,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: dy + numberY * scale - numberSize / 2,
                      child: Text(
                        '$number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontWeight: FontWeight.w500,
                          fontSize: numberSize,
                          height: 1,
                          color: AppColors.destinyNumber,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: imageHeight - (dy + drawnH) + 10,
                      child: Column(
                        children: [
                          Text(
                            'Destiny Number $number',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Geist',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 1.2,
                              color: AppColors.destinyTitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ZodiacHero extends StatelessWidget {
  const _ZodiacHero({required this.name, required this.birth});

  final String name;
  final String birth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final outer = math.min(constraints.maxWidth - 4, 348.0);
        final wheel = outer * 0.6;
        final ringR = outer / 2 - 1;
        // Upper-left and upper-right, sitting on the outer ring stroke.
        const lift = 0.52;
        final labelR = ringR;
        final labelX = math.cos(lift) * labelR;
        final labelY = -math.sin(lift) * labelR;
        return SizedBox(
          height: outer + 36,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              CustomPaint(
                size: Size(outer * 1.05, outer * 1.05),
                painter: const _WheelPainter(),
              ),
              CustomPaint(
                size: Size(outer + 48, outer + 48),
                painter: _OuterRingPainter(ringR),
              ),
              Transform.translate(
                offset: Offset(0, -ringR + 52),
                child: _Profile(name: name, birth: birth),
              ),
              Image.asset(
                AppConstants.zodiacWheel,
                width: wheel,
                height: wheel,
                fit: BoxFit.contain,
              ),
              Image.asset(
                AppConstants.leoLion,
                width: wheel * 0.52,
                height: wheel * 0.52,
                fit: BoxFit.contain,
              ),
              _OrbitIcon(
                asset: AppConstants.zodiacCancer,
                angle: math.pi - 0.35,
                radius: wheel * 0.44,
                size: 30,
              ),
              _OrbitIcon(
                asset: AppConstants.zodiacTaurus,
                angle: math.pi * 0.68,
                radius: wheel * 0.44,
                size: 30,
              ),
              _OrbitIcon(
                asset: AppConstants.zodiacGemini,
                angle: 0.32,
                radius: wheel * 0.44,
                size: 30,
              ),
              _OrbitIcon(
                asset: AppConstants.zodiacAries,
                angle: math.pi * 0.3,
                radius: wheel * 0.44,
                size: 30,
              ),
              Transform.translate(
                offset: Offset(-labelX, labelY),
                child: const SizedBox(
                  width: 0,
                  height: 0,
                  child: OverflowBox(
                    alignment: Alignment.centerLeft,
                    minWidth: 0,
                    maxWidth: 130,
                    minHeight: 0,
                    maxHeight: 44,
                    child: _AxisSign(
                      glyph: '♋',
                      title: 'Cancer',
                      subtitle: 'Sun sign',
                      glyphFirst: true,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(labelX, labelY),
                child: const SizedBox(
                  width: 0,
                  height: 0,
                  child: OverflowBox(
                    alignment: Alignment.centerRight,
                    minWidth: 0,
                    maxWidth: 130,
                    minHeight: 0,
                    maxHeight: 44,
                    child: _AxisSign(
                      glyph: '♌',
                      title: 'Leo',
                      subtitle: 'Moon sign',
                      glyphFirst: false,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, wheel * 0.42 + 22),
                child: const _LeoBadge(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OuterRingPainter extends CustomPainter {
  const _OuterRingPainter(this.radius);

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: c, radius: radius);
    final radians = 201.84 * math.pi / 180;
    final dx = math.sin(radians);
    final dy = -math.cos(radians);
    final shader = LinearGradient(
      begin: Alignment(-dx, -dy),
      end: Alignment(dx, dy),
      colors: const [AppColors.mintLight, AppColors.yellowLight],
      stops: const [0.2303, 0.857],
    ).createShader(rect);

    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = AppColors.ringStroke,
    );

    final arc = Rect.fromCircle(center: c, radius: radius);
    // Upper half only: 9 o'clock, through the top, to 3 o'clock.
    canvas.drawArc(
      arc,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawArc(
      arc,
      math.pi,
      math.pi,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..shader = shader
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
    );
  }

  @override
  bool shouldRepaint(covariant _OuterRingPainter oldDelegate) =>
      oldDelegate.radius != radius;
}

class _AxisSign extends StatelessWidget {
  const _AxisSign({
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.glyphFirst,
  });

  final String glyph;
  final String title;
  final String subtitle;
  final bool glyphFirst;

  @override
  Widget build(BuildContext context) {
    final mark = Text(
      glyph,
      style: const TextStyle(
        fontSize: 18,
        height: 1,
        color: AppColors.zodiacGlyph,
      ),
    );
    final words = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          glyphFirst ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            height: 1.05,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w500,
            fontSize: 11,
            height: 1.1,
            color: AppColors.textSoft,
          ),
        ),
      ],
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          glyphFirst
              ? [mark, const SizedBox(width: 6), words]
              : [words, const SizedBox(width: 6), mark],
    );
  }
}

class _LeoBadge extends StatelessWidget {
  const _LeoBadge();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowSoft,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Image(
              image: AssetImage(AppConstants.zodiacLeo),
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Leo',
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            height: 1,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 12,
          height: 12,
          child: CustomPaint(painter: _SparklePainter()),
        ),
      ],
    );
  }
}

class _SparklePainter extends CustomPainter {
  const _SparklePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final path =
        Path()
          ..moveTo(c.dx, 0)
          ..quadraticBezierTo(c.dx, c.dy, size.width, c.dy)
          ..quadraticBezierTo(c.dx, c.dy, c.dx, size.height)
          ..quadraticBezierTo(c.dx, c.dy, 0, c.dy)
          ..quadraticBezierTo(c.dx, c.dy, c.dx, 0)
          ..close();
    canvas.drawPath(path, Paint()..color = AppColors.chartInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OrbitIcon extends StatelessWidget {
  const _OrbitIcon({
    required this.asset,
    required this.angle,
    required this.radius,
    required this.size,
  });

  final String asset;
  final double angle;
  final double radius;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
      child: Image.asset(asset, width: size, height: size, fit: BoxFit.contain),
    );
  }
}

class _WheelPainter extends CustomPainter {
  const _WheelPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.46;
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          colors: [
            AppColors.sunCream,
            AppColors.sunIvory,
            AppColors.sunMist,
            AppColors.sunFade,
          ],
          stops: [0.0, 0.38, 0.72, 1.0],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SunMoonPainter extends CustomPainter {
  const _SunMoonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sun = Offset(size.width * 0.58, size.height * 0.62);
    final ray =
        Paint()
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round
          ..color = AppColors.sunGold;
    for (var i = 0; i < 10; i++) {
      final a = i / 10 * math.pi * 2;
      canvas.drawLine(
        sun + Offset(math.cos(a) * 16, math.sin(a) * 16),
        sun + Offset(math.cos(a) * 24, math.sin(a) * 24),
        ray,
      );
    }
    canvas.drawCircle(sun, 13, Paint()..color = AppColors.sunFill);
    canvas.drawCircle(
      sun.translate(-3, -3),
      4,
      Paint()..color = AppColors.white.withValues(alpha: 0.45),
    );

    final moon = Offset(size.width * 0.28, size.height * 0.34);
    canvas.drawCircle(moon, 11, Paint()..color = AppColors.moonFill);
    canvas.drawCircle(
      moon.translate(5, -1),
      9,
      Paint()..color = AppColors.moonShade,
    );

    final star = Paint()..color = AppColors.starFill;
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.72), 1.4, star);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.22), 1.2, star);
    canvas.drawCircle(Offset(size.width * 0.42, size.height * 0.16), 1.1, star);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
