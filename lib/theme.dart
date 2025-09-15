import "package:flutter/material.dart";

/// Defines the visual styling for the CascadeFilterChips widget.
///
/// Use this class to customize colors, fonts, shapes, and spacing of the chips.
/// If a property is not provided, the widget will fall back to its default value,
/// typically derived from the app's overall `ThemeData`.
@immutable
class CascadeChipTheme {
  /// The background color for the primary path chip (the first selected item).
  ///
  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? primaryPathBackgroundColor;

  /// The text color for the primary path chip.
  ///
  /// Defaults to `Theme.of(context).colorScheme.onPrimary`.
  final Color? primaryPathForegroundColor;

  /// The background color for subsequent path chips.
  ///
  /// Defaults to `Theme.of(context).colorScheme.primaryContainer`.
  final Color? secondaryPathBackgroundColor;

  /// The text color for subsequent path chips.
  ///
  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? secondaryPathForegroundColor;

  /// The background color for the unselected option chips.
  /// The background color for the unselected option chips.
  ///
  /// Defaults to `Theme.of(context).colorScheme.surface`.
  final Color? optionChipBackgroundColor;

  /// The border color for the unselected option chips.
  /// The border color for the unselected option chips.
  ///
  /// Defaults to `Theme.of(context).colorScheme.outlineVariant`.
  final Color? optionChipBorderColor;

  /// The font size for all chip labels.
  /// The font size for all chip labels.
  ///
  /// Defaults to `14.0`.
  final double? fontSize;

  /// The background color for the 'clear all' chip.
  /// The background color for the 'clear all' chip.
  ///
  /// Defaults to `Theme.of(context).colorScheme.secondaryContainer`.
  final Color? clearChipBackgroundColor;

  /// The color of the icon on the 'clear all' chip.
  /// The color of the icon on the 'clear all' chip.
  ///
  /// Defaults to `Theme.of(context).colorScheme.onSecondaryContainer`.
  final Color? clearChipForegroundColor;

  /// The border color for the 'clear all' chip.
  ///
  /// Defaults to `Theme.of(context).colorScheme.outlineVariant`.
  final Color? clearChipBorderColor;

  /// The border radius for the chips.
  ///
  /// Defaults to a shape with an `8.0` circular radius for path chips
  /// and `StadiumBorder` for option chips.
  final BorderRadius? chipBorderRadius;

  /// The padding inside the chips, around the label.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 12, vertical: 2)`.
  final EdgeInsets? chipPadding;

  /// The horizontal spacing between chips.
  ///
  /// Defaults to `8.0`.
  final double? chipSpacing;

  /// Creates a theme for styling cascade chips.
  const CascadeChipTheme({
    this.primaryPathBackgroundColor,
    this.primaryPathForegroundColor,
    this.secondaryPathBackgroundColor,
    this.secondaryPathForegroundColor,
    this.optionChipBackgroundColor,
    this.optionChipBorderColor,
    this.fontSize,
    this.clearChipBackgroundColor,
    this.clearChipForegroundColor,
    this.clearChipBorderColor,
    this.chipBorderRadius,
    this.chipPadding,
    this.chipSpacing,
  });
}
