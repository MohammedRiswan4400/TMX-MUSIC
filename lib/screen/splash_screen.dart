import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/db_functions/db_functions.dart';
import '../model/tmx_plater.dart';
import 'navigation_screen.dart';

// ignore: camel_case_types
class Spalash_screen extends StatefulWidget {
  const Spalash_screen({super.key});

  @override
  State<Spalash_screen> createState() => _Spalash_screenState();
}

// ignore: camel_case_types
class _Spalash_screenState extends State<Spalash_screen> {
  OnAudioQuery audioQuery = OnAudioQuery();

  Box<Songs> songBox = getSongBox();
  Box<List> playlistBox = getPlaylitBox();

  List<SongModel> deviceSongs = [];
  List<SongModel> fetchedSongs = [];

  @override
  void initState() {
    fetchSongs();
    super.initState();
  }

  Future fetchSongs() async {
    await Permission.storage.request();
    deviceSongs = await audioQuery.querySongs(
      sortType: null,
      // SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );

    for (var song in deviceSongs) {
      if (song.fileExtension == 'mp3') {
        fetchedSongs.add(song);
      }
    }

    for (var audio in fetchedSongs) {
      final song = Songs(
        id: audio.id.toString(),
        songname: audio.displayNameWOExt,
        artist: audio.artist!,
        uri: audio.uri!,
      );
      await songBox.put(song.id, song);
      // log("message");
    }

    if (!playlistBox.keys.contains('Favourites')) {
      await playlistBox.put('Favourites', []);
    }

    if (!playlistBox.keys.contains('Most Played')) {
      await playlistBox.put('Most Played', []);
    }

    if (!playlistBox.keys.contains('Recent')) {
      await playlistBox.put('Recent', []);
    }

    await gotoHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "asset/images/IMG_8227.PNG",
          height: 100,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 21, 55, 77),
    );
  }

  Future<void> gotoHome() async {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (ctx) => const NavigationScreen(),
    ));
  }
}
