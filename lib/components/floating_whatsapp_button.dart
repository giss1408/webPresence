import 'package:flutter/material.dart';
import 'package:flutter_website/components/components.dart';
import 'package:flutter_website/services/whatsapp_service.dart';
import 'package:flutter_website/services/analytics_service.dart';
import 'package:flutter_website/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class FloatingWhatsAppButton extends StatefulWidget {
  final String? customMessage;
  final String? templateKey;

  const FloatingWhatsAppButton({
    super.key,
    this.customMessage,
    this.templateKey,
  });

  @override
  State<FloatingWhatsAppButton> createState() => _FloatingWhatsAppButtonState();
}

class _FloatingWhatsAppButtonState extends State<FloatingWhatsAppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showLabel = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _openWhatsApp() {
    // Track WhatsApp click
    AnalyticsService().trackEvent(
      'whatsapp_button_clicked',
      parameters: {
        'template': widget.templateKey ?? 'none',
        'has_custom_message': widget.customMessage != null,
      },
    );

    if (widget.customMessage != null) {
      WhatsAppService.openWhatsAppWithCustomMessage(widget.customMessage!);
    } else if (widget.templateKey != null) {
      WhatsAppService.openWhatsAppWithTemplate(
        widget.templateKey!,
        locale: context.read<LocaleProvider>().locale,
      );
    } else {
      WhatsAppService.openWhatsApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    // Positioned must be DIRECT child of Stack
    return Positioned(
      bottom: 24,
      left: 24,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _showLabel = true);
          },
          onExit: (_) {
            setState(() => _showLabel = false);
          },
          child: GestureDetector(
            onTap: _openWhatsApp,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: ModernShadows.elevation4,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_showLabel) ...[
                    SizedBox(
                      width: 200,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          localeProvider.tr('whatsapp.chat'),
                          style: ModernTypography.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: ModernShadows.elevation4,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _openWhatsApp,
                        borderRadius: BorderRadius.circular(50),
                        child: const Center(
                          child: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
