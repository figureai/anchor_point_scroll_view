library anchor_point_scroll_view;


import 'package:flutter/material.dart';

/// 锚点 滚动
class AnchorPointScrollView extends StatefulWidget {
  /// 子组件列表
  final List<Widget> children;

  /// 当前滚到到的子组件回调
  final ValueChanged<int>? onIndexChanged;

  /// 滚动时的回调
  final ValueChanged<double>? onScroll;

  /// GlobalKey
  final Key? key;

  /// 不参与计算定位的偏移量
  final double excludeOffset;

  /// Scrollview padding
  final EdgeInsets? padding;

  const AnchorPointScrollView({
    this.key,
    required this.children,
    this.onIndexChanged,
    this.excludeOffset = 0,
    this.onScroll,
    this.padding,
  }) : super(key: key);

  @override
  AnchorPointScrollViewState createState() => AnchorPointScrollViewState();
}

class AnchorPointScrollViewState extends State<AnchorPointScrollView> {
  final _scrollController = ScrollController();

  late BuildContext _originalContext;
  late double _originalOffset;

  /// 组件 context 对象
  Map<int, BuildContext> _widgetContext = {};

  /// 组件相对于屏幕 y 坐标
  Map<int, double> _widgetOffset = {};

  /// 组件高度
  Map<int, double> _widgetHeight = {};

  /// 当前显示的组件
  int currentIndex = 0;

  jumpToIndex(int index) {
    _scrollController.jumpTo(_indexToOffset(index));
  }

  animatedTo(
    int index, {
    required Duration duration,
    required Curve curve,
  }) {
    _scrollController.animateTo(_indexToOffset(index),
        duration: duration, curve: curve);
  }

  _calculateWidgetOffset() {
    // print('lch---_calculateWidgetOffset: ${_scrollController.offset}');
    RenderBox renderBox = _originalContext.findRenderObject() as RenderBox;
    var originalOffset = renderBox.localToGlobal(Offset.zero);
    _originalOffset = originalOffset.dy;
    _widgetContext.forEach((key, value) {
      RenderBox renderBox = value.findRenderObject() as RenderBox;
      var offset = renderBox.localToGlobal(Offset.zero);
      // print('lch---key $key : ${offset.dy}');
      _widgetOffset[key] = offset.dy + _scrollController.offset;
      _widgetHeight[key] = renderBox.size.height;
    });
  }

  /// 组件下标 转 offset
  double _indexToOffset(int index) {
    if (_scrollController.hasClients && index < 0 ||
        index > widget.children.length - 1) return 0;

    return _widgetOffset[index]! - _originalOffset + 1 - widget.excludeOffset;
  }

  /// 滚动位置转 组件 下标
  int _offsetToIndex() {
    // print('lch---currentOffset: ${_scrollController.offset}  $_originalOffset');
    for (var index = 0; index < _widgetOffset.keys.length; index++) {
      double value = _widgetOffset[index]! + _widgetHeight[index]!;

      if ((_scrollController.offset + _originalOffset + widget.excludeOffset) <
          value) {
        // print(
        //     'lch-----current scroll index: $index  scroll offset:${_scrollController.offset + _originalOffset}  widget offset: $value');
        return index;
      }
    }
    return 0;
  }

  /// 滚动时实时更新下标
  _updateIndex() {
    int index = _offsetToIndex();
    if (currentIndex != index) {
      currentIndex = index;
      if (widget.onIndexChanged != null) widget.onIndexChanged!(index);
    }
    if (widget.onScroll != null) widget.onScroll!(_scrollController.offset);
  }

  @override
  void didUpdateWidget(covariant AnchorPointScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _widgetOffset = {};
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPersistentFrameCallback((callback) {
      if (!mounted) return;
      if (_widgetOffset.isEmpty) {
        _calculateWidgetOffset();
      }
      _updateIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (_) {
        _originalContext = _;
        return SingleChildScrollView(
          padding: widget.padding,
          controller: _scrollController,
          child: Column(
            children: List.generate(
              widget.children.length,
              (index) {
                return Builder(
                  builder: (_) {
                    _widgetContext[index] = _;
                    return NotificationListener(
                      onNotification:
                          (SizeChangedLayoutNotification notification) {
                        _widgetOffset = {};
                        // 通过主动调用列表滚动来触发位置计算，不是很优雅
                        _scrollController.jumpTo(_scrollController.offset + 1);
                        return true;
                      },
                      child: SizeChangedLayoutNotifier(
                        child: widget.children[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
