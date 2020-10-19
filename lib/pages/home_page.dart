import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String homePageContent = '正在获取数据';

  @override
  void initState() {
    getHomePageContent().then((value) {
      setState(() {
        homePageContent = value.toString();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('百姓生活+'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String adPicture =
                data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片

            return Column(
              children: [
                SwiperDiy(swiperDataList: swiper),
                TopNavigator(
                  navigatorList: navgatorList,
                ),
                AdBanner(
                  adPicture: adPicture,
                )
              ],
            );
          } else {
            return Center(
              child: Text('加载中'),
            );
          }
        },
        future: getHomePageContent(),
      ),
    );
  }
}

//首页轮播组件
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('设备像素密度:${ScreenUtil().pixelRatio}');
    print('设备的高度:${ScreenUtil().screenHeight}');
    print('设备的宽度:${ScreenUtil().screenWidth}');

    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {
  final List navigatorList;

  const TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: [
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String adPicture;

  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}
