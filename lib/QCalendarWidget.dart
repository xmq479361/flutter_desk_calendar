import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'QCalHolder.dart';
import 'QCalendarRender.dart';
import 'QCalendarView.dart';
import 'QCalModel.dart';

mixin QCalendarWidgetMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey containerKey = GlobalKey();
  QCalHolder _model;
  ScrollController _scrollController;
  QCalendarRender render;

  rebuildView() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController ?? dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      RenderBox box = containerKey.currentContext.findRenderObject();
      Offset offset = box.localToGlobal(Offset.zero);
      print("CalendarWidgetMixin endOfFrame: ${box.size},  $offset");
      _model.fullHeight = box.size.height;
      _model.minHeight = max(45.0, box.size.height / 3 / WEEK_IN_MONTH);
      _model.centerHeight = _model.minHeight * WEEK_IN_MONTH;
      setState(() {});
      modifyMode();
    });
  }

  sliverHeader({
    QCalHolder model,
    pinned = true,
  }) {
    this._model = model ?? QCalHolder(mode: Mode.WEEK);
    return SliverPersistentHeader(
      delegate:
          QCalSliverHeaderDelegate(this, render: render ?? QCalendarRender()),
      pinned: pinned,
    );
  }

  customScrollView(ScrollController _scrollController, CustomScrollView child) {
    this._scrollController = _scrollController;
    return NotificationListener<OverscrollNotification>(
        onNotification: (OverscrollNotification notification) {
          checkModifyMode(notification);
          return true;
        },
        child: NotificationListener<ScrollEndNotification>(
            onNotification: (ScrollEndNotification notification) {
              if (checkModifyMode(notification)) modifyMode();
              return true;
            },
            child: Container(
              child: child,
              height: double.infinity,
              key: containerKey,
            )));
  }

  modifyMode() {
    switch (_model.mode) {
      case Mode.MONTH:
        _scroll(_model.fullHeight - _model.centerHeight);
        break;
      case Mode.WEEK:
        _scroll(_model.fullHeight - _model.minHeight);
        break;
      case Mode.DETAIL:
      default:
        _scroll(-(_scrollController.offset));
    }
  }

  /// 延时检查 是否模式切换
  Future _scroll(offset) async {
    print("_scroll: $offset");
    await Future.delayed(Duration(milliseconds: 20), () {
      if (!mounted) return;
      _scrollController.animateTo(offset,
          duration: Duration(milliseconds: 60), curve: Curves.linear);
    });
  }

  bool checkModifyMode(ScrollNotification notification) {
//    print('------------------------');
    if (notification.depth != 0) return false;
    ScrollMetrics metrics = notification.metrics;
    double offset2Detail = metrics.extentBefore.abs();
    double offsetsScroll = (_model.fullHeight - _model.minHeight);
    double offset2Top = (_model.fullHeight - metrics.extentBefore).abs();
    double offset2Center = (_model.centerHeight - metrics.extentBefore).abs();
    Mode mode;
    if (offset2Top < offset2Center) {
      mode = offset2Top < offset2Detail ? Mode.WEEK : Mode.DETAIL;
    } else {
      mode = offset2Center < offset2Detail ? Mode.MONTH : Mode.DETAIL;
    }
    // print(
    //     "${offsetsScroll}::: offset2Top: ${offset2Top}, offset2Center: ${offset2Center}, offset2Detail: ${offset2Detail} == ${mode} ");
    if (_model.mode != mode) {
      _model.mode = mode;
      rebuildView();
    }
    // 如果已经一步滑动 超出CalendarWidget 高度（fullHeight）
    return metrics.extentBefore <= offsetsScroll;
  }
}

class QCalSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  QCalendarRender render;
  QCalendarWidgetMixin container;

  QCalSliverHeaderDelegate(this.container, {this.render}) {
    if (render == null) render = QCalendarRender();
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return PageView.builder(
        itemCount: maxSize,
        controller: PageController(initialPage: offsetMid),
        physics: ClampingScrollPhysics(),
        onPageChanged: (page) =>
            container._model.focusDateByPage(context, page),
        itemBuilder: (context, pos) => QCalendarView(
            pos, container._model, render, container.rebuildView));
  }

  @override
  double get maxExtent => container._model.fullHeight;

  @override
  double get minExtent => container._model.minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
