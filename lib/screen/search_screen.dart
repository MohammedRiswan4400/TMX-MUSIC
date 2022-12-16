import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tmx_player/screen/playlist_screen.dart';
import 'package:tmx_player/widgets/colors.dart';
import '../model/db_functions/db_functions.dart';
import '../model/tmx_plater.dart';
import '../widgets/song_tile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  Box<Songs> songBox = getSongBox();
  List<Songs> songList = [];
  List<Songs>? dbSongs;
  List<Songs>? searchedSongs;

  @override
  void initState() {
    super.initState();
    dbSongs = songBox.values.toList().cast<Songs>();
    songList = songBox.values.toList().cast<Songs>();
    searchedSongs = List<Songs>.from(dbSongs!).toList().cast<Songs>();
  }

  searchSongfomDb(String searchSong) {
    setState(() {
      searchedSongs = dbSongs!
          .where((song) =>
              song.songname.toLowerCase().contains(searchSong.toLowerCase()))
          .toList();
    });
  }

  // @override
  // void initState() {
  //   songList = songBox.values.toList().cast<Songs>();
  //   super.initState();
  // }

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
      decoration: const BoxDecoration(gradient: tmxBackground),
      child: Scaffold(
        backgroundColor: tmxTransparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                        size: 28,
                        weight: FontWeight.w500,
                        color: tmxWhite,
                        write: "Search"),
                    GestureDetector(
                      child: maincons(
                          icon: Icons.timelapse_rounded,
                          iconColor: tmxWhite,
                          iconSize: 28),
                      onTap: () {
                        goto_recent(context);
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    searchSongfomDb(value);
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: emptyColors,
                      size: 30,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: emptyColors,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: emptyColors,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    filled: true,
                    fillColor: tmxWhite,
                    hintText: "Search Songs...",
                    hintStyle: TextStyle(
                        color: emptyColors,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchedSongs!.length,
                  itemBuilder: (context, index) {
                    return SongTile(
                      songList: searchedSongs!,
                      index: index,
                      audioPlayer: audioPlayer,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
