import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabBarContent extends StatefulWidget {
  final ValueChanged<int> onChange;
  final ScrollController innerController;
  const HomeTabBarContent({Key key, this.onChange, this.innerController})
      : super(key: key);
  @override
  HomeTabBarContentState createState() => HomeTabBarContentState();
}

class HomeTabBarContentState extends State<HomeTabBarContent> {
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
  AutoScrollController controller;
  PageController _pageController;

  double screenWidth = 375;
  String loadMoreText = "正在加载.....";
  List<int> _data = [0, 1, 2, 3, 4, 5, 6, 7,8,9,10];
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(axis: Axis.vertical);
    _pageController = PageController();
  }

  scrollToIndex(int index) {
    _pageController.jumpToPage(index);
  }

  loadMore() {
    //判断是猜你喜欢，还是爆款还是每日上新，还是榜单
    Future.delayed(Duration(seconds: 2), () {
      List<int> data = [];
      data.addAll(_data);
      for (int i = 1; i < 20; i++) {
        data.add(data[i] + i);
      }
      this.setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return AutoScrollTag(
            key: ValueKey(index),
            controller: controller,
            index: index,
            child: Container(
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: StaggeredGridView.countBuilder(
                      crossAxisCount: 3,
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int childIndex) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: Colors.green,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text("$index--------" + "$childIndex"),
                            ),
                            Visibility(child:this.buildLoadMore(),visible: _data.length -1 == childIndex,)
                          ],
                        );
                      },
                      staggeredTileBuilder: (int index) => StaggeredTile.count(
                          (index > 2) ? 3 : 1, index == (50 - 1) ? 1.4 : 1),
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6)),
            ));
      },
      itemCount: homeSearchTitle.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: widget.onChange,
    );
  }


  Widget buildLoadMore(){
    return Row(

      mainAxisAlignment: MainAxisAlignment.center,
        children:
    [
      CupertinoActivityIndicator(radius: 10,),
      Text("正在加载")
    ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
