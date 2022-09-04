import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'adstate.dart';


int state=0;

/*
class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get bannerAdUnitId =>
      Platform.isAndroid ? "Aca-app-pub-3940256099942544/6300978111 ": "ca-app-pub-3940256099942544/2934735716";
  get adListener => null;
}
*/

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  runApp(Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
  ),
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       title: 'Flutter Demo',

      theme: ThemeData(
        primarySwatch:Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  BannerAd banner;
  bool _showFrontSide;
  bool _flipXAxis;
  int coin_state_num;
  bool result_state;
  int delay_num;
  bool _isDisabled;
  double shadowvalue;
  var random = new math.Random();

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
    result_state = false;
    coin_state_num = 0;
    delay_num = 0;
    _isDisabled=false;
    shadowvalue=0;
  }

  //広告表示用//
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

//広告表示用
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        child: Center(

          child: Container(
            constraints: BoxConstraints.tight(Size.square(200.0)),
            child:result_state ? _buildFlipAnimation2():_buildFlipAnimation(),
          ),
        ),
      ),


//広告追加スタート
        bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          /*
          AdmobBanner(
             adUnitId: AdMobService().getBannerAdUnitId(),
             adSize: AdmobBannerSize(),
              width: MediaQuery.of(context).size.width.toInt(),
              height: AdMobService().getHeight(context).toInt(),
              name: 'SMART_BANNER',
             )
          */
          //  Container(height: 40, color: Colors.cyan, child: Center(child: Text('AdMob Text'))),
            if (banner == null)
              SizedBox(height: 320) // Ads
            else
              Container(
                height: 50,
                child: AdWidget(ad: banner),
              ),
           // Container(height: 200, color: Colors.lightBlue, child: Center(child: Text('AdMob Text'))),


         ///////
          //ボトムナビゲーションバー 不要であるためコメントアウト
          ///////
         // BottomNavigationBar(
           // items: const [
              //BottomNavigationBarItem(
               //icon: Icon(Icons.home),
               // label: '',
             // ),
              //BottomNavigationBarItem(
                //icon: Icon(Icons.list),
                //label: '',
              //),
              //BottomNavigationBarItem(
                //icon: Icon(Icons.person),
                //label: '',
              //)
            //],
          //),
    ],
),
//広告追加　END

    );
  }//end

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = !_flipXAxis;
    });

  }

  void _switchCard() {
    setState(() {
      _flipXAxis =!_flipXAxis;
      if (result_state == false) {
        if (random.nextInt(2) == 0) {
          coin_state_num = 3;
          result_state = true;

        }
        else {
          coin_state_num = 2;
          result_state = true;

        }
      } //リザルト状態判定
      else {
        coin_state_num = 0;
        result_state = false;

      }
    });

  }

  void _switchshadowon() {

    setState(() {
      if (result_state == true) {
        shadowvalue = 20;
      }
    });
  }

  void _switchshadowoff() {

    setState(() {
      if (result_state == false) {
        shadowvalue = 0;
      }
    });
  }


  Widget _buildFlipAnimation() {

    return GestureDetector(
      onTap: _isDisabled ?  null :() async {
        HapticFeedback.heavyImpact();
        _switchCard();
        _switchshadowoff();
        setState(() => _isDisabled = true); //ボタンを無効
        await Future.delayed(
          Duration(milliseconds:700 ), //無効にする時間
        );

        setState(() => _isDisabled = false); //ボタンを有効
        _switchshadowon();
      },

      child:
      AnimatedSwitcher(
        duration: Duration(milliseconds: 700),

        // 状態に応じて待ち時間変更する方法は？
        transitionBuilder:result_state ? __transitionBuilder:__transitionBuilder2,

        layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
        //child: _showFrontSide ? _buildFront() : _buildRear(),
        child: (() {
          switch (coin_state_num) {
            case 0:
              return _buildFront();
            case 1:
              return _buildRear();
            case 2:
              return _buildFront2();
            case 3:
              return _buildRear2();
          }
        })(),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),

    );
  }


  Widget _buildFlipAnimation2() {

    return GestureDetector(
      onTap: _isDisabled ?  null :() async {
        HapticFeedback.heavyImpact();
        _switchCard();
        _switchshadowoff();
        setState(() => _isDisabled = true); //ボタンを無効
        await Future.delayed(
          Duration(milliseconds:700 ), //無効にする時間
        );

        setState(() => _isDisabled = false); //ボタンを有効
        _switchshadowon();
      },

      child:
      AnimatedSwitcher(
        duration: Duration(milliseconds: 100),

        // 状態に応じて待ち時間変更する方法は？
        transitionBuilder:result_state ? __transitionBuilder:__transitionBuilder2,

        layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
        //child: _showFrontSide ? _buildFront() : _buildRear(),
        child: (() {
          switch (coin_state_num) {
            case 0:
              return _buildFront();
            case 1:
              return _buildRear();
            case 2:
              return _buildFront2();
            case 3:
              return _buildRear2();
          }
        })(),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),

    );
  }


  Widget __transitionBuilder(Widget widget, Animation<double> animation) {

    if(result_state==true ){
      final rotateAnim = Tween(begin: 10 * pi, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: rotateAnim,
        child: widget,
        builder: (context, widget) {
          final isUnder = (ValueKey(_showFrontSide) != widget.key);
          var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isUnder ? -1.0 : 1.0;
          final value = isUnder ? min(rotateAnim.value, 10 * pi) : rotateAnim.value;
          return Transform(
            transform: _flipXAxis
                ? (Matrix4.rotationY(value)
              ..setEntry(3, 0, tilt))
                : (Matrix4.rotationX(value)
              ..setEntry(3, 1, tilt)),
            child: widget,
            alignment: Alignment.center,
          );
        },
      );
    }

    else {

      final rotateAnim2 = Tween(begin: 0.0, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: rotateAnim2,
        child: widget,
        builder: (context, widget) {
          final isUnder2 = (ValueKey(_showFrontSide) != widget.key);
          var tilt2 = animation.value;
          tilt2 *= 0;
          final value2 =  rotateAnim2.value;
          return Transform(
            transform: _flipXAxis
                ? (Matrix4.rotationY(0)
              ..setEntry(3, 0, tilt2))
                : (Matrix4.rotationX(0)
              ..setEntry(3, 1, tilt2)),
            child: widget,
            alignment: Alignment.center,

          );
        },
      );
    }
  }

  Widget __transitionBuilder2(Widget widget, Animation<double> animation) {

    if(result_state==true) {
      final rotateAnim = Tween(begin: 10 * pi, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: rotateAnim,
        child: widget,
        builder: (context, widget) {
          final isUnder = (ValueKey(_showFrontSide) != widget.key);
          var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
          tilt *= isUnder ? -1.0 : 1.0;
          final value = isUnder ? min(rotateAnim.value, 10 * pi) : rotateAnim.value;
          return Transform(
            transform: _flipXAxis
                ? (Matrix4.rotationY(value)
              ..setEntry(3, 0, tilt))
                : (Matrix4.rotationX(value)
              ..setEntry(3, 1, tilt)),
            child: widget,
            alignment: Alignment.center,
          );
        },
      );
    }

    else {

      final rotateAnim2 = Tween(begin: 0.0, end: 0.0).animate(animation);
      return AnimatedBuilder(
        animation: rotateAnim2,
        child: widget,
        builder: (context, widget) {
          final isUnder2 = (ValueKey(_showFrontSide) != widget.key);
          var tilt2 = animation.value;
          tilt2 *= 0;
          final value2 =  rotateAnim2.value;
          return Transform(
            transform: _flipXAxis
                ? (Matrix4.rotationY(0)
              ..setEntry(3, 0, tilt2))
                : (Matrix4.rotationX(0)
              ..setEntry(3, 1, tilt2)),
            child: widget,
            alignment: Alignment.center,

          );
        },
      );
    }
  }



  Widget _buildFront() {
    return __buildLayout(

      key: ValueKey(1),
      backgroundColor: Colors.cyan,
      faceName: "表",
      child: Container(//Padding]
        //padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(

      key: ValueKey(2),
      backgroundColor: Colors.cyan,
      faceName: "裏",
      child: Container(//Padding]

        //padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildFront2() {
    return __buildLayout(

      key: ValueKey(3),
      backgroundColor: Colors.cyan,
      faceName: "表",
      child: Container(//Padding]

        //padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear2() {
    return __buildLayout(

      key: ValueKey(4),
      backgroundColor: Colors.cyan,
      faceName: "裏",
      child: Container(//Padding]

        //adding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }


  Widget __buildLayout({Key key, Widget child, String faceName, Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(150, 0, 250, 100),
            blurRadius: 10,//shadowvalue,
            spreadRadius: shadowvalue,
          )
        ],
        //borderRadius: BorderRadius.circular(20.0),

      ),

      child: Center(
        child: Text(faceName.substring(0, 1),
          style: TextStyle(fontSize: 80.0,
            color:Colors.white,
          ),
        ),
      ),
    );
    return Container(
      key: key,
      decoration: BoxDecoration(
        //     color: backgroundColor,
        //     borderRadius: BorderRadius.circular(12.0),
        //   ),
        //   child: Stack(
        //     fit: StackFit.expand,
        //     children: [
        //       child,
        //       Positioned(
        //         bottom: 8.0,
        //         right: 8.0,
        //         child: Text(faceName),
        //       ),
        //     ],
      ),
    );
  }
}