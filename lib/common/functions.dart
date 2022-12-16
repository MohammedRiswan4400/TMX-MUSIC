import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../model/tmx_plater.dart';
import '../screen/playlist/nowplaying.dart';
import '../widgets/mini_player.dart';

void showMiniplayerBottom({
  required BuildContext context,
  required List<Songs> songList,
  required int index,
  required AssetsAudioPlayer audioPlayer,
}) {
  showBottomSheet(
      context: context,
      builder: (context) {
        return MiniPlayer(
          index: index,
          songList: songList,
          audioPlayer: audioPlayer,
        );
      },
      backgroundColor: tmxTransparent);
}

// ignore: non_constant_identifier_names
void goto_nowplaying({
  required BuildContext context,
  required AssetsAudioPlayer audioPlayer,
  required List<Audio> songAudioList,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => NowPlaying(
        audioPlayer: audioPlayer,
        songList: songAudioList,
      ),
    ),
  );
}
