import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_app/Utils/ai_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import '../model/radio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<MyRadio> radios;
  late MyRadio _selectedRadio;

  // late Color _selectedColor;
  bool isPlaying = false;
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchRadios();
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == audioPlayer) {
        isPlaying = false;
      } else {
        isPlaying = true;
      }
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {});
  }

  _playMusic(String url) {
    audioPlayer.play(url as Source);
    _selectedRadio = radios.firstWhere((element) => element.url == url);
    print(_selectedRadio);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(LinearGradient(
                colors: [AIColors.primaryColor1, AIColors.primaryColor2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ))
              .make(),
          AppBar(
            title: "AI Radio".text.xl4.bold.white.make().shimmer(
                primaryColor: Vx.purple300, secondaryColor: Colors.white),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100).p(16),
          Center(
            child: VxSwiper.builder(
              itemCount: radios.length,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              itemBuilder: (context, index) {
                final rad = radios[index];
                return VxBox(
                  child: ZStack(
                    [
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: VxBox(
                          child:
                              rad.category.text.uppercase.white.make().px16(),
                        )
                            .height(40)
                            .black
                            .alignCenter
                            .withRounded(value: 10.0)
                            .make(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VStack(
                          [
                            rad.name.text.xl3.white.bold.make(),
                            5.heightBox,
                            rad.tagline.text.sm.white.semiBold.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      ),
                      Align(
                        child: VStack(
                          [
                            Icon(
                              CupertinoIcons.play_circle,
                              color: Colors.white,
                            ),
                            10.heightBox,
                            "Double to Play".text.gray300.make(),
                          ],
                          crossAlignment: CrossAxisAlignment.center,
                        ),
                      )
                    ],
                  ),
                )
                    .clip(Clip.antiAlias)
                    .bgImage(DecorationImage(
                      image: NetworkImage(rad.image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3),
                        BlendMode.darken,
                      ),
                    ))
                    .border(color: Colors.black, width: 5.0)
                    .withRounded(value: 60.0)
                    .make()
                    .onInkDoubleTap(() {})
                    .p(16);
              },
            ).centered(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(CupertinoIcons.stop_circle,
                color: Colors.white, size: 50.0),
          ).pOnly(bottom: context.percentHeight * 12),
        ],
        fit: StackFit.expand,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
