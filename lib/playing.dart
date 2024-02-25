import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/controllers/music.dart';

class playing extends StatefulWidget {
  _playingState createState() => _playingState();
}

class _playingState extends State<playing> {
  final musicCon = Get.put(MusicController());
  playmusic(url, i) async {
    musicCon.player.stop();
    musicCon.playnow(i);
    final duration = await musicCon.player.setUrl('$url');

    musicCon.player.play();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.keyboard_arrow_down_rounded)),
        ),
        body: Obx(() => Center(
              child: Column(
                children: [
                  Hero(
                    tag: 'pic',
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${musicCon.data[musicCon.play.value ?? 0].album?.coverBig}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${musicCon.data[musicCon.play.value ?? 0].title}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${musicCon.data[musicCon.play.value ?? 0].artist?.name}',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<Duration>(
                          stream: musicCon.player.bufferedPositionStream,
                          builder: (context, buf) {
                            var total = 10;
                            total = buf.data?.inSeconds ?? 10;
                            return StreamBuilder<Duration>(
                              stream: musicCon.player.positionStream,
                              builder: (context, positionSnapshot) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 35),
                                  child: (positionSnapshot.hasData == true &&
                                          buf.hasData == true)
                                      ? Column(
                                          children: [
                                            LinearProgressIndicator(
                                              minHeight: 5,
                                              color: const Color.fromARGB(
                                                  255, 151, 133, 133),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              value: positionSnapshot
                                                      .data!.inSeconds /
                                                  ((total == 0) ? 10 : total),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${positionSnapshot.data.toString().substring(2, 7)}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                Text(
                                                  '${buf.data.toString().substring(2, 7)}',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      : Container(
                                          height: 10,
                                          color: Colors.red,
                                        ),
                                );
                              },
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (musicCon.play.value!.toInt() == 0) {
                                  playmusic('${musicCon.data[0].preview}', 0);
                                } else {
                                  playmusic(
                                      '${musicCon.data[(musicCon.play.value!.toInt() - 1)].preview}',
                                      (musicCon.play.value!.toInt() - 1));
                                }
                              },
                              child: Icon(
                                CupertinoIcons.backward_end_fill,
                                size: 50,
                                color: Colors.grey,
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
                                        size: 50,
                                        color: Colors.grey,
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
                                        size: 50,
                                        color: Colors.grey,
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
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  );
                                }),
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
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Container())
                ],
              ),
            )));
  }
}
