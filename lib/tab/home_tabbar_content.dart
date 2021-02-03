import 'package:flutter/material.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabBarContent extends StatefulWidget {
  final ValueChanged<int> onChange;
  const HomeTabBarContent({Key key,this.onChange}) : super(key: key);
  @override
  HomeTabBarContentState createState() => HomeTabBarContentState();
}

class HomeTabBarContentState extends State<HomeTabBarContent> {
  List<Map<String ,String>> homeSearchTitle = [
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},
  ];

  AutoScrollController controller;

  PageController _pageController;


  double screenWidth = 375;

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(axis:Axis.vertical);

    _pageController = PageController();
  }


  scrollToIndex(int index){
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {


    return   PageView.builder(itemBuilder: (BuildContext context,int index){
      return  AutoScrollTag(
          key: ValueKey(index),
          controller:controller,
          index: index,
          child: MediaQuery.removePadding(context: context, removeTop: true, child: StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              itemCount:200,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int childIndex) {
                return Container(
                  color: Colors.green,
                  child: Text("$index"),
                );
              },
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.count((index > 2) ? 3 : 1, 1),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6)
          )
      );
    },
      itemCount: homeSearchTitle.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: widget.onChange,
    );
  }





   @override
  void dispose() {
     controller.dispose();
    super.dispose();
  }
}
