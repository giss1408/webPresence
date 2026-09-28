import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/services/whatsapp_service.dart';
import 'package:flutter_website/pages/travel_page.dart';
import 'package:flutter_website/pages/immobilier_page.dart';
import 'package:flutter_website/pages/loisir_page.dart';
import 'package:flutter_website/pages/tourism_page.dart';
import 'package:flutter_website/providers/theme_provider.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/ui/section_nav.dart';
import 'package:flutter_website/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WebsiteMenuBar extends StatelessWidget {
  const WebsiteMenuBar({super.key, this.onMenuPressed});

  final VoidCallback? onMenuPressed;

  /// Opens a navigation bottom-sheet menu. Ported from flutter_web's NavBar.
  /// Returns a Future that completes when the sheet is dismissed.
  static Future<void> showMenu(BuildContext context) {
    // Use read with listen: false for static method that's called from event handler
    final localeProvider = context.read<LocaleProvider>();
    final palette = context.palette;
    final menuItems = <(String, IconData, VoidCallback)>[
      (
        localeProvider.tr('menu.home'),
        Icons.home,
        () => scrollToSection(context, HomeSections.top)
      ),
      (
        localeProvider.tr('menu.services'),
        Icons.business_center,
        () => scrollToSection(context, HomeSections.expertise)
      ),
      (
        localeProvider.tr('dsa.title'),
        Icons.public,
        () => scrollToSection(context, HomeSections.africa)
      ),
      (
        localeProvider.tr('menu.demo'),
        Icons.phone_iphone,
        () => scrollToSection(context, HomeSections.demo)
      ),
      (
        localeProvider.tr('menu.portfolio'),
        Icons.workspace_premium,
        () => Navigator.pushNamed(context, '/portfolio')
      ),
      (
        localeProvider.tr('menu.contact'),
        Icons.contact_mail,
        () => scrollToSection(context, HomeSections.contact)
      ),
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: context.palette.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      localeProvider.tr('menu.title'),
                      style: headlineSecondaryTextStyle.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: palette.accent,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close, color: palette.accent),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Nav items
                for (final (label, icon, onSelected) in menuItems)
                  ListTile(
                    leading: Icon(icon, color: context.palette.textMuted),
                    title: Text(
                      label,
                      style: bodyTextStyle.copyWith(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      onSelected();
                    },
                  ),
                const SizedBox(height: 16),
                // CTA
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      WhatsAppService.openWhatsApp(
                        message: localeProvider.tr('wa.project'),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(primary),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16)),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    child: Text(
                      localeProvider.tr('menu.start_project'),
                      style:
                          buttonTextStyle.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final palette = context.palette;
    final navLinkColor = palette.textSecondary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 720;
        final isVeryCompact = constraints.maxWidth < 560;
        final showBrandText = constraints.maxWidth >= 680;

        return Container(
          height: 66,
          decoration: BoxDecoration(color: palette.header, boxShadow: [
            BoxShadow(
              color: Color(context.isDark ? 0x66000000 : 0x1A000000),
              offset: const Offset(0, 2),
              blurRadius: 4,
            )
          ]),
          padding: EdgeInsets.symmetric(
            horizontal: isVeryCompact ? 8 : 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              // Hamburger — opens the navigation bottom-sheet menu
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onMenuPressed,
                  child: Padding(
                      padding: EdgeInsets.only(right: isVeryCompact ? 8 : 16),
                      child: Icon(Icons.menu,
                          color: palette.textPrimary, size: 28)),
                ),
              ),
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => scrollToSection(context, HomeSections.top),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(0, 5, isVeryCompact ? 6 : 16, 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/images/logo.svg",
                                  height: 36, width: 36, fit: BoxFit.contain),
                              if (showBrandText) ...[
                                const SizedBox(width: 10),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Regisse",
                                        style:
                                            headlineSecondaryTextStyle.copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: palette.textPrimary),
                                      ),
                                      TextSpan(
                                        text: "__",
                                        style:
                                            headlineSecondaryTextStyle.copyWith(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: palette.accent),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (!context.isMobile)
                for (final (key, page) in <(String, Widget)>[
                  ('nav.travel', const TravelPage()),
                  ('nav.tours', const TourismPage()),
                  ('nav.immobilier', const ImmobilierPage()),
                  ('nav.loisir', const LoisirPage()),
                ])
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => page),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: navLinkColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: context.isDesktop ? 16 : 10),
                    ),
                    child: Text(localeProvider.tr(key),
                        style: const TextStyle(
                            fontSize: 16, fontFamily: fontFamily)),
                  ),
              if (!isCompact)
                IconButton(
                  onPressed: () => openUrl('https://www.youtube.com/@regisse'),
                  tooltip: 'YouTube',
                  icon: ImageIcon(
                      const AssetImage("assets/images/icon_youtube_64x.png"),
                      color: navLinkColor,
                      size: 24),
                ),
              IconButton(
                onPressed: () => context
                    .read<ThemeProvider>()
                    .toggleTheme(Theme.of(context).brightness),
                tooltip: localeProvider
                    .tr(context.isDark ? 'theme.light' : 'theme.dark'),
                icon: Icon(
                  context.isDark ? Icons.light_mode : Icons.dark_mode,
                  color: navLinkColor,
                  size: 24,
                ),
              ),
              // Language Switcher
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isVeryCompact ? 4 : 8),
                child: LanguageSwitcherMenu(
                  padding: EdgeInsets.symmetric(
                    horizontal: isVeryCompact ? 4 : 8,
                    vertical: isVeryCompact ? 4 : 6,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeProvider = context.watch<LocaleProvider>();
    final isNarrow = MediaQuery.of(context).size.width < 520;
    return Container(
      decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border)),
      margin: blockMargin.copyWith(top: 40),
      padding: EdgeInsets.symmetric(
          horizontal: isNarrow ? 20 : 40, vertical: isNarrow ? 40 : 56),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            children: [
              // ── Origin badge ─────────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.accentSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.public, size: 14, color: palette.accent),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        localeProvider.tr('gs.badge'),
                        style: bodyTextStyle.copyWith(
                          fontSize: 12,
                          color: palette.accent,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Hero headline ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 16),
                child: Text(
                  localeProvider.tr('gs.headline'),
                  style: headlineTextStyle.copyWith(
                      fontSize: isNarrow ? 28 : 38, height: 1.25),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── Sub-headline ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text(
                  localeProvider.tr('gs.subheadline'),
                  style: bodyTextStyle.copyWith(
                      fontSize: isNarrow ? 16 : 18, height: 1.7),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── Three value pillars ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ResponsiveRowColumn(
                  layout: context.isMobile
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  rowSpacing: 24,
                  columnSpacing: 16,
                  children: [
                    for (final (icon, n) in const [
                      (Icons.rocket_launch_outlined, 1),
                      (Icons.verified_user_outlined, 2),
                      (Icons.trending_up, 3),
                    ])
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        rowFit: FlexFit.tight,
                        child: _ValuePillar(
                          icon: icon,
                          stat: localeProvider.tr('gs.pillar${n}_stat'),
                          label: localeProvider.tr('gs.pillar${n}_label'),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Body description ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: RichText(
                  text: TextSpan(
                    style: bodyTextStyle.copyWith(fontSize: 16, height: 1.8),
                    children: [
                      TextSpan(text: localeProvider.tr('gs.body_intro')),
                      TextSpan(
                          text: localeProvider.tr('gs.body_highlight'),
                          style: bodyTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: palette.accent)),
                      TextSpan(text: localeProvider.tr('gs.body_mid')),
                      TextSpan(
                          text: localeProvider.tr('gs.body_highlight2'),
                          style: bodyTextStyle.copyWith(
                              fontSize: 16, color: palette.accent)),
                      TextSpan(text: localeProvider.tr('gs.body_mid2')),
                      TextSpan(
                          text: localeProvider.tr('gs.body_highlight3'),
                          style: bodyTextStyle.copyWith(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: palette.accent)),
                      TextSpan(text: localeProvider.tr('gs.body_end')),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // ── CTA buttons ───────────────────────────────────────────────
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  TextButton(
                    onPressed: () => WhatsAppService.openWhatsApp(
                      message: localeProvider.tr('wa.project'),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(primary),
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return buttonPrimaryDark;
                            }
                            if (states.contains(WidgetState.focused) ||
                                states.contains(WidgetState.pressed)) {
                              return buttonPrimaryDarkPressed;
                            }
                            return primary;
                          },
                        ),
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 48)),
                        side: WidgetStateProperty.resolveWith<BorderSide>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.focused) ||
                              states.contains(WidgetState.pressed)) {
                            return const BorderSide(
                                width: 3, color: buttonPrimaryPressedOutline);
                          }
                          return const BorderSide(
                              width: 3, color: Colors.transparent);
                        })),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(localeProvider.tr('gs.cta_primary'),
                                style: buttonTextStyle.copyWith(fontSize: 17))),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/portfolio'),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      side: BorderSide(color: palette.accent, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 32),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_circle_outline,
                            size: 22, color: palette.accent),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Text(localeProvider.tr('gs.cta_secondary'),
                                style: buttonTextStyle.copyWith(
                                    fontSize: 16, color: palette.accent))),
                      ],
                    ),
                  ),
                ],
              ),

              // ── Social proof footnote ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  isNarrow
                      ? localeProvider.tr('gs.footnote').replaceAll('   ', '\n')
                      : localeProvider.tr('gs.footnote'),
                  style: bodyTextStyle.copyWith(
                      fontSize: 13, color: palette.textMuted, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A compact value-pillar card used inside [GetStarted].
class _ValuePillar extends StatelessWidget {
  final IconData icon;
  final String stat;
  final String label;

  const _ValuePillar({
    required this.icon,
    required this.stat,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: palette.accentSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: palette.accent, size: 32),
          const SizedBox(height: 10),
          Text(stat,
              style: headlineSecondaryTextStyle.copyWith(
                  fontSize: 22, color: palette.accent),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(label,
              style: bodyTextStyle.copyWith(
                  fontSize: 13, color: palette.textSecondary),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeProvider = context.watch<LocaleProvider>();
    final bool isDesktop = context.isDesktop;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border)),
      margin: blockMargin,
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 25, vertical: isDesktop ? 72 : 48),
      child: Column(
        children: [
          // ── Section header ───────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(localeProvider.tr('features.badge'),
                style: bodyTextStyle.copyWith(
                    fontSize: 11,
                    color: palette.accent,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 18),
          Text(
            localeProvider.tr('features.title'),
            style: headlineTextStyle.copyWith(fontSize: isDesktop ? 32 : 26),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            localeProvider.tr('features.subtitle'),
            style: bodyTextStyle.copyWith(
                fontSize: 16, color: palette.textSecondary, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),

          // ── Three feature cards ──────────────────────────────────────────
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            columnMainAxisSize: MainAxisSize.min,
            rowSpacing: 32,
            columnSpacing: 32,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 0),
                    child: _FeatureCard(
                      imagePath: "assets/images/icon_development.png",
                      tag: localeProvider.tr('features.card1_tag'),
                      title: localeProvider.tr('features.card1_title'),
                      description: localeProvider.tr('features.card1_desc'),
                      linkLabel: localeProvider.tr('features.card1_link'),
                      onLinkTap: () =>
                          scrollToSection(context, HomeSections.process),
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 120),
                    child: _FeatureCard(
                      imagePath: "assets/images/icon_ui.png",
                      tag: localeProvider.tr('features.card2_tag'),
                      title: localeProvider.tr('features.card2_title'),
                      description: localeProvider.tr('features.card2_desc'),
                      linkLabel: localeProvider.tr('features.card2_link'),
                      onLinkTap: () =>
                          Navigator.pushNamed(context, '/portfolio'),
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 240),
                    child: _FeatureCard(
                      imagePath: "assets/images/icon_performance.png",
                      tag: localeProvider.tr('features.card3_tag'),
                      title: localeProvider.tr('features.card3_title'),
                      description: localeProvider.tr('features.card3_desc'),
                      linkLabel: localeProvider.tr('features.card3_link'),
                      onLinkTap: () =>
                          scrollToSection(context, HomeSections.africa),
                    )),
              ),
            ],
          ),

          // ── Bottom CTA ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: OutlinedButton(
              onPressed: () => scrollToSection(context, HomeSections.services),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: palette.accent, width: 1.5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child: Text(localeProvider.tr('features.cta'),
                          style: bodyTextStyle.copyWith(
                              color: palette.accent,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: palette.accent, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A self-contained feature card used inside [Features].
class _FeatureCard extends StatelessWidget {
  final String imagePath;
  final String tag;
  final String title;
  final String description;
  final String linkLabel;
  final VoidCallback onLinkTap;

  const _FeatureCard({
    required this.imagePath,
    required this.tag,
    required this.title,
    required this.description,
    required this.linkLabel,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle
          buildMaterialIconCircle(context, imagePath, 64),
          const SizedBox(height: 20),

          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(tag,
                style: bodyTextStyle.copyWith(
                    fontSize: 11,
                    color: palette.accent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8)),
          ),
          const SizedBox(height: 12),

          // Title
          Text(title, style: headlineSecondaryTextStyle.copyWith(fontSize: 20)),
          const SizedBox(height: 8),

          // Divider
          Container(
              width: 32,
              height: 2,
              color: palette.accent,
              margin: const EdgeInsets.only(bottom: 14)),

          // Description
          Text(description,
              style: bodyTextStyle.copyWith(
                  fontSize: 15, height: 1.7, color: palette.textSecondary)),
          const SizedBox(height: 20),

          // Learn-more link
          GestureDetector(
            onTap: onLinkTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(linkLabel,
                  style: bodyTextStyle.copyWith(
                      fontSize: 14,
                      color: palette.accent,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class InstallFlutter extends StatelessWidget {
  const InstallFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeProvider = context.watch<LocaleProvider>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          // Dark background differentiates this conversion-CTA block.
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(12)),
      margin: blockMargin,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 64),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              // ── Eyebrow ─────────────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: palette.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: palette.accent.withOpacity(0.4)),
                ),
                child: Text(localeProvider.tr('install.badge'),
                    style: bodyTextStyle.copyWith(
                        fontSize: 11,
                        color: const Color(0xFF7DC8FD),
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              // ── Headline ────────────────────────────────────────────────
              Text(
                localeProvider.tr('install.headline'),
                style: headlineTextStyle.copyWith(
                    fontSize: 36, color: Colors.white, height: 1.2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // ── Sub-headline ─────────────────────────────────────────────
              Text(
                localeProvider.tr('install.subheadline'),
                style: bodyTextStyle.copyWith(
                    fontSize: 17, color: const Color(0xFFB0BEC5), height: 1.7),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // ── CTA row ──────────────────────────────────────────────────
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 12,
                children: [
                  TextButton(
                    onPressed: () => WhatsAppService.openWhatsApp(
                      message: localeProvider.tr('wa.appointment'),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(primary),
                        overlayColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.hovered)) {
                              return buttonPrimaryDark;
                            }
                            if (states.contains(WidgetState.focused) ||
                                states.contains(WidgetState.pressed)) {
                              return buttonPrimaryDarkPressed;
                            }
                            return primary;
                          },
                        ),
                        shape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)))),
                        padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 48)),
                        side: WidgetStateProperty.resolveWith<BorderSide>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.focused) ||
                              states.contains(WidgetState.pressed)) {
                            return const BorderSide(
                                width: 3, color: buttonPrimaryPressedOutline);
                          }
                          return const BorderSide(
                              width: 3, color: Colors.transparent);
                        })),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                            child: Text(
                                localeProvider.tr('install.cta_primary'),
                                style: buttonTextStyle.copyWith(fontSize: 17))),
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_outlined,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/portfolio'),
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      side: const BorderSide(
                          color: Color(0xFF4A6F8A), width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 32),
                    ),
                    child: Text(localeProvider.tr('install.cta_secondary'),
                        style: buttonTextStyle.copyWith(
                            fontSize: 16, color: const Color(0xFFB0BEC5))),
                  ),
                ],
              ),

              // ── Trust badges ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  MediaQuery.of(context).size.width < 520
                      ? localeProvider
                          .tr('install.trust')
                          .replaceAll('   ', '\n')
                      : localeProvider.tr('install.trust'),
                  style: bodyTextStyle.copyWith(
                      fontSize: 13,
                      color: const Color(0xFF607D8B),
                      height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── StatsRow ─────────────────────────────────────────────────────────────────
class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isMobile = context.isMobile;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A3D8F), primary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: blockMargin,
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 48),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowMainAxisAlignment: MainAxisAlignment.spaceAround,
        columnSpacing: 32,
        children: [
          ResponsiveRowColumnItem(
              child: _StatItem(
                  value: '50+', label: localeProvider.tr('stats.projects'))),
          ResponsiveRowColumnItem(
              child: _StatItem(
                  value: '4', label: localeProvider.tr('stats.countries'))),
          ResponsiveRowColumnItem(
              child: _StatItem(
                  value: localeProvider.tr('stats.satisfaction_value'),
                  label: localeProvider.tr('stats.satisfaction'))),
          ResponsiveRowColumnItem(
              child: _StatItem(
                  value: localeProvider.tr('stats.ttm_value'),
                  label: localeProvider.tr('stats.time_to_market'))),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CountUp(value,
            style: headlineTextStyle.copyWith(
                fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(label,
            style: bodyTextStyle.copyWith(
                fontSize: 13, color: Colors.white70, letterSpacing: 0.8),
            textAlign: TextAlign.center),
      ],
    );
  }
}

// ─── ServicesShowcase ─────────────────────────────────────────────────────────
class ServicesShowcase extends StatelessWidget {
  const ServicesShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    void openPortfolio() => Navigator.pushNamed(context, '/portfolio');
    return MaxWidthBox(
      maxWidth: 1200,
      child: Column(
        children: [
          Reveal(
            child: _ServicePanel(
              tag: localeProvider.tr('ss.panel1_tag'),
              title: localeProvider.tr('ss.panel1_title'),
              description: localeProvider.tr('ss.panel1_desc'),
              linkLabel: localeProvider.tr('ss.panel1_link'),
              imagePath: "assets/images/stock-market-2616931_1280.jpg",
              imageOnLeft: false,
              onLinkTap: openPortfolio,
            ),
          ),
          Reveal(
            child: _ServicePanel(
              tag: localeProvider.tr('ss.panel2_tag'),
              title: localeProvider.tr('ss.panel2_title'),
              description: localeProvider.tr('ss.panel2_desc'),
              linkLabel: localeProvider.tr('ss.panel2_link'),
              imagePath: "assets/images/blackWoman_layer_4_1280.jpg",
              imageOnLeft: true,
              onLinkTap: openPortfolio,
            ),
          ),
          Reveal(
            child: _ServicePanel(
              tag: localeProvider.tr('ss.panel3_tag'),
              title: localeProvider.tr('ss.panel3_title'),
              description: localeProvider.tr('ss.panel3_desc'),
              linkLabel: localeProvider.tr('ss.panel3_link'),
              imagePath: "assets/images/abidjan-web.jpg",
              imageOnLeft: false,
              onLinkTap: () => scrollToSection(context, HomeSections.africa),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServicePanel extends StatelessWidget {
  final String tag;
  final String title;
  final String description;
  final String linkLabel;
  final String imagePath;
  final bool imageOnLeft;
  final VoidCallback onLinkTap;

  const _ServicePanel({
    required this.tag,
    required this.title,
    required this.description,
    required this.linkLabel,
    required this.imagePath,
    required this.imageOnLeft,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDesktop = context.isDesktop;

    final imageWidget = ClipRRect(
      borderRadius: isDesktop ? BorderRadius.zero : BorderRadius.circular(12),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: isDesktop ? 400 : 220,
        width: double.infinity,
      ),
    );

    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(12)),
          child: Text(tag,
              style: bodyTextStyle.copyWith(
                  fontSize: 11,
                  color: palette.accent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9)),
        ),
        const SizedBox(height: 16),
        Text(title,
            style: headlineTextStyle.copyWith(fontSize: 30, height: 1.2)),
        const SizedBox(height: 12),
        Container(
            width: 32,
            height: 2,
            color: palette.accent,
            margin: const EdgeInsets.only(bottom: 16)),
        Text(description,
            style: bodyTextStyle.copyWith(fontSize: 15, height: 1.75)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onLinkTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: Text(linkLabel,
                        style: bodyTextStyle.copyWith(
                            color: palette.accent,
                            fontWeight: FontWeight.bold))),
                const SizedBox(width: 6),
                Icon(Icons.arrow_forward, color: palette.accent, size: 14),
              ],
            ),
          ),
        ),
      ],
    );

    if (!isDesktop) {
      return Container(
        margin: blockMargin,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            const SizedBox(height: 28),
            textWidget,
          ],
        ),
      );
    }

    return Container(
      margin: blockMargin,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: imageOnLeft
              ? [
                  Expanded(flex: 5, child: imageWidget),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: textWidget,
                    ),
                  ),
                ]
              : [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(48),
                      child: textWidget,
                    ),
                  ),
                  Expanded(flex: 5, child: imageWidget),
                ],
        ),
      ),
    );
  }
}

// ─── ProcessSteps ─────────────────────────────────────────────────────────────
class ProcessSteps extends StatelessWidget {
  const ProcessSteps({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final palette = context.palette;
    final isDesktop = context.isDesktop;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: palette.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border)),
      margin: blockMargin,
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 72 : 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(localeProvider.tr('ps.badge'),
                style: bodyTextStyle.copyWith(
                    fontSize: 11,
                    color: palette.accent,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 18),
          Text(
            localeProvider.tr('ps.title'),
            style: headlineTextStyle.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            localeProvider.tr('ps.subtitle'),
            style: bodyTextStyle.copyWith(
                fontSize: 16, color: palette.textSecondary, height: 1.7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowSpacing: 20,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 0),
                    child: _StepCard(
                      number: "01",
                      icon: Icons.lightbulb_outline,
                      title: localeProvider.tr('ps.step1_title'),
                      description: localeProvider.tr('ps.step1_desc'),
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 120),
                    child: _StepCard(
                      number: "02",
                      icon: Icons.design_services_outlined,
                      title: localeProvider.tr('ps.step2_title'),
                      description: localeProvider.tr('ps.step2_desc'),
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 240),
                    child: _StepCard(
                      number: "03",
                      icon: Icons.code_outlined,
                      title: localeProvider.tr('ps.step3_title'),
                      description: localeProvider.tr('ps.step3_desc'),
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 360),
                    child: _StepCard(
                      number: "04",
                      icon: Icons.rocket_launch_outlined,
                      title: localeProvider.tr('ps.step4_title'),
                      description: localeProvider.tr('ps.step4_desc'),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(number,
                  style: headlineTextStyle.copyWith(
                      fontSize: 36,
                      color: palette.numeral,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: palette.accentSoft,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: palette.accent, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
              width: 28,
              height: 2,
              color: palette.accent,
              margin: const EdgeInsets.only(bottom: 10)),
          Text(title, style: headlineSecondaryTextStyle.copyWith(fontSize: 17)),
          const SizedBox(height: 8),
          Text(description,
              style: bodyTextStyle.copyWith(
                  fontSize: 14, height: 1.7, color: palette.textSecondary)),
        ],
      ),
    );
  }
}

// ─── Testimonials ─────────────────────────────────────────────────────────────
class Testimonials extends StatelessWidget {
  const Testimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeProvider = context.watch<LocaleProvider>();
    final isDesktop = context.isDesktop;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: palette.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: palette.border)),
      margin: blockMargin,
      padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24, vertical: isDesktop ? 72 : 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: palette.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(localeProvider.tr('testi.badge'),
                style: bodyTextStyle.copyWith(
                    fontSize: 11,
                    color: palette.accent,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 18),
          Text(
            localeProvider.tr('testi.title'),
            style: headlineTextStyle.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          ResponsiveRowColumn(
            layout: isDesktop
                ? ResponsiveRowColumnType.ROW
                : ResponsiveRowColumnType.COLUMN,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            rowSpacing: 24,
            columnSpacing: 24,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 0),
                    child: _TestimonialCard(
                      quote: localeProvider.tr('testi.quote1'),
                      name: "Amara D.",
                      role: localeProvider
                          .tr('testi.role1_company')
                          .split(' • ')[0],
                      company: "FinnoTech GmbH",
                      avatarColor: const Color(0xFF1565C0),
                      initials: "AD",
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 120),
                    child: _TestimonialCard(
                      quote: localeProvider.tr('testi.quote2'),
                      name: "Isabelle M.",
                      role: localeProvider
                          .tr('testi.role2_company')
                          .split(' • ')[0],
                      company: "Tourisma SA",
                      avatarColor: const Color(0xFF00897B),
                      initials: "IM",
                    )),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 1,
                rowFit: FlexFit.tight,
                child: Reveal(
                    delay: const Duration(milliseconds: 240),
                    child: _TestimonialCard(
                      quote: localeProvider.tr('testi.quote3'),
                      name: "Kofi A.",
                      role: localeProvider
                          .tr('testi.role3_company')
                          .split(' • ')[0],
                      company: "LogiSoft Africa",
                      avatarColor: const Color(0xFFE65100),
                      initials: "KA",
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String name;
  final String role;
  final String company;
  final Color avatarColor;
  final String initials;

  const _TestimonialCard({
    required this.quote,
    required this.name,
    required this.role,
    required this.company,
    required this.avatarColor,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(Icons.star, color: Color(0xFFF59E0B), size: 16),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text("\u201C",
              style: headlineTextStyle.copyWith(
                  fontSize: 48, color: palette.accent, height: 0.8)),
          const SizedBox(height: 10),
          Text(quote,
              style: bodyTextStyle.copyWith(
                  fontSize: 14, height: 1.75, color: palette.textSecondary)),
          const SizedBox(height: 24),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: avatarColor,
                child: Text(initials,
                    style: bodyTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: bodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("$role \u00b7 $company",
                        style: bodyTextStyle.copyWith(
                            fontSize: 12, color: palette.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DigitalSolutionsAfrica extends StatelessWidget {
  const DigitalSolutionsAfrica({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isMobile = context.isMobile;

    Widget card(int n) => _DSACard(
          category: localeProvider.tr('dsa.card${n}_category'),
          title: localeProvider.tr('dsa.card${n}_title'),
          description: localeProvider.tr('dsa.card${n}_desc'),
          features: [
            for (var f = 1; f <= 3; f++)
              localeProvider.tr('dsa.card${n}_feat$f'),
          ],
        );

    // Full-bleed photo band: breaks the rhythm of white cards and puts the
    // Africa focus right under the hero.
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 48),
      decoration: const BoxDecoration(
        color: backgroundDark,
        image: DecorationImage(
          image: AssetImage('assets/images/abidjan-web.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment(0, 0.2),
        ),
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xE60F172A), Color(0xCC0F172A), Color(0xF20F172A)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 40, vertical: isMobile ? 56 : 88),
          child: MaxWidthBox(
            maxWidth: 1200,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.public,
                          size: 14, color: Color(0xFF7DC8FD)),
                      const SizedBox(width: 6),
                      Text(
                        localeProvider.tr('dsa.badge'),
                        style: bodyTextStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF7DC8FD),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  localeProvider.tr('dsa.title'),
                  style: headlineTextStyle.copyWith(
                    fontSize: isMobile ? 30 : 44,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    localeProvider.tr('dsa.subtitle'),
                    style: bodyTextStyle.copyWith(
                      fontSize: isMobile ? 16 : 18,
                      color: Colors.white.withOpacity(0.78),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isMobile ? 36 : 56),
                ResponsiveRowColumn(
                  layout: isMobile
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowSpacing: 20,
                  columnSpacing: 16,
                  children: [
                    for (var n = 1; n <= 3; n++)
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        rowFit: FlexFit.tight,
                        child: card(n),
                      ),
                  ],
                ),
                const SizedBox(height: 40),
                FilledButton.icon(
                  onPressed: () => WhatsAppService.openWhatsApp(
                    message: localeProvider.tr('wa.africa'),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 28),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.chat_bubble_outline,
                      size: 18, color: Colors.white),
                  label: Text(localeProvider.tr('dsa.cta'),
                      style: buttonTextStyle.copyWith(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DSACard extends StatelessWidget {
  final String category;
  final String title;
  final String description;
  final List<String> features;

  const _DSACard({
    required this.category,
    required this.title,
    required this.description,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: palette.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              category,
              style: bodyTextStyle.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: palette.accent,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            title,
            style: headlineSecondaryTextStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: bodyTextStyle.copyWith(
              fontSize: 13,
              color: palette.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          // Features
          ...features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            return Padding(
              padding:
                  EdgeInsets.only(bottom: index < features.length - 1 ? 10 : 0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: palette.accent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: bodyTextStyle.copyWith(
                        fontSize: 12,
                        color: palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final localeProvider = context.watch<LocaleProvider>();
    final isMobile = context.isMobile;
    return Container(
      color: backgroundDark,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: logo + nav links
          ResponsiveRowColumn(
            layout: isMobile
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.start,
            columnCrossAxisAlignment: CrossAxisAlignment.start,
            rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand block
              ResponsiveRowColumnItem(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/logo.svg",
                          height: 36,
                          width: 36,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Regisse",
                                style: headlineSecondaryTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: "__",
                                style: headlineSecondaryTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: palette.accent),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localeProvider.tr('footer.tagline'),
                      style: bodyTextStyle.copyWith(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.55),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Social icons row
                    Row(
                      children: [
                        Tooltip(
                          message: localeProvider.tr('footer.youtube'),
                          child: InkWell(
                            onTap: () {
                              openUrl("https://www.youtube.com/@regisse");
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                "assets/images/icon_youtube_64x.png",
                                height: 24,
                                width: 24,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Nav links block
              ResponsiveRowColumnItem(
                child: Padding(
                  padding: EdgeInsets.only(top: isMobile ? 32 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeProvider.tr('footer.links_title'),
                        style: bodyTextStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: palette.accent,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _FooterLink(
                          label: localeProvider.tr('footer.link_services'),
                          onTap: () =>
                              scrollToSection(context, HomeSections.expertise)),
                      const SizedBox(height: 10),
                      _FooterLink(
                          label: localeProvider.tr('footer.link_cgu'),
                          onTap: () {}),
                      const SizedBox(height: 10),
                      _FooterLink(
                          label: localeProvider.tr('footer.link_security'),
                          onTap: () {}),
                      const SizedBox(height: 10),
                      _FooterLink(
                          label: localeProvider.tr('footer.link_privacy'),
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              // Contact block
              ResponsiveRowColumnItem(
                child: Padding(
                  padding: EdgeInsets.only(top: isMobile ? 32 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localeProvider.tr('footer.contact_title'),
                        style: bodyTextStyle.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: palette.accent,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localeProvider.tr('footer.contact_location'),
                        style: bodyTextStyle.copyWith(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          openUrl("mailto:contact@regisse.de");
                        },
                        child: Text(
                          "contact@regisse.de",
                          style: bodyTextStyle.copyWith(
                            fontSize: 13,
                            color: palette.accent,
                            decoration: TextDecoration.underline,
                            decorationColor: primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Divider
          const SizedBox(height: 40),
          Divider(color: Colors.white.withOpacity(0.10), thickness: 1),
          const SizedBox(height: 20),
          // Bottom bar: copyright
          Text(
            "© ${DateTime.now().year} ${localeProvider.tr('footer.copyright')}",
            style: bodyTextStyle.copyWith(
              fontSize: 12,
              color: Colors.white.withOpacity(0.40),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Text(
        label,
        style: bodyTextStyle.copyWith(
          fontSize: 13,
          color: Colors.white.withOpacity(0.65),
        ),
      ),
    );
  }
}

/// Compact sticky footer banner — sits as [Scaffold.bottomNavigationBar].
/// Tapping it opens a [DraggableScrollableSheet] with the full footer content.
