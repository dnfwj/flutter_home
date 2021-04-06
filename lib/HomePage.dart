import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_home/scroll/OutLetNestedScroll.dart';
import 'package:flutter_home/tab/home_banner_widget.dart';
import 'package:flutter_home/tab/home_tabbar.dart';
import 'package:flutter_home/tab/home_tabbar_content.dart';
import 'package:flutter_home/wrap_notify_widget.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'scroll/NestedRefreshIndicator.dart';


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

  final double _tabBarHeight = 50;
  List<Map<String ,String>> homeSearchTitle = [
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},

  ];






  @override
  void initState() {
    super.initState();



  }




  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body:
      NestedRefreshIndicator(
        //可滚动组件在滚动时会发送ScrollNotification类型的通知
          notificationPredicate: (ScrollNotification notification) {

            //该属性包含当前ViewPort及滚动位置等信息
            ScrollMetrics metrics = notification.metrics;

            if(metrics.axis == Axis.vertical){
              print("12312312");
              print(metrics.minScrollExtent == 0.0);
              return  metrics.minScrollExtent == 0.0 ;
            }
            return false;
          },
          //下拉刷新回调方法
          onRefresh: () async {



            //模拟网络刷新 等待2秒
            await Future.delayed(Duration(milliseconds: 2000));
            //返回值以结束刷新
            return Future.value(true);
          },
          child: NestedScrollView (
            headerSliverBuilder:(BuildContext context, bool innerBoxIsScrolled){
              return [
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
                    }, childCount: 10),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                    return ListTile(title: Text('高度不固定${index+1}'),);
                  }, childCount: 29),
                ),

                HomeTabBar(
                  tabBarHeight: _tabBarHeight,
                  key:homeTabBarState ,
                  onChange: (int index){
                    homeTabBarContentState.currentState.scrollToIndex(index);
                  },
                ),
              ];
            },

            body:

            // Container(
            //   height: 200,
            // )

            HomeTabBarContent(
              key: homeTabBarContentState,
              onChange: (int index){
                homeTabBarState.currentState.scrollToIndex(index);
              }
              ,


            ),
          )
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
