import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmx_player/model/db_functions/db_functions.dart';
import 'package:tmx_player/screen/playlist/fav.dart';
import 'package:tmx_player/widgets/colors.dart';
import 'package:tmx_player/widgets/createdlist_play.dart';
import '../functions/alert_function.dart';
import '../model/tmx_plater.dart';

class PlaylistScreen extends StatelessWidget {
  static final Box<List> playlistBox = getPlaylitBox();
  static final Box<Songs> songBox = getSongBox();

  const PlaylistScreen({super.key});
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

  Widget containerone({
    required Color boxcolor,
    required IconData playlisticons,
    required String playlistName,
    required Color iconcolor,
  }) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(color: boxcolor),
        height: 150,
        width: 150,
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                playlistName,
                style: GoogleFonts.ubuntu(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: exploreInnerC,
              ),
              height: 104,
              width: 142,
              child: Icon(
                playlisticons,
                color: iconcolor,
                size: 40,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Widget container({
    required Color boxcolor,
    required Color iconcolor,
    required String playlistName,
    required Color innerboxcolor,
    required IconData playlisticons,
  }) {
    return Stack(children: [
      Container(
        decoration: BoxDecoration(color: boxcolor),
        height: 150,
        width: 150,
      ),
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(color: exploreInnerC),
              height: 104,
              width: 142,
              child: Icon(
                playlisticons,
                color: iconcolor,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                playlistName,
                style: GoogleFonts.ubuntu(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      )
    ]);
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
            child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Explore",
                  style: GoogleFonts.ubuntu(
                      fontSize: 28,
                      color: tmxWhite,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: container(
                            boxcolor: createPlyColor,
                            iconcolor: createPlyColor,
                            playlistName: "Create\nPlaylist",
                            playlisticons: Icons.add_rounded,
                            innerboxcolor: tmxBlack),
                        onTap: () {
                          showCreatingPlaylistDialoge(context: context);
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: containerone(
                            boxcolor: favPlyColor,
                            playlisticons: Icons.favorite,
                            playlistName: "Favorite\nSongs",
                            iconcolor: favPlyColor),
                        onTap: () {
                          goto_fav(context);
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: container(
                            boxcolor: mostPlyColor,
                            iconcolor: mostPlyColor,
                            playlistName: "Most\nPlayed",
                            playlisticons: Icons.access_time_rounded,
                            innerboxcolor: tmxBlack),
                        onTap: () {
                          goto_most(context);
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        child: containerone(
                            boxcolor: recentPlyColor,
                            playlisticons: Icons.timelapse_rounded,
                            playlistName: "Recently\nPlayed",
                            iconcolor: recentPlyColor),
                        onTap: () {
                          goto_recent(context);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                        size: 16,
                        weight: FontWeight.w500,
                        color: tmxWhite,
                        write: "Created Playlist"),
                    const SizedBox(
                      height: 40,
                    ),
                    ValueListenableBuilder(
                      valueListenable: playlistBox.listenable(),
                      builder: (context, value, child) {
                        List keys = playlistBox.keys.toList();
                        keys.removeWhere((key) => key == 'Favourites');
                        keys.removeWhere((key) => key == 'Recent');
                        keys.removeWhere((key) => key == 'Most Played');
                        return (keys.isEmpty)
                            ? Center(
                                child: text(
                                  color: emptyColors,
                                  weight: FontWeight.w400,
                                  write: 'No Created Playlist...',
                                  size: 12,
                                ),
                              )
                            : GridView.builder(
                                itemCount: keys.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  childAspectRatio: 1.25,
                                ),
                                itemBuilder: (context, index) {
                                  final String playlistName = keys[index];

                                  final List<Songs> songList = playlistBox
                                      .get(playlistName)!
                                      .toList()
                                      .cast<Songs>();

                                  final int songListlength = songList.length;

                                  return CreatedPlaylist(
                                    playlistImage:
                                        'asset/images/WhatsApp Image 2022-12-07 at 18.45.16.jpg',
                                    playlistName: playlistName,
                                    playlistSongNum: '$songListlength Songs',
                                  );
                                },
                              );
                      },
                    ),
                  ],
                )
              ],
            ),
          ]),
        )),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
void goto_fav(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) {
        return Fav(
          playlistName: 'Favourites',
        );
      }),
    ),
  );
}

// ignore: non_constant_identifier_names
void goto_most(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) {
        return Fav(playlistName: 'Most Played');
      }),
    ),
  );
}

// ignore: non_constant_identifier_names
void goto_recent(context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: ((context) {
        return Fav(playlistName: "Recent");
      }),
    ),
  );
}
