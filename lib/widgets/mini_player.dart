import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tmx_player/screen/playlist/nowplaying.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../functions/recent_functions.dart';
import '../model/tmx_plater.dart';

class MiniPlayer extends StatefulWidget {
  final int index;
  final List<Songs> songList;
  final AssetsAudioPlayer audioPlayer;

  const MiniPlayer({
    Key? key,
    required this.index,
    required this.songList,
    required this.audioPlayer,
  }) : super(key: key);

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  List<Audio> songAudioList = [];

  @override
  void initState() {
    openAudioPlayer();
    super.initState();
  }

  Future<void> openAudioPlayer() async {
    convertSongToAudio();
    widget.audioPlayer.open(
      Playlist(audios: songAudioList, startIndex: widget.index),
      showNotification: true,
      autoStart: true,
    );
  }

  void convertSongToAudio() {
    for (var song in widget.songList) {
      final Audio audio = Audio.file(
        song.uri,
        metas: Metas(
          id: song.id,
          artist: song.artist,
          title: song.songname,
        ),
      );
      songAudioList.add(audio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioPlayer.builderCurrent(builder: (context, playing) {
      final myAudio = find(songAudioList, playing.audio.assetAudioPath);
      Recents.addSongsToRecents(songId: myAudio.metas.id!);
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), gradient: miniColor),
        height: 72,
        width: double.infinity,
        child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NowPlaying(
                    audioPlayer: widget.audioPlayer,
                    songList: songAudioList,
                    // index: 1,
                  ),
                ),
              );
            },
            leading: QueryArtworkWidget(
              artworkFit: BoxFit.cover,
              artworkHeight: 58,
              artworkWidth: 58,
              artworkBorder: BorderRadius.circular(10),
              id: int.parse(myAudio.metas.id!),
              type: ArtworkType.AUDIO,
              nullArtworkWidget: ClipRRect(
                // clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "asset/images/idfc.jpg",
                  height: 58,
                  width: 58,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              widget.audioPlayer.getCurrentAudioTitle,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ubuntu(color: tmxWhite, fontSize: 16),
            ),
            subtitle: Text(
              widget.audioPlayer.getCurrentAudioArtist,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.ubuntu(color: miniArtist, fontSize: 14),
            ),
            trailing: Wrap(
              spacing: 10,
              children: [
                PlayerBuilder.isPlaying(
                  player: widget.audioPlayer,
                  builder: (context, isPlaying) {
                    return GestureDetector(
                      child: Icon(
                        (isPlaying == true)
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 40,
                        color: miniIconsC,
                      ),
                      onTap: () {
                        widget.audioPlayer.playOrPause();
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.skip_next_rounded,
                    size: 40,
                    color: miniIconsC,
                  ),
                  onTap: () {
                    widget.audioPlayer.next();
                  },
                  onDoubleTap: () {},
                ),
              ],
            )),
      );
    });
  }
}
