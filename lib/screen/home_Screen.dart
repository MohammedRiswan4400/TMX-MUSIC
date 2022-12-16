import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tmx_player/common/functions.dart';
import 'package:tmx_player/screen/playlist_screen.dart';
import 'package:tmx_player/widgets/colors.dart';
import 'package:tmx_player/widgets/song_tile.dart';
import '../model/db_functions/db_functions.dart';
import '../model/tmx_plater.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) {
      return element.path == fromPath;
    });
  }

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylitBox();
  List<Songs> mostSongsList = [];
  List<Songs> songList = [];

  @override
  void initState() {
    songList = songBox.values.toList().cast<Songs>();
    mostSongsList = playlistBox.get('Most Played')!.toList().cast<Songs>();
    super.initState();
  }

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

  Widget buildSheet() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: double.infinity,
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 35,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    "asset/images/love.jpg",
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
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
                write: "Love nwantiti"),
            text(
                size: 14,
                weight: FontWeight.w400,
                color: tmxWhite,
                write: "Ckay"),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      maincons(
                          icon: Icons.favorite_border_outlined,
                          iconColor: tmxWhite,
                          iconSize: 23),
                      const SizedBox(
                        width: 13,
                      ),
                      text(
                          size: 13,
                          weight: FontWeight.w400,
                          color: tmxWhite,
                          write: "Add to Favorites"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      maincons(
                          icon: Icons.queue_music_rounded,
                          iconColor: tmxWhite,
                          iconSize: 23),
                      const SizedBox(
                        width: 13,
                      ),
                      text(
                          size: 13,
                          weight: FontWeight.w400,
                          color: tmxWhite,
                          write: "Add to Playlist"),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      maincons(
                          icon: Icons.ios_share_rounded,
                          iconColor: tmxWhite,
                          iconSize: 23),
                      const SizedBox(
                        width: 13,
                      ),
                      text(
                          size: 13,
                          weight: FontWeight.w400,
                          color: tmxWhite,
                          write: "Share"),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: tmxBackground),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Home",
                        style: GoogleFonts.ubuntu(
                            fontSize: 28,
                            color: tmxWhite,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mostly Played",
                            style: GoogleFonts.ubuntu(
                              fontSize: 18,
                              color: const Color.fromARGB(255, 205, 204, 204),
                            ),
                          ),
                          GestureDetector(
                            child: Text(
                              "View All",
                              style: GoogleFonts.ubuntu(
                                fontSize: 13,
                                color: const Color.fromARGB(255, 132, 131, 131),
                              ),
                            ),
                            onTap: () {
                              goto_most(context);
                            },
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showMiniplayerBottom(
                                  context: context,
                                  index: 0,
                                  songList: mostSongsList,
                                  audioPlayer: audioPlayer,
                                );
                              },
                              child: Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color.fromARGB(104, 0, 140, 255),
                                          Color.fromARGB(255, 97, 210, 241)
                                        ]),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 48,
                                  width: 250,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 40,
                                          width: 60,
                                          child: QueryArtworkWidget(
                                            id: int.parse(mostSongsList[0].id),
                                            artworkHeight: 250,
                                            artworkWidth: 250,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(4.0),
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Image.asset(
                                                "asset/images/idfc.jpg",
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mostSongsList[0].songname,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 13,
                                                  color: tmxBlack),
                                            ),
                                            Text(
                                              mostSongsList[0].artist,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 11,
                                                  color: homeRecentArtistC),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showMiniplayerBottom(
                                  context: context,
                                  index: 1,
                                  songList: mostSongsList,
                                  audioPlayer: audioPlayer,
                                );
                              },
                              child: Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color.fromARGB(92, 5, 255, 1),
                                          Color.fromARGB(255, 70, 255, 98)
                                        ]),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 48,
                                  width: 250,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 40,
                                          width: 60,
                                          child: QueryArtworkWidget(
                                            id: int.parse(mostSongsList[1].id),
                                            artworkHeight: 250,
                                            artworkWidth: 250,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(4.0),
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Image.asset(
                                                "asset/images/idfc.jpg",
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mostSongsList[1].songname,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 13,
                                                  color: tmxBlack),
                                            ),
                                            Text(
                                              mostSongsList[1].artist,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 11,
                                                  color: homeRecentArtistC),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showMiniplayerBottom(
                                  context: context,
                                  index: 2,
                                  songList: mostSongsList,
                                  audioPlayer: audioPlayer,
                                );
                              },
                              child: Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Color.fromARGB(104, 247, 43, 43),
                                          Color.fromARGB(255, 235, 87, 87)
                                        ]),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 48,
                                  width: 250,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          decoration: const BoxDecoration(),
                                          height: 40,
                                          width: 60,
                                          child: QueryArtworkWidget(
                                            id: int.parse(mostSongsList[2].id),
                                            artworkHeight: 250,
                                            artworkWidth: 250,
                                            artworkFit: BoxFit.cover,
                                            artworkBorder:
                                                BorderRadius.circular(4.0),
                                            type: ArtworkType.AUDIO,
                                            nullArtworkWidget: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Image.asset(
                                                "asset/images/idfc.jpg",
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              mostSongsList[2].songname,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 13,
                                                  color: tmxBlack),
                                            ),
                                            Text(
                                              mostSongsList[2].artist,
                                              style: GoogleFonts.ubuntu(
                                                  fontSize: 11,
                                                  color: homeRecentArtistC),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      text(
                          size: 18,
                          weight: FontWeight.w500,
                          color: tmxWhite,
                          write: "All Songs"),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return SongTile(
                    songList: songList,
                    index: index,
                    audioPlayer: audioPlayer,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
