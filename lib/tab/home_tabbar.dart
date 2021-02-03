import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class HomeTabBar extends StatefulWidget {
  final ValueChanged<int> onChange;
  final double tabBarHeight;
  const HomeTabBar({
    Key key,
    this.tabBarHeight = 50,
    this.onChange,
  }) : super(key: key);
  @override
  HomeTabBarState createState() => HomeTabBarState();
}

class HomeTabBarState extends State<HomeTabBar> {
  List<Map<String, String>> homeSearchTitle = [
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},
  ];

  int _index = 0;

  AutoScrollController controller;

  @override
  void initState() {
    controller = AutoScrollController(axis: Axis.vertical);

    super.initState();
  }

  scrollToIndex(int index){
    if(index != _index){
      this.setState(() {
        _index = index;
      });
      controller.scrollToIndex(index);

    }
  }



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print(width);
       return    SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _SliverAppBarDelegate(
          maxHeight: widget.tabBarHeight,
          minHeight: widget.tabBarHeight,
          child:   Container(
            height: widget.tabBarHeight,
            width: width,
            color: Colors.white,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return AutoScrollTag(
                    key: ValueKey(index),
                    controller: controller,
                    index: index,
                    child: InkWell(
                      onTap: () {
                        if (_index != index) {
                          widget.onChange(index);
                          this.setState(() {
                            _index = index;
                          });
                        }
                      },
                      child: Container(
                        width: width / 4,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              homeSearchTitle[index]["title"],
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: _index == index ? Colors.red : Colors.black,
                                  fontSize: 16),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: _index == index ? Colors.red : Colors.white,
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                //设置四周边框
                              ),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 1),
                              child: Text(
                                homeSearchTitle[index]["subTitle"],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _index == index ? Colors.white : Colors.grey,
                                  fontSize: 10,
                                  // height: 1
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              },
              itemCount: homeSearchTitle.length,
              scrollDirection: Axis.horizontal,
              controller: controller,
            ),
          )
      ),
    );


  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => this.minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);

  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
