
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_home/scroll/OutLetNestedScroll.dart';
import 'package:flutter_home/tab/home_banner_widget.dart';
import 'package:flutter_home/tab/home_tabbar.dart';
import 'package:flutter_home/tab/home_tabbar_content.dart';
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
  GlobalKey<OutLetNestedScrollState>  _outLet = GlobalKey<OutLetNestedScrollState>();

  ScrollController _scrollController = ScrollController();
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


    //
   _scrollController.addListener(() {
      if( _scrollController.position.maxScrollExtent==  _scrollController.position.pixels){
        print("外部滑动到底了----");
        _outLet.currentState.innerController.addListener(() {
          print("内部开始滚动---${_outLet.currentState.innerController.position.pixels}");
          if(  _outLet.currentState.innerController.position.maxScrollExtent==   _outLet.currentState.innerController.position.pixels){
            print("内部滑动到底了----");
            homeTabBarContentState.currentState.loadMore();
          }
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    super.build(context);


   print("_outLet.currentState.innerController");
    print(_outLet.currentState.innerController);

    return Scaffold(
      body:
      NestedRefreshIndicator(
        notificationPredicate: (ScrollNotification notification) {

          return true;
        },
        onRefresh: () {
          return Future.delayed(Duration(seconds: 2), () {
            return true;
          });
        },
        child: OutLetNestedScroll(
          key: _outLet,
            controller: _scrollController,
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
              ];

            } ,
            body:  HomeTabBarContent(
              key: homeTabBarContentState,
              onChange: (int index){
                homeTabBarState.currentState.scrollToIndex(index);
              }
              ,
            )
        ) ,
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
