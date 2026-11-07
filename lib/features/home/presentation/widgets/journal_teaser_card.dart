import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// Journal cover that turns in place onto the empty first-entry page.
class JournalTeaserCard extends StatefulWidget {
  const JournalTeaserCard({super.key, required this.ownerName});

  final String ownerName;

  @override
  State<JournalTeaserCard> createState() => _JournalTeaserCardState();
}

class _JournalTeaserCardState extends State<JournalTeaserCard> {
  final _controller = PageFlipController();
  late final List<Widget> _pages;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      _CoverFace(ownerName: widget.ownerName),
      const _OpenJournalPage(),
    ];
  }

  void _flip() {
    if (_index >= _pages.length - 1) {
      _controller.goToPage(0);
      setState(() => _index = 0);
    } else {
      _controller.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h =
            constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : constraints.maxWidth / AppConstants.journalAspect;
        // The shell keeps every tab alive. page_flip stores its pages in
        // globals, so the offstage Journal tab must not mount a second one.
        final active = TickerMode.of(context);
        if (!active) _index = 0;
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.journalRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.journalRadius),
            child: SizedBox(
              width: double.infinity,
              height: h,
              child:
                  active
                      ? Stack(
                        fit: StackFit.expand,
                        children: [
                          PageFlipWidget(
                            controller: _controller,
                            backgroundColor: AppColors.journalCover,
                            duration: AppConstants.pageFlipDuration,
                            onPageFlipped:
                                (page) => setState(() => _index = page),
                            children: _pages,
                          ),
                          // Cover tap flips the page. Once open, the button can be tapped.
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: _index > 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: _flip,
                              ),
                            ),
                          ),
                        ],
                      )
                      : _CoverFace(ownerName: widget.ownerName),
            ),
          ),
        );
      },
    );
  }
}

class _CoverFace extends StatelessWidget {
  const _CoverFace({required this.ownerName});

  final String ownerName;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.journalCover,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage(AppConstants.journalCover),
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
            filterQuality: FilterQuality.high,
          ),
          Positioned(
            top: 36,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 202,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  "${ownerName.toUpperCase()}\u2019S JOURNAL",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontFamily: AppConstants.arvo,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1,
                    letterSpacing: 0,
                    color: AppColors.journalPlate,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Inside page shown after the cover turns.
class _OpenJournalPage extends StatelessWidget {
  const _OpenJournalPage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.journalPage,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ClipRect(
              child: Transform.scale(
                scale: 1.04,
                child: Image(
                  image: AssetImage(AppConstants.journalPage),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 36, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppConstants.journalQuill,
                  width: 34,
                  height: 68,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerLeft,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Your Thoughts\nDeserves A Place',
                  style: TextStyle(
                    fontFamily: AppConstants.geist,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    height: 1.15,
                    letterSpacing: -0.4,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Start Your First Entry And Begin Your\nJournalising Journey Today',
                  style: TextStyle(
                    fontFamily: AppConstants.satoshi,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.journalMuted,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [AppColors.journalAccent, AppColors.primary],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Write entry — UI only'),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: AppColors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Write Your Frist Entry',
                                style: TextStyle(
                                  fontFamily: AppConstants.satoshi,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
