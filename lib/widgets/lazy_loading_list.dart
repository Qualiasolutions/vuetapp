import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';

/// Lazy loading list widget for optimal performance with large datasets
class LazyLoadingList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<List<T>> Function(int offset, int limit)? onLoadMore;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int loadMoreThreshold;
  final int pageSize;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final String? heroTag;

  const LazyLoadingList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.loadingWidget,
    this.emptyWidget,
    this.errorWidget,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.loadMoreThreshold = 3,
    this.pageSize = 20,
    this.enablePullToRefresh = false,
    this.onRefresh,
    this.heroTag,
  });

  @override
  State<LazyLoadingList<T>> createState() => _LazyLoadingListState<T>();
}

class _LazyLoadingListState<T> extends State<LazyLoadingList<T>> {
  late ScrollController _scrollController;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  List<T> _items = [];

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _items = List.from(widget.items);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(LazyLoadingList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        _items = List.from(widget.items);
      });
    }
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - (widget.loadMoreThreshold * 100)) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore || widget.onLoadMore == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await widget.onLoadMore!(_items.length, widget.pageSize);
      
      setState(() {
        _items.addAll(newItems);
        _hasMore = newItems.length == widget.pageSize;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    if (widget.onRefresh != null) {
      await widget.onRefresh!();
    }
    setState(() {
      _items = List.from(widget.items);
      _hasMore = true;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty && !_isLoading) {
      return widget.emptyWidget ?? _buildEmptyWidget();
    }

    if (_error != null && _items.isEmpty) {
      return widget.errorWidget ?? _buildErrorWidget();
    }

    Widget listView = ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: _items.length + (_isLoading || _hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          if (_error != null) {
            return _buildErrorItem();
          }
          return _buildLoadingItem();
        }

        return VisibilityDetector(
          key: Key('${widget.heroTag ?? 'list'}_item_$index'),
          onVisibilityChanged: (info) {
            // Can be used for analytics or performance tracking
          },
          child: widget.itemBuilder(context, _items[index], index),
        );
      },
    );

    if (widget.enablePullToRefresh) {
      listView = RefreshIndicator(
        onRefresh: _onRefresh,
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No items available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Items will appear here when available',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
              });
              _loadMore();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingItem() {
    return widget.loadingWidget ?? _buildDefaultLoadingItem();
  }

  Widget _buildDefaultLoadingItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load more items',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadMore,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Lazy loading grid widget for grid layouts
class LazyLoadingGrid<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const LazyLoadingGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.scrollController,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.grid_view_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No items to display',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return VisibilityDetector(
          key: Key('grid_item_$index'),
          onVisibilityChanged: (info) {
            // Can be used for analytics or performance tracking
          },
          child: itemBuilder(context, items[index], index),
        );
      },
    );
  }
}
