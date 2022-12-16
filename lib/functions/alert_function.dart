import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../model/db_functions/db_functions.dart';
import '../model/tmx_plater.dart';
import '../widgets/mini_player.dart';
import '../widgets/search.dart';
import 'create_playlist.dart';

showMiniPlayer({
  required BuildContext context,
  required int index,
  required List<Songs> songList,
  required AssetsAudioPlayer audioPlayer,
}) {
  return showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return MiniPlayer(
          songList: songList,
          index: index,
          audioPlayer: audioPlayer,
        );
      });
}

showPlaylistModalSheet({
  required BuildContext context,
  required double screenHeight,
  required Songs song,
}) {
  Box<List> playlistBox = getPlaylitBox();
  return showModalBottomSheet(
      backgroundColor: tmxBlack,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Container(
            decoration: BoxDecoration(
              // color: Color.fromARGB(255, 77, 255, 0),
              gradient: showPlaylist,
              borderRadius: BorderRadius.circular(30),
            ),
            height: screenHeight * 0.55,
            child: Column(
              children: [
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    showCreatingPlaylistDialoge(context: ctx);
                  },
                  icon: const Icon(
                    Icons.playlist_add,
                    color: tmxYellow,
                  ),
                  label: const Text(
                    'Create Playlist',
                    style: TextStyle(color: tmxYellow),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: tmxBlack,
                    shape: const StadiumBorder(),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: playlistBox.listenable(),
                    builder: (context, boxSongList, _) {
                      final List<dynamic> keys = playlistBox.keys.toList();

                      keys.removeWhere((key) => key == 'Favourites');
                      keys.removeWhere((key) => key == 'Recent');
                      keys.removeWhere((key) => key == 'Most Played');

                      return Expanded(
                        child: (keys.isEmpty)
                            ? const Center(
                                child: Text("No Playlist Found"),
                              )
                            : ListView.builder(
                                itemCount: keys.length,
                                itemBuilder: (ctx, index) {
                                  final String playlistKey = keys[index];

                                  return Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      onTap: () async {
                                        UserPlaylist.addSongToPlaylist(
                                            context: context,
                                            songId: song.id,
                                            playlistName: playlistKey);
                                        Navigator.pop(context);
                                      },
                                      leading: const Text(
                                        '🎧',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      title: Text(playlistKey),
                                    ),
                                  );
                                },
                              ),
                      );
                    })
              ],
            ),
          ),
        );
      });
}

showCreatingPlaylistDialoge({required BuildContext context}) {
  TextEditingController textEditingController = TextEditingController();
  Box<List> playlistBox = getPlaylitBox();

  Future<void> createNewplaylist() async {
    List<Songs> songList = [];
    final String playlistName = textEditingController.text.trim();
    if (playlistName.isEmpty) {
      return;
    }
    await playlistBox.put(playlistName, songList);
  }

  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final formKey = GlobalKey<FormState>();
        return Form(
          key: formKey,
          child: AlertDialog(
            backgroundColor: alertButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Create playlist',
              style: TextStyle(
                  color: tmxYellow, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            content: SearchField(
              textController: textEditingController,
              hintText: 'Playlist Name',
              icon: Icons.playlist_add,
              validator: (value) {
                final keys = getPlaylitBox().keys.toList();
                if (value == null || value.isEmpty) {
                  return 'Field is empty';
                }
                if (keys.contains(value)) {
                  return '$value Already exist in playlist';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: tmxYellow, fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await createNewplaylist();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(ctx);
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: tmxYellow, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      });
}

showPlaylistDeleteAlert({required BuildContext context, required String key}) {
  final playlistBox = getPlaylitBox();
  return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: alertButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Playlist ?',
            style: TextStyle(color: tmxYellow),
          ),
          content: const Text(
            'Do you want to delete this Playlist',
            style: TextStyle(color: tmxYellow),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: tmxYellow,
                  fontSize: 15,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await playlistBox.delete(key);
                // ignore: use_build_context_synchronously
                Navigator.pop(ctx);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: tmxYellow,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      });
}

showSongModalSheet({
  required BuildContext context,
  required double screenHeight,
  required String playlistKey,
}) {
  return showModalBottomSheet(
    backgroundColor: tmxTransparent,
    context: context,
    builder: (ctx) {
      final songBox = getSongBox();
      return Container(
        decoration: BoxDecoration(
          color: tmxBlack,
          borderRadius: BorderRadius.circular(30),
        ),
        height: screenHeight * 0.55,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Add Songs',
              style: TextStyle(
                color: tmxWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder:
                    (BuildContext context, Box<Songs> boxSongs, Widget? child) {
                  return ListView.builder(
                    itemCount: boxSongs.values.length,
                    itemBuilder: (BuildContext ctx, int index) {
                      final List<Songs> songsList = boxSongs.values.toList();
                      final Songs song = songsList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          onTap: () {
                            UserPlaylist.addSongToPlaylist(
                              context: context,
                              songId: song.id,
                              playlistName: playlistKey,
                            );

                            Navigator.pop(context);
                          },
                          leading: QueryArtworkWidget(
                            id: int.parse(song.id),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(10),
                            nullArtworkWidget: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'asset/images/IMG_8705.JPG',
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          title: Text(
                            song.songname,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: tmxWhite),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

showAboutDailoge(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: playlistColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    title: Center(
      child: Text(
        "About me",
        style: GoogleFonts.ubuntu(
            fontSize: 18, fontWeight: FontWeight.w500, color: tmxWhite),
      ),
    ),
    content: Text(
      "This App is designed and developped\nby Mohammed Riswan",
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(
          fontSize: 13, fontWeight: FontWeight.w500, color: tmxWhite),
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
