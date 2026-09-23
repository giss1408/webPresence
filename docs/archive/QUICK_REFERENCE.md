# Quick Reference - Modern Design System

## 🎨 Colors

```dart
// Primary
ModernColors.primary           // #1389FD (main blue)
ModernColors.primaryLight      // #3FA9FF (hover)
ModernColors.primaryDark       // #0075E6 (pressed)

// Accents
ModernColors.accent           // #00D9FF (cyan)
ModernColors.accentWarm       // #FF6B35 (orange)
ModernColors.accentGreen      // #00B369 (success)
ModernColors.accentPurple     // #7C3AED (purple)

// Text
ModernColors.textPrimary      // #0F172A (dark text)
ModernColors.textSecondary    // #475569 (muted)
ModernColors.textLight        // #CBD5E1 (light text)
ModernColors.textWhite        // #FFFFFF

// Backgrounds
ModernColors.background       // #F8FAFC (light bg)
ModernColors.backgroundDark   // #0F172A (dark bg)
ModernColors.backgroundCard   // #FFFFFF (card)

// Status
ModernColors.success          // #10B981
ModernColors.warning          // #F59E0B
ModernColors.error            // #EF4444
ModernColors.info             // #0EA5E9
```

## 📝 Typography

```dart
// Display (largest)
ModernTypography.displayLarge      // 56px bold
ModernTypography.displayMedium     // 45px bold
ModernTypography.displaySmall      // 36px bold

// Headings
ModernTypography.headlineLarge     // 32px bold
ModernTypography.headlineMedium    // 28px semibold
ModernTypography.headlineSmall     // 24px semibold

// Titles
ModernTypography.titleLarge        // 22px semibold
ModernTypography.titleMedium       // 18px semibold
ModernTypography.titleSmall        // 16px semibold

// Body
ModernTypography.bodyLarge         // 16px regular
ModernTypography.bodyMedium        // 14px regular
ModernTypography.bodySmall         // 12px regular

// Labels
ModernTypography.labelLarge        // 14px semibold
ModernTypography.labelMedium       // 12px semibold
ModernTypography.labelSmall        // 11px semibold
```

## 📏 Spacing

```dart
ModernSpacing.xs       // 4px (micro)
ModernSpacing.sm       // 8px (small)
ModernSpacing.md       // 12px (medium)
ModernSpacing.lg       // 16px (large)
ModernSpacing.xl       // 24px (extra large)
ModernSpacing.xxl      // 32px (double)
ModernSpacing.xxxl     // 48px (triple)
ModernSpacing.maxSpacing  // 64px

// Responsive
ModernSpacing.responsivePadding(context)  // Smart padding
ModernSpacing.sectionSpacing(context)     // Section breaks
ModernSpacing.gutter(context)             // Grid spacing
```

## 🎭 Shadows & Elevation

```dart
ModernShadows.elevation0    // Flat
ModernShadows.elevation1    // Subtle
ModernShadows.elevation2    // Small (cards)
ModernShadows.elevation3    // Medium (hover)
ModernShadows.elevation4    // Large (floating)
ModernShadows.elevation5    // Extra (modals)

ModernRadius.xs             // 4px
ModernRadius.sm             // 8px
ModernRadius.md             // 12px
ModernRadius.lg             // 16px
ModernRadius.xl             // 20px
ModernRadius.circle         // Full circle
```

## 🔘 Components

```dart
// Buttons
ModernComponents.primaryButtonStyle()    // Main action
ModernComponents.secondaryButtonStyle()  // Alternative
ModernComponents.ghostButtonStyle()      // Subtle action

// Cards
ModernComponents.cardDecoration()        // Card styling

// Inputs
ModernComponents.inputDecoration(
  labelText: 'Email',
)
```

## 🎬 Animations

```dart
ModernAnimations.fast       // 150ms
ModernAnimations.normal     // 300ms (standard)
ModernAnimations.slow       // 500ms
ModernAnimations.verySlow   // 800ms

// Usage
AnimatedOpacity(
  opacity: show ? 1 : 0,
  duration: ModernAnimations.normal,
  child: child,
)
```

## 🌈 Common Patterns

### Professional Button
```dart
ElevatedButton(
  onPressed: () {},
  style: ModernComponents.primaryButtonStyle(),
  child: Text('Button', style: ModernTypography.buttonLarge),
)
```

### Card with Shadow
```dart
Container(
  decoration: ModernComponents.cardDecoration(),
  padding: EdgeInsets.all(ModernSpacing.lg),
  child: child,
)
```

### Responsive Section
```dart
Padding(
  padding: ModernSpacing.sectionSpacing(context),
  child: child,
)
```

### Fade-in Animation
```dart
AnimatedOpacity(
  opacity: visible ? 1 : 0,
  duration: ModernAnimations.normal,
  child: child,
)
```

### Smooth Page Transition
```dart
Navigator.push(context,
  ModernPageTransitions.slideInRightTransition(
    page: NextPage(),
  ),
)
```

## 📦 Imports

```dart
// Colors
import 'package:flutter_website/components/modern_colors.dart';

// Typography
import 'package:flutter_website/components/modern_typography.dart';

// Spacing
import 'package:flutter_website/components/modern_spacing.dart';

// Shadows
import 'package:flutter_website/components/modern_shadows.dart';

// Components
import 'package:flutter_website/components/modern_components.dart';

// Animations
import 'package:flutter_website/components/modern_animations.dart';

// Or import all
import 'package:flutter_website/components/components.dart';
```

## 🎯 Best Practices

1. **Always use style constants** - Never hardcode colors, sizes, or durations
2. **Maintain hierarchy** - Use appropriate typography levels
3. **Respect spacing** - Use the spacing system values
4. **Apply shadows** - Use elevation levels for depth
5. **Animate appropriately** - Use `normal` duration for standard interactions
6. **Test both themes** - Dark mode should look equally professional
7. **Check accessibility** - All colors meet WCAG AAA standards
8. **Use responsive** - Always adapt to screen sizes

## 🔗 Related Files

- `lib/components/DESIGN_SYSTEM.dart` - Full documentation
- `lib/config/modern_theme_builder.dart` - Theme implementation
- `UI_ENHANCEMENT_SUMMARY.md` - Complete guide

---

**Pro Tip**: Use VS Code autocomplete to explore all available styles. Type `ModernColors.` or `ModernTypography.` to see all options.
