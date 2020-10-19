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
            return Column(
              children: [SwiperDiy(swiperDataList: swiper)],
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
    ScreenUtil.init(context, designSize: Size(750, 1334));
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
