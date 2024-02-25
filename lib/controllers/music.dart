import 'dart:convert';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as Http;
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/models/musicclass.dart';

class MusicController extends GetxController {
  RxList data = [].obs;
  RxInt title = 0.obs;
  var play = Rx<int?>(null);
  final player = AudioPlayer();

  @override
  void onInit() async {
    // add();
    await getData();
    super.onInit();
  }

  void add() {
    title.value = 10;
  }

  void playnow(int now) {
    play.value = now;
  }

  Future getData() async {
    final response = await Http.get(
      Uri.parse('https://api.deezer.com/search/track?q=taylor swift'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['data'];

      data.value = jsonResponse.map((m) => MusicData.fromJson(m)).toList();
      print(data);

      return response;
    }
  }
}
