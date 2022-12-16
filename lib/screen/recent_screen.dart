import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tmx_player/widgets/colors.dart';

class Recents extends StatelessWidget {
  const Recents({super.key});
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

  Widget songone({
    required String image,
    required String songname,
    required String artist,
  }) {
    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          color: tmxTransparent,
        ),
        height: 60,
        width: double.infinity,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                    decoration: const BoxDecoration(),
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      child: Image.asset(
                        image,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              const SizedBox(
                width: 6,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songname,
                    style: GoogleFonts.ubuntu(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                  ),
                  Text(
                    artist,
                    style: GoogleFonts.ubuntu(
                        fontSize: 13,
                        color: const Color.fromARGB(191, 255, 255, 255)),
                  )
                ],
              )
            ],
          ),
          const Icon(
            Icons.more_vert_rounded,
            color: menuIconColor,
          )
        ],
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                        size: 28,
                        weight: FontWeight.w500,
                        color: tmxWhite,
                        write: "Recent"),
                    maincons(
                        icon: Icons.clear_all_rounded,
                        iconColor: tmxWhite,
                        iconSize: 30)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                songone(
                    image: "asset/images/love.jpg",
                    songname: "Love nwantiti",
                    artist: "Ckey"),
                songone(
                    image: "asset/images/idfc.jpg",
                    songname: "idfc",
                    artist: "blackbear"),
                songone(
                    image: "asset/images/jupiter mazha.jpg",
                    songname: "Jupiter Mazha",
                    artist: "Dganvin KB, Apoorva Sandhya"),
              ],
            ),
          ]),
        )),
      ),
    );
  }
}
