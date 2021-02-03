import 'package:flutter/material.dart' hide FlexibleSpaceBar ;
import 'dart:math' as math;
import 'dart:ui' as ui;

class MyFlexibleSpaceBar extends StatefulWidget {
  ///

  const MyFlexibleSpaceBar({
    Key key,
    this.title,
    this.background,
    this.centerTitle,
    this.titlePadding,
    this.collapseMode = CollapseMode.parallax,
    this.stretchModes = const <StretchMode>[StretchMode.zoomBackground],
  }) : assert(collapseMode != null),
        super(key: key);


  final Widget title;


  final Widget background;


  final bool centerTitle;


  final CollapseMode collapseMode;


  final List<StretchMode> stretchModes;


  final EdgeInsetsGeometry titlePadding;


  static Widget createSettings({
    double toolbarOpacity,
    double minExtent,
    double maxExtent,
    @required double currentExtent,
    @required Widget child,
  }) {
    assert(currentExtent != null);
    return MyFlexibleSpaceBarSettings(
      toolbarOpacity: toolbarOpacity ?? 1.0,
      minExtent: minExtent ?? currentExtent,
      maxExtent: maxExtent ?? currentExtent,
      currentExtent: currentExtent,
      child: child,
    );
  }

  @override
  _FlexibleSpaceBarState createState() => _FlexibleSpaceBarState();
}

class _FlexibleSpaceBarState extends State<MyFlexibleSpaceBar> {
  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (widget.centerTitle != null)
      return widget.centerTitle;
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
    }
    return null;
  }

  Alignment _getTitleAlignment(bool effectiveCenterTitle) {
    if (effectiveCenterTitle)
      return Alignment.bottomCenter;
    final TextDirection textDirection = Directionality.of(context);
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
    return null;
  }

  double _getCollapsePadding(double t, MyFlexibleSpaceBarSettings settings) {
    switch (widget.collapseMode) {
      case CollapseMode.pin:
        return -(settings.maxExtent - settings.currentExtent);
      case CollapseMode.none:
        return 0.0;
      case CollapseMode.parallax:
        final double deltaExtent = settings.maxExtent - settings.minExtent;
        return -Tween<double>(begin: 0.0, end: deltaExtent / 4.0).transform(t);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final MyFlexibleSpaceBarSettings settings = context.dependOnInheritedWidgetOfExactType<MyFlexibleSpaceBarSettings>();
          assert(
          settings != null,
          'A FlexibleSpaceBar must be wrapped in the widget returned by FlexibleSpaceBar.createSettings().',
          );

          final List<Widget> children = <Widget>[];

          final double deltaExtent = settings.maxExtent - settings.minExtent;

          // 0.0 -> Expanded
          // 1.0 -> Collapsed to toolbar
          final double t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0) as double;

          // background
          if (widget.background != null) {
            final double fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
            const double fadeEnd = 1.0;
            assert(fadeStart <= fadeEnd);
            final double opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
            double height = settings.maxExtent;

            // StretchMode.zoomBackground
            if (widget.stretchModes.contains(StretchMode.zoomBackground) &&
                constraints.maxHeight > height) {
              height = constraints.maxHeight;
            }
            //background控件
            children.add(Positioned(
              top: _getCollapsePadding(t, settings),
              left: 0.0,
              right: 0.0,
              height: height,
              child: Opacity(
                // IOS is relying on this semantics node to correctly traverse
                // through the app bar when it is collapsed.
                alwaysIncludeSemantics: true,
                opacity: opacity,
                child: Container(
                  color: Colors.white,
                  child: widget.background,
                ),
              ),
            ));

            // StretchMode.blurBackground
            if (widget.stretchModes.contains(StretchMode.blurBackground) &&
                constraints.maxHeight > settings.maxExtent) {
              final double blurAmount = (constraints.maxHeight - settings.maxExtent) / 10;
              children.add(Positioned.fill(
                  child: BackdropFilter(
                      child: Container(
                        color: Colors.red,
                      ),
                      filter: ui.ImageFilter.blur(
                        sigmaX: blurAmount,
                        sigmaY: blurAmount,
                      )
                  )
              ));
            }
          }

          if (widget.title != null) {
            final ThemeData theme = Theme.of(context);

            Widget title;
            switch (theme.platform) {
              case TargetPlatform.iOS:
              case TargetPlatform.macOS:
                title = widget.title;
                break;
              case TargetPlatform.android:
              case TargetPlatform.fuchsia:
              case TargetPlatform.linux:
              case TargetPlatform.windows:
                title = Semantics(
                  namesRoute: true,
                  child: widget.title,
                );
                break;
            }

            // StretchMode.fadeTitle
            if (widget.stretchModes.contains(StretchMode.fadeTitle) &&
                constraints.maxHeight > settings.maxExtent) {
              final double stretchOpacity = 1 -
                  (((constraints.maxHeight - settings.maxExtent) / 100).clamp(0.0, 1.0) as double);
              title = Opacity(
                opacity: stretchOpacity,
                child: title,
              );
            }

            final double opacity = settings.toolbarOpacity;
            if (opacity > 0.0) {
              TextStyle titleStyle = theme.primaryTextTheme.headline6 ;

              // TextStyle titleStyle = TextStyle(color: Colors.green);

              titleStyle = titleStyle.copyWith(
                  color: titleStyle.color.withOpacity(opacity)
              );
              final bool effectiveCenterTitle = _getEffectiveCenterTitle(theme);
              final EdgeInsetsGeometry padding = widget.titlePadding ??
                  EdgeInsetsDirectional.only(
                    start: effectiveCenterTitle ? 0.0 : 72.0,
                    bottom: 16.0,
                  );
              final double scaleValue = Tween<double>(begin: 1.5, end: 1.0).transform(t);
              final Matrix4 scaleTransform = Matrix4.identity()
                ..scale(scaleValue, scaleValue, 1.0);
              final Alignment titleAlignment = _getTitleAlignment(effectiveCenterTitle);
              children.add(Container(
                padding: padding,
                child: Transform(
                  alignment: titleAlignment,
                  transform: scaleTransform,
                  child: Align(
                    alignment: titleAlignment,
                    child: DefaultTextStyle(
                      style: titleStyle,
                      child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return Container(
                              width: constraints.maxWidth / scaleValue,
                              alignment: titleAlignment,
                              child: title,
                            );
                          }
                      ),
                    ),
                  ),
                ),
              ));
            }
          }

          return ClipRect(child: Stack(children: children));
        }
    );
  }
}


class MyFlexibleSpaceBarSettings extends InheritedWidget {

  const MyFlexibleSpaceBarSettings({
    Key key,
    @required this.toolbarOpacity,
    @required this.minExtent,
    @required this.maxExtent,
    @required this.currentExtent,
    @required Widget child,
  }) : assert(toolbarOpacity != null),
        assert(minExtent != null && minExtent >= 0),
        assert(maxExtent != null && maxExtent >= 0),
        assert(currentExtent != null && currentExtent >= 0),
        assert(toolbarOpacity >= 0.0),
        assert(minExtent <= maxExtent),
        assert(minExtent <= currentExtent),
        assert(currentExtent <= maxExtent),
        super(key: key, child: child);

  final double toolbarOpacity;

  final double minExtent;

  final double maxExtent;

  final double currentExtent;

  @override
  bool updateShouldNotify(MyFlexibleSpaceBarSettings oldWidget) {
    return toolbarOpacity != oldWidget.toolbarOpacity
        || minExtent != oldWidget.minExtent
        || maxExtent != oldWidget.maxExtent
        || currentExtent != oldWidget.currentExtent;
  }
}
