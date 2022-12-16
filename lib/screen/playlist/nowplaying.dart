import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../../functions/alert_function.dart';
import '../../functions/fav_function.dart';
import '../../functions/recent_functions.dart';
import '../../model/tmx_plater.dart';

class NowPlaying extends StatefulWidget {
  final AssetsAudioPlayer audioPlayer;
  final List<Audio> songList;
  // final int index;

  const NowPlaying({
    super.key,
    required this.audioPlayer,
    required this.songList,
    // required this.index,
  });

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  Widget buildSheet() {
    return widget.audioPlayer.builderCurrent(builder: (context, playing) {
      final myAudio = find(widget.songList, playing.audio.assetAudioPath);
      Recents.addSongsToRecents(songId: myAudio.metas.id!);
      return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(227, 7, 7, 7)),
            height: double.infinity,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 35),
                child: Center(
                  child: QueryArtworkWidget(
                    artworkHeight: 140,
                    artworkWidth: 140,
                    artworkFit: BoxFit.cover,
                    artworkBorder: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    id: int.parse(myAudio.metas.id!),
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Image.asset(
                        "asset/images/idfc.jpg",
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              text(
                  size: 17,
                  weight: FontWeight.w400,
                  color: tmxWhite,
                  write: widget.audioPlayer.getCurrentAudioTitle),
              text(
                  size: 14,
                  weight: FontWeight.w400,
                  color: tmxWhite,
                  write: widget.audioPlayer.getCurrentAudioArtist),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Favourites.isThisFavourite(
                              id: myAudio.metas.id!,
                            ),
                            size: 30,
                            color: tmxWhite,
                          ),
                          onPressed: () {
                            Favourites.addSongToFavourites(
                              context: context,
                              id: myAudio.metas.id!,
                            );
                            setState(() {
                              Favourites.isThisFavourite(
                                id: myAudio.metas.id!,
                              );
                            });
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(
                          width: 13,
                        ),
                        text(
                            size: 13,
                            weight: FontWeight.w400,
                            color: tmxWhite,
                            write: "Favorites"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                        onTap: () {
                          final song = Songs(
                            id: myAudio.metas.id!,
                            songname: myAudio.metas.title!,
                            artist: myAudio.metas.artist!,
                            uri: myAudio.path,
                          );
                          showPlaylistModalSheet(
                            context: context,
                            screenHeight: 500,
                            song: song,
                          );
                          // Navigator.pop(context);
                          // addSongToPlaylist();
                        },
                        child: Row(
                          children: [
                            maincons(
                                icon: Icons.queue_music_rounded,
                                iconColor: tmxWhite,
                                iconSize: 30),
                            const SizedBox(
                              width: 20,
                            ),
                            text(
                                size: 13,
                                weight: FontWeight.w400,
                                color: tmxWhite,
                                write: "Add to Playlist"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // )
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: GestureDetector(
                          child: Row(
                            children: [
                              maincons(
                                  icon: Icons.ios_share_rounded,
                                  iconColor: tmxWhite,
                                  iconSize: 30),
                              const SizedBox(
                                width: 20,
                              ),
                              text(
                                  size: 13,
                                  weight: FontWeight.w400,
                                  color: tmxWhite,
                                  write: "Share"),
                            ],
                          ),
                          onTap: () async {
                            await Share.share(
                              'Download TMX Music from Playstore For Free \nDownload Now On Playstore',
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ]),
      );
    });
  }

  Widget maincons({
    required IconData icon,
    required Color iconColor,
    required double iconSize,
  }) {
    return Icon(
      icon,
      color: iconColor,
      size: iconSize,
    );
  }

  Widget image(
      {required String image, required double height, required double width}) {
    return Image.asset(
      image,
      height: height,
      width: width,
    );
  }

  Widget text({
    required double size,
    required FontWeight weight,
    required Color color,
    required String write,
  }) {
    return Text(
      write,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.ubuntu(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }

  bool isshuffle = true;
  bool isLoop = true;
  void shuffleButtonPressed() {
    setState(() {
      widget.audioPlayer.toggleShuffle();
      isshuffle = !isshuffle;
    });
  }

  void repeatButtonPressed() {
    if (isLoop == true) {
      widget.audioPlayer.setLoopMode(LoopMode.single);
    } else {
      widget.audioPlayer.setLoopMode(LoopMode.playlist);
    }
    setState(() {
      isLoop = !isLoop;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.audioPlayer.builderCurrent(
      builder: (context, playing) {
        final myAudio = find(widget.songList, playing.audio.assetAudioPath);
        Recents.addSongsToRecents(songId: myAudio.metas.id!);

        return Container(
          decoration: const BoxDecoration(
            gradient: tmxBackground,
          ),
          child: Scaffold(
            backgroundColor: tmxTransparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Image.asset(
                              "asset/images/IMG_8227.PNG",
                              height: 30,
                              width: 20,
                            ),
                          ),
                          text(
                              size: 28,
                              weight: FontWeight.w500,
                              color: tmxWhite,
                              write: "Now Playing"),
                          GestureDetector(
                            child: maincons(
                                icon: Icons.more_vert_rounded,
                                iconColor: menuIconColor,
                                iconSize: 23),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => buildSheet(),
                                backgroundColor: tmxTransparent,
                              );
                            },
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QueryArtworkWidget(
                            artworkHeight: 250,
                            artworkWidth: 250,
                            artworkFit: BoxFit.cover,
                            artworkBorder: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            id: int.parse(myAudio.metas.id!),
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Image.asset(
                                "asset/images/idfc.jpg",
                                height: 250,
                                width: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 43, 61, 77),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                height: 50,
                                width: 140,
                              ),
                              Positioned(
                                  left: 47,
                                  top: 2.5,
                                  child: Image.asset(
                                    "asset/images/IMG_8227.PNG",
                                    height: 45,
                                    width: 45,
                                  ))
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          ListTile(
                            title: text(
                              size: 25,
                              weight: FontWeight.w400,
                              color: tmxWhite,
                              write: widget.audioPlayer.getCurrentAudioTitle,
                            ),
                            subtitle: text(
                                size: 20,
                                weight: FontWeight.w400,
                                color: nowArtist,
                                write:
                                    widget.audioPlayer.getCurrentAudioArtist),
                            trailing: Wrap(
                              spacing: 12,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    (isshuffle == true)
                                        ? Icons.shuffle_rounded
                                        : Icons.shuffle_on_rounded,
                                    size: 28,
                                    color: tmxWhite,
                                  ),
                                  onPressed: () {
                                    shuffleButtonPressed();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Favourites.isThisFavourite(
                                      id: myAudio.metas.id!,
                                    ),
                                    size: 30,
                                    color: tmxWhite,
                                  ),
                                  onPressed: () {
                                    Favourites.addSongToFavourites(
                                      context: context,
                                      id: myAudio.metas.id!,
                                    );
                                    setState(() {
                                      Favourites.isThisFavourite(
                                        id: myAudio.metas.id!,
                                      );
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    (isLoop == true)
                                        ? Icons.repeat_rounded
                                        : Icons.repeat_one_outlined,
                                    color: tmxWhite,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    repeatButtonPressed();
                                  },
                                ),
                              ],
                            ),
                          ),
                          widget.audioPlayer.builderRealtimePlayingInfos(
                            builder: (context, info) {
                              final duration = info.current!.audio.duration;
                              final position = info.currentPosition;
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                child: ProgressBar(
                                  progress: position,
                                  total: duration,
                                  onSeek: (duration) {
                                    widget.audioPlayer.seek(duration);
                                  },
                                  timeLabelTextStyle:
                                      const TextStyle(color: tmxWhite),
                                  barHeight: 2,
                                  thumbRadius: 5,
                                  baseBarColor:
                                      const Color.fromARGB(98, 87, 87, 87),
                                  progressBarColor: tmxWhite,
                                  thumbColor: tmxWhite,
                                  thumbGlowColor:
                                      const Color.fromARGB(121, 66, 66, 66),
                                  thumbGlowRadius: 12,
                                  bufferedBarColor: Colors.amber,
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: const Icon(
                                    Icons.skip_previous_rounded,
                                    color: tmxWhite,
                                    size: 50,
                                  ),
                                  onTap: () async {
                                    await widget.audioPlayer.previous();
                                  },
                                  onDoubleTap: () {},
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.replay_10_rounded,
                                    color: tmxWhite,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    widget.audioPlayer.seekBy(
                                      const Duration(seconds: -10),
                                    );
                                  },
                                ),
                                PlayerBuilder.isPlaying(
                                    player: widget.audioPlayer,
                                    builder: ((context, isPlaying) {
                                      return GestureDetector(
                                        child: Icon(
                                          (isPlaying == true)
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          color: tmxWhite,
                                          size: 60,
                                        ),
                                        onTap: () async {
                                          await widget.audioPlayer
                                              .playOrPause();
                                        },
                                      );
                                    })),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.forward_10_rounded,
                                    color: tmxWhite,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    widget.audioPlayer
                                        .seekBy(const Duration(seconds: 10));
                                  },
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.skip_next_rounded,
                                    color: tmxWhite,
                                    size: 50,
                                  ),
                                  onTap: () async {
                                    await widget.audioPlayer.next();
                                  },
                                  onDoubleTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
