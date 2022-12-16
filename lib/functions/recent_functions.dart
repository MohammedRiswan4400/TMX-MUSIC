import 'dart:developer';
import 'package:hive_flutter/adapters.dart';
import '../model/db_functions/db_functions.dart';
import '../model/tmx_plater.dart';
import 'most_function.dart';

class Recents {
  static final Box<Songs> songBox = getSongBox();
  static final Box<List> playlistBox = getPlaylitBox();

  static addSongsToRecents({required String songId}) async {
    final List<Songs> dbSongs = songBox.values.toList().cast<Songs>();
    final List<Songs> recentSongList =
        playlistBox.get('Recent')!.toList().cast<Songs>();

    final Songs recentSong =
        dbSongs.firstWhere((song) => song.id.contains(songId));
    int count = recentSong.count;
    recentSong.count = count + 1;
    MostPlayed.addSongToPlaylist(songId);
    log("${recentSong.count} Recent song Count");

    if (recentSongList.length >= 10) {
      recentSongList.removeLast();
    }
    if (recentSongList.where((song) => song.id == recentSong.id).isEmpty) {
      await playlistBox.put('Recent', recentSongList);
    } else {
      recentSongList.removeWhere((song) => song.id == recentSong.id);
      recentSongList.insert(0, recentSong);
      await playlistBox.put('Recent', recentSongList);
    }
  }
}
