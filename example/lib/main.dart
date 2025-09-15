import 'package:cascade_chips/cascade_chips.dart';
import 'package:cascade_chips/cascade_node.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cascade Chips Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

// In a real app, this would likely be in its own file (e.g., 'models/product.dart').
class Product {
  final String name;
  final String brand;
  final String categoryId;

  const Product({
    required this.name,
    required this.brand,
    required this.categoryId,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // State for the example app
  List<Product> _products = [];
  bool _isLoading = true;

  // Data sources for the example
  late final List<CascadeNode> _rootCategories;
  late final List<Product> _allTransactions;

  @override
  void initState() {
    super.initState();

    _rootCategories = _sampleTree();
    _allTransactions = _generateSampleProducts();
    // Fetch initial data with no filters
    _fetchTransactions(List.empty());
  }

  /// Simulates fetching data from a source based on the selected filters.
  Future<void> _fetchTransactions(List<CascadeNode> activeFilters) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    List<Product> results;
    if (activeFilters.isEmpty) {
      results = List.from(_allTransactions);
    } else {
      final lastSelectedCategoryId = activeFilters.last.id;
      results = _allTransactions.where((t) => t.categoryId.startsWith(lastSelectedCategoryId)).toList();
    }
    setState(() {
      _products = results;
      _isLoading = false;
    });
  }

  /// Builds the content area that displays loading, empty, or data states.
  Widget _buildContentArea() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      );
    }
    if (_products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Results Found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'No transactions were found for the selected filter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text(product.brand),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final myInitialFilterIds = ['apparel', 'apparel_womens', 'apparel_womens_dresses'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Cascade Chips Example'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            CascadeChips(
              nodes: _rootCategories,
              initialPathIds: myInitialFilterIds,
              onFilterChanged: (activeFilters) {
                _fetchTransactions(activeFilters);
              },
              // --- OPTIONAL THEME CUSTOMIZATION EXAMPLE ---
              // Uncomment the theme below to see a custom style.
              /*
              theme: CascadeChipTheme(
                primaryPathBackgroundColor: Colors.teal.shade800,
                primaryPathForegroundColor: Colors.white,
                secondaryPathBackgroundColor: Colors.teal.shade100,
                secondaryPathForegroundColor: Colors.teal.shade900,
                optionChipBackgroundColor: Colors.teal.shade50,
                optionChipBorderColor: Colors.teal.shade200,
                clearChipBackgroundColor: Colors.grey.shade200,
                clearChipForegroundColor: Colors.grey.shade700,
                clearChipBorderColor: Colors.grey.shade300,
                fontSize: 14.0,
                chipBorderRadius: BorderRadius.circular(20.0), // Pill-shape
                chipPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                chipSpacing: 10.0,
              ),
              */
            ),
            const Divider(height: 1),
            Expanded(child: _buildContentArea()),
          ],
        ));
  }
}

// SAMPLE DATA (E-commerce Catalog)
List<CascadeNode<Object>> _sampleTree() => [
      const CascadeNode(
        id: 'electronics',
        label: 'Electronics',
        children: [
          CascadeNode(
            id: 'electronics_computers',
            label: 'Computers',
            children: [
              CascadeNode(id: 'electronics_computers_laptops', label: 'Laptops'),
              CascadeNode(id: 'electronics_computers_desktops', label: 'Desktops'),
            ],
          ),
          CascadeNode(
            id: 'electronics_mobiles',
            label: 'Mobile Phones',
            children: [
              CascadeNode(id: 'electronics_mobiles_smartphones', label: 'Smartphones'),
              CascadeNode(id: 'electronics_mobiles_accessories', label: 'Accessories'),
            ],
          ),
        ],
      ),
      const CascadeNode(
        id: 'apparel',
        label: 'Apparel',
        children: [
          CascadeNode(
            id: 'apparel_mens',
            label: 'Men\'s Fashion',
            children: [
              CascadeNode(id: 'apparel_mens_tops', label: 'Tops'),
              CascadeNode(id: 'apparel_mens_bottoms', label: 'Bottoms'),
            ],
          ),
          CascadeNode(
            id: 'apparel_womens',
            label: 'Women\'s Fashion',
            children: [
              CascadeNode(id: 'apparel_womens_dresses', label: 'Dresses'),
              CascadeNode(id: 'apparel_womens_shoes', label: 'Shoes'),
            ],
          ),
        ],
      ),
      const CascadeNode(id: 'books', label: 'Books'), // A category with no children
      const CascadeNode(id: 'home_garden', label: 'Home & Garden'),
    ];

List<Product> _generateSampleProducts() => [
      // Electronics
      const Product(name: 'MacBook Pro 16"', brand: 'Apple', categoryId: 'electronics_computers_laptops'),
      const Product(name: 'XPS 15 Laptop', brand: 'Dell', categoryId: 'electronics_computers_laptops'),
      const Product(name: 'iPhone 17 Pro', brand: 'Apple', categoryId: 'electronics_mobiles_smartphones'),
      const Product(name: 'Pixel 10', brand: 'Google', categoryId: 'electronics_mobiles_smartphones'),
      const Product(
          name: 'QuietComfort Ultra Headphones', brand: 'Bose', categoryId: 'electronics_mobiles_accessories'),

      // Apparel
      const Product(name: 'Classic Crewneck T-Shirt', brand: 'Gap', categoryId: 'apparel_mens_tops'),
      const Product(name: 'Tech Fleece Hoodie', brand: 'Nike', categoryId: 'apparel_mens_tops'),
      const Product(name: '501 Original Fit Jeans', brand: 'Levi\'s', categoryId: 'apparel_mens_bottoms'),
      const Product(name: 'Floral Midi Dress', brand: 'Zara', categoryId: 'apparel_womens_dresses'),

      // Books
      const Product(name: 'Atomic Habits', brand: 'James Clear', categoryId: 'books'),
      const Product(name: 'The Pragmatic Programmer', brand: 'Hunt & Thomas', categoryId: 'books'),
    ];
