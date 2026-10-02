import 'package:flutter/material.dart';

/// Anchors for the home page sections, used by the menu and in-page links.
class HomeSections {
  static final top = GlobalKey(debugLabel: 'top');
  static final africa = GlobalKey(debugLabel: 'africa');
  static final expertise = GlobalKey(debugLabel: 'expertise');
  static final services = GlobalKey(debugLabel: 'services');
  static final demo = GlobalKey(debugLabel: 'demo');
  static final process = GlobalKey(debugLabel: 'process');
  static final pricing = GlobalKey(debugLabel: 'pricing');
  static final contact = GlobalKey(debugLabel: 'contact');
}

/// Smooth-scrolls the home page to [section]. When called from another page,
/// returns to the home page first and scrolls once it is laid out.
void scrollToSection(BuildContext context, GlobalKey section) {
  void scroll() {
    final target = section.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  if (section.currentContext != null &&
      ModalRoute.of(context)?.isFirst != false) {
    scroll();
    return;
  }
  Navigator.of(context).popUntil((route) => route.isFirst);
  WidgetsBinding.instance.addPostFrameCallback((_) => scroll());
}
