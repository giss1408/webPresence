import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_website/config/environment.dart';
import 'package:flutter_website/config/modern_theme_builder.dart';
import 'package:flutter_website/providers/theme_provider.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:flutter_website/services/analytics_service.dart';
import 'package:flutter_website/services/error_handler.dart';
import 'package:flutter_website/components/floating_whatsapp_button.dart';
import 'package:flutter_website/ui/block_wrapper.dart';
import 'package:flutter_website/ui/carousel/carousel.dart';
import 'package:flutter_website/ui/blocks.dart';
import 'package:flutter_website/pages/travel_page.dart';
import 'package:flutter_website/pages/immobilier_page.dart';
import 'package:flutter_website/pages/loisir_page.dart';
import 'package:flutter_website/pages/tourism_page.dart';
import 'package:flutter_website/pages/analytics_dashboard_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';


void main() async {
  // Minimal startup - defer non-critical initialization
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize critical services only
  final themeProvider = ThemeProvider()..initializeTheme();
  final localeProvider = LocaleProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider.value(value: localeProvider),
      ],
      child: MyApp(localeProvider: localeProvider),
    ),
  );

  // Defer non-critical initialization to first frame
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      // Setup error handler asynchronously
      ErrorHandler.setupGlobalErrorHandler();

      // Track app initialization
      AnalyticsService().trackEvent('app_initialized', parameters: {
        'version': AppConfig.appVersion,
        'environment': AppConfig.isDevelopment ? 'development' : 'production',
      });
    } catch (e) {
      if (AppConfig.isDevelopment) {
        print('Deferred initialization error: $e');
      }
    }
  });
}

class MyApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  const MyApp({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Regisse__ #Business Solutions — SaaS, Design & Développement Sur Mesure',
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
          debugShowCheckedModeBanner: AppConfig.isDevelopment,
          builder: (context, widget) => ResponsiveBreakpoints.builder(
            child: Builder(builder: (context) {
              return ResponsiveScaledBox(
                width: ResponsiveValue<double?>(context,
                    defaultValue: null,
                    conditionalValues: [
                      const Condition.equals(name: 'MOBILE_SMALL', value: 480),
                    ]).value,
                child: ClampingScrollWrapper.builder(context, widget!),
              );
            }),
            breakpoints: [
              const Breakpoint(start: 0, end: 480, name: 'MOBILE_SMALL'),
              const Breakpoint(start: 481, end: 850, name: MOBILE),
              const Breakpoint(start: 850, end: 1080, name: TABLET),
              const Breakpoint(start: 1081, end: double.infinity, name: DESKTOP),
            ],
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const _HomePage(),
            '/travel': (context) => const TravelPage(),
            '/immobilier': (context) => const ImmobilierPage(),
            '/loisir': (context) => const LoisirPage(),
            '/tourism': (context) => const TourismPage(),
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
  bool _menuOpen = false;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Track page view
    AnalyticsService().trackPageView('home');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openMenu(BuildContext ctx) {
    final future = WebsiteMenuBar.showMenu(ctx);
    if (mounted) setState(() => _menuOpen = true);
    future.then(
      (_) {
        if (mounted) setState(() => _menuOpen = false);
      },
      onError: (_) {
        if (mounted) setState(() => _menuOpen = false);
      },
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 66),
        child: Builder(
          builder: (scaffoldCtx) => WebsiteMenuBar(
            onMenuPressed: () => _openMenu(scaffoldCtx),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: blocks.length,
            itemBuilder: (context, index) => blocks[index],
          ),
          const FloatingWhatsAppButton(
            templateKey: 'general',
          ),
        ],
      ),
      bottomNavigationBar: _menuOpen
          ? null
          : SafeArea(top: false, bottom: true, child: const CompactFooterBanner()),
      // Floating action button for scroll to top
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget? _buildFloatingActionButton() {
    return StreamBuilder(
      stream: _scrollController.positions.isNotEmpty
          ? Stream.periodic(const Duration(milliseconds: 500))
          : null,
      builder: (context, snapshot) {
        final showFab = _scrollController.hasClients &&
            _scrollController.offset > 300;

        if (!showFab) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: _scrollToTop,
          tooltip: 'Back to top',
          child: const Icon(Icons.arrow_upward),
        );
      },
    );
  }
}

List<Widget> blocks = [
  // ── Hero ────────────────────────────────────────────────────────────────────
  LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 768;
      final double carouselHeight;

      if (isMobile) {
        // Use the taller layout so FittedBox produces a bigger carousel on mobile
        // Container height × (screenWidth / 1200) = displayed height
        // 960 × (375 / 1200) ≈ 300px displayed → occupies ~40% of viewport
        carouselHeight = 960;
      } else {
        carouselHeight = 640;
      }

      return FittedBox(
        fit: BoxFit.fitWidth,
        clipBehavior: Clip.hardEdge,
        child: Container(
          width: 1200,
          height: carouselHeight,
          alignment: Alignment.center,
          child: RepaintBoundary(child: Carousel()),
        ),
      );
    },
  ),


  // ── Value proposition ────────────────────────────────────────────────────────
  const BlockWrapper(GetStarted()),
  // ── Social proof numbers ─────────────────────────────────────────────────────
  const BlockWrapper(StatsRow()),
  // ── Core expertises ──────────────────────────────────────────────────────────
  const BlockWrapper(Features()),
  // ── Service detail panels (image + text) ─────────────────────────────────────
  const ServicesShowcase(),
  // ── How we work ──────────────────────────────────────────────────────────────
  const BlockWrapper(ProcessSteps()),
  // ── Client testimonials ───────────────────────────────────────────────────────
  const BlockWrapper(Testimonials()),
  // ── Digital solutions Africa ─────────────────────────────────────────────────
  const BlockWrapper(DigitalSolutionsAfrica()),

  // ── Contact CTA ───────────────────────────────────────────────────────────────
  const BlockWrapper(InstallFlutter()),
  // ── Footer ────────────────────────────────────────────────────────────────────
  const Footer(),
];
