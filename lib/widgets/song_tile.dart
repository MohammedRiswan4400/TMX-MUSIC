import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../common/functions.dart';
import '../functions/alert_function.dart';
import '../functions/fav_function.dart';
import '../model/tmx_plater.dart';

class SongTile extends StatefulWidget {
  final List<Songs> songList;
  final int index;
  final AssetsAudioPlayer audioPlayer;
  final IconData icon;
  const SongTile({
    super.key,
    this.icon = Icons.playlist_add,
    required this.songList,
    required this.index,
    required this.audioPlayer,
  });

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  List<Audio> songAudioList = [];

  @override
  Widget build(BuildContext context) {
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

    Widget buildSheet({required Songs song}) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.colorBurn,
                  color: const Color.fromARGB(233, 0, 0, 0),
                  borderRadius: BorderRadius.circular(20)),
              height: double.infinity,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Center(
                    child: QueryArtworkWidget(
                      artworkBorder: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      artworkHeight: 140,
                      artworkWidth: 140,
                      artworkFit: BoxFit.cover,
                      id: int.parse(song.id),
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
                    write: widget.songList[widget.index].songname),
                text(
                  size: 14,
                  weight: FontWeight.w400,
                  color: const Color.fromARGB(255, 190, 188, 188),
                  write: widget.songList[widget.index].artist,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Favourites.isThisFavourite(
                                id: widget.songList[widget.index].id,
                              ),
                              size: 30,
                              color: tmxWhite,
                            ),
                            onPressed: () {
                              Favourites.addSongToFavourites(
                                context: context,
                                id: widget.songList[widget.index].id,
                              );
                              setState(() {
                                Favourites.isThisFavourite(
                                  id: widget.songList[widget.index].id,
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
                              write: 'Favorites'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            showPlaylistModalSheet(
                              context: context,
                              screenHeight: 500,
                              song: song,
                            );
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
                      )
                    ],
                  ),
                )
              ],
            ),
          ]),
        );
      });
    }

    return ListTile(
      horizontalTitleGap: 10,
      onTap: () {
        showMiniplayerBottom(
          context: context,
          index: widget.index,
          songList: widget.songList,
          audioPlayer: widget.audioPlayer,
        );
      },
      leading: QueryArtworkWidget(
        artworkBorder: BorderRadius.zero,
        artworkFit: BoxFit.cover,
        artworkHeight: 50,
        artworkWidth: 50,
        id: int.parse(widget.songList[widget.index].id),
        type: ArtworkType.AUDIO,
        nullArtworkWidget: Image.asset(
          "asset/images/idfc.jpg",
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      trailing: InkWell(
        child: const Icon(
          Icons.more_vert_rounded,
          color: Color.fromARGB(237, 82, 81, 81),
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) =>
                  buildSheet(song: widget.songList[widget.index]),
              barrierColor: const Color.fromARGB(40, 0, 0, 0),
              backgroundColor: tmxTransparent);
        },
      ),
      title: Text(
        widget.songList[widget.index].songname,
        style: GoogleFonts.ubuntu(fontSize: 14, color: tmxWhite),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        widget.songList[widget.index].artist,
        style: GoogleFonts.ubuntu(
            fontSize: 13, color: const Color.fromARGB(191, 255, 255, 255)),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
