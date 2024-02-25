import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:get/state_manager.dart';
import 'package:musicapp/controllers/music.dart';
import 'package:musicapp/playing.dart';

class playlist extends StatefulWidget {
  @override
  _playlistState createState() => _playlistState();
}

class _playlistState extends State<playlist> {
  final musicCon = Get.put(MusicController());
  // final player = AudioPlayer();

  playmusic(url, i) async {
    musicCon.player.stop();
    musicCon.playnow(i);
    final duration = await musicCon.player.setUrl('$url');

    musicCon.player.play();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text('My Playlist'),
          centerTitle: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Obx(() => (musicCon.play.value == null)
            ? Container()
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => playing(),
                        fullscreenDialog: true,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        height: 60,
                        // width: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Hero(
                              tag: 'pic',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  '${musicCon.data[musicCon.play.value ?? 0].album?.cover}',
                                  height: 50,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '${musicCon.data[musicCon.play.value ?? 0].title}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            StreamBuilder(
                                stream: musicCon.player.playerStateStream,
                                builder: (context, snapshot) {
                                  final playerState = snapshot.data;
                                  final playing = playerState?.playing;
                                  final prosess = playerState?.processingState;
                                  print(playing);
                                  if (!(playing ?? false)) {
                                    return GestureDetector(
                                      onTap: () {
                                        musicCon.player.play();
                                      },
                                      child: Icon(
                                        CupertinoIcons.play_arrow_solid,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (prosess !=
                                      ProcessingState.completed) {
                                    return GestureDetector(
                                      onTap: () {
                                        musicCon.player.pause();
                                      },
                                      child: Icon(
                                        CupertinoIcons.pause_fill,
                                        size: 35,
                                        color: Colors.white,
                                      ),
                                    );
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      playmusic(
                                          '${musicCon.data[(musicCon.play.value!.toInt())].preview}',
                                          (musicCon.play.value!.toInt()));
                                    },
                                    child: Icon(
                                      CupertinoIcons.play_arrow_solid,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (musicCon.play.value!.toInt() + 1 >
                                    musicCon.data.length - 1) {
                                  playmusic('${musicCon.data[0].preview}', 0);
                                } else {
                                  playmusic(
                                      '${musicCon.data[(musicCon.play.value!.toInt() + 1)].preview}',
                                      (musicCon.play.value!.toInt() + 1));
                                }
                              },
                              child: Icon(
                                CupertinoIcons.forward_end_fill,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        body: Obx(() => ListView.builder(
            padding: EdgeInsets.only(top: 10, bottom: 100),
            itemCount: musicCon.data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: GestureDetector(
                  onTap: () {
                    print('${musicCon.data[index].preview}');

                    playmusic('${musicCon.data[index].preview}', index);
                  },
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                '${musicCon.data[index].album?.coverBig}',
                                height: 65,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${musicCon.data[index].title}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '${musicCon.data[index].artist?.name}',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() => (musicCon.play == index)
                                ? Icon(
                                    Icons.music_note_rounded,
                                    color: Colors.grey,
                                  )
                                : Container())
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 90),
                          child: Divider(
                            thickness: 0.1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            })));
  }
}
