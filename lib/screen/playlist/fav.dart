import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmx_player/widgets/colors.dart';
import 'package:tmx_player/widgets/song_tile.dart';
import '../../model/db_functions/db_functions.dart';
import '../../model/tmx_plater.dart';

// ignore: must_be_immutable
class Fav extends StatelessWidget {
  Fav({super.key, required this.playlistName});
  final String playlistName;

  static final Box<List> playlistBox = getPlaylitBox();
  final Box<Songs> songBox = getSongBox();

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Songs> songList = [];

  Widget text({
    required double size,
    required FontWeight weight,
    required Color color,
    required String write,
  }) {
    return Text(
      write,
      style: GoogleFonts.ubuntu(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: tmxBackground,
      ),
      child: Scaffold(
        backgroundColor: tmxTransparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        text(
                          size: 28,
                          weight: FontWeight.w500,
                          color: tmxWhite,
                          write: playlistName,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: playlistBox.listenable(),
                  builder:
                      (BuildContext context, Box<List> value, Widget? child) {
                    List<Songs> songList =
                        value.get(playlistName)!.toList().cast<Songs>();
                    return (songList.isEmpty)
                        ? Center(
                            child: text(
                                size: 15,
                                weight: FontWeight.bold,
                                color: emptyColors,
                                write: "No Songs"))
                        : ListView.builder(
                            itemCount: songList.length,
                            itemBuilder: (context, index) {
                              return SongTile(
                                songList: songList,
                                index: index,
                                audioPlayer: audioPlayer,
                              );
                            },
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
