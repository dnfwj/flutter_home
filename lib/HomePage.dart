import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_home/tab/home_banner_widget.dart';
import 'package:flutter_home/tab/home_tabbar.dart';
import 'package:flutter_home/tab/home_tabbar_content.dart';
import 'package:scroll_to_index/scroll_to_index.dart';


class ShopPage extends StatefulWidget {
  ShopPage({Key key}) : super(key: key);

  @override
  _ShopPageState createState() => _ShopPageState();
}


class _ShopPageState extends State<ShopPage>
    with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  ///页面滑动协调器
  GlobalKey<HomeTabBarState>  homeTabBarState = GlobalKey<HomeTabBarState>();

  final double _tabBarHeight = 50;
  List<Map<String ,String>> homeSearchTitle = [
    {'title': '猜你喜欢', 'subTitle': '我最懂你'},
    {'title': '爆款', 'subTitle': '奥莱专享款'},
    {'title': '每日上新', 'subTitle': '12:00准时上新'},
    {'title': '榜单', 'subTitle': '大家在买'},

  ];


  AutoScrollController _autoController;
  PageController _pageController;




  @override
  void initState() {
    _autoController = AutoScrollController(axis: Axis.vertical);
    _pageController = PageController();

    super.initState();


    print("我是线测试的代码 主分支");
    this.initData();

  }

  initData(){
    print("测试git分支");
  }

 bool  onNotification(ScrollNotification notification){
   //该属性包含当前ViewPort及滚动位置等信息
   ScrollMetrics metrics = notification.metrics;

   if(metrics.axis == Axis.vertical){
     print("滚动到最地步了metrics.pixels:${metrics.pixels} maxScrollExtent:${metrics.maxScrollExtent} minScrollExtent:${metrics.minScrollExtent}");

     if(metrics.minScrollExtent == 0.0 && metrics.pixels == 0.0 ){
       return true;
     }

   }
   return false;
 }


  @override
  Widget build(BuildContext context) {
    super.build(context);

   return Scaffold(
     body:  CustomScrollView(
       slivers: [
         SliverToBoxAdapter(),
         HomeBannerWidget(),
         SliverList(
           delegate: SliverChildBuilderDelegate((BuildContext context, int index){
             return ListTile(title: Text('高度不固定${index+1}'),);
           }, childCount: 29),
         ),

         HomeTabBar(
           tabBarHeight: _tabBarHeight,
           key:homeTabBarState ,
           onChange: (int index){
             _pageController.jumpToPage(index);
           },
         ),
         SliverFillRemaining(
           child: PageView.builder(
             itemBuilder: (BuildContext context, int index) {
               return AutoScrollTag(
                   key: ValueKey(index),
                   controller: _autoController,
                   index: index,
                   child:HomeTabBarContent(index:index)

               );
             },
             itemCount: homeSearchTitle.length,
             scrollDirection: Axis.horizontal,
             controller: _pageController,
             onPageChanged: (int index){
               homeTabBarState.currentState.scrollToIndex(index);
             },
           ),
         )
       ],
     ),
   );





  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
