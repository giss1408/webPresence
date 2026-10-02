/// Comprehensive translation map for FR / EN / DE
/// Keys are organized by component/section for maintainability.
class Translations {
  static const Map<String, Map<String, String>> _data = {
    // ── Global / Shared ──────────────────────────────────────────────
    'app.title': {
      'fr':
          'Regisse__ #Business Solutions — Développement SaaS mobile (iOS, Android, Web)',
      'en':
          'Regisse__ #Business Solutions — Mobile SaaS Development (iOS, Android, Web)',
      'de':
          'Regisse__ #Business Solutions — Mobile-SaaS-Entwicklung (iOS, Android, Web)',
    },
    'menu.home': {'fr': 'Accueil', 'en': 'Home', 'de': 'Startseite'},
    'menu.services': {'fr': 'Services', 'en': 'Services', 'de': 'Leistungen'},
    'menu.portfolio': {
      'fr': 'Réalisations',
      'en': 'Portfolio',
      'de': 'Referenzen'
    },
    'menu.demo': {'fr': 'Démo live', 'en': 'Live demo', 'de': 'Live-Demo'},
    'menu.saas_mobile': {
      'fr': 'SaaS mobile',
      'en': 'Mobile SaaS',
      'de': 'Mobile SaaS'
    },
    'menu.blog': {'fr': 'Blog', 'en': 'Blog', 'de': 'Blog'},
    'menu.contact': {'fr': 'Contact', 'en': 'Contact', 'de': 'Kontakt'},
    'menu.title': {'fr': 'Menu', 'en': 'Menu', 'de': 'Menü'},
    'menu.start_project': {
      'fr': 'Démarrer mon projet',
      'en': 'Start my project',
      'de': 'Mein Projekt starten'
    },

    // ── GetStarted ──────────────────────────────────────────────────
    'gs.badge': {
      'fr': 'SaaS mobile  •  iOS · Android · Web',
      'en': 'Mobile SaaS  •  iOS · Android · Web',
      'de': 'Mobile SaaS  •  iOS · Android · Web',
    },
    'gs.headline': {
      'fr': 'Votre SaaS mobile,\nde l\'idée aux stores',
      'en': 'Your mobile SaaS,\nfrom idea to the app stores',
      'de': 'Ihr Mobile SaaS,\nvon der Idee in die App Stores',
    },
    'gs.subheadline': {
      'fr':
          'Nous concevons, développons et opérons votre produit SaaS mobile : l\'app iOS et Android, le back-end cloud, les abonnements et le paiement mobile — avec la rigueur de l\'ingénierie allemande.',
      'en':
          'We design, build and run your mobile SaaS product: the iOS and Android app, the cloud backend, subscriptions and mobile money — with German engineering rigor.',
      'de':
          'Wir entwerfen, entwickeln und betreiben Ihr Mobile-SaaS-Produkt: die iOS- und Android-App, das Cloud-Backend, Abonnements und Mobile Payment — mit deutscher Ingenieursgründlichkeit.',
    },
    'gs.pillar1_stat': {'fr': '4 semaines', 'en': '4 weeks', 'de': '4 Wochen'},
    'gs.pillar1_label': {
      'fr': 'Pour un MVP publié sur les stores',
      'en': 'To an MVP live in the stores',
      'de': 'Bis zum MVP in den Stores',
    },
    'gs.pillar2_stat': {
      'fr': '1 code',
      'en': '1 codebase',
      'de': '1 Codebasis',
    },
    'gs.pillar2_label': {
      'fr': 'iOS, Android et web',
      'en': 'iOS, Android and web',
      'de': 'iOS, Android und Web',
    },
    'gs.pillar3_stat': {
      'fr': 'Hors-ligne',
      'en': 'Offline-first',
      'de': 'Offline-first',
    },
    'gs.pillar3_label': {
      'fr': 'Fonctionne même sans réseau',
      'en': 'Works even without a network',
      'de': 'Funktioniert auch ohne Netz',
    },
    'gs.body_intro': {
      'fr': 'Vous avez l\'idée, nous livrons ',
      'en': 'You bring the idea, we deliver ',
      'de': 'Sie haben die Idee, wir liefern ',
    },
    'gs.body_highlight': {
      'fr': 'l\'application que vos clients garderont sur leur téléphone',
      'en': 'the app your customers keep on their phone',
      'de': 'die App, die Ihre Kunden auf dem Handy behalten',
    },
    'gs.body_mid': {
      'fr': '. Notre équipe franco-allemande construit ',
      'en': '. Our Franco-German team builds ',
      'de': '. Unser deutsch-französisches Team baut ',
    },
    'gs.body_highlight2': {
      'fr': 'votre SaaS mobile de A à Z',
      'en': 'your mobile SaaS end to end',
      'de': 'Ihr Mobile SaaS von A bis Z',
    },
    'gs.body_mid2': {
      'fr':
          ' — app iOS et Android, back-end cloud, Mobile Money, mode hors-ligne — et le rend ',
      'en':
          ' — iOS and Android app, cloud backend, mobile money, offline mode — and makes it ',
      'de':
          ' — iOS- und Android-App, Cloud-Backend, Mobile Money, Offline-Modus — und macht es ',
    },
    'gs.body_highlight3': {
      'fr': 'rapide, sécurisé et prêt à vendre',
      'en': 'fast, secure and ready to sell',
      'de': 'schnell, sicher und verkaufsbereit',
    },
    'gs.body_end': {
      'fr':
          '. Vous vous concentrez sur vos clients, nous nous occupons de la technique.',
      'en': '. You focus on your customers; we handle the tech.',
      'de': '. Sie kümmern sich um Ihre Kunden, wir um die Technik.',
    },
    'gs.cta_primary': {
      'fr': 'Démarrer mon projet',
      'en': 'Start my project',
      'de': 'Mein Projekt starten'
    },
    'gs.cta_secondary': {
      'fr': 'Voir nos réalisations',
      'en': 'View our portfolio',
      'de': 'Unsere Referenzen ansehen'
    },
    'gs.link_saas': {
      'fr': 'Découvrir notre offre SaaS mobile',
      'en': 'Explore our mobile SaaS service',
      'de': 'Unser Mobile-SaaS-Angebot entdecken',
    },
    'gs.link_blog': {
      'fr': 'Lire nos conseils sur le blog',
      'en': 'Read our tips on the blog',
      'de': 'Tipps in unserem Blog lesen',
    },
    'gs.footnote': {
      'fr':
          '✓ Sans engagement initial   ✓ Accompagnement dédié   ✓ Support continu',
      'en':
          '✓ No commitment required   ✓ Dedicated support   ✓ Continuous assistance',
      'de':
          '✓ Keine Vorabverpflichtung   ✓ Persönliche Betreuung   ✓ Kontinuierlicher Support'
    },

    // ── Hero carousel ────────────────────────────────────────────────
    'carousel.s1_a': {
      'fr': 'Votre SaaS, ',
      'en': 'Your SaaS, ',
      'de': 'Ihr SaaS, ',
    },
    'carousel.s1_b': {
      'fr': 'dans chaque poche',
      'en': 'in every pocket',
      'de': 'in jeder Tasche',
    },
    'carousel.s2_a': {
      'fr': 'Un seul code,',
      'en': 'One codebase,',
      'de': 'Eine Codebasis,',
    },
    'carousel.s2_b': {
      'fr': ' iOS · Android · Web',
      'en': ' iOS · Android · Web',
      'de': ' iOS · Android · Web',
    },
    'carousel.s3_a': {
      'fr': 'Hors-ligne,',
      'en': 'Offline-first,',
      'de': 'Offline-first,',
    },
    'carousel.s3_b': {
      'fr': ' Mobile Money intégré',
      'en': ' mobile money built in',
      'de': ' Mobile Money integriert',
    },
    'carousel.s4_a': {'fr': 'Toujours, ', 'en': 'Always, ', 'de': 'Immer, '},
    'carousel.s4_b': {'fr': 'partout, ', 'en': 'anywhere, ', 'de': 'überall, '},
    'carousel.s4_c': {'fr': 'mobile', 'en': 'mobile', 'de': 'mobil'},
    'carousel.slide': {'fr': 'Diapositive', 'en': 'Slide', 'de': 'Folie'},
    'carousel.previous': {'fr': 'Précédent', 'en': 'Previous', 'de': 'Zurück'},
    'carousel.next': {'fr': 'Suivant', 'en': 'Next', 'de': 'Weiter'},
    'carousel.pause': {'fr': 'Pause', 'en': 'Pause', 'de': 'Pause'},
    'carousel.play': {'fr': 'Lecture', 'en': 'Play', 'de': 'Abspielen'},
    'theme.dark': {'fr': 'Mode sombre', 'en': 'Dark mode', 'de': 'Dunkelmodus'},
    'theme.light': {
      'fr': 'Mode clair',
      'en': 'Light mode',
      'de': 'Heller Modus'
    },
    'back_to_top': {
      'fr': 'Retour en haut',
      'en': 'Back to top',
      'de': 'Nach oben'
    },

    // ── Features ─────────────────────────────────────────────────────
    'features.badge': {
      'fr': 'NOS EXPERTISES',
      'en': 'OUR EXPERTISE',
      'de': 'UNSERE EXPERTISE'
    },
    'features.title': {
      'fr': 'Tout pour lancer et faire grandir votre SaaS mobile',
      'en': 'Everything to launch and grow your mobile SaaS',
      'de': 'Alles, um Ihr Mobile SaaS zu starten und auszubauen',
    },
    'features.subtitle': {
      'fr':
          'L\'app, le cloud et le modèle économique — conçus ensemble, livrés par une seule équipe.',
      'en':
          'The app, the cloud and the business model — designed together, delivered by one team.',
      'de':
          'App, Cloud und Geschäftsmodell — gemeinsam konzipiert, von einem Team geliefert.',
    },
    'features.card1_tag': {
      'fr': 'Delivery',
      'en': 'Delivery',
      'de': 'Lieferung'
    },
    'features.card1_title': {
      'fr': 'Du MVP aux stores en quelques semaines',
      'en': 'From MVP to the stores in weeks',
      'de': 'Vom MVP in die Stores in Wochen',
    },
    'features.card1_desc': {
      'fr':
          'Sprints courts, démo à chaque itération et publication gérée sur l\'App Store et Google Play. Vous testez votre marché vite, puis vous itérez avec de vrais utilisateurs.',
      'en':
          'Short sprints, a demo at every iteration and publishing handled on the App Store and Google Play. Test your market fast, then iterate with real users.',
      'de':
          'Kurze Sprints, eine Demo bei jeder Iteration und die Veröffentlichung im App Store und bei Google Play übernehmen wir. Testen Sie Ihren Markt schnell und iterieren Sie mit echten Nutzern.',
    },
    'features.card1_link': {
      'fr': 'Notre méthode →',
      'en': 'Our method →',
      'de': 'Unsere Methode →'
    },
    'features.card2_tag': {
      'fr': 'Mobile',
      'en': 'Mobile',
      'de': 'Mobile',
    },
    'features.card2_title': {
      'fr': 'Apps natives iOS & Android',
      'en': 'Native iOS & Android apps',
      'de': 'Native iOS- & Android-Apps',
    },
    'features.card2_desc': {
      'fr':
          'Une seule base de code Flutter, un rendu natif sur chaque plateforme : animations fluides, mode sombre, multilingue, notifications push et fonctionnement hors-ligne dès la première version.',
      'en':
          'One Flutter codebase, a native feel on every platform: smooth animations, dark mode, multiple languages, push notifications and offline mode from the first release.',
      'de':
          'Eine Flutter-Codebasis, natives Gefühl auf jeder Plattform: flüssige Animationen, Dunkelmodus, Mehrsprachigkeit, Push-Benachrichtigungen und Offline-Modus ab der ersten Version.',
    },
    'features.card2_link': {
      'fr': 'Essayer la démo live →',
      'en': 'Try the live demo →',
      'de': 'Live-Demo ausprobieren →',
    },
    'features.card3_tag': {
      'fr': 'SaaS & Cloud',
      'en': 'SaaS & Cloud',
      'de': 'SaaS & Cloud',
    },
    'features.card3_title': {
      'fr': 'Un back-end SaaS prêt à vendre',
      'en': 'A SaaS backend ready to sell',
      'de': 'Ein verkaufsfertiges SaaS-Backend',
    },
    'features.card3_desc': {
      'fr':
          'Multi-clients (multi-tenant), rôles et permissions, abonnements, paiement par Orange Money, Wave ou carte, tableau de bord d\'administration et analytics — hébergés de façon sécurisée et conforme au RGPD.',
      'en':
          'Multi-tenant, roles and permissions, subscriptions, payments via Orange Money, Wave or card, admin dashboard and analytics — hosted securely and GDPR-compliant.',
      'de':
          'Mandantenfähig, Rollen und Berechtigungen, Abonnements, Zahlung per Orange Money, Wave oder Karte, Admin-Dashboard und Analytics — sicher und DSGVO-konform gehostet.',
    },
    'features.card3_link': {
      'fr': 'Nos secteurs →',
      'en': 'Our sectors →',
      'de': 'Unsere Branchen →'
    },
    'features.cta': {
      'fr': 'Découvrir notre offre SaaS mobile',
      'en': 'Discover our mobile SaaS service',
      'de': 'Unser Mobile-SaaS-Angebot entdecken',
    },

    // ── DigitalSolutionsAfrica ──────────────────────────────────────
    'dsa.badge': {
      'fr': 'AFRIQUE DIGITALE',
      'en': 'DIGITAL AFRICA',
      'de': 'DIGITALES AFRIKA'
    },
    'dsa.title': {
      'fr': 'SaaS mobiles pour l\'Afrique',
      'en': 'Mobile SaaS for Africa',
      'de': 'Mobile SaaS für Afrika',
    },
    'dsa.subtitle': {
      'fr':
          'Des plateformes adaptées aux réalités locales — mobile-first, hors-ligne, paiement mobile.',
      'en':
          'Platforms tailored to local realities — mobile-first, offline, mobile money.',
      'de':
          'Plattformen, die an lokale Gegebenheiten angepasst sind — Mobile-First, offline, Mobile Payment.'
    },
    'dsa.card1_category': {
      'fr': 'E-Commerce',
      'en': 'E-Commerce',
      'de': 'E-Commerce'
    },
    'dsa.card1_title': {
      'fr': 'Marketplaces adaptées au mobile',
      'en': 'Mobile-Optimized Marketplaces',
      'de': 'Mobile-optimierte Marktplätze'
    },
    'dsa.card1_desc': {
      'fr':
          'Plateformes e-commerce optimisées pour les réseaux 3G/4G, avec paiement via Orange Money, MTN Mobile Money et Wave.',
      'en':
          'E-commerce platforms optimized for 3G/4G networks, with payments via Orange Money, MTN Mobile Money and Wave.',
      'de':
          'E-Commerce-Plattformen optimiert für 3G/4G-Netze, mit Zahlung via Orange Money, MTN Mobile Money und Wave.'
    },
    'dsa.card1_feat1': {
      'fr': 'Paiement mobile intégré',
      'en': 'Integrated mobile payment',
      'de': 'Integrierte Mobile Payment'
    },
    'dsa.card1_feat2': {
      'fr': 'Mode hors-ligne',
      'en': 'Offline mode',
      'de': 'Offline-Modus'
    },
    'dsa.card1_feat3': {
      'fr': 'Catalogue multi-vendeurs',
      'en': 'Multi-vendor catalog',
      'de': 'Multi-Vendor-Katalog'
    },
    'dsa.card2_category': {
      'fr': 'Agriculture',
      'en': 'Agriculture',
      'de': 'Landwirtschaft',
    },
    'dsa.card2_title': {
      'fr': 'AgriTech pour coopératives et filières',
      'en': 'AgriTech for cooperatives and value chains',
      'de': 'AgriTech für Kooperativen und Wertschöpfungsketten',
    },
    'dsa.card2_desc': {
      'fr':
          'Apps de collecte terrain, suivi des producteurs et des récoltes, prix du marché et paiement des planteurs par mobile money — cacao, anacarde, coton, vivrier.',
      'en':
          'Field data collection apps, farmer and harvest tracking, market prices and mobile money payouts to growers — cocoa, cashew, cotton, food crops.',
      'de':
          'Apps zur Felddatenerfassung, Erzeuger- und Erntetracking, Marktpreise und Auszahlung an Bauern per Mobile Money — Kakao, Cashew, Baumwolle, Grundnahrungsmittel.',
    },
    'dsa.card2_feat1': {
      'fr': 'Collecte hors-ligne',
      'en': 'Offline data collection',
      'de': 'Offline-Datenerfassung',
    },
    'dsa.card2_feat2': {
      'fr': 'Géolocalisation des parcelles',
      'en': 'Plot geolocation',
      'de': 'Parzellen-Geolokalisierung',
    },
    'dsa.card2_feat3': {
      'fr': 'Paiement des producteurs',
      'en': 'Farmer payouts',
      'de': 'Auszahlung an Erzeuger',
    },
    'dsa.card3_category': {
      'fr': 'Santé',
      'en': 'Healthcare',
      'de': 'Gesundheit'
    },
    'dsa.card3_title': {
      'fr': 'Télémédecine & HealthTech',
      'en': 'Telemedicine & HealthTech',
      'de': 'Telemedizin & HealthTech'
    },
    'dsa.card3_desc': {
      'fr':
          'Applications de suivi médical, prise de rendez-vous en ligne et téléconsultation pour les zones rurales mal desservies.',
      'en':
          'Medical tracking apps, online appointments and teleconsultation for underserved rural areas.',
      'de':
          'Medizinische Tracking-Apps, Online-Terminvereinbarung und Telekonsultation für unterversorgte ländliche Gebiete.'
    },
    'dsa.card3_feat1': {
      'fr': 'Téléconsultation',
      'en': 'Teleconsultation',
      'de': 'Telekonsultation'
    },
    'dsa.card3_feat2': {
      'fr': 'Dossier patient numérique',
      'en': 'Digital patient records',
      'de': 'Digitale Patientenakten'
    },
    'dsa.card3_feat3': {
      'fr': 'Alertes SMS',
      'en': 'SMS alerts',
      'de': 'SMS-Benachrichtigungen'
    },
    'dsa.cta': {
      'fr': 'Discuter de votre projet',
      'en': 'Discuss your project',
      'de': 'Über Ihr Projekt sprechen'
    },

    // ── InstallFlutter (Contact CTA) ─────────────────────────────────
    'install.badge': {
      'fr': 'PRÊT À DÉCOLLER ?',
      'en': 'READY TO TAKE OFF?',
      'de': 'BEREIT ZUM START?'
    },
    'install.headline': {
      'fr': 'Lançons votre SaaS mobile',
      'en': 'Let\'s launch your mobile SaaS',
      'de': 'Starten wir Ihr Mobile SaaS',
    },
    'install.subheadline': {
      'fr':
          '30 minutes pour cadrer votre MVP : fonctionnalités, plateformes, paiement, budget et calendrier. Sans engagement.',
      'en':
          '30 minutes to scope your MVP: features, platforms, payments, budget and timeline. No commitment.',
      'de':
          '30 Minuten, um Ihr MVP abzustecken: Funktionen, Plattformen, Zahlung, Budget und Zeitplan. Unverbindlich.',
    },
    'install.cta_primary': {
      'fr': 'Prendre rendez-vous',
      'en': 'Book a meeting',
      'de': 'Termin vereinbaren'
    },
    'install.cta_secondary': {
      'fr': 'Voir nos réalisations',
      'en': 'View our portfolio',
      'de': 'Unsere Referenzen ansehen'
    },
    'install.trust': {
      'fr': '✓ Réponse sous 24 h   ✓ Devis gratuit   ✓ Équipe dédiée',
      'en': '✓ Response within 24h   ✓ Free quote   ✓ Dedicated team',
      'de': '✓ Antwort innerhalb 24h   ✓ Kostenloses Angebot   ✓ Festes Team'
    },

    // ── StatsRow ─────────────────────────────────────────────────────

    // ── StatsRow (only claims made elsewhere on the site) ─────────
    'stats.apps': {
      'fr': 'Apps à essayer en direct',
      'en': 'Apps to try live',
      'de': 'Apps live zum Ausprobieren',
    },
    'stats.platforms': {
      'fr': 'Plateformes, un seul code',
      'en': 'Platforms, one codebase',
      'de': 'Plattformen, eine Codebasis',
    },
    'stats.mvp_value': {
      'fr': '4 sem.',
      'en': '4 wks',
      'de': '4 Wo.',
    },
    'stats.mvp': {
      'fr': 'Pour un MVP sur les stores',
      'en': 'To an MVP in the stores',
      'de': 'Bis zum MVP in den Stores',
    },
    'stats.response_value': {
      'fr': '24 h',
      'en': '24 h',
      'de': '24 Std.',
    },
    'stats.response': {
      'fr': 'Pour vous répondre',
      'en': 'To get back to you',
      'de': 'Bis zur Antwort',
    },

    // ── ServicesShowcase ─────────────────────────────────────────────
    'ss.panel1_tag': {
      'fr': 'SAAS MOBILE',
      'en': 'MOBILE SAAS',
      'de': 'MOBILE SAAS',
    },
    'ss.panel1_title': {
      'fr': 'SaaS mobile,\nde l\'app au cloud',
      'en': 'Mobile SaaS,\nfrom app to cloud',
      'de': 'Mobile SaaS,\nvon der App bis zur Cloud',
    },
    'ss.panel1_desc': {
      'fr':
          'Nous construisons tout le produit : l\'app mobile de vos clients, le back-end multi-tenant, l\'espace d\'administration et les tableaux de bord. Authentification, abonnements, notifications push, synchronisation hors-ligne — chaque brique est pensée pour vos utilisateurs et votre modèle économique.',
      'en':
          'We build the whole product: your customers\' mobile app, the multi-tenant backend, the admin area and the dashboards. Authentication, subscriptions, push notifications, offline sync — every building block is designed for your users and your business model.',
      'de':
          'Wir bauen das ganze Produkt: die mobile App Ihrer Kunden, das mandantenfähige Backend, den Admin-Bereich und die Dashboards. Authentifizierung, Abonnements, Push-Benachrichtigungen, Offline-Sync — jeder Baustein ist auf Ihre Nutzer und Ihr Geschäftsmodell ausgelegt.',
    },
    'ss.panel1_link': {
      'fr': 'Voir nos SaaS mobiles',
      'en': 'See our mobile SaaS products',
      'de': 'Unsere Mobile-SaaS-Produkte ansehen',
    },
    'ss.panel2_tag': {
      'fr': 'DESIGN & UX',
      'en': 'DESIGN & UX',
      'de': 'DESIGN & UX'
    },
    'ss.panel2_title': {
      'fr': 'Interfaces qui\ntransforment vos utilisateurs\nen clients',
      'en': 'Interfaces that\nConvert',
      'de': 'Oberflächen die\nKonvertieren'
    },
    'ss.panel2_desc': {
      'fr':
          'Design centré utilisateur, prototypage rapide et tests A/B. Chaque écran est conçu pour réduire la friction, augmenter l\'engagement et refléter votre identité de marque.',
      'en':
          'User-centered design, rapid prototyping and A/B testing. Every screen is designed to reduce friction, increase engagement and reflect your brand identity.',
      'de':
          'Benutzerzentriertes Design, schnelles Prototyping und A/B-Tests. Jeder Bildschirm ist darauf ausgelegt, Reibung zu reduzieren, Engagement zu steigern und Ihre Markenidentität widerzuspiegeln.'
    },
    'ss.panel2_link': {
      'fr': 'Explorer notre approche design',
      'en': 'Explore our design approach',
      'de': 'Unser Design-Ansatz'
    },
    'ss.panel3_tag': {
      'fr': 'EXPANSION INTERNATIONALE',
      'en': 'INTERNATIONAL EXPANSION',
      'de': 'INTERNATIONALE EXPANSION'
    },
    'ss.panel3_title': {
      'fr': 'Solutions pour\nMarchés Globaux',
      'en': 'Solutions for\nGlobal Markets',
      'de': 'Lösungen für\nGlobale Märkte'
    },
    'ss.panel3_desc': {
      'fr':
          'Présents à Berlin, Paris et en Afrique de l\'Ouest, nous aidons nos clients à lancer des produits adaptés à des marchés multiculturels.',
      'en':
          'Based in Berlin, Paris and West Africa, we help our clients launch products adapted to multicultural markets.',
      'de':
          'Mit Standorten in Berlin, Paris und Westafrika helfen wir unseren Kunden, Produkte für multikulturelle Märkte zu launchten.'
    },
    'ss.panel3_link': {
      'fr': 'Découvrir nos marchés',
      'en': 'Discover our markets',
      'de': 'Unsere Märkte entdecken'
    },

    // ── ProcessSteps ─────────────────────────────────────────────────
    'ps.badge': {
      'fr': 'NOTRE MÉTHODE',
      'en': 'OUR METHOD',
      'de': 'UNSERE METHODE'
    },
    'ps.title': {
      'fr': 'De l\'idée à l\'app publiée en 4 étapes',
      'en': 'From idea to published app in 4 steps',
      'de': 'Von der Idee zur veröffentlichten App in 4 Schritten',
    },
    'ps.subtitle': {
      'fr':
          'Un process éprouvé, transparent et conçu pour minimiser le risque tout en maximisant la vélocité.',
      'en':
          'A proven, transparent process designed to minimize risk while maximizing velocity.',
      'de':
          'Ein bewährter, transparenter Prozess, der Risiken minimiert und gleichzeitig die Geschwindigkeit maximiert.'
    },
    'ps.step1_title': {
      'fr': 'Découverte & Stratégie',
      'en': 'Discovery & Strategy',
      'de': 'Entdeckung & Strategie'
    },
    'ps.step1_desc': {
      'fr':
          'Atelier de cadrage pour comprendre vos enjeux métier, vos utilisateurs et vos objectifs de croissance.',
      'en':
          'Workshop to understand your business challenges, users and growth objectives.',
      'de':
          'Workshop zur Ermittlung Ihrer geschäftlichen Herausforderungen, Benutzer und Wachstumsziele.'
    },
    'ps.step2_title': {
      'fr': 'Design & Architecture',
      'en': 'Design & Architecture',
      'de': 'Design & Architektur'
    },
    'ps.step2_desc': {
      'fr':
          'Maquettes mobiles interactives et architecture cloud validées ensemble avant d\'écrire la première ligne de code.',
      'en':
          'Interactive mobile mockups and cloud architecture validated together before writing the first line of code.',
      'de':
          'Interaktive mobile Mockups und Cloud-Architektur werden gemeinsam validiert, bevor die erste Codezeile geschrieben wird.',
    },
    'ps.step3_title': {
      'fr': 'Développement Agile',
      'en': 'Agile Development',
      'de': 'Agile Entwicklung'
    },
    'ps.step3_desc': {
      'fr':
          'Sprints de deux semaines avec démo à chaque itération. Vous validez, on avance — aucune surprise à la livraison.',
      'en':
          'Two-week sprints with demo at every iteration. You validate, we move forward — no surprises at delivery.',
      'de':
          'Zweiwöchige Sprints mit Demo bei jeder Iteration. Sie validieren, wir machen weiter — keine Überraschungen bei der Lieferung.'
    },
    'ps.step4_title': {
      'fr': 'Stores & Support',
      'en': 'App Stores & Support',
      'de': 'App Stores & Support',
    },
    'ps.step4_desc': {
      'fr':
          'Publication sur l\'App Store et Google Play, monitoring continu, mises à jour régulières et accompagnement pour faire grandir votre base d\'utilisateurs.',
      'en':
          'Publishing on the App Store and Google Play, continuous monitoring, regular updates and support to grow your user base.',
      'de':
          'Veröffentlichung im App Store und bei Google Play, kontinuierliches Monitoring, regelmäßige Updates und Begleitung beim Wachstum Ihrer Nutzerbasis.',
    },

    // ── Testimonials ─────────────────────────────────────────────────
    'testi.badge': {
      'fr': 'NOS PREMIERS CLIENTS',
      'en': 'OUR FIRST CLIENTS',
      'de': 'UNSERE ERSTEN KUNDEN',
    },
    'testi.title': {
      'fr': 'Nous démarrons.\nSoyez le premier à nous mettre au défi.',
      'en': 'We\'re just starting.\nBe the first to challenge us.',
      'de': 'Wir fangen gerade an.\nFordern Sie uns als Erster heraus.',
    },
    'testi.subtitle': {
      'fr':
          'Pas encore d\'avis clients à afficher : à vous d\'écrire le premier. En attendant, nos propres apps — Akwaba Ivoire, Djassa, Immoizi — tournent déjà, et vous pouvez les essayer en direct.',
      'en':
          'No client reviews to show yet: yours could be the first. Meanwhile, our own apps — Akwaba Ivoire, Djassa, Immoizi — are already running, and you can try them live.',
      'de':
          'Noch keine Kundenstimmen: Ihre könnte die erste sein. Unsere eigenen Apps — Akwaba Ivoire, Djassa, Immoizi — laufen bereits, und Sie können sie live ausprobieren.',
    },
    'testi.perk1_title': {
      'fr': 'Toute notre attention',
      'en': 'Our full attention',
      'de': 'Unsere volle Aufmerksamkeit',
    },
    'testi.perk1_desc': {
      'fr':
          'Vous échangez directement avec les développeurs qui construisent votre app, sans intermédiaire.',
      'en':
          'You talk directly to the developers building your app, with no middleman.',
      'de':
          'Sie sprechen direkt mit den Entwicklern Ihrer App, ohne Zwischenstelle.',
    },
    'testi.perk2_title': {
      'fr': 'Votre avis compte vraiment',
      'en': 'Your feedback really counts',
      'de': 'Ihr Feedback zählt wirklich',
    },
    'testi.perk2_desc': {
      'fr':
          'Vos retours façonnent nos offres et notre façon de travailler. Vous ne serez pas un client parmi d\'autres.',
      'en':
          'Your feedback shapes our offers and the way we work. You won\'t be just another client.',
      'de':
          'Ihr Feedback prägt unsere Angebote und Arbeitsweise. Sie sind nicht irgendein Kunde.',
    },
    'testi.perk3_title': {
      'fr': 'Une vitrine pour votre projet',
      'en': 'A showcase for your project',
      'de': 'Ein Schaufenster für Ihr Projekt',
    },
    'testi.perk3_desc': {
      'fr':
          'Avec votre accord, votre app figure parmi nos premières références, sur notre site et notre blog.',
      'en':
          'With your consent, your app becomes one of our first references, on our website and blog.',
      'de':
          'Mit Ihrer Zustimmung wird Ihre App eine unserer ersten Referenzen, auf unserer Website und im Blog.',
    },
    'testi.cta': {
      'fr': 'Devenir notre premier client',
      'en': 'Become our first client',
      'de': 'Unser erster Kunde werden',
    },
    'testi.cta_secondary': {
      'fr': 'Essayer nos apps',
      'en': 'Try our apps',
      'de': 'Unsere Apps ausprobieren',
    },
    'wa.first_client': {
      'fr':
          'Bonjour, je veux bien être l\'un de vos premiers clients ! Voici mon projet :',
      'en':
          'Hello, I\'d like to be one of your first clients! Here is my project:',
      'de':
          'Hallo, ich möchte einer Ihrer ersten Kunden sein! Hier ist mein Projekt:',
    },

    // ── Footer ───────────────────────────────────────────────────────
    'footer.tagline': {
      'fr': 'Votre SaaS mobile, conçu pour grandir.',
      'en': 'Your mobile SaaS, built to grow.',
      'de': 'Ihr Mobile SaaS, gebaut zum Wachsen.',
    },
    'footer.links_title': {
      'fr': 'LIENS UTILES',
      'en': 'USEFUL LINKS',
      'de': 'NÜTZLICHE LINKS'
    },
    'footer.link_services': {
      'fr': 'Services',
      'en': 'Services',
      'de': 'Leistungen'
    },
    'footer.link_cgu': {
      'fr': 'Conditions Générales d\'Utilisation',
      'en': 'Terms of Service',
      'de': 'Allgemeine Geschäftsbedingungen'
    },
    'footer.link_security': {
      'fr': 'Sécurité',
      'en': 'Security',
      'de': 'Sicherheit'
    },
    'footer.link_privacy': {
      'fr': 'Confidentialité',
      'en': 'Privacy',
      'de': 'Datenschutz'
    },
    'footer.contact_title': {'fr': 'CONTACT', 'en': 'CONTACT', 'de': 'KONTAKT'},
    'footer.contact_location': {
      'fr': 'Berlin · Paris · Télétravail',
      'en': 'Berlin · Paris · Remote',
      'de': 'Berlin · Paris · Remote'
    },
    'footer.copyright': {
      'fr': 'Regisse__ GmbH. Tous droits réservés.',
      'en': 'Regisse__ GmbH. All rights reserved.',
      'de': 'Regisse__ GmbH. Alle Rechte vorbehalten.'
    },

    // ── WhatsApp button ──────────────────────────────────────────────
    'whatsapp.chat': {
      'fr': 'Discuter sur WhatsApp',
      'en': 'Chat with us on WhatsApp',
      'de': 'Chat auf WhatsApp'
    },

    // ── WhatsApp service messages ────────────────────────────────────
    'wa.general': {
      'fr': 'Bonjour, j\'aimerais en savoir plus sur vos services.',
      'en': 'Hello, I\'d like to learn more about your services.',
      'de': 'Hallo, ich möchte mehr über Ihre Dienstleistungen erfahren.'
    },
    'wa.support': {
      'fr': 'J\'ai une question concernant votre service.',
      'en': 'I have a question about your service.',
      'de': 'Ich habe eine Frage zu Ihrem Service.'
    },
    'wa.project': {
      'fr':
          'Bonjour, j\'aimerais discuter de mon projet digital avec Regisse__. Pouvez-vous m\'aider?',
      'en':
          'Hello, I\'d like to discuss my digital project with Regisse__. Can you help me?',
      'de':
          'Hallo, ich möchte mein digitales Projekt mit Regisse__ besprechen. Können Sie mir helfen?'
    },
    'wa.appointment': {
      'fr':
          'Bonjour, j\'aimerais prendre rendez-vous avec Regisse__ pour discuter de mon projet digital.',
      'en':
          'Hello, I\'d like to book an appointment with Regisse__ to discuss my digital project.',
      'de':
          'Hallo, ich möchte einen Termin mit Regisse__ vereinbaren, um mein digitales Projekt zu besprechen.'
    },
    'wa.africa': {
      'fr':
          'Bonjour, je souhaite discuter d\'une solution digitale pour mon marché en Afrique.',
      'en':
          'Hello, I\'d like to discuss a digital solution for my market in Africa.',
      'de':
          'Hallo, ich möchte eine digitale Lösung für meinen Markt in Afrika besprechen.'
    },

    // ── Pricing (MVP offer), SEO page and blog links ────────────────
    'menu.pricing': {
      'fr': 'Tarifs',
      'en': 'Pricing',
      'de': 'Preise',
    },
    'footer.link_saas_mobile': {
      'fr': 'Développement SaaS mobile',
      'en': 'Mobile SaaS development',
      'de': 'Mobile-SaaS-Entwicklung',
    },
    'pricing.badge': {
      'fr': 'TARIF',
      'en': 'PRICING',
      'de': 'PREISE',
    },
    'pricing.title': {
      'fr': 'Testez votre idée avec un MVP mobile',
      'en': 'Test your idea with a mobile MVP',
      'de': 'Testen Sie Ihre Idee mit einem mobilen MVP',
    },
    'pricing.subtitle': {
      'fr':
          'Un prototype fonctionnel de votre SaaS mobile, entre les mains de vos premiers utilisateurs — avant d\'investir dans la version complète.',
      'en':
          'A working prototype of your mobile SaaS in the hands of your first users — before you invest in the full version.',
      'de':
          'Ein funktionsfähiger Prototyp Ihres Mobile SaaS in den Händen Ihrer ersten Nutzer — bevor Sie in die Vollversion investieren.',
    },
    'pricing.offer': {
      'fr': 'MVP (prototype) SaaS mobile',
      'en': 'Mobile SaaS MVP (prototype)',
      'de': 'Mobile-SaaS-MVP (Prototyp)',
    },
    'pricing.from': {
      'fr': 'à partir de',
      'en': 'from',
      'de': 'ab',
    },
    'pricing.price': {
      'fr': '250 000 FCFA',
      'en': '250,000 FCFA',
      'de': '250.000 FCFA',
    },
    'pricing.price_note': {
      'fr': 'Prix indicatif HT · devis précis après l\'appel de cadrage',
      'en': '≈ 381 € excl. VAT · exact quote after the scoping call',
      'de': '≈ 381 € zzgl. MwSt. · genaues Angebot nach dem Erstgespräch',
    },
    'pricing.cta': {
      'fr': 'Demander mon MVP',
      'en': 'Request my MVP',
      'de': 'Mein MVP anfragen',
    },
    'pricing.included': {
      'fr': 'INCLUS',
      'en': 'INCLUDED',
      'de': 'INKLUSIVE',
    },
    'pricing.item1': {
      'fr': 'Atelier de cadrage et parcours utilisateur',
      'en': 'Scoping workshop and user journey',
      'de': 'Workshop zur Planung und User Journey',
    },
    'pricing.item2': {
      'fr': 'Jusqu\'à 5 écrans clés, à vos couleurs',
      'en': 'Up to 5 key screens in your brand colors',
      'de': 'Bis zu 5 Kernbildschirme in Ihren Markenfarben',
    },
    'pricing.item3': {
      'fr': 'App Android et iOS (une seule base de code Flutter)',
      'en': 'Android and iOS app (one Flutter codebase)',
      'de': 'Android- und iOS-App (eine Flutter-Codebasis)',
    },
    'pricing.item4': {
      'fr': 'Connexion utilisateur et back-end cloud de base',
      'en': 'User login and a basic cloud backend',
      'de': 'Benutzer-Login und ein einfaches Cloud-Backend',
    },
    'pricing.item5': {
      'fr': 'Version de test installable + 1 cycle de retours',
      'en': 'Installable test version + 1 round of feedback',
      'de': 'Installierbare Testversion + 1 Feedbackrunde',
    },
    'pricing.options': {
      'fr':
          'En option : paiement Mobile Money, multi-tenant, abonnements, mode hors-ligne, publication sur l\'App Store et Google Play.',
      'en':
          'Options: mobile money payments, multi-tenancy, subscriptions, offline mode, App Store and Google Play publishing.',
      'de':
          'Optional: Mobile-Money-Zahlung, Mandantenfähigkeit, Abonnements, Offline-Modus, Veröffentlichung im App Store und bei Google Play.',
    },
    'wa.mvp': {
      'fr':
          'Bonjour, je suis intéressé(e) par votre offre MVP SaaS mobile à partir de 250 000 FCFA. Voici mon idée :',
      'en':
          'Hello, I\'m interested in your mobile SaaS MVP offer from 250,000 FCFA. Here is my idea:',
      'de':
          'Hallo, ich interessiere mich für Ihr Mobile-SaaS-MVP-Angebot ab 250.000 FCFA. Hier ist meine Idee:',
    },

    // ── Language switcher ────────────────────────────────────────────
    'lang.fr': {'fr': 'Français', 'en': 'French', 'de': 'Französisch'},
    'lang.en': {'fr': 'Anglais', 'en': 'English', 'de': 'Englisch'},
    'lang.de': {'fr': 'Allemand', 'en': 'German', 'de': 'Deutsch'},

    // ── StatsRow values ─────────────────────────────────────────────

    // ── Footer extras ───────────────────────────────────────────────

    // ── Language switcher ───────────────────────────────────────────
    'lang.tooltip': {
      'fr': 'Langue : {lang} — toucher pour changer',
      'en': 'Language: {lang} — tap to change',
      'de': 'Sprache: {lang} — tippen zum Wechseln',
    },

    // ── Portfolio page ──────────────────────────────────────────────
    'portfolio.heading': {
      'fr': 'Nos réalisations',
      'en': 'Our work',
      'de': 'Unsere Referenzen',
    },
    'portfolio.subtitle': {
      'fr': 'Nos propres produits, conçus pour les marchés africains.',
      'en': 'Our own products, built for African markets.',
      'de': 'Unsere eigenen Produkte, entwickelt für afrikanische Märkte.',
    },
    'portfolio.tourism_title': {
      'fr': 'Akwaba Ivoire',
      'en': 'Akwaba Ivoire',
      'de': 'Akwaba Ivoire',
    },
    'portfolio.tourism_subtitle': {
      'fr': 'Tourisme en Côte d’Ivoire',
      'en': 'Tourism in Côte d’Ivoire',
      'de': 'Tourismus in der Côte d’Ivoire',
    },
    'portfolio.tourism_desc': {
      'fr':
          'Application de voyage : destinations, réservations avec paiement Stripe, guides locaux sur WhatsApp et avis vérifiés, avec une app de gestion du catalogue.',
      'en':
          'Travel app: destinations, bookings with Stripe payment, local guides on WhatsApp and verified reviews, plus a staff app to manage the catalogue.',
      'de':
          'Reise-App: Reiseziele, Buchungen mit Stripe-Zahlung, lokale Guides über WhatsApp und verifizierte Bewertungen, dazu eine App zur Katalogverwaltung.',
    },
    'portfolio.djassa_title': {
      'fr': 'Djassa',
      'en': 'Djassa',
      'de': 'Djassa',
    },
    'portfolio.djassa_subtitle': {
      'fr': 'Inclusion financière des commerçants',
      'en': 'Financial inclusion for merchants',
      'de': 'Finanzielle Inklusion für Händler',
    },
    'portfolio.djassa_desc': {
      'fr':
          'App de caisse pour petits commerçants : chaque vente enregistrée, même sans réseau, devient un historique d’activité. Pensée pour les vieux téléphones Android et le faible débit.',
      'en':
          'Sales app for small merchants: every sale is recorded, even offline, and becomes a business history. Built for old Android phones and low bandwidth.',
      'de':
          'Kassen-App für kleine Händler: Jeder Verkauf wird erfasst, auch offline, und ergibt eine Geschäftshistorie. Für alte Android-Handys und geringe Bandbreite.',
    },
    'portfolio.immoizi_title': {
      'fr': 'Immoizi',
      'en': 'Immoizi',
      'de': 'Immoizi',
    },
    'portfolio.immoizi_subtitle': {
      'fr': 'Gestion immobilière',
      'en': 'Property management',
      'de': 'Immobilienverwaltung',
    },
    'portfolio.immoizi_desc': {
      'fr':
          'Deux apps mobiles, propriétaires et locataires : annonces, baux, loyers, documents et demandes de maintenance.',
      'en':
          'Two mobile apps, for landlords and tenants: listings, leases, rent payments, documents and maintenance requests.',
      'de':
          'Zwei mobile Apps für Vermieter und Mieter: Inserate, Mietverträge, Mietzahlungen, Dokumente und Wartungsanfragen.',
    },

    // ── Live demo, offline-first section ────────────────────────────
    'portfolio.try_demo': {
      'fr': 'Essayer la démo',
      'en': 'Try the demo',
      'de': 'Demo ausprobieren',
    },
    'portfolio.watch': {
      'fr': 'Voir la vidéo',
      'en': 'Watch the video',
      'de': 'Video ansehen',
    },
    'showcase.badge': {
      'fr': 'DÉMO LIVE',
      'en': 'LIVE DEMO',
      'de': 'LIVE-DEMO',
    },
    'showcase.title': {
      'fr': 'Votre future app, en direct',
      'en': 'Your future app, live',
      'de': 'Ihre künftige App, live',
    },
    'showcase.body': {
      'fr':
          'Ce téléphone ne lit pas une vidéo : il exécute du vrai code Flutter, la technologie avec laquelle nous livrons vos apps iOS, Android et web. Touchez-le, faites-le glisser, changez de plateforme.',
      'en':
          'This phone is not playing a video: it runs real Flutter code, the technology we use to ship your iOS, Android and web apps. Tap it, swipe it, switch platforms.',
      'de':
          'Dieses Handy spielt kein Video ab: Es führt echten Flutter-Code aus – die Technologie, mit der wir Ihre iOS-, Android- und Web-Apps liefern. Tippen, wischen, Plattform wechseln.',
    },
    'showcase.point1': {
      'fr': 'Une seule base de code pour iOS, Android et le web',
      'en': 'One codebase for iOS, Android and the web',
      'de': 'Eine Codebasis für iOS, Android und Web',
    },
    'showcase.point2': {
      'fr':
          'Look natif sur chaque plateforme, animations fluides à 60 images/s',
      'en': 'Native look on each platform, smooth 60 fps animations',
      'de': 'Nativer Look auf jeder Plattform, flüssige Animationen mit 60 fps',
    },
    'showcase.point3': {
      'fr': 'Mode sombre et multilingue dès le premier jour',
      'en': 'Dark mode and multiple languages from day one',
      'de': 'Dunkelmodus und Mehrsprachigkeit ab dem ersten Tag',
    },
    'showcase.hint': {
      'fr': 'Touchez ou faites glisser le téléphone',
      'en': 'Tap or swipe the phone',
      'de': 'Handy antippen oder wischen',
    },
    'showcase.portfolio': {
      'fr': 'Voir nos réalisations',
      'en': 'See our work',
      'de': 'Unsere Referenzen ansehen',
    },
    'demo.now': {
      'fr': 'maintenant',
      'en': 'now',
      'de': 'jetzt',
    },
    'demo.ak.step1': {
      'fr': 'Explorer les destinations',
      'en': 'Browse destinations',
      'de': 'Reiseziele entdecken',
    },
    'demo.ak.step2': {
      'fr': 'Découvrir un lieu',
      'en': 'View a destination',
      'de': 'Ein Reiseziel ansehen',
    },
    'demo.ak.step3': {
      'fr': 'Réserver et payer avec Stripe',
      'en': 'Book and pay with Stripe',
      'de': 'Buchen und mit Stripe bezahlen',
    },
    'demo.ak.step4': {
      'fr': 'Confirmation et guide sur WhatsApp',
      'en': 'Confirmation and a guide on WhatsApp',
      'de': 'Bestätigung und Guide über WhatsApp',
    },
    'demo.ak.hello': {
      'fr': 'Bonjour Aya',
      'en': 'Hello Aya',
      'de': 'Hallo Aya',
    },
    'demo.ak.where': {
      'fr': 'Où partir ce week-end ?',
      'en': 'Where to this weekend?',
      'de': 'Wohin am Wochenende?',
    },
    'demo.ak.search': {
      'fr': 'Plages, parcs, culture…',
      'en': 'Beaches, parks, culture…',
      'de': 'Strände, Parks, Kultur…',
    },
    'demo.ak.popular': {
      'fr': 'Populaires',
      'en': 'Popular',
      'de': 'Beliebt',
    },
    'demo.ak.cat_beach': {
      'fr': 'Plage',
      'en': 'Beach',
      'de': 'Strand',
    },
    'demo.ak.cat_nature': {
      'fr': 'Nature',
      'en': 'Nature',
      'de': 'Natur',
    },
    'demo.ak.cat_culture': {
      'fr': 'Culture',
      'en': 'Culture',
      'de': 'Kultur',
    },
    'demo.ak.explore': {
      'fr': 'Explorer',
      'en': 'Explore',
      'de': 'Entdecken',
    },
    'demo.ak.map': {
      'fr': 'Carte',
      'en': 'Map',
      'de': 'Karte',
    },
    'demo.ak.trips': {
      'fr': 'Voyages',
      'en': 'Trips',
      'de': 'Reisen',
    },
    'demo.ak.profile': {
      'fr': 'Profil',
      'en': 'Profile',
      'de': 'Profil',
    },
    'demo.ak.assinie_desc': {
      'fr': 'Lagune, océan et cocotiers à 1 h 30 d\'Abidjan.',
      'en': 'Lagoon, ocean and palm trees 1.5 hours from Abidjan.',
      'de': 'Lagune, Ozean und Palmen, 1,5 Stunden von Abidjan.',
    },
    'demo.ak.from': {
      'fr': 'À partir de',
      'en': 'From',
      'de': 'Ab',
    },
    'demo.ak.night': {
      'fr': '/ nuit',
      'en': '/ night',
      'de': '/ Nacht',
    },
    'demo.ak.book': {
      'fr': 'Réserver',
      'en': 'Book',
      'de': 'Buchen',
    },
    'demo.ak.booking': {
      'fr': 'Réservation',
      'en': 'Booking',
      'de': 'Buchung',
    },
    'demo.ak.dates': {
      'fr': 'Dates',
      'en': 'Dates',
      'de': 'Reisedaten',
    },
    'demo.ak.thu': {
      'fr': 'Jeu',
      'en': 'Thu',
      'de': 'Do',
    },
    'demo.ak.fri': {
      'fr': 'Ven',
      'en': 'Fri',
      'de': 'Fr',
    },
    'demo.ak.sat': {
      'fr': 'Sam',
      'en': 'Sat',
      'de': 'Sa',
    },
    'demo.ak.sun': {
      'fr': 'Dim',
      'en': 'Sun',
      'de': 'So',
    },
    'demo.ak.month': {
      'fr': 'oct.',
      'en': 'Oct',
      'de': 'Okt.',
    },
    'demo.ak.travellers': {
      'fr': '2 voyageurs',
      'en': '2 travellers',
      'de': '2 Reisende',
    },
    'demo.ak.guide': {
      'fr': 'Guide local sur WhatsApp',
      'en': 'Local guide on WhatsApp',
      'de': 'Lokaler Guide über WhatsApp',
    },
    'demo.ak.nights': {
      'fr': '2 nuits',
      'en': '2 nights',
      'de': '2 Nächte',
    },
    'demo.ak.pay': {
      'fr': 'Payer',
      'en': 'Pay',
      'de': 'Zahlen:',
    },
    'demo.ak.secure': {
      'fr': 'Paiement sécurisé par Stripe',
      'en': 'Secure payment by Stripe',
      'de': 'Sichere Zahlung über Stripe',
    },
    'demo.ak.confirmed': {
      'fr': 'Réservation confirmée',
      'en': 'Booking confirmed',
      'de': 'Buchung bestätigt',
    },
    'demo.ak.ref': {
      'fr': 'Réf.',
      'en': 'Ref.',
      'de': 'Ref.',
    },
    'demo.ak.done': {
      'fr': 'Retour à l\'accueil',
      'en': 'Back to home',
      'de': 'Zur Startseite',
    },
    'demo.ak.notice': {
      'fr': 'Koffi, votre guide, vous écrit sur WhatsApp.',
      'en': 'Koffi, your guide, is messaging you on WhatsApp.',
      'de': 'Koffi, Ihr Guide, schreibt Ihnen auf WhatsApp.',
    },
    'demo.dj.step1': {
      'fr': 'Les ventes du jour, même hors ligne',
      'en': 'Today\'s sales, even offline',
      'de': 'Tagesumsatz, auch offline',
    },
    'demo.dj.step2': {
      'fr': 'Enregistrer une vente en quelques touches',
      'en': 'Record a sale in a few taps',
      'de': 'Einen Verkauf mit wenigen Tipps erfassen',
    },
    'demo.dj.step3': {
      'fr': 'Sauvegardée sur le téléphone',
      'en': 'Saved on the phone',
      'de': 'Auf dem Handy gespeichert',
    },
    'demo.dj.step4': {
      'fr': 'Synchronisée au retour du réseau',
      'en': 'Synced when the network is back',
      'de': 'Synchronisiert, sobald das Netz zurück ist',
    },
    'demo.dj.shop': {
      'fr': 'Boutique Awa',
      'en': 'Awa\'s shop',
      'de': 'Awas Laden',
    },
    'demo.dj.today': {
      'fr': 'Ventes du jour',
      'en': 'Today\'s sales',
      'de': 'Heutiger Umsatz',
    },
    'demo.dj.vs': {
      'fr': '+12 % par rapport à hier',
      'en': '+12% vs yesterday',
      'de': '+12 % gegenüber gestern',
    },
    'demo.dj.latest': {
      'fr': 'Dernières ventes',
      'en': 'Latest sales',
      'de': 'Letzte Verkäufe',
    },
    'demo.dj.offline': {
      'fr': 'Hors ligne',
      'en': 'Offline',
      'de': 'Offline',
    },
    'demo.dj.online': {
      'fr': 'En ligne',
      'en': 'Online',
      'de': 'Online',
    },
    'demo.dj.new': {
      'fr': 'Nouvelle vente',
      'en': 'New sale',
      'de': 'Neuer Verkauf',
    },
    'demo.dj.product': {
      'fr': 'Produit',
      'en': 'Product',
      'de': 'Produkt',
    },
    'demo.dj.method': {
      'fr': 'Paiement',
      'en': 'Payment',
      'de': 'Zahlung',
    },
    'demo.dj.cash': {
      'fr': 'Espèces',
      'en': 'Cash',
      'de': 'Bar',
    },
    'demo.dj.save': {
      'fr': 'Enregistrer',
      'en': 'Save',
      'de': 'Speichern',
    },
    'demo.dj.saved': {
      'fr': 'Enregistrée sur le téléphone — synchro au retour du réseau',
      'en': 'Saved on the phone — syncs when the network is back',
      'de': 'Auf dem Handy gespeichert — Sync, sobald das Netz zurück ist',
    },
    'demo.dj.notice': {
      'fr': '4 ventes synchronisées avec votre compte.',
      'en': '4 sales synced to your account.',
      'de': '4 Verkäufe mit Ihrem Konto synchronisiert.',
    },
    'demo.im.step1': {
      'fr': 'Le tableau de bord du propriétaire',
      'en': 'The landlord\'s dashboard',
      'de': 'Das Dashboard des Vermieters',
    },
    'demo.im.step2': {
      'fr': 'Suivre le loyer de chaque lot',
      'en': 'Track rent for every unit',
      'de': 'Die Miete jeder Einheit verfolgen',
    },
    'demo.im.step3': {
      'fr': 'Relancer en un geste',
      'en': 'Send a reminder in one tap',
      'de': 'Mit einem Tipp erinnern',
    },
    'demo.im.step4': {
      'fr': 'Paiement reçu par Mobile Money',
      'en': 'Payment received via Mobile Money',
      'de': 'Zahlung per Mobile Money erhalten',
    },
    'demo.im.properties': {
      'fr': 'Mes biens',
      'en': 'My properties',
      'de': 'Meine Objekte',
    },
    'demo.im.collected': {
      'fr': 'Loyers encaissés en octobre',
      'en': 'Rent collected in October',
      'de': 'Im Oktober eingenommene Mieten',
    },
    'demo.im.units6': {
      'fr': '6 lots · 5 loués',
      'en': '6 units · 5 let',
      'de': '6 Einheiten · 5 vermietet',
    },
    'demo.im.units1': {
      'fr': '1 lot · loué',
      'en': '1 unit · let',
      'de': '1 Einheit · vermietet',
    },
    'demo.im.one_late': {
      'fr': '1 loyer en retard',
      'en': '1 late payment',
      'de': '1 Miete überfällig',
    },
    'demo.im.units_title': {
      'fr': 'Lots',
      'en': 'Units',
      'de': 'Einheiten',
    },
    'demo.im.paid': {
      'fr': 'Payé',
      'en': 'Paid',
      'de': 'Bezahlt',
    },
    'demo.im.vacant': {
      'fr': 'Libre',
      'en': 'Vacant',
      'de': 'Frei',
    },
    'demo.im.late': {
      'fr': '5 jours de retard',
      'en': '5 days late',
      'de': '5 Tage überfällig',
    },
    'demo.im.remind': {
      'fr': 'Relancer',
      'en': 'Remind',
      'de': 'Erinnern',
    },
    'demo.im.reminded_badge': {
      'fr': 'Relancé',
      'en': 'Reminded',
      'de': 'Erinnert',
    },
    'demo.im.reminded': {
      'fr': 'Rappel envoyé à M. Diallo sur WhatsApp',
      'en': 'Reminder sent to Mr Diallo on WhatsApp',
      'de': 'Erinnerung per WhatsApp an Herrn Diallo gesendet',
    },
    'demo.im.notice': {
      'fr': 'M. Diallo a payé le loyer d\'octobre par Orange Money.',
      'en': 'Mr Diallo paid October rent via Orange Money.',
      'de': 'Herr Diallo hat die Oktobermiete per Orange Money bezahlt.',
    },
    'demo.im.home': {
      'fr': 'Accueil',
      'en': 'Home',
      'de': 'Start',
    },
    'demo.im.tenants': {
      'fr': 'Locataires',
      'en': 'Tenants',
      'de': 'Mieter',
    },
    'demo.im.requests': {
      'fr': 'Demandes',
      'en': 'Requests',
      'de': 'Anfragen',
    },
    'sync.badge': {
      'fr': 'OFFLINE-FIRST',
      'en': 'OFFLINE-FIRST',
      'de': 'OFFLINE-FIRST',
    },
    'sync.title': {
      'fr': 'Le réseau coupe. Votre app, non.',
      'en': 'The network drops. Your app doesn\'t.',
      'de': 'Das Netz fällt aus. Ihre App nicht.',
    },
    'sync.body': {
      'fr':
          'En Afrique, la connexion est souvent intermittente. Nos apps continuent de fonctionner sans réseau, puis se synchronisent toutes seules — comme Djassa, notre app de caisse pour commerçants.',
      'en':
          'Across Africa, connectivity is often patchy. Our apps keep working without a network, then sync on their own — like Djassa, our sales app for merchants.',
      'de':
          'In Afrika ist die Verbindung oft unterbrochen. Unsere Apps arbeiten ohne Netz weiter und synchronisieren sich dann selbst — wie Djassa, unsere Kassen-App für Händler.',
    },
    'sync.phase1': {
      'fr': 'Chaque vente est d\'abord enregistrée sur le téléphone',
      'en': 'Every sale is saved on the phone first',
      'de': 'Jeder Verkauf wird zuerst auf dem Handy gespeichert',
    },
    'sync.phase2': {
      'fr': 'Sans réseau, les ventes attendent dans une file locale',
      'en': 'Without a network, sales wait in a local queue',
      'de': 'Ohne Netz warten Verkäufe in einer lokalen Warteschlange',
    },
    'sync.phase3': {
      'fr': 'Au retour du réseau, tout se synchronise, sans doublon',
      'en': 'When the network returns, everything syncs, with no duplicates',
      'de':
          'Sobald das Netz zurück ist, wird alles synchronisiert, ohne Duplikate',
    },
    'sync.syncing': {
      'fr': 'Synchronisation…',
      'en': 'Syncing…',
      'de': 'Synchronisiere…',
    },
    'sync.synced': {
      'fr': 'Tout est synchronisé',
      'en': 'All synced',
      'de': 'Alles synchronisiert',
    },
    'sync.pending': {
      'fr': '{n} en attente',
      'en': '{n} pending',
      'de': '{n} ausstehend',
    },
    'sync.phone': {
      'fr': 'Téléphone',
      'en': 'Phone',
      'de': 'Handy',
    },
    'sync.server': {
      'fr': 'Serveur',
      'en': 'Server',
      'de': 'Server',
    },
    'sync.recorded': {
      'fr': 'ventes enregistrées',
      'en': 'sales recorded',
      'de': 'erfasste Verkäufe',
    },
    'sync.p1': {
      'fr': 'Riz 5 kg',
      'en': 'Rice 5 kg',
      'de': 'Reis 5 kg',
    },
    'sync.p2': {
      'fr': 'Huile 1 L',
      'en': 'Oil 1 L',
      'de': 'Öl 1 L',
    },
    'sync.p3': {
      'fr': 'Savon ×3',
      'en': 'Soap ×3',
      'de': 'Seife ×3',
    },
    'sync.p4': {
      'fr': 'Sucre 1 kg',
      'en': 'Sugar 1 kg',
      'de': 'Zucker 1 kg',
    },

    // ── Live demo: Djassa for customers ─────────────────────────────
    'portfolio.djassa_user_subtitle': {
      'fr': 'Maquis, pharmacies de garde et paiement',
      'en': 'Maquis, on-duty pharmacies and payments',
      'de': 'Maquis, Notdienst-Apotheken und Zahlungen',
    },
    'portfolio.djassa_user_desc': {
      'fr':
          'App grand public : trouver un maquis ou la pharmacie de garde la plus proche, payer en scannant le QR code du commerçant avec son mobile money et cumuler des points fidélité.',
      'en':
          'Consumer app: find a maquis or the nearest on-duty pharmacy, pay by scanning the merchant\'s QR code with mobile money, and collect loyalty points.',
      'de':
          'App für Endkunden: ein Maquis oder die nächste Notdienst-Apotheke finden, per QR-Code des Händlers mit Mobile Money bezahlen und Treuepunkte sammeln.',
    },
    'demo.dj.tag': {
      'fr': 'Commerçants',
      'en': 'Merchants',
      'de': 'Händler',
    },
    'demo.dju.tag': {
      'fr': 'Clients',
      'en': 'Customers',
      'de': 'Kunden',
    },
    'demo.dju.step1': {
      'fr': 'Maquis, pharmacies et paiements dans une app',
      'en': 'Maquis, pharmacies and payments in one app',
      'de': 'Maquis, Apotheken und Zahlungen in einer App',
    },
    'demo.dju.step2': {
      'fr': 'Les pharmacies de garde, même la nuit',
      'en': 'On-duty pharmacies, even at night',
      'de': 'Notdienst-Apotheken, auch nachts',
    },
    'demo.dju.step3': {
      'fr': 'Trouver son maquis',
      'en': 'Find a maquis',
      'de': 'Ein Maquis finden',
    },
    'demo.dju.step4': {
      'fr': 'Payer en scannant le QR code',
      'en': 'Pay by scanning the QR code',
      'de': 'Per QR-Code bezahlen',
    },
    'demo.dju.step5': {
      'fr': 'Des points fidélité à chaque paiement',
      'en': 'Loyalty points with every payment',
      'de': 'Treuepunkte bei jeder Zahlung',
    },
    'demo.dju.hello': {
      'fr': 'Bonsoir Koffi',
      'en': 'Good evening, Koffi',
      'de': 'Guten Abend, Koffi',
    },
    'demo.dju.search': {
      'fr': 'Un plat, une pharmacie…',
      'en': 'A dish, a pharmacy…',
      'de': 'Ein Gericht, eine Apotheke…',
    },
    'demo.dju.on_duty': {
      'fr': 'De garde',
      'en': 'On duty',
      'de': 'Notdienst',
    },
    'demo.dju.deals': {
      'fr': 'Promos',
      'en': 'Deals',
      'de': 'Angebote',
    },
    'demo.dju.loyalty': {
      'fr': 'Fidélité',
      'en': 'Loyalty',
      'de': 'Treue',
    },
    'demo.dju.pay': {
      'fr': 'Payer',
      'en': 'Pay',
      'de': 'Zahlen',
    },
    'demo.dju.nearby': {
      'fr': 'Maquis près de vous',
      'en': 'Maquis near you',
      'de': 'Maquis in der Nähe',
    },
    'demo.dju.djassa_pay': {
      'fr': 'Paiement Djassa',
      'en': 'Djassa Pay',
      'de': 'Djassa Pay',
    },
    'demo.dju.pharmacies': {
      'fr': 'Pharmacies de garde',
      'en': 'On-duty pharmacies',
      'de': 'Notdienst-Apotheken',
    },
    'demo.dju.pharmacies_sub': {
      'fr': 'Ouvertes jour et nuit cette semaine',
      'en': 'Open day and night this week',
      'de': 'Diese Woche Tag und Nacht geöffnet',
    },
    'demo.dju.duty_label': {
      'fr': 'DE GARDE',
      'en': 'ON DUTY',
      'de': 'NOTDIENST',
    },
    'demo.dju.until': {
      'fr': 'Jusqu\'à lundi 8:00',
      'en': 'Until Monday 8:00',
      'de': 'Bis Montag 8:00',
    },
    'demo.dju.call': {
      'fr': 'Appeler',
      'en': 'Call',
      'de': 'Anrufen',
    },
    'demo.dju.specialties': {
      'fr': 'Spécialités',
      'en': 'Specialties',
      'de': 'Spezialitäten',
    },
    'demo.dju.specialties_value': {
      'fr': 'Garba, alloco, poulet braisé',
      'en': 'Garba, alloco, grilled chicken',
      'de': 'Garba, Alloco, gegrilltes Hähnchen',
    },
    'demo.dju.hours': {
      'fr': 'Horaires',
      'en': 'Hours',
      'de': 'Öffnungszeiten',
    },
    'demo.dju.points_here': {
      'fr': 'Vos points ici',
      'en': 'Your points here',
      'de': 'Ihre Punkte hier',
    },
    'demo.dju.reward': {
      'fr': 'Alloco offert',
      'en': 'Free alloco',
      'de': 'Gratis-Alloco',
    },
    'demo.dju.scan': {
      'fr': 'Scanner pour payer',
      'en': 'Scan to pay',
      'de': 'Zum Bezahlen scannen',
    },
    'demo.dju.paid': {
      'fr': 'Paiement envoyé',
      'en': 'Payment sent',
      'de': 'Zahlung gesendet',
    },
    'demo.dju.points': {
      'fr': 'points',
      'en': 'points',
      'de': 'Punkte',
    },
    'demo.dju.funds': {
      'fr':
          'L\'argent va directement de votre portefeuille à celui du commerçant.',
      'en': 'The money goes straight from your wallet to the merchant\'s.',
      'de': 'Das Geld geht direkt von Ihrer Wallet an die des Händlers.',
    },
    'demo.dju.done': {
      'fr': 'Terminé',
      'en': 'Done',
      'de': 'Fertig',
    },
    'demo.dju.notice': {
      'fr': '+35 points chez Tantie Awa. Encore 35 pour un alloco offert !',
      'en': '+35 points at Tantie Awa. 35 more for a free alloco!',
      'de': '+35 Punkte bei Tantie Awa. Noch 35 bis zum Gratis-Alloco!',
    },
  };

  /// Translate [key] to the given [locale] (fr, en, de).
  /// Returns the key itself if no translation is found.
  static String translate(String key, String locale) {
    final localized = _data[key];
    if (localized == null) return key;
    return localized[locale] ?? localized['en'] ?? key;
  }

  /// All translation keys with their FR / EN / DE values (used by tests).
  static Map<String, Map<String, String>> get entries => _data;

  /// Returns all available locale codes.
  static List<String> get supportedLocales => ['fr', 'en', 'de'];

  /// Returns a user-friendly name for a locale code.
  static String localeName(String code) {
    switch (code) {
      case 'fr':
        return 'Français';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return code;
    }
  }
}
