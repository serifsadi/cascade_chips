/// Represents a single node in the hierarchical filter data structure.
///
/// Each node has a unique [id], a display [label], and can contain a list
/// of child nodes to create a nested hierarchy. It can also hold an optional
/// generic [value] of type [T] to associate custom data.
class CascadeNode<T> {
  /// A unique identifier for the node.
  ///
  /// This is used for tracking and for the `initialPathIds` property of the main widget.
  final String id;

  /// The text label that will be displayed on the chip.
  final String label;

  /// A list of child nodes representing the next level in the hierarchy.
  ///
  /// Defaults to an empty list if not provided.
  final List<CascadeNode<T>> children;

  /// An optional data payload of type [T] associated with this node.
  ///
  /// This allows you to attach your own custom objects (e.g., a product category model)
  /// to each node in the filter tree.
  final T? value;

  /// Creates a node for the cascade filter.
  const CascadeNode({
    required this.id,
    required this.label,
    this.children = const [],
    this.value,
  });
}
