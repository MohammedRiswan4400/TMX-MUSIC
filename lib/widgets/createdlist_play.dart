import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmx_player/functions/alert_function.dart';
import 'package:tmx_player/screen/created_playlist.dart';
import 'package:tmx_player/widgets/colors.dart';

class CreatedPlaylist extends StatelessWidget {
  const CreatedPlaylist({
    Key? key,
    required this.playlistImage,
    required this.playlistName,
    required this.playlistSongNum,
  }) : super(key: key);
  final String playlistImage;
  final String playlistName;
  final String playlistSongNum;

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
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ScreenCreatedPlaylist(
              playlistName: playlistName,
            ),
          ),
        );
      },
      onLongPress: () {
        showPlaylistDeleteAlert(context: context, key: playlistName);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              playlistImage,
              fit: BoxFit.cover,
              // height: 137,
              height: screenHeight * 0.21,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                    size: 15,
                    weight: FontWeight.w600,
                    color: tmxWhite,
                    write: playlistName),
                Text(
                  playlistSongNum,
                  style: const TextStyle(
                    color: emptyColors,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
