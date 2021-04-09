import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabBarContent extends StatefulWidget {
  final  int index;
  const HomeTabBarContent({Key key, this.index,})
      : super(key: key);
  @override
  HomeTabBarContentState createState() => HomeTabBarContentState();
}

class HomeTabBarContentState extends State<HomeTabBarContent> {

  String loadMoreText = "正在加载.....";
  List<int> _data = [0, 1, 2, 3, 4, 5, 6, 7,8,9,10];
  bool isLoadingMore = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   return Container(

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
                     child: Text( "${widget.index}======$childIndex"),
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

}
