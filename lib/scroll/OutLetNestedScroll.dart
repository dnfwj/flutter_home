import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'NestedScrollCoordinator.dart';


class OutLetNestedScroll extends StatefulWidget {
  final ScrollController controller;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics physics;
  final NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final Widget body;
  final DragStartBehavior dragStartBehavior;
  final bool floatHeaderSlivers;
  final Clip clipBehavior;
  final String restorationId;

  const OutLetNestedScroll({
    Key key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics,
    @required this.headerSliverBuilder,
    @required this.body,
    this.dragStartBehavior = DragStartBehavior.start,
    this.floatHeaderSlivers = false,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
  }) : assert(scrollDirection != null),
        assert(reverse != null),
        assert(headerSliverBuilder != null),
        assert(body != null),
        assert(floatHeaderSlivers != null),
        assert(clipBehavior != null),
        super(key: key);



  List<Widget> _buildSlivers(BuildContext context, ScrollController innerController, bool bodyIsScrolled) {
    return <Widget>[
      ...headerSliverBuilder(context, bodyIsScrolled),
      SliverFillRemaining(
        child: PrimaryScrollController(
          controller: innerController,
          child: body,
        ),
      ),
    ];
  }
  @override
  OutLetNestedScrollState createState() => OutLetNestedScrollState();
}

class OutLetNestedScrollState extends State<OutLetNestedScroll> {


  ScrollController get innerController => _coordinator.innerController;

  ScrollController get outerController => _coordinator.outerController;

  NestedScrollCoordinator _coordinator;

  @override
  void initState() {
    super.initState();
    _coordinator = NestedScrollCoordinator(
      this, widget.controller,
      _handleHasScrolledBodyChanged,
      widget.floatHeaderSlivers,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _coordinator.setParent(widget.controller);
  }

  @override
  void didUpdateWidget(covariant OutLetNestedScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
      if (oldWidget.controller != widget.controller)
        _coordinator.setParent(widget.controller);
  }

  @override
  void dispose() {
    _coordinator.dispose();
    _coordinator = null;
    super.dispose();
  }

  bool _lastHasScrolledBody;

  void _handleHasScrolledBodyChanged() {
    if (!mounted)
      return;
    final bool newHasScrolledBody = _coordinator.hasScrolledBody;
    if (_lastHasScrolledBody != newHasScrolledBody) {
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        _lastHasScrolledBody = _coordinator.hasScrolledBody;

        return CustomScrollView(
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          physics: widget.physics != null
              ? widget.physics.applyTo(const ClampingScrollPhysics())
              : const ClampingScrollPhysics(),
          controller: _coordinator.outerController,
          slivers: [
            ...widget._buildSlivers(context, _coordinator.innerController, _lastHasScrolledBody)
          ],
        );
      });
  }
}
