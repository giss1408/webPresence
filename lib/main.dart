import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/app_palette.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/config/environment.dart';
import 'package:flutter_website/config/modern_theme_builder.dart';
import 'package:flutter_website/providers/theme_provider.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/services/analytics_service.dart';
import 'package:flutter_website/services/error_handler.dart';
import 'package:flutter_website/ui/block_wrapper.dart';
import 'package:flutter_website/ui/carousel/carousel.dart';
import 'package:flutter_website/ui/blocks.dart';
import 'package:flutter_website/ui/section_nav.dart';
import 'package:flutter_website/ui/showcase/app_showcase.dart';
import 'package:flutter_website/ui/showcase/offline_sync_demo.dart';
import 'package:flutter_website/components/motion.dart';
import 'package:flutter_website/pages/analytics_dashboard_page.dart';
import 'package:flutter_website/pages/portfolio_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ErrorHandler.setupGlobalErrorHandler();

  final localeProvider = LocaleProvider();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: MyApp(localeProvider: localeProvider),
    ),
  );

  AnalyticsService().trackEvent('app_initialized', parameters: {
    'version': AppConfig.appVersion,
    'environment': AppConfig.environmentName,
  });
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  const MyApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, _) {
        return MaterialApp(
          onGenerateTitle: (_) => localeProvider.tr('app.title'),
          locale: localeProvider.flutterLocale,
          supportedLocales: const [Locale('fr'), Locale('en'), Locale('de')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ModernThemeBuilder.buildLightTheme(),
          darkTheme: ModernThemeBuilder.buildDarkTheme(),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const _HomePage(),
            '/portfolio': (context) => const PortfolioPage(),
            // Internal in-memory analytics view: debug builds only.
            if (kDebugMode)
              '/analytics': (context) => const AnalyticsDashboardPage(),
          },
        );
      },
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();
  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Track page view
    AnalyticsService().trackPageView('home');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 66),
        child: Builder(
          builder: (scaffoldCtx) => WebsiteMenuBar(
            onMenuPressed: () => WebsiteMenuBar.showMenu(scaffoldCtx),
          ),
        ),
      ),
      // A Column (not a lazy ListView) so every section is laid out and
      // the menu / in-page links can scroll to it.
      body: DefaultTextStyle.merge(
        // Sections leave body text uncolored so it follows the theme.
        style: TextStyle(color: context.palette.textPrimary),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: blocks),
        ),
      ),
    );
  }
}

List<Widget> blocks = [
  // ── Hero ────────────────────────────────────────────────────────────────────
  RepaintBoundary(key: HomeSections.top, child: const Carousel()),
  // ── Value proposition ────────────────────────────────────────────────────────
  const Reveal(child: BlockWrapper(GetStarted())),
  // ── Live app demo in a phone (iOS / Android) ─────────────────────────────────
  Reveal(child: BlockWrapper(const AppShowcase(), key: HomeSections.demo)),
  // ── Digital solutions Africa (full-bleed photo band) ────────────────────────
  DigitalSolutionsAfrica(key: HomeSections.africa),
  // ── Social proof numbers (count up on scroll) ────────────────────────────────
  const Reveal(child: BlockWrapper(StatsRow())),
  // ── Core expertises (cards reveal one by one) ────────────────────────────────
  BlockWrapper(const Features(), key: HomeSections.expertise),
  // ── Service detail panels (image + text) ─────────────────────────────────────
  ServicesShowcase(key: HomeSections.services),
  // ── Offline-first sync animation ─────────────────────────────────────────────
  const Reveal(child: BlockWrapper(OfflineSyncDemo())),
  // ── How we work ──────────────────────────────────────────────────────────────
  BlockWrapper(const ProcessSteps(), key: HomeSections.process),
  // ── MVP offer and starting price ─────────────────────────────────────────────
  Reveal(child: BlockWrapper(const PricingOffer(), key: HomeSections.pricing)),
  // ── Client testimonials ───────────────────────────────────────────────────────
  const BlockWrapper(Testimonials()),
  // ── Contact CTA ───────────────────────────────────────────────────────────────
  Reveal(
      child: BlockWrapper(const InstallFlutter(), key: HomeSections.contact)),
  // ── Footer ────────────────────────────────────────────────────────────────────
  const Footer(),
];
