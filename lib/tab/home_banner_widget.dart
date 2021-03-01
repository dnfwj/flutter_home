import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
class HomeBannerWidget extends StatefulWidget {
  @override
  _HomeBannerWidgetState createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget>    {
  double _searchBarHeight = 30;
  double _bannerHeight = 160;

  ValueNotifier<Color> _colors;

  final List _list = [
    {
      'bgColor': "#3C245F",
      'picUrl': "https://ossmp.shanshan-business.com/dadv8i4dgcu3qpo6x6gb.jpg"
    },
    {
      'bgColor': "#681F1F",
      'picUrl': "https://ossmp.shanshan-business.com/et6f4hphvihobj8b4oly.jpg"
    },
    {
      'bgColor': "#8E6A29",
      'picUrl': "https://ossmp.shanshan-business.com/afqtqxkri8mt6d6ukqp9.jpg"
    },
    {
      'bgColor': '#3C3026',
      'picUrl': "https://ossmp.shanshan-business.com/14xp95byb87innahsmpj.jpg"
    },
    {
      'bgColor': "#88312C",
      'picUrl': "https://ossmp.shanshan-business.com/c68fmoenbtna490jwsj3.jpg"
    }
  ];




  @override
  void initState() {
    super.initState();
    _colors = ValueNotifier<Color>(HexColor.fromHex(_list.first["bgColor"]));
  }

  @override
  void deactivate() {
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    double margin = 10;
    double stateHeight = MediaQuery.of(context).padding.top;
    double expandedHeight =
        kToolbarHeight + _bannerHeight + _searchBarHeight + margin * 2;
    double stackHeight =
        stateHeight + kToolbarHeight + _searchBarHeight + _bannerHeight / 2;


    return Theme(
      data: ThemeData(primaryColor:Colors.white,),
      child:  SliverAppBar(
        backgroundColor: Colors.black,
        leading:  IconButton(
          icon: Icon(Icons.menu,color: Colors.white,),
          onPressed: () {},
        ),
        title:  Text('杉杉奥特莱斯',style: TextStyle(color: Colors.white),),
        centerTitle: false,
        pinned: true,
        floating: false,
        snap: false,
        primary: true,

        expandedHeight: expandedHeight,
        //是否显示阴影，直接取值innerBoxIsScrolled，展开不显示阴影，合并后会显示
        // forceElevated: innerBoxIsScrolled,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.more_horiz,color: Colors.white,),
            onPressed: () {
              print("更多");
            },
          ),
        ],
        flexibleSpace: FlexibleSpaceBar(
            background:
            Stack(
              children: [
                ValueListenableBuilder(
                    valueListenable: _colors,
                    builder: (BuildContext context, Color value, Widget child) {
                      return AnimatedContainer(
                        color: value,
                        height: stackHeight,
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(seconds: 1),

                      );
                    }),

                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + kToolbarHeight),
                        height: _searchBarHeight,
                        width: double.infinity,
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(25.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search,
                                size: 24,
                                color: Colors.grey,
                              ),
                              Text(
                                "搜索",
                                style: TextStyle(fontSize: 13, color:  Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: _bannerHeight,
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(20, margin, 20, margin),
                        child: Swiper(
                          key: UniqueKey(),
                          loop: true,
                          autoplay: true,
                          duration: 2000,
                          autoplayDelay: 6000,
                          onIndexChanged: (int index){
                            _colors.value  = HexColor.fromHex(_list[index]["bgColor"]);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(_list[index]["picUrl"],height: _bannerHeight,fit: BoxFit.fill,);
                          },
                          itemCount: _list.length,
                          pagination: SwiperPagination(
                            alignment: Alignment.bottomCenter, //分页指示器的位置
                            margin: EdgeInsets.all(10), //分页指示器与容器边框的距离
                            builder: SwiperPagination.dots, //分页指示器样式
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );


  }


}





extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}