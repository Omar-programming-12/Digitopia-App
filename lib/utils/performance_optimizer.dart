import 'package:flutter/material.dart';

class PerformanceOptimizer {
  // Lazy loading for lists
  static Widget buildLazyList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 500, // Cache items for better performance
    );
  }

  // Optimized grid view
  static Widget buildOptimizedGrid({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required int crossAxisCount,
    double childAspectRatio = 1.0,
    ScrollController? controller,
  }) {
    return GridView.builder(
      controller: controller,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 500,
    );
  }

  // Memory efficient image loading
  static Widget buildMemoryEfficientImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.error),
        );
      },
    );
  }

  // Debounced text field
  static Widget buildDebouncedTextField({
    required Function(String) onChanged,
    TextEditingController? controller,
    String? hintText,
    Duration debounceTime = const Duration(milliseconds: 300),
  }) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        Future.delayed(debounceTime, () {
          onChanged(value);
        });
      },
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Optimized stream builder
  static Widget buildOptimizedStreamBuilder<T>({
    required Stream<T> stream,
    required Widget Function(BuildContext, T) builder,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return errorWidget ?? Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        if (!snapshot.hasData) {
          return const Center(child: Text('لا توجد بيانات'));
        }
        
        return builder(context, snapshot.data!);
      },
    );
  }
}