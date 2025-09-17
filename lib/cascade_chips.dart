import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

import "cascade_node.dart";
import "theme.dart";

/// A stylish and animated chip-based widget for filtering and navigating
/// through hierarchical data structures.
///
/// This widget takes a list of [CascadeNode] objects and builds an interactive
/// UI that allows users to drill down into nested categories. The current
/// selection path is reported through the [onFilterChanged] callback.
class CascadeChips extends StatefulWidget {
  /// The root list of [CascadeNode]s that builds the filter tree.
  final List<CascadeNode> nodes;

  /// A callback function that is triggered whenever the filter selection changes.
  ///
  /// It returns the currently active path of selected nodes as a `List<CascadeNode>`.
  final ValueChanged<List<CascadeNode>> onFilterChanged;

  /// An optional theme to customize the appearance of the chips.
  ///
  /// If null, default styles from the app's theme will be used.
  final CascadeChipTheme? theme;

  /// An optional list of node IDs to set the initial filter path when the widget is first built.
  /// The widget will traverse the [nodes] tree and activate the corresponding path.
  final List<String>? initialPathIds;

  /// Creates a cascade filter chips widget.
  const CascadeChips({
    required this.nodes,
    required this.onFilterChanged,
    this.theme,
    this.initialPathIds,
    super.key,
  });

  @override
  State<CascadeChips> createState() => _CascadeChipsState();
}

class _CascadeChipsState extends State<CascadeChips> {
  final List<CascadeNode> _activeFilters = [];

  @override
  void initState() {
    super.initState();
    _resolveInitialPath();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onFilterChanged(_activeFilters);
      }
    });
  }

  void _resolveInitialPath() {
    final initialIds = widget.initialPathIds;
    if (initialIds == null || initialIds.isEmpty) {
      return;
    }

    List<CascadeNode> currentLevelNodes = widget.nodes;
    for (final String idToFind in initialIds) {
      final foundNode = currentLevelNodes.cast<CascadeNode?>().firstWhere(
            (node) => node?.id == idToFind,
            orElse: () => null,
          );

      if (foundNode != null) {
        _activeFilters.add(foundNode);
        currentLevelNodes = foundNode.children;
      } else {
        if (kDebugMode) {
          print(
            "Warning: CascadeChips could not find a node with ID '$idToFind'.",
          );
        }
        break;
      }
    }
  }

  Widget _buildClearChip() {
    final appTheme = Theme.of(context);
    final customTheme = widget.theme;

    return ActionChip(
      key: const ValueKey("clear_chip"),
      label: Icon(
        Icons.close,
        size: 16.0,
        color: customTheme?.clearChipForegroundColor ??
            appTheme.colorScheme.onSecondaryContainer,
      ),
      labelStyle: const TextStyle(fontSize: 14.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      shape: const CircleBorder(),
      side: BorderSide(
        color: customTheme?.clearChipBorderColor ??
            appTheme.colorScheme.outlineVariant,
      ),
      backgroundColor:
          customTheme?.clearChipBackgroundColor ?? appTheme.colorScheme.surface,
      visualDensity: VisualDensity.compact,
      onPressed: () {
        setState(() => _activeFilters.clear());
        widget.onFilterChanged(_activeFilters);
      },
    );
  }

  List<Widget> _buildPathChips() {
    final appTheme = Theme.of(context);
    final customTheme = widget.theme;

    return _activeFilters.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final node = entry.value;

        final BorderRadius baseRadius = customTheme?.chipBorderRadius ??
            const BorderRadius.all(Radius.circular(8.0));

        final bool isFirst = index == 0;
        final bool isLast = index == _activeFilters.length - 1;

        BorderRadius chipSpecificRadius;
        if (isFirst && isLast) {
          chipSpecificRadius = baseRadius;
        } else if (isFirst) {
          chipSpecificRadius = BorderRadius.only(
            topLeft: baseRadius.topLeft,
            bottomLeft: baseRadius.bottomLeft,
          );
        } else if (isLast) {
          chipSpecificRadius = BorderRadius.only(
            topRight: baseRadius.topRight,
            bottomRight: baseRadius.bottomRight,
          );
        } else {
          chipSpecificRadius = BorderRadius.zero;
        }

        final OutlinedBorder shape =
            RoundedRectangleBorder(borderRadius: chipSpecificRadius);

        final Color backgroundColor = isFirst
            ? customTheme?.primaryPathBackgroundColor ??
                appTheme.colorScheme.primary
            : customTheme?.secondaryPathBackgroundColor ??
                appTheme.colorScheme.primaryContainer;

        final Color labelColor = isFirst
            ? customTheme?.primaryPathForegroundColor ??
                appTheme.colorScheme.onPrimary
            : customTheme?.secondaryPathForegroundColor ??
                appTheme.colorScheme.primary;

        return ChoiceChip(
          key: ValueKey("path_chip_${node.id}"),
          label: Text(node.label),
          shape: shape,
          visualDensity: VisualDensity.compact,
          selectedColor: backgroundColor,
          backgroundColor: backgroundColor,
          labelStyle: TextStyle(
            color: labelColor,
            fontSize: customTheme?.fontSize ?? 14.0,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(0),
          labelPadding: customTheme?.chipPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          showCheckmark: false,
          selected: true,
          onSelected: (_) {
            setState(() {
              _activeFilters.removeRange(index, _activeFilters.length);
            });
            widget.onFilterChanged(_activeFilters);
          },
        );
      },
    ).toList();
  }

  List<Widget> _buildOptionChips() {
    final appTheme = Theme.of(context);
    final customTheme = widget.theme;
    final List<CascadeNode> currentOptions =
        _activeFilters.isEmpty ? widget.nodes : _activeFilters.last.children;

    return currentOptions.map(
      (category) {
        return ChoiceChip(
          key: ValueKey("option_chip_${category.id}"),
          label: Text(category.label),
          visualDensity: VisualDensity.compact,
          labelStyle: TextStyle(
            color: customTheme?.secondaryPathForegroundColor ??
                appTheme.colorScheme.primary,
            fontSize: customTheme?.fontSize ?? 14.0,
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(0),
          labelPadding: customTheme?.chipPadding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          shape: customTheme?.chipBorderRadius != null
              ? RoundedRectangleBorder(
                  borderRadius: customTheme!.chipBorderRadius!,
                )
              : null,
          side: BorderSide(
            color: customTheme?.optionChipBorderColor ??
                appTheme.colorScheme.outlineVariant,
          ),
          backgroundColor: customTheme?.optionChipBackgroundColor ??
              appTheme.colorScheme.surface,
          showCheckmark: false,
          selected: false,
          onSelected: (_) {
            setState(() {
              _activeFilters.add(category);
            });
            widget.onFilterChanged(_activeFilters);
          },
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pathChips = _buildPathChips();
    final optionChips = _buildOptionChips();

    final List<Widget> chipWidgets = [
      if (_activeFilters.isNotEmpty) _buildClearChip(),
      ...pathChips,
      ...optionChips,
    ];

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chipWidgets.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final chipWidget = entry.value;

              final bool isPathChip = index > 0 && index <= pathChips.length;
              final bool isLastPathChip = index == pathChips.length;

              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: isPathChip && !isLastPathChip
                        ? 0
                        : (widget.theme?.chipSpacing ?? 8.0),
                  ),
                  child: chipWidget,
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
