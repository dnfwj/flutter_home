
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_home/home_banner_widget.dart';
import 'package:flutter_home/tab/home_tabbar.dart';
import 'package:flutter_home/tab/home_tabbar_content.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}


class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  ///页面滑动协调器
  GlobalKey<HomeTabBarState>  homeTabBarState = GlobalKey<HomeTabBarState>();
  GlobalKey<HomeTabBarContentState>  homeTabBarContentState = GlobalKey<HomeTabBarContentState>();

  ScrollController _scrollController = ScrollController();
  final double _tabBarHeight = 50;
  List<Map<String ,String>> homeSearchTitle = [
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},

  ];

  //子控件是否滑动了
  Drag drag;
  DragStartDetails dragStartDetails;
  bool onEdge = false;

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 滑动冲突，解决列表滑动流畅即可，必须在CustomScrollView里面使用flutter_staggered_grid_view

    return Scaffold(
      body:  CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(),
          HomeBannerWidget(),
          SliverPadding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 3),
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return Container(
                  color: Colors.primaries[index % Colors.primaries.length],
                );
              }, childCount: 20),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return ListTile(title: Text('高度不固定${index+1}'),);
            }, childCount: 40),
          ),

          HomeTabBar(
            tabBarHeight: _tabBarHeight,
            key:homeTabBarState ,
            onChange: (int index){
              homeTabBarContentState.currentState.scrollToIndex(index);
            },
          ),
          SliverFillRemaining(
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 3,
                itemCount:200,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int childIndex) {
                  return Container(
                    color: Colors.green,
                    child: Text("$childIndex"),
                  );
                },
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.count((index > 2) ? 3 : 1, 1),
                mainAxisSpacing: 6,
                crossAxisSpacing: 6)
          )
        ],
      )

    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
