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
  AutoScrollController _autoController;
  PageController _pageController;
  String loadMoreText = "正在加载.....";
  List<int> _data = [0, 1, 2, 3, 4, 5, 6, 7,8,9,10];
  bool isLoadingMore = true;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _autoController = AutoScrollController(axis: Axis.vertical);
    _pageController = PageController();
  }

  scrollToIndex(int index) {
    _index = index;
    _pageController.jumpToPage(index);
  }

  loadMore() {

    print("调用过一次+$_index"+isLoadingMore.toString());

    if(isLoadingMore){
      isLoadingMore = false;

      Future.delayed(Duration(seconds: 4), () {
        List<int> data = [];
        data.addAll(_data);
        for (int i = 1; i < 20; i++) {
          data.add(data[i] + i);
        }
        isLoadingMore = true;
        this.setState(() {
          _data = data;
        });

      });
    }
    //判断是猜你喜欢，还是爆款还是每日上新，还是榜单

  }
  bool onNotification(ScrollNotification notification){
    final ScrollMetrics metrics = notification.metrics;
    if(metrics.axis == Axis.vertical ){
      if(metrics.pixels == metrics.maxScrollExtent && metrics.axisDirection == AxisDirection.down){
        this.loadMore();
        return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {

    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return AutoScrollTag(
            key: ValueKey(index),
            controller: _autoController,
            index: index,
            child: NotificationListener(
              onNotification: this.onNotification,
              child: Container(
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 3,
                        itemCount: _data.length,
                        shrinkWrap: true, // todo comment this out and check the result
                        physics: ClampingScrollPhysics(), // todo comment this out and check the result
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
                        crossAxisSpacing: 6)
                ),
              ),
            ));
      },
      itemCount: homeSearchTitle.length,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      onPageChanged: (int index){
        _index = index;
        widget.onChange(index);
      },
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
    _pageController.dispose();
    _autoController.dispose();
    super.dispose();
  }
}
