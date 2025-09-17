# Cascade Chips

[![pub package](https://img.shields.io/pub/v/cascade_chips.svg)](https://pub.dev/packages/cascade_chips)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub Points](https://img.shields.io/pub/points/cascade_chips)](https://pub.dev/packages/cascade_chips/score)
<!-- TODO: Add Build Status Badge e.g., [![Build Status](https://img.shields.io/github/actions/workflow/status/YOUR_USERNAME/cascade_chips/your_ci_workflow.yml?branch=main)](https://github.com/YOUR_USERNAME/cascade_chips/actions) -->
<!-- TODO: Add Code Coverage Badge e.g., [![codecov](https://codecov.io/gh/YOUR_USERNAME/cascade_chips/branch/main/graph/badge.svg)](https://codecov.io/gh/YOUR_USERNAME/cascade_chips) -->

A stylish and animated chip-based filter widget for navigating and selecting from hierarchical data structures in Flutter.

<p align="center">
  <img src="https://raw.githubusercontent.com/serifsadi/cascade_chips/main/docs/images/demo.gif" alt="A demo showing the animated filtering capabilities of Cascade Chips" width="424">
</p>

`cascade_chips` provides a user-friendly and visually appealing way for users to drill down through nested categories, making complex filtering tasks intuitive and elegant. Ideal for e-commerce category selection, document organization, or any application requiring multi-level filtering.

## Features

- **Hierarchical Filtering:** Allow users to navigate through deeply nested data structures with ease.
- **Smooth Animations:** Built-in animations for adding and removing chips provide a fluid user experience.
- **Fully Customizable:** Use the `CascadeChipTheme` object to customize everything from colors and fonts to border radius and spacing.
- **Initial Path Selection:** Programmatically set an initial filter path using a list of node IDs, perfect for deep-linking or restoring state.
- **Flexible Data Model:** Supports a generic `CascadeNode<T>` to associate custom data (`value`) with each filter item.
- **Null-Safe:** Written entirely in null-safe Dart.

## Use Cases

- **E-commerce:** Filtering products by category, sub-category, brand, etc.
- **Content Management:** Navigating through hierarchical tags or folders.
- **Settings Screens:** Selecting nested preferences.
- **Data Exploration:** Drilling down into complex datasets.

## Getting Started

1.  **Add the dependency**

    Add this to your package's `pubspec.yaml` file:

    ```yaml
    dependencies:
      cascade_chips: ^0.0.1 # Replace with the latest version
    ```

2.  **Install it**

    Run the following command in your terminal:

    ```bash
    flutter pub get
    ```

3.  **Import the package**

    ```dart
    import 'package:cascade_chips/cascade_chips.dart';
    ```

## Usage

1.  **Prepare your data**

    Structure your hierarchical data using `CascadeNode`. You can use the generic parameter `<T>` to attach your own data objects to each node's `value` property.

    ```dart
    // You can define a custom class for your data
    class MyProductData {
      final String sku;
      MyProductData(this.sku);
    }
    
    // Use your custom class with CascadeNode<T>
    final List<CascadeNode<MyProductData>> filterNodes = [
      CascadeNode(
        id: 'electronics',
        label: 'Electronics',
        value: MyProductData('CAT-ELEC'), // Optional custom data
        children: [
          CascadeNode(id: 'laptops', label: 'Laptops', value: MyProductData('SUBCAT-LAP')),
          CascadeNode(id: 'smartphones', label: 'Smartphones', value: MyProductData('SUBCAT-SP')),
        ],
      ),
    ];
    ```

2.  **Add the widget to your UI**

    Place the `CascadeChips` widget in your app. Use `onFilterChanged` to get the current selection and `initialPathIds` to set a default path.

    ```dart
    import 'package:cascade_chips/cascade_chips.dart';
    
    // ... inside your widget build method
    
    CascadeChips(
      nodes: filterNodes,
      initialPathIds: const ['electronics', 'laptops'],
      onFilterChanged: (List<CascadeNode> activeFilters) {
        // The list contains the full path of selected nodes.
        // Note: activeFilters is of type List<CascadeNode<dynamic>>.
        print('Current selection path: ${activeFilters.map((e) => e.label).join(' > ')}');
        
        if (activeFilters.isNotEmpty) {
          // You may need to cast the value if you used a specific type
          final lastValue = activeFilters.last.value as MyProductData?;
          if (lastValue != null) {
            print('SKU of last selected node: ${lastValue.sku}');
          }
        }
        // Trigger your data fetching or state update logic here
      },
    )
    ```

### Customization

You can fully customize the appearance of the chips by providing a `CascadeChipTheme` object.

```dart
CascadeChips(
    nodes: filterNodes,
    onFilterChanged: (filters) { /* ... */ },
    theme: CascadeChipTheme(
        primaryPathBackgroundColor: Colors.deepPurple,
        primaryPathForegroundColor: Colors.white,
        secondaryPathBackgroundColor: Colors.deepPurple.shade100,
        secondaryPathForegroundColor: Colors.deepPurple,
        optionChipBackgroundColor: Colors.grey.shade200,
        optionChipBorderColor: Colors.grey.shade400,
        chipBorderRadius: BorderRadius.circular(20.0), // Pill-shaped
        chipSpacing: 10.0,
    ),
)
```

### Contributing
Contributions are welcome! If you find a bug or have a feature request, please open an issue on the [GitHub repository](https://github.com/serifsadi/cascade_chips/issues).
