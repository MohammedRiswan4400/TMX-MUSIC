import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmx_player/model/db_functions/db_functions.dart';
import 'package:tmx_player/model/tmx_plater.dart';
import 'package:tmx_player/widgets/colors.dart';
import 'package:tmx_player/widgets/song_tile.dart';

import '../functions/alert_function.dart';
import '../functions/create_playlist.dart';
import '../widgets/search.dart';

class ScreenCreatedPlaylist extends StatefulWidget {
  const ScreenCreatedPlaylist({super.key, required this.playlistName});
  final String playlistName;

  @override
  State<ScreenCreatedPlaylist> createState() => _ScreenCreatedPlaylistState();
}

class _ScreenCreatedPlaylistState extends State<ScreenCreatedPlaylist> {
  String? newPlaylistName;
  @override
  void initState() {
    newPlaylistName = widget.playlistName;
    super.initState();
  }

  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylitBox();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: playlistColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: playlistColor,
        elevation: 0,
        title: Text(
          newPlaylistName!,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              final List<Songs> playlistSongs =
                  playlistBox.get(newPlaylistName)!.toList().cast<Songs>();
              showEditingPlaylistDialoge(
                context: context,
                playlistName: newPlaylistName!,
                playlistSongs: playlistSongs,
              );
            },
            icon: const Icon(
              Icons.mode_edit_outline_rounded,
              color: tmxWhite,
            ),
          ),
          IconButton(
            onPressed: () {
              showSongModalSheet(
                context: context,
                screenHeight: screenHeight,
                playlistKey: newPlaylistName!,
              );
            },
            icon: const Icon(
              Icons.add,
              size: 27,
              color: tmxWhite,
            ),
          )
        ],
      ),
      body: ValueListenableBuilder<Box<List<dynamic>>>(
        valueListenable: playlistBox.listenable(),
        builder: (context, boxSongList, _) {
          final List<Songs> songList =
              boxSongList.get(newPlaylistName)!.cast<Songs>();

          if (songList.isEmpty) {
            return const Center(
              child: Text(
                'No Songs Found',
                style: TextStyle(color: emptyColors),
              ),
            );
          }
          return ListView.builder(
            itemCount: songList.length,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                child: SongTile(
                    icon: Icons.delete_outline_rounded,
                    songList: songList,
                    index: index,
                    audioPlayer: audioPlayer),
                onLongPress: () {
                  UserPlaylist.deleteFromPlaylist(
                    context: context,
                    songId: songList[index].id,
                    playlistName: newPlaylistName!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  showEditingPlaylistDialoge({
    required BuildContext context,
    required String playlistName,
    required List<Songs> playlistSongs,
  }) {
    final TextEditingController textController =
        TextEditingController(text: playlistName);
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          final formKey = GlobalKey<FormState>();
          return Form(
            key: formKey,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: tmxBlack,
              title: const Text(
                'Edit playlist',
                style: TextStyle(
                  color: tmxWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SearchField(
                textController: textController,
                hintText: 'Playlist Name',
                icon: Icons.playlist_add,
                validator: (value) {
                  final keys = getPlaylitBox().keys.toList();
                  if (value == null || value.isEmpty) {
                    return 'Field is empty';
                  }
                  if (keys.contains(value)) {
                    return '$value already exist in playlist';
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
                    style: TextStyle(color: tmxWhite, fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final playlistBox = getPlaylitBox();
                      setState(() {
                        newPlaylistName = textController.text.trim();
                      });
                      await playlistBox.put(newPlaylistName, playlistSongs);
                      playlistBox.delete(playlistName);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: tmxWhite, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
